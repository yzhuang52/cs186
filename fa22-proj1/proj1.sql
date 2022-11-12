-- Before running drop any existing views
DROP VIEW IF EXISTS q0;
DROP VIEW IF EXISTS q1i;
DROP VIEW IF EXISTS q1ii;
DROP VIEW IF EXISTS q1iii;
DROP VIEW IF EXISTS q1iv;
DROP VIEW IF EXISTS q2i;
DROP VIEW IF EXISTS q2ii;
DROP VIEW IF EXISTS q2iii;
DROP VIEW IF EXISTS q3i;
DROP VIEW IF EXISTS q3ii;
DROP VIEW IF EXISTS q3iii;
DROP VIEW IF EXISTS q4i;
DROP VIEW IF EXISTS q4ii;
DROP VIEW IF EXISTS q4iii;
DROP VIEW IF EXISTS q4iv;
DROP VIEW IF EXISTS q4v;
DROP VIEW IF EXISTS lslg;
-- Question 0
CREATE VIEW q0(era)
AS
  SELECT MAX(era)
  FROM pitching
;

-- Question 1i
CREATE VIEW q1i(namefirst, namelast, birthyear)
AS
  SELECT namefirst, namelast, birthyear
  FROM people
  WHERE weight>300
;

-- Question 1ii
CREATE VIEW q1ii(namefirst, namelast, birthyear)
AS
  SELECT namefirst, namelast, birthyear
  FROM people
  WHERE namefirst LIKE '% %'
  ORDER BY namefirst ASC, namelast
;

-- Question 1iii
CREATE VIEW q1iii(birthyear, avgheight, count)
AS
  SELECT birthyear, AVG(height), COUNT(*) as count
  FROM people
  GROUP BY birthyear
  ORDER BY birthyear ASC

;

-- Question 1iv
CREATE VIEW q1iv(birthyear, avgheight, count)
AS
  SELECT birthyear, AVG(height), COUNT(*) as count
  FROM people
  GROUP BY birthyear
  HAVING(AVG(height)>70)
  ORDER BY birthyear ASC
;

-- Question 2i
CREATE VIEW q2i(namefirst, namelast, playerid, yearid)
AS

  SELECT people.namefirst, people.namelast, people.playerid, HallofFame.yearid
  FROM people
  INNER JOIN HallofFame
  ON people.playerid=HallofFame.playerid
  WHERE HallofFame.inducted = 'Y'
  ORDER BY HallofFame.yearid DESC, people.playerid ASC
;

-- Question 2ii
CREATE VIEW q2ii(namefirst, namelast, playerid, schoolid, yearid)
AS
  SELECT people.namefirst, people.namelast, people.playerid, collegePlaying.schoolID, HallofFame.yearid
  FROM people
  INNER JOIN HallofFame
  ON people.playerid=HallofFame.playerid
  INNER JOIN CollegePlaying
  ON people.playerid=CollegePlaying.playerid
  INNER JOIN Schools
  ON CollegePlaying.schoolID=Schools.schoolID
  WHERE HallofFame.inducted = 'Y' and Schools.schoolState = 'CA'
  ORDER BY HallofFame.yearid DESC, collegePlaying.schoolID , people.playerid ASC
;

-- Question 2iii
CREATE VIEW q2iii(playerid, namefirst, namelast, schoolid)
AS
  SELECT people.playerid,people.namefirst, people.namelast,  collegePlaying.schoolID
  FROM people
  INNER JOIN HallofFame
  ON people.playerid=HallofFame.playerid
  LEFT JOIN collegePlaying
  ON people.playerid=collegePlaying.playerid
  WHERE HallofFame.inducted = 'Y'
  ORDER BY people.playerid DESC, collegePlaying.schoolID ASC
;

-- Question 3i
CREATE VIEW q3i(playerid, namefirst, namelast, yearid, slg)
AS
  SELECT p.playerid, p.namefirst, p.namelast, b.yearID, ((b.H-b.H2B-b.H3B-b.HR)+2*b.H2B+3*b.H3B+4*b.HR+0.0)/b.AB as slg
  FROM people as p
  INNER JOIN batting as b
  ON p.playerid=b.playerID
  WHERE b.AB > 50
  ORDER BY slg DESC, b.yearid, p.playerid ASC
  LIMIT 10
;

CREATE VIEW lslg(playerid, lslgval)
AS
  SELECT playerid, ((SUM(H)-SUM(H2B)-SUM(H3B)-SUM(HR))+SUM(2*H2B)+SUM(3*H3B)+SUM(4*HR)+0.0)/(SUM(AB)+0.0)
  FROM batting
  GROUP BY playerid
  HAVING SUM(AB)>50
;

-- Question 3ii
CREATE VIEW q3ii(playerid, namefirst, namelast, lslg)
AS
  SELECT p.playerID, p.namefirst, p.namelast, l.lslgval
  FROM people as p
  INNER JOIN lslg l
  ON l.playerid = p.playerid
  ORDER BY l.lslgval DESC , p.playerid
  LIMIT 10
;

-- Question 3iii
CREATE VIEW q3iii(namefirst, namelast, lslg)
AS
  SELECT p.namefirst, p.namelast, l.lslgval
  FROM people as p
  INNER JOIN lslg as l
  ON l.playerid = p.playerid
  WHERE l.lslgval > (
      SELECT lslgval
      FROM lslg
      WHERE playerid = 'mayswi01'
      )
;

-- Question 4i
CREATE VIEW q4i(yearid, min, max, avg)
AS
  SELECT yearID, MIN(salary), MAX(salary), AVG(salary)
  FROM salaries
  GROUP BY yearID
  ORDER BY yearID
;

-- Question 4ii
CREATE VIEW q4ii(binid, low, high, count)
AS
  SELECT b.*, MIN(s.salary), MAX(s.salary), COUNT(*)
  FROM binids as b, salaries as s
  WHERE s.yearID = '2016'
;

-- Question 4iii
CREATE VIEW q4iii(yearid, mindiff, maxdiff, avgdiff)
AS
  SELECT 1, 1, 1, 1 -- replace this line
;

-- Question 4iv
CREATE VIEW q4iv(playerid, namefirst, namelast, salary, yearid)
AS
  SELECT 1, 1, 1, 1, 1 -- replace this line
;
-- Question 4v
CREATE VIEW q4v(team, diffAvg) AS
  SELECT a.teamID, MAX(s.salary)-MIN(s.salary)
  FROM allstarfull as a
  INNER JOIN salaries as s
  ON a.playerID = s.playerID AND a.yearID = s.yearID
  WHERE a.yearID = 2016
  GROUP BY a.teamID
;


<%@page import="Classes.EncriptedFormat"%>
<%@page import="javax.swing.JOptionPane"%>
<%@page import="Classes.SqliteConnectionThread"%>
<%@page import="Classes.UserGuiDB"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="Classes.User"%>
<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="shortcut icon" type="image/x-icon" href="images/icon.jpg" />


<% 

String userid=request.getParameter("userid");
String student=request.getParameter("student");

SqliteConnectionThread sqlthrd=new SqliteConnectionThread();
sqlthrd.start();
try 
{
	
	sqlthrd.join();
} catch (InterruptedException e) 
{
	e.printStackTrace();
}
Connection connection =sqlthrd.getConn();



Statement st=connection.createStatement();
int msgCount=st.executeQuery("select count(msg) from "+userid+"Messages where boxType='inbox' and status='unread'").getInt(1);


ResultSet rs=UserGuiDB.getUserFromDB(connection,student.toLowerCase());
%>

<title>View Student info</title>

<style>
#image {
    float: left;
    border: 1px solid black;
    max-width: 180px;
   box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);
 
}

#info {
  float:center;
   margin-left: 450px;
    padding: 1em;
    overflow: hidden;
}
</style>

</head>
<body>
<h1 style=" color:#b70a01;"> &nbsp;&nbsp;S University<sub> admin </sub></h1>
<div  style="padding-left:80px; padding-right:80px;">
<form  method="post" action="HomeLogin"><h3 style=" color:#378fa1;text-align: right;">Hello &nbsp;&nbsp;<%= userid%>  
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;<a href="Messages.jsp?userid=<%=userid%>">Messages<%out.print(" ( "+ msgCount+" )"); %></a>
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;<a href="HomeLogin.jsp">Logout</a></h3></form>  


<form method="post" action="HomeLogin" >
<h3 style=" color:#b70a01; text-align: right"> 
<span><a href="Admin.jsp?userid=<%= userid%>">Admin Home</a></span>&nbsp;&nbsp;|&nbsp;&nbsp;
<span><a href="AccountSettings.jsp?userid=<%= userid%>">Account Setting</a></span>&nbsp;&nbsp;|&nbsp;&nbsp;
<span><a href="ApplicantsList.jsp?userid=<%= userid%>">Applicant List</a></span>&nbsp;&nbsp;|&nbsp;&nbsp;
<span><a href="StudentsList.jsp?userid=<%= userid%>">Student List</a></span>&nbsp;&nbsp;|&nbsp;&nbsp;
<span><a href="FacultyList.jsp?userid=<%= userid%>">Faculty List</a></span>&nbsp;&nbsp;|&nbsp;&nbsp;
<span><a href="CourseList.jsp?userid=<%= userid%>">Course List</a></span>&nbsp;&nbsp;|&nbsp;&nbsp;
<span><a href="DepartmentList.jsp?userid=<%= userid%>">Department List</a></span>&nbsp;&nbsp;|&nbsp;&nbsp;
<span><a href="UniversityPaymentsList.jsp?userid=<%= userid%>">Financial Issues</a></span> </h3>
</form>
</div>
${error}${notification}
<br>

<div style="
    padding-left:80px;
    padding-right:80px;">
<fieldset>
<legend><h3> Student info</h3></legend>
<br>


<nav id="image">

<form action="changePic" method="post">
<%
String fileName="G:\\Masters\\Java\\Java Mars\\S_University\\WebContent\\images\\"+student+".jpg";
File f=null;
f=new File(fileName);
if(f.exists())
{
	fileName="images/"+student+".jpg";
}
else
{
	fileName="images/user.png";
}


String action="";
if(rs.getString("status").equalsIgnoreCase("active"))
{
	action="Block";
}
else
	action="Active";
%>

<img src=<%=fileName%> alt="<%=student %>" title=<%=student %> style="width:100px;height:130px;">

</form>
</nav>

<nav id="info">
<form action="ChangeStatus" method="post">
<input type="hidden" name="studentName" value=<%=rs.getString(1) %>>
<input type="hidden" name="userid" value=<%=userid %>>
 Name &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: <%=rs.getString(1) %> <br><br>

 Email&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: <%=rs.getString(10) %> <br><br>

 Phone&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: <%=rs.getString(9)%><br><br>

 Date of birth&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:<%=rs.getString(11) %> <br><br>

 Level of study &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: <%=rs.getString(12)%>
<br><br>

 Course &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: <%=rs.getString(13) %> <br><br>
 Department &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: <%=rs.getString(14) %> <br><br>


 ID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: <font style="color:#b70a01"><%=rs.getString(15) %>&nbsp;&nbsp;</font>
 <br><br>

 Status&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: <%=rs.getString("status")%><br><br>

<br>
<br>
<button style="color:white;background-color:#378fa1" type=submit name=action value=<%=action %>><%=action %></button>
</form>
</nav>
</fieldset>
</div>

<%
UserGuiDB.CreatingTablesIfNotCreated(connection, student, "student");
String sql="select * from "+student+"Academics";
ResultSet rsCourse=UserGuiDB.getStudentCourseList(connection,student,"full");
%>

<br><br>
<div style="padding-left:80px; padding-right:80px;">
<fieldset>
<legend><h3>Academic info</h3> </legend>
<br>

 <table align="center" border="1" width="100%" >
<tr style="background:#3a94a8; color:white;"><th>S.no</th><th> Course name</th><th>Course id</th><th>Department</th><th>Faculty</th><th>Grade</th><th>Action</th></tr>
<%
int i=1;
while(rsCourse.next())
{
%>
			<tr>
			<td><%=i %></td>
			<td> <font size="2" ><%=rsCourse.getString(2)%></font></td>
			<td> <font size="2" ><%=rsCourse.getString(1)%></font></td>
			<td> <font size="2" ><%=rsCourse.getString(3)%></font></td>
			<td> <font size="2" ><%=rsCourse.getString(4)%></font></td>
			<td> <font size="2" color="black"><%=rsCourse.getString(5)%></font></td>
			<td style="padding-left:20px;"> 
<form action="ClassTasks" method="post" > 
				
			<input type="hidden" name="userid" value="<%= userid%>">
			<input type="hidden" name="student" value="<%= student%>">
			<input type="hidden" name="course" value="<%=rsCourse.getString(1)%>">
			
<%
String course=rsCourse.getString(1);
String buttonStatus="";

UserGuiDB.createCourseListTable(connection, course);

int tasksInCourse=st.executeQuery("select count(*) from "+course+"Details").getInt(1);

if(tasksInCourse<=0)
{
buttonStatus="disabled";
}
%>

			 
			<button  type="submit" value="viewActivities" name="source" <%=buttonStatus %>>View Activities</button>

 </form></td>

			</tr>
<% i++; 
} 
%>

</table>
<p  align="center"> * View Button will be disabled if there is no task in course</p>

</fieldset>
</div>

<br><br>
<div style="
    padding-left:80px;
    padding-right:80px;">
<fieldset>
<legend><h3>Grading & Financial details</h3> </legend>
<br>

 CGPA &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: <font style="color:#b70a01"><%=Float.parseFloat(rs.getString(17))%></font> <br><br>

 Financial Pending &nbsp;&nbsp;&nbsp;&nbsp;: <font style="color:#b70a01"><%=rs.getFloat(18) %></font> <br><br>

 
</fieldset>
</div>
<% 
st.close();
connection.close(); 
%>

</body>
</html>
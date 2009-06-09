Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbZFIPvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbZFIPvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 11:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbZFIPvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 11:51:07 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:41772 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbZFIPvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 11:51:05 -0400
Message-ID: <4A2E84CE.30703@oracle.com>
Date: Tue, 09 Jun 2009 08:50:38 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] kernel-doc: cleanup perl script
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt007.oracle.com [141.146.116.16]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4A2E84D2.023A:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Various cleanups of scripts/kernel-doc:
- don't use **/ as an ending kernel-doc block since it's not preferred;
- typos/spellos
- add whitespace around ==, after comma, & around . operator;

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kernel-doc |  174 ++++++++++++++++++++++++++---------------------------
 1 file changed, 87 insertions(+), 87 deletions(-)

--- lnx-2630-rc8.orig/scripts/kernel-doc
+++ lnx-2630-rc8/scripts/kernel-doc
@@ -5,7 +5,7 @@ use strict;
 ## Copyright (c) 1998 Michael Zucchi, All Rights Reserved        ##
 ## Copyright (C) 2000, 1  Tim Waugh <twaugh@redhat.com>          ##
 ## Copyright (C) 2001  Simon Huggins                             ##
-## Copyright (C) 2005-2008  Randy Dunlap                         ##
+## Copyright (C) 2005-2009  Randy Dunlap                         ##
 ## 								 ##
 ## #define enhancements by Armin Kuster <akuster@mvista.com>	 ##
 ## Copyright (c) 2000 MontaVista Software, Inc.			 ##
@@ -85,7 +85,7 @@ use strict;
 #
 # /**
 #  * my_function
-#  **/
+#  */
 #
 # If the Description: header tag is omitted, then there must be a blank line
 # after the last parameter specification.
@@ -105,7 +105,7 @@ use strict;
 #  */
 # etc.
 #
-# Beside functions you can also write documentation for structs, unions,
+# Besides functions you can also write documentation for structs, unions,
 # enums and typedefs. Instead of the function name you must write the name
 # of the declaration;  the struct/union/enum/typedef must always precede
 # the name. Nesting of declarations is not supported.
@@ -223,7 +223,7 @@ sub usage {
 }
 
 # read arguments
-if ($#ARGV==-1) {
+if ($#ARGV == -1) {
     usage();
 }
 
@@ -240,12 +240,12 @@ my $man_date = ('January', 'February', '
   " " . ((localtime)[5]+1900);
 
 # Essentially these are globals
-# They probably want to be tidied up made more localised or summat.
-# CAVEAT EMPTOR!  Some of the others I localised may not want to be which
+# They probably want to be tidied up, made more localised or something.
+# CAVEAT EMPTOR!  Some of the others I localised may not want to be, which
 # could cause "use of undefined value" or other bugs.
-my ($function, %function_table,%parametertypes,$declaration_purpose);
-my ($type,$declaration_name,$return_type);
-my ($newsection,$newcontents,$prototype,$filelist, $brcount, %source_map);
+my ($function, %function_table, %parametertypes, $declaration_purpose);
+my ($type, $declaration_name, $return_type);
+my ($newsection, $newcontents, $prototype, $filelist, $brcount, %source_map);
 
 if (defined($ENV{'KBUILD_VERBOSE'})) {
 	$verbose = "$ENV{'KBUILD_VERBOSE'}";
@@ -279,10 +279,10 @@ my $doc_special = "\@\%\$\&";
 my $doc_start = '^/\*\*\s*$'; # Allow whitespace at end of comment start.
 my $doc_end = '\*/';
 my $doc_com = '\s*\*\s*';
-my $doc_decl = $doc_com.'(\w+)';
-my $doc_sect = $doc_com.'(['.$doc_special.']?[\w\s]+):(.*)';
-my $doc_content = $doc_com.'(.*)';
-my $doc_block = $doc_com.'DOC:\s*(.*)?';
+my $doc_decl = $doc_com . '(\w+)';
+my $doc_sect = $doc_com . '([' . $doc_special . ']?[\w\s]+):(.*)';
+my $doc_content = $doc_com . '(.*)';
+my $doc_block = $doc_com . 'DOC:\s*(.*)?';
 
 my %constants;
 my %parameterdescs;
@@ -485,12 +485,12 @@ sub output_enum_html(%) {
     my %args = %{$_[0]};
     my ($parameter);
     my $count;
-    print "<h2>enum ".$args{'enum'}."</h2>\n";
+    print "<h2>enum " . $args{'enum'} . "</h2>\n";
 
-    print "<b>enum ".$args{'enum'}."</b> {<br>\n";
+    print "<b>enum " . $args{'enum'} . "</b> {<br>\n";
     $count = 0;
     foreach $parameter (@{$args{'parameterlist'}}) {
-	print " <b>".$parameter."</b>";
+	print " <b>" . $parameter . "</b>";
 	if ($count != $#{$args{'parameterlist'}}) {
 	    $count++;
 	    print ",\n";
@@ -502,7 +502,7 @@ sub output_enum_html(%) {
     print "<h3>Constants</h3>\n";
     print "<dl>\n";
     foreach $parameter (@{$args{'parameterlist'}}) {
-	print "<dt><b>".$parameter."</b>\n";
+	print "<dt><b>" . $parameter . "</b>\n";
 	print "<dd>";
 	output_highlight($args{'parameterdescs'}{$parameter});
     }
@@ -516,9 +516,9 @@ sub output_typedef_html(%) {
     my %args = %{$_[0]};
     my ($parameter);
     my $count;
-    print "<h2>typedef ".$args{'typedef'}."</h2>\n";
+    print "<h2>typedef " . $args{'typedef'} . "</h2>\n";
 
-    print "<b>typedef ".$args{'typedef'}."</b>\n";
+    print "<b>typedef " . $args{'typedef'} . "</b>\n";
     output_section_html(@_);
     print "<hr>\n";
 }
@@ -528,8 +528,8 @@ sub output_struct_html(%) {
     my %args = %{$_[0]};
     my ($parameter);
 
-    print "<h2>".$args{'type'}." ".$args{'struct'}. " - " .$args{'purpose'}."</h2>\n";
-    print "<b>".$args{'type'}." ".$args{'struct'}."</b> {<br>\n";
+    print "<h2>" . $args{'type'} . " " . $args{'struct'} . " - " . $args{'purpose'} . "</h2>\n";
+    print "<b>" . $args{'type'} . " " . $args{'struct'} . "</b> {<br>\n";
     foreach $parameter (@{$args{'parameterlist'}}) {
 	if ($parameter =~ /^#/) {
 		print "$parameter<br>\n";
@@ -561,7 +561,7 @@ sub output_struct_html(%) {
 	$parameter_name =~ s/\[.*//;
 
 	($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
-	print "<dt><b>".$parameter."</b>\n";
+	print "<dt><b>" . $parameter . "</b>\n";
 	print "<dd>";
 	output_highlight($args{'parameterdescs'}{$parameter_name});
     }
@@ -576,9 +576,9 @@ sub output_function_html(%) {
     my ($parameter, $section);
     my $count;
 
-    print "<h2>" .$args{'function'}." - ".$args{'purpose'}."</h2>\n";
-    print "<i>".$args{'functiontype'}."</i>\n";
-    print "<b>".$args{'function'}."</b>\n";
+    print "<h2>" . $args{'function'} . " - " . $args{'purpose'} . "</h2>\n";
+    print "<i>" . $args{'functiontype'} . "</i>\n";
+    print "<b>" . $args{'function'} . "</b>\n";
     print "(";
     $count = 0;
     foreach $parameter (@{$args{'parameterlist'}}) {
@@ -587,7 +587,7 @@ sub output_function_html(%) {
 	    # pointer-to-function
 	    print "<i>$1</i><b>$parameter</b>) <i>($2)</i>";
 	} else {
-	    print "<i>".$type."</i> <b>".$parameter."</b>";
+	    print "<i>" . $type . "</i> <b>" . $parameter . "</b>";
 	}
 	if ($count != $#{$args{'parameterlist'}}) {
 	    $count++;
@@ -603,7 +603,7 @@ sub output_function_html(%) {
 	$parameter_name =~ s/\[.*//;
 
 	($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
-	print "<dt><b>".$parameter."</b>\n";
+	print "<dt><b>" . $parameter . "</b>\n";
 	print "<dd>";
 	output_highlight($args{'parameterdescs'}{$parameter_name});
     }
@@ -657,7 +657,7 @@ sub output_function_xml(%) {
     my $count;
     my $id;
 
-    $id = "API-".$args{'function'};
+    $id = "API-" . $args{'function'};
     $id =~ s/[^A-Za-z0-9]/-/g;
 
     print "<refentry id=\"$id\">\n";
@@ -667,12 +667,12 @@ sub output_function_xml(%) {
     print " <date>$man_date</date>\n";
     print "</refentryinfo>\n";
     print "<refmeta>\n";
-    print " <refentrytitle><phrase>".$args{'function'}."</phrase></refentrytitle>\n";
+    print " <refentrytitle><phrase>" . $args{'function'} . "</phrase></refentrytitle>\n";
     print " <manvolnum>9</manvolnum>\n";
     print " <refmiscinfo class=\"version\">" . $kernelversion . "</refmiscinfo>\n";
     print "</refmeta>\n";
     print "<refnamediv>\n";
-    print " <refname>".$args{'function'}."</refname>\n";
+    print " <refname>" . $args{'function'} . "</refname>\n";
     print " <refpurpose>\n";
     print "  ";
     output_highlight ($args{'purpose'});
@@ -682,8 +682,8 @@ sub output_function_xml(%) {
     print "<refsynopsisdiv>\n";
     print " <title>Synopsis</title>\n";
     print "  <funcsynopsis><funcprototype>\n";
-    print "   <funcdef>".$args{'functiontype'}." ";
-    print "<function>".$args{'function'}." </function></funcdef>\n";
+    print "   <funcdef>" . $args{'functiontype'} . " ";
+    print "<function>" . $args{'function'} . " </function></funcdef>\n";
 
     $count = 0;
     if ($#{$args{'parameterlist'}} >= 0) {
@@ -694,7 +694,7 @@ sub output_function_xml(%) {
 		print "   <paramdef>$1<parameter>$parameter</parameter>)\n";
 		print "     <funcparams>$2</funcparams></paramdef>\n";
 	    } else {
-		print "   <paramdef>".$type;
+		print "   <paramdef>" . $type;
 		print " <parameter>$parameter</parameter></paramdef>\n";
 	    }
 	}
@@ -734,7 +734,7 @@ sub output_struct_xml(%) {
     my ($parameter, $section);
     my $id;
 
-    $id = "API-struct-".$args{'struct'};
+    $id = "API-struct-" . $args{'struct'};
     $id =~ s/[^A-Za-z0-9]/-/g;
 
     print "<refentry id=\"$id\">\n";
@@ -744,12 +744,12 @@ sub output_struct_xml(%) {
     print " <date>$man_date</date>\n";
     print "</refentryinfo>\n";
     print "<refmeta>\n";
-    print " <refentrytitle><phrase>".$args{'type'}." ".$args{'struct'}."</phrase></refentrytitle>\n";
+    print " <refentrytitle><phrase>" . $args{'type'} . " " . $args{'struct'} . "</phrase></refentrytitle>\n";
     print " <manvolnum>9</manvolnum>\n";
     print " <refmiscinfo class=\"version\">" . $kernelversion . "</refmiscinfo>\n";
     print "</refmeta>\n";
     print "<refnamediv>\n";
-    print " <refname>".$args{'type'}." ".$args{'struct'}."</refname>\n";
+    print " <refname>" . $args{'type'} . " " . $args{'struct'} . "</refname>\n";
     print " <refpurpose>\n";
     print "  ";
     output_highlight ($args{'purpose'});
@@ -759,7 +759,7 @@ sub output_struct_xml(%) {
     print "<refsynopsisdiv>\n";
     print " <title>Synopsis</title>\n";
     print "  <programlisting>\n";
-    print $args{'type'}." ".$args{'struct'}." {\n";
+    print $args{'type'} . " " . $args{'struct'} . " {\n";
     foreach $parameter (@{$args{'parameterlist'}}) {
 	if ($parameter =~ /^#/) {
 	    print "$parameter\n";
@@ -779,7 +779,7 @@ sub output_struct_xml(%) {
 	    # bitfield
 	    print "  $1 $parameter$2;\n";
 	} else {
-	    print "  ".$type." ".$parameter.";\n";
+	    print "  " . $type . " " . $parameter . ";\n";
 	}
     }
     print "};";
@@ -824,7 +824,7 @@ sub output_enum_xml(%) {
     my $count;
     my $id;
 
-    $id = "API-enum-".$args{'enum'};
+    $id = "API-enum-" . $args{'enum'};
     $id =~ s/[^A-Za-z0-9]/-/g;
 
     print "<refentry id=\"$id\">\n";
@@ -834,12 +834,12 @@ sub output_enum_xml(%) {
     print " <date>$man_date</date>\n";
     print "</refentryinfo>\n";
     print "<refmeta>\n";
-    print " <refentrytitle><phrase>enum ".$args{'enum'}."</phrase></refentrytitle>\n";
+    print " <refentrytitle><phrase>enum " . $args{'enum'} . "</phrase></refentrytitle>\n";
     print " <manvolnum>9</manvolnum>\n";
     print " <refmiscinfo class=\"version\">" . $kernelversion . "</refmiscinfo>\n";
     print "</refmeta>\n";
     print "<refnamediv>\n";
-    print " <refname>enum ".$args{'enum'}."</refname>\n";
+    print " <refname>enum " . $args{'enum'} . "</refname>\n";
     print " <refpurpose>\n";
     print "  ";
     output_highlight ($args{'purpose'});
@@ -849,7 +849,7 @@ sub output_enum_xml(%) {
     print "<refsynopsisdiv>\n";
     print " <title>Synopsis</title>\n";
     print "  <programlisting>\n";
-    print "enum ".$args{'enum'}." {\n";
+    print "enum " . $args{'enum'} . " {\n";
     $count = 0;
     foreach $parameter (@{$args{'parameterlist'}}) {
 	print "  $parameter";
@@ -891,7 +891,7 @@ sub output_typedef_xml(%) {
     my ($parameter, $section);
     my $id;
 
-    $id = "API-typedef-".$args{'typedef'};
+    $id = "API-typedef-" . $args{'typedef'};
     $id =~ s/[^A-Za-z0-9]/-/g;
 
     print "<refentry id=\"$id\">\n";
@@ -901,11 +901,11 @@ sub output_typedef_xml(%) {
     print " <date>$man_date</date>\n";
     print "</refentryinfo>\n";
     print "<refmeta>\n";
-    print " <refentrytitle><phrase>typedef ".$args{'typedef'}."</phrase></refentrytitle>\n";
+    print " <refentrytitle><phrase>typedef " . $args{'typedef'} . "</phrase></refentrytitle>\n";
     print " <manvolnum>9</manvolnum>\n";
     print "</refmeta>\n";
     print "<refnamediv>\n";
-    print " <refname>typedef ".$args{'typedef'}."</refname>\n";
+    print " <refname>typedef " . $args{'typedef'} . "</refname>\n";
     print " <refpurpose>\n";
     print "  ";
     output_highlight ($args{'purpose'});
@@ -914,7 +914,7 @@ sub output_typedef_xml(%) {
 
     print "<refsynopsisdiv>\n";
     print " <title>Synopsis</title>\n";
-    print "  <synopsis>typedef ".$args{'typedef'}.";</synopsis>\n";
+    print "  <synopsis>typedef " . $args{'typedef'} . ";</synopsis>\n";
     print "</refsynopsisdiv>\n";
 
     output_section_xml(@_);
@@ -963,15 +963,15 @@ sub output_function_gnome {
     my $count;
     my $id;
 
-    $id = $args{'module'}."-".$args{'function'};
+    $id = $args{'module'} . "-" . $args{'function'};
     $id =~ s/[^A-Za-z0-9]/-/g;
 
     print "<sect2>\n";
-    print " <title id=\"$id\">".$args{'function'}."</title>\n";
+    print " <title id=\"$id\">" . $args{'function'} . "</title>\n";
 
     print "  <funcsynopsis>\n";
-    print "   <funcdef>".$args{'functiontype'}." ";
-    print "<function>".$args{'function'}." ";
+    print "   <funcdef>" . $args{'functiontype'} . " ";
+    print "<function>" . $args{'function'} . " ";
     print "</function></funcdef>\n";
 
     $count = 0;
@@ -983,7 +983,7 @@ sub output_function_gnome {
 		print "   <paramdef>$1 <parameter>$parameter</parameter>)\n";
 		print "     <funcparams>$2</funcparams></paramdef>\n";
 	    } else {
-		print "   <paramdef>".$type;
+		print "   <paramdef>" . $type;
 		print " <parameter>$parameter</parameter></paramdef>\n";
 	    }
 	}
@@ -1043,13 +1043,13 @@ sub output_function_man(%) {
     print ".TH \"$args{'function'}\" 9 \"$args{'function'}\" \"$man_date\" \"Kernel Hacker's Manual\" LINUX\n";
 
     print ".SH NAME\n";
-    print $args{'function'}." \\- ".$args{'purpose'}."\n";
+    print $args{'function'} . " \\- " . $args{'purpose'} . "\n";
 
     print ".SH SYNOPSIS\n";
     if ($args{'functiontype'} ne "") {
-	print ".B \"".$args{'functiontype'}."\" ".$args{'function'}."\n";
+	print ".B \"" . $args{'functiontype'} . "\" " . $args{'function'} . "\n";
     } else {
-	print ".B \"".$args{'function'}."\n";
+	print ".B \"" . $args{'function'} . "\n";
     }
     $count = 0;
     my $parenth = "(";
@@ -1061,10 +1061,10 @@ sub output_function_man(%) {
 	$type = $args{'parametertypes'}{$parameter};
 	if ($type =~ m/([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)/) {
 	    # pointer-to-function
-	    print ".BI \"".$parenth.$1."\" ".$parameter." \") (".$2.")".$post."\"\n";
+	    print ".BI \"" . $parenth . $1 . "\" " . $parameter . " \") (" . $2 . ")" . $post . "\"\n";
 	} else {
 	    $type =~ s/([^\*])$/$1 /;
-	    print ".BI \"".$parenth.$type."\" ".$parameter." \"".$post."\"\n";
+	    print ".BI \"" . $parenth . $type . "\" " . $parameter . " \"" . $post . "\"\n";
 	}
 	$count++;
 	$parenth = "";
@@ -1075,7 +1075,7 @@ sub output_function_man(%) {
 	my $parameter_name = $parameter;
 	$parameter_name =~ s/\[.*//;
 
-	print ".IP \"".$parameter."\" 12\n";
+	print ".IP \"" . $parameter . "\" 12\n";
 	output_highlight($args{'parameterdescs'}{$parameter_name});
     }
     foreach $section (@{$args{'sectionlist'}}) {
@@ -1094,10 +1094,10 @@ sub output_enum_man(%) {
     print ".TH \"$args{'module'}\" 9 \"enum $args{'enum'}\" \"$man_date\" \"API Manual\" LINUX\n";
 
     print ".SH NAME\n";
-    print "enum ".$args{'enum'}." \\- ".$args{'purpose'}."\n";
+    print "enum " . $args{'enum'} . " \\- " . $args{'purpose'} . "\n";
 
     print ".SH SYNOPSIS\n";
-    print "enum ".$args{'enum'}." {\n";
+    print "enum " . $args{'enum'} . " {\n";
     $count = 0;
     foreach my $parameter (@{$args{'parameterlist'}}) {
 	print ".br\n.BI \"    $parameter\"\n";
@@ -1116,7 +1116,7 @@ sub output_enum_man(%) {
 	my $parameter_name = $parameter;
 	$parameter_name =~ s/\[.*//;
 
-	print ".IP \"".$parameter."\" 12\n";
+	print ".IP \"" . $parameter . "\" 12\n";
 	output_highlight($args{'parameterdescs'}{$parameter_name});
     }
     foreach $section (@{$args{'sectionlist'}}) {
@@ -1131,13 +1131,13 @@ sub output_struct_man(%) {
     my %args = %{$_[0]};
     my ($parameter, $section);
 
-    print ".TH \"$args{'module'}\" 9 \"".$args{'type'}." ".$args{'struct'}."\" \"$man_date\" \"API Manual\" LINUX\n";
+    print ".TH \"$args{'module'}\" 9 \"" . $args{'type'} . " " . $args{'struct'} . "\" \"$man_date\" \"API Manual\" LINUX\n";
 
     print ".SH NAME\n";
-    print $args{'type'}." ".$args{'struct'}." \\- ".$args{'purpose'}."\n";
+    print $args{'type'} . " " . $args{'struct'} . " \\- " . $args{'purpose'} . "\n";
 
     print ".SH SYNOPSIS\n";
-    print $args{'type'}." ".$args{'struct'}." {\n.br\n";
+    print $args{'type'} . " " . $args{'struct'} . " {\n.br\n";
 
     foreach my $parameter (@{$args{'parameterlist'}}) {
 	if ($parameter =~ /^#/) {
@@ -1151,13 +1151,13 @@ sub output_struct_man(%) {
 	$type = $args{'parametertypes'}{$parameter};
 	if ($type =~ m/([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)/) {
 	    # pointer-to-function
-	    print ".BI \"    ".$1."\" ".$parameter." \") (".$2.")"."\"\n;\n";
+	    print ".BI \"    " . $1 . "\" " . $parameter . " \") (" . $2 . ")" . "\"\n;\n";
 	} elsif ($type =~ m/^(.*?)\s*(:.*)/) {
 	    # bitfield
-	    print ".BI \"    ".$1."\ \" ".$parameter.$2." \""."\"\n;\n";
+	    print ".BI \"    " . $1 . "\ \" " . $parameter . $2 . " \"" . "\"\n;\n";
 	} else {
 	    $type =~ s/([^\*])$/$1 /;
-	    print ".BI \"    ".$type."\" ".$parameter." \""."\"\n;\n";
+	    print ".BI \"    " . $type . "\" " . $parameter . " \"" . "\"\n;\n";
 	}
 	print "\n.br\n";
     }
@@ -1171,7 +1171,7 @@ sub output_struct_man(%) {
 	$parameter_name =~ s/\[.*//;
 
 	($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
-	print ".IP \"".$parameter."\" 12\n";
+	print ".IP \"" . $parameter . "\" 12\n";
 	output_highlight($args{'parameterdescs'}{$parameter_name});
     }
     foreach $section (@{$args{'sectionlist'}}) {
@@ -1189,7 +1189,7 @@ sub output_typedef_man(%) {
     print ".TH \"$args{'module'}\" 9 \"$args{'typedef'}\" \"$man_date\" \"API Manual\" LINUX\n";
 
     print ".SH NAME\n";
-    print "typedef ".$args{'typedef'}." \\- ".$args{'purpose'}."\n";
+    print "typedef " . $args{'typedef'} . " \\- " . $args{'purpose'} . "\n";
 
     foreach $section (@{$args{'sectionlist'}}) {
 	print ".SH \"$section\"\n";
@@ -1218,13 +1218,13 @@ sub output_function_text(%) {
     my $start;
 
     print "Name:\n\n";
-    print $args{'function'}." - ".$args{'purpose'}."\n";
+    print $args{'function'} . " - " . $args{'purpose'} . "\n";
 
     print "\nSynopsis:\n\n";
     if ($args{'functiontype'} ne "") {
-	$start = $args{'functiontype'}." ".$args{'function'}." (";
+	$start = $args{'functiontype'} . " " . $args{'function'} . " (";
     } else {
-	$start = $args{'function'}." (";
+	$start = $args{'function'} . " (";
     }
     print $start;
 
@@ -1233,9 +1233,9 @@ sub output_function_text(%) {
 	$type = $args{'parametertypes'}{$parameter};
 	if ($type =~ m/([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)/) {
 	    # pointer-to-function
-	    print $1.$parameter.") (".$2;
+	    print $1 . $parameter . ") (" . $2;
 	} else {
-	    print $type." ".$parameter;
+	    print $type . " " . $parameter;
 	}
 	if ($count != $#{$args{'parameterlist'}}) {
 	    $count++;
@@ -1251,7 +1251,7 @@ sub output_function_text(%) {
 	my $parameter_name = $parameter;
 	$parameter_name =~ s/\[.*//;
 
-	print $parameter."\n\t".$args{'parameterdescs'}{$parameter_name}."\n";
+	print $parameter . "\n\t" . $args{'parameterdescs'}{$parameter_name} . "\n";
     }
     output_section_text(@_);
 }
@@ -1276,8 +1276,8 @@ sub output_enum_text(%) {
     my $count;
     print "Enum:\n\n";
 
-    print "enum ".$args{'enum'}." - ".$args{'purpose'}."\n\n";
-    print "enum ".$args{'enum'}." {\n";
+    print "enum " . $args{'enum'} . " - " . $args{'purpose'} . "\n\n";
+    print "enum " . $args{'enum'} . " {\n";
     $count = 0;
     foreach $parameter (@{$args{'parameterlist'}}) {
 	print "\t$parameter";
@@ -1292,7 +1292,7 @@ sub output_enum_text(%) {
     print "Constants:\n\n";
     foreach $parameter (@{$args{'parameterlist'}}) {
 	print "$parameter\n\t";
-	print $args{'parameterdescs'}{$parameter}."\n";
+	print $args{'parameterdescs'}{$parameter} . "\n";
     }
 
     output_section_text(@_);
@@ -1305,7 +1305,7 @@ sub output_typedef_text(%) {
     my $count;
     print "Typedef:\n\n";
 
-    print "typedef ".$args{'typedef'}." - ".$args{'purpose'}."\n";
+    print "typedef " . $args{'typedef'} . " - " . $args{'purpose'} . "\n";
     output_section_text(@_);
 }
 
@@ -1314,8 +1314,8 @@ sub output_struct_text(%) {
     my %args = %{$_[0]};
     my ($parameter);
 
-    print $args{'type'}." ".$args{'struct'}." - ".$args{'purpose'}."\n\n";
-    print $args{'type'}." ".$args{'struct'}." {\n";
+    print $args{'type'} . " " . $args{'struct'} . " - " . $args{'purpose'} . "\n\n";
+    print $args{'type'} . " " . $args{'struct'} . " {\n";
     foreach $parameter (@{$args{'parameterlist'}}) {
 	if ($parameter =~ /^#/) {
 	    print "$parameter\n";
@@ -1334,7 +1334,7 @@ sub output_struct_text(%) {
 	    # bitfield
 	    print "\t$1 $parameter$2;\n";
 	} else {
-	    print "\t".$type." ".$parameter.";\n";
+	    print "\t" . $type . " " . $parameter . ";\n";
 	}
     }
     print "};\n\n";
@@ -1348,7 +1348,7 @@ sub output_struct_text(%) {
 
 	($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
 	print "$parameter\n\t";
-	print $args{'parameterdescs'}{$parameter_name}."\n";
+	print $args{'parameterdescs'}{$parameter_name} . "\n";
     }
     print "\n";
     output_section_text(@_);
@@ -1387,7 +1387,7 @@ sub output_declaration {
 # generic output function - calls the right one based on current output mode.
 sub output_blockhead {
     no strict 'refs';
-    my $func = "output_blockhead_".$output_mode;
+    my $func = "output_blockhead_" . $output_mode;
     &$func(@_);
     $section_counter++;
 }
@@ -1398,7 +1398,7 @@ sub output_blockhead {
 sub dump_declaration($$) {
     no strict 'refs';
     my ($prototype, $file) = @_;
-    my $func = "dump_".$decl_type;
+    my $func = "dump_" . $decl_type;
     &$func(@_);
 }
 
@@ -1645,7 +1645,7 @@ sub push_parameter($$$) {
 		    "or member '$param' not " .
 		    "described in '$declaration_name'\n";
 	    }
-	    print STDERR "Warning(${file}:$.):".
+	    print STDERR "Warning(${file}:$.):" .
 			 " No description found for parameter '$param'\n";
 	    ++$warnings;
 	}
@@ -1907,7 +1907,7 @@ sub process_state3_type($$) {
 	    ($2 eq '{') && $brcount++;
 	    ($2 eq '}') && $brcount--;
 	    if (($2 eq ';') && ($brcount == 0)) {
-		dump_declaration($prototype,$file);
+		dump_declaration($prototype, $file);
 		reset_state();
 		last;
 	    }
@@ -2084,7 +2084,7 @@ sub process_file($) {
 		    $section = $section_default;
 		    $contents = "";
 		} else {
-		    $contents .= $1."\n";
+		    $contents .= $1 . "\n";
 		}
 	    } else {
 		# i dont know - bad line?  ignore.

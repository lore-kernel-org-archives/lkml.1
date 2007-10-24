Return-Path: <linux-kernel-owner+w=401wt.eu-S1758230AbXJXWPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230AbXJXWPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 18:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754478AbXJXWOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 18:14:00 -0400
Received: from xenotime.net ([66.160.160.81]:50034 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754334AbXJXWN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 18:13:57 -0400
Date: Wed, 24 Oct 2007 15:08:48 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Johannes Berg <johannes@sipsolutions.net>,
       sam@ravnborg.org
Subject: [PATCH 4/6] kernel-doc: process functions, not DOC:
Message-ID: <11932637281563@xenotime.net>
In-Reply-To: <11932637282902@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>

This flag is necessary for the next patch for docproc to output
only the functions and not DOC: sections when a function list
is requested.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

---
 scripts/kernel-doc |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- linux-2.6.23-git19.orig/scripts/kernel-doc
+++ linux-2.6.23-git19/scripts/kernel-doc
@@ -46,13 +46,16 @@ use strict;
 # Note: This only supports 'c'.
 
 # usage:
-# kernel-doc [ -docbook | -html | -text | -man ]
+# kernel-doc [ -docbook | -html | -text | -man ] [ -no-doc-sections ]
 #           [ -function funcname [ -function funcname ...] ] c file(s)s > outputfile
 # or
 #           [ -nofunction funcname [ -function funcname ...] ] c file(s)s > outputfile
 #
 #  Set output format using one of -docbook -html -text or -man.  Default is man.
 #
+#  -no-doc-sections
+#	Do not output DOC: sections
+#
 #  -function funcname
 #	If set, then only generate documentation for the given function(s) or
 #	DOC: section titles.  All other functions and DOC: sections are ignored.
@@ -211,7 +214,7 @@ my $blankline_text = "";
 
 
 sub usage {
-    print "Usage: $0 [ -v ] [ -docbook | -html | -text | -man ]\n";
+    print "Usage: $0 [ -v ] [ -docbook | -html | -text | -man ] [ -no-doc-sections ]\n";
     print "         [ -function funcname [ -function funcname ...] ]\n";
     print "         [ -nofunction funcname [ -nofunction funcname ...] ]\n";
     print "         c source file(s) > outputfile\n";
@@ -225,6 +228,7 @@ if ($#ARGV==-1) {
 
 my $verbose = 0;
 my $output_mode = "man";
+my $no_doc_sections = 0;
 my %highlights = %highlights_man;
 my $blankline = $blankline_man;
 my $modulename = "Kernel API";
@@ -329,6 +333,8 @@ while ($ARGV[0] =~ m/^-(.*)/) {
 	usage();
     } elsif ($cmd eq '-filelist') {
 	    $filelist = shift @ARGV;
+    } elsif ($cmd eq '-no-doc-sections') {
+	    $no_doc_sections = 1;
     }
 }
 
@@ -380,6 +386,10 @@ sub dump_doc_section {
     my $name = shift;
     my $contents = join "\n", @_;
 
+    if ($no_doc_sections) {
+	return;
+    }
+
     if (($function_only==0) ||
 	( $function_only == 1 && defined($function_table{$name})) ||
 	( $function_only == 2 && !defined($function_table{$name})))


-- 


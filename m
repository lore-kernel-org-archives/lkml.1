Return-Path: <linux-kernel-owner+w=401wt.eu-S1764017AbXEWAVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764017AbXEWAVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 20:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762196AbXEWAVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 20:21:16 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:37754 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761824AbXEWAVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 20:21:14 -0400
Date: Tue, 22 May 2007 17:26:44 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH 3/3] kernel-doc: strip C99 comments
Message-Id: <20070522172644.0cdff5b1.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Strip C99-style comments from the input stream.
/*...*/ comments are already stripped.
C99 comments confuse the kernel-doc script.

Also update some comments.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kernel-doc |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- linux-2.6.22-rc2-git2.orig/scripts/kernel-doc
+++ linux-2.6.22-rc2-git2/scripts/kernel-doc
@@ -719,6 +719,7 @@ sub output_struct_xml(%) {
 	    # pointer-to-function
 	    print "  $1 $parameter) ($2);\n";
 	} elsif ($type =~ m/^(.*?)\s*(:.*)/) {
+	    # bitfield
 	    print "  $1 $parameter$2;\n";
 	} else {
 	    print "  ".$type." ".$parameter.";\n";
@@ -1261,6 +1262,7 @@ sub output_struct_text(%) {
 	    # pointer-to-function
 	    print "\t$1 $parameter) ($2);\n";
 	} elsif ($type =~ m/^(.*?)\s*(:.*)/) {
+	    # bitfield
 	    print "\t$1 $parameter$2;\n";
 	} else {
 	    print "\t".$type." ".$parameter.";\n";
@@ -1697,6 +1699,8 @@ sub process_state3_function($$) {
     my $x = shift;
     my $file = shift;
 
+    $x =~ s@\/\/.*$@@gos; # strip C99-style comments to end of line
+
     if ($x =~ m#\s*/\*\s+MACDOC\s*#io || ($x =~ /^#/ && $x !~ /^#define/)) {
 	# do nothing
     }
@@ -1719,6 +1723,8 @@ sub process_state3_type($$) {
     $x =~ s@[\r\n]+@ @gos; # strip newlines/cr's.
     $x =~ s@^\s+@@gos; # strip leading spaces
     $x =~ s@\s+$@@gos; # strip trailing spaces
+    $x =~ s@\/\/.*$@@gos; # strip C99-style comments to end of line
+
     if ($x =~ /^#/) {
 	# To distinguish preprocessor directive from regular declaration later.
 	$x .= ";";
@@ -1802,7 +1808,7 @@ sub process_file($) {
 
 		$state = 2;
 		if (/-(.*)/) {
-		    # strip leading/trailing/multiple spaces #RDD:T:
+		    # strip leading/trailing/multiple spaces
 		    $descr= $1;
 		    $descr =~ s/^\s*//;
 		    $descr =~ s/\s*$//;

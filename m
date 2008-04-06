Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbYDFEzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbYDFEzJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 00:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbYDFEy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 00:54:57 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:55766 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbYDFEy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 00:54:56 -0400
Date: Sun, 6 Apr 2008 06:54:54 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: apw@shadowen.org
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch] checkpatch: relax spacing and line length
Message-ID: <alpine.LNX.1.10.0804060653020.30794@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

===
total: 0 errors, 0 warnings, 36 lines checked

d27a9f5.diff has no obvious style problems and is ready for submission.
===
commit d27a9f5760fa231ab888f96e27355a001c88b239
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Sun Apr 6 06:49:01 2008 +0200

     checkpatch: relax spacing and line length

     We all had the arguments about 80 columns, so here goes a relax.
     Checking for 95 (or perhaps something better?), but of course we
     print "80" in the output, because if you happened to get to 95, it's
     "really time" to break it.

     This also relaxes the tab doctrine, because spaces DO make sense --
     especially when you view the code with a tab setting of not-8.

     Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
  scripts/checkpatch.pl |   22 ++++++++++++++++------
  1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 58a9494..e5a96c1 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1094,8 +1094,8 @@ sub process {
  			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
  			ERROR("trailing whitespace\n" . $herevet);
  		}
-#80 column limit
-		if ($line =~ /^\+/ && !($prevrawline=~/\/\*\*/) && $length > 80) {
+#80 column limit (yes, testing for 95 is correct, we do not want to annoy)
+		if ($line =~ /^\+/ && !($prevrawline=~/\/\*\*/) && $length >= 95) {
  			WARN("line over 80 characters\n" . $herecurr);
  		}

@@ -1107,12 +1107,22 @@ sub process {
  # check we are in a valid source file *.[hc] if not then ignore this hunk
  		next if ($realfile !~ /\.[hc]$/);

+		my $arg = qr/$Type(?: ?$Ident)?/;
+		if ($rawline =~ /^\+ +($arg, )*$arg(?:,|\);?)$/) {
+			# We are probably in a function parameter list.
+			# Spaces ok -- used for align.
+		} elsif ($rawline =~ /^\+\t+ *\S/) {
+			# We are probably in a function or an array/struct
+			# definition/initializer. Spaces ok -- used for align
+			# on multiline statements.
+		} else {
  # at the beginning of a line any tabs must come first and anything
  # more than 8 must use tabs.
-		if ($rawline =~ /^\+\s* \t\s*\S/ ||
-		    $rawline =~ /^\+\s*        \s*/) {
-			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
-			ERROR("use tabs not spaces\n" . $herevet);
+			if ($rawline =~ /^\+\s* \t\s*\S/ ||
+			    $rawline =~ /^\+\s*        \s*/) {
+				my $herevet = "$here\n" . cat_vet($rawline) . "\n";
+				ERROR("use tabs not spaces\n" . $herevet);
+			}
  		}

  # check for RCS/CVS revision markers


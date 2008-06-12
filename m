Return-Path: <linux-kernel-owner+w=401wt.eu-S1760424AbYFLM7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760424AbYFLM7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 08:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757410AbYFLM72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 08:59:28 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4936 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758051AbYFLM71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 08:59:27 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 18/23] checkpatch: improve type matcher debug
Date: Thu, 12 Jun 2008 13:05:57 +0100
Message-Id: <1213272362-19457-19-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.5.6.rc0.140.ga9675
In-Reply-To: <1213272362-19457-1-git-send-email-apw@shadowen.org>
References: <1213272362-19457-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve type matcher debug so we can see what it does match.  As part
of this move us to to using the common debug framework.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index bcfb8ef..077a2ca 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -17,7 +17,6 @@ my $quiet = 0;
 my $tree = 1;
 my $chk_signoff = 1;
 my $chk_patch = 1;
-my $tst_type = 0;
 my $tst_only;
 my $emacs = 0;
 my $terse = 0;
@@ -44,7 +43,6 @@ GetOptions(
 	'summary-file!'	=> \$summary_file,
 
 	'debug=s'	=> \%debug,
-	'test-type!'	=> \$tst_type,
 	'test-only=s'	=> \$tst_only,
 ) or exit;
 
@@ -67,6 +65,7 @@ if ($#ARGV < 0) {
 
 my $dbg_values = 0;
 my $dbg_possible = 0;
+my $dbg_type = 0;
 for my $key (keys %debug) {
 	eval "\${dbg_$key} = '$debug{$key}';"
 }
@@ -1307,8 +1306,12 @@ sub process {
 		if ($line=~/^[^\+]/) {next;}
 
 # TEST: allow direct testing of the type matcher.
-		if ($tst_type && $line =~ /^.$Declare$/) {
-			ERROR("TEST: is type $Declare\n" . $herecurr);
+		if ($dbg_type) {
+			if ($line =~ /^.\s*$Declare\s*$/) {
+				ERROR("TEST: is type\n" . $herecurr);
+			} elsif ($dbg_type > 1 && $line =~ /^.+($Declare)/) {
+				ERROR("TEST: is not type ($1 is)\n". $herecurr);
+			}
 			next;
 		}
 
-- 
1.5.6.rc0.140.ga9675


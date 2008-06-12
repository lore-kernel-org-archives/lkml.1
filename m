Return-Path: <linux-kernel-owner+w=401wt.eu-S1761302AbYFLM3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761302AbYFLM3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 08:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761130AbYFLM3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 08:29:32 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3387 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761107AbYFLM3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 08:29:31 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 13/23] checkpatch: toughen trailing if statement checks and extend them to while and for
Date: Thu, 12 Jun 2008 13:05:52 +0100
Message-Id: <1213272362-19457-14-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.5.6.rc0.140.ga9675
In-Reply-To: <1213272362-19457-1-git-send-email-apw@shadowen.org>
References: <1213272362-19457-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend the trailing statement checks to report a trailing semi-colon ';'
as we really want it on the next line and indented so it is really really
obvious.  Also extend the tests to include while and for.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e7c8ab1..8616bae 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1269,8 +1269,8 @@ sub process {
 				$ctx_ln++;
 			}
 
-			##print "realcnt<$realcnt> ctx_cnt<$ctx_cnt>\n";
-			##print "pre<$pre_ctx>\nline<$line>\nctx<$ctx>\nnext<$lines[$ctx_ln - 1]>\n";
+			#print "realcnt<$realcnt> ctx_cnt<$ctx_cnt>\n";
+			#print "pre<$pre_ctx>\nline<$line>\nctx<$ctx>\nnext<$lines[$ctx_ln - 1]>\n";
 
 			if ($ctx !~ /{\s*/ && defined($lines[$ctx_ln -1]) && $lines[$ctx_ln - 1] =~ /^\+\s*{/) {
 				ERROR("that open brace { should be on the previous line\n" .
@@ -1713,7 +1713,7 @@ sub process {
 		}
 
 # Check for illegal assignment in if conditional.
-		if ($line =~ /\bif\s*\(/) {
+		if ($line =~ /\b(?:if|while|for)\s*\(/ && $line !~ /^.\s*#/) {
 			my ($s, $c) = ($stat, $cond);
 
 			if ($c =~ /\bif\s*\(.*[^<>!=]=[^=].*/) {
@@ -1725,8 +1725,8 @@ sub process {
 			substr($s, 0, length($c), '');
 			$s =~ s/\n.*//g;
 			$s =~ s/$;//g; 	# Remove any comments
-			if (length($c) && $s !~ /^\s*({|;|)\s*\\*\s*$/ &&
-			    $c !~ /^.\s*\#\s*if/)
+			if (length($c) && $s !~ /^\s*{?\s*\\*\s*$/ &&
+			    $c !~ /}\s*while\s*/)
 			{
 				ERROR("trailing statements should be on next line\n" . $herecurr);
 			}
-- 
1.5.6.rc0.140.ga9675


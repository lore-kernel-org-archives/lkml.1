Return-Path: <linux-kernel-owner+w=401wt.eu-S1758244AbYHKUPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244AbYHKUPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 16:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757376AbYHKUNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 16:13:23 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:41163 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbYHKUNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 16:13:19 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 03/17] checkpatch: conditional indent -- labels have different indent rules
Date: Mon, 11 Aug 2008 21:12:58 +0100
Message-Id: <1218485592-6679-4-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.rc1.258.g80295
In-Reply-To: <1218485592-6679-1-git-send-email-apw@shadowen.org>
References: <1218485592-6679-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Labels have different indent rules and must be ignored when checking
the conditional indent levels.  Also correct identify labels in
single statement conditionals.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 1148213..1e7d2cd 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -782,9 +782,9 @@ sub annotate_values {
 			}
 			$type = 'N';
 
-		} elsif ($cur =~ /^(if|while|typeof|__typeof__|for)\b/o) {
+		} elsif ($cur =~ /^(if|while|for)\b/o) {
 			print "COND($1)\n" if ($dbg_values > 1);
-			$av_pending = 'N';
+			$av_pending = 'E';
 			$type = 'N';
 
 		} elsif ($cur =~/^(case)/o) {
@@ -792,7 +792,7 @@ sub annotate_values {
 			$av_pend_colon = 'C';
 			$type = 'N';
 
-		} elsif ($cur =~/^(return|else|goto)/o) {
+		} elsif ($cur =~/^(return|else|goto|typeof|__typeof__)\b/o) {
 			print "KEYWORD($1)\n" if ($dbg_values > 1);
 			$type = 'N';
 
@@ -1846,6 +1846,11 @@ sub process {
 				$check = 0;
 			}
 
+			# Ignore the current line if it is label.
+			if ($s =~ /^\s*$Ident\s*:/) {
+				$check = 0;
+			}
+
 			my (undef, $sindent) = line_stats("+" . $s);
 
 			##print "line<$line> prevline<$prevline> indent<$indent> sindent<$sindent> check<$check> continuation<$continuation> s<$s>\n";
-- 
1.6.0.rc1.258.g80295


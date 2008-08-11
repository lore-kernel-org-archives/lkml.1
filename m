Return-Path: <linux-kernel-owner+w=401wt.eu-S1758874AbYHKUT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874AbYHKUT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 16:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758064AbYHKUSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 16:18:31 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:41280 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757766AbYHKUSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 16:18:30 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 15/17] checkpatch: report the correct lines for single statement blocks
Date: Mon, 11 Aug 2008 21:13:10 +0100
Message-Id: <1218485592-6679-16-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.rc1.258.g80295
In-Reply-To: <1218485592-6679-1-git-send-email-apw@shadowen.org>
References: <1218485592-6679-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Report the correct lines for single statement blocks.  Currently we are
reporting the right number of lines, but not skipping the negative lines.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index c7980ff..36825c3 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2214,10 +2214,10 @@ sub process {
 			}
 			if ($level == 0 && $block =~ /^\s*\{/ && !$allowed) {
 				my $herectx = $here . "\n";;
-				my $end = $linenr + statement_rawlines($block) - 1;
+				my $cnt = statement_rawlines($block);
 
-				for (my $ln = $linenr - 1; $ln < $end; $ln++) {
-					$herectx .= $rawlines[$ln] . "\n";;
+				for (my $n = 0; $n < $cnt; $n++) {
+					$herectx .= raw_line($linenr, $n) . "\n";;
 				}
 
 				WARN("braces {} are not necessary for single statement blocks\n" . $herectx);
-- 
1.6.0.rc1.258.g80295


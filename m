Return-Path: <linux-kernel-owner+w=401wt.eu-S1758180AbYHKUOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180AbYHKUOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 16:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756772AbYHKUNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 16:13:23 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:41170 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839AbYHKUNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 16:13:19 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 07/17] checkpatch: complex macros -- fix up extension handling
Date: Mon, 11 Aug 2008 21:13:02 +0100
Message-Id: <1218485592-6679-8-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.rc1.258.g80295
In-Reply-To: <1218485592-6679-1-git-send-email-apw@shadowen.org>
References: <1218485592-6679-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only pull in new extension lines where the current contents ends
with a \.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 303c363..586f9a4 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1977,8 +1977,8 @@ sub process {
 			# Extract the remainder of the define (if any) and
 			# rip off surrounding spaces, and trailing \'s.
 			$rest = '';
-			while ($off != 0 || ($cnt > 0 && $rest =~ /(?:^|\\)\s*$/)) {
-				#print "ADDING $off <" . substr($lines[$ln - 1], $off) . ">\n";
+			while ($off != 0 || ($cnt > 0 && $rest =~ /\\\s*$/)) {
+				#print "ADDING cnt<$cnt> $off <" . substr($lines[$ln - 1], $off) . "> rest<$rest>\n";
 				if ($off != 0 || $lines[$ln - 1] !~ /^-/) {
 					$rest .= substr($lines[$ln - 1], $off) . "\n";
 					$cnt--;
-- 
1.6.0.rc1.258.g80295


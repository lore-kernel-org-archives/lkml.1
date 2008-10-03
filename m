Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbYJCP2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbYJCP2X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 11:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbYJCP0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 11:26:07 -0400
Received: from tallyho.bytemark.co.uk ([80.68.81.166]:57509 "EHLO
	tallyho.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbYJCP0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 11:26:00 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 07/13] checkpatch: suspect code indent must stop at #else/#elif
Date: Fri,  3 Oct 2008 16:25:48 +0100
Message-Id: <1223047554-31111-8-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.1.451.gc8d31
In-Reply-To: <1223047554-31111-1-git-send-email-apw@shadowen.org>
References: <1223047554-31111-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we hit and #else or #elif we know we are meeting an alternative
piece of code.  All bets are off on indent if we did not see the open of
the control so stop checking.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 4680ccf..c479bde 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1468,6 +1468,12 @@ sub process {
 			while ($cond_ptr != $cond_lines) {
 				$cond_ptr = $cond_lines;
 
+				# If we see an #else/#elif then the code
+				# is not linear.
+				if ($s =~ /^\s*\#\s*(?:else|elif)/) {
+					$check = 0;
+				}
+
 				# Ignore:
 				#  1) blank lines, they should be at 0,
 				#  2) preprocessor lines, and
-- 
1.6.0.1.451.gc8d31


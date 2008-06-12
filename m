Return-Path: <linux-kernel-owner+w=401wt.eu-S1761337AbYFLMa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761337AbYFLMa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 08:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758399AbYFLMaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 08:30:11 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3393 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757548AbYFLMaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 08:30:09 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 12/23] checkpatch: check spacing for square brackets
Date: Thu, 12 Jun 2008 13:05:51 +0100
Message-Id: <1213272362-19457-13-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.5.6.rc0.140.ga9675
In-Reply-To: <1213272362-19457-1-git-send-email-apw@shadowen.org>
References: <1213272362-19457-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check on the spacing before square brackets.  We should only allow spaces
there if this is part of a type definition or an initialialiser.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 5f71b30..e7c8ab1 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1435,6 +1435,17 @@ sub process {
 			ERROR("open brace '{' following $1 go on the same line\n" . $hereprev);
 		}
 
+# check for spacing round square brackets; allowed:
+#  1. with a type on the left -- int [] a;
+#  2. at the beginning of a line for slice initialisers -- [0..10] = 5,
+		while ($line =~ /(.*?\s)\[/g) {
+			my ($where, $prefix) = ($-[1], $1);
+			if ($prefix !~ /$Type\s+$/ &&
+			    ($where != 0 || $prefix !~ /^.\s+$/)) {
+				ERROR("space prohibited before open square bracket '['\n" . $herecurr);
+			}
+		}
+
 # check for spaces between functions and their parentheses.
 		while ($line =~ /($Ident)\s+\(/g) {
 			my $name = $1;
-- 
1.5.6.rc0.140.ga9675


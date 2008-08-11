Return-Path: <linux-kernel-owner+w=401wt.eu-S1758788AbYHKUU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788AbYHKUU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 16:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758132AbYHKUSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 16:18:36 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:41286 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757982AbYHKUSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 16:18:34 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 16/17] checkpatch: perform indent checks on perl
Date: Mon, 11 Aug 2008 21:13:11 +0100
Message-Id: <1218485592-6679-17-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.rc1.258.g80295
In-Reply-To: <1218485592-6679-1-git-send-email-apw@shadowen.org>
References: <1218485592-6679-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So that we eat our own dog food ensure the indent checks apply to perl too.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 36825c3..ba677c1 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1266,8 +1266,8 @@ sub process {
 			WARN("adding a line without newline at end of file\n" . $herecurr);
 		}
 
-# check we are in a valid source file *.[hc] if not then ignore this hunk
-		next if ($realfile !~ /\.[hc]$/);
+# check we are in a valid source file C or perl if not then ignore this hunk
+		next if ($realfile !~ /\.(h|c|pl)$/);
 
 # at the beginning of a line any tabs must come first and anything
 # more than 8 must use tabs.
@@ -1277,6 +1277,9 @@ sub process {
 			ERROR("code indent should use tabs where possible\n" . $herevet);
 		}
 
+# check we are in a valid C source file if not then ignore this hunk
+		next if ($realfile !~ /\.(h|c)$/);
+
 # check for RCS/CVS revision markers
 		if ($rawline =~ /^\+.*\$(Revision|Log|Id)(?:\$|)/) {
 			WARN("CVS style keyword markers, these will _not_ be updated\n". $herecurr);
-- 
1.6.0.rc1.258.g80295


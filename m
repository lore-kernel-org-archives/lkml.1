Return-Path: <linux-kernel-owner+w=401wt.eu-S1755222AbYJWLHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbYJWLHI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 07:07:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbYJWLGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 07:06:55 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:50717 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbYJWLGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 07:06:54 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 3/9] checkpatch: widen implied comment detection to allow multiple stars
Date: Thu, 23 Oct 2008 12:06:33 +0100
Message-Id: <1224759999-21389-4-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.2.711.gf1ba4
In-Reply-To: <1224759999-21389-1-git-send-email-apw@shadowen.org>
References: <1224759999-21389-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some people use double star '**' as a comment continuation, and start
comments with complete lines of stars.  Widen the implied comment detection
to pick these up.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index beae539..c28c20c 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1109,7 +1109,7 @@ sub process {
 			# is the start of a diff block and this line starts
 			# ' *' then it is very likely a comment.
 			if (!defined $edge &&
-			    $rawlines[$linenr] =~ m@^.\s* \*(?:\s|$)@)
+			    $rawlines[$linenr] =~ m@^.\s*(?:\*\*+| \*)(?:\s|$)@)
 			{
 				$in_comment = 1;
 			}
-- 
1.6.0.2.711.gf1ba4


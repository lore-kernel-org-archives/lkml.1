Return-Path: <linux-kernel-owner+w=401wt.eu-S1755522AbYJWLII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbYJWLII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 07:08:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbYJWLG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 07:06:56 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:50739 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbYJWLGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 07:06:54 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 2/9] checkpatch: comment detection may miss an implied comment on the last hunk
Date: Thu, 23 Oct 2008 12:06:32 +0100
Message-Id: <1224759999-21389-3-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.2.711.gf1ba4
In-Reply-To: <1224759999-21389-1-git-send-email-apw@shadowen.org>
References: <1224759999-21389-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When detecting implied comments from leading stars we may incorrectly
think we have detected an edge one way or the other when we have not
if we drop off the end of the last hunk.  Fix this up.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index dbbf96f..beae539 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1097,8 +1097,8 @@ sub process {
 					 $rawlines[$ln - 1] =~ /^-/);
 				$cnt--;
 				#print "RAW<$rawlines[$ln - 1]>\n";
-				($edge) = (defined $rawlines[$ln - 1] &&
-					$rawlines[$ln - 1] =~ m@(/\*|\*/)@);
+				last if (!defined $rawlines[$ln - 1]);
+				($edge) = ($rawlines[$ln - 1] =~ m@(/\*|\*/)@);
 				last if (defined $edge);
 			}
 			if (defined $edge && $edge eq '*/') {
-- 
1.6.0.2.711.gf1ba4


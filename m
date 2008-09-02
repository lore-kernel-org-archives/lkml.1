Return-Path: <linux-kernel-owner+w=401wt.eu-S1753521AbYIBRZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbYIBRZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 13:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbYIBRZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 13:25:19 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:36115 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbYIBRZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 13:25:18 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 5/7] checkpatch: suspect indent count condition lines correctly
Date: Tue,  2 Sep 2008 18:25:12 +0100
Message-Id: <1220376314-15180-6-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.rc1.258.g80295
In-Reply-To: <1220376314-15180-1-git-send-email-apw@shadowen.org>
References: <1220376314-15180-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct calculation of the number of lines of condition where we have
suspect indent.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index a2e4a3d..2e513fd 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1417,7 +1417,8 @@ sub process {
 			$s =~ s/\n./\n/gs;
 
 			# Find out how long the conditional actually is.
-			my $cond_lines = 0 + $c =~ /\n/gs;
+			my @newlines = ($c =~ /\n/gs);
+			my $cond_lines = 1 + $#newlines;
 
 			# We want to check the first line inside the block
 			# starting at the end of the conditional, so remove:
-- 
1.6.0.rc1.258.g80295


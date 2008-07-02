Return-Path: <linux-kernel-owner+w=401wt.eu-S1764100AbYGBLeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764100AbYGBLeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 07:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756054AbYGBLd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 07:33:29 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2923 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326AbYGBLd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 07:33:27 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 3/5] checkpatch: complex macros need to ignore comments
Date: Wed,  2 Jul 2008 12:31:16 +0100
Message-Id: <1214998278-11767-4-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.5.6.1.201.g3e7d3
In-Reply-To: <1214998278-11767-1-git-send-email-apw@shadowen.org>
References: <1214998278-11767-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure we ignore comments in complex macro detection else we incorrectly
report this:

	#define PFM_GROUP_PERM_ANY     -1      /* any user/group */

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 8afa88a..96a762b 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1972,6 +1972,7 @@ sub process {
 			} else {
 				$dstat =~ s/^.\s*\#\s*define\s+$Ident\s*//;
 			}
+			$dstat =~ s/$;//g;
 			$dstat =~ s/\\\n.//g;
 			$dstat =~ s/^\s*//s;
 			$dstat =~ s/\s*$//s;
-- 
1.5.6.1.201.g3e7d3


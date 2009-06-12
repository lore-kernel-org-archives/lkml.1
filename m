Return-Path: <linux-kernel-owner+w=401wt.eu-S1760986AbZFLL3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760986AbZFLL3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 07:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbZFLL3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 07:29:39 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:59255 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbZFLL3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 07:29:38 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] scripts/checksyscalls.sh: only whine perf_counter_open when supported
Date: Fri, 12 Jun 2009 07:29:29 -0400
Message-Id: <1244806169-12232-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the port does not support HAVE_PERF_COUNTERS, then they can't support
the perf_counter_open syscall either.  Rather than forcing everyone to add
an ignore (or suffer the warning until they get around to implementing
support), only whine about the syscall when applicable.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 scripts/checksyscalls.sh |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/scripts/checksyscalls.sh b/scripts/checksyscalls.sh
index 60d00d1..90fb953 100755
--- a/scripts/checksyscalls.sh
+++ b/scripts/checksyscalls.sh
@@ -104,6 +104,11 @@ cat << EOF
 #define __IGNORE_sync_file_range
 #endif
 
+/* if the port doesn't have support for it yet */
+#ifndef CONFIG_HAVE_PERF_COUNTERS
+#define __IGNORE_perf_counter_open
+#endif
+
 /* Unmerged syscalls for AFS, STREAMS, etc. */
 #define __IGNORE_afs_syscall
 #define __IGNORE_getpmsg
-- 
1.6.3.1


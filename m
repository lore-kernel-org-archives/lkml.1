Return-Path: <linux-kernel-owner+w=401wt.eu-S1754347AbZKDHST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbZKDHST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 02:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898AbZKDHSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 02:18:18 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:39335 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbZKDHSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 02:18:17 -0500
Message-ID: <4AF129C8.3030008@ct.jp.nec.com>
Date: Wed, 04 Nov 2009 16:14:16 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] sched: remove __schedule() declaration
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

__schedule() had been removed.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 include/linux/sched.h |    1 -
 kernel/kgdb.c         |    2 +-
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 75e6e60..f18102c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -349,7 +349,6 @@ extern signed long schedule_timeout(signed long timeout);
 extern signed long schedule_timeout_interruptible(signed long timeout);
 extern signed long schedule_timeout_killable(signed long timeout);
 extern signed long schedule_timeout_uninterruptible(signed long timeout);
-asmlinkage void __schedule(void);
 asmlinkage void schedule(void);
 extern int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner);
 
diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index 9147a31..7d70146 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -870,7 +870,7 @@ static void gdb_cmd_getregs(struct kgdb_state *ks)
 
 	/*
 	 * All threads that don't have debuggerinfo should be
-	 * in __schedule() sleeping, since all other CPUs
+	 * in schedule() sleeping, since all other CPUs
 	 * are in kgdb_wait, and thus have debuggerinfo.
 	 */
 	if (local_debuggerinfo) {
-- 
1.6.3.3


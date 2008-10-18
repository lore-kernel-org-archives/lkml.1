Return-Path: <linux-kernel-owner+w=401wt.eu-S1755915AbYJRBVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbYJRBVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 21:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbYJRBVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 21:21:33 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:20000 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbYJRBVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 21:21:32 -0400
Message-ID: <48F93A19.9070007@ct.jp.nec.com>
Date: Fri, 17 Oct 2008 18:21:29 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: [PATCH -rt] sched: remove unneeded #if directive
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

__cond_resched_spinlock() is in #ifdef CONFIG_PREEMPT_RT.
So the following line always true.
#if (defined(CONFIG_SMP) && defined(CONFIG_PREEMPT)) || defined(CONFIG_PREEMPT_RT)

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 kernel/sched.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 0d68e79..2b34f00 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5841,7 +5841,6 @@ EXPORT_SYMBOL(__cond_resched_raw_spinlock);
 
 int __cond_resched_spinlock(spinlock_t *lock)
 {
-#if (defined(CONFIG_SMP) && defined(CONFIG_PREEMPT)) || defined(CONFIG_PREEMPT_RT)
 	if (lock->break_lock) {
 		lock->break_lock = 0;
 		spin_unlock_no_resched(lock);
@@ -5849,7 +5848,7 @@ int __cond_resched_spinlock(spinlock_t *lock)
 		spin_lock(lock);
 		return 1;
 	}
-#endif
+
 	return 0;
 }
 EXPORT_SYMBOL(__cond_resched_spinlock);
-- 
1.5.6


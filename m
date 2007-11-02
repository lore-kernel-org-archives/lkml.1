Return-Path: <linux-kernel-owner+w=401wt.eu-S1755610AbXKBOWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbXKBOWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 10:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbXKBOWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 10:22:40 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:60340 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688AbXKBOWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 10:22:39 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 02 Nov 2007 19:52:20 +0530
Message-Id: <20071102142220.24166.49046.sendpatchset@balbir-laptop>
Subject: [PATCH] Fix delay accounting regression
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Fix the delay accounting regression introduced by commit
75d4ef16a6aa84f708188bada182315f80aab6fa. rq no longer has sched_info
data associated with it. task_struct sched_info structure is used by delay
accounting to provide back statistics to user space.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 kernel/sched_stats.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/sched_stats.h~delayacct-define-bug kernel/sched_stats.h
--- linux-2.6-latest/kernel/sched_stats.h~delayacct-define-bug	2007-11-02 19:02:07.000000000 +0530
+++ linux-2.6-latest-balbir/kernel/sched_stats.h	2007-11-02 19:51:30.000000000 +0530
@@ -127,7 +127,7 @@ rq_sched_info_depart(struct rq *rq, unsi
 # define schedstat_set(var, val)	do { } while (0)
 #endif
 
-#ifdef CONFIG_SCHEDSTATS
+#if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 /*
  * Called when a process is dequeued from the active array and given
  * the cpu.  We should note that with the exception of interactive
@@ -231,5 +231,5 @@ sched_info_switch(struct task_struct *pr
 #else
 #define sched_info_queued(t)		do { } while (0)
 #define sched_info_switch(t, next)	do { } while (0)
-#endif /* CONFIG_SCHEDSTATS */
+#endif /* CONFIG_SCHEDSTATS || CONFIG_TASK_DELAY_ACCT */
 
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL

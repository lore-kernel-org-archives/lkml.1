Return-Path: <linux-kernel-owner+w=401wt.eu-S1754735AbZKDHSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbZKDHSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 02:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbZKDHSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 02:18:38 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:39827 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914AbZKDHSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 02:18:37 -0500
Message-ID: <4AF12A66.6020609@ct.jp.nec.com>
Date: Wed, 04 Nov 2009 16:16:54 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] sched: remove cpu_nr_migrations()
References: <4AF129C8.3030008@ct.jp.nec.com>
In-Reply-To: <4AF129C8.3030008@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

cpu_nr_migrations() is not used, remove it.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 include/linux/sched.h |    1 -
 kernel/sched.c        |   11 -----------
 2 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 754b3de..dfc21fb 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -145,7 +145,6 @@ extern unsigned long this_cpu_load(void);
 
 
 extern void calc_global_load(void);
-extern u64 cpu_nr_migrations(int cpu);
 
 extern unsigned long get_parent_ip(unsigned long addr);
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 92cf9cb..21f9ab0 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -541,7 +541,6 @@ struct rq {
 	struct load_weight load;
 	unsigned long nr_load_updates;
 	u64 nr_switches;
-	u64 nr_migrations_in;
 
 	struct cfs_rq cfs;
 	struct rt_rq rt;
@@ -2077,7 +2076,6 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 #endif
 	if (old_cpu != new_cpu) {
 		p->se.nr_migrations++;
-		new_rq->nr_migrations_in++;
 #ifdef CONFIG_SCHEDSTATS
 		if (task_hot(p, old_rq->clock, NULL))
 			schedstat_inc(p, se.nr_forced2_migrations);
@@ -3017,15 +3015,6 @@ static void calc_load_account_active(struct rq *this_rq)
 }
 
 /*
- * Externally visible per-cpu scheduler statistics:
- * cpu_nr_migrations(cpu) - number of migrations into that cpu
- */
-u64 cpu_nr_migrations(int cpu)
-{
-	return cpu_rq(cpu)->nr_migrations_in;
-}
-
-/*
  * Update rq->cpu_load[] statistics. This function is usually called every
  * scheduler tick (TICK_NSEC).
  */
-- 
1.6.3.3


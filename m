Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbZKDLLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbZKDLLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 06:11:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755425AbZKDLLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 06:11:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:39773 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332AbZKDLLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 06:11:05 -0500
Date: Wed, 4 Nov 2009 11:10:40 GMT
From: tip-bot for Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, h-shimamoto@ct.jp.nec.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, h-shimamoto@ct.jp.nec.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4AF12A66.6020609@ct.jp.nec.com>
References: <4AF12A66.6020609@ct.jp.nec.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove unused cpu_nr_migrations()
Message-ID: <tip-9824a2b728b63e7ff586b9fd9293c819be79f0f3@git.kernel.org>
Git-Commit-ID: 9824a2b728b63e7ff586b9fd9293c819be79f0f3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9824a2b728b63e7ff586b9fd9293c819be79f0f3
Gitweb:     http://git.kernel.org/tip/9824a2b728b63e7ff586b9fd9293c819be79f0f3
Author:     Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
AuthorDate: Wed, 4 Nov 2009 16:16:54 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Nov 2009 11:43:43 +0100

sched: Remove unused cpu_nr_migrations()

cpu_nr_migrations() is not used, remove it.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <4AF12A66.6020609@ct.jp.nec.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
index 67be4d0..30fd0ba 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -541,7 +541,6 @@ struct rq {
 	struct load_weight load;
 	unsigned long nr_load_updates;
 	u64 nr_switches;
-	u64 nr_migrations_in;
 
 	struct cfs_rq cfs;
 	struct rt_rq rt;
@@ -2049,7 +2048,6 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 #endif
 	if (old_cpu != new_cpu) {
 		p->se.nr_migrations++;
-		new_rq->nr_migrations_in++;
 #ifdef CONFIG_SCHEDSTATS
 		if (task_hot(p, old_rq->clock, NULL))
 			schedstat_inc(p, se.nr_forced2_migrations);
@@ -2989,15 +2987,6 @@ static void calc_load_account_active(struct rq *this_rq)
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

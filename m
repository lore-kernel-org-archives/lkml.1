Return-Path: <linux-kernel-owner+w=401wt.eu-S1763386AbYFZNgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763386AbYFZNgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbYFZNgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 09:36:44 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:55232 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbYFZNgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 09:36:43 -0400
Date: Thu, 26 Jun 2008 19:06:11 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] make sched_{fair,rt}.c ifdefs more readable
Message-ID: <20080626133611.GB5326@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Another patch to make the ifdef jungle more readable :)

Thanks,


sched: Make sched_{rt,fair}.c ifdefs more readable


Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>

Index: linux-2.6-tip/kernel/sched_rt.c
===================================================================
--- linux-2.6-tip.orig/kernel/sched_rt.c	2008-06-23 21:52:33.000000000 +0530
+++ linux-2.6-tip/kernel/sched_rt.c	2008-06-24 22:48:34.000000000 +0530
@@ -161,7 +161,7 @@ static inline struct rt_bandwidth *sched
 	return &rt_rq->tg->rt_bandwidth;
 }
 
-#else
+#else /* !CONFIG_RT_GROUP_SCHED */
 
 static inline u64 sched_rt_runtime(struct rt_rq *rt_rq)
 {
@@ -226,7 +226,7 @@ static inline struct rt_bandwidth *sched
 	return &def_rt_bandwidth;
 }
 
-#endif
+#endif /* CONFIG_RT_GROUP_SCHED */
 
 #ifdef CONFIG_SMP
 static int do_balance_runtime(struct rt_rq *rt_rq)
@@ -375,12 +375,12 @@ static int balance_runtime(struct rt_rq 
 
 	return more;
 }
-#else
+#else /* !CONFIG_SMP */
 static inline int balance_runtime(struct rt_rq *rt_rq)
 {
 	return 0;
 }
-#endif
+#endif /* CONFIG_SMP */
 
 static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
 {
@@ -1470,4 +1470,4 @@ static void print_rt_stats(struct seq_fi
 		print_rt_rq(m, cpu, rt_rq);
 	rcu_read_unlock();
 }
-#endif
+#endif /* CONFIG_SCHED_DEBUG */
Index: linux-2.6-tip/kernel/sched_fair.c
===================================================================
--- linux-2.6-tip.orig/kernel/sched_fair.c	2008-06-23 21:52:33.000000000 +0530
+++ linux-2.6-tip/kernel/sched_fair.c	2008-06-24 22:55:07.000000000 +0530
@@ -832,7 +832,7 @@ static void hrtick_start_fair(struct rq 
 		hrtick_start(rq, delta, requeue);
 	}
 }
-#else
+#else /* !CONFIG_SCHED_HRTICK */
 static inline void
 hrtick_start_fair(struct rq *rq, struct task_struct *p)
 {
@@ -973,7 +973,7 @@ static int wake_idle(int cpu, struct tas
 	}
 	return cpu;
 }
-#else
+#else /* !ARCH_HAS_SCHED_WAKE_IDLE*/
 static inline int wake_idle(int cpu, struct task_struct *p)
 {
 	return cpu;
@@ -1318,7 +1318,7 @@ static int cfs_rq_best_prio(struct cfs_r
 
 	return p->prio;
 }
-#endif
+#endif /* CONFIG_FAIR_GROUP_SCHED */
 
 static unsigned long
 load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
@@ -1351,7 +1351,7 @@ load_balance_fair(struct rq *this_rq, in
 		maxload = min(rem_load_move, imbalance);
 
 		*this_best_prio = cfs_rq_best_prio(this_cfs_rq);
-#else
+#else /* !CONFIG_FAIR_GROUP_SCHED */
 # define maxload rem_load_move
 #endif
 		/*
@@ -1394,7 +1394,7 @@ move_one_task_fair(struct rq *this_rq, i
 
 	return 0;
 }
-#endif
+#endif /* CONFIG_SMP */
 
 /*
  * scheduler tick hitting a task of our scheduling class:
-- 
regards,
Dhaval

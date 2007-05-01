Return-Path: <linux-kernel-owner+w=401wt.eu-S1423673AbXEAEaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423673AbXEAEaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 00:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030524AbXEAEaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 00:30:10 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:33324 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030515AbXEAEaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 00:30:06 -0400
From: Balbir Singh <balbir@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Balbir Singh <balbir@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 01 May 2007 10:00:00 +0530
Message-Id: <20070501043000.14787.54833.sendpatchset@balbir-laptop>
Subject: [PATCH CFS V7] Fix warnings in sched and sched_debug
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch I sent out did not have a sign-off; I had trouble with my patch 
tools.

This patch fixes all warnings seen on powerpc during compilation of the
CFS patch. It also fixes errors (side-effect of the warnings), where
some of the data is printed as negative values.

Applies on top of cfs v7

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 kernel/sched.c       |   34 +++++++++++++++++-----------------
 kernel/sched_debug.c |   16 ++++++++--------
 2 files changed, 25 insertions(+), 25 deletions(-)

diff -puN kernel/sched.c~cfs-v7-fix-sched-debug-warnings kernel/sched.c
--- linux-2.6.21/kernel/sched.c~cfs-v7-fix-sched-debug-warnings	2007-05-01 09:55:14.000000000 +0530
+++ linux-2.6.21-balbir/kernel/sched.c	2007-05-01 09:55:14.000000000 +0530
@@ -229,7 +229,7 @@ char * sched_print_task_state(struct tas
 	unsigned long long t0, t1;
 
 #define P(F) \
-	buffer += sprintf(buffer, "%-25s:%20Ld\n", #F, p->F)
+	buffer += sprintf(buffer, "%-25s:%20Ld\n", #F, (long long)p->F)
 
 	P(wait_start);
 	P(wait_start_fair);
@@ -248,22 +248,22 @@ char * sched_print_task_state(struct tas
 
 	t0 = sched_clock();
 	t1 = sched_clock();
-	buffer += sprintf(buffer, "%-25s:%20Ld\n", "clock-delta", t1-t0);
-	buffer += sprintf(buffer, "%-25s:%20Ld\n",
-			  "rq-wait_runtime", this_rq->wait_runtime);
-	buffer += sprintf(buffer, "%-25s:%20Ld\n",
-			  "rq-fair_clock", this_rq->fair_clock);
-	buffer += sprintf(buffer, "%-25s:%20Ld\n",
-			  "rq-clock", this_rq->clock);
-	buffer += sprintf(buffer, "%-25s:%20Ld\n",
-			  "rq-prev_clock_raw", this_rq->prev_clock_raw);
-	buffer += sprintf(buffer, "%-25s:%20Ld\n",
-			  "rq-clock_max_delta", this_rq->clock_max_delta);
-	buffer += sprintf(buffer, "%-25s:%20u\n",
-			  "rq-clock_warps", this_rq->clock_warps);
-	buffer += sprintf(buffer, "%-25s:%20u\n",
-			  "rq-clock_unstable_events",
-				  this_rq->clock_unstable_events);
+	buffer += sprintf(buffer, "%-25s:%20Ld\n", "clock-delta",
+				(long long)t1-t0);
+	buffer += sprintf(buffer, "%-25s:%20Ld\n", "rq-wait_runtime",
+				(long long)this_rq->wait_runtime);
+	buffer += sprintf(buffer, "%-25s:%20Ld\n", "rq-fair_clock",
+				(long long)this_rq->fair_clock);
+	buffer += sprintf(buffer, "%-25s:%20Ld\n", "rq-clock",
+				(long long)this_rq->clock);
+	buffer += sprintf(buffer, "%-25s:%20Ld\n", "rq-prev_clock_raw",
+				(long long)this_rq->prev_clock_raw);
+	buffer += sprintf(buffer, "%-25s:%20Ld\n", "rq-clock_max_delta",
+				(long long)this_rq->clock_max_delta);
+	buffer += sprintf(buffer, "%-25s:%20u\n", "rq-clock_warps",
+				this_rq->clock_warps);
+	buffer += sprintf(buffer, "%-25s:%20u\n", "rq-clock_unstable_events",
+				this_rq->clock_unstable_events);
 	return buffer;
 }
 
diff -puN kernel/sched_debug.c~cfs-v7-fix-sched-debug-warnings kernel/sched_debug.c
--- linux-2.6.21/kernel/sched_debug.c~cfs-v7-fix-sched-debug-warnings	2007-05-01 09:55:14.000000000 +0530
+++ linux-2.6.21-balbir/kernel/sched_debug.c	2007-05-01 09:55:14.000000000 +0530
@@ -45,13 +45,13 @@ print_task(struct seq_file *m, struct rq
 	SEQ_printf(m, "%14s %5d %12Ld %11Ld %10Ld %9Ld %5d "
 		      "%13Ld %13Ld %13Ld\n",
 		p->comm, p->pid,
-		p->fair_key, p->fair_key - rq->fair_clock,
-		p->wait_runtime,
-		p->nr_switches,
+		(long long)p->fair_key, (long long)p->fair_key - rq->fair_clock,
+		(long long)p->wait_runtime,
+		(long long)p->nr_switches,
 		p->prio,
-		p->wait_start_fair - rq->fair_clock,
-		p->sum_exec_runtime,
-		p->sum_wait_runtime);
+		(long long)p->wait_start_fair - rq->fair_clock,
+		(long long)p->sum_exec_runtime,
+		(long long)p->sum_wait_runtime);
 }
 
 static void print_rq(struct seq_file *m, struct rq *rq, u64 now)
@@ -83,7 +83,7 @@ static void print_cpu(struct seq_file *m
 
 	SEQ_printf(m, "\ncpu: %d\n", cpu);
 #define P(x) \
-	SEQ_printf(m, "  .%-22s: %Ld\n", #x, (u64)(rq->x))
+	SEQ_printf(m, "  .%-22s: %Lu\n", #x, (unsigned long long)(rq->x))
 
 	P(nr_running);
 	P(raw_weighted_load);
@@ -110,7 +110,7 @@ static int sched_debug_show(struct seq_f
 	int cpu;
 
 	SEQ_printf(m, "Sched Debug Version: v0.02\n");
-	SEQ_printf(m, "now at %Ld nsecs\n", (unsigned long long)now);
+	SEQ_printf(m, "now at %Lu nsecs\n", (unsigned long long)now);
 
 	for_each_online_cpu(cpu)
 		print_cpu(m, cpu, now);
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL

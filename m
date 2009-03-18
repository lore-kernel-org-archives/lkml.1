Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbZCRAGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbZCRAGO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 20:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbZCRAF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 20:05:58 -0400
Received: from relay4.ptmail.sapo.pt ([212.55.154.24]:51156 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751767AbZCRAF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 20:05:57 -0400
X-AntiVirus: PTMail-AV 0.3-0.92.0
Date: Wed, 18 Mar 2009 00:03:43 +0000
From: Luis Henriques <henrix@sapo.pt>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2 -tip] sched: Clean unused fields from struct rq
Message-ID: <20090318000343.GA2189@hades.domain.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since they are used on in statistics and are always set to zero, the following
frields from struct rq have been removed: yld_exp_empty, yld_act_empty and
yld_both_empty.

Signed-off-by: Luis Henriques <henrix@sapo.pt>
---
 kernel/sched.c       |    3 ---
 kernel/sched_debug.c |    3 ---
 kernel/sched_stats.h |    5 ++---
 3 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 4000304..289eac2 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -646,9 +646,6 @@ struct rq {
 	/* could above be rq->cfs_rq.exec_clock + rq->rt_rq.rt_runtime ? */
 
 	/* sys_sched_yield() stats */
-	unsigned int yld_exp_empty;
-	unsigned int yld_act_empty;
-	unsigned int yld_both_empty;
 	unsigned int yld_count;
 
 	/* schedule() stats */
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 2b1260f..1f16606 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -287,9 +287,6 @@ static void print_cpu(struct seq_file *m, int cpu)
 #ifdef CONFIG_SCHEDSTATS
 #define P(n) SEQ_printf(m, "  .%-30s: %d\n", #n, rq->n);
 
-	P(yld_exp_empty);
-	P(yld_act_empty);
-	P(yld_both_empty);
 	P(yld_count);
 
 	P(sched_switch);
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index a8f93dd..2e7287a 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -26,9 +26,8 @@ static int show_schedstat(struct seq_file *seq, void *v)
 
 		/* runqueue-specific stats */
 		seq_printf(seq,
-		    "cpu%d %u %u %u %u %u %u %u %u %u %llu %llu %lu",
-		    cpu, rq->yld_both_empty,
-		    rq->yld_act_empty, rq->yld_exp_empty, rq->yld_count,
+		    "cpu%d %u %u %u %u %u %u %llu %llu %lu",
+		    cpu, rq->yld_count,
 		    rq->sched_switch, rq->sched_count, rq->sched_goidle,
 		    rq->ttwu_count, rq->ttwu_local,
 		    rq->rq_cpu_time,
-- 
1.6.2


-- 
Luis Henriques

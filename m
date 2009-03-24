Return-Path: <linux-kernel-owner+w=401wt.eu-S1755020AbZCXWTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbZCXWTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 18:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867AbZCXWTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 18:19:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:44856 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976AbZCXWTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 18:19:08 -0400
Date: Tue, 24 Mar 2009 22:18:30 GMT
From: Luis Henriques <henrix@sapo.pt>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, henrix@sapo.pt, ghaskins@novell.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peterz@infradead.org, henrix@sapo.pt, tglx@linutronix.de,
       ghaskins@novell.com, mingo@elte.hu
In-Reply-To: <20090324221002.GA10061@hades.domain.com>
References: <20090324221002.GA10061@hades.domain.com>
Subject: [tip:sched/cleanups] sched: remove unused fields from struct rq
Message-ID: <tip-67aa0f767af488a7f1e41cccb4f7a4893f24a1ab@git.kernel.org>
Git-Commit-ID: 67aa0f767af488a7f1e41cccb4f7a4893f24a1ab
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Mar 2009 22:18:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  67aa0f767af488a7f1e41cccb4f7a4893f24a1ab
Gitweb:     http://git.kernel.org/tip/67aa0f767af488a7f1e41cccb4f7a4893f24a1ab
Author:     Luis Henriques <henrix@sapo.pt>
AuthorDate: Tue, 24 Mar 2009 22:10:02 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 24 Mar 2009 23:16:51 +0100

sched: remove unused fields from struct rq

Impact: cleanup, new schedstat ABI

Since they are used on in statistics and are always set to zero, the
following fields from struct rq have been removed: yld_exp_empty,
yld_act_empty and yld_both_empty.

Both Sched Debug and SCHEDSTAT_VERSION versions has also been
incremented since ABIs have been changed.

The schedtop tool has been updated to properly handle new version of
schedstat:

   http://rt.wiki.kernel.org/index.php/Schedtop_utility

Signed-off-by: Luis Henriques <henrix@sapo.pt>
Acked-by: Gregory Haskins <ghaskins@novell.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20090324221002.GA10061@hades.domain.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c       |    3 ---
 kernel/sched_debug.c |    5 +----
 kernel/sched_stats.h |    7 +++----
 3 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index d2dfe4c..7b389c7 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -638,9 +638,6 @@ struct rq {
 	/* could above be rq->cfs_rq.exec_clock + rq->rt_rq.rt_runtime ? */
 
 	/* sys_sched_yield() stats */
-	unsigned int yld_exp_empty;
-	unsigned int yld_act_empty;
-	unsigned int yld_both_empty;
 	unsigned int yld_count;
 
 	/* schedule() stats */
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 4daebff..467ca72 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -286,9 +286,6 @@ static void print_cpu(struct seq_file *m, int cpu)
 #ifdef CONFIG_SCHEDSTATS
 #define P(n) SEQ_printf(m, "  .%-30s: %d\n", #n, rq->n);
 
-	P(yld_exp_empty);
-	P(yld_act_empty);
-	P(yld_both_empty);
 	P(yld_count);
 
 	P(sched_switch);
@@ -313,7 +310,7 @@ static int sched_debug_show(struct seq_file *m, void *v)
 	u64 now = ktime_to_ns(ktime_get());
 	int cpu;
 
-	SEQ_printf(m, "Sched Debug Version: v0.08, %s %.*s\n",
+	SEQ_printf(m, "Sched Debug Version: v0.09, %s %.*s\n",
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
 		init_utsname()->version);
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index a8f93dd..32d2bd4 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -4,7 +4,7 @@
  * bump this up when changing the output format or the meaning of an existing
  * format, so that tools can adapt (or abort)
  */
-#define SCHEDSTAT_VERSION 14
+#define SCHEDSTAT_VERSION 15
 
 static int show_schedstat(struct seq_file *seq, void *v)
 {
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

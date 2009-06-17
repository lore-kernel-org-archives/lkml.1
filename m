Return-Path: <linux-kernel-owner+w=401wt.eu-S1757609AbZFQQeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609AbZFQQeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754469AbZFQQeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:34:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:42323 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbZFQQeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:34:07 -0400
Date: Wed, 17 Jun 2009 16:33:33 GMT
From: tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       mitake@dcl.info.waseda.ac.jp, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       mitake@dcl.info.waseda.ac.jp, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090617.222055.374768827975756908.mitake@dcl.info.waseda.ac.jp>
References: <20090617.222055.374768827975756908.mitake@dcl.info.waseda.ac.jp>
Subject: [tip:sched/urgent] sched: Hide runqueues from direct refer at source code level
Message-ID: <tip-348ec61e6268c3cd7ee75cfa50e408184a941506@git.kernel.org>
Git-Commit-ID: 348ec61e6268c3cd7ee75cfa50e408184a941506
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 16:33:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  348ec61e6268c3cd7ee75cfa50e408184a941506
Gitweb:     http://git.kernel.org/tip/348ec61e6268c3cd7ee75cfa50e408184a941506
Author:     Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
AuthorDate: Wed, 17 Jun 2009 22:20:55 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 17 Jun 2009 18:29:42 +0200

sched: Hide runqueues from direct refer at source code level

There are some points which refer the per-cpu value "runqueues" directly.
sched.c provides nice abstraction, such as cpu_rq() and this_rq(),
so we should use these macros when looking runqueues.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
LKML-Reference: <20090617.222055.374768827975756908.mitake@dcl.info.waseda.ac.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched_debug.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 467ca72..70c7e0b 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -162,7 +162,7 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 {
 	s64 MIN_vruntime = -1, min_vruntime, max_vruntime = -1,
 		spread, rq0_min_vruntime, spread0;
-	struct rq *rq = &per_cpu(runqueues, cpu);
+	struct rq *rq = cpu_rq(cpu);
 	struct sched_entity *last;
 	unsigned long flags;
 
@@ -191,7 +191,7 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 	if (last)
 		max_vruntime = last->vruntime;
 	min_vruntime = cfs_rq->min_vruntime;
-	rq0_min_vruntime = per_cpu(runqueues, 0).cfs.min_vruntime;
+	rq0_min_vruntime = cpu_rq(0)->cfs.min_vruntime;
 	spin_unlock_irqrestore(&rq->lock, flags);
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "MIN_vruntime",
 			SPLIT_NS(MIN_vruntime));
@@ -248,7 +248,7 @@ void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq)
 
 static void print_cpu(struct seq_file *m, int cpu)
 {
-	struct rq *rq = &per_cpu(runqueues, cpu);
+	struct rq *rq = cpu_rq(cpu);
 
 #ifdef CONFIG_X86
 	{

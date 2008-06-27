Return-Path: <linux-kernel-owner+w=401wt.eu-S1757333AbYF0L6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333AbYF0L6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 07:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754591AbYF0L5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:57:54 -0400
Received: from viefep32-int.chello.at ([62.179.121.50]:47493 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbYF0L5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:57:52 -0400
Message-Id: <20080627115211.359635737@chello.nl>
References: <20080627114109.724249622@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:41:17 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 08/30] sched: add full schedstats to /proc/sched_debug
Content-Disposition: inline; filename=sched-debug-schedstat.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

show all the schedstats in /debug/sched_debug as well.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_debug.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/sched_debug.c
===================================================================
--- linux-2.6.orig/kernel/sched_debug.c
+++ linux-2.6/kernel/sched_debug.c
@@ -162,8 +162,23 @@ void print_cfs_rq(struct seq_file *m, in
 	SEQ_printf(m, "  .%-30s: %ld\n", "nr_running", cfs_rq->nr_running);
 	SEQ_printf(m, "  .%-30s: %ld\n", "load", cfs_rq->load.weight);
 #ifdef CONFIG_SCHEDSTATS
-	SEQ_printf(m, "  .%-30s: %d\n", "bkl_count",
-			rq->bkl_count);
+#define P(n) SEQ_printf(m, "  .%-30s: %d\n", #n, rq->n);
+
+	P(yld_exp_empty);
+	P(yld_act_empty);
+	P(yld_both_empty);
+	P(yld_count);
+
+	P(sched_switch);
+	P(sched_count);
+	P(sched_goidle);
+
+	P(ttwu_count);
+	P(ttwu_local);
+
+	P(bkl_count);
+
+#undef P
 #endif
 	SEQ_printf(m, "  .%-30s: %ld\n", "nr_spread_over",
 			cfs_rq->nr_spread_over);

-- 


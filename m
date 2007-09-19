Return-Path: <linux-kernel-owner+w=401wt.eu-S1758002AbXISKvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002AbXISKvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 06:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756879AbXISKvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 06:51:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756431AbXISKvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 06:51:05 -0400
Message-Id: <20070919105055.091184000@chello.nl>
References: <20070919104125.286538000@chello.nl>
User-Agent: quilt/0.45-1
Date: Wed, 19 Sep 2007 12:41:30 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: [RFC][PATCH 5/6] fixup funny preemption tricks in irq_exit
Content-Disposition: inline; filename=preempt-fixup-irq-exit.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/softirq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/kernel/softirq.c
===================================================================
--- linux-2.6.orig/kernel/softirq.c
+++ linux-2.6/kernel/softirq.c
@@ -312,7 +312,7 @@ void irq_exit(void)
 	if (!in_interrupt() && idle_cpu(smp_processor_id()) && !need_resched())
 		tick_nohz_stop_sched_tick();
 #endif
-	preempt_enable_no_resched();
+	_preempt_enable_no_resched();
 }
 
 /*

--


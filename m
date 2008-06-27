Return-Path: <linux-kernel-owner+w=401wt.eu-S1759275AbYF0MBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275AbYF0MBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756346AbYF0L6C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:58:02 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:54151 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbYF0L5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:57:55 -0400
Message-Id: <20080627115212.217220463@chello.nl>
References: <20080627114109.724249622@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:41:34 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 25/30] sched: fix shares boost logic
Content-Disposition: inline; filename=sched-fixup-tg_shares_up.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case the domain is empty, pretend there is a single task on each cpu, so
that together with the boost logic we end up giving 1/n shares to each
cpu.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -1543,6 +1543,9 @@ tg_shares_up(struct task_group *tg, int 
 	if (!sd->parent || !(sd->parent->flags & SD_LOAD_BALANCE))
 		shares = tg->shares;
 
+	if (!rq_weight)
+		rq_weight = cpus_weight(sd->span) * NICE_0_LOAD;
+
 	for_each_cpu_mask(i, sd->span) {
 		struct rq *rq = cpu_rq(i);
 		unsigned long flags;

-- 


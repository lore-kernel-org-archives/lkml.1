Return-Path: <linux-kernel-owner+w=401wt.eu-S1762931AbXLRSUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762931AbXLRSUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 13:20:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758154AbXLRSUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 13:20:20 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58939 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573AbXLRSUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 13:20:16 -0500
Message-Id: <20071218174428.481724000@chello.nl>
References: <20071218174120.711901000@chello.nl>
User-Agent: quilt/0.45-1
Date: Tue, 18 Dec 2007 18:41:21 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/3] sched: rt: account the cpu time during the tick
Content-Disposition: inline; filename=sched-rt-update.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Realtime tasks would not account their runtime during ticks. Which would lead
to:

        struct sched_param param = { .sched_priority = 10 };
        pthread_setschedparam(pthread_self(), SCHED_FIFO, &param);

	while (1) ;

Not showing up in top.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_rt.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -837,6 +837,8 @@ static void prio_changed_rt(struct rq *r
 
 static void task_tick_rt(struct rq *rq, struct task_struct *p)
 {
+	update_curr_rt(rq);
+
 	/*
 	 * RR tasks need a special form of timeslice management.
 	 * FIFO tasks have no timeslices.

--


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753523Ab0A2G6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab0A2G6t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 01:58:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785Ab0A2G6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 01:58:48 -0500
Received: from mail-pz0-f189.google.com ([209.85.222.189]:35779 "EHLO
	mail-pz0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab0A2G6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 01:58:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=CDxnMZVMD2HwkXrLr8RrmSWlcOYjHuRc/2Xwz8XTH2ujS7qKYlS5dLlFCdx83cndMi
         4R558/Z8yWyhgd8wSI2Lk0XppK+7dSiIJF4+ovAlJZtt5evSFN4P2gN64XomJAdZmYVB
         8O3VNccnVh4TCq9h3Wc8j+WZxv9Shi7pUePec=
MIME-Version: 1.0
Date: Fri, 29 Jan 2010 14:58:47 +0800
Message-ID: <2674af741001282258q38781619u653ca4a7dd267347@mail.gmail.com>
Subject: [RFC PATCH 2/2] sched: remove member rt_se from struct rt_rq
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, rusty <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's a duplicate of tg->rt_se[cpu] and the only usage is
sched_rt_rq_dequeue() and sched_rt_rq_enqueue(). After the
first patch to those two function. rt_se can be removed.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/sched.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 4508fe7..dc04041 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -478,7 +478,6 @@ struct rt_rq {
 	struct rq *rq;
 	struct list_head leaf_rt_rq_list;
 	struct task_group *tg;
-	struct sched_rt_entity *rt_se;
 #endif
 };

@@ -9437,7 +9436,6 @@ static void init_tg_rt_entry(struct task_group
*tg, struct rt_rq *rt_rq,
 	tg->rt_rq[cpu] = rt_rq;
 	init_rt_rq(rt_rq, rq);
 	rt_rq->tg = tg;
-	rt_rq->rt_se = rt_se;
 	rt_rq->rt_runtime = tg->rt_bandwidth.rt_runtime;
 	if (add)
 		list_add(&rt_rq->leaf_rt_rq_list, &rq->leaf_rt_rq_list);
-- 
1.6.3.3

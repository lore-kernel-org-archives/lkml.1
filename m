Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115Ab0BDJ5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 04:57:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:60132 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758003Ab0BDJ5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 04:57:15 -0500
Date: Thu, 4 Feb 2010 09:56:26 GMT
From: tip-bot for Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, rusty@rustcorp.com.au, yong.zhang0@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       yong.zhang0@gmail.com, mingo@elte.hu
In-Reply-To: <2674af741001282258q38781619u653ca4a7dd267347@mail.gmail.com>
References: <2674af741001282258q38781619u653ca4a7dd267347@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove member rt_se from struct rt_rq
Message-ID: <tip-23577256953c870de9b724c3a2611ce7be6a1e4e@git.kernel.org>
Git-Commit-ID: 23577256953c870de9b724c3a2611ce7be6a1e4e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Feb 2010 09:56:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  23577256953c870de9b724c3a2611ce7be6a1e4e
Gitweb:     http://git.kernel.org/tip/23577256953c870de9b724c3a2611ce7be6a1e4e
Author:     Yong Zhang <yong.zhang0@gmail.com>
AuthorDate: Fri, 29 Jan 2010 14:58:47 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Feb 2010 09:57:33 +0100

sched: Remove member rt_se from struct rt_rq

It's a duplicate of tg->rt_se[cpu] and the only usage is
sched_rt_rq_dequeue() and sched_rt_rq_enqueue(). After the
first patch to those two function. rt_se can be removed.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <2674af741001282258q38781619u653ca4a7dd267347@mail.gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 2386f54..6cee227 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -436,7 +436,6 @@ struct rt_rq {
 	struct rq *rq;
 	struct list_head leaf_rt_rq_list;
 	struct task_group *tg;
-	struct sched_rt_entity *rt_se;
 #endif
 };
 
@@ -7592,7 +7591,6 @@ static void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
 	tg->rt_rq[cpu] = rt_rq;
 	init_rt_rq(rt_rq, rq);
 	rt_rq->tg = tg;
-	rt_rq->rt_se = rt_se;
 	rt_rq->rt_runtime = tg->rt_bandwidth.rt_runtime;
 	if (add)
 		list_add(&rt_rq->leaf_rt_rq_list, &rq->leaf_rt_rq_list);

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab0CKJ74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 04:59:56 -0500
Received: from mail.gmx.net ([213.165.64.20]:48879 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755302Ab0CKJ7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 04:59:54 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18QmSZt1+MQldSWJR59JWvNpID7B+XNYkpfhRPRJP
	obMvmmBXSVzo0V
Subject: Re: [patch 9/12] sched: remove WAKEUP_SYNC feature
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1268300950.6785.27.camel@marge.simson.net>
References: <1268300950.6785.27.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 11 Mar 2010 10:59:51 +0100
Message-Id: <1268301591.6785.42.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46000000000000002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sched: remove WAKEUP_SYNC feature

This feature never earned it's keep, remove it.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 kernel/sched_fair.c     |    4 ----
 kernel/sched_features.h |    5 -----
 2 files changed, 9 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1657,7 +1657,6 @@ static void check_preempt_wakeup(struct
 	struct task_struct *curr = rq->curr;
 	struct sched_entity *se = &curr->se, *pse = &p->se;
 	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
-	int sync = wake_flags & WF_SYNC;
 	int scale = cfs_rq->nr_running >= sched_nr_latency;
 
 	if (unlikely(rt_prio(p->prio)))
@@ -1690,9 +1689,6 @@ static void check_preempt_wakeup(struct
 	if (unlikely(curr->policy == SCHED_IDLE))
 		goto preempt;
 
-	if (sched_feat(WAKEUP_SYNC) && sync)
-		goto preempt;
-
 	if (!sched_feat(WAKEUP_PREEMPT))
 		return;
 
Index: linux-2.6/kernel/sched_features.h
===================================================================
--- linux-2.6.orig/kernel/sched_features.h
+++ linux-2.6/kernel/sched_features.h
@@ -23,11 +23,6 @@ SCHED_FEAT(WAKEUP_PREEMPT, 1)
 SCHED_FEAT(ASYM_GRAN, 1)
 
 /*
- * Always wakeup-preempt SYNC wakeups, see SYNC_WAKEUPS.
- */
-SCHED_FEAT(WAKEUP_SYNC, 0)
-
-/*
  * Use the SYNC wakeup hint, pipes and the likes use this to indicate
  * the remote end is likely to consume the data we just wrote, and
  * therefore has cache benefit from being placed on the same cpu, see



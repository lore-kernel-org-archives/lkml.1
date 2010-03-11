Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab0CKKDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 05:03:42 -0500
Received: from mail.gmx.net ([213.165.64.20]:54108 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756420Ab0CKKDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 05:03:40 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18RzER+oXsRBLOE+K0nfv1Ol9Vp6mxazM7Y7Z0EqY
	31+Wtt/y99S7Ru
Subject: Re: [patch 10/12] sched: remove SYNC_WAKEUPS feature
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1268300950.6785.27.camel@marge.simson.net>
References: <1268300950.6785.27.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 11 Mar 2010 11:03:37 +0100
Message-Id: <1268301817.6785.47.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sched: remove SYNC_WAKEUPS feature

Sync wakeups are critical functionality with a long history.  Remove it, we don't
need the branch or icache footprint.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 kernel/sched.c          |    3 ---
 kernel/sched_features.h |    8 --------
 2 files changed, 11 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2369,9 +2369,6 @@ static int try_to_wake_up(struct task_st
 	unsigned long flags;
 	struct rq *rq, *orig_rq;
 
-	if (!sched_feat(SYNC_WAKEUPS))
-		wake_flags &= ~WF_SYNC;
-
 	this_cpu = get_cpu();
 
 	smp_wmb();
Index: linux-2.6/kernel/sched_features.h
===================================================================
--- linux-2.6.orig/kernel/sched_features.h
+++ linux-2.6/kernel/sched_features.h
@@ -17,14 +17,6 @@ SCHED_FEAT(START_DEBIT, 1)
 SCHED_FEAT(WAKEUP_PREEMPT, 1)
 
 /*
- * Use the SYNC wakeup hint, pipes and the likes use this to indicate
- * the remote end is likely to consume the data we just wrote, and
- * therefore has cache benefit from being placed on the same cpu, see
- * also AFFINE_WAKEUPS.
- */
-SCHED_FEAT(SYNC_WAKEUPS, 1)
-
-/*
  * Based on load and program behaviour, see if it makes sense to place
  * a newly woken task on the same cpu as the task that woke it --
  * improve cache locality. Typically used with SYNC wakeups as



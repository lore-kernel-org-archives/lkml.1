Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab0CKJ6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 04:58:50 -0500
Received: from mail.gmx.net ([213.165.64.20]:57541 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755746Ab0CKJ6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 04:58:48 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+m7C4bLT2mdOSW1OJFV0ZAnXwDsSFTH9ysiHTXv9
	mG2BXmFMcZtpp6
Subject: Re: [patch 8/12] sched: remove FAIR_SLEEPERS feature
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1268300950.6785.27.camel@marge.simson.net>
References: <1268300950.6785.27.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 11 Mar 2010 10:58:40 +0100
Message-Id: <1268301520.6785.40.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.52000000000000002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sched: remove FAIR_SLEEPERS feature

Our preemption model relies too heavily on sleeper fairness to disable it
without dire consequences.  Remove the feature, and save a branch or two.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 kernel/sched_fair.c     |    2 +-
 kernel/sched_features.h |    7 -------
 2 files changed, 1 insertion(+), 8 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -737,7 +737,7 @@ place_entity(struct cfs_rq *cfs_rq, stru
 		vruntime += sched_vslice(cfs_rq, se);
 
 	/* sleeps up to a single latency don't count. */
-	if (!initial && sched_feat(FAIR_SLEEPERS)) {
+	if (!initial) {
 		unsigned long thresh = sysctl_sched_latency;
 
 		/*
Index: linux-2.6/kernel/sched_features.h
===================================================================
--- linux-2.6.orig/kernel/sched_features.h
+++ linux-2.6/kernel/sched_features.h
@@ -1,11 +1,4 @@
 /*
- * Disregards a certain amount of sleep time (sched_latency_ns) and
- * considers the task to be running during that period. This gives it
- * a service deficit on wakeup, allowing it to run sooner.
- */
-SCHED_FEAT(FAIR_SLEEPERS, 1)
-
-/*
  * Only give sleepers 50% of their service deficit. This allows
  * them to run sooner, but does not allow tons of sleepers to
  * rip the spread apart.



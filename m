Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433Ab0CKJ5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 04:57:32 -0500
Received: from mail.gmx.net ([213.165.64.20]:60125 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755285Ab0CKJ5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 04:57:31 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19Wwmh0B75WTjiBPKTVO814s2Oswo0EWijkjo+hJd
	fH4Bqpgg0UJzMN
Subject: Re: [patch 7/12] sched: remove NORMALIZED_SLEEPER
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1268300950.6785.27.camel@marge.simson.net>
References: <1268300950.6785.27.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 11 Mar 2010 10:57:27 +0100
Message-Id: <1268301447.6785.38.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sched: remove NORMALIZED_SLEEPER

This feature hasn't been enabled in a long time, remove effectively dead code.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 kernel/sched_fair.c     |   10 ----------
 kernel/sched_features.h |    7 -------
 2 files changed, 17 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -741,16 +741,6 @@ place_entity(struct cfs_rq *cfs_rq, stru
 		unsigned long thresh = sysctl_sched_latency;
 
 		/*
-		 * Convert the sleeper threshold into virtual time.
-		 * SCHED_IDLE is a special sub-class.  We care about
-		 * fairness only relative to other SCHED_IDLE tasks,
-		 * all of which have the same weight.
-		 */
-		if (sched_feat(NORMALIZED_SLEEPER) && (!entity_is_task(se) ||
-				 task_of(se)->policy != SCHED_IDLE))
-			thresh = calc_delta_fair(thresh, se);
-
-		/*
 		 * Halve their sleep time's effect, to allow
 		 * for a gentler effect of sleepers:
 		 */
Index: linux-2.6/kernel/sched_features.h
===================================================================
--- linux-2.6.orig/kernel/sched_features.h
+++ linux-2.6/kernel/sched_features.h
@@ -13,13 +13,6 @@ SCHED_FEAT(FAIR_SLEEPERS, 1)
 SCHED_FEAT(GENTLE_FAIR_SLEEPERS, 1)
 
 /*
- * By not normalizing the sleep time, heavy tasks get an effective
- * longer period, and lighter task an effective shorter period they
- * are considered running.
- */
-SCHED_FEAT(NORMALIZED_SLEEPER, 0)
-
-/*
  * Place new tasks ahead so that they do not starve already running
  * tasks
  */



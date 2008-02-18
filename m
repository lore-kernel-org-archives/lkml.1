Return-Path: <linux-kernel-owner+w=401wt.eu-S1759278AbYBRKCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278AbYBRKCE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 05:02:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757357AbYBRJ7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 04:59:31 -0500
Received: from viefep11-int.chello.at ([62.179.121.31]:52846 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757315AbYBRJ7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 04:59:30 -0500
Message-Id: <20080218095624.336501000@chello.nl>
References: <20080218095535.629736000@chello.nl>
User-Agent: quilt/0.45-1
Date: Mon, 18 Feb 2008 10:55:36 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       dhaval@linux.vnet.ibm.com, tong.n.li@intel.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/7] sched: cleanup old and rarely used debug features.
Content-Disposition: inline; filename=sched-fair-clean-up.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TREE_AVG and APPROX_AVG are initial task placement policies that have been
disabled for a long while.. time to remove them.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c      |    8 ++------
 kernel/sched_fair.c |   14 --------------
 2 files changed, 2 insertions(+), 20 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -717,18 +717,14 @@ enum {
 	SCHED_FEAT_NEW_FAIR_SLEEPERS	= 1,
 	SCHED_FEAT_WAKEUP_PREEMPT	= 2,
 	SCHED_FEAT_START_DEBIT		= 4,
-	SCHED_FEAT_TREE_AVG		= 8,
-	SCHED_FEAT_APPROX_AVG		= 16,
-	SCHED_FEAT_HRTICK		= 32,
-	SCHED_FEAT_DOUBLE_TICK		= 64,
+	SCHED_FEAT_HRTICK		= 8,
+	SCHED_FEAT_DOUBLE_TICK		= 16,
 };
 
 const_debug unsigned int sysctl_sched_features =
 		SCHED_FEAT_NEW_FAIR_SLEEPERS	* 1 |
 		SCHED_FEAT_WAKEUP_PREEMPT	* 1 |
 		SCHED_FEAT_START_DEBIT		* 1 |
-		SCHED_FEAT_TREE_AVG		* 0 |
-		SCHED_FEAT_APPROX_AVG		* 0 |
 		SCHED_FEAT_HRTICK		* 1 |
 		SCHED_FEAT_DOUBLE_TICK		* 0;
 
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -288,11 +288,6 @@ static u64 __sched_vslice(unsigned long 
 	return vslice;
 }
 
-static u64 sched_vslice(struct cfs_rq *cfs_rq)
-{
-	return __sched_vslice(cfs_rq->load.weight, cfs_rq->nr_running);
-}
-
 static u64 sched_vslice_add(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	return __sched_vslice(cfs_rq->load.weight + se->load.weight,
@@ -500,15 +495,6 @@ place_entity(struct cfs_rq *cfs_rq, stru
 
 	vruntime = cfs_rq->min_vruntime;
 
-	if (sched_feat(TREE_AVG)) {
-		struct sched_entity *last = __pick_last_entity(cfs_rq);
-		if (last) {
-			vruntime += last->vruntime;
-			vruntime >>= 1;
-		}
-	} else if (sched_feat(APPROX_AVG) && cfs_rq->nr_running)
-		vruntime += sched_vslice(cfs_rq)/2;
-
 	/*
 	 * The 'current' period is already promised to the current tasks,
 	 * however the extra weight of the new task will slow them down a

--


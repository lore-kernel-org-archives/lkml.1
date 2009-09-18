Return-Path: <linux-kernel-owner+w=401wt.eu-S1755140AbZIRHT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140AbZIRHT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 03:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbZIRHTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 03:19:25 -0400
Received: from mail.gmx.net ([213.165.64.20]:57800 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754527AbZIRHTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 03:19:24 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/Ks/J79czKs12Z6PLCVsxWs0DvW/S03lIuRC9VQP
	ALzLf9FpFfb13C
Subject: [patch] sched: cleanup - remove unneeded indentation in
 sched_fair.c::place_entity()
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 09:19:25 +0200
Message-Id: <1253258365.22787.33.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sched: cleanup - remove unneeded indentation in sched_fair.c::place_entity()

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

 kernel/sched_fair.c |   41 +++++++++++++++++++----------------------
 1 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 990b188..1918b18 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -710,31 +710,28 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 	if (initial && sched_feat(START_DEBIT))
 		vruntime += sched_vslice(cfs_rq, se);
 
-	if (!initial) {
-		/* sleeps upto a single latency don't count. */
-		if (sched_feat(FAIR_SLEEPERS)) {
-			unsigned long thresh = sysctl_sched_latency;
+	/* sleeps up to a single latency don't count. */
+	if (!initial && sched_feat(FAIR_SLEEPERS)) {
+		unsigned long thresh = sysctl_sched_latency;
 
-			/*
-			 * Convert the sleeper threshold into virtual time.
-			 * SCHED_IDLE is a special sub-class.  We care about
-			 * fairness only relative to other SCHED_IDLE tasks,
-			 * all of which have the same weight.
-			 */
-			if (sched_feat(NORMALIZED_SLEEPER) &&
-					(!entity_is_task(se) ||
-					 task_of(se)->policy != SCHED_IDLE))
-				thresh = calc_delta_fair(thresh, se);
+		/*
+		 * Convert the sleeper threshold into virtual time.
+		 * SCHED_IDLE is a special sub-class.  We care about
+		 * fairness only relative to other SCHED_IDLE tasks,
+		 * all of which have the same weight.
+		 */
+		if (sched_feat(NORMALIZED_SLEEPER) && (!entity_is_task(se) ||
+				 task_of(se)->policy != SCHED_IDLE))
+			thresh = calc_delta_fair(thresh, se);
 
-			/*
-			 * Halve their sleep time's effect, to allow
-			 * for a gentler effect of sleepers:
-			 */
-			if (sched_feat(GENTLE_FAIR_SLEEPERS))
-				thresh >>= 1;
+		/*
+		 * Halve their sleep time's effect, to allow
+		 * for a gentler effect of sleepers:
+		 */
+		if (sched_feat(GENTLE_FAIR_SLEEPERS))
+			thresh >>= 1;
 
-			vruntime -= thresh;
-		}
+		vruntime -= thresh;
 	}
 
 	/* ensure we never gain time by being placed backwards. */



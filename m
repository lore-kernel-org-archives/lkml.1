Return-Path: <linux-kernel-owner+w=401wt.eu-S1754651AbZIRHZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbZIRHZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 03:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbZIRHZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 03:25:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:41266 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbZIRHZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 03:25:02 -0400
Date: Fri, 18 Sep 2009 07:24:36 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1253258365.22787.33.camel@marge.simson.net>
References: <1253258365.22787.33.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Remove unneeded indentation in sched_fair.c::place_entity()
Message-ID: <tip-a2e7a7eb2fea109891ffff90f947e8306080a2a3@git.kernel.org>
Git-Commit-ID: a2e7a7eb2fea109891ffff90f947e8306080a2a3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 18 Sep 2009 07:24:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a2e7a7eb2fea109891ffff90f947e8306080a2a3
Gitweb:     http://git.kernel.org/tip/a2e7a7eb2fea109891ffff90f947e8306080a2a3
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Fri, 18 Sep 2009 09:19:25 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 18 Sep 2009 09:22:39 +0200

sched: Remove unneeded indentation in sched_fair.c::place_entity()

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1253258365.22787.33.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched_fair.c |   41 +++++++++++++++++++----------------------
 1 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 10d218a..29b35a7 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -709,31 +709,28 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
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

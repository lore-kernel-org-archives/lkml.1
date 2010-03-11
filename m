Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab0CKSc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:32:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:40892 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756201Ab0CKScw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:32:52 -0500
Date: Thu, 11 Mar 2010 18:32:17 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1268301447.6785.38.camel@marge.simson.net>
References: <1268301447.6785.38.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove NORMALIZED_SLEEPER
Message-ID: <tip-6bc6cf2b61336ed0c55a615eb4c0c8ed5daf3f08@git.kernel.org>
Git-Commit-ID: 6bc6cf2b61336ed0c55a615eb4c0c8ed5daf3f08
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Mar 2010 18:32:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6bc6cf2b61336ed0c55a615eb4c0c8ed5daf3f08
Gitweb:     http://git.kernel.org/tip/6bc6cf2b61336ed0c55a615eb4c0c8ed5daf3f08
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Thu, 11 Mar 2010 17:17:17 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 11 Mar 2010 18:32:52 +0100

sched: Remove NORMALIZED_SLEEPER

This feature hasn't been enabled in a long time, remove effectively dead code.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1268301447.6785.38.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c     |   10 ----------
 kernel/sched_features.h |    7 -------
 2 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 0008cc4..de98e2e 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -742,16 +742,6 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
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
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index c545e04..4042883 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
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

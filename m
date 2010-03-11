Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992Ab0CKSdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:33:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:37090 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756844Ab0CKSdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:33:37 -0500
Date: Thu, 11 Mar 2010 18:32:49 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1268301591.6785.42.camel@marge.simson.net>
References: <1268301591.6785.42.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove WAKEUP_SYNC feature
Message-ID: <tip-f2e74eeac03ffb779d64b66a643c5e598145a28b@git.kernel.org>
Git-Commit-ID: f2e74eeac03ffb779d64b66a643c5e598145a28b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Mar 2010 18:32:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f2e74eeac03ffb779d64b66a643c5e598145a28b
Gitweb:     http://git.kernel.org/tip/f2e74eeac03ffb779d64b66a643c5e598145a28b
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Thu, 11 Mar 2010 17:17:18 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 11 Mar 2010 18:32:52 +0100

sched: Remove WAKEUP_SYNC feature

This feature never earned its keep, remove it.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1268301591.6785.42.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c     |    4 ----
 kernel/sched_features.h |    5 -----
 2 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 97682f9..1d99535 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1658,7 +1658,6 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	struct task_struct *curr = rq->curr;
 	struct sched_entity *se = &curr->se, *pse = &p->se;
 	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
-	int sync = wake_flags & WF_SYNC;
 	int scale = cfs_rq->nr_running >= sched_nr_latency;
 
 	if (unlikely(rt_prio(p->prio)))
@@ -1691,9 +1690,6 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	if (unlikely(curr->policy == SCHED_IDLE))
 		goto preempt;
 
-	if (sched_feat(WAKEUP_SYNC) && sync)
-		goto preempt;
-
 	if (!sched_feat(WAKEUP_PREEMPT))
 		return;
 
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index 850f980..1cb7c47 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
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

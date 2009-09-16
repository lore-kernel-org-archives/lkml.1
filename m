Return-Path: <linux-kernel-owner+w=401wt.eu-S1759256AbZIPPKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759256AbZIPPKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 11:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759249AbZIPPKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 11:10:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:39026 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759229AbZIPPKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 11:10:39 -0400
Date: Wed, 16 Sep 2009 15:10:07 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Rename flags to wake_flags
Message-ID: <tip-5a9b86f647a56862cdc0a1362bfb015ae921af7f@git.kernel.org>
Git-Commit-ID: 5a9b86f647a56862cdc0a1362bfb015ae921af7f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 15:10:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5a9b86f647a56862cdc0a1362bfb015ae921af7f
Gitweb:     http://git.kernel.org/tip/5a9b86f647a56862cdc0a1362bfb015ae921af7f
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 16 Sep 2009 13:47:58 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Sep 2009 16:44:33 +0200

sched: Rename flags to wake_flags

For consistencies sake, rename the argument (again).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched_fair.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index aeff40e..c741cd9 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1551,12 +1551,12 @@ static void set_next_buddy(struct sched_entity *se)
 /*
  * Preempt the current task with a newly woken task if needed:
  */
-static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int flags)
+static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
 {
 	struct task_struct *curr = rq->curr;
 	struct sched_entity *se = &curr->se, *pse = &p->se;
 	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
-	int sync = flags & WF_SYNC;
+	int sync = wake_flags & WF_SYNC;
 
 	update_curr(cfs_rq);
 
@@ -1582,7 +1582,7 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int flags
 	 */
 	if (sched_feat(LAST_BUDDY) && likely(se->on_rq && curr != rq->idle))
 		set_last_buddy(se);
-	if (sched_feat(NEXT_BUDDY) && !(flags & WF_FORK))
+	if (sched_feat(NEXT_BUDDY) && !(wake_flags & WF_FORK))
 		set_next_buddy(pse);
 
 	/*

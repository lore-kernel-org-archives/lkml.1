Return-Path: <linux-kernel-owner+w=401wt.eu-S1756931AbZIPKT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931AbZIPKT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbZIPKTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:19:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:46318 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756809AbZIPKTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:19:54 -0400
Date: Wed, 16 Sep 2009 10:19:31 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Complete buddy switches
Message-ID: <tip-3cb63d527f76e25dbccce4f577f21aecfa2abac7@git.kernel.org>
Git-Commit-ID: 3cb63d527f76e25dbccce4f577f21aecfa2abac7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 10:19:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3cb63d527f76e25dbccce4f577f21aecfa2abac7
Gitweb:     http://git.kernel.org/tip/3cb63d527f76e25dbccce4f577f21aecfa2abac7
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Fri, 11 Sep 2009 12:01:17 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Sep 2009 16:01:02 +0200

sched: Complete buddy switches

Add a NEXT_BUDDY feature flag to aid in debugging.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched_fair.c     |    3 ++-
 kernel/sched_features.h |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index cea5b82..4f6356e 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1501,7 +1501,8 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int sync)
 	 */
 	if (sched_feat(LAST_BUDDY) && likely(se->on_rq && curr != rq->idle))
 		set_last_buddy(se);
-	set_next_buddy(pse);
+	if (sched_feat(NEXT_BUDDY))
+		set_next_buddy(pse);
 
 	/*
 	 * We can come here with TIF_NEED_RESCHED already set from new task
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index 07c8250..6174c12 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -14,5 +14,6 @@ SCHED_FEAT(LB_WAKEUP_UPDATE, 1)
 SCHED_FEAT(ASYM_EFF_LOAD, 1)
 SCHED_FEAT(WAKEUP_SYNC, 0)
 SCHED_FEAT(WAKEUP_OVERLAP, 0)
+SCHED_FEAT(NEXT_BUDDY, 1)
 SCHED_FEAT(LAST_BUDDY, 1)
 SCHED_FEAT(OWNER_SPIN, 1)

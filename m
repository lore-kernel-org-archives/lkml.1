Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366Ab0CKSd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:33:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:37100 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756365Ab0CKSdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:33:52 -0500
Date: Thu, 11 Mar 2010 18:33:05 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1268301817.6785.47.camel@marge.simson.net>
References: <1268301817.6785.47.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove SYNC_WAKEUPS feature
Message-ID: <tip-c6ee36c423c3ed1fb86bb3eabba9fc256a300d16@git.kernel.org>
Git-Commit-ID: c6ee36c423c3ed1fb86bb3eabba9fc256a300d16
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Mar 2010 18:33:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c6ee36c423c3ed1fb86bb3eabba9fc256a300d16
Gitweb:     http://git.kernel.org/tip/c6ee36c423c3ed1fb86bb3eabba9fc256a300d16
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Thu, 11 Mar 2010 17:16:43 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 11 Mar 2010 18:32:53 +0100

sched: Remove SYNC_WAKEUPS feature

Sync wakeups are critical functionality with a long history.  Remove it, we don't
need the branch or icache footprint.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1268301817.6785.47.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c          |    3 ---
 kernel/sched_features.h |    8 --------
 2 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 16559de..cc6dc8c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2369,9 +2369,6 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 	unsigned long flags;
 	struct rq *rq;
 
-	if (!sched_feat(SYNC_WAKEUPS))
-		wake_flags &= ~WF_SYNC;
-
 	this_cpu = get_cpu();
 
 	smp_wmb();
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index 1cb7c47..f54b6f9 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -23,14 +23,6 @@ SCHED_FEAT(WAKEUP_PREEMPT, 1)
 SCHED_FEAT(ASYM_GRAN, 1)
 
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

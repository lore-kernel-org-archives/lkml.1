Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528Ab0CKOkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 09:40:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:35386 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932506Ab0CKOj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 09:39:56 -0500
Date: Thu, 11 Mar 2010 14:39:23 GMT
From: tip-bot for Dan Carpenter <error27@gmail.com>
Cc: linux-kernel@vger.kernel.org, ego@in.ibm.com, hpa@zytor.com,
       mingo@redhat.com, andreas.herrmann3@amd.com, peterz@infradead.org,
       error27@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, ego@in.ibm.com,
       linux-kernel@vger.kernel.org, error27@gmail.com,
       andreas.herrmann3@amd.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100306111752.GL4958@bicker>
References: <20100306111752.GL4958@bicker>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Cleanup: remove unused variable in try_to_wake_up()
Message-ID: <tip-ab3b3aa5dd01b3aaa6b15caee113b21b1b6520c4@git.kernel.org>
Git-Commit-ID: ab3b3aa5dd01b3aaa6b15caee113b21b1b6520c4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Mar 2010 14:39:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ab3b3aa5dd01b3aaa6b15caee113b21b1b6520c4
Gitweb:     http://git.kernel.org/tip/ab3b3aa5dd01b3aaa6b15caee113b21b1b6520c4
Author:     Dan Carpenter <error27@gmail.com>
AuthorDate: Sat, 6 Mar 2010 14:17:52 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 11 Mar 2010 13:59:59 +0100

sched: Cleanup: remove unused variable in try_to_wake_up()

We haven't used the "orig_rq" variable since
055a00865d "Fix/add missing update_rq_clock() calls"

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: efault@gmx.de
LKML-Reference: <20100306111752.GL4958@bicker>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 6a212c9..2c1db81 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2359,7 +2359,7 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 {
 	int cpu, orig_cpu, this_cpu, success = 0;
 	unsigned long flags;
-	struct rq *rq, *orig_rq;
+	struct rq *rq;
 
 	if (!sched_feat(SYNC_WAKEUPS))
 		wake_flags &= ~WF_SYNC;
@@ -2367,7 +2367,7 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 	this_cpu = get_cpu();
 
 	smp_wmb();
-	rq = orig_rq = task_rq_lock(p, &flags);
+	rq = task_rq_lock(p, &flags);
 	update_rq_clock(rq);
 	if (!(p->state & state))
 		goto out;

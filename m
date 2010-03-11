Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933560Ab0CKSeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:34:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:37140 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756825Ab0CKSeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:34:13 -0500
Date: Thu, 11 Mar 2010 18:33:38 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1268301890.6785.50.camel@marge.simson.net>
References: <1268301890.6785.50.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove AFFINE_WAKEUPS feature
Message-ID: <tip-beac4c7e4a1cc6d57801f690e5e82fa2c9c245c8@git.kernel.org>
Git-Commit-ID: beac4c7e4a1cc6d57801f690e5e82fa2c9c245c8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Mar 2010 18:33:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  beac4c7e4a1cc6d57801f690e5e82fa2c9c245c8
Gitweb:     http://git.kernel.org/tip/beac4c7e4a1cc6d57801f690e5e82fa2c9c245c8
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Thu, 11 Mar 2010 17:17:20 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 11 Mar 2010 18:32:53 +0100

sched: Remove AFFINE_WAKEUPS feature

Disabling affine wakeups is too horrible to contemplate.  Remove the feature flag.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1268301890.6785.50.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 9357ecd..35a5c64 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1434,8 +1434,7 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 	int sync = wake_flags & WF_SYNC;
 
 	if (sd_flag & SD_BALANCE_WAKE) {
-		if (sched_feat(AFFINE_WAKEUPS) &&
-		    cpumask_test_cpu(cpu, &p->cpus_allowed))
+		if (cpumask_test_cpu(cpu, &p->cpus_allowed))
 			want_affine = 1;
 		new_cpu = prev_cpu;
 	}

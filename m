Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388Ab0CKSdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:33:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:40957 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755379Ab0CKSdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:33:07 -0500
Date: Thu, 11 Mar 2010 18:32:33 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1268301520.6785.40.camel@marge.simson.net>
References: <1268301520.6785.40.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove FAIR_SLEEPERS feature
Message-ID: <tip-5ca9880c6f4ba4c84b517bc2fed5366adf63d191@git.kernel.org>
Git-Commit-ID: 5ca9880c6f4ba4c84b517bc2fed5366adf63d191
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Mar 2010 18:32:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5ca9880c6f4ba4c84b517bc2fed5366adf63d191
Gitweb:     http://git.kernel.org/tip/5ca9880c6f4ba4c84b517bc2fed5366adf63d191
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Thu, 11 Mar 2010 17:17:17 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 11 Mar 2010 18:32:52 +0100

sched: Remove FAIR_SLEEPERS feature

Our preemption model relies too heavily on sleeper fairness to disable it
without dire consequences.  Remove the feature, and save a branch or two.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1268301520.6785.40.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c     |    2 +-
 kernel/sched_features.h |    7 -------
 2 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index de98e2e..97682f9 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -738,7 +738,7 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 		vruntime += sched_vslice(cfs_rq, se);
 
 	/* sleeps up to a single latency don't count. */
-	if (!initial && sched_feat(FAIR_SLEEPERS)) {
+	if (!initial) {
 		unsigned long thresh = sysctl_sched_latency;
 
 		/*
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index 4042883..850f980 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -1,11 +1,4 @@
 /*
- * Disregards a certain amount of sleep time (sched_latency_ns) and
- * considers the task to be running during that period. This gives it
- * a service deficit on wakeup, allowing it to run sooner.
- */
-SCHED_FEAT(FAIR_SLEEPERS, 1)
-
-/*
  * Only give sleepers 50% of their service deficit. This allows
  * them to run sooner, but does not allow tons of sleepers to
  * rip the spread apart.

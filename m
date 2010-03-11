Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab0CKScc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:32:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:40869 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755379Ab0CKScU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:32:20 -0500
Date: Thu, 11 Mar 2010 18:31:45 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1268301285.6785.34.camel@marge.simson.net>
References: <1268301285.6785.34.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Tweak sched_latency and min_granularity
Message-ID: <tip-21406928afe43f1db6acab4931bb8c886f4d04ce@git.kernel.org>
Git-Commit-ID: 21406928afe43f1db6acab4931bb8c886f4d04ce
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Mar 2010 18:31:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  21406928afe43f1db6acab4931bb8c886f4d04ce
Gitweb:     http://git.kernel.org/tip/21406928afe43f1db6acab4931bb8c886f4d04ce
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Thu, 11 Mar 2010 17:17:15 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 11 Mar 2010 18:32:51 +0100

sched: Tweak sched_latency and min_granularity

Allow LAST_BUDDY to kick in sooner, improving cache utilization as soon as
a second buddy pair arrives on scene.  The cost is latency starting to climb
sooner, the tbenefit for tbench 8 on my Q6600 box is ~2%.  No detrimental
effects noted in normal idesktop usage.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1268301285.6785.34.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 69e5820..d19df5b 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -35,8 +35,8 @@
  * (to see the precise effective timeslice length of your workload,
  *  run vmstat and monitor the context-switches (cs) field)
  */
-unsigned int sysctl_sched_latency = 5000000ULL;
-unsigned int normalized_sysctl_sched_latency = 5000000ULL;
+unsigned int sysctl_sched_latency = 6000000ULL;
+unsigned int normalized_sysctl_sched_latency = 6000000ULL;
 
 /*
  * The initial- and re-scaling of tunables is configurable
@@ -52,15 +52,15 @@ enum sched_tunable_scaling sysctl_sched_tunable_scaling
 
 /*
  * Minimal preemption granularity for CPU-bound tasks:
- * (default: 1 msec * (1 + ilog(ncpus)), units: nanoseconds)
+ * (default: 2 msec * (1 + ilog(ncpus)), units: nanoseconds)
  */
-unsigned int sysctl_sched_min_granularity = 1000000ULL;
-unsigned int normalized_sysctl_sched_min_granularity = 1000000ULL;
+unsigned int sysctl_sched_min_granularity = 2000000ULL;
+unsigned int normalized_sysctl_sched_min_granularity = 2000000ULL;
 
 /*
  * is kept at sysctl_sched_latency / sysctl_sched_min_granularity
  */
-static unsigned int sched_nr_latency = 5;
+static unsigned int sched_nr_latency = 3;
 
 /*
  * After fork, child runs first. If set to 0 (default) then

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab0CKJzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 04:55:00 -0500
Received: from mail.gmx.net ([213.165.64.20]:45272 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755101Ab0CKJy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 04:54:58 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+uk4YYj7KuA016awVOGbxe1jqXvjknk21/aJSh1c
	PK8JqETPWFCjTW
Subject: Re: [patch 5/12] sched: tweak sched_latency and min_granularity
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1268300950.6785.27.camel@marge.simson.net>
References: <1268300950.6785.27.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 11 Mar 2010 10:54:45 +0100
Message-Id: <1268301285.6785.34.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53000000000000003
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sched: tweak sched_latency and min_granularity

Allow LAST_BUDDY to kick in sooner, improving cache utilization as soon as
a second buddy pair arrives on scene.  The cost is latency starting to climb
sooner, the tbenefit for tbench 8 on my Q6600 box is ~2%.  No detrimental
effects noted in normal idesktop usage.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 kernel/sched_fair.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
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
@@ -52,15 +52,15 @@ enum sched_tunable_scaling sysctl_sched_
 
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



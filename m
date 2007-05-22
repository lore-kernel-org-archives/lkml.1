Return-Path: <linux-kernel-owner+w=401wt.eu-S1765710AbXEVJ2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765710AbXEVJ2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 05:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756542AbXEVJ21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 05:28:27 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:33123 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979AbXEVJ20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 05:28:26 -0400
Message-ID: <4652B7B6.4080002@mentorg.com>
Date: Tue, 22 May 2007 14:58:22 +0530
From: Pranith Kumar D <pranith-kumar_d@mentor.com>
User-Agent: Thunderbird 1.5 (X11/20051201)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH] CFS: sched-design-CFS.txt - ambiguity about leftmost and
 some formatting
References: <465292B0.8040604@mentorg.com> <20070522083051.GA9699@elte.hu>
In-Reply-To: <20070522083051.GA9699@elte.hu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 May 2007 09:28:22.0229 (UTC) FILETIME=[8A71F050:01C79C53]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
The document is very clear and explains the basic mechanism of CFS very 
well.
But, i find that the descriptions are a bit up and down. I mean, u use 
leftmost and rightmost before mentioning that CFS uses rbtree.( which 
comes much later).

In the following patch I mentioned the rbtree, the first time you talked 
about 'leftmost'. Also i did some basic formatting. Hope its not a pain. :)

Signed-off by:Pranith Kumar D<pranith-kumar_d@mentor.com>

--- linux-2.6.21.1//Documentation/sched-design-CFS.txt.orig 2007-05-22 
14:33:27.000000000 +0530
+++ linux-2.6.21.1//Documentation/sched-design-CFS.txt 2007-05-22 
14:46:38.000000000 +0530
@@ -1,20 +1,20 @@

-this is the CFS scheduler.
+This is the CFS scheduler.

80% of CFS's design can be summed up in a single sentence: CFS basically
models an "ideal, precise multi-tasking CPU" on real hardware.

-"Ideal multi-tasking CPU" is a (non-existent :-) CPU that has 100%
+"Ideal multi-tasking CPU" is a (non-existent :-)) CPU that has 100%
physical power and which can run each task at precise equal speed, in
parallel, each at 1/nr_running speed. For example: if there are 2 tasks
running then it runs each at 50% physical power - totally in parallel.

On real hardware, we can run only a single task at once, so while that
-one task runs the other tasks that are waiting for the CPU are at a
+one task runs, the other tasks that are waiting for the CPU are at a
disadvantage - the current task gets an unfair amount of CPU time. In
CFS this fairness imbalance is expressed and tracked via the per-task
p->wait_runtime (nanosec-unit) value. "wait_runtime" is the amount of
-time the task should now run on the CPU for it become completely fair
+time the task should now run on the CPU for it to become completely fair
and balanced.

( small detail: on 'ideal' hardware, the p->wait_runtime value would
@@ -37,10 +37,10 @@ the task schedules (or a scheduler tick
'accounted for': the (small) time it just spent using the physical CPU
is deducted from p->wait_runtime. [minus the 'fair share' it would have
gotten anyway]. Once p->wait_runtime gets low enough so that another
-task becomes the 'leftmost task' (plus a small amount of 'granularity'
-distance relative to the leftmost task so that we do not over-schedule
-tasks and trash the cache) then the new leftmost task is picked and the
-current task is preempted.
+task becomes the 'leftmost task' of the time-ordered rbtree it maintains
+(plus a small amount of 'granularity' distance relative to the leftmost
+task so that we do not over-schedule tasks and trash the cache) then the
+new leftmost task is picked and the current task is preempted.

The rq->fair_clock value tracks the 'CPU time a runnable task would have
fairly gotten, had it been runnable during that time'. So by using
@@ -64,7 +64,7 @@ Some implementation details:
replacement for the vanilla scheduler's SCHED_OTHER interactivity
code.

- i'd like to give credit to Con Kolivas for the general approach here:
+ I'd like to give credit to Con Kolivas for the general approach here:
he has proven via RSDL/SD that 'fair scheduling' is possible and that
it results in better desktop scheduling. Kudos Con!

@@ -92,17 +92,17 @@ Some implementation details:
setting suitable for desktop workloads. SCHED_BATCH is handled by the
CFS scheduler module too.

- due to its design, the CFS scheduler is not prone to any of the
+ Due to its design, the CFS scheduler is not prone to any of the
'attacks' that exist today against the heuristics of the stock
scheduler: fiftyp.c, thud.c, chew.c, ring-test.c, massive_intr.c all
work fine and do not impact interactivity and produce the expected
behavior.

- the CFS scheduler has a much stronger handling of nice levels and
+ The CFS scheduler has a much stronger handling of nice levels and
SCHED_BATCH: both types of workloads should be isolated much more
agressively than under the vanilla scheduler.

- ( another rdetail: due to nanosec accounting and timeline sorting,
+ ( another detail: due to nanosec accounting and timeline sorting,
sched_yield() support is very simple under CFS, and in fact under
CFS sched_yield() behaves much better than under any other
scheduler i have tested so far. )



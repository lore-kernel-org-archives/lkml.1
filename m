Return-Path: <linux-kernel-owner+w=401wt.eu-S1762130AbXEVGug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762130AbXEVGug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 02:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758156AbXEVGu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 02:50:29 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:47026 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756921AbXEVGu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 02:50:29 -0400
Message-ID: <465292B0.8040604@mentorg.com>
Date: Tue, 22 May 2007 12:20:24 +0530
From: Pranith Kumar D <pranith-kumar_d@mentor.com>
User-Agent: Thunderbird 1.5 (X11/20051201)
MIME-Version: 1.0
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] CFS: sched-design-CFS.txt - ambiguity about leftmost
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 May 2007 06:50:24.0722 (UTC) FILETIME=[79692320:01C79C3D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I felt the description of the leftmost task a bit ambiguous. Is it the 
leftmost task in the rbtree?
or did u mean the "most leftout task" in the task list? If it is so then 
this patch should correct the leftmost task as "most leftout task". NACK 
it if I'm wrong. Just trying to help. :)

Changes "leftmost task" to "most leftout task".

Signed-off by: Pranith Kumar D<pranith-kumar_d@mentorg.com>

--- sched-design-CFS.txt.orig    2007-05-22 12:04:43.000000000 +0530
+++ sched-design-CFS.txt    2007-05-22 12:11:35.000000000 +0530
@@ -37,9 +37,9 @@ the task schedules (or a scheduler tick
 'accounted for': the (small) time it just spent using the physical CPU
 is deducted from p->wait_runtime. [minus the 'fair share' it would have
 gotten anyway]. Once p->wait_runtime gets low enough so that another
-task becomes the 'leftmost task' (plus a small amount of 'granularity'
-distance relative to the leftmost task so that we do not over-schedule
-tasks and trash the cache) then the new leftmost task is picked and the
+task becomes the 'most leftout task' (plus a small amount of 'granularity'
+distance relative to the most leftout task so that we do not over-schedule
+tasks and trash the cache) then the new most leftout task is picked and the
 current task is preempted.
 
 The rq->fair_clock value tracks the 'CPU time a runnable task would have
@@ -47,10 +47,10 @@ fairly gotten, had it been runnable duri
 rq->fair_clock values we can accurately timestamp and measure the
 'expected CPU time' a task should have gotten. All runnable tasks are
 sorted in the rbtree by the "rq->fair_clock - p->wait_runtime" key, and
-CFS picks the 'leftmost' task and sticks to it. As the system progresses
+CFS picks the 'most leftout' task and sticks to it. As the system 
progresses
 forwards, newly woken tasks are put into the tree more and more to the
 right - slowly but surely giving a chance for every task to become the
-'leftmost task' and thus get on the CPU within a deterministic amount of
+'most leftout task' and thus get on the CPU within a deterministic 
amount of
 time.
 
 Some implementation details:


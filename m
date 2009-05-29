Return-Path: <linux-kernel-owner+w=401wt.eu-S1758566AbZE2RQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566AbZE2RQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 13:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbZE2RQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 13:16:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:57502 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505AbZE2RQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 13:16:21 -0400
Date: Fri, 29 May 2009 17:15:45 GMT
From: tip-bot for GeunSik Lim <leemgs1@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, geunsik.lim@samsung.com, leemgs1@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, geunsik.lim@samsung.com, a.p.zijlstra@chello.nl,
       leemgs1@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:sched/core] ftrace: fix typo about map of kernel priority in ftrace.txt file.
Message-ID: <tip-294ae4011530d008c59c4fb9847738e39228821e@git.kernel.org>
Git-Commit-ID: 294ae4011530d008c59c4fb9847738e39228821e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 29 May 2009 17:15:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  294ae4011530d008c59c4fb9847738e39228821e
Gitweb:     http://git.kernel.org/tip/294ae4011530d008c59c4fb9847738e39228821e
Author:     GeunSik Lim <leemgs1@gmail.com>
AuthorDate: Thu, 28 May 2009 10:36:11 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 May 2009 16:21:08 +0200

ftrace: fix typo about map of kernel priority in ftrace.txt file.

Fix typo about chart to map the kernel priority to user land priorities.

   * About sched_setscheduler(2)
      Processes scheduled under SCHED_FIFO or SCHED_RR
      can have a (user-space) static priority in the range 1 to 99.
      (reference: http://www.kernel.org/doc/man-pages/online/pages/
                  man2/sched_setscheduler.2.html)

   * From: Steven Rostedt
      0 to 98 - maps to RT tasks 99 to 1 (SCHED_RR or SCHED_FIFO)

      99 - maps to internal kernel threads that want to be lower than RT tasks
      but higher than SCHED_OTHER tasks. Although I'm not sure if any
      kernel thread actually uses this. I'm not even sure how this can be
      set, because the internal sched_setscheduler function does not allow
      for it.

      100 to 139 - maps nice levels -20 to 19. These are not set via
      sched_setscheduler, but are set via the nice system call.

      140 - reserved for idle tasks.

Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/trace/ftrace.txt |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index fd9a3e6..e362f50 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -518,9 +518,18 @@ priority with zero (0) being the highest priority and the nice
 values starting at 100 (nice -20). Below is a quick chart to map
 the kernel priority to user land priorities.
 
-  Kernel priority: 0 to 99    ==> user RT priority 99 to 0
-  Kernel priority: 100 to 139 ==> user nice -20 to 19
-  Kernel priority: 140        ==> idle task priority
+   Kernel Space                     User Space
+ ===============================================================
+   0(high) to  98(low)     user RT priority 99(high) to 1(low)
+                           with SCHED_RR or SCHED_FIFO
+ ---------------------------------------------------------------
+  99                       sched_priority is not used in scheduling
+                           decisions(it must be specified as 0)
+ ---------------------------------------------------------------
+ 100(high) to 139(low)     user nice -20(high) to 19(low)
+ ---------------------------------------------------------------
+ 140                       idle task priority
+ ---------------------------------------------------------------
 
 The task states are:
 

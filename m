Return-Path: <linux-kernel-owner+w=401wt.eu-S1755216AbYDGUjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbYDGUjs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 16:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbYDGUjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 16:39:41 -0400
Received: from mail.fieldses.org ([66.93.2.214]:60228 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111AbYDGUjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 16:39:40 -0400
Date: Mon, 7 Apr 2008 16:39:38 -0400
To: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org
Subject: [PATCH] Move sched-rt-group.txt to scheduler/
Message-ID: <20080407203938.GC11219@fieldses.org>
References: <1207598345-14295-1-git-send-email-bfields@citi.umich.edu> <26652.1207599992@vena.lwn.net> <20080407203158.GB11219@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080407203158.GB11219@fieldses.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J. Bruce Fields <bfields@citi.umich.edu>

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>

---
 Documentation/sched-rt-group.txt           |   59 ----------------------------
 Documentation/scheduler/00-INDEX           |    2 +
 Documentation/scheduler/sched-rt-group.txt |   59 ++++++++++++++++++++++++++++
 3 files changed, 61 insertions(+), 59 deletions(-)
 delete mode 100644 Documentation/sched-rt-group.txt
 create mode 100644 Documentation/scheduler/sched-rt-group.txt

On Mon, Apr 07, 2008 at 04:31:58PM -0400, J. Bruce Fields wrote:
> Thanks!  Oh, also, I just noticed one more.  But one could probably do
> this all day....

Err--especially if I forget to "git add" a moved file.  Apologies!

--b.

diff --git a/Documentation/sched-rt-group.txt b/Documentation/sched-rt-group.txt
deleted file mode 100644
index 1c6332f..0000000
--- a/Documentation/sched-rt-group.txt
+++ /dev/null
@@ -1,59 +0,0 @@
-
-
-Real-Time group scheduling.
-
-The problem space:
-
-In order to schedule multiple groups of realtime tasks each group must
-be assigned a fixed portion of the CPU time available. Without a minimum
-guarantee a realtime group can obviously fall short. A fuzzy upper limit
-is of no use since it cannot be relied upon. Which leaves us with just
-the single fixed portion.
-
-CPU time is divided by means of specifying how much time can be spent
-running in a given period. Say a frame fixed realtime renderer must
-deliver 25 frames a second, which yields a period of 0.04s. Now say
-it will also have to play some music and respond to input, leaving it
-with around 80% for the graphics. We can then give this group a runtime
-of 0.8 * 0.04s = 0.032s.
-
-This way the graphics group will have a 0.04s period with a 0.032s runtime
-limit.
-
-Now if the audio thread needs to refill the DMA buffer every 0.005s, but
-needs only about 3% CPU time to do so, it can do with a 0.03 * 0.005s
-= 0.00015s.
-
-
-The Interface:
-
-system wide:
-
-/proc/sys/kernel/sched_rt_period_ms
-/proc/sys/kernel/sched_rt_runtime_us
-
-CONFIG_FAIR_USER_SCHED
-
-/sys/kernel/uids/<uid>/cpu_rt_runtime_us
-
-or
-
-CONFIG_FAIR_CGROUP_SCHED
-
-/cgroup/<cgroup>/cpu.rt_runtime_us
-
-[ time is specified in us because the interface is s32; this gives an
-  operating range of ~35m to 1us ]
-
-The period takes values in [ 1, INT_MAX ], runtime in [ -1, INT_MAX - 1 ].
-
-A runtime of -1 specifies runtime == period, ie. no limit.
-
-New groups get the period from /proc/sys/kernel/sched_rt_period_us and
-a runtime of 0.
-
-Settings are constrained to:
-
-   \Sum_{i} runtime_{i} / global_period <= global_runtime / global_period
-
-in order to keep the configuration schedulable.
diff --git a/Documentation/scheduler/00-INDEX b/Documentation/scheduler/00-INDEX
index b5f5ca0..fc234d0 100644
--- a/Documentation/scheduler/00-INDEX
+++ b/Documentation/scheduler/00-INDEX
@@ -12,5 +12,7 @@ sched-domains.txt
 	- information on scheduling domains.
 sched-nice-design.txt
 	- How and why the scheduler's nice levels are implemented.
+sched-rt-group.txt
+	- real-time group scheduling.
 sched-stats.txt
 	- information on schedstats (Linux Scheduler Statistics).
diff --git a/Documentation/scheduler/sched-rt-group.txt b/Documentation/scheduler/sched-rt-group.txt
new file mode 100644
index 0000000..1c6332f
--- /dev/null
+++ b/Documentation/scheduler/sched-rt-group.txt
@@ -0,0 +1,59 @@
+
+
+Real-Time group scheduling.
+
+The problem space:
+
+In order to schedule multiple groups of realtime tasks each group must
+be assigned a fixed portion of the CPU time available. Without a minimum
+guarantee a realtime group can obviously fall short. A fuzzy upper limit
+is of no use since it cannot be relied upon. Which leaves us with just
+the single fixed portion.
+
+CPU time is divided by means of specifying how much time can be spent
+running in a given period. Say a frame fixed realtime renderer must
+deliver 25 frames a second, which yields a period of 0.04s. Now say
+it will also have to play some music and respond to input, leaving it
+with around 80% for the graphics. We can then give this group a runtime
+of 0.8 * 0.04s = 0.032s.
+
+This way the graphics group will have a 0.04s period with a 0.032s runtime
+limit.
+
+Now if the audio thread needs to refill the DMA buffer every 0.005s, but
+needs only about 3% CPU time to do so, it can do with a 0.03 * 0.005s
+= 0.00015s.
+
+
+The Interface:
+
+system wide:
+
+/proc/sys/kernel/sched_rt_period_ms
+/proc/sys/kernel/sched_rt_runtime_us
+
+CONFIG_FAIR_USER_SCHED
+
+/sys/kernel/uids/<uid>/cpu_rt_runtime_us
+
+or
+
+CONFIG_FAIR_CGROUP_SCHED
+
+/cgroup/<cgroup>/cpu.rt_runtime_us
+
+[ time is specified in us because the interface is s32; this gives an
+  operating range of ~35m to 1us ]
+
+The period takes values in [ 1, INT_MAX ], runtime in [ -1, INT_MAX - 1 ].
+
+A runtime of -1 specifies runtime == period, ie. no limit.
+
+New groups get the period from /proc/sys/kernel/sched_rt_period_us and
+a runtime of 0.
+
+Settings are constrained to:
+
+   \Sum_{i} runtime_{i} / global_period <= global_runtime / global_period
+
+in order to keep the configuration schedulable.
-- 
1.5.5.rc1


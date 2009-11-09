Return-Path: <linux-kernel-owner+w=401wt.eu-S1754908AbZKIJNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbZKIJNM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 04:13:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbZKIJNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 04:13:11 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38957 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754725AbZKIJNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 04:13:09 -0500
Date: Mon, 9 Nov 2009 14:43:10 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
Subject: [RFC v3 PATCH 7/7] sched: Hard limits documentation
Message-ID: <20091109091310.GK23472@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20091109090838.GD23472@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091109090838.GD23472@in.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched: Hard limits documentation

From: Bharata B Rao <bharata@linux.vnet.ibm.com>

Documentation for hard limits feature.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 Documentation/scheduler/sched-cfs-hard-limits.txt |   48 +++++++++++++++++++++
 1 files changed, 48 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/scheduler/sched-cfs-hard-limits.txt

diff --git a/Documentation/scheduler/sched-cfs-hard-limits.txt b/Documentation/scheduler/sched-cfs-hard-limits.txt
new file mode 100644
index 0000000..d6387af
--- /dev/null
+++ b/Documentation/scheduler/sched-cfs-hard-limits.txt
@@ -0,0 +1,48 @@
+CPU HARD LIMITS FOR CFS GROUPS
+==============================
+
+1. Overview
+2. Interface
+3. Examples
+
+1. Overview
+-----------
+
+CFS is a proportional share scheduler which tries to divide the CPU time
+proportionately between tasks or groups of tasks (task group/cgroup) depending
+on the priority/weight of the task or shares assigned to groups of tasks.
+In CFS, a task/task group can get more than its share of CPU if there are
+enough idle CPU cycles available in the system, due to the work conserving
+nature of the scheduler. However in certain scenarios (like pay-per-use),
+it is desirable not to provide extra time to a group even in the presence
+of idle CPU cycles. This is where hard limiting can be of use.
+
+Hard limits for task groups can be set by specifying how much CPU runtime a
+group can consume within a given period. If the group consumes more CPU time
+than the runtime in a given period, it gets throttled. None of the tasks of
+the throttled group gets to run until the runtime of the group gets refreshed
+at the beginning of the next period.
+
+2. Interface
+------------
+
+Hard limit feature adds 2 cgroup files for CFS group scheduler:
+
+cfs_runtime_us: Hard limit for the group in microseconds.
+
+cfs_period_us: Time period in microseconds within which hard limits is
+enforced.
+
+A group gets created with default values for runtime (infinite runtime which
+means hard limits disabled) and period (0.5s). Each group can set its own
+values for runtime and period independent of other groups in the system.
+
+3. Examples
+-----------
+
+# mount -t cgroup -ocpu none /cgroups/
+# cd /cgroups
+# mkdir 1
+# cd 1/
+# echo 250000 > cfs_runtime_us /* set a 250ms runtime or limit */
+# echo 500000 > cfs_period_us /* set a 500ms period */

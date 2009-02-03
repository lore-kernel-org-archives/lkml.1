Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbZBCND7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbZBCND7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 08:03:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbZBCNDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 08:03:50 -0500
Received: from liberdade.minaslivre.org ([72.232.18.203]:52998 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbZBCNDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 08:03:49 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH] trivial: fix where cgroup documentation is not correctly referred to
Date: Tue,  3 Feb 2009 11:04:15 -0200
Message-Id: <1233666255-5968-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <4987DBDF.9060504@cn.fujitsu.com>
References: <4987DBDF.9060504@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup documentation was moved to Documentation/cgroups/. There are some
places that still refer to Documentation/controllers/,
Documentation/cgroups.txt and Documentation/cpusets.txt. Fix those.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 Documentation/00-INDEX                         |    4 ++--
 Documentation/kernel-parameters.txt            |    4 ++--
 Documentation/scheduler/sched-rt-group.txt     |    2 +-
 Documentation/vm/numa_memory_policy.txt        |    3 ++-
 Documentation/vm/page_migration                |    3 ++-
 Documentation/x86/x86_64/fake-numa-for-cpusets |    5 +++--
 include/linux/cgroup.h                         |    5 ++++-
 init/Kconfig                                   |    2 +-
 8 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index 2a39aeb..d05737a 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -86,6 +86,8 @@ cachetlb.txt
 	- describes the cache/TLB flushing interfaces Linux uses.
 cdrom/
 	- directory with information on the CD-ROM drivers that Linux has.
+cgroups/
+	- cgroups features, including cpusets and memory controller.
 connector/
 	- docs on the netlink based userspace<->kernel space communication mod.
 console/
@@ -98,8 +100,6 @@ cpu-load.txt
 	- document describing how CPU load statistics are collected.
 cpuidle/
 	- info on CPU_IDLE, CPU idle state management subsystem.
-cpusets.txt
-	- documents the cpusets feature; assign CPUs and Mem to a set of tasks.
 cputopology.txt
 	- documentation on how CPU topology info is exported via sysfs.
 cris/
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index d8362cf..4fd448b 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1563,7 +1563,7 @@ and is between 256 and 4096 characters. It is defined in the file
 	nosoftlockup	[KNL] Disable the soft-lockup detector.
 
 	noswapaccount	[KNL] Disable accounting of swap in memory resource
-			controller. (See Documentation/controllers/memory.txt)
+			controller. (See Documentation/cgroups/memory.txt)
 
 	nosync		[HW,M68K] Disables sync negotiation for all devices.
 
@@ -1907,7 +1907,7 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	relax_domain_level=
 			[KNL, SMP] Set scheduler's default relax_domain_level.
-			See Documentation/cpusets.txt.
+			See Documentation/cgroups/cpusets.txt.
 
 	reserve=	[KNL,BUGS] Force the kernel to ignore some iomem area
 
diff --git a/Documentation/scheduler/sched-rt-group.txt b/Documentation/scheduler/sched-rt-group.txt
index 3ef339f..5ba4d3f 100644
--- a/Documentation/scheduler/sched-rt-group.txt
+++ b/Documentation/scheduler/sched-rt-group.txt
@@ -126,7 +126,7 @@ This uses the /cgroup virtual file system and "/cgroup/<cgroup>/cpu.rt_runtime_u
 to control the CPU time reserved for each control group instead.
 
 For more information on working with control groups, you should read
-Documentation/cgroups.txt as well.
+Documentation/cgroups/cgroups.txt as well.
 
 Group settings are checked against the following limits in order to keep the configuration
 schedulable:
diff --git a/Documentation/vm/numa_memory_policy.txt b/Documentation/vm/numa_memory_policy.txt
index 6aaaeb3..be45dbb 100644
--- a/Documentation/vm/numa_memory_policy.txt
+++ b/Documentation/vm/numa_memory_policy.txt
@@ -8,7 +8,8 @@ The current memory policy support was added to Linux 2.6 around May 2004.  This
 document attempts to describe the concepts and APIs of the 2.6 memory policy
 support.
 
-Memory policies should not be confused with cpusets (Documentation/cpusets.txt)
+Memory policies should not be confused with cpusets
+(Documentation/cgroups/cpusets.txt)
 which is an administrative mechanism for restricting the nodes from which
 memory may be allocated by a set of processes. Memory policies are a
 programming interface that a NUMA-aware application can take advantage of.  When
diff --git a/Documentation/vm/page_migration b/Documentation/vm/page_migration
index d5fdfd3..6513fe2 100644
--- a/Documentation/vm/page_migration
+++ b/Documentation/vm/page_migration
@@ -37,7 +37,8 @@ locations.
 
 Larger installations usually partition the system using cpusets into
 sections of nodes. Paul Jackson has equipped cpusets with the ability to
-move pages when a task is moved to another cpuset (See ../cpusets.txt).
+move pages when a task is moved to another cpuset (See
+Documentation/cgroups/cpusets.txt).
 Cpusets allows the automation of process locality. If a task is moved to
 a new cpuset then also all its pages are moved with it so that the
 performance of the process does not sink dramatically. Also the pages
diff --git a/Documentation/x86/x86_64/fake-numa-for-cpusets b/Documentation/x86/x86_64/fake-numa-for-cpusets
index 33bb566..0f11d9b 100644
--- a/Documentation/x86/x86_64/fake-numa-for-cpusets
+++ b/Documentation/x86/x86_64/fake-numa-for-cpusets
@@ -7,7 +7,8 @@ you can create fake NUMA nodes that represent contiguous chunks of memory and
 assign them to cpusets and their attached tasks.  This is a way of limiting the
 amount of system memory that are available to a certain class of tasks.
 
-For more information on the features of cpusets, see Documentation/cpusets.txt.
+For more information on the features of cpusets, see
+Documentation/cgroups/cpusets.txt.
 There are a number of different configurations you can use for your needs.  For
 more information on the numa=fake command line option and its various ways of
 configuring fake nodes, see Documentation/x86/x86_64/boot-options.txt.
@@ -32,7 +33,7 @@ A machine may be split as follows with "numa=fake=4*512," as reported by dmesg:
 	On node 3 totalpages: 131072
 
 Now following the instructions for mounting the cpusets filesystem from
-Documentation/cpusets.txt, you can assign fake nodes (i.e. contiguous memory
+Documentation/cgroups/cpusets.txt, you can assign fake nodes (i.e. contiguous memory
 address spaces) to individual cpusets:
 
 	[root@xroads /]# mkdir exampleset
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index e267e62..1d9dd8f 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -341,7 +341,10 @@ int cgroup_task_count(const struct cgroup *cgrp);
 /* Return true if the cgroup is a descendant of the current cgroup */
 int cgroup_is_descendant(const struct cgroup *cgrp);
 
-/* Control Group subsystem type. See Documentation/cgroups.txt for details */
+/*
+ * Control Group subsystem type.
+ * See Documentation/cgroups/cgroups.txt for details
+ */
 
 struct cgroup_subsys {
 	struct cgroup_subsys_state *(*create)(struct cgroup_subsys *ss,
diff --git a/init/Kconfig b/init/Kconfig
index f068071..87e26cd 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -505,7 +505,7 @@ config CGROUP_MEM_RES_CTLR
 	select MM_OWNER
 	help
 	  Provides a memory resource controller that manages both anonymous
-	  memory and page cache. (See Documentation/controllers/memory.txt)
+	  memory and page cache. (See Documentation/cgroups/memory.txt)
 
 	  Note that setting this option increases fixed memory overhead
 	  associated with each page of memory in the system. By this,
-- 
1.6.0.6


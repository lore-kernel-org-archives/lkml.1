Return-Path: <linux-kernel-owner+w=401wt.eu-S936351AbYBVA4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936351AbYBVA4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 19:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756785AbYBVA4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 19:56:04 -0500
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:60982 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1756052AbYBVA4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 19:56:03 -0500
X-Spam-Check-By: mail.local.tull.net
Date: Fri, 22 Feb 2008 11:55:31 +1100
Message-ID: <20080222-114832-init-kconfig-6@tull.net>
From: Nick Andrew <nick@nick-andrew.net>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>,
       Serge Hallyn <serue@us.ibm.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Paul Menage <menage@google.com>, Paul Jackson <pj@sgi.com>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Subject: [PATCH 2.6.25-rc2 6/9] Kconfig: Improve init/Kconfig help descriptions - CGROUPS
References: <20080219140609.GA26619@tull.net>
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rewrite the help descriptions for clarity, accuracy and consistency.

Kernel config options affected:

  - CGROUPS
  - CGROUP_DEBUG
  - CPUSETS
  - GROUP_SCHED
  - CGROUP_SCHED
  - CGROUP_CPUACCT
  - SYSFS_DEPRECATED
  - CGROUP_MEM_CONT
  - PROC_PID_CPUSET

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---
Try #3.

--- a/init/Kconfig	2008-02-20 09:34:48.000000000 +1100
+++ b/init/Kconfig	2008-02-21 08:22:39.000000000 +1100
@@ -276,10 +276,17 @@ config LOG_BUF_SHIFT
 config CGROUPS
 	bool "Control Group support"
 	help
-	  This option will let you use process cgroup subsystems
-	  such as Cpusets
+	  Control Groups enable processes to be grouped into "cgroups"
+	  to facilitate tracking and resource management. For example
+	  a cgroup can tie a set of processes to a set of CPUs using
+	  "cpusets".
 
-	  Say N if unsure.
+	  See <file:Documentation/cgroups.txt> for more information.
+
+	  If you say Y here, you probably want to enable one or
+	  more of the cgroup subsystem options below.
+
+	  If unsure, say N.
 
 config CGROUP_DEBUG
 	bool "Example debug cgroup subsystem"
@@ -287,9 +294,9 @@ config CGROUP_DEBUG
 	help
 	  This option enables a simple cgroup subsystem that
 	  exports useful debugging information about the cgroups
-	  framework
+	  framework.
 
-	  Say N if unsure
+	  If unsure, say N.
 
 config CGROUP_NS
         bool "Namespace cgroup subsystem"
@@ -304,19 +311,24 @@ config CPUSETS
 	bool "Cpuset support"
 	depends on SMP && CGROUPS
 	help
-	  This option will let you create and manage CPUSETs which
+	  This option will let you create and manage "cpusets" which
 	  allow dynamically partitioning a system into sets of CPUs and
 	  Memory Nodes and assigning tasks to run only within those sets.
+
 	  This is primarily useful on large SMP or NUMA systems.
 
-	  Say N if unsure.
+	  See <file:Documentation/cpusets.txt> for more information.
+
+	  If unsure, say N.
 
 config GROUP_SCHED
 	bool "Group CPU scheduler"
 	default y
 	help
-	  This feature lets CPU scheduler recognize task groups and control CPU
-	  bandwidth allocation to such task groups.
+	  This feature enables the CPU scheduler to recognize task groups
+	  and control CPU bandwidth allocation to such task groups.
+
+	  See <file:Documentation/sched-design-CFS.txt> for more information.
 
 config FAIR_GROUP_SCHED
 	bool "Group scheduling for SCHED_OTHER"
@@ -346,9 +358,10 @@ config CGROUP_SCHED
  	help
 	  This option allows you to create arbitrary task groups
 	  using the "cgroup" pseudo filesystem and control
-	  the cpu bandwidth allocated to each such task group.
-	  Refer to Documentation/cgroups.txt for more information
-	  on "cgroup" pseudo filesystem.
+	  the CPU bandwidth allocated to each such task group.
+
+	  See <file:Documentation/cgroups.txt> for more information
+	  on the "cgroup" pseudo filesystem.
 
 endchoice
 
@@ -357,7 +370,7 @@ config CGROUP_CPUACCT
 	depends on CGROUPS
 	help
 	  Provides a simple Resource Controller for monitoring the
-	  total CPU consumed by the tasks in a cgroup
+	  total CPU consumed by the tasks in a cgroup.
 
 config RESOURCE_COUNTERS
 	bool "Resource counters"
@@ -375,6 +388,7 @@ config SYSFS_DEPRECATED
 	  "device"-link, the <subsystem>:<name>-link, and the
 	  "bus"-link. It may also add deprecated key in the
 	  uevent environment.
+
 	  None of these features or values should be used today, as
 	  they export driver core implementation details to userspace
 	  or export properties which can't be kept stable across kernel
@@ -394,10 +408,20 @@ config CGROUP_MEM_CONT
 	  Provides a memory controller that manages both page cache and
 	  RSS memory.
 
+	  If unsure, say N.
+
 config PROC_PID_CPUSET
 	bool "Include legacy /proc/<pid>/cpuset file"
 	depends on CPUSETS
 	default y
+	help
+	  This option provides the /proc/<pid>/cpuset file.
+
+	  This file contains the name of the cpuset in which
+	  the process is executing. For more information, see
+	  <file:Documentation/cpusets.txt>
+
+	  If unsure, say Y.
 
 config RELAY
 	bool "Kernel->user space relay support (formerly relayfs)"

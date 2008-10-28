Return-Path: <linux-kernel-owner+w=401wt.eu-S1753500AbYJ1KKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbYJ1KKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 06:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbYJ1KKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 06:10:42 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41043 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbYJ1KKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 06:10:41 -0400
Date: Tue, 28 Oct 2008 19:10:08 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "menage@google.com" <menage@google.com>,
       "xemul@openvz.org" <xemul@openvz.org>
Subject: [PATCH 1/4][mmotm]  cgroup: make cgroup config as submenu
Message-Id: <20081028191008.d610de18.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081028190911.6857b0a6.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081028190911.6857b0a6.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Making CGROUP related configs to be sub-menu.

This patch will making CGROUP related configs to be sub-menu and
making 1st level configs of "General Setup" shorter.

 including following additional changes 
  - add help comment about CGROUPS and GROUP_SCHED.
  - moved MM_OWNER config to the bottom.
    (for good indent in menuconfig)

Changelog: v1->v2
 - applied comments and fixed text.
 - added precise "See Documentation..."

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


 init/Kconfig |  123 ++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 67 insertions(+), 56 deletions(-)

Index: mmotm-2.6.28rc2+/init/Kconfig
===================================================================
--- mmotm-2.6.28rc2+.orig/init/Kconfig
+++ mmotm-2.6.28rc2+/init/Kconfig
@@ -271,59 +271,6 @@ config LOG_BUF_SHIFT
 		     13 =>  8 KB
 		     12 =>  4 KB
 
-config CGROUPS
-	bool "Control Group support"
-	help
-	  This option will let you use process cgroup subsystems
-	  such as Cpusets
-
-	  Say N if unsure.
-
-config CGROUP_DEBUG
-	bool "Example debug cgroup subsystem"
-	depends on CGROUPS
-	default n
-	help
-	  This option enables a simple cgroup subsystem that
-	  exports useful debugging information about the cgroups
-	  framework
-
-	  Say N if unsure
-
-config CGROUP_NS
-        bool "Namespace cgroup subsystem"
-        depends on CGROUPS
-        help
-          Provides a simple namespace cgroup subsystem to
-          provide hierarchical naming of sets of namespaces,
-          for instance virtual servers and checkpoint/restart
-          jobs.
-
-config CGROUP_FREEZER
-        bool "control group freezer subsystem"
-        depends on CGROUPS
-        help
-          Provides a way to freeze and unfreeze all tasks in a
-	  cgroup.
-
-config CGROUP_DEVICE
-	bool "Device controller for cgroups"
-	depends on CGROUPS && EXPERIMENTAL
-	help
-	  Provides a cgroup implementing whitelists for devices which
-	  a process in the cgroup can mknod or open.
-
-config CPUSETS
-	bool "Cpuset support"
-	depends on SMP && CGROUPS
-	help
-	  This option will let you create and manage CPUSETs which
-	  allow dynamically partitioning a system into sets of CPUs and
-	  Memory Nodes and assigning tasks to run only within those sets.
-	  This is primarily useful on large SMP or NUMA systems.
-
-	  Say N if unsure.
-
 #
 # Architectures with an unreliable sched_clock() should select this:
 #
@@ -337,6 +284,8 @@ config GROUP_SCHED
 	help
 	  This feature lets CPU scheduler recognize task groups and control CPU
 	  bandwidth allocation to such task groups.
+	  In order to create a group from arbitrary set of processes, use
+	  CONFIG_CGROUPS. (See Control Group support.)
 
 config FAIR_GROUP_SCHED
 	bool "Group scheduling for SCHED_OTHER"
@@ -379,6 +328,66 @@ config CGROUP_SCHED
 
 endchoice
 
+menu "Control Group support"
+config CGROUPS
+	bool "Control Group support"
+	help
+	  This option add support for grouping sets of processes together, for
+	  use with process control subsystems such as Cpusets, CFS, memory
+	  controls or device isolation.
+	  See
+		- Documentation/cpusets.txt	(Cpusets)
+		- Documentation/scheduler/sched-design-CFS.txt	(CFS)
+		- Documentation/cgroups/ (features for grouping, isolation)
+		- Documentation/controllers/ (features for resource control)
+
+	  Say N if unsure.
+
+config CGROUP_DEBUG
+	bool "Example debug cgroup subsystem"
+	depends on CGROUPS
+	default n
+	help
+	  This option enables a simple cgroup subsystem that
+	  exports useful debugging information about the cgroups
+	  framework
+
+	  Say N if unsure
+
+config CGROUP_NS
+        bool "Namespace cgroup subsystem"
+        depends on CGROUPS
+        help
+          Provides a simple namespace cgroup subsystem to
+          provide hierarchical naming of sets of namespaces,
+          for instance virtual servers and checkpoint/restart
+          jobs.
+
+config CGROUP_FREEZER
+        bool "control group freezer subsystem"
+        depends on CGROUPS
+        help
+          Provides a way to freeze and unfreeze all tasks in a
+	  cgroup.
+
+config CGROUP_DEVICE
+	bool "Device controller for cgroups"
+	depends on CGROUPS && EXPERIMENTAL
+	help
+	  Provides a cgroup implementing whitelists for devices which
+	  a process in the cgroup can mknod or open.
+
+config CPUSETS
+	bool "Cpuset support"
+	depends on SMP && CGROUPS
+	help
+	  This option will let you create and manage CPUSETs which
+	  allow dynamically partitioning a system into sets of CPUs and
+	  Memory Nodes and assigning tasks to run only within those sets.
+	  This is primarily useful on large SMP or NUMA systems.
+
+	  Say N if unsure.
+
 config CGROUP_CPUACCT
 	bool "Simple CPU accounting cgroup subsystem"
 	depends on CGROUPS
@@ -393,9 +402,6 @@ config RESOURCE_COUNTERS
           infrastructure that works with cgroups
 	depends on CGROUPS
 
-config MM_OWNER
-	bool
-
 config CGROUP_MEM_RES_CTLR
 	bool "Memory Resource Controller for Control Groups"
 	depends on CGROUPS && RESOURCE_COUNTERS
@@ -419,6 +425,11 @@ config CGROUP_MEM_RES_CTLR
 	  This config option also selects MM_OWNER config option, which
 	  could in turn add some fork/exit overhead.
 
+config MM_OWNER
+	bool
+
+endmenu
+
 config SYSFS_DEPRECATED
 	bool
 


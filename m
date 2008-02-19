Return-Path: <linux-kernel-owner+w=401wt.eu-S1757579AbYBSPM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579AbYBSPM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 10:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbYBSPMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 10:12:48 -0500
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:54925 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1754104AbYBSPMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 10:12:48 -0500
X-Spam-Check-By: mail.local.tull.net
Date: Wed, 20 Feb 2008 02:12:14 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Improve init/Kconfig help descriptions [PATCH 6/9]
Message-ID: <20080219151214.GD27352@tull.net>
References: <20080219140609.GA26619@tull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219140609.GA26619@tull.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 01:06:09AM +1100, Nick Andrew wrote:
> Here is a series of 9 patches to init/Kconfig intended to improve the
> usefulness and consistency of the help descriptions. The patches are
> against linux-2.6.24.2.
> [...]
> Patch 6
> 	CGROUPS
> 	CGROUP_DEBUG
> 	CPUSETS
> 	FAIR_GROUP_SCHED
> 	FAIR_CGROUP_SCHED
> 	CGROUP_CPUACCT
> 	PROC_PID_CPUSET

Changelog:

Improve usefulness and consistency of kernel configuration help messages.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>


--- a/init/Kconfig	2008-02-20 00:45:07.000000000 +1100
+++ b/init/Kconfig	2008-02-20 00:52:07.000000000 +1100
@@ -289,10 +289,16 @@ config LOG_BUF_SHIFT
 config CGROUPS
 	bool "Control Group support"
 	help
-	  This option will let you use process cgroup subsystems
-	  such as Cpusets
+	  Control Groups enables processes to be tracked and grouped
+	  into "cgroups". This enables you, for example, to associate
+	  cgroups with certain CPU sets using "cpusets".
 
-	  Say N if unsure.
+	  When enabled, a new filesystem type "cgroup" is available
+	  and can be mounted to control cpusets.
+
+	  See <file:Documentation/cgroups.txt> for more information.
+
+	  If unsure, say N.
 
 config CGROUP_DEBUG
 	bool "Example debug cgroup subsystem"
@@ -300,9 +306,9 @@ config CGROUP_DEBUG
 	help
 	  This option enables a simple cgroup subsystem that
 	  exports useful debugging information about the cgroups
-	  framework
+	  framework.
 
-	  Say N if unsure
+	  If unsure, say N.
 
 config CGROUP_NS
         bool "Namespace cgroup subsystem"
@@ -317,19 +323,24 @@ config CPUSETS
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
 
 config FAIR_GROUP_SCHED
 	bool "Fair group CPU scheduler"
 	default y
 	help
-	  This feature lets CPU scheduler recognize task groups and control CPU
-	  bandwidth allocation to such task groups.
+	  This feature enables the CPU scheduler to recognize task groups
+	  and control CPU bandwidth allocation to such task groups.
+
+	  See <file:Documentation/sched-design-CFS.txt> for more information.
 
 choice
 	depends on FAIR_GROUP_SCHED
@@ -348,9 +359,10 @@ config FAIR_CGROUP_SCHED
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
 
@@ -359,7 +371,7 @@ config CGROUP_CPUACCT
 	depends on CGROUPS
 	help
 	  Provides a simple Resource Controller for monitoring the
-	  total CPU consumed by the tasks in a cgroup
+	  total CPU consumed by the tasks in a cgroup.
 
 config SYSFS_DEPRECATED
 	bool "Create deprecated sysfs files"
@@ -369,6 +381,7 @@ config SYSFS_DEPRECATED
 	  "device"-link, the <subsystem>:<name>-link, and the
 	  "bus"-link. It may also add deprecated key in the
 	  uevent environment.
+
 	  None of these features or values should be used today, as
 	  they export driver core implementation details to userspace
 	  or export properties which can't be kept stable across kernel
@@ -381,10 +394,20 @@ config SYSFS_DEPRECATED
 	  If you are using a distro that was released in 2006 or later,
 	  it should be safe to say N here.
 
+	  If unsure, say N.
+
 config PROC_PID_CPUSET
 	bool "Include legacy /proc/<pid>/cpuset file"
 	depends on CPUSETS
 	default y
+	help
+	  This option provides the legacy /proc/<pid>/cpuset file.
+
+	  It has been deprecated in favour of an additional line
+	  in /proc/<pid>/status showing on which CPUs a process
+	  may be scheduled.
+
+	  If unsure, say Y.
 
 config RELAY
 	bool "Kernel->user space relay support (formerly relayfs)"

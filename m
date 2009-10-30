Return-Path: <linux-kernel-owner+w=401wt.eu-S933058AbZJ3Wyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058AbZJ3Wyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 18:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933004AbZJ3Wyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 18:54:37 -0400
Received: from kroah.org ([198.145.64.141]:38980 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933039AbZJ3Wyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 18:54:31 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alex Chiang <achiang@hp.com>, Mike Travis <travis@sgi.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 6/9] Documentation: ABI: /sys/devices/system/cpu/cpu#/ topology files
Date: Fri, 30 Oct 2009 15:54:25 -0700
Message-Id: <1256943268-12164-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <20091030220930.GA11297@kroah.com>
References: <20091030220930.GA11297@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Chiang <achiang@hp.com>

Add brief descriptions for the following sysfs files:

	/sys/devices/system/cpu/cpu#/topology/core_id
	/sys/devices/system/cpu/cpu#/topology/core_siblings
	/sys/devices/system/cpu/cpu#/topology/core_siblings_list
	/sys/devices/system/cpu/cpu#/topology/physical_package_id
	/sys/devices/system/cpu/cpu#/topology/thread_siblings
	/sys/devices/system/cpu/cpu#/topology/thread_siblings_list

The descriptions in Documentation/cputopology.txt weren't very
informative, so I attempted a better description based on code
reading and hopeful guessing.

Updated Documentation/cputopology.txt with the better descriptions and
fixed some style issues.

Cc: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Alex Chiang <achiang@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/ABI/testing/sysfs-devices-system-cpu |   39 ++++++++++++++++
 Documentation/cputopology.txt                      |   47 ++++++++++++-------
 2 files changed, 69 insertions(+), 17 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index 871acdb..2ade5c0 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -38,6 +38,45 @@ Description:	CPU topology files that describe kernel limits related to
 		See Documentation/cputopology.txt for more information.
 
 
+What:		/sys/devices/system/cpu/cpu#/topology/core_id
+		/sys/devices/system/cpu/cpu#/topology/core_siblings
+		/sys/devices/system/cpu/cpu#/topology/core_siblings_list
+		/sys/devices/system/cpu/cpu#/topology/physical_package_id
+		/sys/devices/system/cpu/cpu#/topology/thread_siblings
+		/sys/devices/system/cpu/cpu#/topology/thread_siblings_list
+Date:		December 2008
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+Description:	CPU topology files that describe a logical CPU's relationship
+		to other cores and threads in the same physical package.
+
+		One cpu# directory is created per logical CPU in the system,
+		e.g. /sys/devices/system/cpu/cpu42/.
+
+		Briefly, the files above are:
+
+		core_id: the CPU core ID of cpu#. Typically it is the
+		hardware platform's identifier (rather than the kernel's).
+		The actual value is architecture and platform dependent.
+
+		core_siblings: internal kernel map of cpu#'s hardware threads
+		within the same physical_package_id.
+
+		core_siblings_list: human-readable list of the logical CPU
+		numbers within the same physical_package_id as cpu#.
+
+		physical_package_id: physical package id of cpu#. Typically
+		corresponds to a physical socket number, but the actual value
+		is architecture and platform dependent.
+
+		thread_siblings: internel kernel map of cpu#'s hardware
+		threads within the same core as cpu#
+
+		thread_siblings_list: human-readable list of cpu#'s hardware
+		threads within the same core as cpu#
+
+		See Documentation/cputopology.txt for more information.
+
+
 What:      /sys/devices/system/cpu/cpu*/cache/index*/cache_disable_X
 Date:      August 2008
 KernelVersion:	2.6.27
diff --git a/Documentation/cputopology.txt b/Documentation/cputopology.txt
index b41f3e5..f1c5c4b 100644
--- a/Documentation/cputopology.txt
+++ b/Documentation/cputopology.txt
@@ -1,15 +1,28 @@
 
-Export cpu topology info via sysfs. Items (attributes) are similar
+Export CPU topology info via sysfs. Items (attributes) are similar
 to /proc/cpuinfo.
 
 1) /sys/devices/system/cpu/cpuX/topology/physical_package_id:
-represent the physical package id of  cpu X;
+
+	physical package id of cpuX. Typically corresponds to a physical
+	socket number, but the actual value is architecture and platform
+	dependent.
+
 2) /sys/devices/system/cpu/cpuX/topology/core_id:
-represent the cpu core id to cpu X;
+
+	the CPU core ID of cpuX. Typically it is the hardware platform's
+	identifier (rather than the kernel's).  The actual value is
+	architecture and platform dependent.
+
 3) /sys/devices/system/cpu/cpuX/topology/thread_siblings:
-represent the thread siblings to cpu X in the same core;
+
+	internel kernel map of cpuX's hardware threads within the same
+	core as cpuX
+
 4) /sys/devices/system/cpu/cpuX/topology/core_siblings:
-represent the thread siblings to cpu X in the same physical package;
+
+	internal kernel map of cpuX's hardware threads within the same
+	physical_package_id.
 
 To implement it in an architecture-neutral way, a new source file,
 drivers/base/topology.c, is to export the 4 attributes.
@@ -32,32 +45,32 @@ not defined by include/asm-XXX/topology.h:
 3) thread_siblings: just the given CPU
 4) core_siblings: just the given CPU
 
-Additionally, cpu topology information is provided under
+Additionally, CPU topology information is provided under
 /sys/devices/system/cpu and includes these files.  The internal
 source for the output is in brackets ("[]").
 
-    kernel_max: the maximum cpu index allowed by the kernel configuration.
+    kernel_max: the maximum CPU index allowed by the kernel configuration.
 		[NR_CPUS-1]
 
-    offline:	cpus that are not online because they have been
+    offline:	CPUs that are not online because they have been
 		HOTPLUGGED off (see cpu-hotplug.txt) or exceed the limit
-		of cpus allowed by the kernel configuration (kernel_max
+		of CPUs allowed by the kernel configuration (kernel_max
 		above). [~cpu_online_mask + cpus >= NR_CPUS]
 
-    online:	cpus that are online and being scheduled [cpu_online_mask]
+    online:	CPUs that are online and being scheduled [cpu_online_mask]
 
-    possible:	cpus that have been allocated resources and can be
+    possible:	CPUs that have been allocated resources and can be
 		brought online if they are present. [cpu_possible_mask]
 
-    present:	cpus that have been identified as being present in the
+    present:	CPUs that have been identified as being present in the
 		system. [cpu_present_mask]
 
 The format for the above output is compatible with cpulist_parse()
 [see <linux/cpumask.h>].  Some examples follow.
 
-In this example, there are 64 cpus in the system but cpus 32-63 exceed
+In this example, there are 64 CPUs in the system but cpus 32-63 exceed
 the kernel max which is limited to 0..31 by the NR_CPUS config option
-being 32.  Note also that cpus 2 and 4-31 are not online but could be
+being 32.  Note also that CPUs 2 and 4-31 are not online but could be
 brought online as they are both present and possible.
 
      kernel_max: 31
@@ -67,8 +80,8 @@ brought online as they are both present and possible.
         present: 0-31
 
 In this example, the NR_CPUS config option is 128, but the kernel was
-started with possible_cpus=144.  There are 4 cpus in the system and cpu2
-was manually taken offline (and is the only cpu that can be brought
+started with possible_cpus=144.  There are 4 CPUs in the system and cpu2
+was manually taken offline (and is the only CPU that can be brought
 online.)
 
      kernel_max: 127
@@ -78,4 +91,4 @@ online.)
         present: 0-3
 
 See cpu-hotplug.txt for the possible_cpus=NUM kernel start parameter
-as well as more information on the various cpumask's.
+as well as more information on the various cpumasks.
-- 
1.6.4.2


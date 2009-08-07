Return-Path: <linux-kernel-owner+w=401wt.eu-S1756152AbZHGNHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbZHGNHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 09:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755844AbZHGNHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 09:07:04 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:4962 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737AbZHGNHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 09:07:02 -0400
X-SpamScore: 1
X-BigFish: VPS1(z5edIz14c3M853ka4a4kzz1202hzzz32i6bh203h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KO0CF6-01-2JC-02
X-M-MSG: 
Date: Fri, 7 Aug 2009 15:05:59 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>,
       Brice Goglin <Brice.Goglin@inria.fr>
Subject: [PATCH 8/8] topology: Update CPU topology documentation
Message-ID: <20090807130559.GA6520@alberich.amd.com>
References: <20090807125609.GH7198@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090807125609.GH7198@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 07 Aug 2009 13:05:59.0573 (UTC) FILETIME=[CF008450:01CA175F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mention new attributes introduced for multi-node processor support.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 Documentation/cputopology.txt |   35 +++++++++++++++++++++++++++++------
 1 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/Documentation/cputopology.txt b/Documentation/cputopology.txt
index b41f3e5..48914b1 100644
--- a/Documentation/cputopology.txt
+++ b/Documentation/cputopology.txt
@@ -3,13 +3,32 @@ Export cpu topology info via sysfs. Items (attributes) are similar
 to /proc/cpuinfo.
 
 1) /sys/devices/system/cpu/cpuX/topology/physical_package_id:
-represent the physical package id of  cpu X;
+   represents the physical package id of cpu X;
 2) /sys/devices/system/cpu/cpuX/topology/core_id:
-represent the cpu core id to cpu X;
-3) /sys/devices/system/cpu/cpuX/topology/thread_siblings:
-represent the thread siblings to cpu X in the same core;
-4) /sys/devices/system/cpu/cpuX/topology/core_siblings:
-represent the thread siblings to cpu X in the same physical package;
+   represents the cpu core id of cpu X;
+3) /sys/devices/system/cpu/cpuX/topology/cpu_node_id:
+   represents the processor internal node_id of cpu X;
+4) /sys/devices/system/cpu/cpuX/topology/thread_siblings:
+   represents the thread siblings of cpu X in the same core;
+5) /sys/devices/system/cpu/cpuX/topology/core_siblings:
+   represents the thread siblings of cpu X in the same processor
+   internal node;
+6) /sys/devices/system/cpu/cpuX/topology/cpu_node_siblings:
+   represents the thread siblings of cpu X in the same physical
+   package;
+
+Note: cpu_node_siblings and core_siblings differ only on
+      multi-node processors. On all other processors they are
+      identical and then cpu_node_id is always 0.
+
+With that CPU topology is mapped into following hierarchy:
+
+  Level        | Set of CPUs
+ --------------|---------------
+  phys_package | cpu_node_siblings
+  cpu_node     | core_siblings
+  core         | thread_siblings
+  thread       | one CPU
 
 To implement it in an architecture-neutral way, a new source file,
 drivers/base/topology.c, is to export the 4 attributes.
@@ -20,6 +39,8 @@ these macros in include/asm-XXX/topology.h:
 #define topology_core_id(cpu)
 #define topology_thread_cpumask(cpu)
 #define topology_core_cpumask(cpu)
+#define topology_cpu_node_id(cpu)
+#define topology_cpu_node_siblings(cpu)
 
 The type of **_id is int.
 The type of siblings is (const) struct cpumask *.
@@ -31,6 +52,8 @@ not defined by include/asm-XXX/topology.h:
 2) core_id: 0
 3) thread_siblings: just the given CPU
 4) core_siblings: just the given CPU
+5) cpu_node_id: 0
+6) cpu_node_siblings: identical to core_siblings
 
 Additionally, cpu topology information is provided under
 /sys/devices/system/cpu and includes these files.  The internal
-- 
1.6.3.3




Return-Path: <linux-kernel-owner+w=401wt.eu-S1760706AbZDXQqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760706AbZDXQqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 12:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759896AbZDXQmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 12:42:52 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:41697 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760141AbZDXQmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 12:42:51 -0400
Subject: [PATCH 12/14] kmemleak: Enable the building of the memory leak
	detector
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 24 Apr 2009 17:42:05 +0100
Message-ID: <20090424164205.4476.9856.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20090424163500.4476.62146.stgit@pc1117.cambridge.arm.com>
References: <20090424163500.4476.62146.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.369.gbbd9.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Apr 2009 16:42:50.0001 (UTC) FILETIME=[B4728810:01C9C4FB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Kconfig.debug and Makefile entries needed for
building kmemleak into the kernel.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 lib/Kconfig.debug |   22 ++++++++++++++++++++++
 mm/Makefile       |    1 +
 2 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index c6e854f..6c9d21f 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -336,6 +336,28 @@ config SLUB_STATS
 	  out which slabs are relevant to a particular load.
 	  Try running: slabinfo -DA
 
+config DEBUG_KMEMLEAK
+	bool "Kernel memory leak detector"
+	default n
+	depends on EXPERIMENTAL && (X86 || ARM) && !MEMORY_HOTPLUG
+	select DEBUG_SLAB if SLAB
+	select SLUB_DEBUG if SLUB
+	select DEBUG_FS if SYSFS
+	select STACKTRACE if STACKTRACE_SUPPORT
+	select KALLSYMS
+	help
+	  Say Y here if you want to enable the memory leak
+	  detector. The memory allocation/freeing is traced in a way
+	  similar to the Boehm's conservative garbage collector, the
+	  difference being that the orphan objects are not freed but
+	  only shown in /sys/kernel/debug/kmemleak. Enabling this
+	  feature will introduce an overhead to memory
+	  allocations. See Documentation/kmemleak.txt for more
+	  details.
+
+	  In order to access the kmemleak file, debugfs needs to be
+	  mounted (usually at /sys/kernel/debug).
+
 config DEBUG_PREEMPT
 	bool "Debug preemptible kernel"
 	depends on DEBUG_KERNEL && PREEMPT && (TRACE_IRQFLAGS_SUPPORT || PPC64)
diff --git a/mm/Makefile b/mm/Makefile
index ec73c68..cb84a02 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -38,3 +38,4 @@ obj-$(CONFIG_SMP) += allocpercpu.o
 endif
 obj-$(CONFIG_QUICKLIST) += quicklist.o
 obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o page_cgroup.o
+obj-$(CONFIG_DEBUG_KMEMLEAK) += kmemleak.o


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943AbYKTLdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbYKTLdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 06:33:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755422AbYKTLbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 06:31:17 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:47391 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755417AbYKTLbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 06:31:16 -0500
Subject: [PATCH 2.6.28-rc5 08/11] kmemleak: Enable the building of the memory
	leak detector
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Thu, 20 Nov 2008 11:31:13 +0000
Message-ID: <20081120113113.16607.59694.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20081120112903.16607.68902.stgit@pc1117.cambridge.arm.com>
References: <20081120112903.16607.68902.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.286.g8983
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Nov 2008 11:31:13.0696 (UTC) FILETIME=[7E8D8A00:01C94B03]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Kconfig.debug and Makefile entries needed for
building kmemleak into the kernel.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 lib/Kconfig.debug |   23 +++++++++++++++++++++++
 mm/Makefile       |    1 +
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index b0f239e..1e59827 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -290,6 +290,29 @@ config SLUB_STATS
 	  out which slabs are relevant to a particular load.
 	  Try running: slabinfo -DA
 
+config DEBUG_MEMLEAK
+	bool "Kernel memory leak detector"
+	default n
+	depends on EXPERIMENTAL
+	select DEBUG_SLAB if SLAB
+	select SLUB_DEBUG if SLUB
+	select DEBUG_FS
+	select STACKTRACE
+	select FRAME_POINTER
+	select KALLSYMS
+	help
+	  Say Y here if you want to enable the memory leak
+	  detector. The memory allocation/freeing is traced in a way
+	  similar to the Boehm's conservative garbage collector, the
+	  difference being that the orphan objects are not freed but
+	  only shown in /sys/kernel/debug/memleak. Enabling this
+	  feature will introduce an overhead to memory
+	  allocations. See Documentation/kmemleak.txt for more
+	  details.
+
+	  In order to access the memleak file, debugfs needs to be
+	  mounted (usually at /sys/kernel/debug).
+
 config DEBUG_PREEMPT
 	bool "Debug preemptible kernel"
 	depends on DEBUG_KERNEL && PREEMPT && (TRACE_IRQFLAGS_SUPPORT || PPC64)
diff --git a/mm/Makefile b/mm/Makefile
index c06b45a..3e43536 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -34,3 +34,4 @@ obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_SMP) += allocpercpu.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
 obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o page_cgroup.o
+obj-$(CONFIG_DEBUG_MEMLEAK) += memleak.o


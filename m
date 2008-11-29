Return-Path: <linux-kernel-owner+w=401wt.eu-S1756910AbYK2Krv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbYK2Krv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 05:47:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756348AbYK2Ko3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 05:44:29 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:41423 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756334AbYK2Ko2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 05:44:28 -0500
Subject: [PATCH 12/15] kmemleak: Enable the building of the memory leak
	detector
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Date: Sat, 29 Nov 2008 10:44:13 +0000
Message-ID: <20081129104413.16726.3632.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20081129103908.16726.24264.stgit@pc1117.cambridge.arm.com>
References: <20081129103908.16726.24264.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.288.gdd3f
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Nov 2008 10:44:13.0766 (UTC) FILETIME=[6B761E60:01C9520F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Kconfig.debug and Makefile entries needed for
building kmemleak into the kernel.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
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


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631AbYLSSRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbYLSSRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 13:17:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754604AbYLSSOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 13:14:08 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:50416 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754578AbYLSSOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 13:14:06 -0500
Subject: [PATCH 12/14] kmemleak: Enable the building of the memory leak
	detector
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 19 Dec 2008 18:14:03 +0000
Message-ID: <20081219181403.7778.13549.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20081219181255.7778.52219.stgit@pc1117.cambridge.arm.com>
References: <20081219181255.7778.52219.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.292.gb975
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Dec 2008 18:14:04.0375 (UTC) FILETIME=[93613670:01C96205]
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
index b0f239e..a45aeb5 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -290,6 +290,28 @@ config SLUB_STATS
 	  out which slabs are relevant to a particular load.
 	  Try running: slabinfo -DA
 
+config DEBUG_KMEMLEAK
+	bool "Kernel memory leak detector"
+	default n
+	depends on EXPERIMENTAL
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
index c06b45a..c2dd3e0 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -34,3 +34,4 @@ obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_SMP) += allocpercpu.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
 obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o page_cgroup.o
+obj-$(CONFIG_DEBUG_KMEMLEAK) += kmemleak.o


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbYJXKtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbYJXKtY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 06:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbYJXKtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 06:49:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43205 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbYJXKtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 06:49:15 -0400
Subject: [PATCH] trace: add the MMIO-tracer to the tracer menu
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Pekka Paalanen <pq@iki.fi>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 24 Oct 2008 12:49:17 +0200
Message-Id: <1224845357.4075.0.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: trace: add the MMIO-tracer to the tracer menu
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri Oct 24 12:46:04 CEST 2008

Add the MMIO-tracer to the tracer menu.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Pekka Paalanen <pq@iki.fi>
---
 arch/x86/Kconfig.debug |   28 ++--------------------------
 kernel/trace/Kconfig   |   28 ++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 26 deletions(-)

Index: linux-2.6/arch/x86/Kconfig.debug
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig.debug
+++ linux-2.6/arch/x86/Kconfig.debug
@@ -175,32 +175,8 @@ config IOMMU_LEAK
 	  Add a simple leak tracer to the IOMMU code. This is useful when you
 	  are debugging a buggy device driver that leaks IOMMU mappings.
 
-config MMIOTRACE_HOOKS
-	bool
-
-config MMIOTRACE
-	bool "Memory mapped IO tracing"
-	depends on DEBUG_KERNEL && PCI
-	select TRACING
-	select MMIOTRACE_HOOKS
-	help
-	  Mmiotrace traces Memory Mapped I/O access and is meant for
-	  debugging and reverse engineering. It is called from the ioremap
-	  implementation and works via page faults. Tracing is disabled by
-	  default and can be enabled at run-time.
-
-	  See Documentation/tracers/mmiotrace.txt.
-	  If you are not helping to develop drivers, say N.
-
-config MMIOTRACE_TEST
-	tristate "Test module for mmiotrace"
-	depends on MMIOTRACE && m
-	help
-	  This is a dumb module for testing mmiotrace. It is very dangerous
-	  as it will write garbage to IO memory starting at a given address.
-	  However, it should be safe to use on e.g. unused portion of VRAM.
-
-	  Say N, unless you absolutely know what you are doing.
+config HAVE_MMIOTRACE_SUPPORT
+	def_bool y
 
 #
 # IO delay types:
Index: linux-2.6/kernel/trace/Kconfig
===================================================================
--- linux-2.6.orig/kernel/trace/Kconfig
+++ linux-2.6/kernel/trace/Kconfig
@@ -194,4 +194,32 @@ config FTRACE_STARTUP_TEST
 	  functioning properly. It will do tests on all the configured
 	  tracers of ftrace.
 
+config MMIOTRACE_HOOKS
+	bool
+
+config MMIOTRACE
+	bool "Memory mapped IO tracing"
+	depends on HAVE_MMIOTRACE_SUPPORT && DEBUG_KERNEL && PCI
+	select TRACING
+	select MMIOTRACE_HOOKS
+	help
+	  Mmiotrace traces Memory Mapped I/O access and is meant for
+	  debugging and reverse engineering. It is called from the ioremap
+	  implementation and works via page faults. Tracing is disabled by
+	  default and can be enabled at run-time.
+
+	  See Documentation/tracers/mmiotrace.txt.
+	  If you are not helping to develop drivers, say N.
+
+config MMIOTRACE_TEST
+	tristate "Test module for mmiotrace"
+	depends on MMIOTRACE && m
+	help
+	  This is a dumb module for testing mmiotrace. It is very dangerous
+	  as it will write garbage to IO memory starting at a given address.
+	  However, it should be safe to use on e.g. unused portion of VRAM.
+
+	  Say N, unless you absolutely know what you are doing.
+
+
 endmenu


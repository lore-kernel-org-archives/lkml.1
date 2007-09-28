Return-Path: <linux-kernel-owner+w=401wt.eu-S1761506AbXI1OdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761506AbXI1OdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 10:33:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759364AbXI1Oct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 10:32:49 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:49778 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761761AbXI1Ocs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 10:32:48 -0400
Message-Id: <20070928143159.638289605@polymtl.ca>
References: <20070928142845.795281397@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 28 Sep 2007 10:28:48 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [patch 3/5] Add samples subdir
Content-Disposition: inline; filename=add-samples-subdir.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Fri, 28 Sep 2007 14:32:00 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Begin infrastructure for kernel code samples in the samples/ directory.
Add its Kconfig and Kbuild files.
Source its Kconfig file in all arch/ Kconfigs.

Changelog:
- Move menu to Kernel Hacking
- Don't build with the kernel image

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Makefile          |    3 +++
 lib/Kconfig.debug |    2 ++
 samples/Kconfig   |   11 +++++++++++
 3 files changed, 16 insertions(+)

Index: linux-2.6-lttng/Makefile
===================================================================
--- linux-2.6-lttng.orig/Makefile	2007-09-28 09:24:09.000000000 -0400
+++ linux-2.6-lttng/Makefile	2007-09-28 09:27:28.000000000 -0400
@@ -772,6 +772,9 @@ vmlinux: $(vmlinux-lds) $(vmlinux-init) 
 ifdef CONFIG_HEADERS_CHECK
 	$(Q)$(MAKE) -f $(srctree)/Makefile headers_check
 endif
+ifdef CONFIG_SAMPLES
+	$(Q)$(MAKE) $(build)=samples
+endif
 	$(call vmlinux-modpost)
 	$(call if_changed_rule,vmlinux__)
 	$(Q)rm -f .old_version
Index: linux-2.6-lttng/samples/Kconfig
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/samples/Kconfig	2007-09-28 09:27:28.000000000 -0400
@@ -0,0 +1,11 @@
+# samples/Kconfig
+
+menuconfig SAMPLES
+	bool "Sample kernel code"
+	help
+	  You can build and test sample kernel code here.
+
+if SAMPLES
+
+
+endif # SAMPLES
Index: linux-2.6-lttng/lib/Kconfig.debug
===================================================================
--- linux-2.6-lttng.orig/lib/Kconfig.debug	2007-09-28 09:25:47.000000000 -0400
+++ linux-2.6-lttng/lib/Kconfig.debug	2007-09-28 09:27:28.000000000 -0400
@@ -558,3 +558,5 @@ config FAULT_INJECTION_STACKTRACE_FILTER
 	  Provide stacktrace filter for fault-injection capabilities
 
 source "lib/Kconfig.kgdb"
+
+source "samples/Kconfig"

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

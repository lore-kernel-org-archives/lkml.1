Return-Path: <linux-kernel-owner+w=401wt.eu-S1759290AbXIYUui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290AbXIYUui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 16:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756157AbXIYUuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 16:50:24 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:48435 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755577AbXIYUuX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 16:50:23 -0400
Date: Tue, 25 Sep 2007 16:50:21 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 3/5] Add samples subdir (updated)
Message-ID: <20070925205021.GB16652@Krystal>
References: <20070925121145.262664884@polymtl.ca> <20070925121251.954162366@polymtl.ca> <20070925190036.GA14579@uranus.ravnborg.org> <20070925133234.cdd9edf1.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20070925133234.cdd9edf1.randy.dunlap@oracle.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:46:23 up 57 days, 21:05,  5 users,  load average: 0.40, 0.49, 0.35
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy, since I did big changes to the patch, I removed your
Signed-off-by. Tell me if you want me to add it back... (Is the From:
still valid ?)

Mathieu


Add samples subdir (updated)

From: Randy Dunlap <randy.dunlap@oracle.com>

Begin infrastructure for kernel code samples in the samples/ directory.
Add its Kconfig and Kbuild files.

Changelog:
- Move menu to Kernel Hacking
- Don't build with the kernel image

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 Makefile          |    3 +++
 lib/Kconfig.debug |    2 ++
 samples/Kconfig   |   11 +++++++++++
 3 files changed, 16 insertions(+)

Index: linux-2.6-lttng/Makefile
===================================================================
--- linux-2.6-lttng.orig/Makefile	2007-09-25 16:44:44.000000000 -0400
+++ linux-2.6-lttng/Makefile	2007-09-25 16:45:13.000000000 -0400
@@ -770,6 +770,9 @@ vmlinux: $(vmlinux-lds) $(vmlinux-init) 
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
+++ linux-2.6-lttng/samples/Kconfig	2007-09-25 16:45:13.000000000 -0400
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
--- linux-2.6-lttng.orig/lib/Kconfig.debug	2007-09-25 16:44:44.000000000 -0400
+++ linux-2.6-lttng/lib/Kconfig.debug	2007-09-25 16:45:13.000000000 -0400
@@ -558,3 +558,5 @@ config FAULT_INJECTION_STACKTRACE_FILTER
 	  Provide stacktrace filter for fault-injection capabilities
 
 source "lib/Kconfig.kgdb"
+
+source "samples/Kconfig"

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754263AbYBKKph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbYBKKph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 05:45:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754705AbYBKKpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 05:45:18 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:54988 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926AbYBKKpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 05:45:16 -0500
Date: Mon, 11 Feb 2008 16:15:46 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Christoph Hellwig <hch@infradead.org>,
       sam@ravnborg.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH 1/8] Create tests/ directory 
Message-ID: <20080211104546.GC7944@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20080211104452.GB7944@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211104452.GB7944@in.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Create a toplevel tests/ directory to house in-kernel subsystem specific
tests.

Thanks to Sam Ravnborg for the Makefile corrections.

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile          |    1 +
 lib/Kconfig.debug |    2 ++
 tests/Kconfig     |   10 ++++++++++
 tests/Makefile    |    3 +++
 4 files changed, 16 insertions(+)

Index: linux-2.6.25-rc1/Makefile
===================================================================
--- linux-2.6.25-rc1.orig/Makefile
+++ linux-2.6.25-rc1/Makefile
@@ -603,6 +603,7 @@ export mod_strip_cmd
 
 ifeq ($(KBUILD_EXTMOD),)
 core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/
+core-$(CONFIG_KERNEL_TESTS) += tests/
 
 vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, $(init-y) $(init-m) \
 		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \
Index: linux-2.6.25-rc1/lib/Kconfig.debug
===================================================================
--- linux-2.6.25-rc1.orig/lib/Kconfig.debug
+++ linux-2.6.25-rc1/lib/Kconfig.debug
@@ -618,3 +618,5 @@ config PROVIDE_OHCI1394_DMA_INIT
 	  See Documentation/debugging-via-ohci1394.txt for more information.
 
 source "samples/Kconfig"
+
+source "tests/Kconfig"
Index: linux-2.6.25-rc1/tests/Kconfig
===================================================================
--- /dev/null
+++ linux-2.6.25-rc1/tests/Kconfig
@@ -0,0 +1,10 @@
+# tests/Kconfig
+
+menuconfig KERNEL_TESTS
+	bool "Kernel subsystem tests"
+	help
+	  You can build kernel subsystem specific tests.
+
+if KERNEL_TESTS
+
+endif # KERNEL_TESTS
Index: linux-2.6.25-rc1/tests/Makefile
===================================================================
--- /dev/null
+++ linux-2.6.25-rc1/tests/Makefile
@@ -0,0 +1,3 @@
+#
+# Makefile for kernel subsystem specific tests
+#

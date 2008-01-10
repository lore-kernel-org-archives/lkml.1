Return-Path: <linux-kernel-owner+w=401wt.eu-S1756921AbYAJLzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbYAJLzy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 06:55:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbYAJLzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 06:55:47 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:58547 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbYAJLzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 06:55:45 -0500
Date: Thu, 10 Jan 2008 17:25:37 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm@linux-foundation.org, mingo@elte.hu, ak@suse.de, sam@ravnborg.org
Subject: [PATCH 1/7] Add tests/ directory
Message-ID: <20080110115537.GB26577@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20080110115428.GA26577@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110115428.GA26577@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Create a toplevel tests/ directory to house in-kernel subsystem specific
tests.

PS: I am not sure if I've gotten the Makefile change right.

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---
 Makefile          |    3 +++
 lib/Kconfig.debug |    2 ++
 tests/Kconfig     |   11 +++++++++++
 tests/Makefile    |    3 +++
 4 files changed, 19 insertions(+)

Index: linux-2.6.24-rc6/lib/Kconfig.debug
===================================================================
--- linux-2.6.24-rc6.orig/lib/Kconfig.debug
+++ linux-2.6.24-rc6/lib/Kconfig.debug
@@ -596,3 +596,5 @@ config PROVIDE_OHCI1394_DMA_INIT
 	  See Documentation/debugging-via-ohci1394.txt for more information.
 
 source "samples/Kconfig"
+
+source "tests/Kconfig"
Index: linux-2.6.24-rc6/tests/Kconfig
===================================================================
--- /dev/null
+++ linux-2.6.24-rc6/tests/Kconfig
@@ -0,0 +1,11 @@
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
+
Index: linux-2.6.24-rc6/tests/Makefile
===================================================================
--- /dev/null
+++ linux-2.6.24-rc6/tests/Makefile
@@ -0,0 +1,3 @@
+#
+# Makefile for kernel subsystem specific tests
+#
Index: linux-2.6.24-rc6/Makefile
===================================================================
--- linux-2.6.24-rc6.orig/Makefile
+++ linux-2.6.24-rc6/Makefile
@@ -598,6 +598,9 @@ export mod_strip_cmd
 
 ifeq ($(KBUILD_EXTMOD),)
 core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/
+ifdef CONFIG_KERNEL_TESTS
+core-y		+= tests/
+endif
 
 vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, $(init-y) $(init-m) \
 		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \

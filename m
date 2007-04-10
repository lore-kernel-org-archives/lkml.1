Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbXDJLIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbXDJLIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 07:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbXDJLIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 07:08:40 -0400
Received: from ozlabs.org ([203.10.76.45]:56250 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630AbXDJLIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 07:08:38 -0400
Subject: [PATCH 4/8] lguest: the Makefile and Kconfig
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Andi Kleen <ak@muc.de>
In-Reply-To: <1176203231.26372.27.camel@localhost.localdomain>
References: <1176203068.26372.21.camel@localhost.localdomain>
	 <1176203130.26372.23.camel@localhost.localdomain>
	 <1176203176.26372.25.camel@localhost.localdomain>
	 <1176203231.26372.27.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 10 Apr 2007 21:08:05 +1000
Message-Id: <1176203285.26372.29.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the Kconfig and Makefile to allow lguest to actually be
compiled.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/Kconfig         |    2 ++
 drivers/Makefile        |    1 +
 drivers/lguest/Kconfig  |   20 ++++++++++++++++++++
 drivers/lguest/Makefile |    7 +++++++
 4 files changed, 30 insertions(+)

===================================================================
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -87,4 +87,6 @@ source "drivers/kvm/Kconfig"
 source "drivers/kvm/Kconfig"
 
 source "drivers/uio/Kconfig"
+
+source "drivers/lguest/Kconfig"
 endmenu
===================================================================
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -86,3 +86,4 @@ obj-$(CONFIG_HID)		+= hid/
 obj-$(CONFIG_HID)		+= hid/
 obj-$(CONFIG_PPC_PS3)		+= ps3/
 obj-$(CONFIG_SSB)		+= ssb/
+obj-$(CONFIG_LGUEST_GUEST)	+= lguest/
===================================================================
--- /dev/null
+++ b/drivers/lguest/Kconfig
@@ -0,0 +1,20 @@
+config LGUEST
+	tristate "Linux hypervisor example code"
+	depends on X86 && PARAVIRT && NET && EXPERIMENTAL && !X86_PAE
+	select LGUEST_GUEST
+	select HVC_DRIVER
+	---help---
+	  This is a very simple module which allows you to run
+	  multiple instances of the same Linux kernel, using the
+	  "lguest" command found in the Documentation/lguest directory.
+	  Note that "lguest" is pronounced to rhyme with "fell quest",
+	  not "rustyvisor".  See Documentation/lguest/lguest.txt.
+
+	  If unsure, say N.  If curious, say M.  If masochistic, say Y.
+
+config LGUEST_GUEST
+	bool
+	help
+	  The guest needs code built-in, even if the host has lguest
+	  support as a module.  The drivers are tiny, so we build them
+	  in too.
===================================================================
--- /dev/null
+++ b/drivers/lguest/Makefile
@@ -0,0 +1,7 @@
+# Guest requires the paravirt_ops replacement and the bus driver.
+obj-$(CONFIG_LGUEST_GUEST) += lguest.o lguest_asm.o lguest_bus.o
+
+# Host requires the other files, which can be a module.
+obj-$(CONFIG_LGUEST)	+= lg.o
+lg-objs := core.o hypercalls.o page_tables.o interrupts_and_traps.o \
+	segments.o io.o lguest_user.o switcher.o



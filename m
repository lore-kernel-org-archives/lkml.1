Return-Path: <linux-kernel-owner+w=401wt.eu-S1756512AbXFLXj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbXFLXj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 19:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbXFLXjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 19:39:49 -0400
Received: from raven.upol.cz ([158.194.120.4]:41895 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471AbXFLXjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 19:39:48 -0400
Message-Id: <20070612234558.915990000@flower.upol.cz>
References: <20070612233650.486224000@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: quilt + emacs + jed (x86_64-pc-linux-glibc-debian)
X-Mailer: formail(procmail)
Date: Wed, 13 Jun 2007 01:36:53 +0200
From: Oleg Verych <olecom@flower.upol.cz>
To: Sam Ravnborg <sam@ravnborg.org>, Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>, kbuild-devel@lists.sourceforge.net
Subject: [patch 03/03] kbuild, asm-values: private for lguest
Content-Disposition: inline; filename=kbuild-asm-values-lguest-private.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	A small example of how it can be used privately.

rfc-by: Oleg Verych
---
 TODO: change lguest files to use it.

 drivers/lguest/Makefile     |    4 ++++
 drivers/lguest/asm-values.c |   24 ++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

Index: linux-2.6.22-rc4-mm2/drivers/lguest/Makefile
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/lguest/Makefile	2007-06-13 01:25:17.931654500 +0200
+++ linux-2.6.22-rc4-mm2/drivers/lguest/Makefile	2007-06-13 01:29:01.337616500 +0200
@@ -1,2 +1,6 @@
+# Generate private asm-values.h
+ASM_NS = LGUEST
+include $(srctree)/scripts/Makefile.asm
+
 # Guest requires the paravirt_ops replacement and the bus driver.
 obj-$(CONFIG_LGUEST_GUEST) += lguest.o lguest_asm.o lguest_bus.o
Index: linux-2.6.22-rc4-mm2/drivers/lguest/asm-values.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.22-rc4-mm2/drivers/lguest/asm-values.c	2007-06-13 01:29:01.337616500 +0200
@@ -0,0 +1,24 @@
+/*
+ * Private definitions needed by lguest's assembly language modules.
+ */
+
+#include <linux/lguest.h>
+#include "lg.h"
+#include <asm-generic/asm-values.h>
+
+void fell_guest(void);
+
+void fell_guest(void)
+{
+	OFFSET(LGUEST_DATA_irq_enabled, lguest_data, irq_enabled);
+	OFFSET(LGUEST_PAGES_host_gdt_desc, lguest_pages, state.host_gdt_desc);
+	OFFSET(LGUEST_PAGES_host_idt_desc, lguest_pages, state.host_idt_desc);
+	OFFSET(LGUEST_PAGES_host_cr3, lguest_pages, state.host_cr3);
+	OFFSET(LGUEST_PAGES_host_sp, lguest_pages, state.host_sp);
+	OFFSET(LGUEST_PAGES_guest_gdt_desc, lguest_pages,state.guest_gdt_desc);
+	OFFSET(LGUEST_PAGES_guest_idt_desc, lguest_pages,state.guest_idt_desc);
+	OFFSET(LGUEST_PAGES_guest_gdt, lguest_pages, state.guest_gdt);
+	OFFSET(LGUEST_PAGES_regs_trapnum, lguest_pages, regs.trapnum);
+	OFFSET(LGUEST_PAGES_regs_errcode, lguest_pages, regs.errcode);
+	OFFSET(LGUEST_PAGES_regs, lguest_pages, regs);
+}

--


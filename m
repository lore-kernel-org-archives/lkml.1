Return-Path: <linux-kernel-owner+w=401wt.eu-S933783AbXCVQJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933783AbXCVQJj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 12:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933816AbXCVQJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 12:09:39 -0400
Received: from [198.99.130.12] ([198.99.130.12]:53364 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S933783AbXCVQJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 12:09:37 -0400
Date: Thu, 22 Mar 2007 12:06:43 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [ PATCH 4/7 ] UML - create as-layout.h
Message-ID: <20070322160643.GA7012@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves all the the symbols defined in um_arch.c, which are
mostly boundaries between different parts of the UML kernel address
space, to a new header, as-layout.h.  There are also a few things here
which aren't really related to address space layout, but which don't
really have a better place to go.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/include/as-layout.h   |   35 +++++++++++++++++++++++++++++++++++
 arch/um/include/user_util.h   |   23 -----------------------
 arch/um/kernel/exec.c         |    1 +
 arch/um/kernel/ksyms.c        |    1 +
 arch/um/kernel/mem.c          |    1 +
 arch/um/kernel/physmem.c      |    1 +
 arch/um/kernel/process.c      |    1 +
 arch/um/kernel/skas/process.c |    1 +
 arch/um/kernel/tlb.c          |    1 +
 arch/um/kernel/trap.c         |    1 +
 arch/um/kernel/um_arch.c      |    1 +
 arch/um/os-Linux/main.c       |    1 +
 arch/um/os-Linux/skas/trap.c  |    1 +
 13 files changed, 46 insertions(+), 23 deletions(-)

Index: linux-2.6.21-mm/arch/um/kernel/exec.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/exec.c	2007-03-21 17:33:45.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/exec.c	2007-03-22 11:18:21.000000000 -0400
@@ -12,6 +12,7 @@
 #include "asm/uaccess.h"
 #include "user_util.h"
 #include "kern_util.h"
+#include "as-layout.h"
 #include "mem_user.h"
 #include "kern.h"
 #include "irq_user.h"
Index: linux-2.6.21-mm/arch/um/kernel/mem.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/mem.c	2007-03-21 17:33:45.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/mem.c	2007-03-22 11:18:21.000000000 -0400
@@ -15,6 +15,7 @@
 #include "asm/pgalloc.h"
 #include "user_util.h"
 #include "kern_util.h"
+#include "as-layout.h"
 #include "kern.h"
 #include "mem_user.h"
 #include "uml_uaccess.h"
Index: linux-2.6.21-mm/arch/um/kernel/process.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/process.c	2007-03-21 17:33:45.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/process.c	2007-03-22 11:18:21.000000000 -0400
@@ -34,6 +34,7 @@
 #include "asm/user.h"
 #include "user_util.h"
 #include "kern_util.h"
+#include "as-layout.h"
 #include "kern.h"
 #include "signal_kern.h"
 #include "init.h"
Index: linux-2.6.21-mm/arch/um/kernel/skas/process.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/skas/process.c	2007-03-21 17:33:45.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/skas/process.c	2007-03-22 11:18:21.000000000 -0400
@@ -13,6 +13,7 @@
 #include "asm/uaccess.h"
 #include "asm/atomic.h"
 #include "kern_util.h"
+#include "as-layout.h"
 #include "skas.h"
 #include "os.h"
 #include "user_util.h"
Index: linux-2.6.21-mm/arch/um/os-Linux/main.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/main.c	2007-03-21 17:33:45.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/main.c	2007-03-22 11:18:21.000000000 -0400
@@ -15,6 +15,7 @@
 #include <asm/page.h>
 #include "user_util.h"
 #include "kern_util.h"
+#include "as-layout.h"
 #include "mem_user.h"
 #include "irq_user.h"
 #include "user.h"
Index: linux-2.6.21-mm/arch/um/os-Linux/skas/trap.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/skas/trap.c	2007-03-21 17:33:45.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/skas/trap.c	2007-03-22 11:18:21.000000000 -0400
@@ -7,6 +7,7 @@
 #include <errno.h>
 #include "user_util.h"
 #include "kern_util.h"
+#include "as-layout.h"
 #include "task.h"
 #include "sigcontext.h"
 #include "skas.h"
Index: linux-2.6.21-mm/arch/um/kernel/physmem.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/physmem.c	2007-03-21 17:33:45.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/physmem.c	2007-03-22 11:18:21.000000000 -0400
@@ -13,6 +13,7 @@
 #include "asm/types.h"
 #include "asm/pgtable.h"
 #include "kern_util.h"
+#include "as-layout.h"
 #include "user_util.h"
 #include "mode_kern.h"
 #include "mem.h"
Index: linux-2.6.21-mm/arch/um/kernel/tlb.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/tlb.c	2007-03-21 17:33:45.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/tlb.c	2007-03-22 11:18:21.000000000 -0400
@@ -9,6 +9,7 @@
 #include "asm/tlbflush.h"
 #include "choose-mode.h"
 #include "mode_kern.h"
+#include "as-layout.h"
 #include "user_util.h"
 #include "tlb.h"
 #include "mem.h"
Index: linux-2.6.21-mm/arch/um/kernel/trap.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/trap.c	2007-03-21 17:38:21.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/trap.c	2007-03-22 11:18:21.000000000 -0400
@@ -20,6 +20,7 @@
 #include "sysdep/sigcontext.h"
 #include "user_util.h"
 #include "kern_util.h"
+#include "as-layout.h"
 #include "arch.h"
 #include "kern.h"
 #include "chan_kern.h"
Index: linux-2.6.21-mm/arch/um/kernel/um_arch.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/um_arch.c	2007-03-21 17:38:21.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/um_arch.c	2007-03-22 11:18:21.000000000 -0400
@@ -28,6 +28,7 @@
 #include "asm/current.h"
 #include "user_util.h"
 #include "kern_util.h"
+#include "as-layout.h"
 #include "arch.h"
 #include "kern.h"
 #include "mem_user.h"
Index: linux-2.6.21-mm/arch/um/include/user_util.h
===================================================================
--- linux-2.6.21-mm.orig/arch/um/include/user_util.h	2007-03-21 17:38:21.000000000 -0400
+++ linux-2.6.21-mm/arch/um/include/user_util.h	2007-03-22 11:18:21.000000000 -0400
@@ -30,30 +30,7 @@ extern int grantpt(int __fd);
 extern int unlockpt(int __fd);
 extern char *ptsname(int __fd);
 
-struct cpu_task {
-	int pid;
-	void *task;
-};
-
-extern struct cpu_task cpu_tasks[];
-
-extern void (*sig_info[])(int, union uml_pt_regs *);
-
-extern unsigned long low_physmem;
-extern unsigned long high_physmem;
-extern unsigned long uml_physmem;
-extern unsigned long uml_reserved;
-extern unsigned long end_vm;
-extern unsigned long start_vm;
-extern unsigned long long highmem;
-
-extern unsigned long _stext, _etext, _sdata, _edata, __bss_start, _end;
-extern unsigned long _unprotected_end;
-extern unsigned long brk_start;
-
 extern void *add_signal_handler(int sig, void (*handler)(int));
-extern int linux_main(int argc, char **argv);
-extern void set_cmdline(char *cmd);
 extern void input_cb(void (*proc)(void *), void *arg, int arg_len);
 extern int get_pty(void);
 extern int switcheroo(int fd, int prot, void *from, void *to, int size);
Index: linux-2.6.21-mm/arch/um/kernel/ksyms.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/ksyms.c	2007-03-21 17:33:45.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/ksyms.c	2007-03-22 11:18:21.000000000 -0400
@@ -16,6 +16,7 @@
 #include "asm/page.h"
 #include "asm/tlbflush.h"
 #include "kern_util.h"
+#include "as-layout.h"
 #include "user_util.h"
 #include "mem_user.h"
 #include "os.h"
Index: linux-2.6.21-mm/arch/um/include/as-layout.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.21-mm/arch/um/include/as-layout.h	2007-03-22 11:18:04.000000000 -0400
@@ -0,0 +1,35 @@
+/*
+ * Copyright (C) 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
+ * Licensed under the GPL
+ */
+
+#ifndef __START_H__
+#define __START_H__
+
+#include "sysdep/ptrace.h"
+
+struct cpu_task {
+	int pid;
+	void *task;
+};
+
+extern struct cpu_task cpu_tasks[];
+
+extern unsigned long low_physmem;
+extern unsigned long high_physmem;
+extern unsigned long uml_physmem;
+extern unsigned long uml_reserved;
+extern unsigned long end_vm;
+extern unsigned long start_vm;
+extern unsigned long long highmem;
+
+extern unsigned long _stext, _etext, _sdata, _edata, __bss_start, _end;
+extern unsigned long _unprotected_end;
+extern unsigned long brk_start;
+
+extern int linux_main(int argc, char **argv);
+extern void set_cmdline(char *cmd);
+
+extern void (*sig_info[])(int, union uml_pt_regs *);
+
+#endif

Return-Path: <linux-kernel-owner+w=401wt.eu-S933761AbXCVQJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933761AbXCVQJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 12:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933816AbXCVQJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 12:09:38 -0400
Received: from [198.99.130.12] ([198.99.130.12]:53363 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S933761AbXCVQJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 12:09:37 -0400
Date: Thu, 22 Mar 2007 12:06:42 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [ PATCH 3/7 ] UML - Create arch.h
Message-ID: <20070322160642.GA7007@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the declarations of the architecture hooks from
user_util.h to a new header, arch.c, and adds the necessary includes
to files which need those declarations.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/include/arch.h      |   15 +++++++++++++++
 arch/um/include/user_util.h |    4 ----
 arch/um/kernel/trap.c       |    1 +
 arch/um/kernel/um_arch.c    |    1 +
 4 files changed, 17 insertions(+), 4 deletions(-)

Index: linux-2.6.21-mm/arch/um/include/arch.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.21-mm/arch/um/include/arch.h	2007-03-21 17:29:15.000000000 -0400
@@ -0,0 +1,15 @@
+/*
+ * Copyright (C) 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
+ * Licensed under the GPL
+ */
+
+#ifndef __ARCH_H__
+#define __ARCH_H__
+
+#include "sysdep/ptrace.h"
+
+extern void arch_check_bugs(void);
+extern int arch_fixup(unsigned long address, void *sc_ptr);
+extern int arch_handle_signal(int sig, union uml_pt_regs *regs);
+
+#endif
Index: linux-2.6.21-mm/arch/um/kernel/trap.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/trap.c	2007-03-21 16:16:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/trap.c	2007-03-21 17:29:15.000000000 -0400
@@ -20,6 +20,7 @@
 #include "sysdep/sigcontext.h"
 #include "user_util.h"
 #include "kern_util.h"
+#include "arch.h"
 #include "kern.h"
 #include "chan_kern.h"
 #include "mconsole_kern.h"
Index: linux-2.6.21-mm/arch/um/kernel/um_arch.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/um_arch.c	2007-03-21 16:16:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/um_arch.c	2007-03-21 17:29:15.000000000 -0400
@@ -28,6 +28,7 @@
 #include "asm/current.h"
 #include "user_util.h"
 #include "kern_util.h"
+#include "arch.h"
 #include "kern.h"
 #include "mem_user.h"
 #include "mem.h"
Index: linux-2.6.21-mm/arch/um/include/user_util.h
===================================================================
--- linux-2.6.21-mm.orig/arch/um/include/user_util.h	2007-03-21 16:17:50.000000000 -0400
+++ linux-2.6.21-mm/arch/um/include/user_util.h	2007-03-21 17:29:15.000000000 -0400
@@ -65,10 +65,6 @@ extern int attach(int pid);
 extern void kill_child_dead(int pid);
 extern int cont(int pid);
 extern void check_sigio(void);
-extern void arch_check_bugs(void);
-extern int arch_handle_signal(int sig, union uml_pt_regs *regs);
-extern int arch_fixup(unsigned long address, void *sc_ptr);
-extern void arch_init_thread(void);
 extern int raw(int fd);
 
 #endif

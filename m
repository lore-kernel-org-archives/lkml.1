Return-Path: <linux-kernel-owner+w=401wt.eu-S1758304AbYGUAHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758304AbYGUAHA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 20:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757169AbYGUAEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 20:04:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58582 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757032AbYGUAEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 20:04:04 -0400
Subject: [PATCH 13/22] mips: Introducing asm/syscalls.h
From: Jaswinder Singh <jaswinder@infradead.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: kernelnewbies <kernelnewbies@nl.linux.org>,
       David Woodhouse <dwmw2@infradead.org>, ralf@linux-mips.org,
       linux-mips@linux-mips.org
In-Reply-To: <1216597151.3679.125.camel@jaswinder.satnam>
References: <1216592500.3679.14.camel@jaswinder.satnam>
	 <1216592798.3679.22.camel@jaswinder.satnam>
	 <1216592879.3679.24.camel@jaswinder.satnam>
	 <1216593035.3679.27.camel@jaswinder.satnam>
	 <1216596035.3679.95.camel@jaswinder.satnam>
	 <1216596106.3679.98.camel@jaswinder.satnam>
	 <1216596325.3679.104.camel@jaswinder.satnam>
	 <1216596669.3679.112.camel@jaswinder.satnam>
	 <1216596749.3679.115.camel@jaswinder.satnam>
	 <1216596835.3679.117.camel@jaswinder.satnam>
	 <1216596932.3679.120.camel@jaswinder.satnam>
	 <1216597066.3679.123.camel@jaswinder.satnam>
	 <1216597151.3679.125.camel@jaswinder.satnam>
Content-Type: text/plain
Date: Mon, 21 Jul 2008 05:10:37 +0530
Message-Id: <1216597237.3679.128.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declaring arch-dependent syscalls for mips architecture

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 arch/mips/kernel/linux32.c  |    1 -
 arch/mips/kernel/signal.c   |    2 +-
 arch/mips/kernel/signal32.c |    1 -
 arch/mips/kernel/syscall.c  |    1 -
 include/asm-mips/syscalls.h |   45 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 46 insertions(+), 4 deletions(-)

diff --git a/arch/mips/kernel/linux32.c b/arch/mips/kernel/linux32.c
index 65af3cc..710e4dc 100644
--- a/arch/mips/kernel/linux32.c
+++ b/arch/mips/kernel/linux32.c
@@ -41,7 +41,6 @@
 #include <net/scm.h>
 
 #include <asm/compat-signal.h>
-#include <asm/sim.h>
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
 #include <asm/mman.h>
diff --git a/arch/mips/kernel/signal.c b/arch/mips/kernel/signal.c
index a4e106c..2bc1a37 100644
--- a/arch/mips/kernel/signal.c
+++ b/arch/mips/kernel/signal.c
@@ -20,13 +20,13 @@
 #include <linux/unistd.h>
 #include <linux/compiler.h>
 #include <linux/uaccess.h>
+#include <linux/syscalls.h>
 
 #include <asm/abi.h>
 #include <asm/asm.h>
 #include <linux/bitops.h>
 #include <asm/cacheflush.h>
 #include <asm/fpu.h>
-#include <asm/sim.h>
 #include <asm/ucontext.h>
 #include <asm/cpu-features.h>
 #include <asm/war.h>
diff --git a/arch/mips/kernel/signal32.c b/arch/mips/kernel/signal32.c
index 572c610..c1b32e9 100644
--- a/arch/mips/kernel/signal32.c
+++ b/arch/mips/kernel/signal32.c
@@ -27,7 +27,6 @@
 #include <asm/compat-signal.h>
 #include <linux/bitops.h>
 #include <asm/cacheflush.h>
-#include <asm/sim.h>
 #include <asm/ucontext.h>
 #include <asm/system.h>
 #include <asm/fpu.h>
diff --git a/arch/mips/kernel/syscall.c b/arch/mips/kernel/syscall.c
index af1bdc8..3505210 100644
--- a/arch/mips/kernel/syscall.c
+++ b/arch/mips/kernel/syscall.c
@@ -35,7 +35,6 @@
 #include <asm/cacheflush.h>
 #include <asm/asm-offsets.h>
 #include <asm/signal.h>
-#include <asm/sim.h>
 #include <asm/shmparam.h>
 #include <asm/sysmips.h>
 #include <asm/uaccess.h>
diff --git a/include/asm-mips/syscalls.h b/include/asm-mips/syscalls.h
index e69de29..3beed90 100644
--- a/include/asm-mips/syscalls.h
+++ b/include/asm-mips/syscalls.h
@@ -0,0 +1,45 @@
+/*
+ * syscalls.h - Linux syscall interfaces (arch-specific)
+ *
+ * Copyright (c) 2008 Jaswinder Singh
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ *
+ * Please do not call me directly, include linux/syscalls.h
+ */
+
+#ifndef _ASM_MIPS_SYSCALLS_H
+#define _ASM_MIPS_SYSCALLS_H
+
+#include <linux/ptrace.h>
+#include <asm/sim.h>
+
+/* kernel/signal.c */
+#ifdef CONFIG_TRAD_SIGNALS
+asmlinkage int sys_sigsuspend(nabi_no_regargs struct pt_regs);
+asmlinkage int sys_sigaction(int, const struct sigaction __user *,
+			     struct sigaction __user *);
+asmlinkage void sys_sigreturn(nabi_no_regargs struct pt_regs);
+#endif
+
+asmlinkage int sys_rt_sigsuspend(nabi_no_regargs struct pt_regs);
+asmlinkage int sys_sigaltstack(nabi_no_regargs struct pt_regs);
+asmlinkage void sys_rt_sigreturn(nabi_no_regargs struct pt_regs);
+
+/* kernel/syscalls.c */
+asmlinkage unsigned long old_mmap(unsigned long, unsigned long,
+				  int, int, int, off_t);
+
+asmlinkage unsigned long sys_mmap2(unsigned long, unsigned long,
+				   unsigned long, unsigned long,
+				   unsigned long, unsigned long);
+asmlinkage int sys_execve(nabi_no_regargs struct pt_regs);
+asmlinkage int sys_uname(struct old_utsname __user *);
+asmlinkage int sys_olduname(struct oldold_utsname __user *);
+asmlinkage int sys_set_thread_area(unsigned long);
+asmlinkage int sys_ipc(unsigned int, int, int,
+		       unsigned long, void __user *, long);
+asmlinkage int sys_cachectl(char *, int, int);
+
+#endif /* _ASM_MIPS_SYSCALLS_H */
-- 
1.5.5.1




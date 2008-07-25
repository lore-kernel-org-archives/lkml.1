Return-Path: <linux-kernel-owner+w=401wt.eu-S1754078AbYGYIUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbYGYIUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 04:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbYGYITt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 04:19:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:48296 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbYGYITs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 04:19:48 -0400
Subject: [PATCH] avr32: Introducing asm/syscalls.h
From: Jaswinder Singh <jaswinder@infradead.org>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 25 Jul 2008 13:48:38 +0530
Message-Id: <1216973918.26114.1.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declaring arch-dependent syscalls for avr32 architecture

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 arch/avr32/kernel/process.c   |    1 +
 arch/avr32/kernel/signal.c    |    1 +
 arch/avr32/kernel/sys_avr32.c |    1 +
 arch/avr32/mm/cache.c         |    1 +
 include/asm-avr32/syscalls.h  |   39 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 43 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-avr32/syscalls.h

diff --git a/arch/avr32/kernel/process.c b/arch/avr32/kernel/process.c
index ff820a9..3feb59e 100644
--- a/arch/avr32/kernel/process.c
+++ b/arch/avr32/kernel/process.c
@@ -17,6 +17,7 @@
 
 #include <asm/sysreg.h>
 #include <asm/ocd.h>
+#include <asm/syscalls.h>
 
 #include <asm/arch/pm.h>
 
diff --git a/arch/avr32/kernel/signal.c b/arch/avr32/kernel/signal.c
index c5b11f9..803d7be 100644
--- a/arch/avr32/kernel/signal.c
+++ b/arch/avr32/kernel/signal.c
@@ -19,6 +19,7 @@
 
 #include <asm/uaccess.h>
 #include <asm/ucontext.h>
+#include <asm/syscalls.h>
 
 #define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
 
diff --git a/arch/avr32/kernel/sys_avr32.c b/arch/avr32/kernel/sys_avr32.c
index 8e8911e..5d2daea 100644
--- a/arch/avr32/kernel/sys_avr32.c
+++ b/arch/avr32/kernel/sys_avr32.c
@@ -13,6 +13,7 @@
 
 #include <asm/mman.h>
 #include <asm/uaccess.h>
+#include <asm/syscalls.h>
 
 asmlinkage long sys_mmap2(unsigned long addr, unsigned long len,
 			  unsigned long prot, unsigned long flags,
diff --git a/arch/avr32/mm/cache.c b/arch/avr32/mm/cache.c
index 15a4e5e..24a74d1 100644
--- a/arch/avr32/mm/cache.c
+++ b/arch/avr32/mm/cache.c
@@ -13,6 +13,7 @@
 #include <asm/cachectl.h>
 #include <asm/processor.h>
 #include <asm/uaccess.h>
+#include <asm/syscalls.h>
 
 /*
  * If you attempt to flush anything more than this, you need superuser
diff --git a/include/asm-avr32/syscalls.h b/include/asm-avr32/syscalls.h
new file mode 100644
index 0000000..483d666
--- /dev/null
+++ b/include/asm-avr32/syscalls.h
@@ -0,0 +1,39 @@
+/*
+ * syscalls.h - Linux syscall interfaces (arch-specific)
+ *
+ * Copyright (c) 2008 Jaswinder Singh
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#ifndef _ASM_AVR32_SYSCALLS_H
+#define _ASM_AVR32_SYSCALLS_H
+
+#include <linux/compiler.h>
+#include <linux/linkage.h>
+#include <linux/types.h>
+#include <linux/signal.h>
+
+/* kernel/process.c */
+asmlinkage int sys_fork(struct pt_regs *);
+asmlinkage int sys_clone(unsigned long, unsigned long,
+			 unsigned long, unsigned long,
+			 struct pt_regs *);
+asmlinkage int sys_vfork(struct pt_regs *);
+asmlinkage int sys_execve(char __user *, char __user *__user *,
+			  char __user *__user *, struct pt_regs *);
+
+/* kernel/signal.c */
+asmlinkage int sys_sigaltstack(const stack_t __user *, stack_t __user *,
+			       struct pt_regs *);
+asmlinkage int sys_rt_sigreturn(struct pt_regs *);
+
+/* kernel/sys_avr32.c */
+asmlinkage long sys_mmap2(unsigned long, unsigned long, unsigned long,
+			  unsigned long, unsigned long, off_t);
+
+/* mm/cache.c */
+asmlinkage int sys_cacheflush(int, void __user *, size_t);
+
+#endif /* _ASM_AVR32_SYSCALLS_H */
-- 
1.5.5.1




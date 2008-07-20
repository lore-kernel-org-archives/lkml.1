Return-Path: <linux-kernel-owner+w=401wt.eu-S1757676AbYGUAEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757676AbYGUAEB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 20:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754539AbYGUADE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 20:03:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:56718 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465AbYGUADD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 20:03:03 -0400
Subject: [PATCH 4/22] avr32: Introducing asm/syscalls.h
From: Jaswinder Singh <jaswinder@infradead.org>
To: LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       David Woodhouse <dwmw2@infradead.org>, hskinnemoen@atmel.com
In-Reply-To: <1216593035.3679.27.camel@jaswinder.satnam>
References: <1216592500.3679.14.camel@jaswinder.satnam>
	 <1216592798.3679.22.camel@jaswinder.satnam>
	 <1216592879.3679.24.camel@jaswinder.satnam>
	 <1216593035.3679.27.camel@jaswinder.satnam>
Content-Type: text/plain
Date: Mon, 21 Jul 2008 04:50:34 +0530
Message-Id: <1216596035.3679.95.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
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
 include/asm-avr32/syscalls.h  |   36 ++++++++++++++++++++++++++++++++++++
 5 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/arch/avr32/kernel/process.c b/arch/avr32/kernel/process.c
index 6cf9df1..ee57d4c 100644
--- a/arch/avr32/kernel/process.c
+++ b/arch/avr32/kernel/process.c
@@ -14,6 +14,7 @@
 #include <linux/tick.h>
 #include <linux/uaccess.h>
 #include <linux/unistd.h>
+#include <linux/syscalls.h>
 
 #include <asm/sysreg.h>
 #include <asm/ocd.h>
diff --git a/arch/avr32/kernel/signal.c b/arch/avr32/kernel/signal.c
index c5b11f9..90ba201 100644
--- a/arch/avr32/kernel/signal.c
+++ b/arch/avr32/kernel/signal.c
@@ -16,6 +16,7 @@
 #include <linux/ptrace.h>
 #include <linux/unistd.h>
 #include <linux/freezer.h>
+#include <linux/syscalls.h>
 
 #include <asm/uaccess.h>
 #include <asm/ucontext.h>
diff --git a/arch/avr32/kernel/sys_avr32.c b/arch/avr32/kernel/sys_avr32.c
index 8e8911e..4c0a167 100644
--- a/arch/avr32/kernel/sys_avr32.c
+++ b/arch/avr32/kernel/sys_avr32.c
@@ -10,6 +10,7 @@
 #include <linux/file.h>
 #include <linux/mm.h>
 #include <linux/unistd.h>
+#include <linux/syscalls.h>
 
 #include <asm/mman.h>
 #include <asm/uaccess.h>
diff --git a/arch/avr32/mm/cache.c b/arch/avr32/mm/cache.c
index 15a4e5e..2faf302 100644
--- a/arch/avr32/mm/cache.c
+++ b/arch/avr32/mm/cache.c
@@ -8,6 +8,7 @@
 
 #include <linux/highmem.h>
 #include <linux/unistd.h>
+#include <linux/syscalls.h>
 
 #include <asm/cacheflush.h>
 #include <asm/cachectl.h>
diff --git a/include/asm-avr32/syscalls.h b/include/asm-avr32/syscalls.h
index e69de29..727c58c 100644
--- a/include/asm-avr32/syscalls.h
+++ b/include/asm-avr32/syscalls.h
@@ -0,0 +1,36 @@
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
+#ifndef _ASM_AVR32_SYSCALLS_H
+#define _ASM_AVR32_SYSCALLS_H
+
+/* kernel/process.c */
+asmlinkage int sys_fork(struct pt_regs);
+asmlinkage int sys_clone(unsigned long, unsigned long,
+			 unsigned long, unsigned long,
+			 struct pt_regs *);
+asmlinkage int sys_vfork(struct pt_regs);
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




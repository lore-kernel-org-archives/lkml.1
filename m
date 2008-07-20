Return-Path: <linux-kernel-owner+w=401wt.eu-S1758513AbYGUAHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758513AbYGUAHt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 20:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757781AbYGUAEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 20:04:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:37654 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756995AbYGUAET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 20:04:19 -0400
Subject: [PATCH 15/22] parisc: Introducing asm/syscalls.h
From: Jaswinder Singh <jaswinder@infradead.org>
To: LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       David Woodhouse <dwmw2@infradead.org>, matthew@wil.cx, kyle@mcmartin.ca,
       grundler@parisc-linux.org, linux-parisc@vger.kernel.org
In-Reply-To: <1216597352.3679.131.camel@jaswinder.satnam>
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
	 <1216597237.3679.128.camel@jaswinder.satnam>
	 <1216597352.3679.131.camel@jaswinder.satnam>
Content-Type: text/plain
Date: Mon, 21 Jul 2008 05:16:06 +0530
Message-Id: <1216597566.3679.135.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declaring arch-dependent syscalls for parisc architecture

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 arch/parisc/kernel/process.c  |    1 +
 arch/parisc/kernel/signal.c   |    1 +
 include/asm-parisc/syscalls.h |   36 ++++++++++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/arch/parisc/kernel/process.c b/arch/parisc/kernel/process.c
index b80e02a..9a73fcd 100644
--- a/arch/parisc/kernel/process.c
+++ b/arch/parisc/kernel/process.c
@@ -46,6 +46,7 @@
 #include <linux/stddef.h>
 #include <linux/unistd.h>
 #include <linux/kallsyms.h>
+#include <linux/syscalls.h>
 
 #include <asm/io.h>
 #include <asm/asm-offsets.h>
diff --git a/arch/parisc/kernel/signal.c b/arch/parisc/kernel/signal.c
index 06213d1..b10cade 100644
--- a/arch/parisc/kernel/signal.c
+++ b/arch/parisc/kernel/signal.c
@@ -25,6 +25,7 @@
 #include <linux/stddef.h>
 #include <linux/compat.h>
 #include <linux/elf.h>
+#include <linux/syscalls.h>
 #include <asm/ucontext.h>
 #include <asm/rt_sigframe.h>
 #include <asm/uaccess.h>
diff --git a/include/asm-parisc/syscalls.h b/include/asm-parisc/syscalls.h
index e69de29..0de8837 100644
--- a/include/asm-parisc/syscalls.h
+++ b/include/asm-parisc/syscalls.h
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
+#ifndef _ASM_PARISC_SYSCALLS_H
+#define _ASM_PARISC_SYSCALLS_H
+
+/* kernel/process.c */
+int sys_clone(unsigned long, unsigned long, struct pt_regs *);
+int sys_vfork(struct pt_regs *);
+asmlinkage int sys_execve(struct pt_regs *);
+
+/* kernel/signal.c */
+void sys_rt_sigreturn(struct pt_regs *, int);
+
+/* kernel/sys_parisc.c */
+asmlinkage unsigned long sys_mmap2(unsigned long, unsigned long,
+				   unsigned long, unsigned long,
+				   unsigned long, unsigned long);
+asmlinkage unsigned long sys_mmap(unsigned long, unsigned long,
+				  unsigned long, unsigned long,
+				  unsigned long, unsigned long);
+#ifdef CONFIG_64BIT
+asmlinkage long sys_truncate64(const char __user *, unsigned long);
+asmlinkage long sys_ftruncate64(unsigned int, unsigned long);
+asmlinkage long sys_fcntl64(unsigned int, unsigned int, unsigned long);
+#endif
+
+#endif /* _ASM_PARISC_SYSCALLS_H */
-- 
1.5.5.1




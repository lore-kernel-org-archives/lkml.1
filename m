Return-Path: <linux-kernel-owner+w=401wt.eu-S1758673AbYGUAHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673AbYGUAHa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 20:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757796AbYGUAES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 20:04:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:37648 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757781AbYGUAER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 20:04:17 -0400
Subject: [PATCH 14/22] mn10300: Introducing asm/syscalls.h
From: Jaswinder Singh <jaswinder@infradead.org>
To: LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       David Woodhouse <dwmw2@infradead.org>, dhowells@redhat.com,
       yasutake.koichi@jp.panasonic.com
In-Reply-To: <1216597237.3679.128.camel@jaswinder.satnam>
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
Content-Type: text/plain
Date: Mon, 21 Jul 2008 05:12:32 +0530
Message-Id: <1216597352.3679.131.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declaring arch-dependent syscalls for mn10300 architecture

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 arch/mn10300/kernel/process.c  |    1 +
 arch/mn10300/kernel/signal.c   |    1 +
 include/asm-mn10300/syscalls.h |   41 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/arch/mn10300/kernel/process.c b/arch/mn10300/kernel/process.c
index b28c9a6..49a05f9 100644
--- a/arch/mn10300/kernel/process.c
+++ b/arch/mn10300/kernel/process.c
@@ -26,6 +26,7 @@
 #include <linux/percpu.h>
 #include <linux/err.h>
 #include <linux/fs.h>
+#include <linux/syscalls.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/system.h>
diff --git a/arch/mn10300/kernel/signal.c b/arch/mn10300/kernel/signal.c
index 841ca99..bf37ccc 100644
--- a/arch/mn10300/kernel/signal.c
+++ b/arch/mn10300/kernel/signal.c
@@ -23,6 +23,7 @@
 #include <linux/tty.h>
 #include <linux/personality.h>
 #include <linux/suspend.h>
+#include <linux/syscalls.h>
 #include <asm/cacheflush.h>
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
diff --git a/include/asm-mn10300/syscalls.h b/include/asm-mn10300/syscalls.h
index e69de29..67baaea 100644
--- a/include/asm-mn10300/syscalls.h
+++ b/include/asm-mn10300/syscalls.h
@@ -0,0 +1,41 @@
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
+#ifndef _ASM_MN10300_SYSCALLS_H
+#define _ASM_MN10300_SYSCALLS_H
+
+/* kernel/process.c */
+asmlinkage long sys_clone(unsigned long, unsigned long,
+			  int __user *, int __user *, int __user *);
+asmlinkage long sys_fork(void);
+asmlinkage long sys_vfork(void);
+asmlinkage long sys_execve(char __user *, char __user * __user *,
+			   char __user * __user *);
+
+/* kernel/signal.c */
+asmlinkage long sys_sigsuspend(int, int, old_sigset_t);
+asmlinkage long sys_sigaction(int sig,
+			      const struct old_sigaction __user *,
+			      struct old_sigaction __user *);
+asmlinkage long sys_sigaltstack(const stack_t __user *, stack_t *);
+asmlinkage long sys_sigreturn(void);
+asmlinkage long sys_rt_sigreturn(void);
+
+/* kernel/sys_mn10300.c */
+asmlinkage long sys_mmap2(unsigned long, unsigned long, unsigned long,
+			  unsigned long, unsigned long, unsigned long);
+asmlinkage long old_mmap(unsigned long, unsigned long, unsigned long,
+			  unsigned long, unsigned long, unsigned long);
+struct sel_arg_struct;
+asmlinkage int old_select(struct sel_arg_struct __user *);
+asmlinkage long sys_ipc(uint, int, int, int, void __user *, long);
+
+#endif /* _ASM_MN10300_SYSCALLS_H */
-- 
1.5.5.1




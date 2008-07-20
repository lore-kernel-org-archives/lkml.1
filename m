Return-Path: <linux-kernel-owner+w=401wt.eu-S1757770AbYGUAFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770AbYGUAFF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 20:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757103AbYGUADX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 20:03:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58548 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757074AbYGUADW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 20:03:22 -0400
Subject: [PATCH 7/22] frv: Introducing asm/syscalls.h
From: Jaswinder Singh <jaswinder@infradead.org>
To: LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       David Woodhouse <dwmw2@infradead.org>, dhowells@redhat.com
In-Reply-To: <1216596325.3679.104.camel@jaswinder.satnam>
References: <1216592500.3679.14.camel@jaswinder.satnam>
	 <1216592798.3679.22.camel@jaswinder.satnam>
	 <1216592879.3679.24.camel@jaswinder.satnam>
	 <1216593035.3679.27.camel@jaswinder.satnam>
	 <1216596035.3679.95.camel@jaswinder.satnam>
	 <1216596106.3679.98.camel@jaswinder.satnam>
	 <1216596325.3679.104.camel@jaswinder.satnam>
Content-Type: text/plain
Date: Mon, 21 Jul 2008 05:01:09 +0530
Message-Id: <1216596669.3679.112.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declaring arch-dependent syscalls for frv architecture

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 arch/frv/kernel/process.c  |    1 +
 arch/frv/kernel/signal.c   |    1 +
 include/asm-frv/syscalls.h |   37 +++++++++++++++++++++++++++++++++++++
 3 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/arch/frv/kernel/process.c b/arch/frv/kernel/process.c
index 9583a33..09b3c13 100644
--- a/arch/frv/kernel/process.c
+++ b/arch/frv/kernel/process.c
@@ -26,6 +26,7 @@
 #include <linux/reboot.h>
 #include <linux/interrupt.h>
 #include <linux/pagemap.h>
+#include <linux/syscalls.h>
 
 #include <asm/asm-offsets.h>
 #include <asm/uaccess.h>
diff --git a/arch/frv/kernel/signal.c b/arch/frv/kernel/signal.c
index 3bdb368..5d024fe 100644
--- a/arch/frv/kernel/signal.c
+++ b/arch/frv/kernel/signal.c
@@ -21,6 +21,7 @@
 #include <linux/unistd.h>
 #include <linux/personality.h>
 #include <linux/freezer.h>
+#include <linux/syscalls.h>
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
diff --git a/include/asm-frv/syscalls.h b/include/asm-frv/syscalls.h
index e69de29..e2639f2 100644
--- a/include/asm-frv/syscalls.h
+++ b/include/asm-frv/syscalls.h
@@ -0,0 +1,37 @@
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
+#ifndef _ASM_FRV_SYSCALLS_H
+#define _ASM_FRV_SYSCALLS_H
+
+/* kernel/process.c */
+asmlinkage int sys_fork(void);
+asmlinkage int sys_vfork(void);
+asmlinkage int sys_clone(unsigned long, unsigned long, int __user *,
+			 int __user *, int __user *);
+asmlinkage int sys_execve(char __user *, char __user * __user *,
+			  char __user * __user *);
+
+/* kernel/signal.c */
+asmlinkage int sys_sigsuspend(int, int, old_sigset_t);
+asmlinkage int sys_sigaction(int, const struct old_sigaction __user *,
+			     struct old_sigaction __user *);
+asmlinkage int sys_sigaltstack(const stack_t __user *, stack_t __user *);
+asmlinkage int sys_sigreturn(void);
+asmlinkage int sys_rt_sigreturn(void);
+
+/* kernel/sys_frv.c */
+asmlinkage long sys_mmap2(unsigned long, unsigned long, unsigned long,
+			  unsigned long, unsigned long, unsigned long);
+asmlinkage long sys_ipc(unsigned long, unsigned long, unsigned long,
+			unsigned long, void __user *, unsigned long);
+
+#endif /* _ASM_FRV_SYSCALLS_H */
-- 
1.5.5.1




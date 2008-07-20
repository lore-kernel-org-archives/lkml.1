Return-Path: <linux-kernel-owner+w=401wt.eu-S1758474AbYGUAG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758474AbYGUAG1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 20:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757476AbYGUADv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 20:03:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58566 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757475AbYGUADu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 20:03:50 -0400
Subject: [PATCH 11/22] m68k: Introducing asm/syscalls.h
From: Jaswinder Singh <jaswinder@infradead.org>
To: LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       David Woodhouse <dwmw2@infradead.org>, geert@linux-m68k.org,
       zippel@linux-m68k.org, linux-m68k@vger.kernel.org
In-Reply-To: <1216596932.3679.120.camel@jaswinder.satnam>
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
Content-Type: text/plain
Date: Mon, 21 Jul 2008 05:07:46 +0530
Message-Id: <1216597066.3679.123.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declaring arch-dependent syscalls for m68k architecture

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 arch/m68k/kernel/process.c  |    1 +
 include/asm-m68k/syscalls.h |   35 +++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/arch/m68k/kernel/process.c b/arch/m68k/kernel/process.c
index 7888cdf..41aa0c3 100644
--- a/arch/m68k/kernel/process.c
+++ b/arch/m68k/kernel/process.c
@@ -26,6 +26,7 @@
 #include <linux/reboot.h>
 #include <linux/init_task.h>
 #include <linux/mqueue.h>
+#include <linux/syscalls.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
diff --git a/include/asm-m68k/syscalls.h b/include/asm-m68k/syscalls.h
index e69de29..13ad908 100644
--- a/include/asm-m68k/syscalls.h
+++ b/include/asm-m68k/syscalls.h
@@ -0,0 +1,35 @@
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
+#ifndef _ASM_M68K_SYSCALLS_H
+#define _ASM_M68K_SYSCALLS_H
+
+/* kernel/process.c */
+asmlinkage int sys_execve(char __user *, char __user * __user *,
+			  char __user * __user *);
+
+/* kernel/signal.c */
+asmlinkage int sys_sigaction(int, const struct old_sigaction __user *,
+			     struct old_sigaction __user *);
+asmlinkage int sys_sigaltstack(const stack_t __user *, stack_t __user *);
+
+/* kernel/sys_m68k.c */
+asmlinkage long sys_mmap2(unsigned long, unsigned long, unsigned long,
+			  unsigned long, unsigned long, unsigned long);
+struct mmap_arg_struct;
+asmlinkage int old_mmap(struct mmap_arg_struct __user *);
+struct sel_arg_struct;
+asmlinkage int old_select(struct sel_arg_struct __user *);
+asmlinkage int sys_ipc(uint, int, int, int, void __user *, long);
+asmlinkage int sys_cacheflush(unsigned long, int, int, unsigned long);
+asmlinkage int sys_getpagesize(void);
+
+#endif /* _ASM_M68K_SYSCALLS_H */
-- 
1.5.5.1




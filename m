Return-Path: <linux-kernel-owner+w=401wt.eu-S1759117AbYGUAJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759117AbYGUAJe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 20:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757976AbYGUAEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 20:04:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:37671 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757500AbYGUAEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 20:04:51 -0400
Subject: [PATCH 20/22] v850: Introducing asm/syscalls.h
From: Jaswinder Singh <jaswinder@infradead.org>
To: LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       David Woodhouse <dwmw2@infradead.org>, miles@gnu.org
In-Reply-To: <1216598067.3679.146.camel@jaswinder.satnam>
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
	 <1216597566.3679.135.camel@jaswinder.satnam>
	 <1216597856.3679.139.camel@jaswinder.satnam>
	 <1216597923.3679.141.camel@jaswinder.satnam>
	 <1216597993.3679.144.camel@jaswinder.satnam>
	 <1216598067.3679.146.camel@jaswinder.satnam>
Content-Type: text/plain
Date: Mon, 21 Jul 2008 05:25:51 +0530
Message-Id: <1216598151.3679.148.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declaring arch-dependent syscalls for v850 architecture

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 arch/v850/kernel/process.c  |    1 +
 arch/v850/kernel/signal.c   |    1 +
 include/asm-v850/syscalls.h |   34 ++++++++++++++++++++++++++++++++++
 3 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/arch/v850/kernel/process.c b/arch/v850/kernel/process.c
index e4a4b8e..4ea0783 100644
--- a/arch/v850/kernel/process.c
+++ b/arch/v850/kernel/process.c
@@ -23,6 +23,7 @@
 #include <linux/user.h>
 #include <linux/a.out.h>
 #include <linux/reboot.h>
+#include <linux/syscalls.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
diff --git a/arch/v850/kernel/signal.c b/arch/v850/kernel/signal.c
index bf166e7..603c13e 100644
--- a/arch/v850/kernel/signal.c
+++ b/arch/v850/kernel/signal.c
@@ -26,6 +26,7 @@
 #include <linux/stddef.h>
 #include <linux/personality.h>
 #include <linux/tty.h>
+#include <linux/syscalls.h>
 
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
diff --git a/include/asm-v850/syscalls.h b/include/asm-v850/syscalls.h
index e69de29..5c7f0eb 100644
--- a/include/asm-v850/syscalls.h
+++ b/include/asm-v850/syscalls.h
@@ -0,0 +1,34 @@
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
+#ifndef _ASM_V850_SYSCALLS_H
+#define _ASM_V850_SYSCALLS_H
+
+/* kernel/process.c */
+int sys_execve(char *, char **, char **, struct pt_regs *);
+
+/* kernel/signal.c */
+asmlinkage int sys_sigsuspend(old_sigset_t, struct pt_regs *);
+asmlinkage int sys_rt_sigsuspend(sigset_t *, size_t, struct pt_regs *);
+asmlinkage int sys_sigaction(int, const struct old_sigaction *,
+			     struct old_sigaction *);
+asmlinkage int sys_sigaltstack(const stack_t *, stack_t *, struct pt_regs *);
+asmlinkage int sys_sigreturn(struct pt_regs *);
+asmlinkage int sys_rt_sigreturn(struct pt_regs *);
+
+/* kernel/syscalls.c */
+int sys_ipc(uint, int, int, int, void *, long);
+unsigned long sys_mmap2(unsigned long, size_t, unsigned long,
+			unsigned long, unsigned long, unsigned long);
+unsigned long sys_mmap(unsigned long, size_t, unsigned long,
+		       unsigned long, unsigned long, off_t);
+
+#endif /* _ASM_V850_SYSCALLS_H */
-- 
1.5.5.1




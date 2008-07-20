Return-Path: <linux-kernel-owner+w=401wt.eu-S1758123AbYGUAGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123AbYGUAGn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 20:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757621AbYGUAD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 20:03:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:37642 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757600AbYGUAD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 20:03:57 -0400
Subject: [PATCH 12/22] m68knommu: Introducing asm/syscalls.h
From: Jaswinder Singh <jaswinder@infradead.org>
To: LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       David Woodhouse <dwmw2@infradead.org>, geert@linux-m68k.org,
       zippel@linux-m68k.org, linux-m68k@vger.kernel.org
In-Reply-To: <1216597066.3679.123.camel@jaswinder.satnam>
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
Content-Type: text/plain
Date: Mon, 21 Jul 2008 05:09:11 +0530
Message-Id: <1216597151.3679.125.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declaring arch-dependent syscalls for m68knommu architecture

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 arch/m68knommu/kernel/process.c  |    1 +
 include/asm-m68knommu/syscalls.h |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/arch/m68knommu/kernel/process.c b/arch/m68knommu/kernel/process.c
index 47502d5..30dea18 100644
--- a/arch/m68knommu/kernel/process.c
+++ b/arch/m68knommu/kernel/process.c
@@ -29,6 +29,7 @@
 #include <linux/interrupt.h>
 #include <linux/reboot.h>
 #include <linux/fs.h>
+#include <linux/syscalls.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
diff --git a/include/asm-m68knommu/syscalls.h b/include/asm-m68knommu/syscalls.h
index e69de29..e4b5c95 100644
--- a/include/asm-m68knommu/syscalls.h
+++ b/include/asm-m68knommu/syscalls.h
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
+#ifndef _ASM_M68KNOMMU_SYSCALLS_H
+#define _ASM_M68KNOMMU_SYSCALLS_H
+
+/* kernel/process.c */
+asmlinkage int sys_execve(char *, char **, char **);
+
+/* kernel/signal.c */
+asmlinkage int sys_sigaction(int, const struct old_sigaction *,
+			     struct old_sigaction *);
+asmlinkage int sys_sigaltstack(const stack_t *, stack_t *);
+
+/* kernel/sys_m68k.c */
+asmlinkage long sys_mmap2(unsigned long, unsigned long, unsigned long,
+			  unsigned long, unsigned long, unsigned long);
+struct mmap_arg_struct;
+asmlinkage int old_mmap(struct mmap_arg_struct *);
+struct sel_arg_struct;
+asmlinkage int old_select(struct sel_arg_struct *);
+asmlinkage int sys_ipc(uint, int, int, int, void *, long);
+asmlinkage int sys_cacheflush(unsigned long, int, int, unsigned long);
+asmlinkage int sys_getpagesize(void);
+
+#endif /* _ASM_M68KNOMMU_SYSCALLS_H */
-- 
1.5.5.1




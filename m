Return-Path: <linux-kernel-owner+w=401wt.eu-S1757868AbYGUAE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868AbYGUAE3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 20:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756940AbYGUADK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 20:03:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58542 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747AbYGUADJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 20:03:09 -0400
Subject: [PATCH 5/22] blackfin: Introducing asm/syscalls.h
From: Jaswinder Singh <jaswinder@infradead.org>
To: LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       David Woodhouse <dwmw2@infradead.org>, cooloney@kernel.org
In-Reply-To: <1216596035.3679.95.camel@jaswinder.satnam>
References: <1216592500.3679.14.camel@jaswinder.satnam>
	 <1216592798.3679.22.camel@jaswinder.satnam>
	 <1216592879.3679.24.camel@jaswinder.satnam>
	 <1216593035.3679.27.camel@jaswinder.satnam>
	 <1216596035.3679.95.camel@jaswinder.satnam>
Content-Type: text/plain
Date: Mon, 21 Jul 2008 04:51:46 +0530
Message-Id: <1216596106.3679.98.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declaring arch-dependent syscalls for blackfin architecture

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 arch/blackfin/kernel/process.c  |    1 +
 include/asm-blackfin/syscalls.h |   29 +++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 53c2cd2..6ca088c 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -36,6 +36,7 @@
 #include <linux/tick.h>
 #include <linux/fs.h>
 #include <linux/err.h>
+#include <linux/syscalls.h>
 
 #include <asm/blackfin.h>
 #include <asm/fixed_code.h>
diff --git a/include/asm-blackfin/syscalls.h b/include/asm-blackfin/syscalls.h
index e69de29..73927f5 100644
--- a/include/asm-blackfin/syscalls.h
+++ b/include/asm-blackfin/syscalls.h
@@ -0,0 +1,29 @@
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
+#ifndef _ASM_BLACKFIN_SYSCALLS_H
+#define _ASM_BLACKFIN_SYSCALLS_H
+
+/* kernel/process.c */
+asmlinkage int sys_execve(char __user *, char __user * __user *,
+			  char __user * __user *);
+
+/* kernel/signal.c */
+asmlinkage int sys_sigaltstack(const stack_t __user *, stack_t __user *);
+
+/* kernel/sys_bfin.c */
+asmlinkage long sys_mmap2(unsigned long, unsigned long, unsigned long,
+			  unsigned long, unsigned long, unsigned long);
+asmlinkage void *sys_sram_alloc(size_t, unsigned long);
+asmlinkage int sys_sram_free(const void *);
+asmlinkage void *sys_dma_memcpy(void *, const void *, size_t);
+
+#endif /* _ASM_BLACKFIN_SYSCALLS_H */
-- 
1.5.5.1




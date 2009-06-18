Return-Path: <linux-kernel-owner+w=401wt.eu-S1760335AbZFRSBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760335AbZFRSBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 14:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756260AbZFRSBC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 14:01:02 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:59399 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbZFRSA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 14:00:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <monstr@monstr.eu>
Cc: microblaze-uclinux@itee.uq.edu.au, LKML <linux-kernel@vger.kernel.org>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 10/11] microblaze: use generic system.h
Date: Thu, 18 Jun 2009 19:55:34 +0200
Message-Id: <4372408b2a754e861984bf803d8b1ade651eb827.1245347640.git.arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <cover.1245345894.git.arnd@arndb.de>
References: <cover.1245345894.git.arnd@arndb.de>
In-Reply-To: <24d10c58e2739bacec05d641ab2a2c95ce6d69a9.1245347640.git.arnd@arndb.de>
References: <24d10c58e2739bacec05d641ab2a2c95ce6d69a9.1245347640.git.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18vLMWIV7IkC2eho/8FfKAWRY2Dkr9Zt4IPAhF
 IebiXeeeJtoGTN6qPxu1hoeD7nvLVfeTBs6WCHP+NbSKhZQdgk
 xREMKAESj2x1zed4l2xsw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Remis Lima Baima <remis.developer@googlemail.com>

Parts of the microblaze system.h can be removed by
falling back to the asm-generic version.

Signed-off-by: Remis Lima Baima <remis.developer@googlemail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/microblaze/include/asm/cmpxchg-local.h |    1 +
 arch/microblaze/include/asm/irqflags.h      |    2 +-
 arch/microblaze/include/asm/system.h        |  124 +++++++--------------------
 3 files changed, 32 insertions(+), 95 deletions(-)
 create mode 100644 arch/microblaze/include/asm/cmpxchg-local.h
 rewrite arch/microblaze/include/asm/system.h (67%)

diff --git a/arch/microblaze/include/asm/cmpxchg-local.h b/arch/microblaze/include/asm/cmpxchg-local.h
new file mode 100644
index 0000000..d3358a3
--- /dev/null
+++ b/arch/microblaze/include/asm/cmpxchg-local.h
@@ -0,0 +1 @@
+#include <asm-generic/cmpxchg-local.h>
diff --git a/arch/microblaze/include/asm/irqflags.h b/arch/microblaze/include/asm/irqflags.h
index dea6564..a6dbdee 100644
--- a/arch/microblaze/include/asm/irqflags.h
+++ b/arch/microblaze/include/asm/irqflags.h
@@ -9,7 +9,7 @@
 #ifndef _ASM_MICROBLAZE_IRQFLAGS_H
 #define _ASM_MICROBLAZE_IRQFLAGS_H
 
-#include <linux/irqflags.h>
+#include <asm/registers.h>
 
 # if CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR
 
diff --git a/arch/microblaze/include/asm/system.h b/arch/microblaze/include/asm/system.h
dissimilarity index 67%
index b1ed615..a26ef8e 100644
--- a/arch/microblaze/include/asm/system.h
+++ b/arch/microblaze/include/asm/system.h
@@ -1,94 +1,30 @@
-/*
- * Copyright (C) 2006 Atmark Techno, Inc.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef _ASM_MICROBLAZE_SYSTEM_H
-#define _ASM_MICROBLAZE_SYSTEM_H
-
-#include <asm/registers.h>
-#include <asm/setup.h>
-#include <asm/irqflags.h>
-
-#include <asm-generic/cmpxchg.h>
-#include <asm-generic/cmpxchg-local.h>
-
-struct task_struct;
-struct thread_info;
-
-extern struct task_struct *_switch_to(struct thread_info *prev,
-					struct thread_info *next);
-
-#define switch_to(prev, next, last)					\
-	do {								\
-		(last) = _switch_to(task_thread_info(prev),		\
-					task_thread_info(next));	\
-	} while (0)
-
-#define smp_read_barrier_depends()	do {} while (0)
-#define read_barrier_depends()		do {} while (0)
-
-#define nop()			asm volatile ("nop")
-#define mb()			barrier()
-#define rmb()			mb()
-#define wmb()			mb()
-#define set_mb(var, value)	do { var = value; mb(); } while (0)
-#define set_wmb(var, value)	do { var = value; wmb(); } while (0)
-
-#define smp_mb()		mb()
-#define smp_rmb()		rmb()
-#define smp_wmb()		wmb()
-
-void show_trace(struct task_struct *task, unsigned long *stack);
-void __bad_xchg(volatile void *ptr, int size);
-
-static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
-								int size)
-{
-	unsigned long ret;
-	unsigned long flags;
-
-	switch (size) {
-	case 1:
-		local_irq_save(flags);
-		ret = *(volatile unsigned char *)ptr;
-		*(volatile unsigned char *)ptr = x;
-		local_irq_restore(flags);
-		break;
-
-	case 4:
-		local_irq_save(flags);
-		ret = *(volatile unsigned long *)ptr;
-		*(volatile unsigned long *)ptr = x;
-		local_irq_restore(flags);
-		break;
-	default:
-		__bad_xchg(ptr, size), ret = 0;
-		break;
-	}
-
-	return ret;
-}
-
-void disable_hlt(void);
-void enable_hlt(void);
-void default_idle(void);
-
-#define xchg(ptr, x) \
-	((__typeof__(*(ptr))) __xchg((unsigned long)(x), (ptr), sizeof(*(ptr))))
-
-void free_init_pages(char *what, unsigned long begin, unsigned long end);
-void free_initmem(void);
-extern char *klimit;
-extern void ret_from_fork(void);
-
-#ifdef CONFIG_DEBUG_FS
-extern struct dentry *of_debugfs_root;
-#endif
-
-#define arch_align_stack(x) (x)
-
-#endif /* _ASM_MICROBLAZE_SYSTEM_H */
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+#ifndef _ASM_MICROBLAZE_SYSTEM_H
+#define _ASM_MICROBLAZE_SYSTEM_H
+
+#define __switch_to	_switch_to
+
+#include <asm/irqflags.h>
+#include <asm-generic/system.h>
+
+#ifdef CONFIG_DEBUG_FS
+extern struct dentry *of_debugfs_root;
+#endif
+
+void show_trace(struct task_struct *task, unsigned long *stack);
+void disable_hlt(void);
+void enable_hlt(void);
+void default_idle(void);
+void free_init_pages(char *what, unsigned long begin, unsigned long end);
+void free_initmem(void);
+
+extern char *klimit;
+extern void ret_from_fork(void);
+
+#endif /* _ASM_MICROBLAZE_SYSTEM_H */
-- 
1.6.3.1


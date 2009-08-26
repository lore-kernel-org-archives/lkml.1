Return-Path: <linux-kernel-owner+w=401wt.eu-S1753986AbZHZG2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbZHZG2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753503AbZHZG2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:28:20 -0400
Received: from 124-219-29-227.vdslpro.static.apol.com.tw ([124.219.29.227]:52548
	"EHLO mswedge2.sunplus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752525AbZHZG2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:28:19 -0400
Subject: Subject: [PATCH 11/33] score: create head files hardirq.h hw_irq.h
	irq.h irqflags.h irq_regs.h
From: Chen Liqin <liqin.chen@sunplusct.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, torvalds@linux-foundation.org
Content-Type: text/plain
Date: Wed, 26 Aug 2009 14:17:48 +0800
Message-Id: <1251267468.3073.14.camel@ad3ser01>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f305766cc791c2e727aa80be85af6df5cf707dd0 Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Wed, 26 Aug 2009 10:05:01 +0800
Subject: [PATCH 11/33] score: create head files hardirq.h hw_irq.h irq.h irqflags.h irq_regs.h


Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/include/asm/hardirq.h  |    6 ++
 arch/score/include/asm/hw_irq.h   |    4 ++
 arch/score/include/asm/irq.h      |   25 +++++++++
 arch/score/include/asm/irq_regs.h |   11 ++++
 arch/score/include/asm/irqflags.h |  109 +++++++++++++++++++++++++++++++++++++
 5 files changed, 155 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/include/asm/hardirq.h
 create mode 100644 arch/score/include/asm/hw_irq.h
 create mode 100644 arch/score/include/asm/irq.h
 create mode 100644 arch/score/include/asm/irq_regs.h
 create mode 100644 arch/score/include/asm/irqflags.h

diff --git a/arch/score/include/asm/hardirq.h b/arch/score/include/asm/hardirq.h
new file mode 100644
index 0000000..dc932c5
--- /dev/null
+++ b/arch/score/include/asm/hardirq.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_HARDIRQ_H
+#define _ASM_SCORE_HARDIRQ_H
+
+#include <asm-generic/hardirq.h>
+
+#endif /* _ASM_SCORE_HARDIRQ_H */
diff --git a/arch/score/include/asm/hw_irq.h b/arch/score/include/asm/hw_irq.h
new file mode 100644
index 0000000..4caafb2
--- /dev/null
+++ b/arch/score/include/asm/hw_irq.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_SCORE_HW_IRQ_H
+#define _ASM_SCORE_HW_IRQ_H
+
+#endif /* _ASM_SCORE_HW_IRQ_H */
diff --git a/arch/score/include/asm/irq.h b/arch/score/include/asm/irq.h
new file mode 100644
index 0000000..c883f3d
--- /dev/null
+++ b/arch/score/include/asm/irq.h
@@ -0,0 +1,25 @@
+#ifndef _ASM_SCORE_IRQ_H
+#define _ASM_SCORE_IRQ_H
+
+#define EXCEPTION_VECTOR_BASE_ADDR	0xa0000000
+#define VECTOR_ADDRESS_OFFSET_MODE4	0
+#define VECTOR_ADDRESS_OFFSET_MODE16	1
+
+#define DEBUG_VECTOR_SIZE		(0x4)
+#define DEBUG_VECTOR_BASE_ADDR		((EXCEPTION_VECTOR_BASE_ADDR) + 0x1fc)
+
+#define GENERAL_VECTOR_SIZE		(0x10)
+#define GENERAL_VECTOR_BASE_ADDR	((EXCEPTION_VECTOR_BASE_ADDR) + 0x200)
+
+#define NR_IRQS				64
+#define IRQ_VECTOR_SIZE			(0x10)
+#define IRQ_VECTOR_BASE_ADDR		((EXCEPTION_VECTOR_BASE_ADDR) + 0x210)
+#define IRQ_VECTOR_END_ADDR		((EXCEPTION_VECTOR_BASE_ADDR) + 0x5f0)
+
+#define irq_canonicalize(irq)	(irq)
+
+#define IRQ_TIMER (7)		/* Timer IRQ number of SPCT6600 */
+
+extern void interrupt_exception_vector(void);
+
+#endif /* _ASM_SCORE_IRQ_H */
diff --git a/arch/score/include/asm/irq_regs.h b/arch/score/include/asm/irq_regs.h
new file mode 100644
index 0000000..b8e881c
--- /dev/null
+++ b/arch/score/include/asm/irq_regs.h
@@ -0,0 +1,11 @@
+#ifndef _ASM_SCORE_IRQ_REGS_H
+#define _ASM_SCORE_IRQ_REGS_H
+
+#include <linux/thread_info.h>
+
+static inline struct pt_regs *get_irq_regs(void)
+{
+	return current_thread_info()->regs;
+}
+
+#endif /* _ASM_SCORE_IRQ_REGS_H */
diff --git a/arch/score/include/asm/irqflags.h b/arch/score/include/asm/irqflags.h
new file mode 100644
index 0000000..690a6ca
--- /dev/null
+++ b/arch/score/include/asm/irqflags.h
@@ -0,0 +1,109 @@
+#ifndef _ASM_SCORE_IRQFLAGS_H
+#define _ASM_SCORE_IRQFLAGS_H
+
+#ifndef __ASSEMBLY__
+
+#define raw_local_irq_save(x)			\
+{						\
+	__asm__ __volatile__(			\
+		"mfcr	r8, cr0;"		\
+		"li	r9, 0xfffffffe;"	\
+		"nop;"				\
+		"mv	%0, r8;"		\
+		"and	r8, r8, r9;"		\
+		"mtcr	r8, cr0;"		\
+		"nop;"				\
+		"nop;"				\
+		"nop;"				\
+		"nop;"				\
+		"nop;"				\
+		: "=r" (x)			\
+		:				\
+		: "r8", "r9"			\
+		);				\
+}
+
+#define raw_local_irq_restore(x)		\
+{						\
+	__asm__ __volatile__(			\
+		"mfcr	r8, cr0;"		\
+		"ldi	r9, 0x1;"		\
+		"and	%0, %0, r9;"		\
+		"or	r8, r8, %0;"		\
+		"mtcr	r8, cr0;"		\
+		"nop;"				\
+		"nop;"				\
+		"nop;"				\
+		"nop;"				\
+		"nop;"				\
+		:				\
+		: "r"(x)			\
+		: "r8", "r9"			\
+		);				\
+}
+
+#define raw_local_irq_enable(void)		\
+{						\
+	__asm__ __volatile__(			\
+		"mfcr\tr8,cr0;"			\
+		"nop;"				\
+		"nop;"				\
+		"ori\tr8,0x1;"			\
+		"mtcr\tr8,cr0;"			\
+		"nop;"				\
+		"nop;"				\
+		"nop;"				\
+		"nop;"				\
+		"nop;"				\
+		:				\
+		:				\
+		: "r8");			\
+}
+
+#define raw_local_irq_disable(void)		\
+{						\
+	__asm__ __volatile__(			\
+		"mfcr\tr8,cr0;"			\
+		"nop;"				\
+		"nop;"				\
+		"srli\tr8,r8,1;"		\
+		"slli\tr8,r8,1;"		\
+		"mtcr\tr8,cr0;"			\
+		"nop;"				\
+		"nop;"				\
+		"nop;"				\
+		"nop;"				\
+		"nop;"				\
+		:				\
+		:				\
+		: "r8");			\
+}
+
+#define raw_local_save_flags(x)			\
+{						\
+	__asm__ __volatile__(			\
+		"mfcr	r8, cr0;"		\
+		"nop;"				\
+		"nop;"				\
+		"mv	%0, r8;"		\
+		"nop;"				\
+		"nop;"				\
+		"nop;"				\
+		"nop;"				\
+		"nop;"				\
+		"ldi	r9, 0x1;"		\
+		"and	%0, %0, r9;"		\
+		: "=r" (x)			\
+		:				\
+		: "r8", "r9"			\
+		);				\
+}
+
+static inline int raw_irqs_disabled_flags(unsigned long flags)
+{
+	return !(flags & 1);
+}
+
+#endif
+
+#endif /* _ASM_SCORE_IRQFLAGS_H */
-- 
1.6.2




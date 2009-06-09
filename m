Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbZFIGfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbZFIGfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 02:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbZFIGfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 02:35:16 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:36812 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbZFIGfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 02:35:15 -0400
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: [PATCH 10/27] score: create head files ioctl.h ioctls.h io.h ipcbuf.h
 irqflags.h irq.h irq_regs.h
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF52D1B01C.30E802C6-ON482575D0.002387A7-482575D0.0023F9F2@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Tue, 9 Jun 2009 14:28:40 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/06/09 ?? 02:28:40,
	Serialize complete at 2009/06/09 ?? 02:28:40
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 0acb91f274e6fdc2a55941215664d05bcbfecadb Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Tue, 9 Jun 2009 13:43:09 +0800



Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/include/asm/io.h       |    9 +++
 arch/score/include/asm/ioctl.h    |    6 ++
 arch/score/include/asm/ioctls.h   |    6 ++
 arch/score/include/asm/ipcbuf.h   |    6 ++
 arch/score/include/asm/irq.h      |   33 +++++++++++
 arch/score/include/asm/irq_regs.h |    6 ++
 arch/score/include/asm/irqflags.h |  111 
+++++++++++++++++++++++++++++++++++++
 7 files changed, 177 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/include/asm/io.h
 create mode 100644 arch/score/include/asm/ioctl.h
 create mode 100644 arch/score/include/asm/ioctls.h
 create mode 100644 arch/score/include/asm/ipcbuf.h
 create mode 100644 arch/score/include/asm/irq.h
 create mode 100644 arch/score/include/asm/irq_regs.h
 create mode 100644 arch/score/include/asm/irqflags.h

diff --git a/arch/score/include/asm/io.h b/arch/score/include/asm/io.h
new file mode 100644
index 0000000..fbbfd71
--- /dev/null
+++ b/arch/score/include/asm/io.h
@@ -0,0 +1,9 @@
+#ifndef _ASM_SCORE_IO_H
+#define _ASM_SCORE_IO_H
+
+#include <asm-generic/io.h>
+
+#define virt_to_bus    virt_to_phys
+#define bus_to_virt    phys_to_virt
+
+#endif /* _ASM_SCORE_IO_H */
diff --git a/arch/score/include/asm/ioctl.h 
b/arch/score/include/asm/ioctl.h
new file mode 100644
index 0000000..a351d21
--- /dev/null
+++ b/arch/score/include/asm/ioctl.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_IOCTL_H
+#define _ASM_SCORE_IOCTL_H
+
+#include <asm-generic/ioctl.h>
+
+#endif /* _ASM_SCORE_IOCTL_H */
diff --git a/arch/score/include/asm/ioctls.h 
b/arch/score/include/asm/ioctls.h
new file mode 100644
index 0000000..ed01d2b
--- /dev/null
+++ b/arch/score/include/asm/ioctls.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_IOCTLS_H
+#define _ASM_SCORE_IOCTLS_H
+
+#include <asm-generic/ioctls.h>
+
+#endif /* _ASM_SCORE_IOCTLS_H */
diff --git a/arch/score/include/asm/ipcbuf.h 
b/arch/score/include/asm/ipcbuf.h
new file mode 100644
index 0000000..e082cef
--- /dev/null
+++ b/arch/score/include/asm/ipcbuf.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_IPCBUF_H
+#define _ASM_SCORE_IPCBUF_H
+
+#include <asm-generic/ipcbuf.h>
+
+#endif /* _ASM_SCORE_IPCBUF_H */
diff --git a/arch/score/include/asm/irq.h b/arch/score/include/asm/irq.h
new file mode 100644
index 0000000..401f670
--- /dev/null
+++ b/arch/score/include/asm/irq.h
@@ -0,0 +1,33 @@
+#ifndef _ASM_SCORE_IRQ_H
+#define _ASM_SCORE_IRQ_H
+
+#define EXCEPTION_VECTOR_BASE_ADDR     0xa0000000
+#define VECTOR_ADDRESS_OFFSET_MODE4    0
+#define VECTOR_ADDRESS_OFFSET_MODE16   1
+
+#define DEBUG_VECTOR_SIZE              (0x4)
+#define DEBUG_VECTOR_BASE_ADDR         ((EXCEPTION_VECTOR_BASE_ADDR) + 
0x1fc)
+
+#define GENERAL_VECTOR_SIZE            (0x10)
+#define GENERAL_VECTOR_BASE_ADDR       ((EXCEPTION_VECTOR_BASE_ADDR) + 
0x200)
+
+#define NR_IRQS                                64
+#define IRQ_VECTOR_SIZE                        (0x10)
+#define IRQ_VECTOR_BASE_ADDR           ((EXCEPTION_VECTOR_BASE_ADDR) + 
0x210)
+#define IRQ_VECTOR_END_ADDR            ((EXCEPTION_VECTOR_BASE_ADDR) + 
0x5f0)
+
+#define irq_canonicalize(irq)  (irq)
+
+#define P_INT_PNDL             0x95F50000
+#define P_INT_PNDH             0x95F50004
+#define P_INT_PRIORITY_M       0x95F50008
+#define P_INT_PRIORITY_SG0     0x95F50010
+#define P_INT_PRIORITY_SG1     0x95F50014
+#define P_INT_PRIORITY_SG2     0x95F50018
+#define P_INT_PRIORITY_SG3     0x95F5001C
+#define P_INT_MASKL            0x95F50020
+#define P_INT_MASKH            0x95F50024
+
+#define IRQ_TIMER (7)          /* Timer IRQ number of SPCT6600 */
+
+#endif /* _ASM_SCORE_IRQ_H */
diff --git a/arch/score/include/asm/irq_regs.h 
b/arch/score/include/asm/irq_regs.h
new file mode 100644
index 0000000..905b7b0
--- /dev/null
+++ b/arch/score/include/asm/irq_regs.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_IRQ_REGS_H
+#define _ASM_SCORE_IRQ_REGS_H
+
+#include <asm-generic/irq_regs.h>
+
+#endif /* _ASM_SCORE_IRQ_REGS_H */
diff --git a/arch/score/include/asm/irqflags.h 
b/arch/score/include/asm/irqflags.h
new file mode 100644
index 0000000..92eeb33
--- /dev/null
+++ b/arch/score/include/asm/irqflags.h
@@ -0,0 +1,111 @@
+#ifndef _ASM_SCORE_IRQFLAGS_H
+#define _ASM_SCORE_IRQFLAGS_H
+
+#ifndef __ASSEMBLY__
+
+#define raw_local_irq_save(x)                  \
+{                                              \
+       __asm__ __volatile__(                   \
+               "mfcr   r8, cr0;"               \
+               "li     r9, 0xfffffffe;"        \
+               "nop;"                          \
+               "mv     %0, r8;"                \
+               "and    r8, r8, r9;"            \
+               "mtcr   r8, cr0;"               \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               "ldi    r9, 0x1;"               \
+               "and    %0, %0, r9;"            \
+               : "=r" (x)                      \
+               :                               \
+               : "r8", "r9"                    \
+               );                              \
+}
+
+#define raw_local_irq_restore(x)               \
+{                                              \
+       __asm__ __volatile__(                   \
+               "mfcr   r8, cr0;"               \
+               "ldi    r9, 0x1;"               \
+               "and    %0, %0, r9;"            \
+               "or     r8, r8, %0;"            \
+               "mtcr   r8, cr0;"               \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               :                               \
+               : "r"(x)                        \
+               : "r8", "r9"                    \
+               );                              \
+}
+
+#define raw_local_irq_enable(void)             \
+{                                              \
+       __asm__ __volatile__(                   \
+               "mfcr\tr8,cr0;"                 \
+               "nop;"                          \
+               "nop;"                          \
+               "ori\tr8,0x1;"                  \
+               "mtcr\tr8,cr0;"                 \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               :                               \
+               :                               \
+               : "r8");                        \
+}
+
+#define raw_local_irq_disable(void)            \
+{                                              \
+       __asm__ __volatile__(                   \
+               "mfcr\tr8,cr0;"                 \
+               "nop;"                          \
+               "nop;"                          \
+               "srli\tr8,r8,1;"                \
+               "slli\tr8,r8,1;"                \
+               "mtcr\tr8,cr0;"                 \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               :                               \
+               :                               \
+               : "r8");                        \
+}
+
+#define raw_local_save_flags(x)                        \
+{                                              \
+       __asm__ __volatile__(                   \
+               "mfcr   r8, cr0;"               \
+               "nop;"                          \
+               "nop;"                          \
+               "mv     %0, r8;"                \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               "ldi    r9, 0x1;"               \
+               "and    %0, %0, r9;"            \
+               : "=r" (x)                      \
+               :                               \
+               : "r8", "r9"                    \
+               );                              \
+}
+
+static inline int raw_irqs_disabled_flags(unsigned long flags)
+{
+       return !(flags & 1);
+}
+
+#endif
+
+#endif /* _ASM_SCORE_IRQFLAGS_H */
-- 
1.6.2


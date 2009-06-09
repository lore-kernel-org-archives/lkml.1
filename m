Return-Path: <linux-kernel-owner+w=401wt.eu-S1757781AbZFIGi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781AbZFIGi0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 02:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756590AbZFIGiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 02:38:18 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:58380 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111AbZFIGiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 02:38:16 -0400
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: [PATCH 17/27] score: create head files termbits.h termios.h thread_info.h
 timex.h tlbflush.h tlb.h topology.h types.h
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OFAD8FAF98.DFB73657-ON482575D0.0023F74A-482575D0.002468DA@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Tue, 9 Jun 2009 14:33:24 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/06/09 ?? 02:33:25,
	Serialize complete at 2009/06/09 ?? 02:33:25
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a8821850ed08c0d2a49a1564f2a10e0d2cc6f2f4 Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Tue, 9 Jun 2009 13:43:14 +0800
Subject: [PATCH 17/27] score: create head files termbits.h termios.h 
thread_info.h timex.h tlbflush.h tlb.h topology.h types.h


Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/include/asm/termbits.h    |    6 ++
 arch/score/include/asm/termios.h     |    6 ++
 arch/score/include/asm/thread_info.h |  103 ++++++++++++++++++++++++
 arch/score/include/asm/timex.h       |    6 ++
 arch/score/include/asm/tlb.h         |   17 ++++
 arch/score/include/asm/tlbflush.h    |  142 
++++++++++++++++++++++++++++++++++
 arch/score/include/asm/topology.h    |    6 ++
 arch/score/include/asm/types.h       |    6 ++
 8 files changed, 292 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/include/asm/termbits.h
 create mode 100644 arch/score/include/asm/termios.h
 create mode 100644 arch/score/include/asm/thread_info.h
 create mode 100644 arch/score/include/asm/timex.h
 create mode 100644 arch/score/include/asm/tlb.h
 create mode 100644 arch/score/include/asm/tlbflush.h
 create mode 100644 arch/score/include/asm/topology.h
 create mode 100644 arch/score/include/asm/types.h

diff --git a/arch/score/include/asm/termbits.h 
b/arch/score/include/asm/termbits.h
new file mode 100644
index 0000000..9a95c14
--- /dev/null
+++ b/arch/score/include/asm/termbits.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_TERMBITS_H
+#define _ASM_SCORE_TERMBITS_H
+
+#include <asm-generic/termbits.h>
+
+#endif /* _ASM_SCORE_TERMBITS_H */
diff --git a/arch/score/include/asm/termios.h 
b/arch/score/include/asm/termios.h
new file mode 100644
index 0000000..40984e8
--- /dev/null
+++ b/arch/score/include/asm/termios.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_TERMIOS_H
+#define _ASM_SCORE_TERMIOS_H
+
+#include <asm-generic/termios.h>
+
+#endif /* _ASM_SCORE_TERMIOS_H */
diff --git a/arch/score/include/asm/thread_info.h 
b/arch/score/include/asm/thread_info.h
new file mode 100644
index 0000000..0af8ca0
--- /dev/null
+++ b/arch/score/include/asm/thread_info.h
@@ -0,0 +1,103 @@
+#ifndef _ASM_SCORE_THREAD_INFO_H
+#define _ASM_SCORE_THREAD_INFO_H
+
+#ifdef __KERNEL__
+
+#define KU_MASK        0x08
+#define KU_USER        0x08
+#define KU_KERN        0x00
+
+#ifndef __ASSEMBLY__
+
+#include <asm/processor.h>
+
+/*
+ * low level task data that entry.S needs immediate access to
+ * - this struct should fit entirely inside of one cache line
+ * - this struct shares the supervisor stack pages
+ * - if the contents of this structure are changed, the assembly 
constants
+ *   must also be changed
+ */
+struct thread_info {
+       struct task_struct      *task;          /* main task structure */
+       struct exec_domain      *exec_domain;   /* execution domain */
+       unsigned long           flags;          /* low level flags */
+       unsigned long           tp_value;       /* thread pointer */
+       __u32                   cpu;            /* current CPU */
+
+       /* 0 => preemptable, < 0 => BUG */
+       int                     preempt_count;
+
+       /*
+        * thread address space:
+        * 0-0xBFFFFFFF for user-thead
+        * 0-0xFFFFFFFF for kernel-thread
+        */
+       mm_segment_t            addr_limit;
+       struct restart_block    restart_block;
+       struct pt_regs          *regs;
+};
+
+/*
+ * macros/functions for gaining access to the thread information 
structure
+ *
+ * preempt_count needs to be 1 initially, until the scheduler is 
functional.
+ */
+#define INIT_THREAD_INFO(tsk)                  \
+{                                              \
+       .task           = &tsk,                 \
+       .exec_domain    = &default_exec_domain, \
+       .cpu            = 0,                    \
+       .preempt_count  = 1,                    \
+       .addr_limit     = KERNEL_DS,            \
+       .restart_block  = {                     \
+               .fn = do_no_restart_syscall,    \
+       },                                      \
+}
+
+#define init_thread_info       (init_thread_union.thread_info)
+#define init_stack             (init_thread_union.stack)
+
+/* How to get the thread information struct from C. */
+register struct thread_info *__current_thread_info __asm__("r28");
+#define current_thread_info()  __current_thread_info
+
+/* thread information allocation */
+#define THREAD_SIZE_ORDER      (1)
+#define THREAD_SIZE            (PAGE_SIZE << THREAD_SIZE_ORDER)
+#define THREAD_MASK            (THREAD_SIZE - 1UL)
+#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
+
+#define alloc_thread_info(tsk) kmalloc(THREAD_SIZE, GFP_KERNEL)
+#define free_thread_info(info) kfree(info)
+
+#endif /* !__ASSEMBLY__ */
+
+#define PREEMPT_ACTIVE         0x10000000
+
+/*
+ * thread information flags
+ * - these are process state flags that various assembly files may need 
to
+ *   access
+ * - pending work-to-be-done flags are in LSW
+ * - other flags in MSW
+ */
+#define TIF_SYSCALL_TRACE      0       /* syscall trace active */
+#define TIF_SIGPENDING         1       /* signal pending */
+#define TIF_NEED_RESCHED       2       /* rescheduling necessary */
+#define TIF_RESTORE_SIGMASK    9       /* restore signal mask in 
do_signal() */
+#define TIF_POLLING_NRFLAG     17      /* true if poll_idle() is polling
+                                                TIF_NEED_RESCHED */
+#define TIF_MEMDIE             18
+
+#define _TIF_SYSCALL_TRACE     (1<<TIF_SYSCALL_TRACE)
+#define _TIF_SIGPENDING                (1<<TIF_SIGPENDING)
+#define _TIF_NEED_RESCHED      (1<<TIF_NEED_RESCHED)
+#define _TIF_RESTORE_SIGMASK   (1<<TIF_RESTORE_SIGMASK)
+#define _TIF_POLLING_NRFLAG    (1<<TIF_POLLING_NRFLAG)
+
+#define _TIF_WORK_MASK         (0x0000ffff)
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_SCORE_THREAD_INFO_H */
diff --git a/arch/score/include/asm/timex.h 
b/arch/score/include/asm/timex.h
new file mode 100644
index 0000000..5f3c92b
--- /dev/null
+++ b/arch/score/include/asm/timex.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_TIMEX_H
+#define _ASM_SCORE_TIMEX_H
+
+#include <asm-generic/timex.h>
+
+#endif /* _ASM_SCORE_TIMEX_H */
diff --git a/arch/score/include/asm/tlb.h b/arch/score/include/asm/tlb.h
new file mode 100644
index 0000000..46882ed
--- /dev/null
+++ b/arch/score/include/asm/tlb.h
@@ -0,0 +1,17 @@
+#ifndef _ASM_SCORE_TLB_H
+#define _ASM_SCORE_TLB_H
+
+/*
+ * SCORE doesn't need any special per-pte or per-vma handling, except
+ * we need to flush cache for area to be unmapped.
+ */
+#define tlb_start_vma(tlb, vma)                do {} while (0)
+#define tlb_end_vma(tlb, vma)          do {} while (0)
+#define __tlb_remove_tlb_entry(tlb, ptep, address) do {} while (0)
+#define tlb_flush(tlb)                 flush_tlb_mm((tlb)->mm)
+
+extern void score7_FTLB_refill_Handler(void);
+
+#include <asm-generic/tlb.h>
+
+#endif /* _ASM_SCORE_TLB_H */
diff --git a/arch/score/include/asm/tlbflush.h 
b/arch/score/include/asm/tlbflush.h
new file mode 100644
index 0000000..9cce978
--- /dev/null
+++ b/arch/score/include/asm/tlbflush.h
@@ -0,0 +1,142 @@
+#ifndef _ASM_SCORE_TLBFLUSH_H
+#define _ASM_SCORE_TLBFLUSH_H
+
+#include <linux/mm.h>
+
+/*
+ * TLB flushing:
+ *
+ * - flush_tlb_all() flushes all processes TLB entries
+ * - flush_tlb_mm(mm) flushes the specified mm context TLB entries
+ * - flush_tlb_page(vma, vmaddr) flushes one page
+ * - flush_tlb_range(vma, start, end) flushes a range of pages
+ * - flush_tlb_kernel_range(start, end) flushes a range of kernel pages
+ */
+extern void local_flush_tlb_all(void);
+extern void local_flush_tlb_mm(struct mm_struct *mm);
+extern void local_flush_tlb_range(struct vm_area_struct *vma,
+       unsigned long start, unsigned long end);
+extern void local_flush_tlb_kernel_range(unsigned long start,
+       unsigned long end);
+extern void local_flush_tlb_page(struct vm_area_struct *vma,
+       unsigned long page);
+extern void local_flush_tlb_one(unsigned long vaddr);
+
+#define flush_tlb_all()                        local_flush_tlb_all()
+#define flush_tlb_mm(mm)               local_flush_tlb_mm(mm)
+#define flush_tlb_range(vma, vmaddr, end) \
+       local_flush_tlb_range(vma, vmaddr, end)
+#define flush_tlb_kernel_range(vmaddr, end) \
+       local_flush_tlb_kernel_range(vmaddr, end)
+#define flush_tlb_page(vma, page)      local_flush_tlb_page(vma, page)
+#define flush_tlb_one(vaddr)           local_flush_tlb_one(vaddr)
+
+#ifndef __ASSEMBLY__
+
+static inline unsigned long pevn_get(void)
+{
+       unsigned long val;
+
+       __asm__ __volatile__(
+               "mfcr %0, cr11\n"
+               "nop\nnop\n"
+               : "=r" (val));
+
+       return val;
+}
+
+static inline void pevn_set(unsigned long val)
+{
+       __asm__ __volatile__(
+               "mtcr %0, cr11\n"
+               "nop\nnop\nnop\nnop\nnop\n"
+       : : "r" (val));
+}
+
+static inline void pectx_set(unsigned long val)
+{
+       __asm__ __volatile__(
+               "mtcr %0, cr12\n"
+               "nop\nnop\nnop\nnop\nnop\n"
+       : : "r" (val));
+}
+
+static inline unsigned long pectx_get(void)
+{
+       unsigned long val;
+       __asm__ __volatile__(
+               "mfcr %0, cr12\n"
+               "nop\nnop\n"
+       : "=r" (val));
+       return val;
+}
+static inline unsigned long tlblock_get(void)
+{
+       unsigned long val;
+
+       __asm__ __volatile__(
+               "mfcr %0, cr7\n"
+               "nop\nnop\n"
+       : "=r" (val));
+       return val;
+}
+static inline void tlblock_set(unsigned long val)
+{
+       __asm__ __volatile__(
+               "mtcr %0, cr7\n"
+               "nop\nnop\nnop\nnop\nnop\n"
+       : : "r" (val));
+}
+
+static inline void tlbpt_set(unsigned long val)
+{
+       __asm__ __volatile__(
+               "mtcr %0, cr8\n"
+               "nop\nnop\nnop\nnop\nnop\n"
+               : : "r" (val));
+}
+
+static inline long tlbpt_get(void)
+{
+       long val;
+
+       __asm__ __volatile__(
+               "mfcr %0, cr8\n"
+               "nop\nnop\n"
+               : "=r" (val));
+
+       return val;
+}
+
+static inline void peaddr_set(unsigned long val)
+{
+       __asm__ __volatile__(
+               "mtcr %0, cr9\n"
+               "nop\nnop\nnop\nnop\nnop\n"
+               : : "r" (val));
+}
+
+/* TLB operations. */
+static inline void tlb_probe(void)
+{
+       __asm__ __volatile__("stlb;nop;nop;nop;nop;nop");
+}
+
+static inline void tlb_read(void)
+{
+       __asm__ __volatile__("mftlb;nop;nop;nop;nop;nop");
+}
+
+static inline void tlb_write_indexed(void)
+{
+       __asm__ __volatile__("mtptlb;nop;nop;nop;nop;nop");
+}
+
+static inline void tlb_write_random(void)
+{
+       __asm__ __volatile__("mtrtlb;nop;nop;nop;nop;nop");
+}
+
+#endif /* Not __ASSEMBLY__ */
+
+#endif /* _ASM_SCORE_TLBFLUSH_H */
diff --git a/arch/score/include/asm/topology.h 
b/arch/score/include/asm/topology.h
new file mode 100644
index 0000000..425fba3
--- /dev/null
+++ b/arch/score/include/asm/topology.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_TOPOLOGY_H
+#define _ASM_SCORE_TOPOLOGY_H
+
+#include <asm-generic/topology.h>
+
+#endif /* _ASM_SCORE_TOPOLOGY_H */
diff --git a/arch/score/include/asm/types.h 
b/arch/score/include/asm/types.h
new file mode 100644
index 0000000..2140032
--- /dev/null
+++ b/arch/score/include/asm/types.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_TYPES_H
+#define _ASM_SCORE_TYPES_H
+
+#include <asm-generic/types.h>
+
+#endif /* _ASM_SCORE_TYPES_H */
-- 
1.6.2


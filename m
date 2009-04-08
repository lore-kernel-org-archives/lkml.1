Return-Path: <linux-kernel-owner+w=401wt.eu-S1763278AbZDHH3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763278AbZDHH3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763098AbZDHH2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:28:04 -0400
Received: from 60-248-182-106.HINET-IP.hinet.net ([60.248.182.106]:55708 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763099AbZDHH17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:27:59 -0400
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, Arnd Bergmann <arnd@arndb.de>,
       Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Kyle McMartin <kyle@mcmartin.ca>
MIME-Version: 1.0
Subject: [PATCH 6/14] score - New architecure port to SunplusCT S+CORE
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF07A7AD07.6A821943-ON48257592.0028B5E3-48257592.0028FC8B@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Wed, 8 Apr 2009 15:25:32 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/04/08 ?? 03:25:32,
	Serialize complete at 2009/04/08 ?? 03:25:32
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chen Liqin <liqin.chen@sunplusct.com>

asm/termios.h, asm/thread_info.h, asm/timex.h, asm/tlbflush.h,
asm/tlb.h, asm/topology.h, asm/types.h, asm/uaccess.h, asm/ucontext.h,
asm/unaligned.h, asm/unistd.h and asm/user.h for the score architecture.

Signed off by: Chen Liqin <liqin.chen@sunplusct.com>
Signed off by: Lennox Wu <lennox.wu@sunplusct.com>
--

diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/termios.h 
linux-2.6-git.new/arch/score/include/asm/termios.h
--- linux-2.6-git.ori/arch/score/include/asm/termios.h  1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/termios.h  2009-04-03 
17:07:30.000000000 +0800
@@ -0,0 +1,85 @@
+#ifndef __SCORE_TERMIOS_H
+#define __SCORE_TERMIOS_H
+
+#include <asm/termbits.h>
+#include <asm/ioctls.h>
+
+struct sgttyb {
+       char    sg_ispeed;
+       char    sg_ospeed;
+       char    sg_erase;
+       char    sg_kill;
+       int     sg_flags;       /* SGI special - int, not short */
+};
+
+struct tchars {
+       char    t_intrc;
+       char    t_quitc;
+       char    t_startc;
+       char    t_stopc;
+       char    t_eofc;
+       char    t_brkc;
+};
+
+struct ltchars {
+       char    t_suspc;        /* stop process signal */
+       char    t_dsuspc;       /* delayed stop process signal */
+       char    t_rprntc;       /* reprint line */
+       char    t_flushc;       /* flush output (toggles) */
+       char    t_werasc;       /* word erase */
+       char    t_lnextc;       /* literal next character */
+};
+
+/* TIOCGSIZE, TIOCSSIZE not defined yet.  Only needed for SunOS source
+   compatibility anyway ... */
+
+struct winsize {
+       unsigned short ws_row;
+       unsigned short ws_col;
+       unsigned short ws_xpixel;
+       unsigned short ws_ypixel;
+};
+
+#define NCC    8
+struct termio {
+       unsigned short c_iflag;         /* input mode flags */
+       unsigned short c_oflag;         /* output mode flags */
+       unsigned short c_cflag;         /* control mode flags */
+       unsigned short c_lflag;         /* local mode flags */
+       char c_line;                    /* line discipline */
+       unsigned char c_cc[NCCS];       /* control characters */
+};
+
+#ifdef __KERNEL__
+#include <linux/module.h>
+
+/*
+ *     intr=^C         quit=^\         erase=del       kill=^U
+ *     vmin=\1         vtime=\0        eol2=\0         swtc=\0
+ *     start=^Q        stop=^S         susp=^Z         vdsusp=
+ *     reprint=^R      discard=^U      werase=^W       lnext=^V
+ *     eof=^D          eol=\0
+ */
+#define INIT_C_CC 
"\003\034\177\025\1\0\0\0\021\023\032\0\022\017\027\026\004\0"
+#endif
+
+/* modem lines */
+#define TIOCM_LE       0x001           /* line enable */
+#define TIOCM_DTR      0x002           /* data terminal ready */
+#define TIOCM_RTS      0x004           /* request to send */
+#define TIOCM_ST       0x010           /* secondary transmit */
+#define TIOCM_SR       0x020           /* secondary receive */
+#define TIOCM_CTS      0x040           /* clear to send */
+#define TIOCM_CAR      0x100           /* carrier detect */
+#define TIOCM_CD       TIOCM_CAR
+#define TIOCM_RNG      0x200           /* ring */
+#define TIOCM_RI       TIOCM_RNG
+#define TIOCM_DSR      0x400           /* data set ready */
+#define TIOCM_OUT1     0x2000
+#define TIOCM_OUT2     0x4000
+#define TIOCM_LOOP     0x8000
+
+#ifdef __KERNEL__
+#include <asm-generic/termios.h>
+#endif /* defined(__KERNEL__) */
+#endif /* __SCORE_TERMIOS_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/thread_info.h 
linux-2.6-git.new/arch/score/include/asm/thread_info.h
--- linux-2.6-git.ori/arch/score/include/asm/thread_info.h      1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/thread_info.h      2009-04-03 
17:07:38.000000000 +0800
@@ -0,0 +1,97 @@
+#ifndef __SCORE_THREAD_INFO_H
+#define __SCORE_THREAD_INFO_H
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
+       int                     preempt_count;  /* 0 => preemptable, <0 => 
BUG */
+       mm_segment_t            addr_limit;     /* thread address space:
+                                                  0-0xBFFFFFFF for 
user-thead
+                                                  0-0xFFFFFFFF for 
kernel-thread
+                                               */
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
+/* How to get the thread information struct from C.  */
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
TIF_NEED_RESCHED */
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
+#endif /* __SCORE_THREAD_INFO_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/timex.h 
linux-2.6-git.new/arch/score/include/asm/timex.h
--- linux-2.6-git.ori/arch/score/include/asm/timex.h    1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/timex.h    2009-04-03 
17:07:45.000000000 +0800
@@ -0,0 +1,34 @@
+#ifndef __SCORE_TIMEX_H
+#define __SCORE_TIMEX_H
+
+#ifdef __KERNEL__
+
+/*
+ * This is the clock rate of the i8253 PIT.  A SCORE system may not have
+ * a PIT by the symbol is used all over the kernel including some APIs.
+ * So keeping it defined to the number for the PIT is the only sane thing
+ * for now.
+ */
+#define CLOCK_TICK_RATE 1193182
+
+/*
+ * Standard way to access the cycle counter.
+ * Currently only used on SMP for scheduling.
+ *
+ * Only the low 32 bits are available as a continuously counting entity.
+ * But this only means we'll force a reschedule every 8 seconds or so,
+ * which isn't an evil thing.
+ *
+ * We know that all SMP capable CPUs have cycle counters.
+ */
+
+typedef unsigned int cycles_t;
+
+static inline cycles_t get_cycles(void)
+{
+       return 0;
+}
+
+#endif /* __KERNEL__ */
+
+#endif /*  __SCORE_TIMEX_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/tlbflush.h 
linux-2.6-git.new/arch/score/include/asm/tlbflush.h
--- linux-2.6-git.ori/arch/score/include/asm/tlbflush.h 1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/tlbflush.h 2009-04-07 
21:00:41.000000000 +0800
@@ -0,0 +1,142 @@
+#ifndef __SCORE_TLBFLUSH_H
+#define __SCORE_TLBFLUSH_H
+
+#include <linux/mm.h>
+
+/*
+ * TLB flushing:
+ *
+ *  - flush_tlb_all() flushes all processes TLB entries
+ *  - flush_tlb_mm(mm) flushes the specified mm context TLB entries
+ *  - flush_tlb_page(vma, vmaddr) flushes one page
+ *  - flush_tlb_range(vma, start, end) flushes a range of pages
+ *  - flush_tlb_kernel_range(start, end) flushes a range of kernel pages
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
+static inline unsigned long get_PEVN(void)
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
+static inline void set_PEVN(unsigned long val)
+{
+       __asm__ __volatile__(
+               "mtcr %0, cr11\n"
+               "nop\nnop\nnop\nnop\nnop\n"
+       : : "r" (val));
+}
+
+static inline void set_PECTX(unsigned long val)
+{
+       __asm__ __volatile__(
+               "mtcr %0, cr12\n"
+               "nop\nnop\nnop\nnop\nnop\n"
+       : : "r" (val));
+}
+
+static inline unsigned long get_PECTX(void)
+{
+       unsigned long val;
+       __asm__ __volatile__(
+               "mfcr %0, cr12\n"
+               "nop\nnop\n"
+       : "=r" (val));
+       return val;
+}
+static inline unsigned long get_TLBLOCK(void)
+{
+       unsigned long val;
+
+       __asm__ __volatile__(
+               "mfcr %0, cr7\n"
+               "nop\nnop\n"
+       : "=r" (val));
+       return val;
+}
+static inline void set_TLBLOCK(unsigned long val)
+{
+       __asm__ __volatile__(
+               "mtcr %0, cr7\n"
+               "nop\nnop\nnop\nnop\nnop\n"
+       : : "r" (val));
+}
+
+static inline void set_TLBPT(unsigned long val)
+{
+       __asm__ __volatile__(
+               "mtcr %0, cr8\n"
+               "nop\nnop\nnop\nnop\nnop\n"
+               : : "r" (val));
+}
+
+static inline long get_TLBPT(void)
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
+static inline void set_PEADDR(unsigned long val)
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
+#endif /* __SCORE_TLBFLUSH_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/tlb.h 
linux-2.6-git.new/arch/score/include/asm/tlb.h
--- linux-2.6-git.ori/arch/score/include/asm/tlb.h      1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/tlb.h      2009-04-03 
17:08:10.000000000 +0800
@@ -0,0 +1,17 @@
+#ifndef __SCORE_TLB_H
+#define __SCORE_TLB_H
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
+#endif /* __SCORE_TLB_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/topology.h 
linux-2.6-git.new/arch/score/include/asm/topology.h
--- linux-2.6-git.ori/arch/score/include/asm/topology.h 1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/topology.h 2009-04-03 
17:08:20.000000000 +0800
@@ -0,0 +1,6 @@
+#ifndef __SCORE_TOPOLOGY_H
+#define __SCORE_TOPOLOGY_H
+
+#include <asm-generic/topology.h>
+
+#endif /* __SCORE_TOPOLOGY_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/types.h 
linux-2.6-git.new/arch/score/include/asm/types.h
--- linux-2.6-git.ori/arch/score/include/asm/types.h    1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/types.h    2009-04-03 
17:08:49.000000000 +0800
@@ -0,0 +1,19 @@
+#ifndef __SCORE_TYPES_H
+#define __SCORE_TYPES_H
+
+#include <asm-generic/int-ll64.h>
+
+#ifndef __ASSEMBLY__
+typedef unsigned short umode_t;
+#endif /* __ASSEMBLY__ */
+
+#ifdef __KERNEL__
+#define BITS_PER_LONG  32
+#ifndef __ASSEMBLY__
+
+typedef u32 dma_addr_t;
+typedef u64 dma64_addr_t;
+
+#endif /* __ASSEMBLY__ */
+#endif /* __KERNEL__ */
+#endif /* __SCORE_TYPES_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/uaccess.h 
linux-2.6-git.new/arch/score/include/asm/uaccess.h
--- linux-2.6-git.ori/arch/score/include/asm/uaccess.h  1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/uaccess.h  2009-04-08 
11:07:16.000000000 +0800
@@ -0,0 +1,434 @@
+#ifndef __SCORE_UACCESS_H
+#define __SCORE_UACCESS_H
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/thread_info.h>
+#include <asm-generic/uaccess.h>
+
+#define __UA_LIMIT     0x80000000UL
+#define KERNEL_DS      ((mm_segment_t) { 0UL })
+#define USER_DS                ((mm_segment_t) { __UA_LIMIT })
+
+#define VERIFY_READ    0
+#define VERIFY_WRITE   1
+
+#define get_ds()       (KERNEL_DS)
+#define get_fs()       (current_thread_info()->addr_limit)
+#define set_fs(x)      (current_thread_info()->addr_limit = (x))
+#define segment_eq(a, b)       ((a).seg == (b).seg)
+
+/*
+ * Is a address valid? This does a straighforward calculation rather
+ * than tests.
+ *
+ * Address valid if:
+ *  - "addr" doesn't have any high-bits set
+ *  - AND "size" doesn't have any high-bits set
+ *  - AND "addr+size" doesn't have any high-bits set
+ *  - OR we are in kernel mode.
+ *
+ * __ua_size() is a trick to avoid runtime checking of positive constant
+ * sizes; for those we already know at compile time that the size is ok.
+ */
+#define __ua_size(size) \
+       ((__builtin_constant_p(size) && (signed long) (size) > 0) ? 0 : 
(size))
+
+/*
+ * access_ok: - Checks if a user space pointer is valid
+ * @type: Type of access: %VERIFY_READ or %VERIFY_WRITE.  Note that
+ *        %VERIFY_WRITE is a superset of %VERIFY_READ - if it is safe
+ *        to write to a block, it is always safe to read from it.
+ * @addr: User space pointer to start of block to check
+ * @size: Size of block to check
+ *
+ * Context: User context only.  This function may sleep.
+ *
+ * Checks if a pointer to a block of memory in user space is valid.
+ *
+ * Returns true (nonzero) if the memory block may be valid, false (zero)
+ * if it is definitely invalid.
+ *
+ * Note that, depending on architecture, this function probably just
+ * checks that the pointer is in the user space range - after calling
+ * this function, memory access functions may still return -EFAULT.
+ */
+
+#define __access_mask get_fs().seg
+
+#define __access_ok(addr, size, mask)                                  \
+       (((signed long)((mask) & ((addr) | ((addr) + (size)) | 
__ua_size(size)))) == 0)
+
+#define access_ok(type, addr, size)                                    \
+       likely(__access_ok((unsigned long)(addr), (size), __access_mask))
+
+/*
+ * put_user: - Write a simple value into user space.
+ * @x:   Value to copy to user space.
+ * @ptr: Destination address, in user space.
+ *
+ * Context: User context only.  This function may sleep.
+ *
+ * This macro copies a single simple value from kernel space to user
+ * space.  It supports simple types like char and int, but not larger
+ * data types like structures or arrays.
+ *
+ * @ptr must have pointer-to-simple-variable type, and @x must be 
assignable
+ * to the result of dereferencing @ptr.
+ *
+ * Returns zero on success, or -EFAULT on error.
+ */
+#define put_user(x, ptr) __put_user_check((x), (ptr), sizeof(*(ptr)))
+
+/*
+ * get_user: - Get a simple variable from user space.
+ * @x:   Variable to store result.
+ * @ptr: Source address, in user space.
+ *
+ * Context: User context only.  This function may sleep.
+ *
+ * This macro copies a single simple variable from user space to kernel
+ * space.  It supports simple types like char and int, but not larger
+ * data types like structures or arrays.
+ *
+ * @ptr must have pointer-to-simple-variable type, and the result of
+ * dereferencing @ptr must be assignable to @x without a cast.
+ *
+ * Returns zero on success, or -EFAULT on error.
+ * On error, the variable @x is set to zero.
+ */
+#define get_user(x, ptr) __get_user_check((x), (ptr), sizeof(*(ptr)))
+
+/*
+ * __put_user: - Write a simple value into user space, with less 
checking.
+ * @x:   Value to copy to user space.
+ * @ptr: Destination address, in user space.
+ *
+ * Context: User context only.  This function may sleep.
+ *
+ * This macro copies a single simple value from kernel space to user
+ * space.  It supports simple types like char and int, but not larger
+ * data types like structures or arrays.
+ *
+ * @ptr must have pointer-to-simple-variable type, and @x must be 
assignable
+ * to the result of dereferencing @ptr.
+ *
+ * Caller must check the pointer with access_ok() before calling this
+ * function.
+ *
+ * Returns zero on success, or -EFAULT on error.
+ */
+#define __put_user(x, ptr) __put_user_nocheck((x), (ptr), sizeof(*(ptr)))
+
+/*
+ * __get_user: - Get a simple variable from user space, with less 
checking.
+ * @x:   Variable to store result.
+ * @ptr: Source address, in user space.
+ *
+ * Context: User context only.  This function may sleep.
+ *
+ * This macro copies a single simple variable from user space to kernel
+ * space.  It supports simple types like char and int, but not larger
+ * data types like structures or arrays.
+ *
+ * @ptr must have pointer-to-simple-variable type, and the result of
+ * dereferencing @ptr must be assignable to @x without a cast.
+ *
+ * Caller must check the pointer with access_ok() before calling this
+ * function.
+ *
+ * Returns zero on success, or -EFAULT on error.
+ * On error, the variable @x is set to zero.
+ */
+#define __get_user(x, ptr) __get_user_nocheck((x), (ptr), sizeof(*(ptr)))
+
+struct __large_struct { unsigned long buf[100]; };
+#define __m(x) (*(struct __large_struct __user *)(x))
+
+/*
+ * Yuck.  We need two variants, one for 64bit operation and one
+ * for 32 bit mode and old iron.
+ */
+extern void __get_user_unknown(void);
+
+#define __get_user_common(val, size, ptr)                              \
+do {                                                                   \
+       switch (size) {                                                 \
+       case 1:                                                         \
+               __get_user_asm(val, "lb", ptr);                         \
+               break;                                                  \
+       case 2:                                                         \
+               __get_user_asm(val, "lh", ptr);                         \
+                break;                                                 \
+       case 4:                                                         \
+               __get_user_asm(val, "lw", ptr);                         \
+                break;                                                 \
+       case 8:                                                         \
+               if ((copy_from_user((void *)&val, ptr, 8)) == 0)        \
+                       __gu_err = 0;                                   \
+               else                                                    \
+                       __gu_err = -EFAULT;                             \
+               break;                                                  \
+       default:                                                        \
+               __get_user_unknown();                                   \
+               break;                                                  \
+       }                                                               \
+} while (0)
+
+#define __get_user_nocheck(x, ptr, size)                               \
+({                                                                     \
+       long __gu_err = 0;                                              \
+       __get_user_common((x), size, ptr);                              \
+       __gu_err;                                                       \
+})
+
+#define __get_user_check(x, ptr, size)                                 \
+({                                                                     \
+       long __gu_err = -EFAULT;                                        \
+       const __typeof__(*(ptr)) __user *__gu_ptr = (ptr);              \
+                                                                       \
+       if (likely(access_ok(VERIFY_READ, __gu_ptr, size)))             \
+               __get_user_common((x), size, __gu_ptr);                 \
+                                                                       \
+       __gu_err;                                                       \
+})
+
+#define __get_user_asm(val, insn, addr) \
+{                                                                      \
+       long __gu_tmp;                                                  \
+                                                                       \
+       __asm__ __volatile__(                                           \
+               "1:" insn " %1, %3\n"                                   \
+               "2:\n"                                                  \
+               ".section .fixup,\"ax\"\n"                              \
+               "3:li   %0, %4\n"                                       \
+               "j      2b\n"                                           \
+               ".previous\n"                                           \
+               ".section __ex_table,\"a\"\n"                           \
+               ".word  1b, 3b\n"                                       \
+               ".previous\n"                                           \
+               : "=r" (__gu_err), "=r" (__gu_tmp)                      \
+               : "0" (0), "o" (__m(addr)), "i" (-EFAULT));             \
+                                                                       \
+               (val) = (__typeof__(*(addr))) __gu_tmp;                 \
+}
+
+/*
+ * Yuck.  We need two variants, one for 64bit operation and one
+ * for 32 bit mode and old iron.
+ */
+#define __put_user_nocheck(val, ptr, size)                             \
+({                                                                     \
+       __typeof__(*(ptr)) __pu_val;                                    \
+       long __pu_err = 0;                                              \
+                                                                       \
+       __pu_val = (val);                                               \
+       switch (size) {                                                 \
+       case 1:                                                         \
+               __put_user_asm("sb", ptr);                              \
+               break;                                                  \
+       case 2:                                                         \
+               __put_user_asm("sh", ptr);                              \
+               break;                                                  \
+       case 4:                                                         \
+               __put_user_asm("sw", ptr);                              \
+               break;                                                  \
+       case 8:                                                         \
+               if ((__copy_to_user((void *)ptr, &__pu_val, 8)) == 0)   \
+                       __pu_err = 0;                                   \
+               else                                                    \
+                       __pu_err = -EFAULT;                             \
+               break;                                                  \
+       default:                                                        \
+                __put_user_unknown();                                  \
+                break;                                                 \
+       }                                                               \
+       __pu_err;                                                       \
+})
+
+
+#define __put_user_check(val, ptr, size)                               \
+({                                                                     \
+       __typeof__(*(ptr)) __user *__pu_addr = (ptr);                   \
+       __typeof__(*(ptr)) __pu_val = (val);                            \
+       long __pu_err = -EFAULT;                                        \
+                                                                       \
+       if (likely(access_ok(VERIFY_WRITE, __pu_addr, size))) {         \
+               switch (size) {                                         \
+               case 1:                                                 \
+                       __put_user_asm("sb", __pu_addr);                \
+                       break;                                          \
+               case 2:                                                 \
+                       __put_user_asm("sh", __pu_addr);                \
+                       break;                                          \
+               case 4:                                                 \
+                       __put_user_asm("sw", __pu_addr);                \
+                       break;                                          \
+               case 8:                                                 \
+                       if ((__copy_to_user((void *)__pu_addr, &__pu_val, 
8)) == 0)\
+                               __pu_err = 0;                           \
+                       else                                            \
+                               __pu_err = -EFAULT;                     \
+                       break;                                          \
+               default:                                                \
+                       __put_user_unknown();                           \
+                       break;                                          \
+               }                                                       \
+       }                                                               \
+       __pu_err;                                                       \
+})
+
+#define __put_user_asm(insn, ptr)                                      \
+       __asm__ __volatile__(                                           \
+               "1:" insn " %2, %3\n"                                   \
+               "2:\n"                                                  \
+               ".section .fixup,\"ax\"\n"                              \
+               "3:li %0, %4\n"                                         \
+               "j 2b\n"                                                \
+               ".previous\n"                                           \
+               ".section __ex_table,\"a\"\n"                           \
+               ".word 1b, 3b\n"                                        \
+               ".previous\n"                                           \
+               : "=r" (__pu_err)                                       \
+               : "0" (0), "r" (__pu_val), "o" (__m(ptr)),              \
+                 "i" (-EFAULT));
+
+extern void __put_user_unknown(void);
+
+extern int __copy_tofrom_user(void *to, const void *from, unsigned long 
len);
+
+static inline unsigned long copy_from_user(void *to, const void *from, 
unsigned long len)
+{
+       unsigned long over;
+
+       if (access_ok(VERIFY_READ, from, len))
+               return __copy_tofrom_user(to, from, len);
+
+       if ((unsigned long)from < TASK_SIZE) {
+               over = (unsigned long)from + len - TASK_SIZE;
+               return __copy_tofrom_user(to, from, len - over) + over;
+       }
+       return len;
+}
+
+static inline unsigned long copy_to_user(void *to, const void *from, 
unsigned long len)
+{
+       unsigned long over;
+
+       if (access_ok(VERIFY_WRITE, to, len))
+               return __copy_tofrom_user(to, from, len);
+
+       if ((unsigned long)to < TASK_SIZE) {
+               over = (unsigned long)to + len - TASK_SIZE;
+               return __copy_tofrom_user(to, from, len - over) + over;
+       }
+       return len;
+}
+
+#define __copy_from_user(to, from, len)        \
+               __copy_tofrom_user((to), (from), (len))
+
+#define __copy_to_user(to, from, len)          \
+               __copy_tofrom_user((to), (from), (len))
+
+
+static inline unsigned long
+__copy_to_user_inatomic(void *to, const void *from, unsigned long len)
+{
+       return __copy_to_user(to, from, len);
+}
+
+static inline unsigned long
+__copy_from_user_inatomic(void *to, const void *from, unsigned long len)
+{
+       return __copy_from_user(to, from, len);
+}
+
+#define __copy_in_user(to, from, len)  __copy_from_user(to, from, len)
+
+static inline unsigned long
+copy_in_user(void *to, const void *from, unsigned long len)
+{
+       if (access_ok(VERIFY_READ, from, len) &&
+                     access_ok(VERFITY_WRITE, to, len))
+               return copy_from_user(to, from, len);
+}
+
+/*
+ * __clear_user: - Zero a block of memory in user space, with less 
checking.
+ * @to:   Destination address, in user space.
+ * @n:    Number of bytes to zero.
+ *
+ * Zero a block of memory in user space.  Caller must check
+ * the specified block with access_ok() before calling this function.
+ *
+ * Returns number of bytes that could not be cleared.
+ * On success, this will be zero.
+ */
+extern unsigned long __clear_user(void __user *src, unsigned long size);
+
+static inline unsigned long clear_user(char *src, unsigned long size)
+{
+       if (access_ok(VERIFY_WRITE, src, size))
+               return __clear_user(src, size);
+
+       return -EFAULT;
+}
+
+
+/*
+ * __strncpy_from_user: - Copy a NUL terminated string from userspace, 
with less checking.
+ * @dst:   Destination address, in kernel space.  This buffer must be at
+ *         least @count bytes long.
+ * @src:   Source address, in user space.
+ * @count: Maximum number of bytes to copy, including the trailing NUL.
+ *
+ * Copies a NUL-terminated string from userspace to kernel space.
+ * Caller must check the specified block with access_ok() before calling
+ * this function.
+ *
+ * On success, returns the length of the string (not including the 
trailing
+ * NUL).
+ *
+ * If access to userspace fails, returns -EFAULT (some data may have been
+ * copied).
+ *
+ * If @count is smaller than the length of the string, copies @count 
bytes
+ * and returns @count.
+ */
+extern int __strncpy_from_user(char *dst, const char *src, long len);
+
+static inline int strncpy_from_user(char *dst, const char *src, long len)
+{
+       if (access_ok(VERIFY_READ, src, 1))
+               return __strncpy_from_user(dst, src, len);
+
+       return -EFAULT;
+}
+
+
+extern int __strlen_user(const char *src);
+static inline long strlen_user(const char __user *src)
+{
+       return __strlen_user(src);
+}
+
+
+extern int __strnlen_user(const char *str, long len);
+static inline long strnlen_user(const char __user *str, long len)
+{
+       if (access_ok(VERIFY_READ, str, len))
+               return __strnlen_user(str, len);
+
+       return -EFAULT;
+}
+
+struct exception_table_entry {
+       unsigned long insn;
+       unsigned long nextinsn;
+};
+
+extern int fixup_exception(struct pt_regs *regs);
+
+#endif /* __SCORE_UACCESS_H */
+
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/ucontext.h 
linux-2.6-git.new/arch/score/include/asm/ucontext.h
--- linux-2.6-git.ori/arch/score/include/asm/ucontext.h 1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/ucontext.h 2009-04-03 
17:09:06.000000000 +0800
@@ -0,0 +1,12 @@
+#ifndef __SCORE_UCONTEXT_H
+#define __SCORE_UCONTEXT_H
+
+struct ucontext {
+       unsigned long   uc_flags;
+       struct ucontext *uc_link;
+       stack_t         uc_stack;
+       struct sigcontext uc_mcontext;
+       sigset_t        uc_sigmask;     /* mask last for extensibility */
+};
+
+#endif /* __SCORE_UCONTEXT_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/unaligned.h 
linux-2.6-git.new/arch/score/include/asm/unaligned.h
--- linux-2.6-git.ori/arch/score/include/asm/unaligned.h        1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/unaligned.h        2009-04-03 
17:09:13.000000000 +0800
@@ -0,0 +1,11 @@
+#ifndef __SCORE_SCORE_UNALIGNED_H
+#define __SCORE_SCORE_UNALIGNED_H
+
+#include <linux/unaligned/le_struct.h>
+#include <linux/unaligned/be_byteshift.h>
+#include <linux/unaligned/generic.h>
+
+#define get_unaligned  __get_unaligned_le
+#define put_unaligned  __put_unaligned_le
+
+#endif /* __SCORE_SCORE_UNALIGNED_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/unistd.h 
linux-2.6-git.new/arch/score/include/asm/unistd.h
--- linux-2.6-git.ori/arch/score/include/asm/unistd.h   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/unistd.h   2009-04-03 
17:09:23.000000000 +0800
@@ -0,0 +1,381 @@
+#ifndef __SCORE_UNISTD_H
+#define __SCORE_UNISTD_H
+
+#define __NR_restart_syscall           0
+#define __NR_exit                      1
+#define __NR_fork                      2
+#define __NR_read                      3
+#define __NR_write                     4
+#define __NR_open                      5
+#define __NR_close                     6
+#define __NR_waitpid                   7
+#define __NR_creat                     8
+#define __NR_link                      9
+#define __NR_unlink                    10
+#define __NR_execve                    11
+#define __NR_chdir                     12
+#define __NR_time                      13
+#define __NR_mknod                     14
+#define __NR_chmod                     15
+#define __NR_lchown                    16
+                                       /* 17 __NR_break */
+                                       /* 18 __NR_oldstat */
+#define __NR_lseek                     19
+#define __NR_getpid                    20
+#define __NR_mount                     21
+                                       /* 22 __NR_umount */
+#define __NR_setuid                    23
+#define __NR_getuid                    24
+#define __NR_stime                     25
+#define __NR_ptrace                    26
+#define __NR_alarm                     27
+                                       /* 28 __NR_oldstat */
+#define __NR_pause                     29
+                                       /* 30 __NR_utime */
+                                       /* 31 __NR_stty */
+                                       /* 32 __NR_gtty */
+#define __NR_access                    33
+#define __NR_nice                      34
+                                       /* 35 __NR_ftime */
+#define __NR_sync                      36
+#define __NR_kill                      37
+#define __NR_rename                    38
+#define __NR_mkdir                     39
+#define __NR_rmdir                     40
+#define __NR_dup                       41
+#define __NR_pipe                      42
+#define __NR_times                     43
+                                       /* 44 __NR_prof */
+#define __NR_brk                       45
+#define __NR_setgid                    46
+#define __NR_getgid                    47
+                                       /* 48 __NR_signal */
+#define __NR_geteuid                   49
+#define __NR_getegid                   50
+#define __NR_acct                      51
+#define __NR_umount2                   52
+                                       /* 53 __NR_lock */
+#define __NR_ioctl                     54
+#define __NR_fcntl                     55
+                                       /* 56 __NR_mpx */
+#define __NR_setpgid                   57
+                                       /* 58 __NR_ulimit */
+                                       /* 59 __NR_unused */
+#define __NR_umask                     60
+#define __NR_chroot                    61
+#define __NR_ustat                     62
+#define __NR_dup2                      63
+#define __NR_getppid                   64
+#define __NR_getpgrp                   65
+#define __NR_setsid                    66
+                                       /* 67 __NR_sigaction */
+#define __NR_sgetmask                  68
+#define __NR_ssetmask                  69
+#define __NR_setreuid                  70
+#define __NR_setregid                  71
+                                       /* 72 __NR_sigsuspend */
+                                       /* 73 __NR_sigpending */
+#define __NR_sethostname               74
+#define __NR_setrlimit                 75
+                                       /* 76 __NR_getrlimit */
+#define __NR_getrusage                 77
+#define __NR_gettimeofday              78
+#define __NR_settimeofday              79
+#define __NR_getgroups                 80
+#define __NR_setgroups                 81
+                                       /* 82 __NR_select */
+#define __NR_symlink                   83
+                                       /* 84 __NR_oldlstat */
+#define __NR_readlink                  85
+                                       /* 86 __NR_uselib */
+                                       /* 87 __NR_swapon */
+#define __NR_reboot                    88
+                                       /* 89 __NR_readdir */
+                                       /* 90 __NR_mmap */
+#define __NR_munmap                    91
+#define __NR_truncate                  92
+#define __NR_ftruncate                 93
+#define __NR_fchmod                    94
+#define __NR_fchown                    95
+#define __NR_getpriority               96
+#define __NR_setpriority               97
+                                       /* 98 __NR_profil */
+#define __NR_statfs                    99
+#define __NR_fstatfs                   100
+                                       /* 101 __NR_ioperm */
+                                       /* 102 __NR_socketcall */
+#define __NR_syslog                    103
+#define __NR_setitimer                 104
+#define __NR_getitimer                 105
+#define __NR_stat                      106
+#define __NR_lstat                     107
+#define __NR_fstat                     108
+                                       /* 109 __NR_olduname */
+                                       /* 110 __NR_iopl */
+#define __NR_vhangup                   111
+                                       /* 112 __NR_idle */
+                                       /* 113 __NR_vm86 */
+#define __NR_wait4                     114
+                                       /* 115 __NR_swapoff */
+#define __NR_sysinfo                   116
+                                       /* 117 __NR_ipc */
+#define __NR_fsync                     118
+                                       /* 119 __NR_sigreturn */
+#define __NR_clone                     120
+#define __NR_setdomainname             121
+#define __NR_uname                     122
+                                       /* 123 __NR_modify_ldt */
+#define __NR_adjtimex                  124
+                                       /* 125 __NR_mprotect */
+                                       /* 126 __NR_sigprocmask */
+                                       /* 127 __NR_create_module */
+#define __NR_init_module               128
+#define __NR_delete_module             129
+                                       /* 130 __NR_get_kernel_syms */
+#define __NR_quotactl                  131
+#define __NR_getpgid                   132
+#define __NR_fchdir                    133
+#define __NR_bdflush                   134
+                                       /* 135 __NR_sysfs */
+#define __NR_personality               136
+                                       /* 137 __NR_afs_syscall */
+#define __NR_setfsuid                  138
+#define __NR_setfsgid                  139
+#define __NR__llseek                   140
+#define __NR_getdents                  141
+                                       /* 142 __NR__newselect */
+#define __NR_flock                     143
+                                       /* 144 __NR_msync */
+#define __NR_readv                     145
+#define __NR_writev                    146
+                                       /* 147 __NR_cacheflush */
+                                       /* 148 __NR_cachectl */
+                                       /* 149 __NR_sysscore */
+                                       /* 150 __NR_unused */
+#define __NR_getsid                    151
+#define __NR_fdatasync                 152
+#define __NR__sysctl                   153
+                                       /* 154 __NR_mlock */
+                                       /* 155 __NR_munlock */
+                                       /* 156 __NR_mlockall */
+                                       /* 157 __NR_munlockall */
+#define __NR_sched_setparam            158
+#define __NR_sched_getparam            159
+#define __NR_sched_setscheduler                160
+#define __NR_sched_getscheduler                161
+#define __NR_sched_yield               162
+#define __NR_sched_get_priority_max    163
+#define __NR_sched_get_priority_min    164
+#define __NR_sched_rr_get_interval     165
+#define __NR_nanosleep                 166
+#define __NR_mremap                    167
+#define __NR_accept                    168
+#define __NR_bind                      169
+#define __NR_connect                   170
+#define __NR_getpeername               171
+#define __NR_getsockname               172
+#define __NR_getsockopt                        173
+#define __NR_listen                    174
+#define __NR_recv                      175
+#define __NR_recvfrom                  176
+#define __NR_recvmsg                   177
+#define __NR_send                      178
+#define __NR_sendmsg                   179
+#define __NR_sendto                    180
+#define __NR_setsockopt                        181
+#define __NR_shutdown                  182
+#define __NR_socket                    183
+#define __NR_socketpair                        184
+#define __NR_setresuid                 185
+#define __NR_getresuid                 186
+                                       /* 187 __NR_query_module */
+                                       /* 188 __NR_poll */
+#define __NR_nfsservctl                        189
+#define __NR_setresgid                 190
+#define __NR_getresgid                 191
+#define __NR_prctl                     192
+#define __NR_rt_sigreturn              193
+#define __NR_rt_sigaction              194
+#define __NR_rt_sigprocmask            195
+#define __NR_rt_sigpending             196
+#define __NR_rt_sigtimedwait           197
+#define __NR_rt_sigqueueinfo           198
+#define __NR_rt_sigsuspend             199
+#define __NR_pread64                   200
+#define __NR_pwrite64                  201
+#define __NR_chown                     202
+#define __NR_getcwd                    203
+#define __NR_capget                    204
+#define __NR_capset                    205
+#define __NR_sigaltstack               206
+#define __NR_sendfile                  207
+                                       /* 208 __NR_getpmsg */
+                                       /* 209 __NR_putpmsg */
+#define __NR_mmap2                     210
+#define __NR_truncate64                        211
+#define __NR_ftruncate64               212
+#define __NR_stat64                    213
+#define __NR_lstat64                   214
+#define __NR_fstat64                   215
+#define __NR_pivot_root                        216
+                                       /* 217 __NR_mincore */
+                                       /* 218 __NR_madvise */
+#define __NR_getdents64                        219
+#define __NR_fcntl64                   220
+                                       /* 221 __NR_unused */
+#define __NR_gettid                    222
+#define __NR_readahead                 223
+#define __NR_setxattr                  224
+#define __NR_lsetxattr                 225
+#define __NR_fsetxattr                 226
+#define __NR_getxattr                  227
+#define __NR_lgetxattr                 228
+#define __NR_fgetxattr                 229
+#define __NR_listxattr                 230
+#define __NR_llistxattr                        231
+#define __NR_flistxattr                        232
+#define __NR_removexattr               233
+#define __NR_lremovexattr              234
+#define __NR_fremovexattr              235
+#define __NR_tkill                     236
+#define __NR_sendfile64                        237
+#define __NR_futex                     238
+#define __NR_sched_setaffinity         239
+#define __NR_sched_getaffinity         240
+#define __NR_io_setup                  241
+#define __NR_io_destroy                        242
+#define __NR_io_getevents              243
+#define __NR_io_submit                 244
+#define __NR_io_cancel                 245
+#define __NR_exit_group                        246
+#define __NR_lookup_dcookie            247
+#define __NR_epoll_create              248
+#define __NR_epoll_ctl                 249
+#define __NR_epoll_wait                        250
+                                       /* 251 __NR_remap_file_pages */
+#define __NR_set_tid_address           252
+                                       /* 253 __NR_restart_syscall */
+#define __NR_fadvise64_64              254
+#define __NR_statfs64                  255
+#define __NR_fstatfs64                 256
+#define __NR_timer_create              257
+#define __NR_timer_settime             258
+#define __NR_timer_gettime             259
+#define __NR_timer_getoverrun          260
+#define __NR_timer_delete              261
+#define __NR_clock_settime             262
+#define __NR_clock_gettime             263
+#define __NR_clock_getres              264
+#define __NR_clock_nanosleep           265
+#define __NR_tgkill                    266
+#define __NR_utimes                    267
+                                       /* 268 __NR_mbind */
+                                       /* 269 __NR_get_mempolicy */
+                                       /* 270 __NR_set_mempolicy */
+#define __NR_mq_open                   271
+#define __NR_mq_unlink                 272
+#define __NR_mq_timedsend              273
+#define __NR_mq_timedreceive           274
+#define __NR_mq_notify                 275
+#define __NR_mq_getsetattr             276
+                                       /* 277 __NR_vserver */
+#define __NR_waitid                    278
+                                       /* 279 __NR_sys_setaltroot */
+#define __NR_add_key                   280
+#define __NR_request_key               281
+#define __NR_keyctl                    282
+                                       /* 283 __NR_set_thread_area */
+#define __NR_inotify_init              284
+#define __NR_inotify_add_watch         285
+#define __NR_inotify_rm_watch          286
+                                       /* 287 __NR_migrate_pages */
+#define __NR_openat                    288
+#define __NR_mkdirat                   289
+#define __NR_mknodat                   290
+#define __NR_fchownat                  291
+#define __NR_futimesat                 292
+#define __NR_fstatat64                 293
+#define __NR_unlinkat                  294
+#define __NR_renameat                  295
+#define __NR_linkat                    296
+#define __NR_symlinkat                 297
+#define __NR_readlinkat                        298
+#define __NR_fchmodat                  299
+#define __NR_faccessat                 300
+#define __NR_pselect6                  301
+#define __NR_ppoll                     302
+#define __NR_unshare                   303
+#define __NR_splice                    304
+#define __NR_sync_file_range           305
+#define __NR_tee                       306
+#define __NR_vmsplice                  307
+#define __NR_move_pages                        308
+#define __NR_set_robust_list           309
+#define __NR_get_robust_list           310
+#define __NR_kexec_load                        311
+#define __NR_getcpu                    312
+#define __NR_epoll_pwait               313
+#define __NR_ioprio_set                        314
+#define __NR_ioprio_get                        315
+#define __NR_utimensat                 316
+#define __NR_signalfd                  317
+                                       /* 318 __NR_timerfd */
+#define __NR_eventfd                   319
+#define __NR_fallocate                 320
+#define __NR_timerfd_create            321
+#define __NR_timerfd_gettime           322
+#define __NR_timerfd_settime           323
+#define __NR_signalfd4                 324
+#define __NR_eventfd2                  325
+#define __NR_epoll_create1             326
+#define __NR_dup3                      327
+#define __NR_pipe2                     328
+#define __NR_inotify_init1             329
+
+#ifdef __KERNEL__
+#define __NR_Linux_syscalls            329
+
+#define __IGNORE_sysfs
+#define __IGNORE_uselib
+#define __IGNORE_mmap
+#define __IGNORE_poll
+#define __IGNORE_select
+#define __IGNORE_utime
+#define __IGNORE_swapon
+#define __IGNORE_swapoff
+#define __IGNORE_msync
+#define __IGNORE_mlock
+#define __IGNORE_munlock
+#define __IGNORE_mlockall
+#define __IGNORE_munlockall
+#define __IGNORE_mincore
+#define __IGNORE_madvise
+#define __IGNORE_remap_file_pages
+#define __IGNORE_mbind
+#define __IGNORE_get_mempolicy
+#define __IGNORE_set_mempolicy
+#define __IGNORE_migrate_pages
+
+#define __ARCH_WANT_IPC_PARSE_VERSION
+#define __ARCH_WANT_STAT64
+#define __ARCH_WANT_SYS_ALARM
+#define __ARCH_WANT_SYS_PAUSE
+#define __ARCH_WANT_SYS_SGETMASK
+#define __ARCH_WANT_SYS_TIME
+#define __ARCH_WANT_SYS_FADVISE64
+#define __ARCH_WANT_SYS_GETPGRP
+#define __ARCH_WANT_SYS_LLSEEK
+#define __ARCH_WANT_SYS_NICE
+#define __ARCH_WANT_SYS_RT_SIGACTION
+#define __ARCH_WANT_SYS_WAITPID
+
+/*
+ * "Conditional" syscalls
+ *
+ * What we want is __attribute__((weak,alias("sys_ni_syscall"))),
+ * but it doesn't work on all toolchains, so we just do it by hand
+ */
+#define cond_syscall(x) asm(".weak\t" #x "\n" #x "\t=\tsys_ni_syscall")
+
+#endif /* __KERNEL__ */
+#endif /* __SCORE_UNISTD_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/user.h 
linux-2.6-git.new/arch/score/include/asm/user.h
--- linux-2.6-git.ori/arch/score/include/asm/user.h     1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/user.h     2009-04-03 
17:09:30.000000000 +0800
@@ -0,0 +1,4 @@
+#ifndef __SCORE_USER_H
+#define __SCORE_USER_H
+
+#endif /* __SCORE_USER_H */

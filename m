Return-Path: <linux-kernel-owner+w=401wt.eu-S1756730AbZHZGe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730AbZHZGe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbZHZGe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:34:27 -0400
Received: from 124-219-29-227.vdslpro.static.apol.com.tw ([124.219.29.227]:40551
	"EHLO mswedge2.sunplus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751240AbZHZGe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:34:26 -0400
Subject: Subject: [PATCH 17/33] score: create head files pci.h processor.h
	thread_info.h topology.h
From: Chen Liqin <liqin.chen@sunplusct.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, torvalds@linux-foundation.org
Content-Type: text/plain
Date: Wed, 26 Aug 2009 14:24:09 +0800
Message-Id: <1251267849.3153.1.camel@ad3ser01>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e8bb30582c7a43a8a568041d2ad6239b99b637e3 Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Wed, 26 Aug 2009 10:05:04 +0800
Subject: [PATCH 17/33] score: create head files pci.h processor.h thread_info.h topology.h


Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/include/asm/pci.h         |    4 +
 arch/score/include/asm/processor.h   |  106 ++++++++++++++++++++++++++++++++++
 arch/score/include/asm/thread_info.h |  103 +++++++++++++++++++++++++++++++++
 arch/score/include/asm/topology.h    |    6 ++
 4 files changed, 219 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/include/asm/pci.h
 create mode 100644 arch/score/include/asm/processor.h
 create mode 100644 arch/score/include/asm/thread_info.h
 create mode 100644 arch/score/include/asm/topology.h

diff --git a/arch/score/include/asm/pci.h b/arch/score/include/asm/pci.h
new file mode 100644
index 0000000..3f3cfd8
--- /dev/null
+++ b/arch/score/include/asm/pci.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_SCORE_PCI_H
+#define _ASM_SCORE_PCI_H
+
+#endif /* _ASM_SCORE_PCI_H */
diff --git a/arch/score/include/asm/processor.h b/arch/score/include/asm/processor.h
new file mode 100644
index 0000000..7e22f21
--- /dev/null
+++ b/arch/score/include/asm/processor.h
@@ -0,0 +1,106 @@
+#ifndef _ASM_SCORE_PROCESSOR_H
+#define _ASM_SCORE_PROCESSOR_H
+
+#include <linux/cpumask.h>
+#include <linux/threads.h>
+
+#include <asm/segment.h>
+
+struct task_struct;
+
+/*
+ * System setup and hardware flags..
+ */
+extern void (*cpu_wait)(void);
+
+extern long kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
+extern unsigned long thread_saved_pc(struct task_struct *tsk);
+extern void start_thread(struct pt_regs *regs,
+			unsigned long pc, unsigned long sp);
+extern unsigned long get_wchan(struct task_struct *p);
+
+/*
+ * Return current * instruction pointer ("program counter").
+ */
+#define current_text_addr() ({ __label__ _l; _l: &&_l; })
+
+#define cpu_relax()		barrier()
+#define release_thread(thread)	do {} while (0)
+#define prepare_to_copy(tsk)	do {} while (0)
+
+/*
+ * User space process size: 2GB. This is hardcoded into a few places,
+ * so don't change it unless you know what you are doing.
+ */
+#define TASK_SIZE	0x7fff8000UL
+
+/*
+ * This decides where the kernel will search for a free chunk of vm
+ * space during mmap's.
+ */
+#define TASK_UNMAPPED_BASE	((TASK_SIZE / 3) & ~(PAGE_SIZE))
+
+#ifdef __KERNEL__
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	TASK_SIZE
+#endif
+
+/*
+ * If you change thread_struct remember to change the #defines below too!
+ */
+struct thread_struct {
+	unsigned long reg0, reg2, reg3;
+	unsigned long reg12, reg13, reg14, reg15, reg16;
+	unsigned long reg17, reg18, reg19, reg20, reg21;
+
+	unsigned long cp0_psr;
+	unsigned long cp0_ema;		/* Last user fault */
+	unsigned long cp0_badvaddr;	/* Last user fault */
+	unsigned long cp0_baduaddr;	/* Last kernel fault accessing USEG */
+	unsigned long error_code;
+	unsigned long trap_no;
+
+	unsigned long mflags;
+	unsigned long reg29;
+
+	unsigned long single_step;
+	unsigned long ss_nextcnt;
+
+	unsigned long insn1_type;
+	unsigned long addr1;
+	unsigned long insn1;
+
+	unsigned long insn2_type;
+	unsigned long addr2;
+	unsigned long insn2;
+
+	mm_segment_t current_ds;
+};
+
+#define INIT_THREAD {						\
+	.reg0			= 0,				\
+	.reg2			= 0,				\
+	.reg3			= 0,				\
+	.reg12			= 0,				\
+	.reg13			= 0,				\
+	.reg14			= 0,				\
+	.reg15			= 0,				\
+	.reg16			= 0,				\
+	.reg17			= 0,				\
+	.reg18			= 0,				\
+	.reg19			= 0,				\
+	.reg20			= 0,				\
+	.reg21			= 0,				\
+	.cp0_psr		= 0,				\
+	.error_code		= 0,				\
+	.trap_no		= 0,				\
+}
+
+#define kstk_tos(tsk)		\
+	((unsigned long)task_stack_page(tsk) + THREAD_SIZE - 32)
+#define task_pt_regs(tsk)	((struct pt_regs *)kstk_tos(tsk) - 1)
+
+#define KSTK_EIP(tsk)		(task_pt_regs(tsk)->cp0_epc)
+#define KSTK_ESP(tsk)		(task_pt_regs(tsk)->regs[29])
+
+#endif /* _ASM_SCORE_PROCESSOR_H */
diff --git a/arch/score/include/asm/thread_info.h b/arch/score/include/asm/thread_info.h
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
+#define KU_MASK	0x08
+#define KU_USER	0x08
+#define KU_KERN	0x00
+
+#ifndef __ASSEMBLY__
+
+#include <asm/processor.h>
+
+/*
+ * low level task data that entry.S needs immediate access to
+ * - this struct should fit entirely inside of one cache line
+ * - this struct shares the supervisor stack pages
+ * - if the contents of this structure are changed, the assembly constants
+ *   must also be changed
+ */
+struct thread_info {
+	struct task_struct	*task;		/* main task structure */
+	struct exec_domain	*exec_domain;	/* execution domain */
+	unsigned long		flags;		/* low level flags */
+	unsigned long		tp_value;	/* thread pointer */
+	__u32			cpu;		/* current CPU */
+
+	/* 0 => preemptable, < 0 => BUG */
+	int			preempt_count;
+
+	/*
+	 * thread address space:
+	 * 0-0xBFFFFFFF for user-thead
+	 * 0-0xFFFFFFFF for kernel-thread
+	 */
+	mm_segment_t		addr_limit;
+	struct restart_block	restart_block;
+	struct pt_regs		*regs;
+};
+
+/*
+ * macros/functions for gaining access to the thread information structure
+ *
+ * preempt_count needs to be 1 initially, until the scheduler is functional.
+ */
+#define INIT_THREAD_INFO(tsk)			\
+{						\
+	.task		= &tsk,			\
+	.exec_domain	= &default_exec_domain,	\
+	.cpu		= 0,			\
+	.preempt_count	= 1,			\
+	.addr_limit	= KERNEL_DS,		\
+	.restart_block	= {			\
+		.fn = do_no_restart_syscall,	\
+	},					\
+}
+
+#define init_thread_info	(init_thread_union.thread_info)
+#define init_stack		(init_thread_union.stack)
+
+/* How to get the thread information struct from C. */
+register struct thread_info *__current_thread_info __asm__("r28");
+#define current_thread_info()	__current_thread_info
+
+/* thread information allocation */
+#define THREAD_SIZE_ORDER 	(1)
+#define THREAD_SIZE 		(PAGE_SIZE << THREAD_SIZE_ORDER)
+#define THREAD_MASK 		(THREAD_SIZE - 1UL)
+#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
+
+#define alloc_thread_info(tsk) kmalloc(THREAD_SIZE, GFP_KERNEL)
+#define free_thread_info(info) kfree(info)
+
+#endif /* !__ASSEMBLY__ */
+
+#define PREEMPT_ACTIVE		0x10000000
+
+/*
+ * thread information flags
+ * - these are process state flags that various assembly files may need to
+ *   access
+ * - pending work-to-be-done flags are in LSW
+ * - other flags in MSW
+ */
+#define TIF_SYSCALL_TRACE	0	/* syscall trace active */
+#define TIF_SIGPENDING		1	/* signal pending */
+#define TIF_NEED_RESCHED	2	/* rescheduling necessary */
+#define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal() */
+#define TIF_POLLING_NRFLAG	17	/* true if poll_idle() is polling
+						 TIF_NEED_RESCHED */
+#define TIF_MEMDIE		18
+
+#define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
+#define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
+#define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
+#define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
+#define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
+
+#define _TIF_WORK_MASK		(0x0000ffff)
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_SCORE_THREAD_INFO_H */
diff --git a/arch/score/include/asm/topology.h b/arch/score/include/asm/topology.h
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
-- 
1.6.2




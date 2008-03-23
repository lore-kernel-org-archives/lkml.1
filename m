Return-Path: <linux-kernel-owner+w=401wt.eu-S1764835AbYCWIia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764835AbYCWIia (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759780AbYCWIKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:10:23 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2302 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759754AbYCWIKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:10:17 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 127/148] include/asm-x86/thread_info_32.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:42 -0700
Message-Id: <1206259443-13210-128-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/thread_info_32.h |   88 ++++++++++++++++++++------------------
 1 files changed, 46 insertions(+), 42 deletions(-)

diff --git a/include/asm-x86/thread_info_32.h b/include/asm-x86/thread_info_32.h
index 54140ce..5318599 100644
--- a/include/asm-x86/thread_info_32.h
+++ b/include/asm-x86/thread_info_32.h
@@ -20,7 +20,8 @@
  * low level task data that entry.S needs immediate access to
  * - this struct should fit entirely inside of one cache line
  * - this struct shares the supervisor stack pages
- * - if the contents of this structure are changed, the assembly constants must also be changed
+ * - if the contents of this structure are changed,
+ *   the assembly constants must also be changed
  */
 #ifndef __ASSEMBLY__
 
@@ -30,18 +31,16 @@ struct thread_info {
 	unsigned long		flags;		/* low level flags */
 	unsigned long		status;		/* thread-synchronous flags */
 	__u32			cpu;		/* current CPU */
-	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
-
-
+	int			preempt_count;	/* 0 => preemptable,
+						   <0 => BUG */
 	mm_segment_t		addr_limit;	/* thread address space:
-					 	   0-0xBFFFFFFF for user-thead
-						   0-0xFFFFFFFF for kernel-thread
+						   0-0xBFFFFFFF user-thread
+						   0-0xFFFFFFFF kernel-thread
 						*/
 	void			*sysenter_return;
 	struct restart_block    restart_block;
-
-	unsigned long           previous_esp;   /* ESP of the previous stack in case
-						   of nested (IRQ) stacks
+	unsigned long           previous_esp;   /* ESP of the previous stack in
+						   case of nested (IRQ) stacks
 						*/
 	__u8			supervisor_stack[0];
 };
@@ -90,22 +89,23 @@ register unsigned long current_stack_pointer asm("esp") __used;
 /* how to get the thread information struct from C */
 static inline struct thread_info *current_thread_info(void)
 {
-	return (struct thread_info *)(current_stack_pointer & ~(THREAD_SIZE - 1));
+	return (struct thread_info *)
+		(current_stack_pointer & ~(THREAD_SIZE - 1));
 }
 
 /* thread information allocation */
 #ifdef CONFIG_DEBUG_STACK_USAGE
-#define alloc_thread_info(tsk) ((struct thread_info *) \
-	__get_free_pages(GFP_KERNEL| __GFP_ZERO, get_order(THREAD_SIZE)))
+#define alloc_thread_info(tsk) ((struct thread_info *)			\
+	__get_free_pages(GFP_KERNEL | __GFP_ZERO, get_order(THREAD_SIZE)))
 #else
-#define alloc_thread_info(tsk) ((struct thread_info *) \
+#define alloc_thread_info(tsk) ((struct thread_info *)			\
 	__get_free_pages(GFP_KERNEL, get_order(THREAD_SIZE)))
 #endif
 
 #else /* !__ASSEMBLY__ */
 
 /* how to get the thread information struct from ASM */
-#define GET_THREAD_INFO(reg) \
+#define GET_THREAD_INFO(reg)	 \
 	movl $-THREAD_SIZE, reg; \
 	andl %esp, reg
 
@@ -117,14 +117,16 @@ static inline struct thread_info *current_thread_info(void)
 
 /*
  * thread information flags
- * - these are process state flags that various assembly files may need to access
+ * - these are process state flags that various
+ *   assembly files may need to access
  * - pending work-to-be-done flags are in LSW
  * - other flags in MSW
  */
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
 #define TIF_SIGPENDING		1	/* signal pending */
 #define TIF_NEED_RESCHED	2	/* rescheduling necessary */
-#define TIF_SINGLESTEP		3	/* restore singlestep on return to user mode */
+#define TIF_SINGLESTEP		3	/* restore singlestep on return to
+					   user mode */
 #define TIF_IRET		4	/* return with iret */
 #define TIF_SYSCALL_EMU		5	/* syscall emulation active */
 #define TIF_SYSCALL_AUDIT	6	/* syscall auditing active */
@@ -141,36 +143,36 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_DS_AREA_MSR 	23      /* uses thread_struct.ds_area_msr */
 #define TIF_BTS_TRACE_TS        24      /* record scheduling event timestamps */
 
-#define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
-#define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
-#define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
-#define _TIF_SINGLESTEP		(1<<TIF_SINGLESTEP)
-#define _TIF_IRET		(1<<TIF_IRET)
-#define _TIF_SYSCALL_EMU	(1<<TIF_SYSCALL_EMU)
-#define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
-#define _TIF_SECCOMP		(1<<TIF_SECCOMP)
-#define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
-#define _TIF_HRTICK_RESCHED	(1<<TIF_HRTICK_RESCHED)
-#define _TIF_DEBUG		(1<<TIF_DEBUG)
-#define _TIF_IO_BITMAP		(1<<TIF_IO_BITMAP)
-#define _TIF_FREEZE		(1<<TIF_FREEZE)
-#define _TIF_NOTSC		(1<<TIF_NOTSC)
-#define _TIF_FORCED_TF		(1<<TIF_FORCED_TF)
-#define _TIF_DEBUGCTLMSR	(1<<TIF_DEBUGCTLMSR)
-#define _TIF_DS_AREA_MSR	(1<<TIF_DS_AREA_MSR)
-#define _TIF_BTS_TRACE_TS	(1<<TIF_BTS_TRACE_TS)
+#define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
+#define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
+#define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
+#define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
+#define _TIF_IRET		(1 << TIF_IRET)
+#define _TIF_SYSCALL_EMU	(1 << TIF_SYSCALL_EMU)
+#define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
+#define _TIF_SECCOMP		(1 << TIF_SECCOMP)
+#define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
+#define _TIF_HRTICK_RESCHED	(1 << TIF_HRTICK_RESCHED)
+#define _TIF_DEBUG		(1 << TIF_DEBUG)
+#define _TIF_IO_BITMAP		(1 << TIF_IO_BITMAP)
+#define _TIF_FREEZE		(1 << TIF_FREEZE)
+#define _TIF_NOTSC		(1 << TIF_NOTSC)
+#define _TIF_FORCED_TF		(1 << TIF_FORCED_TF)
+#define _TIF_DEBUGCTLMSR	(1 << TIF_DEBUGCTLMSR)
+#define _TIF_DS_AREA_MSR	(1 << TIF_DS_AREA_MSR)
+#define _TIF_BTS_TRACE_TS	(1 << TIF_BTS_TRACE_TS)
 
 /* work to do on interrupt/exception return */
-#define _TIF_WORK_MASK \
-  (0x0000FFFF & ~(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | \
-		  _TIF_SECCOMP | _TIF_SYSCALL_EMU))
+#define _TIF_WORK_MASK							\
+	(0x0000FFFF & ~(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT |	\
+			_TIF_SECCOMP | _TIF_SYSCALL_EMU))
 /* work to do on any return to u-space */
 #define _TIF_ALLWORK_MASK	(0x0000FFFF & ~_TIF_SECCOMP)
 
 /* flags to check in __switch_to() */
-#define _TIF_WORK_CTXSW \
-    (_TIF_IO_BITMAP | _TIF_NOTSC | _TIF_DEBUGCTLMSR | \
-     _TIF_DS_AREA_MSR | _TIF_BTS_TRACE_TS)
+#define _TIF_WORK_CTXSW						\
+	(_TIF_IO_BITMAP | _TIF_NOTSC | _TIF_DEBUGCTLMSR |	\
+	 _TIF_DS_AREA_MSR | _TIF_BTS_TRACE_TS)
 #define _TIF_WORK_CTXSW_PREV _TIF_WORK_CTXSW
 #define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW | _TIF_DEBUG)
 
@@ -182,8 +184,10 @@ static inline struct thread_info *current_thread_info(void)
  * ever touches our thread-synchronous status, so we don't
  * have to worry about atomic accesses.
  */
-#define TS_USEDFPU		0x0001	/* FPU was used by this task this quantum (SMP) */
-#define TS_POLLING		0x0002	/* True if in idle loop and not sleeping */
+#define TS_USEDFPU		0x0001	/* FPU was used by this task
+					   this quantum (SMP) */
+#define TS_POLLING		0x0002	/* True if in idle loop
+					   and not sleeping */
 
 #define tsk_is_polling(t) (task_thread_info(t)->status & TS_POLLING)
 
-- 
1.5.4.rc2


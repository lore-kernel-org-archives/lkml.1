Return-Path: <linux-kernel-owner+w=401wt.eu-S1765107AbYCWIl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765107AbYCWIl2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759886AbYCWIKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:10:36 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2307 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759855AbYCWIKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:10:34 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 128/148] include/asm-x86/thread_info_64.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:43 -0700
Message-Id: <1206259443-13210-129-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/thread_info_64.h |   78 ++++++++++++++++++++------------------
 1 files changed, 41 insertions(+), 37 deletions(-)

diff --git a/include/asm-x86/thread_info_64.h b/include/asm-x86/thread_info_64.h
index 92ff23d..f23fefc 100644
--- a/include/asm-x86/thread_info_64.h
+++ b/include/asm-x86/thread_info_64.h
@@ -29,9 +29,9 @@ struct thread_info {
 	__u32			flags;		/* low level flags */
 	__u32			status;		/* thread synchronous flags */
 	__u32			cpu;		/* current CPU */
-	int 			preempt_count;	/* 0 => preemptable, <0 => BUG */
-
-	mm_segment_t		addr_limit;	
+	int 			preempt_count;	/* 0 => preemptable,
+						   <0 => BUG */
+	mm_segment_t		addr_limit;
 	struct restart_block    restart_block;
 #ifdef CONFIG_IA32_EMULATION
 	void __user		*sysenter_return;
@@ -61,17 +61,17 @@ struct thread_info {
 #define init_stack		(init_thread_union.stack)
 
 static inline struct thread_info *current_thread_info(void)
-{ 
+{
 	struct thread_info *ti;
 	ti = (void *)(read_pda(kernelstack) + PDA_STACKOFFSET - THREAD_SIZE);
-	return ti; 
+	return ti;
 }
 
 /* do not use in interrupt context */
 static inline struct thread_info *stack_thread_info(void)
 {
 	struct thread_info *ti;
-	__asm__("andq %%rsp,%0; ":"=r" (ti) : "0" (~(THREAD_SIZE - 1)));
+	asm("andq %%rsp,%0; " : "=r" (ti) : "0" (~(THREAD_SIZE - 1)));
 	return ti;
 }
 
@@ -82,8 +82,8 @@ static inline struct thread_info *stack_thread_info(void)
 #define THREAD_FLAGS GFP_KERNEL
 #endif
 
-#define alloc_thread_info(tsk) \
-	((struct thread_info *) __get_free_pages(THREAD_FLAGS, THREAD_ORDER))
+#define alloc_thread_info(tsk)						\
+	((struct thread_info *)__get_free_pages(THREAD_FLAGS, THREAD_ORDER))
 
 #else /* !__ASSEMBLY__ */
 
@@ -96,7 +96,8 @@ static inline struct thread_info *stack_thread_info(void)
 
 /*
  * thread information flags
- * - these are process state flags that various assembly files may need to access
+ * - these are process state flags that various assembly files
+ *   may need to access
  * - pending work-to-be-done flags are in LSW
  * - other flags in MSW
  * Warning: layout of LSW is hardcoded in entry.S
@@ -112,7 +113,7 @@ static inline struct thread_info *stack_thread_info(void)
 #define TIF_MCE_NOTIFY		10	/* notify userspace of an MCE */
 #define TIF_HRTICK_RESCHED	11	/* reprogram hrtick timer */
 /* 16 free */
-#define TIF_IA32		17	/* 32bit process */ 
+#define TIF_IA32		17	/* 32bit process */
 #define TIF_FORK		18	/* ret_from_fork */
 #define TIF_ABI_PENDING		19
 #define TIF_MEMDIE		20
@@ -124,39 +125,40 @@ static inline struct thread_info *stack_thread_info(void)
 #define TIF_DS_AREA_MSR		26      /* uses thread_struct.ds_area_msr */
 #define TIF_BTS_TRACE_TS	27      /* record scheduling event timestamps */
 
-#define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
-#define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
-#define _TIF_SINGLESTEP		(1<<TIF_SINGLESTEP)
-#define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
-#define _TIF_IRET		(1<<TIF_IRET)
-#define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
-#define _TIF_SECCOMP		(1<<TIF_SECCOMP)
-#define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
-#define _TIF_MCE_NOTIFY		(1<<TIF_MCE_NOTIFY)
-#define _TIF_HRTICK_RESCHED	(1<<TIF_HRTICK_RESCHED)
-#define _TIF_IA32		(1<<TIF_IA32)
-#define _TIF_FORK		(1<<TIF_FORK)
-#define _TIF_ABI_PENDING	(1<<TIF_ABI_PENDING)
-#define _TIF_DEBUG		(1<<TIF_DEBUG)
-#define _TIF_IO_BITMAP		(1<<TIF_IO_BITMAP)
-#define _TIF_FREEZE		(1<<TIF_FREEZE)
-#define _TIF_FORCED_TF		(1<<TIF_FORCED_TF)
-#define _TIF_DEBUGCTLMSR	(1<<TIF_DEBUGCTLMSR)
-#define _TIF_DS_AREA_MSR	(1<<TIF_DS_AREA_MSR)
-#define _TIF_BTS_TRACE_TS	(1<<TIF_BTS_TRACE_TS)
+#define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
+#define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
+#define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
+#define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
+#define _TIF_IRET		(1 << TIF_IRET)
+#define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
+#define _TIF_SECCOMP		(1 << TIF_SECCOMP)
+#define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
+#define _TIF_MCE_NOTIFY		(1 << TIF_MCE_NOTIFY)
+#define _TIF_HRTICK_RESCHED	(1 << TIF_HRTICK_RESCHED)
+#define _TIF_IA32		(1 << TIF_IA32)
+#define _TIF_FORK		(1 << TIF_FORK)
+#define _TIF_ABI_PENDING	(1 << TIF_ABI_PENDING)
+#define _TIF_DEBUG		(1 << TIF_DEBUG)
+#define _TIF_IO_BITMAP		(1 << TIF_IO_BITMAP)
+#define _TIF_FREEZE		(1 << TIF_FREEZE)
+#define _TIF_FORCED_TF		(1 << TIF_FORCED_TF)
+#define _TIF_DEBUGCTLMSR	(1 << TIF_DEBUGCTLMSR)
+#define _TIF_DS_AREA_MSR	(1 << TIF_DS_AREA_MSR)
+#define _TIF_BTS_TRACE_TS	(1 << TIF_BTS_TRACE_TS)
 
 /* work to do on interrupt/exception return */
-#define _TIF_WORK_MASK \
-  (0x0000FFFF & ~(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SINGLESTEP|_TIF_SECCOMP))
+#define _TIF_WORK_MASK							\
+	(0x0000FFFF &							\
+	 ~(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SINGLESTEP|_TIF_SECCOMP))
 /* work to do on any return to user space */
 #define _TIF_ALLWORK_MASK (0x0000FFFF & ~_TIF_SECCOMP)
 
-#define _TIF_DO_NOTIFY_MASK \
+#define _TIF_DO_NOTIFY_MASK						\
 	(_TIF_SIGPENDING|_TIF_SINGLESTEP|_TIF_MCE_NOTIFY|_TIF_HRTICK_RESCHED)
 
 /* flags to check in __switch_to() */
-#define _TIF_WORK_CTXSW \
-    (_TIF_IO_BITMAP|_TIF_DEBUGCTLMSR|_TIF_DS_AREA_MSR|_TIF_BTS_TRACE_TS)
+#define _TIF_WORK_CTXSW							\
+	(_TIF_IO_BITMAP|_TIF_DEBUGCTLMSR|_TIF_DS_AREA_MSR|_TIF_BTS_TRACE_TS)
 #define _TIF_WORK_CTXSW_PREV _TIF_WORK_CTXSW
 #define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW|_TIF_DEBUG)
 
@@ -169,9 +171,11 @@ static inline struct thread_info *stack_thread_info(void)
  * ever touches our thread-synchronous status, so we don't
  * have to worry about atomic accesses.
  */
-#define TS_USEDFPU		0x0001	/* FPU was used by this task this quantum (SMP) */
+#define TS_USEDFPU		0x0001	/* FPU was used by this task
+					   this quantum (SMP) */
 #define TS_COMPAT		0x0002	/* 32bit syscall active */
-#define TS_POLLING		0x0004	/* true if in idle loop and not sleeping */
+#define TS_POLLING		0x0004	/* true if in idle loop
+					   and not sleeping */
 
 #define tsk_is_polling(t) (task_thread_info(t)->status & TS_POLLING)
 
-- 
1.5.4.rc2


Return-Path: <linux-kernel-owner+w=401wt.eu-S933137AbZHVE7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933137AbZHVE7Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 00:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932655AbZHVE7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 00:59:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932887AbZHVE7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 00:59:21 -0400
From: Josh Stone <jistone@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Josh Stone <jistone@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH v3 1/4] tracing: Rename TIF_SYSCALL_FTRACE->_TRACEPOINT
Date: Fri, 21 Aug 2009 21:58:42 -0700
Message-Id: <1250917125-6174-2-git-send-email-jistone@redhat.com>
In-Reply-To: <1250917125-6174-1-git-send-email-jistone@redhat.com>
References: <1250795373-32363-1-git-send-email-jistone@redhat.com>
 <1250917125-6174-1-git-send-email-jistone@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This thread flag is no longer specific to just ftrace, so
TIF_SYSCALL_TRACEPOINT may be a more apt name.

Signed-off-by: Josh Stone <jistone@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jiaying Zhang <jiayingz@google.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 arch/s390/include/asm/thread_info.h |    4 ++--
 arch/s390/kernel/entry.S            |    2 +-
 arch/s390/kernel/entry64.S          |    2 +-
 arch/s390/kernel/ptrace.c           |    4 ++--
 arch/x86/include/asm/thread_info.h  |   13 +++++++------
 arch/x86/kernel/ptrace.c            |    4 ++--
 kernel/tracepoint.c                 |    4 ++--
 7 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/arch/s390/include/asm/thread_info.h b/arch/s390/include/asm/thread_info.h
index ba1cab9..07eb61b 100644
--- a/arch/s390/include/asm/thread_info.h
+++ b/arch/s390/include/asm/thread_info.h
@@ -92,7 +92,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_SYSCALL_TRACE	8	/* syscall trace active */
 #define TIF_SYSCALL_AUDIT	9	/* syscall auditing active */
 #define TIF_SECCOMP		10	/* secure computing */
-#define TIF_SYSCALL_FTRACE	11	/* ftrace syscall instrumentation */
+#define TIF_SYSCALL_TRACEPOINT	11	/* syscall tracepoint instrumentation */
 #define TIF_USEDFPU		16	/* FPU was used by this task this quantum (SMP) */
 #define TIF_POLLING_NRFLAG	17	/* true if poll_idle() is polling 
 					   TIF_NEED_RESCHED */
@@ -111,7 +111,7 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
-#define _TIF_SYSCALL_FTRACE	(1<<TIF_SYSCALL_FTRACE)
+#define _TIF_SYSCALL_TRACEPOINT	(1<<TIF_SYSCALL_TRACEPOINT)
 #define _TIF_USEDFPU		(1<<TIF_USEDFPU)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_31BIT		(1<<TIF_31BIT)
diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index c4c80a2..5d40fce 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -54,7 +54,7 @@ _TIF_WORK_SVC = (_TIF_SIGPENDING | _TIF_NOTIFY_RESUME | _TIF_NEED_RESCHED | \
 _TIF_WORK_INT = (_TIF_SIGPENDING | _TIF_NOTIFY_RESUME | _TIF_NEED_RESCHED | \
 		 _TIF_MCCK_PENDING)
 _TIF_SYSCALL = (_TIF_SYSCALL_TRACE>>8 | _TIF_SYSCALL_AUDIT>>8 | \
-		_TIF_SECCOMP>>8 | _TIF_SYSCALL_FTRACE>>8)
+		_TIF_SECCOMP>>8 | _TIF_SYSCALL_TRACEPOINT>>8)
 
 STACK_SHIFT = PAGE_SHIFT + THREAD_ORDER
 STACK_SIZE  = 1 << STACK_SHIFT
diff --git a/arch/s390/kernel/entry64.S b/arch/s390/kernel/entry64.S
index f6618e9..3ceb53c 100644
--- a/arch/s390/kernel/entry64.S
+++ b/arch/s390/kernel/entry64.S
@@ -57,7 +57,7 @@ _TIF_WORK_SVC = (_TIF_SIGPENDING | _TIF_NOTIFY_RESUME | _TIF_NEED_RESCHED | \
 _TIF_WORK_INT = (_TIF_SIGPENDING | _TIF_NOTIFY_RESUME | _TIF_NEED_RESCHED | \
 		 _TIF_MCCK_PENDING)
 _TIF_SYSCALL = (_TIF_SYSCALL_TRACE>>8 | _TIF_SYSCALL_AUDIT>>8 | \
-		_TIF_SECCOMP>>8 | _TIF_SYSCALL_FTRACE>>8)
+		_TIF_SECCOMP>>8 | _TIF_SYSCALL_TRACEPOINT>>8)
 
 #define BASED(name) name-system_call(%r13)
 
diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index c5e87d8..9d3dcfa 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -664,7 +664,7 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 		ret = -1;
 	}
 
-	if (unlikely(test_thread_flag(TIF_SYSCALL_FTRACE)))
+	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
 		trace_syscall_enter(regs, regs->gprs[2]);
 
 	if (unlikely(current->audit_context))
@@ -682,7 +682,7 @@ asmlinkage void do_syscall_trace_exit(struct pt_regs *regs)
 		audit_syscall_exit(AUDITSC_RESULT(regs->gprs[2]),
 				   regs->gprs[2]);
 
-	if (unlikely(test_thread_flag(TIF_SYSCALL_FTRACE)))
+	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
 		trace_syscall_exit(regs, regs->gprs[2]);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index fad7d40..6f7786a 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -95,7 +95,7 @@ struct thread_info {
 #define TIF_DEBUGCTLMSR		25	/* uses thread_struct.debugctlmsr */
 #define TIF_DS_AREA_MSR		26      /* uses thread_struct.ds_area_msr */
 #define TIF_LAZY_MMU_UPDATES	27	/* task is updating the mmu lazily */
-#define TIF_SYSCALL_FTRACE	28	/* for ftrace syscall instrumentation */
+#define TIF_SYSCALL_TRACEPOINT	28	/* syscall tracepoint instrumentation */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
@@ -118,17 +118,17 @@ struct thread_info {
 #define _TIF_DEBUGCTLMSR	(1 << TIF_DEBUGCTLMSR)
 #define _TIF_DS_AREA_MSR	(1 << TIF_DS_AREA_MSR)
 #define _TIF_LAZY_MMU_UPDATES	(1 << TIF_LAZY_MMU_UPDATES)
-#define _TIF_SYSCALL_FTRACE	(1 << TIF_SYSCALL_FTRACE)
+#define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
 
 /* work to do in syscall_trace_enter() */
 #define _TIF_WORK_SYSCALL_ENTRY	\
-	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_EMU | _TIF_SYSCALL_FTRACE |	\
-	 _TIF_SYSCALL_AUDIT | _TIF_SECCOMP | _TIF_SINGLESTEP)
+	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_EMU | _TIF_SYSCALL_AUDIT |	\
+	 _TIF_SECCOMP | _TIF_SINGLESTEP | _TIF_SYSCALL_TRACEPOINT)
 
 /* work to do in syscall_trace_leave() */
 #define _TIF_WORK_SYSCALL_EXIT	\
 	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | _TIF_SINGLESTEP |	\
-	 _TIF_SYSCALL_FTRACE)
+	 _TIF_SYSCALL_TRACEPOINT)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK							\
@@ -137,7 +137,8 @@ struct thread_info {
 	   _TIF_SINGLESTEP|_TIF_SECCOMP|_TIF_SYSCALL_EMU))
 
 /* work to do on any return to user space */
-#define _TIF_ALLWORK_MASK ((0x0000FFFF & ~_TIF_SECCOMP) | _TIF_SYSCALL_FTRACE)
+#define _TIF_ALLWORK_MASK						\
+	((0x0000FFFF & ~_TIF_SECCOMP) | _TIF_SYSCALL_TRACEPOINT)
 
 /* Only used for 64 bit */
 #define _TIF_DO_NOTIFY_MASK						\
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 34dd6f1..a909afe 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1500,7 +1500,7 @@ asmregparm long syscall_trace_enter(struct pt_regs *regs)
 	    tracehook_report_syscall_entry(regs))
 		ret = -1L;
 
-	if (unlikely(test_thread_flag(TIF_SYSCALL_FTRACE)))
+	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
 		trace_syscall_enter(regs, regs->orig_ax);
 
 	if (unlikely(current->audit_context)) {
@@ -1526,7 +1526,7 @@ asmregparm void syscall_trace_leave(struct pt_regs *regs)
 	if (unlikely(current->audit_context))
 		audit_syscall_exit(AUDITSC_RESULT(regs->ax), regs->ax);
 
-	if (unlikely(test_thread_flag(TIF_SYSCALL_FTRACE)))
+	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
 		trace_syscall_exit(regs, regs->ax);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 35dd27a..43bca1f 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -593,7 +593,7 @@ void syscall_regfunc(void)
 	if (!sys_tracepoint_refcount) {
 		read_lock_irqsave(&tasklist_lock, flags);
 		do_each_thread(g, t) {
-			set_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
+			set_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
 		} while_each_thread(g, t);
 		read_unlock_irqrestore(&tasklist_lock, flags);
 	}
@@ -611,7 +611,7 @@ void syscall_unregfunc(void)
 	if (!sys_tracepoint_refcount) {
 		read_lock_irqsave(&tasklist_lock, flags);
 		do_each_thread(g, t) {
-			clear_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
+			clear_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
 		} while_each_thread(g, t);
 		read_unlock_irqrestore(&tasklist_lock, flags);
 	}
-- 
1.6.2.5


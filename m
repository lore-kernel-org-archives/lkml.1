Return-Path: <linux-kernel-owner+w=401wt.eu-S932893AbZHZBjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893AbZHZBjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 21:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932880AbZHZBjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 21:39:42 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:57119 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932631AbZHZBjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 21:39:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=bY4j1p44tT+xvXHtua4974quWPazxukWwW7MR15OYgVbisfWiOCf9+RK+t3YTjIeiV
         jZsC4RnGf9xNeA7vtOCU20D8wCGggA5dexwhsA7TTyVmMcKTi/KRUYqhDpbJLDr5nISQ
         mCYyGRBncW38j8q5QJ2IE3H5IKi8Od4duoWOA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
       Linux Arch <linux-arch@vger.kernel.org>,
       Jason Baron <jbaron@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Paul Mundt <lethal@linux-sh.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 1/4] tracing: Rename FTRACE_SYSCALLS for tracepoints
Date: Wed, 26 Aug 2009 03:38:59 +0200
Message-Id: <1251250742-6458-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1251250742-6458-1-git-send-email-fweisbec@gmail.com>
References: <1251250742-6458-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Stone <jistone@redhat.com>

s/HAVE_FTRACE_SYSCALLS/HAVE_SYSCALL_TRACEPOINTS/g
s/TIF_SYSCALL_FTRACE/TIF_SYSCALL_TRACEPOINT/g

The syscall enter/exit tracing is no longer specific to just ftrace, so
they now have names that reflect their tie to tracepoints instead.

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
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
LKML-Reference: <1251150194-1713-2-git-send-email-jistone@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/s390/Kconfig                   |    2 +-
 arch/s390/defconfig                 |    2 +-
 arch/s390/include/asm/thread_info.h |    4 ++--
 arch/s390/kernel/entry.S            |    2 +-
 arch/s390/kernel/entry64.S          |    2 +-
 arch/s390/kernel/ptrace.c           |    4 ++--
 arch/x86/Kconfig                    |    2 +-
 arch/x86/configs/i386_defconfig     |    2 +-
 arch/x86/configs/x86_64_defconfig   |    2 +-
 arch/x86/include/asm/thread_info.h  |   13 +++++++------
 arch/x86/kernel/ptrace.c            |    4 ++--
 kernel/trace/Kconfig                |    4 ++--
 kernel/tracepoint.c                 |    4 ++--
 13 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 2ae5d72..7238ef4 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -84,7 +84,7 @@ config S390
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_FTRACE_MCOUNT_RECORD
-	select HAVE_FTRACE_SYSCALLS
+	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_DEFAULT_NO_SPIN_MUTEXES
diff --git a/arch/s390/defconfig b/arch/s390/defconfig
index fcba206..4e91a25 100644
--- a/arch/s390/defconfig
+++ b/arch/s390/defconfig
@@ -900,7 +900,7 @@ CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
 CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
 CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
-CONFIG_HAVE_FTRACE_SYSCALLS=y
+CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
 CONFIG_TRACING_SUPPORT=y
 CONFIG_FTRACE=y
 # CONFIG_FUNCTION_TRACER is not set
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
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 738bdc6..d59cbf7 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -37,7 +37,7 @@ config X86
 	select HAVE_FUNCTION_GRAPH_FP_TEST
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_FTRACE_NMI_ENTER if DYNAMIC_FTRACE
-	select HAVE_FTRACE_SYSCALLS
+	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_KVM
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index edb992e..d28fad1 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -2355,7 +2355,7 @@ CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
 CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
 CONFIG_HAVE_HW_BRANCH_TRACER=y
-CONFIG_HAVE_FTRACE_SYSCALLS=y
+CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
 CONFIG_RING_BUFFER=y
 CONFIG_TRACING=y
 CONFIG_TRACING_SUPPORT=y
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index cee1dd2..6c86acd 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -2329,7 +2329,7 @@ CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
 CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
 CONFIG_HAVE_HW_BRANCH_TRACER=y
-CONFIG_HAVE_FTRACE_SYSCALLS=y
+CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
 CONFIG_RING_BUFFER=y
 CONFIG_TRACING=y
 CONFIG_TRACING_SUPPORT=y
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
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 019f380..06be85a 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -41,7 +41,7 @@ config HAVE_FTRACE_MCOUNT_RECORD
 config HAVE_HW_BRANCH_TRACER
 	bool
 
-config HAVE_FTRACE_SYSCALLS
+config HAVE_SYSCALL_TRACEPOINTS
 	bool
 
 config TRACER_MAX_TRACE
@@ -211,7 +211,7 @@ config ENABLE_DEFAULT_TRACERS
 
 config FTRACE_SYSCALLS
 	bool "Trace syscalls"
-	depends on HAVE_FTRACE_SYSCALLS
+	depends on HAVE_SYSCALL_TRACEPOINTS
 	select GENERIC_TRACER
 	select KALLSYMS
 	help
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 06f165a..be86b9a 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -590,7 +590,7 @@ void syscall_regfunc(void)
 	if (!sys_tracepoint_refcount) {
 		read_lock_irqsave(&tasklist_lock, flags);
 		do_each_thread(g, t) {
-			set_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
+			set_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
 		} while_each_thread(g, t);
 		read_unlock_irqrestore(&tasklist_lock, flags);
 	}
@@ -608,7 +608,7 @@ void syscall_unregfunc(void)
 	if (!sys_tracepoint_refcount) {
 		read_lock_irqsave(&tasklist_lock, flags);
 		do_each_thread(g, t) {
-			clear_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
+			clear_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
 		} while_each_thread(g, t);
 		read_unlock_irqrestore(&tasklist_lock, flags);
 	}
-- 
1.6.2.3


Return-Path: <linux-kernel-owner+w=401wt.eu-S1760695AbZCOUaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760695AbZCOUaH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 16:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759009AbZCOU0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 16:26:01 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:58969 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758847AbZCOUZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 16:25:57 -0400
Message-Id: <20090315200506.754647697@polymtl.ca>
References: <20090315200144.017321577@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 15 Mar 2009 16:01:57 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 13/20] LTTng Kernel Trace Thread Flag powerpc
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-powerpc.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sun, 15 Mar 2009 20:24:31 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a thread flag to activate system-wide syscall tracing.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/powerpc/include/asm/thread_info.h |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux-2.6-lttng/arch/powerpc/include/asm/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/include/asm/thread_info.h	2009-03-15 15:57:04.000000000 -0400
+++ linux-2.6-lttng/arch/powerpc/include/asm/thread_info.h	2009-03-15 15:57:17.000000000 -0400
@@ -100,7 +100,7 @@ static inline struct thread_info *curren
 #define TIF_POLLING_NRFLAG	3	/* true if poll_idle() is polling
 					   TIF_NEED_RESCHED */
 #define TIF_32BIT		4	/* 32 bit binary */
-#define TIF_PERFMON_WORK	5	/* work for pfm_handle_work() */
+#define TIF_KERNEL_TRACE	5	/* kernel trace active */
 #define TIF_PERFMON_CTXSW	6	/* perfmon needs ctxsw calls */
 #define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
 #define TIF_SINGLESTEP		8	/* singlestepping active */
@@ -112,6 +112,7 @@ static inline struct thread_info *curren
 #define TIF_FREEZE		14	/* Freezing for suspend */
 #define TIF_RUNLATCH		15	/* Is the runlatch enabled? */
 #define TIF_ABI_PENDING		16	/* 32/64 bit switch needed */
+#define TIF_PERFMON_WORK	17	/* work for pfm_handle_work() */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
@@ -119,7 +120,7 @@ static inline struct thread_info *curren
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_32BIT		(1<<TIF_32BIT)
-#define _TIF_PERFMON_WORK	(1<<TIF_PERFMON_WORK)
+#define _TIF_KERNEL_TRACE	(1<<TIF_KERNEL_TRACE)
 #define _TIF_PERFMON_CTXSW	(1<<TIF_PERFMON_CTXSW)
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
 #define _TIF_SINGLESTEP		(1<<TIF_SINGLESTEP)
@@ -130,7 +131,8 @@ static inline struct thread_info *curren
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
 #define _TIF_RUNLATCH		(1<<TIF_RUNLATCH)
 #define _TIF_ABI_PENDING	(1<<TIF_ABI_PENDING)
-#define _TIF_SYSCALL_T_OR_A	(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP)
+#define _TIF_PERFMON_WORK	(1<<TIF_PERFMON_WORK)
+#define _TIF_SYSCALL_T_OR_A	(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP|_TIF_KERNEL_TRACE)
 
 #define _TIF_USER_WORK_MASK	(_TIF_SIGPENDING | _TIF_NEED_RESCHED | \
 				 _TIF_NOTIFY_RESUME)

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

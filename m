Return-Path: <linux-kernel-owner+w=401wt.eu-S1755703AbZEIQzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703AbZEIQzV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 12:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755875AbZEIQvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 12:51:32 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:54691 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755935AbZEIQvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 12:51:31 -0400
Message-Id: <20090509162350.632906649@polymtl.ca>
References: <20090509162209.217414024@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sat, 09 May 2009 12:22:24 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       fweisbec@gmail.com, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, jiayingz@google.com, roland@redhat.com,
       mbligh@google.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 15/20] LTTng Kernel Trace Thread Flag SH
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-sh.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sat,  9 May 2009 16:47:20 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a thread flag to activate system-wide syscall tracing.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/sh/include/asm/thread_info.h |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

Index: linux-2.6-lttng/arch/sh/include/asm/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/arch/sh/include/asm/thread_info.h	2009-03-15 15:57:04.000000000 -0400
+++ linux-2.6-lttng/arch/sh/include/asm/thread_info.h	2009-03-15 15:57:17.000000000 -0400
@@ -116,6 +116,7 @@ extern void free_thread_info(struct thre
 #define TIF_SYSCALL_AUDIT	5	/* syscall auditing active */
 #define TIF_SECCOMP		6	/* secure computing */
 #define TIF_NOTIFY_RESUME	7	/* callback before returning to user */
+#define TIF_KERNEL_TRACE	8	/* kernel trace active */
 #define TIF_USEDFPU		16	/* FPU was used by this task this quantum (SMP) */
 #define TIF_POLLING_NRFLAG	17	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		18
@@ -129,6 +130,7 @@ extern void free_thread_info(struct thre
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
+#define _TIF_KERNEL_TRACE	(1 << TIF_KERNEL_TRACE)
 #define _TIF_USEDFPU		(1 << TIF_USEDFPU)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_FREEZE		(1 << TIF_FREEZE)
@@ -141,17 +143,19 @@ extern void free_thread_info(struct thre
 
 /* work to do in syscall trace */
 #define _TIF_WORK_SYSCALL_MASK	(_TIF_SYSCALL_TRACE | _TIF_SINGLESTEP | \
-				 _TIF_SYSCALL_AUDIT | _TIF_SECCOMP)
+				 _TIF_SYSCALL_AUDIT | _TIF_SECCOMP | \
+				 _TIF_KERNEL_TRACE)
 
 /* work to do on any return to u-space */
 #define _TIF_ALLWORK_MASK	(_TIF_SYSCALL_TRACE | _TIF_SIGPENDING      | \
 				 _TIF_NEED_RESCHED  | _TIF_SYSCALL_AUDIT   | \
 				 _TIF_SINGLESTEP    | _TIF_RESTORE_SIGMASK | \
-				 _TIF_NOTIFY_RESUME)
+				 _TIF_NOTIFY_RESUME | _TIF_KERNEL_TRACE)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK		(_TIF_ALLWORK_MASK & ~(_TIF_SYSCALL_TRACE | \
-				 _TIF_SYSCALL_AUDIT | _TIF_SINGLESTEP))
+				 _TIF_SYSCALL_AUDIT | _TIF_SINGLESTEP | \
+				 _TIF_KERNEL_TRACE))
 
 #endif /* __KERNEL__ */
 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

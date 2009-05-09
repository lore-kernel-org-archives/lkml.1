Return-Path: <linux-kernel-owner+w=401wt.eu-S1755238AbZEIQtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbZEIQtZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 12:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbZEIQs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 12:48:56 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:54416 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754632AbZEIQsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 12:48:55 -0400
Message-Id: <20090509162349.657122969@polymtl.ca>
References: <20090509162209.217414024@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sat, 09 May 2009 12:22:18 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       fweisbec@gmail.com, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, jiayingz@google.com, roland@redhat.com,
       mbligh@google.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 09/20] LTTng Kernel Trace Thread Flag m32r
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-m32r.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sat,  9 May 2009 16:47:19 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a thread flag to activate system-wide syscall tracing.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/m32r/include/asm/thread_info.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/arch/m32r/include/asm/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/arch/m32r/include/asm/thread_info.h	2009-05-09 11:39:23.000000000 -0400
+++ linux-2.6-lttng/arch/m32r/include/asm/thread_info.h	2009-05-09 11:40:38.000000000 -0400
@@ -151,6 +151,7 @@ static inline unsigned int get_thread_fa
 #define TIF_NEED_RESCHED	2	/* rescheduling necessary */
 #define TIF_SINGLESTEP		3	/* restore singlestep on return to user mode */
 #define TIF_IRET		4	/* return with iret */
+#define TIF_KERNEL_TRACE	5	/* kernel trace active */
 #define TIF_RESTORE_SIGMASK	8	/* restore signal mask in do_signal() */
 #define TIF_USEDFPU		16	/* FPU was used by this task this quantum (SMP) */
 #define TIF_POLLING_NRFLAG	17	/* true if poll_idle() is polling TIF_NEED_RESCHED */
@@ -162,13 +163,17 @@ static inline unsigned int get_thread_fa
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_SINGLESTEP		(1<<TIF_SINGLESTEP)
 #define _TIF_IRET		(1<<TIF_IRET)
+#define _TIF_KERNEL_TRACE	(1<<TIF_KERNEL_TRACE)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_USEDFPU		(1<<TIF_USEDFPU)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
 
-#define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
-#define _TIF_ALLWORK_MASK	0x0000FFFF	/* work to do on any return to u-space */
+/* work to do on any return to u-space */
+#define _TIF_ALLWORK_MASK	0x0000FFFF
+/* work to do on interrupt/exception return */
+#define _TIF_WORK_MASK \
+	(0x0000FFFF & ~(_TIF_SYSCALL_TRACE | _TIF_KERNEL_TRACE))
 
 /*
  * Thread-synchronous status.

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

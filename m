Return-Path: <linux-kernel-owner+w=401wt.eu-S1756948AbXLFCrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948AbXLFCrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 21:47:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754716AbXLFCox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 21:44:53 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:51345 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357AbXLFCot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 21:44:49 -0500
Message-Id: <20071206024432.510147866@polymtl.ca>
References: <20071206024243.397994403@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 21:42:53 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch-RFC 10/26] LTTng Kernel Trace Thread Flag m32r
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-m32r.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Dec 2007 02:44:35 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a thread flag to activate system-wide syscall tracing.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/asm-m32r/thread_info.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/include/asm-m32r/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-m32r/thread_info.h	2007-11-28 08:40:56.000000000 -0500
+++ linux-2.6-lttng/include/asm-m32r/thread_info.h	2007-11-28 08:47:42.000000000 -0500
@@ -149,6 +149,7 @@ static inline unsigned int get_thread_fa
 #define TIF_NEED_RESCHED	2	/* rescheduling necessary */
 #define TIF_SINGLESTEP		3	/* restore singlestep on return to user mode */
 #define TIF_IRET		4	/* return with iret */
+#define TIF_KERNEL_TRACE	5	/* kernel trace active */
 #define TIF_RESTORE_SIGMASK	8	/* restore signal mask in do_signal() */
 #define TIF_USEDFPU		16	/* FPU was used by this task this quantum (SMP) */
 #define TIF_POLLING_NRFLAG	17	/* true if poll_idle() is polling TIF_NEED_RESCHED */
@@ -160,13 +161,17 @@ static inline unsigned int get_thread_fa
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
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752085AbXLFCtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbXLFCtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 21:49:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877AbXLFCo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 21:44:57 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:51367 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754712AbXLFCox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 21:44:53 -0500
Message-Id: <20071206024430.439255443@polymtl.ca>
References: <20071206024243.397994403@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 21:42:48 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch-RFC 05/26] LTTng Kernel Trace Thread Flag Cris
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-cris.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Dec 2007 02:44:33 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a thread flag to activate system-wide syscall tracing.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/asm-cris/thread_info.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/include/asm-cris/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-cris/thread_info.h	2007-11-15 21:18:41.000000000 -0500
+++ linux-2.6-lttng/include/asm-cris/thread_info.h	2007-11-15 21:32:07.000000000 -0500
@@ -83,6 +83,7 @@ struct thread_info {
 #define TIF_NOTIFY_RESUME	1	/* resumption notification requested */
 #define TIF_SIGPENDING		2	/* signal pending */
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
+#define TIF_KERNEL_TRACE	4	/* kernel trace active */
 #define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal() */
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		17
@@ -91,11 +92,15 @@ struct thread_info {
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
+#define _TIF_KERNEL_TRACE	(1<<TIF_KERNEL_TRACE)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 
-#define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
-#define _TIF_ALLWORK_MASK	0x0000FFFF	/* work to do on any return to u-space */
+/* work to do on interrupt/exception return */
+#define _TIF_WORK_MASK		0x0000FFFF & \
+		(~_TIF_SYSCALL_TRACE | ~_TIF_KERNEL_TRACE)
+/* work to do on any return to u-space */
+#define _TIF_ALLWORK_MASK	0x0000FFFF
 
 #endif /* __KERNEL__ */
 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

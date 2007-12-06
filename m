Return-Path: <linux-kernel-owner+w=401wt.eu-S1756915AbXLFCsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915AbXLFCsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 21:48:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754793AbXLFCoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 21:44:54 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:51355 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754567AbXLFCou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 21:44:50 -0500
Message-Id: <20071206024430.793776504@polymtl.ca>
References: <20071206024243.397994403@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 21:42:49 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch-RFC 06/26] LTTng Kernel Trace Thread Flag Frv
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-frv.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Dec 2007 02:44:33 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a thread flag to activate system-wide syscall tracing.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/asm-frv/thread_info.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/include/asm-frv/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-frv/thread_info.h	2007-09-04 11:52:56.000000000 -0400
+++ linux-2.6-lttng/include/asm-frv/thread_info.h	2007-09-04 12:19:57.000000000 -0400
@@ -112,6 +112,7 @@ register struct thread_info *__current_t
 #define TIF_SINGLESTEP		3	/* restore singlestep on return to user mode */
 #define TIF_IRET		4	/* return with iret */
 #define TIF_RESTORE_SIGMASK	5	/* restore signal mask in do_signal() */
+#define TIF_KERNEL_TRACE	6	/* kernel trace active */
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		17	/* OOM killer killed process */
 #define TIF_FREEZE		18	/* freezing for suspend */
@@ -122,10 +123,11 @@ register struct thread_info *__current_t
 #define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
 #define _TIF_IRET		(1 << TIF_IRET)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
+#define _TIF_KERNEL_TRACE	(1 << TIF_KERNEL_TRACE)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_FREEZE		(1 << TIF_FREEZE)
 
-#define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
+#define _TIF_WORK_MASK		0x0000FFBE	/* work to do on interrupt/exception return */
 #define _TIF_ALLWORK_MASK	0x0000FFFF	/* work to do on any return to u-space */
 
 /*

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

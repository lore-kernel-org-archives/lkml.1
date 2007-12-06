Return-Path: <linux-kernel-owner+w=401wt.eu-S1756653AbXLFCqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbXLFCqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 21:46:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbXLFCou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 21:44:50 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:51323 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768AbXLFCor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 21:44:47 -0500
Message-Id: <20071206024429.692624577@polymtl.ca>
References: <20071206024243.397994403@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 21:42:46 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch-RFC 03/26] LTTng Kernel Trace Thread Flag AVR32
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-avr32.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Dec 2007 02:44:32 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a thread flag to activate system-wide syscall tracing.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/asm-avr32/thread_info.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/include/asm-avr32/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-avr32/thread_info.h	2007-07-30 18:49:43.000000000 -0400
+++ linux-2.6-lttng/include/asm-avr32/thread_info.h	2007-07-30 18:59:15.000000000 -0400
@@ -83,6 +83,7 @@ static inline struct thread_info *curren
 #define TIF_MEMDIE		6
 #define TIF_RESTORE_SIGMASK	7	/* restore signal mask in do_signal */
 #define TIF_CPU_GOING_TO_SLEEP	8	/* CPU is entering sleep 0 mode */
+#define TIF_KERNEL_TRACE        9       /* kernel trace active */
 #define TIF_USERSPACE		31      /* true if FS sets userspace */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
@@ -94,12 +95,13 @@ static inline struct thread_info *curren
 #define _TIF_MEMDIE		(1 << TIF_MEMDIE)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
 #define _TIF_CPU_GOING_TO_SLEEP (1 << TIF_CPU_GOING_TO_SLEEP)
+#define _TIF_KERNEL_TRACE	(1 << TIF_KERNEL_TRACE)
 
 /* XXX: These two masks must never span more than 16 bits! */
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK		0x0000013e
 /* work to do on any return to userspace */
-#define _TIF_ALLWORK_MASK	0x0000013f
+#define _TIF_ALLWORK_MASK	0x0000033f
 /* work to do on return from debug mode */
 #define _TIF_DBGWORK_MASK	0x0000017e
 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

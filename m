Return-Path: <linux-kernel-owner+w=401wt.eu-S1757850AbXLFCwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850AbXLFCwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 21:52:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754615AbXLFCpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 21:45:15 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:51411 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755283AbXLFCpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 21:45:00 -0500
Message-Id: <20071206024433.673854396@polymtl.ca>
References: <20071206024243.397994403@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 21:42:56 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch-RFC 13/26] LTTng Kernel Trace Thread Flag MIPS
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-mips.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Dec 2007 02:44:36 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a thread flag to activate system-wide syscall tracing.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/asm-mips/thread_info.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/include/asm-mips/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-mips/thread_info.h	2007-08-09 15:19:01.000000000 -0400
+++ linux-2.6-lttng/include/asm-mips/thread_info.h	2007-08-09 15:28:15.000000000 -0400
@@ -122,9 +122,11 @@ register struct thread_info *__current_t
 #define TIF_32BIT_REGS		22	/* also implies 16/32 fprs */
 #define TIF_32BIT_ADDR		23	/* 32-bit address space (o32/n32) */
 #define TIF_FPUBOUND		24	/* thread bound to FPU-full CPU set */
+#define TIF_KERNEL_TRACE	30	/* kernel trace active */
 #define TIF_SYSCALL_TRACE	31	/* syscall trace active */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
+#define _TIF_KERNEL_TRACE	(1<<TIF_KERNEL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
@@ -142,7 +144,7 @@ register struct thread_info *__current_t
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK		(0x0000ffef & ~_TIF_SECCOMP)
 /* work to do on any return to u-space */
-#define _TIF_ALLWORK_MASK	(0x8000ffff & ~_TIF_SECCOMP)
+#define _TIF_ALLWORK_MASK	(0xc000ffff & ~_TIF_SECCOMP)
 
 #endif /* __KERNEL__ */
 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

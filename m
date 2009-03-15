Return-Path: <linux-kernel-owner+w=401wt.eu-S1758157AbZCOTbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157AbZCOTbs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 15:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755892AbZCOTbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 15:31:22 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:56366 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906AbZCOTbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 15:31:21 -0400
Message-Id: <20090315191104.019235372@polymtl.ca>
References: <20090315190340.229569867@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 15 Mar 2009 15:03:51 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 11/21] LTTng Kernel Trace Thread Flag MIPS
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-mips.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sun, 15 Mar 2009 19:30:28 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a thread flag to activate system-wide syscall tracing.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/mips/include/asm/thread_info.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/arch/mips/include/asm/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/arch/mips/include/asm/thread_info.h	2009-01-09 18:15:55.000000000 -0500
+++ linux-2.6-lttng/arch/mips/include/asm/thread_info.h	2009-01-09 18:17:47.000000000 -0500
@@ -125,9 +125,11 @@ register struct thread_info *__current_t
 #define TIF_32BIT_ADDR		23	/* 32-bit address space (o32/n32) */
 #define TIF_FPUBOUND		24	/* thread bound to FPU-full CPU set */
 #define TIF_LOAD_WATCH		25	/* If set, load watch registers */
+#define TIF_KERNEL_TRACE	30	/* kernel trace active */
 #define TIF_SYSCALL_TRACE	31	/* syscall trace active */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
+#define _TIF_KERNEL_TRACE	(1<<TIF_KERNEL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
@@ -146,7 +148,7 @@ register struct thread_info *__current_t
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK		(0x0000ffef & ~_TIF_SECCOMP)
 /* work to do on any return to u-space */
-#define _TIF_ALLWORK_MASK	(0x8000ffff & ~_TIF_SECCOMP)
+#define _TIF_ALLWORK_MASK	(0xc000ffff & ~_TIF_SECCOMP)
 
 #endif /* __KERNEL__ */
 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

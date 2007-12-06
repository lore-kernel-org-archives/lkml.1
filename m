Return-Path: <linux-kernel-owner+w=401wt.eu-S1757921AbXLFCwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921AbXLFCwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 21:52:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755690AbXLFCpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 21:45:33 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:51494 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755563AbXLFCpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 21:45:32 -0500
Message-Id: <20071206024438.257679926@polymtl.ca>
References: <20071206024243.397994403@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 21:43:07 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch-RFC 24/26] LTTng Linux Kernel Trace Thread Flag x86_64
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-x86_64.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Dec 2007 02:44:40 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a thread flag to activate system-wide syscall tracing.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: H. Peter Anvin <hpa@zytor.com>
---
 include/asm-x86/thread_info_64.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/include/asm-x86/thread_info_64.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86/thread_info_64.h	2007-11-02 11:06:22.000000000 -0400
+++ linux-2.6-lttng/include/asm-x86/thread_info_64.h	2007-11-02 12:02:57.000000000 -0400
@@ -107,6 +107,7 @@ static inline struct thread_info *stack_
  * Warning: layout of LSW is hardcoded in entry.S
  */
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
+#define TIF_KERNEL_TRACE	1	/* kernel trace active */
 #define TIF_SIGPENDING		2	/* signal pending */
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
 #define TIF_SINGLESTEP		4	/* reenable singlestep on user return*/
@@ -125,6 +126,7 @@ static inline struct thread_info *stack_
 #define TIF_FREEZE		23	/* is freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
+#define _TIF_KERNEL_TRACE	(1<<TIF_KERNEL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_SINGLESTEP		(1<<TIF_SINGLESTEP)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
@@ -142,7 +144,7 @@ static inline struct thread_info *stack_
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK \
-  (0x0000FFFF & ~(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SINGLESTEP|_TIF_SECCOMP))
+  (0x0000FFFF & ~(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_KERNEL_TRACE|_TIF_SINGLESTEP|_TIF_SECCOMP))
 /* work to do on any return to user space */
 #define _TIF_ALLWORK_MASK (0x0000FFFF & ~_TIF_SECCOMP)
 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

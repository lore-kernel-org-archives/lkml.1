Return-Path: <linux-kernel-owner+w=401wt.eu-S1757831AbXLFCxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831AbXLFCxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 21:53:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754523AbXLFCph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 21:45:37 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:51496 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755722AbXLFCpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 21:45:36 -0500
Message-Id: <20071206024431.513408373@polymtl.ca>
References: <20071206024243.397994403@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 21:42:51 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch-RFC 08/26] LTTng Linux Kernel Trace Thread Flags x86_32
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-i386.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Dec 2007 02:44:34 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a thread flag to activate system-wide syscall tracing.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: H. Peter Anvin <hpa@zytor.com>
---
 include/asm-i386/thread_info.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/include/asm-x86/thread_info_32.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86/thread_info_32.h	2007-07-30 19:41:44.000000000 -0400
+++ linux-2.6-lttng/include/asm-x86/thread_info_32.h	2007-07-30 20:07:03.000000000 -0400
@@ -132,6 +132,7 @@ static inline struct thread_info *curren
 #define TIF_SYSCALL_AUDIT	6	/* syscall auditing active */
 #define TIF_SECCOMP		7	/* secure computing */
 #define TIF_RESTORE_SIGMASK	8	/* restore signal mask in do_signal() */
+#define TIF_KERNEL_TRACE	9	/* kernel trace active */
 #define TIF_MEMDIE		16
 #define TIF_DEBUG		17	/* uses debug registers */
 #define TIF_IO_BITMAP		18	/* uses I/O bitmap */
@@ -147,6 +148,7 @@ static inline struct thread_info *curren
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
+#define _TIF_KERNEL_TRACE	(1<<TIF_KERNEL_TRACE)
 #define _TIF_DEBUG		(1<<TIF_DEBUG)
 #define _TIF_IO_BITMAP		(1<<TIF_IO_BITMAP)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
@@ -154,7 +156,7 @@ static inline struct thread_info *curren
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK \
-  (0x0000FFFF & ~(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | \
+  (0x0000FFFF & ~(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | _TIF_KERNEL_TRACE |\
 		  _TIF_SECCOMP | _TIF_SYSCALL_EMU))
 /* work to do on any return to u-space */
 #define _TIF_ALLWORK_MASK	(0x0000FFFF & ~_TIF_SECCOMP)

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

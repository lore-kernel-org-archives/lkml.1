Return-Path: <linux-kernel-owner+w=401wt.eu-S1758798AbZCOTc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798AbZCOTc1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 15:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757548AbZCOTbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 15:31:41 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:56423 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757867AbZCOTbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 15:31:40 -0400
Message-Id: <20090315191102.778196297@polymtl.ca>
References: <20090315190340.229569867@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 15 Mar 2009 15:03:43 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 03/21] LTTng Kernel Trace Thread Flag AVR32
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-avr32.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sun, 15 Mar 2009 19:30:27 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a thread flag to activate system-wide syscall tracing.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/avr32/include/asm/thread_info.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/arch/avr32/include/asm/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/arch/avr32/include/asm/thread_info.h	2009-01-09 18:15:55.000000000 -0500
+++ linux-2.6-lttng/arch/avr32/include/asm/thread_info.h	2009-01-09 18:17:45.000000000 -0500
@@ -84,6 +84,7 @@ static inline struct thread_info *curren
 #define TIF_MEMDIE		6
 #define TIF_RESTORE_SIGMASK	7	/* restore signal mask in do_signal */
 #define TIF_CPU_GOING_TO_SLEEP	8	/* CPU is entering sleep 0 mode */
+#define TIF_KERNEL_TRACE	9	/* kernel trace active */
 #define TIF_FREEZE		29
 #define TIF_DEBUG		30	/* debugging enabled */
 #define TIF_USERSPACE		31      /* true if FS sets userspace */
@@ -96,6 +97,7 @@ static inline struct thread_info *curren
 #define _TIF_MEMDIE		(1 << TIF_MEMDIE)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
 #define _TIF_CPU_GOING_TO_SLEEP (1 << TIF_CPU_GOING_TO_SLEEP)
+#define _TIF_KERNEL_TRACE	(1 << TIF_KERNEL_TRACE)
 #define _TIF_FREEZE		(1 << TIF_FREEZE)
 
 /* Note: The masks below must never span more than 16 bits! */
@@ -109,7 +111,7 @@ static inline struct thread_info *curren
 	 | (1 << TIF_RESTORE_SIGMASK))
 
 /* work to do on any return to userspace */
-#define _TIF_ALLWORK_MASK	(_TIF_WORK_MASK | (1 << TIF_SYSCALL_TRACE))
+#define _TIF_ALLWORK_MASK	(_TIF_WORK_MASK | _TIF_SYSCALL_TRACE | _TIF_KERNEL_TRACE)
 /* work to do on return from debug mode */
 #define _TIF_DBGWORK_MASK	(_TIF_WORK_MASK & ~(1 << TIF_BREAKPOINT))
 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

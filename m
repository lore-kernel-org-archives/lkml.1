Return-Path: <linux-kernel-owner+w=401wt.eu-S1758382AbZCOU3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758382AbZCOU3K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 16:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758808AbZCOUZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 16:25:59 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:58965 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757884AbZCOUZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 16:25:57 -0400
Message-Id: <20090315200505.517041352@polymtl.ca>
References: <20090315200144.017321577@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 15 Mar 2009 16:01:49 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 05/20] LTTng Kernel Trace Thread Flag Cris
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-cris.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sun, 15 Mar 2009 20:24:30 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a thread flag to activate system-wide syscall tracing.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/cris/include/asm/thread_info.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/arch/cris/include/asm/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/arch/cris/include/asm/thread_info.h	2009-03-15 15:57:05.000000000 -0400
+++ linux-2.6-lttng/arch/cris/include/asm/thread_info.h	2009-03-15 15:57:14.000000000 -0400
@@ -85,6 +85,7 @@ struct thread_info {
 #define TIF_NOTIFY_RESUME	1	/* resumption notification requested */
 #define TIF_SIGPENDING		2	/* signal pending */
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
+#define TIF_KERNEL_TRACE	4	/* kernel trace active */
 #define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal() */
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		17
@@ -94,12 +95,16 @@ struct thread_info {
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
+#define _TIF_KERNEL_TRACE	(1<<TIF_KERNEL_TRACE)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
 
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
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

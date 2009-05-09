Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbZEIQwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbZEIQwh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 12:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755142AbZEIQtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 12:49:15 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:54454 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755135AbZEIQtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 12:49:11 -0400
Message-Id: <20090509162349.810329097@polymtl.ca>
References: <20090509162209.217414024@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sat, 09 May 2009 12:22:19 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       fweisbec@gmail.com, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, jiayingz@google.com, roland@redhat.com,
       mbligh@google.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 10/20] LTTng Kernel Trace Thread Flag m68k
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-m68k.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sat,  9 May 2009 16:47:19 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a thread flag to activate system-wide syscall tracing.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/m68k/include/asm/thread_info_mm.h |    1 +
 arch/m68k/include/asm/thread_info_no.h |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/arch/m68k/include/asm/thread_info_mm.h
===================================================================
--- linux-2.6-lttng.orig/arch/m68k/include/asm/thread_info_mm.h	2009-03-15 15:57:05.000000000 -0400
+++ linux-2.6-lttng/arch/m68k/include/asm/thread_info_mm.h	2009-03-15 15:57:16.000000000 -0400
@@ -49,6 +49,7 @@ struct thread_info {
  */
 #define TIF_SIGPENDING		6	/* signal pending */
 #define TIF_NEED_RESCHED	7	/* rescheduling necessary */
+#define TIF_KERNEL_TRACE	13	/* kernel trace active */
 #define TIF_DELAYED_TRACE	14	/* single step a syscall */
 #define TIF_SYSCALL_TRACE	15	/* syscall trace active */
 #define TIF_MEMDIE		16
Index: linux-2.6-lttng/arch/m68k/include/asm/thread_info_no.h
===================================================================
--- linux-2.6-lttng.orig/arch/m68k/include/asm/thread_info_no.h	2009-03-15 15:57:05.000000000 -0400
+++ linux-2.6-lttng/arch/m68k/include/asm/thread_info_no.h	2009-03-15 15:57:16.000000000 -0400
@@ -84,6 +84,7 @@ static inline struct thread_info *curren
 #define TIF_POLLING_NRFLAG	3	/* true if poll_idle() is polling
 					   TIF_NEED_RESCHED */
 #define TIF_MEMDIE		4
+#define TIF_KERNEL_TRACE	5	/* kernel trace active */
 #define TIF_FREEZE		16	/* is freezing for suspend */
 
 /* as above, but as bit values */
@@ -92,8 +93,9 @@ static inline struct thread_info *curren
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
+#define _TIF_KERNEL_TRACE	(1<<TIF_KERNEL_TRACE)
 
-#define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
+#define _TIF_WORK_MASK		0x0000FFDE	/* work to do on interrupt/exception return */
 
 #endif /* __KERNEL__ */
 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

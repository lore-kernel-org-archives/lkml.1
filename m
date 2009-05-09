Return-Path: <linux-kernel-owner+w=401wt.eu-S1752947AbZEIQtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbZEIQtA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 12:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbZEIQsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 12:48:52 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:54412 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888AbZEIQsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 12:48:51 -0400
Message-Id: <20090509162348.872445655@polymtl.ca>
References: <20090509162209.217414024@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sat, 09 May 2009 12:22:13 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       fweisbec@gmail.com, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, jiayingz@google.com, roland@redhat.com,
       mbligh@google.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 04/20] LTTng Kernel Trace Thread Flag Blackfin
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-blackfin.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sat,  9 May 2009 16:47:18 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a thread flag to activate system-wide syscall tracing.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/blackfin/include/asm/thread_info.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/arch/blackfin/include/asm/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/arch/blackfin/include/asm/thread_info.h	2009-03-16 19:50:47.000000000 -0400
+++ linux-2.6-lttng/arch/blackfin/include/asm/thread_info.h	2009-03-16 19:55:16.000000000 -0400
@@ -123,6 +123,7 @@ static inline struct thread_info *curren
 #define TIF_RESTORE_SIGMASK	5	/* restore signal mask in do_signal() */
 #define TIF_FREEZE              6       /* is freezing for suspend */
 #define TIF_IRQ_SYNC            7       /* sync pipeline stage */
+#define TIF_KERNEL_TRACE        8       /* kernel trace active */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
@@ -132,8 +133,9 @@ static inline struct thread_info *curren
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_FREEZE             (1<<TIF_FREEZE)
 #define _TIF_IRQ_SYNC           (1<<TIF_IRQ_SYNC)
+#define _TIF_KERNEL_TRACE       (1<<TIF_KERNEL_TRACE)
 
-#define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
+#define _TIF_WORK_MASK		0x0000FEFE	/* work to do on interrupt/exception return */
 
 #endif				/* __KERNEL__ */
 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

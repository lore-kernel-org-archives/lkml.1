Return-Path: <linux-kernel-owner+w=401wt.eu-S1759383AbZCOTdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759383AbZCOTdZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 15:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757886AbZCOTbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 15:31:45 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:56438 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757800AbZCOTbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 15:31:44 -0400
Message-Id: <20090315191102.932389852@polymtl.ca>
References: <20090315190340.229569867@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 15 Mar 2009 15:03:44 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 04/21] LTTng Kernel Trace Thread Flag Blackfin
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-blackfin.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sun, 15 Mar 2009 19:30:27 +0000
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
--- linux-2.6-lttng.orig/arch/blackfin/include/asm/thread_info.h	2009-03-15 14:56:28.000000000 -0400
+++ linux-2.6-lttng/arch/blackfin/include/asm/thread_info.h	2009-03-15 14:57:30.000000000 -0400
@@ -122,6 +122,7 @@ static inline struct thread_info *curren
 #define TIF_MEMDIE              4
 #define TIF_RESTORE_SIGMASK	5	/* restore signal mask in do_signal() */
 #define TIF_FREEZE              6       /* is freezing for suspend */
+#define TIF_KERNEL_TRACE	7	/* kernel trace active */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
@@ -130,8 +131,9 @@ static inline struct thread_info *curren
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_FREEZE             (1<<TIF_FREEZE)
+#define _TIF_KERNEL_TRACE	(1<<TIF_KERNEL_TRACE)
 
-#define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
+#define _TIF_WORK_MASK		0x0000FF7E	/* work to do on interrupt/exception return */
 
 #endif				/* __KERNEL__ */
 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

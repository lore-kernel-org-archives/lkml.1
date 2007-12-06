Return-Path: <linux-kernel-owner+w=401wt.eu-S1757202AbXLFCsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202AbXLFCsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 21:48:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754827AbXLFCoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 21:44:55 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:51359 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754617AbXLFCov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 21:44:51 -0500
Message-Id: <20071206024430.040115138@polymtl.ca>
References: <20071206024243.397994403@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 05 Dec 2007 21:42:47 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch-RFC 04/26] LTTng Kernel Trace Thread Flag Blackfin
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-blackfin.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Dec 2007 02:44:32 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a thread flag to activate system-wide syscall tracing.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/asm-blackfin/thread_info.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/include/asm-blackfin/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-blackfin/thread_info.h	2007-07-30 18:49:43.000000000 -0400
+++ linux-2.6-lttng/include/asm-blackfin/thread_info.h	2007-07-30 19:01:13.000000000 -0400
@@ -125,6 +125,7 @@ static inline struct thread_info *curren
 #define TIF_MEMDIE              4
 #define TIF_RESTORE_SIGMASK	5	/* restore signal mask in do_signal() */
 #define TIF_FREEZE              6       /* is freezing for suspend */
+#define TIF_KERNEL_TRACE	7	/* kernel trace active */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
@@ -133,8 +134,9 @@ static inline struct thread_info *curren
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_FREEZE             (1<<TIF_FREEZE)
+#define _TIF_KERNEL_TRACE	(1<<TIF_KERNEL_TRACE)
 
-#define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
+#define _TIF_WORK_MASK		0x0000FF7E	/* work to do on interrupt/exception return */
 
 #endif				/* __KERNEL__ */
 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

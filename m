Return-Path: <linux-kernel-owner+w=401wt.eu-S1757352AbZKWXSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352AbZKWXSO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 18:18:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757267AbZKWXSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 18:18:13 -0500
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:43387 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757281AbZKWXSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 18:18:10 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak4JACakCkuuWOh5/2dsb2JhbACBTZtFuXyEPASBcA
Date: Mon, 23 Nov 2009 18:18:13 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] avr32 thread flags cleanup
Message-ID: <20091123231813.GA9551@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 18:13:52 up 97 days, 10:03,  4 users,  load average: 0.57, 0.37,
	0.29
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent 2.6.32-rc commits are a bit lazy wrt coding style. Let's clean it
up.

Applies on top of 2.6.32-rc8.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 arch/avr32/include/asm/thread_info.h |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

Index: linux-2.6-lttng/arch/avr32/include/asm/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/arch/avr32/include/asm/thread_info.h	2009-11-22 20:36:57.000000000 -0500
+++ linux-2.6-lttng/arch/avr32/include/asm/thread_info.h	2009-11-22 20:39:16.000000000 -0500
@@ -93,28 +93,31 @@ static inline struct thread_info *curren
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
+#define _TIF_BREAKPOINT		(1 << TIF_BREAKPOINT)
 #define _TIF_SINGLE_STEP	(1 << TIF_SINGLE_STEP)
 #define _TIF_MEMDIE		(1 << TIF_MEMDIE)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
 #define _TIF_CPU_GOING_TO_SLEEP (1 << TIF_CPU_GOING_TO_SLEEP)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 #define _TIF_FREEZE		(1 << TIF_FREEZE)
+#define _TIF_DEBUG		(1 << TIF_DEBUG)
+#define _TIF_USERSPACE		(1 << TIF_USERSPACE)
 
 /* Note: The masks below must never span more than 16 bits! */
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK				\
-	((1 << TIF_SIGPENDING)			\
+	(_TIF_SIGPENDING			\
 	 | _TIF_NOTIFY_RESUME			\
-	 | (1 << TIF_NEED_RESCHED)		\
-	 | (1 << TIF_POLLING_NRFLAG)		\
-	 | (1 << TIF_BREAKPOINT)		\
-	 | (1 << TIF_RESTORE_SIGMASK))
+	 | _TIF_NEED_RESCHED			\
+	 | _TIF_POLLING_NRFLAG			\
+	 | _TIF_BREAKPOINT			\
+	 | _TIF_RESTORE_SIGMASK)
 
 /* work to do on any return to userspace */
-#define _TIF_ALLWORK_MASK	(_TIF_WORK_MASK | (1 << TIF_SYSCALL_TRACE) | \
+#define _TIF_ALLWORK_MASK	(_TIF_WORK_MASK | _TIF_SYSCALL_TRACE | \
 				 _TIF_NOTIFY_RESUME)
 /* work to do on return from debug mode */
-#define _TIF_DBGWORK_MASK	(_TIF_WORK_MASK & ~(1 << TIF_BREAKPOINT))
+#define _TIF_DBGWORK_MASK	(_TIF_WORK_MASK & ~_TIF_BREAKPOINT)
 
 #endif /* __ASM_AVR32_THREAD_INFO_H */

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

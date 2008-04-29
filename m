Return-Path: <linux-kernel-owner+w=401wt.eu-S1757540AbYD2Bx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540AbYD2Bx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 21:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbYD2BxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 21:53:04 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37578 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751314AbYD2BxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 21:53:01 -0400
Message-Id: <20080429015300.620828984@sgi.com>
References: <20080429015231.908196699@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 18:52:34 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: travis@sgi.com, linux-kernel@vger.kernel.org
Subject: [patch 3/9] x86: threadinfo: Merge thread sync state definitions
Content-Disposition: inline; filename=merge_threadinfo
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merge both. x86_64 has an additional TS_COMPAT that is harmless
for 32 bit.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/asm-x86/thread_info.h |   22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

Index: linux-2.6/include/asm-x86/thread_info.h
===================================================================
--- linux-2.6.orig/include/asm-x86/thread_info.h	2008-04-28 17:45:31.632388749 -0700
+++ linux-2.6/include/asm-x86/thread_info.h	2008-04-28 17:47:10.563649517 -0700
@@ -177,21 +177,6 @@ static inline struct thread_info *curren
 #define _TIF_WORK_CTXSW_PREV _TIF_WORK_CTXSW
 #define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW | _TIF_DEBUG)
 
-
-/*
- * Thread-synchronous status.
- *
- * This is different from the flags in that nobody else
- * ever touches our thread-synchronous status, so we don't
- * have to worry about atomic accesses.
- */
-#define TS_USEDFPU		0x0001	/* FPU was used by this task
-					   this quantum (SMP) */
-#define TS_POLLING		0x0002	/* True if in idle loop
-					   and not sleeping */
-
-#define tsk_is_polling(t) (task_thread_info(t)->status & TS_POLLING)
-
 #else /* X86_32 */
 
 #include <asm/pda.h>
@@ -349,6 +334,8 @@ static inline struct thread_info *stack_
 
 #define PREEMPT_ACTIVE     0x10000000
 
+#endif /* !X86_32 */
+
 /*
  * Thread-synchronous status.
  *
@@ -358,15 +345,12 @@ static inline struct thread_info *stack_
  */
 #define TS_USEDFPU		0x0001	/* FPU was used by this task
 					   this quantum (SMP) */
-#define TS_COMPAT		0x0002	/* 32bit syscall active */
+#define TS_COMPAT		0x0002	/* 32bit syscall active (64BIT)*/
 #define TS_POLLING		0x0004	/* true if in idle loop
 					   and not sleeping */
 
 #define tsk_is_polling(t) (task_thread_info(t)->status & TS_POLLING)
 
-#endif /* !X86_32 */
-
-
 #ifndef __ASSEMBLY__
 extern void arch_task_cache_init(void);
 extern void free_thread_info(struct thread_info *ti);

-- 

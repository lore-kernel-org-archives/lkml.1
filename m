Return-Path: <linux-kernel-owner+w=401wt.eu-S1758834AbYD2Byj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834AbYD2Byj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 21:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbYD2BxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 21:53:06 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37582 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752106AbYD2BxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 21:53:01 -0400
Message-Id: <20080429015301.284203318@sgi.com>
References: <20080429015231.908196699@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 18:52:36 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: travis@sgi.com, linux-kernel@vger.kernel.org
Subject: [patch 5/9] x86: threadinfo: Merge INIT_THREAD_INFO
Content-Disposition: inline; filename=init_thread_info
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both definitions are the same. So move to common x86 area.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/asm-x86/thread_info.h |   49 ++++++++++++++----------------------------
 1 file changed, 17 insertions(+), 32 deletions(-)

Index: linux-2.6/include/asm-x86/thread_info.h
===================================================================
--- linux-2.6.orig/include/asm-x86/thread_info.h	2008-04-28 17:47:14.822390659 -0700
+++ linux-2.6/include/asm-x86/thread_info.h	2008-04-28 17:48:36.029891123 -0700
@@ -39,6 +39,23 @@ struct thread_info {
 	__u8			supervisor_stack[0];
 #endif
 };
+
+#define INIT_THREAD_INFO(tsk)			\
+{						\
+	.task		= &tsk,			\
+	.exec_domain	= &default_exec_domain,	\
+	.flags		= 0,			\
+	.cpu		= 0,			\
+	.preempt_count	= 1,			\
+	.addr_limit	= KERNEL_DS,		\
+	.restart_block = {			\
+		.fn = do_no_restart_syscall,	\
+	},					\
+}
+
+#define init_thread_info	(init_thread_union.thread_info)
+#define init_stack		(init_thread_union.stack)
+
 #else /* !__ASSEMBLY__ */
 
 #include <asm/asm-offsets.h>
@@ -62,22 +79,6 @@ struct thread_info {
  */
 #ifndef __ASSEMBLY__
 
-#define INIT_THREAD_INFO(tsk)			\
-{						\
-	.task		= &tsk,			\
-	.exec_domain	= &default_exec_domain,	\
-	.flags		= 0,			\
-	.cpu		= 0,			\
-	.preempt_count	= 1,			\
-	.addr_limit	= KERNEL_DS,		\
-	.restart_block = {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
-}
-
-#define init_thread_info	(init_thread_union.thread_info)
-#define init_stack		(init_thread_union.stack)
-
 
 /* how to get the current stack pointer from C */
 register unsigned long current_stack_pointer asm("esp") __used;
@@ -181,22 +182,6 @@ static inline struct thread_info *curren
  * preempt_count needs to be 1 initially, until the scheduler is functional.
  */
 #ifndef __ASSEMBLY__
-#define INIT_THREAD_INFO(tsk)			\
-{						\
-	.task	       = &tsk,			\
-	.exec_domain   = &default_exec_domain,	\
-	.flags	       = 0,			\
-	.cpu	       = 0,			\
-	.preempt_count = 1,			\
-	.addr_limit     = KERNEL_DS,		\
-	.restart_block = {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
-}
-
-#define init_thread_info	(init_thread_union.thread_info)
-#define init_stack		(init_thread_union.stack)
-
 static inline struct thread_info *current_thread_info(void)
 {
 	struct thread_info *ti;

-- 

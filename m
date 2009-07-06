Return-Path: <linux-kernel-owner+w=401wt.eu-S1754292AbZGFLdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbZGFLdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 07:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbZGFLdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 07:33:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:44973 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbZGFLdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 07:33:05 -0400
Subject: [PATCH -tip] x86: thread_info.h moving comment to where it should
 be
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Christoph Lameter <cl@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 06 Jul 2009 17:02:05 +0530
Message-Id: <1246879925.28541.3.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


By mistake commit 2052e8d40ad58 moved following comment to wrong place,
where it does not make any sense :

 "preempt_count needs to be 1 initially, until the scheduler is functional."

Moving comment back to right place where preempt_count is setting to 1

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/thread_info.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index b078352..2dda0f8 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -43,6 +43,9 @@ struct thread_info {
 	int			uaccess_err;
 };
 
+/*
+ * preempt_count needs to be 1 initially, until the scheduler is functional.
+ */
 #define INIT_THREAD_INFO(tsk)			\
 {						\
 	.task		= &tsk,			\
@@ -167,14 +170,12 @@ struct thread_info {
 #ifdef CONFIG_X86_32
 
 #define STACK_WARN	(THREAD_SIZE/8)
+
 /*
  * macros/functions for gaining access to the thread information structure
- *
- * preempt_count needs to be 1 initially, until the scheduler is functional.
  */
 #ifndef __ASSEMBLY__
 
-
 /* how to get the current stack pointer from C */
 register unsigned long current_stack_pointer asm("esp") __used;
 
@@ -205,7 +206,6 @@ static inline struct thread_info *current_thread_info(void)
 
 /*
  * macros/functions for gaining access to the thread information structure
- * preempt_count needs to be 1 initially, until the scheduler is functional.
  */
 #ifndef __ASSEMBLY__
 DECLARE_PER_CPU(unsigned long, kernel_stack);
-- 
1.6.0.6




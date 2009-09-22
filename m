Return-Path: <linux-kernel-owner+w=401wt.eu-S1756691AbZIVOXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbZIVOXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 10:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755833AbZIVOX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 10:23:29 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:56510 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756669AbZIVOX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 10:23:27 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Tim Abbott <tabbott@ksplice.com>,
       Hirokazu Takata <takata@linux-m32r.org>
Subject: [PATCH 03/13] m32r: Define THREAD_SIZE only once.
Date: Tue, 22 Sep 2009 10:22:17 -0400
Message-Id: <1253629347-23119-4-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253629347-23119-1-git-send-email-tabbott@ksplice.com>
References: <1253629347-23119-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, m32r's asm/thread_info.h defined THREAD_SIZE differently
for assembly and C code; now that PAGE_SIZE is usable from assembly,
these can be combined.  Also, m32r's asm/processor.h redefines
THREAD_SIZE to the same value; remove this redundant definition.

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/m32r/include/asm/processor.h   |    2 --
 arch/m32r/include/asm/thread_info.h |    6 ++----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/m32r/include/asm/processor.h b/arch/m32r/include/asm/processor.h
index 1a997fc..8397c24 100644
--- a/arch/m32r/include/asm/processor.h
+++ b/arch/m32r/include/asm/processor.h
@@ -140,8 +140,6 @@ unsigned long get_wchan(struct task_struct *p);
 #define KSTK_EIP(tsk)  ((tsk)->thread.lr)
 #define KSTK_ESP(tsk)  ((tsk)->thread.sp)
 
-#define THREAD_SIZE (2*PAGE_SIZE)
-
 #define cpu_relax()	barrier()
 
 #endif /* _ASM_M32R_PROCESSOR_H */
diff --git a/arch/m32r/include/asm/thread_info.h b/arch/m32r/include/asm/thread_info.h
index 7157815..4d66169 100644
--- a/arch/m32r/include/asm/thread_info.h
+++ b/arch/m32r/include/asm/thread_info.h
@@ -55,6 +55,8 @@ struct thread_info {
 
 #define PREEMPT_ACTIVE		0x10000000
 
+#define THREAD_SIZE (PAGE_SIZE << 1)
+
 /*
  * macros/functions for gaining access to the thread information structure
  */
@@ -76,8 +78,6 @@ struct thread_info {
 #define init_thread_info	(init_thread_union.thread_info)
 #define init_stack		(init_thread_union.stack)
 
-#define THREAD_SIZE (2*PAGE_SIZE)
-
 /* how to get the thread information struct from C */
 static inline struct thread_info *current_thread_info(void)
 {
@@ -127,8 +127,6 @@ static inline unsigned int get_thread_fault_code(void)
 
 #else /* !__ASSEMBLY__ */
 
-#define THREAD_SIZE	8192
-
 /* how to get the thread information struct from ASM */
 #define GET_THREAD_INFO(reg)	GET_THREAD_INFO reg
 	.macro GET_THREAD_INFO reg
-- 
1.6.3.3


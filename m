Return-Path: <linux-kernel-owner+w=401wt.eu-S1758614AbZIRUfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614AbZIRUfj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 16:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbZIRUfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 16:35:34 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:63056 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758608AbZIRUf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 16:35:29 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Hirokazu Takata <takata@linux-m32r.org>
Cc: linux-m32r@ml.linux-m32r.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@ksplice.com>,
       Hirokazu Takata <takata@linux-m32r.org>
Subject: [PATCH v2 2/6] m32r: Define THREAD_SIZE only once.
Date: Fri, 18 Sep 2009 16:32:45 -0400
Message-Id: <1253305969-6948-3-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253305969-6948-1-git-send-email-tabbott@ksplice.com>
References: <1253305969-6948-1-git-send-email-tabbott@ksplice.com>
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


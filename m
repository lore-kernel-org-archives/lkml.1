Return-Path: <linux-kernel-owner+w=401wt.eu-S1758187AbZIRUdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187AbZIRUdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 16:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbZIRUdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 16:33:13 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:62002 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750786AbZIRUdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 16:33:12 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Hirokazu Takata <takata@linux-m32r.org>
Cc: linux-m32r@ml.linux-m32r.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@ksplice.com>,
       Hirokazu Takata <takata@linux-m32r.org>
Subject: [PATCH v2 3/6] m32r: Move GET_THREAD_INFO definition out of asm/thread_info.h.
Date: Fri, 18 Sep 2009 16:32:46 -0400
Message-Id: <1253305969-6948-4-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253305969-6948-1-git-send-email-tabbott@ksplice.com>
References: <1253305969-6948-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, asm/thread_info.h was not usable from linker scripts
because it contains a piece of .macro code.  Since that code was only
used in the m32r entry.S, the right fix is probably to move the macro
there.

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
---
 arch/m32r/include/asm/thread_info.h |    9 ---------
 arch/m32r/kernel/entry.S            |    7 +++++++
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/m32r/include/asm/thread_info.h b/arch/m32r/include/asm/thread_info.h
index 4d66169..ed240b6 100644
--- a/arch/m32r/include/asm/thread_info.h
+++ b/arch/m32r/include/asm/thread_info.h
@@ -125,15 +125,6 @@ static inline unsigned int get_thread_fault_code(void)
 	return ti->flags >> TI_FLAG_FAULT_CODE_SHIFT;
 }
 
-#else /* !__ASSEMBLY__ */
-
-/* how to get the thread information struct from ASM */
-#define GET_THREAD_INFO(reg)	GET_THREAD_INFO reg
-	.macro GET_THREAD_INFO reg
-	ldi	\reg, #-THREAD_SIZE
-	and	\reg, sp
-	.endm
-
 #endif
 
 /*
diff --git a/arch/m32r/kernel/entry.S b/arch/m32r/kernel/entry.S
index 612d35b..4038698 100644
--- a/arch/m32r/kernel/entry.S
+++ b/arch/m32r/kernel/entry.S
@@ -118,6 +118,13 @@
 #define resume_kernel		restore_all
 #endif
 
+/* how to get the thread information struct from ASM */
+#define GET_THREAD_INFO(reg)	GET_THREAD_INFO reg
+	.macro GET_THREAD_INFO reg
+	ldi	\reg, #-THREAD_SIZE
+	and	\reg, sp
+	.endm
+
 ENTRY(ret_from_fork)
 	pop	r0
 	bl	schedule_tail
-- 
1.6.3.3


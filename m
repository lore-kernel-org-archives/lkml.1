Return-Path: <linux-kernel-owner+w=401wt.eu-S1760771AbYCWIRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760771AbYCWIRv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756538AbYCWIIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:08:41 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2255 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759203AbYCWIIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:08:36 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 055/148] include/asm-x86/irqflags.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:30 -0700
Message-Id: <1206259443-13210-56-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/irqflags.h |   30 +++++++++++++-----------------
 1 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/include/asm-x86/irqflags.h b/include/asm-x86/irqflags.h
index 92021c1..c242527 100644
--- a/include/asm-x86/irqflags.h
+++ b/include/asm-x86/irqflags.h
@@ -12,25 +12,21 @@ static inline unsigned long native_save_fl(void)
 {
 	unsigned long flags;
 
-	__asm__ __volatile__(
-		"# __raw_save_flags\n\t"
-		"pushf ; pop %0"
-		: "=g" (flags)
-		: /* no input */
-		: "memory"
-	);
+	asm volatile("# __raw_save_flags\n\t"
+		     "pushf ; pop %0"
+		     : "=g" (flags)
+		     : /* no input */
+		     : "memory");
 
 	return flags;
 }
 
 static inline void native_restore_fl(unsigned long flags)
 {
-	__asm__ __volatile__(
-		"push %0 ; popf"
-		: /* no output */
-		:"g" (flags)
-		:"memory", "cc"
-	);
+	asm volatile("push %0 ; popf"
+		     : /* no output */
+		     :"g" (flags)
+		     :"memory", "cc");
 }
 
 static inline void native_irq_disable(void)
@@ -131,11 +127,11 @@ static inline unsigned long __raw_local_irq_save(void)
 #endif /* CONFIG_PARAVIRT */
 
 #ifndef __ASSEMBLY__
-#define raw_local_save_flags(flags) \
-		do { (flags) = __raw_local_save_flags(); } while (0)
+#define raw_local_save_flags(flags)				\
+	do { (flags) = __raw_local_save_flags(); } while (0)
 
-#define raw_local_irq_save(flags) \
-		do { (flags) = __raw_local_irq_save(); } while (0)
+#define raw_local_irq_save(flags)				\
+	do { (flags) = __raw_local_irq_save(); } while (0)
 
 static inline int raw_irqs_disabled_flags(unsigned long flags)
 {
-- 
1.5.4.rc2


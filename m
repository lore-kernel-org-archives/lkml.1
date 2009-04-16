Return-Path: <linux-kernel-owner+w=401wt.eu-S1756743AbZDPKC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743AbZDPKC3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 06:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755892AbZDPKBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 06:01:36 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:54383 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755456AbZDPKBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 06:01:35 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: microblaze-uclinux@itee.uq.edu.au, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 04/11] microblaze: Rename kernel_mode to pt_mode in pt_regs
Date: Thu, 16 Apr 2009 11:56:31 +0200
Message-Id: <708dba6c793117ed9ee1036cae48ed9288d328b8.1239874968.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <f62690af2276b3fb111af2adae91e65ba1587c11.1239874968.git.monstr@monstr.eu>
References: <1239875798-10523-1-git-send-email-monstr@monstr.eu>
 <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>
 <11ed83a6ecbedc74fc543dad9cb81157ce5771ee.1239874968.git.monstr@monstr.eu>
 <f62690af2276b3fb111af2adae91e65ba1587c11.1239874968.git.monstr@monstr.eu>
In-Reply-To: <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>
References: <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/processor.h |    2 +-
 arch/microblaze/include/asm/ptrace.h    |    4 ++--
 arch/microblaze/kernel/asm-offsets.c    |    2 +-
 arch/microblaze/kernel/process.c        |    4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/microblaze/include/asm/processor.h b/arch/microblaze/include/asm/processor.h
index d8e1543..4bed76d 100644
--- a/arch/microblaze/include/asm/processor.h
+++ b/arch/microblaze/include/asm/processor.h
@@ -62,7 +62,7 @@ static inline void start_thread(struct pt_regs *regs,
 {
 	regs->pc = pc;
 	regs->r1 = usp;
-	regs->kernel_mode = 0;
+	regs->pt_mode = 0;
 }
 
 /* Free all resources held by a thread. */
diff --git a/arch/microblaze/include/asm/ptrace.h b/arch/microblaze/include/asm/ptrace.h
index f1f0348..55015bc 100644
--- a/arch/microblaze/include/asm/ptrace.h
+++ b/arch/microblaze/include/asm/ptrace.h
@@ -52,10 +52,10 @@ struct pt_regs {
 	microblaze_reg_t ear;
 	microblaze_reg_t esr;
 	microblaze_reg_t fsr;
-	int kernel_mode;
+	int pt_mode;
 };
 
-#define kernel_mode(regs)		((regs)->kernel_mode)
+#define kernel_mode(regs)		((regs)->pt_mode)
 #define user_mode(regs)			(!kernel_mode(regs))
 
 #define instruction_pointer(regs)	((regs)->pc)
diff --git a/arch/microblaze/kernel/asm-offsets.c b/arch/microblaze/kernel/asm-offsets.c
index 38e1a2e..aabd9e9 100644
--- a/arch/microblaze/kernel/asm-offsets.c
+++ b/arch/microblaze/kernel/asm-offsets.c
@@ -57,7 +57,7 @@ int main(int argc, char *argv[])
 	DEFINE(PT_R29, offsetof(struct pt_regs, r29));
 	DEFINE(PT_R30, offsetof(struct pt_regs, r30));
 	DEFINE(PT_R31, offsetof(struct pt_regs, r31));
-	DEFINE(PT_MODE, offsetof(struct pt_regs, kernel_mode));
+	DEFINE(PT_MODE, offsetof(struct pt_regs, pt_mode));
 	BLANK();
 
 	/* Magic offsets for PTRACE PEEK/POKE etc */
diff --git a/arch/microblaze/kernel/process.c b/arch/microblaze/kernel/process.c
index bdc8b2c..40cc148 100644
--- a/arch/microblaze/kernel/process.c
+++ b/arch/microblaze/kernel/process.c
@@ -18,7 +18,7 @@
 
 void show_regs(struct pt_regs *regs)
 {
-	printk(KERN_INFO " Registers dump: mode=%X\r\n", regs->kernel_mode);
+	printk(KERN_INFO " Registers dump: mode=%X\r\n", regs->pt_mode);
 	printk(KERN_INFO " r1=%08lX, r2=%08lX, r3=%08lX, r4=%08lX\n",
 				regs->r1, regs->r2, regs->r3, regs->r4);
 	printk(KERN_INFO " r5=%08lX, r6=%08lX, r7=%08lX, r8=%08lX\n",
@@ -169,7 +169,7 @@ int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
 	regs.r6 = (unsigned long)arg;
 	local_save_flags(regs.msr);
 	regs.pc = (unsigned long)kernel_thread_helper;
-	regs.kernel_mode = 1;
+	regs.pt_mode = 1;
 
 	ret = do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0,
 			&regs, 0, NULL, NULL);
-- 
1.5.5.1


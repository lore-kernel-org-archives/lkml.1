Return-Path: <linux-kernel-owner+w=401wt.eu-S1757819AbZDPKFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819AbZDPKFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 06:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755873AbZDPKEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 06:04:50 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:57957 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753782AbZDPKEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 06:04:48 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: microblaze-uclinux@itee.uq.edu.au, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 09/11] microblaze: Move start_thread to process.c
Date: Thu, 16 Apr 2009 11:56:36 +0200
Message-Id: <74602b0d6e166c6a657f3d9b7f6c3890b0783326.1239874968.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <a3f7086da43a5d4f994344a07a75568f679095d6.1239874968.git.monstr@monstr.eu>
References: <1239875798-10523-1-git-send-email-monstr@monstr.eu>
 <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>
 <11ed83a6ecbedc74fc543dad9cb81157ce5771ee.1239874968.git.monstr@monstr.eu>
 <f62690af2276b3fb111af2adae91e65ba1587c11.1239874968.git.monstr@monstr.eu>
 <708dba6c793117ed9ee1036cae48ed9288d328b8.1239874968.git.monstr@monstr.eu>
 <1f1874e0192d8481356551ffbeeebcecce951afc.1239874968.git.monstr@monstr.eu>
 <157375351273eacf9b552e677447505542f90521.1239874968.git.monstr@monstr.eu>
 <f87119e246276eb41047985c97b74a5b79adc259.1239874968.git.monstr@monstr.eu>
 <a3f7086da43a5d4f994344a07a75568f679095d6.1239874968.git.monstr@monstr.eu>
In-Reply-To: <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>
References: <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

This change is due to upcomming MMU merge

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/processor.h |   13 +++----------
 arch/microblaze/kernel/process.c        |    9 +++++++++
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/microblaze/include/asm/processor.h b/arch/microblaze/include/asm/processor.h
index cea42a3..89aa395 100644
--- a/arch/microblaze/include/asm/processor.h
+++ b/arch/microblaze/include/asm/processor.h
@@ -29,6 +29,9 @@ extern const struct seq_operations cpuinfo_op;
 #define task_pt_regs(tsk) \
 		(((struct pt_regs *)(THREAD_SIZE + task_stack_page(tsk))) - 1)
 
+/* Do necessary setup to start up a newly executed thread. */
+void start_thread(struct pt_regs *regs, unsigned long pc, unsigned long usp);
+
 /*
  * User space process size: memory size
  *
@@ -58,16 +61,6 @@ struct task_struct;
 struct thread_struct { };
 # define INIT_THREAD	{ }
 
-/* Do necessary setup to start up a newly executed thread. */
-static inline void start_thread(struct pt_regs *regs,
-				unsigned long pc,
-				unsigned long usp)
-{
-	regs->pc = pc;
-	regs->r1 = usp;
-	regs->pt_mode = 0;
-}
-
 /* Free all resources held by a thread. */
 static inline void release_thread(struct task_struct *dead_task)
 {
diff --git a/arch/microblaze/kernel/process.c b/arch/microblaze/kernel/process.c
index 40cc148..dd15de9 100644
--- a/arch/microblaze/kernel/process.c
+++ b/arch/microblaze/kernel/process.c
@@ -182,3 +182,12 @@ unsigned long get_wchan(struct task_struct *p)
 /* TBD (used by procfs) */
 	return 0;
 }
+
+/* Set up a thread for executing a new program */
+void start_thread(struct pt_regs *regs, unsigned long pc, unsigned long usp)
+{
+	set_fs(USER_DS);
+	regs->pc = pc;
+	regs->r1 = usp;
+	regs->pt_mode = 0;
+}
-- 
1.5.5.1


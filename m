Return-Path: <linux-kernel-owner+w=401wt.eu-S1757505AbZDPKD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505AbZDPKD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 06:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755657AbZDPKDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 06:03:46 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:54409 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754691AbZDPKDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 06:03:45 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: microblaze-uclinux@itee.uq.edu.au, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 05/11] microblaze: Move task_pt_regs up
Date: Thu, 16 Apr 2009 11:56:32 +0200
Message-Id: <1f1874e0192d8481356551ffbeeebcecce951afc.1239874968.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <708dba6c793117ed9ee1036cae48ed9288d328b8.1239874968.git.monstr@monstr.eu>
References: <1239875798-10523-1-git-send-email-monstr@monstr.eu>
 <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>
 <11ed83a6ecbedc74fc543dad9cb81157ce5771ee.1239874968.git.monstr@monstr.eu>
 <f62690af2276b3fb111af2adae91e65ba1587c11.1239874968.git.monstr@monstr.eu>
 <708dba6c793117ed9ee1036cae48ed9288d328b8.1239874968.git.monstr@monstr.eu>
In-Reply-To: <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>
References: <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

This change is important for easier merge with Microblaze MMU code.

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/processor.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/microblaze/include/asm/processor.h b/arch/microblaze/include/asm/processor.h
index 4bed76d..cea42a3 100644
--- a/arch/microblaze/include/asm/processor.h
+++ b/arch/microblaze/include/asm/processor.h
@@ -26,6 +26,9 @@ extern const struct seq_operations cpuinfo_op;
 
 # endif /* __ASSEMBLY__ */
 
+#define task_pt_regs(tsk) \
+		(((struct pt_regs *)(THREAD_SIZE + task_stack_page(tsk))) - 1)
+
 /*
  * User space process size: memory size
  *
@@ -84,9 +87,6 @@ extern unsigned long get_wchan(struct task_struct *p);
  */
 extern int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
 
-# define task_pt_regs(tsk) \
-		(((struct pt_regs *)(THREAD_SIZE + task_stack_page(tsk))) - 1)
-
 # define KSTK_EIP(tsk)	(0)
 # define KSTK_ESP(tsk)	(0)
 
-- 
1.5.5.1


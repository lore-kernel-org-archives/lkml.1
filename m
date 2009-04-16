Return-Path: <linux-kernel-owner+w=401wt.eu-S1756951AbZDPKCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951AbZDPKCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 06:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756524AbZDPKCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 06:02:08 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:54392 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756402AbZDPKCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 06:02:07 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: microblaze-uclinux@itee.uq.edu.au, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 10/11] microblaze: Remove redundant variable
Date: Thu, 16 Apr 2009 11:56:37 +0200
Message-Id: <c92f8e48fb760c385438885b4a2c79c50a213f3b.1239874968.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <74602b0d6e166c6a657f3d9b7f6c3890b0783326.1239874968.git.monstr@monstr.eu>
References: <1239875798-10523-1-git-send-email-monstr@monstr.eu>
 <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>
 <11ed83a6ecbedc74fc543dad9cb81157ce5771ee.1239874968.git.monstr@monstr.eu>
 <f62690af2276b3fb111af2adae91e65ba1587c11.1239874968.git.monstr@monstr.eu>
 <708dba6c793117ed9ee1036cae48ed9288d328b8.1239874968.git.monstr@monstr.eu>
 <1f1874e0192d8481356551ffbeeebcecce951afc.1239874968.git.monstr@monstr.eu>
 <157375351273eacf9b552e677447505542f90521.1239874968.git.monstr@monstr.eu>
 <f87119e246276eb41047985c97b74a5b79adc259.1239874968.git.monstr@monstr.eu>
 <a3f7086da43a5d4f994344a07a75568f679095d6.1239874968.git.monstr@monstr.eu>
 <74602b0d6e166c6a657f3d9b7f6c3890b0783326.1239874968.git.monstr@monstr.eu>
In-Reply-To: <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>
References: <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/process.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/microblaze/kernel/process.c b/arch/microblaze/kernel/process.c
index dd15de9..07d4fa3 100644
--- a/arch/microblaze/kernel/process.c
+++ b/arch/microblaze/kernel/process.c
@@ -161,7 +161,6 @@ static void kernel_thread_helper(int (*fn)(void *), void *arg)
 int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
 {
 	struct pt_regs regs;
-	int ret;
 
 	memset(&regs, 0, sizeof(regs));
 	/* store them in non-volatile registers */
@@ -171,10 +170,8 @@ int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
 	regs.pc = (unsigned long)kernel_thread_helper;
 	regs.pt_mode = 1;
 
-	ret = do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0,
+	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0,
 			&regs, 0, NULL, NULL);
-
-	return ret;
 }
 
 unsigned long get_wchan(struct task_struct *p)
-- 
1.5.5.1


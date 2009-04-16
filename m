Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbZDPKBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbZDPKBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 06:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbZDPKA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 06:00:58 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:54381 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752898AbZDPKA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 06:00:57 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: microblaze-uclinux@itee.uq.edu.au, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 02/11] microblaze: Remove while(1) loop from show_regs function
Date: Thu, 16 Apr 2009 11:56:29 +0200
Message-Id: <11ed83a6ecbedc74fc543dad9cb81157ce5771ee.1239874968.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>
References: <1239875798-10523-1-git-send-email-monstr@monstr.eu>
 <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>
In-Reply-To: <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>
References: <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

I removed it because of show_regs can't break die function.
If process/kernel failed, die (do_exit) function resolve it.

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/process.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/microblaze/kernel/process.c b/arch/microblaze/kernel/process.c
index 436f26c..bdc8b2c 100644
--- a/arch/microblaze/kernel/process.c
+++ b/arch/microblaze/kernel/process.c
@@ -37,8 +37,6 @@ void show_regs(struct pt_regs *regs)
 				regs->r29, regs->r30, regs->r31, regs->pc);
 	printk(KERN_INFO " msr=%08lX, ear=%08lX, esr=%08lX, fsr=%08lX\n",
 				regs->msr, regs->ear, regs->esr, regs->fsr);
-	while (1)
-		;
 }
 
 void (*pm_idle)(void);
-- 
1.5.5.1


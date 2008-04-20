Return-Path: <linux-kernel-owner+w=401wt.eu-S1762945AbYDTCzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762945AbYDTCzX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 22:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbYDTCyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 22:54:39 -0400
Received: from smtp01.mtu.ru ([62.5.255.48]:62085 "EHLO smtp01.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbYDTCyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 22:54:37 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] x86: remove unused code and data in nexgen.c
Date: Sun, 20 Apr 2008 06:54:32 +0400
Message-Id: <1208660074-7324-3-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1208660074-7324-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1208660074-7324-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp01.mtu.ru 10002; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nobody calls the function nexgen_init_cpu(), therefore it
can be removed. The variable nexgen_cpu_dev is used only by
this function, so this patch removes useless data as well.

This patch was build-tested using defconfigs for i386 and x86_64.
It also survived a few randconfig instances for i386. Runtime
tests were performed by booting 32-bit and 64-bit x86 boxen up to
the shell prompt.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 arch/x86/kernel/cpu/nexgen.c |   19 -------------------
 1 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/cpu/nexgen.c b/arch/x86/kernel/cpu/nexgen.c
index 5d5e1c1..f5753b4 100644
--- a/arch/x86/kernel/cpu/nexgen.c
+++ b/arch/x86/kernel/cpu/nexgen.c
@@ -38,22 +38,3 @@ static void __cpuinit nexgen_identify(struct cpuinfo_x86 *c)
 	if (deep_magic_nexgen_probe())
 		strcpy(c->x86_vendor_id, "NexGenDriven");
 }
-
-static struct cpu_dev nexgen_cpu_dev __cpuinitdata = {
-	.c_vendor	= "Nexgen",
-	.c_ident	= { "NexGenDriven" },
-	.c_models = {
-			{ .vendor = X86_VENDOR_NEXGEN,
-			  .family = 5,
-			  .model_names = { [1] = "Nx586" }
-			},
-	},
-	.c_init		= init_nexgen,
-	.c_identify	= nexgen_identify,
-};
-
-int __init nexgen_init_cpu(void)
-{
-	cpu_devs[X86_VENDOR_NEXGEN] = &nexgen_cpu_dev;
-	return 0;
-}
-- 
1.5.3


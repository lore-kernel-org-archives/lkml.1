Return-Path: <linux-kernel-owner+w=401wt.eu-S1760609AbZDGRjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760609AbZDGRjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 13:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758222AbZDGRjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 13:39:09 -0400
Received: from smtp-68.nebula.fi ([83.145.220.68]:47587 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757703AbZDGRjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 13:39:08 -0400
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: ming@elte.hu
Cc: penberg@cs.helsinki.fi, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 13/13] x86: remove some ifdefs from native_init_IRQ()
Date: Tue,  7 Apr 2009 16:48:40 +0300
Message-Id: <1239112120-676-13-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1239112120-676-1-git-send-email-penberg@cs.helsinki.fi>
References: <1239112120-676-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/kernel/irqinit.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index f2c60a5..6269772 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -205,7 +205,6 @@ static void __init apic_intr_init(void)
 #endif
 }
 
-#ifdef CONFIG_X86_32
 /**
  * x86_quirk_pre_intr_init - initialisation prior to setting up interrupt vectors
  *
@@ -217,24 +216,21 @@ static void __init apic_intr_init(void)
  **/
 static void __init x86_quirk_pre_intr_init(void)
 {
+#ifdef CONFIG_X86_32
 	if (x86_quirks->arch_pre_intr_init) {
 		if (x86_quirks->arch_pre_intr_init())
 			return;
 	}
+#endif
 	init_ISA_irqs();
 }
-#endif
 
 void __init native_init_IRQ(void)
 {
 	int i;
 
-#ifdef CONFIG_X86_32
 	/* Execute any quirks before the call gates are initialised: */
 	x86_quirk_pre_intr_init();
-#else
-	init_ISA_irqs();
-#endif
 
 	/*
 	 * Cover the whole vector space, no vector can escape
-- 
1.5.6.3


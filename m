Return-Path: <linux-kernel-owner+w=401wt.eu-S1760367AbZDGS4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760367AbZDGS4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 14:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753838AbZDGS4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 14:56:08 -0400
Received: from smtp-68.nebula.fi ([83.145.220.68]:43521 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbZDGS4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 14:56:06 -0400
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: ming@elte.hu
Cc: penberg@cs.helsinki.fi, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 02/13] x86: move init_ISA_irqs() in irqinit_32.c to match ordering in irqinit_64.c
Date: Tue,  7 Apr 2009 16:48:29 +0300
Message-Id: <1239112120-676-2-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1239112120-676-1-git-send-email-penberg@cs.helsinki.fi>
References: <1239112120-676-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/kernel/irqinit_32.c |   48 +++++++++++++++++++++---------------------
 1 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
index 0c0dedc..c5cb769 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -53,30 +53,6 @@ static struct irqaction fpu_irq = {
 	.name = "fpu",
 };
 
-static void __init init_ISA_irqs(void)
-{
-	int i;
-
-#ifdef CONFIG_X86_LOCAL_APIC
-	init_bsp_APIC();
-#endif
-	init_8259A(0);
-
-	/*
-	 * 16 old-style INTA-cycle interrupts:
-	 */
-	for (i = 0; i < NR_IRQS_LEGACY; i++) {
-		struct irq_desc *desc = irq_to_desc(i);
-
-		desc->status = IRQ_DISABLED;
-		desc->action = NULL;
-		desc->depth = 1;
-
-		set_irq_chip_and_handler_name(i, &i8259A_chip,
-					      handle_level_irq, "XT");
-	}
-}
-
 /*
  * IRQ2 is cascade interrupt to second interrupt controller
  */
@@ -118,6 +94,30 @@ int vector_used_by_percpu_irq(unsigned int vector)
 	return 0;
 }
 
+static void __init init_ISA_irqs(void)
+{
+	int i;
+
+#ifdef CONFIG_X86_LOCAL_APIC
+	init_bsp_APIC();
+#endif
+	init_8259A(0);
+
+	/*
+	 * 16 old-style INTA-cycle interrupts:
+	 */
+	for (i = 0; i < NR_IRQS_LEGACY; i++) {
+		struct irq_desc *desc = irq_to_desc(i);
+
+		desc->status = IRQ_DISABLED;
+		desc->action = NULL;
+		desc->depth = 1;
+
+		set_irq_chip_and_handler_name(i, &i8259A_chip,
+					      handle_level_irq, "XT");
+	}
+}
+
 /* Overridden in paravirt.c */
 void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
 
-- 
1.5.6.3


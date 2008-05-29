Return-Path: <linux-kernel-owner+w=401wt.eu-S1757798AbYE2PQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798AbYE2PQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 11:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754042AbYE2PQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 11:16:15 -0400
Received: from smtp.movial.fi ([62.236.91.34]:35037 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754146AbYE2PQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 11:16:14 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] [MIPS] remove unused function alloc_legacy_irqno()
Date: Thu, 29 May 2008 17:57:10 +0300
Message-Id: <12120730322842-git-send-email-dmitri.vorobiev@movial.fi>
X-Mailer: git-send-email 1.4.4.3
In-Reply-To: <12120730323761-git-send-email-dmitri.vorobiev@movial.fi>
References: <12120730323761-git-send-email-dmitri.vorobiev@movial.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function alloc_legacy_irqno() is not used any more, and this
patch removes it.

Inspired by a namespacecheck warning.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
---
 arch/mips/kernel/irq.c |   13 -------------
 include/asm-mips/irq.h |    1 -
 2 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/arch/mips/kernel/irq.c b/arch/mips/kernel/irq.c
index e3309ff..ba4e331 100644
--- a/arch/mips/kernel/irq.c
+++ b/arch/mips/kernel/irq.c
@@ -46,19 +46,6 @@ again:
 
 EXPORT_SYMBOL_GPL(allocate_irqno);
 
-/*
- * Allocate the 16 legacy interrupts for i8259 devices.  This happens early
- * in the kernel initialization so treating allocation failure as BUG() is
- * ok.
- */
-void __init alloc_legacy_irqno(void)
-{
-	int i;
-
-	for (i = 0; i <= 16; i++)
-		BUG_ON(test_and_set_bit(i, irq_map));
-}
-
 void free_irqno(unsigned int irq)
 {
 	smp_mb__before_clear_bit();
diff --git a/include/asm-mips/irq.h b/include/asm-mips/irq.h
index a58f0ee..08e0700 100644
--- a/include/asm-mips/irq.h
+++ b/include/asm-mips/irq.h
@@ -148,7 +148,6 @@ extern void arch_init_irq(void);
 extern void spurious_interrupt(void);
 
 extern int allocate_irqno(void);
-extern void alloc_legacy_irqno(void);
 extern void free_irqno(unsigned int irq);
 
 /*
-- 
1.4.4.3


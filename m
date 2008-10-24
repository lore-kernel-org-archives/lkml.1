Return-Path: <linux-kernel-owner+w=401wt.eu-S1757935AbYJXXKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935AbYJXXKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 19:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803AbYJXXJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 19:09:59 -0400
Received: from smtp.movial.fi ([62.236.91.34]:45360 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757406AbYJXXJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 19:09:56 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [MIPS] IP22: Small cleanups
Date: Sat, 25 Oct 2008 01:46:56 +0300
Message-Id: <1224888417-26494-1-git-send-email-dmitri.vorobiev@movial.fi>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following functions

disable_local1_irq()
disable_local2_irq()
disable_local3_irq()

are needlessly defined global, so make them static. While at
it, fix a couple of coding style errors in the same file.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
---
 arch/mips/sgi-ip22/ip22-int.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/mips/sgi-ip22/ip22-int.c b/arch/mips/sgi-ip22/ip22-int.c
index f6d9bf4..5b9b4f3 100644
--- a/arch/mips/sgi-ip22/ip22-int.c
+++ b/arch/mips/sgi-ip22/ip22-int.c
@@ -16,6 +16,7 @@
 #include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
+#include <linux/time.h>
 
 #include <asm/mipsregs.h>
 #include <asm/addrspace.h>
@@ -23,7 +24,6 @@
 #include <asm/sgi/ioc.h>
 #include <asm/sgi/hpc3.h>
 #include <asm/sgi/ip22.h>
-#include <asm/time.h>
 
 /* #define DEBUG_SGINT */
 
@@ -68,7 +68,7 @@ static void enable_local1_irq(unsigned int irq)
 		sgint->imask1 |= (1 << (irq - SGINT_LOCAL1));
 }
 
-void disable_local1_irq(unsigned int irq)
+static void disable_local1_irq(unsigned int irq)
 {
 	sgint->imask1 &= ~(1 << (irq - SGINT_LOCAL1));
 }
@@ -87,7 +87,7 @@ static void enable_local2_irq(unsigned int irq)
 	sgint->cmeimask0 |= (1 << (irq - SGINT_LOCAL2));
 }
 
-void disable_local2_irq(unsigned int irq)
+static void disable_local2_irq(unsigned int irq)
 {
 	sgint->cmeimask0 &= ~(1 << (irq - SGINT_LOCAL2));
 	if (!sgint->cmeimask0)
@@ -108,7 +108,7 @@ static void enable_local3_irq(unsigned int irq)
 	sgint->cmeimask1 |= (1 << (irq - SGINT_LOCAL3));
 }
 
-void disable_local3_irq(unsigned int irq)
+static void disable_local3_irq(unsigned int irq)
 {
 	sgint->cmeimask1 &= ~(1 << (irq - SGINT_LOCAL3));
 	if (!sgint->cmeimask1)
@@ -344,6 +344,6 @@ void __init arch_init_irq(void)
 
 #ifdef CONFIG_EISA
 	if (ip22_is_fullhouse())	/* Only Indigo-2 has EISA stuff */
-	        ip22_eisa_init();
+		ip22_eisa_init();
 #endif
 }
-- 
1.5.4.3


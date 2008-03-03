Return-Path: <linux-kernel-owner+w=401wt.eu-S1758067AbYCCS2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067AbYCCS2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 13:28:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbYCCS20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 13:28:26 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:30899 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbYCCS2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 13:28:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AZHgfhz0+HFBqGZJx2aBLjj6+GSkKnmIWSbnbP1SdIad7pBNgZ12J/8t+7IsAG1pqa7filM2q+TBg+A1EOUc+gRCBNlKfWjayN+1asOwy/4feQUkGxpEi9AASXaYbzH7N7v3oh6tg54+Kk65N8E8d2sxBb758GlzHsaby65GzG0=
Subject: [PATCH] m68k: replace remaining __FUNCTION__ occurances
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 10:28:23 -0800
Message-Id: <1204568903.3266.27.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/m68k/kernel/ints.c |   10 +++++-----
 arch/m68k/mac/oss.c     |    4 ++--
 arch/m68k/q40/q40ints.c |    2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/m68k/kernel/ints.c b/arch/m68k/kernel/ints.c
index 2b41245..ded7dd2 100644
--- a/arch/m68k/kernel/ints.c
+++ b/arch/m68k/kernel/ints.c
@@ -186,7 +186,7 @@ int setup_irq(unsigned int irq, struct irq_node *node)
 
 	if (irq >= NR_IRQS || !(contr = irq_controller[irq])) {
 		printk("%s: Incorrect IRQ %d from %s\n",
-		       __FUNCTION__, irq, node->devname);
+		       __func__, irq, node->devname);
 		return -ENXIO;
 	}
 
@@ -249,7 +249,7 @@ void free_irq(unsigned int irq, void *dev_id)
 	unsigned long flags;
 
 	if (irq >= NR_IRQS || !(contr = irq_controller[irq])) {
-		printk("%s: Incorrect IRQ %d\n", __FUNCTION__, irq);
+		printk("%s: Incorrect IRQ %d\n", __func__, irq);
 		return;
 	}
 
@@ -267,7 +267,7 @@ void free_irq(unsigned int irq, void *dev_id)
 		node->handler = NULL;
 	} else
 		printk("%s: Removing probably wrong IRQ %d\n",
-		       __FUNCTION__, irq);
+		       __func__, irq);
 
 	if (!irq_list[irq]) {
 		if (contr->shutdown)
@@ -288,7 +288,7 @@ void enable_irq(unsigned int irq)
 
 	if (irq >= NR_IRQS || !(contr = irq_controller[irq])) {
 		printk("%s: Incorrect IRQ %d\n",
-		       __FUNCTION__, irq);
+		       __func__, irq);
 		return;
 	}
 
@@ -312,7 +312,7 @@ void disable_irq(unsigned int irq)
 
 	if (irq >= NR_IRQS || !(contr = irq_controller[irq])) {
 		printk("%s: Incorrect IRQ %d\n",
-		       __FUNCTION__, irq);
+		       __func__, irq);
 		return;
 	}
 
diff --git a/arch/m68k/mac/oss.c b/arch/m68k/mac/oss.c
index 50603d3..3c943d2 100644
--- a/arch/m68k/mac/oss.c
+++ b/arch/m68k/mac/oss.c
@@ -190,7 +190,7 @@ void oss_irq_enable(int irq) {
 			break;
 #ifdef DEBUG_IRQUSE
 		default:
-			printk("%s unknown irq %d\n",__FUNCTION__, irq);
+			printk("%s unknown irq %d\n", __func__, irq);
 			break;
 #endif
 	}
@@ -230,7 +230,7 @@ void oss_irq_disable(int irq) {
 			break;
 #ifdef DEBUG_IRQUSE
 		default:
-			printk("%s unknown irq %d\n", __FUNCTION__, irq);
+			printk("%s unknown irq %d\n", __func__, irq);
 			break;
 #endif
 	}
diff --git a/arch/m68k/q40/q40ints.c b/arch/m68k/q40/q40ints.c
index 46161ce..9f0e3d5 100644
--- a/arch/m68k/q40/q40ints.c
+++ b/arch/m68k/q40/q40ints.c
@@ -47,7 +47,7 @@ static int q40_irq_startup(unsigned int irq)
 	switch (irq) {
 	case 1: case 2: case 8: case 9:
 	case 11: case 12: case 13:
-		printk("%s: ISA IRQ %d not implemented by HW\n", __FUNCTION__, irq);
+		printk("%s: ISA IRQ %d not implemented by HW\n", __func__, irq);
 		return -ENXIO;
 	}
 	return 0;
-- 
1.5.4.3.500.g83a2c




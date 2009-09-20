Return-Path: <linux-kernel-owner+w=401wt.eu-S1753136AbZITOYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbZITOYs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 10:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971AbZITOYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 10:24:48 -0400
Received: from khc.piap.pl ([195.187.100.11]:47607 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbZITOYr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 10:24:47 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH] [TRIVIAL] Changes to IRQs.
Date: Sun, 20 Sep 2009 16:24:49 +0200
Message-ID: <m3y6o93d8u.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Copy sent to trivial@kernel.org]

Trivial changes to IRQs.

Signed-off-by: Krzysztof Ha³asa <khc@pm.waw.pl>

diff --git a/Documentation/DocBook/genericirq.tmpl b/Documentation/DocBook/genericirq.tmpl
index c671a01..1448b33 100644
--- a/Documentation/DocBook/genericirq.tmpl
+++ b/Documentation/DocBook/genericirq.tmpl
@@ -417,8 +417,8 @@ desc->chip->end();
       </para>
       <para>
 	To make use of the split implementation, replace the call to
-	__do_IRQ by a call to desc->chip->handle_irq() and associate
-        the appropriate handler function to desc->chip->handle_irq().
+	__do_IRQ by a call to desc->handle_irq() and associate
+        the appropriate handler function to desc->handle_irq().
 	In most cases the generic handler implementations should
 	be sufficient.
      </para>
diff --git a/arch/arm/include/asm/hw_irq.h b/arch/arm/include/asm/hw_irq.h
index 90831f6..5b4e642 100644
--- a/arch/arm/include/asm/hw_irq.h
+++ b/arch/arm/include/asm/hw_irq.h
@@ -10,14 +10,6 @@ static inline void ack_bad_irq(int irq)
 	irq_err_count++;
 }
 
-/*
- * Obsolete inline function for calling irq descriptor handlers.
- */
-static inline void desc_handle_irq(unsigned int irq, struct irq_desc *desc)
-{
-	desc->handle_irq(irq, desc);
-}
-
 void set_irq_flags(unsigned int irq, unsigned int flags);
 
 #define IRQF_VALID	(1 << 0)
diff --git a/arch/arm/plat-orion/gpio.c b/arch/arm/plat-orion/gpio.c
index e814803..85f305a 100644
--- a/arch/arm/plat-orion/gpio.c
+++ b/arch/arm/plat-orion/gpio.c
@@ -354,6 +354,6 @@ void orion_gpio_irq_handler(int pinoff)
 			polarity ^= 1 << (pin & 31);
 			writel(polarity, GPIO_IN_POL(pin));
 		}
-		desc_handle_irq(irq, desc);
+		desc->handle_irq(irq, desc);
 	}
 }
diff --git a/include/linux/irq.h b/include/linux/irq.h
index cb2e77a..b0424fe 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -281,7 +281,7 @@ extern irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action);
 
 /*
  * Built-in IRQ handlers for various IRQ types,
- * callable via desc->chip->handle_irq()
+ * callable via desc->handle_irq()
  */
 extern void handle_level_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc);

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752456AbXDDWrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbXDDWrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 18:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbXDDWq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 18:46:29 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:37954 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445AbXDDWqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 18:46:24 -0400
Message-Id: <20070404224608.828386000@ldl.fc.hp.com>
References: <20070404224536.337573000@ldl.fc.hp.com>
User-Agent: quilt/0.45-1
Date: Wed, 04 Apr 2007 16:45:39 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Keith Owens <kaos@ocs.com.au>
Cc: Len Brown <lenb@kernel.org>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Matthieu CASTET <castet.matthieu@free.fr>
Cc: Jean Tourrilhes <jt@hpl.hp.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Ville Syrjala <syrjala@sci.fi>
Cc: Russell King <rmk+serial@arm.linux.org.uk>
Cc: linux-serial@vger.kernel.org
Cc: Samuel Ortiz <samuel@sortiz.org>
Cc: linux-kernel@vger.kernel.org
Subject: [patch 3/5] smsc-ircc2: tidy up module parameter checking
Content-Disposition: inline; filename=smsc-ircc2-tidy-module-param-checking.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

To determine whether the user specified a module parameter, use some #defines
instead of checking for bare magic numbers.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: w/drivers/net/irda/smsc-ircc2.c
===================================================================
--- w.orig/drivers/net/irda/smsc-ircc2.c	2007-04-04 13:38:30.000000000 -0600
+++ w/drivers/net/irda/smsc-ircc2.c	2007-04-04 13:45:18.000000000 -0600
@@ -79,11 +79,13 @@
 MODULE_DESCRIPTION("SMC IrCC SIR/FIR controller driver");
 MODULE_LICENSE("GPL");
 
-static int ircc_dma = 255;
+#define DMA_INVAL 255
+static int ircc_dma = DMA_INVAL;
 module_param(ircc_dma, int, 0);
 MODULE_PARM_DESC(ircc_dma, "DMA channel");
 
-static int ircc_irq = 255;
+#define IRQ_INVAL 255
+static int ircc_irq = IRQ_INVAL;
 module_param(ircc_irq, int, 0);
 MODULE_PARM_DESC(ircc_irq, "IRQ line");
 
@@ -646,7 +648,7 @@
 	self->io.fifo_size = SMSC_IRCC2_FIFO_SIZE;
 	self->io.speed = SMSC_IRCC2_C_IRDA_FALLBACK_SPEED;
 
-	if (irq < 255) {
+	if (irq != IRQ_INVAL) {
 		if (irq != chip_irq)
 			IRDA_MESSAGE("%s, Overriding IRQ - chip says %d, using %d\n",
 				     driver_name, chip_irq, irq);
@@ -654,7 +656,7 @@
 	} else
 		self->io.irq = chip_irq;
 
-	if (dma < 255) {
+	if (dma != DMA_INVAL) {
 		if (dma != chip_dma)
 			IRDA_MESSAGE("%s, Overriding DMA - chip says %d, using %d\n",
 				     driver_name, chip_dma, dma);
@@ -2836,9 +2838,9 @@
 					tmpconf.fir_io = ircc_fir;
 				if (ircc_sir != 0)
 					tmpconf.sir_io = ircc_sir;
-				if (ircc_dma != 0xff)
+				if (ircc_dma != DMA_INVAL)
 					tmpconf.fir_dma = ircc_dma;
-				if (ircc_irq != 0xff)
+				if (ircc_irq != IRQ_INVAL)
 					tmpconf.fir_irq = ircc_irq;
 
 				IRDA_MESSAGE("Detected unconfigured %s SMSC IrDA chip, pre-configuring device.\n", conf->name);

--

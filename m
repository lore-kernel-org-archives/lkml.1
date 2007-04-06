Return-Path: <linux-kernel-owner+w=401wt.eu-S932796AbXDFUI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796AbXDFUI3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 16:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932794AbXDFUI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 16:08:29 -0400
Received: from www.osadl.org ([213.239.205.134]:33157 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932787AbXDFUI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 16:08:28 -0400
Subject: [PATCH-mm] Replace more deprecated SA_xxx interrupt flags
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1175889782.28263.470.camel@localhost.localdomain>
References: <20070114081905.135797900@inhelltoy.tec.linutronix.de>
	 <20070114081926.912658228@inhelltoy.tec.linutronix.de>
	 <20070123120245.ec3b0772.akpm@osdl.org>
	 <1169584278.21181.86.camel@localhost.localdomain>
	 <1175867366.28263.454.camel@localhost.localdomain>
	 <20070406122228.3dc06c79.akpm@linux-foundation.org>
	 <1175888217.28263.465.camel@localhost.localdomain>
	 <1175889782.28263.470.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 06 Apr 2007 22:08:55 +0200
Message-Id: <1175890135.28263.473.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the obnoxious users of the deprecated SA_xxx interrupt flags.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Index: linux-2.6.21-rc3-mm2/drivers/i2c/busses/i2c-bfin-twi.c
===================================================================
--- linux-2.6.21-rc3-mm2.orig/drivers/i2c/busses/i2c-bfin-twi.c
+++ linux-2.6.21-rc3-mm2/drivers/i2c/busses/i2c-bfin-twi.c
@@ -573,7 +573,7 @@ static int i2c_bfin_twi_probe(struct pla
 	p_adap->dev.parent = &dev->dev;
 
 	rc = request_irq(iface->irq, bfin_twi_interrupt_entry,
-		SA_INTERRUPT, dev->name, iface);
+		IRQF_DISABLED, dev->name, iface);
 	if (rc) {
 		dev_err(&(p_adap->dev), "i2c-bfin-twi: can't get IRQ %d !\n",
 			iface->irq);
Index: linux-2.6.21-rc3-mm2/drivers/input/keyboard/pxa27x_keyboard.c
===================================================================
--- linux-2.6.21-rc3-mm2.orig/drivers/input/keyboard/pxa27x_keyboard.c
+++ linux-2.6.21-rc3-mm2/drivers/input/keyboard/pxa27x_keyboard.c
@@ -181,7 +181,7 @@ static int __devinit pxakbd_probe(struct
 		}
 	}
 
-	error = request_irq(IRQ_KEYPAD, pxakbd_irq_handler, SA_INTERRUPT,
+	error = request_irq(IRQ_KEYPAD, pxakbd_irq_handler, IRQF_DISABLED,
 			    DRIVER_NAME, pdev);
 	if (error) {
 		printk(KERN_ERR "Cannot request keypad IRQ\n");
Index: linux-2.6.21-rc3-mm2/drivers/net/vioc/vioc_irq.c
===================================================================
--- linux-2.6.21-rc3-mm2.orig/drivers/net/vioc/vioc_irq.c
+++ linux-2.6.21-rc3-mm2/drivers/net/vioc/vioc_irq.c
@@ -319,7 +319,7 @@ static int vioc_irq_install(struct pci_d
 
 	ret = request_irq(vioc_interrupts[vioc_id].intreq[intr_id].irq,
 			  vioc_interrupts[vioc_id].intreq[intr_id].hthandler,
-			  SA_INTERRUPT,
+			  IRQF_DISABLED,
 			  vioc_interrupts[vioc_id].intreq[intr_id].name,
 			  vioc_interrupts[vioc_id].intreq[intr_id].
 			  intrFuncparm);



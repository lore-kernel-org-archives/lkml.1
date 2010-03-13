Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034Ab0CMMkw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 07:40:52 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:43449 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144Ab0CMMkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 07:40:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=CbuwT6zc1X2IYs38fblyCc27UL9pnLnwTjgtnO03Xpe/Y/1TqM5YmZoO+dU+hEdEuo
         4lYsL7DzFlNFrnOm5zm2gQ9GtvWkTR1nYmJclRbxI55bDfTNg8cEXGeYdGRClqqbttLI
         N5tviMq1fS0xdR6ZE1UuE/TBbGB/B9Q5ih50g=
From: Stefan Schick <stinder21@googlemail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.com, linux-kernel@vger.kernel.org,
       Stefan Schick <stinder21@googlemail.com>
Subject: [PATCH] Staging: comedi: dt3000: fixed some coding style issues
Date: Sat, 13 Mar 2010 13:47:09 +0100
Message-Id: <1268484429-10900-1-git-send-email-stinder21@googlemail.com>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed some coding style issues

Signed-off-by: Stefan Schick <stinder21@googlemail.com>
---
 drivers/staging/comedi/drivers/dt3000.c |   21 +++++++--------------
 1 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt3000.c b/drivers/staging/comedi/drivers/dt3000.c
index bbbef79..ca68789 100644
--- a/drivers/staging/comedi/drivers/dt3000.c
+++ b/drivers/staging/comedi/drivers/dt3000.c
@@ -314,9 +314,8 @@ static int dt3k_send_cmd(struct comedi_device *dev, unsigned int cmd)
 			break;
 		udelay(1);
 	}
-	if ((status & DT3000_COMPLETION_MASK) == DT3000_NOERROR) {
+	if ((status & DT3000_COMPLETION_MASK) == DT3000_NOERROR)
 		return 0;
-	}
 
 	printk("dt3k_send_cmd() timeout/error status=0x%04x\n", status);
 
@@ -359,9 +358,8 @@ static irqreturn_t dt3k_interrupt(int irq, void *d)
 	struct comedi_subdevice *s;
 	unsigned int status;
 
-	if (!dev->attached) {
+	if (!dev->attached)
 		return IRQ_NONE;
-	}
 
 	s = dev->subdevices + 0;
 	status = readw(devpriv->io_addr + DPR_Intr_Flag);
@@ -374,9 +372,8 @@ static irqreturn_t dt3k_interrupt(int irq, void *d)
 		s->async->events |= COMEDI_CB_BLOCK;
 	}
 
-	if (status & (DT3000_ADSWERR | DT3000_ADHWERR)) {
+	if (status & (DT3000_ADSWERR | DT3000_ADHWERR))
 		s->async->events |= COMEDI_CB_ERROR | COMEDI_CB_EOA;
-	}
 
 	debug_n_ints++;
 	if (debug_n_ints >= 10) {
@@ -399,9 +396,8 @@ static void debug_intr_flags(unsigned int flags)
 	int i;
 	printk("dt3k: intr_flags:");
 	for (i = 0; i < 8; i++) {
-		if (flags & (1 << i)) {
+		if (flags & (1 << i))
 			printk(" %s", intr_flags[i]);
-		}
 	}
 	printk("\n");
 }
@@ -690,9 +686,8 @@ static int dt3k_ai_insn(struct comedi_device *dev, struct comedi_subdevice *s,
 	/* XXX docs don't explain how to select aref */
 	aref = CR_AREF(insn->chanspec);
 
-	for (i = 0; i < insn->n; i++) {
+	for (i = 0; i < insn->n; i++)
 		data[i] = dt3k_readsingle(dev, SUBS_AI, chan, gain);
-	}
 
 	return i;
 }
@@ -720,9 +715,8 @@ static int dt3k_ao_insn_read(struct comedi_device *dev,
 	unsigned int chan;
 
 	chan = CR_CHAN(insn->chanspec);
-	for (i = 0; i < insn->n; i++) {
+	for (i = 0; i < insn->n; i++)
 		data[i] = devpriv->ao_readback[chan];
-	}
 
 	return i;
 }
@@ -911,9 +905,8 @@ static int dt3000_detach(struct comedi_device *dev)
 
 	if (devpriv) {
 		if (devpriv->pci_dev) {
-			if (devpriv->phys_addr) {
+			if (devpriv->phys_addr)
 				comedi_pci_disable(devpriv->pci_dev);
-			}
 			pci_dev_put(devpriv->pci_dev);
 		}
 		if (devpriv->io_addr)
-- 
1.7.0.2


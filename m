Return-Path: <linux-kernel-owner+w=401wt.eu-S1751892AbZIXWDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892AbZIXWDg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 18:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751296AbZIXWDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 18:03:35 -0400
Received: from mail-px0-f189.google.com ([209.85.216.189]:48696 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbZIXWDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 18:03:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=LlCJIfVlavIywNWfAk+RXhGqurJL6DWFAiypM0+3qEivEGmfL83iSxSp1Dnl7nsW0A
         bkF0AzhSjiLS0WgVkzmkWA8ms4NbG4N58hl+BjEUbaJ1AeOiynJdNVkvD5Gvv2j5fWOi
         YRSQx6nLJ5RPNnPF/5izDttvlPxZiE3+lljyk=
Message-ID: <4ABBECB8.5040207@gmail.com>
Date: Thu, 24 Sep 2009 15:03:36 -0700
From: Bruce Jones <brucej97223@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: gregkh@suse.de
CC: wfp5@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] staging: comedi: fix formating in drivers/ni_atmio16d.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix improper use of printks in this driver.  Most are
debug messages under a DEBUG #ifdef, a few are info/warnings
that should get logged for driver error conditions.

Signed-off-by: Bruce Jones <brucej@linux.com>
---
 drivers/staging/comedi/drivers/ni_atmio16d.c |   30 +++++++++++++------------
 1 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_atmio16d.c b/drivers/staging/comedi/drivers/ni_atmio16d.c
index c8876dc..3af879a 100644
--- a/drivers/staging/comedi/drivers/ni_atmio16d.c
+++ b/drivers/staging/comedi/drivers/ni_atmio16d.c
@@ -279,7 +279,9 @@ static irqreturn_t atmio16d_interrupt(int irq, void *d)
 	struct comedi_device *dev = d;
 	struct comedi_subdevice *s = dev->subdevices + 0;
 
-/* printk("atmio16d_interrupt!\n"); */
+#ifdef DEBUG1
+	printk(KERN_DEBUG "atmio16d_interrupt!\n");
+#endif
 
 	comedi_buf_put(s->async, inw(dev->iobase + AD_FIFO_REG));
 
@@ -293,7 +295,7 @@ static int atmio16d_ai_cmdtest(struct comedi_device *dev,
 {
 	int err = 0, tmp;
 #ifdef DEBUG1
-	printk("atmio16d_ai_cmdtest\n");
+	printk(KERN_DEBUG "atmio16d_ai_cmdtest\n");
 #endif
 	/* make sure triggers are valid */
 	tmp = cmd->start_src;
@@ -397,7 +399,7 @@ static int atmio16d_ai_cmd(struct comedi_device *dev,
 	unsigned int sample_count, tmp, chan, gain;
 	int i;
 #ifdef DEBUG1
-	printk("atmio16d_ai_cmd\n");
+	printk(KERN_DEBUG "atmio16d_ai_cmd\n");
 #endif
 	/* This is slowly becoming a working command interface. *
 	 * It is still uber-experimental */
@@ -559,7 +561,7 @@ static int atmio16d_ai_insn_read(struct comedi_device *dev,
 	int status;
 
 #ifdef DEBUG1
-	printk("atmio16d_ai_insn_read\n");
+	printk(KERN_DEBUG "atmio16d_ai_insn_read\n");
 #endif
 	chan = CR_CHAN(insn->chanspec);
 	gain = CR_RANGE(insn->chanspec);
@@ -580,7 +582,7 @@ static int atmio16d_ai_insn_read(struct comedi_device *dev,
 			/* check conversion status */
 			status = inw(dev->iobase + STAT_REG);
 #ifdef DEBUG1
-			printk("status=%x\n", status);
+			printk(KERN_DEBUG "status=%x\n", status);
 #endif
 			if (status & STAT_AD_CONVAVAIL) {
 				/* read the data now */
@@ -591,7 +593,7 @@ static int atmio16d_ai_insn_read(struct comedi_device *dev,
 				break;
 			}
 			if (status & STAT_AD_OVERFLOW) {
-				printk("atmio16d: a/d FIFO overflow\n");
+				printk(KERN_INFO "atmio16d: a/d FIFO overflow\n");
 				outw(0, dev->iobase + AD_CLEAR_REG);
 
 				return -ETIME;
@@ -599,7 +601,7 @@ static int atmio16d_ai_insn_read(struct comedi_device *dev,
 		}
 		/* end waiting, now check if it timed out */
 		if (t == ATMIO16D_TIMEOUT) {
-			printk("atmio16d: timeout\n");
+			printk(KERN_INFO "atmio16d: timeout\n");
 
 			return -ETIME;
 		}
@@ -614,7 +616,7 @@ static int atmio16d_ao_insn_read(struct comedi_device *dev,
 {
 	int i;
 #ifdef DEBUG1
-	printk("atmio16d_ao_insn_read\n");
+	printk(KERN_DEBUG "atmio16d_ao_insn_read\n");
 #endif
 
 	for (i = 0; i < insn->n; i++)
@@ -630,7 +632,7 @@ static int atmio16d_ao_insn_write(struct comedi_device *dev,
 	int chan;
 	int d;
 #ifdef DEBUG1
-	printk("atmio16d_ao_insn_write\n");
+	printk(KERN_DEBUG "atmio16d_ao_insn_write\n");
 #endif
 
 	chan = CR_CHAN(insn->chanspec);
@@ -740,7 +742,7 @@ static int atmio16d_attach(struct comedi_device *dev,
 
 	/* make sure the address range is free and allocate it */
 	iobase = it->options[0];
-	printk("comedi%d: atmio16d: 0x%04lx ", dev->minor, iobase);
+	printk(KERN_INFO "comedi%d: atmio16d: 0x%04lx ", dev->minor, iobase);
 	if (!request_region(iobase, ATMIO16D_SIZE, "ni_atmio16d")) {
 		printk("I/O port conflict\n");
 		return -EIO;
@@ -767,13 +769,13 @@ static int atmio16d_attach(struct comedi_device *dev,
 
 		ret = request_irq(irq, atmio16d_interrupt, 0, "atmio16d", dev);
 		if (ret < 0) {
-			printk("failed to allocate irq %u\n", irq);
+			printk(KERN_INFO "failed to allocate irq %u\n", irq);
 			return ret;
 		}
 		dev->irq = irq;
-		printk("( irq = %u )\n", irq);
+		printk(KERN_INFO "( irq = %u )\n", irq);
 	} else {
-		printk("( no irq )");
+		printk(KERN_INFO "( no irq )");
 	}
 
 	/* set device options */
@@ -870,7 +872,7 @@ static int atmio16d_attach(struct comedi_device *dev,
 
 static int atmio16d_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: atmio16d: remove\n", dev->minor);
+	printk(KERN_INFO "comedi%d: atmio16d: remove\n", dev->minor);
 
 	if (dev->subdevices && boardtype->has_8255)
 		subdev_8255_cleanup(dev, dev->subdevices + 3);
-- 
1.6.5.rc2

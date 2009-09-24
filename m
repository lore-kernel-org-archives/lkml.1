Return-Path: <linux-kernel-owner+w=401wt.eu-S1751602AbZIXWBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602AbZIXWBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 18:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751151AbZIXWBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 18:01:34 -0400
Received: from mail-px0-f189.google.com ([209.85.216.189]:42623 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbZIXWBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 18:01:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=bQeY4PPRqH7GmpHtC4Jdfr8VLNwgbVTYpluDYD7GkqxltKd+zhpircyv3MIMd6OlkP
         FJSKUR201+1uYqWVqOjVs9rbA18l9DSGplGkpkmFM43LTDCgMzmE0laB+1Vn11Sq9+IO
         YvnonRuiK+UWRmzcIIx6RUJF9KWgCf1hTi0Mo=
Message-ID: <4ABBEC3F.7020300@gmail.com>
Date: Thu, 24 Sep 2009 15:01:35 -0700
From: Bruce Jones <brucej97223@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: gregkh@suse.de
CC: wfp5@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] staging: comedi: fix formatting errors in drivers/ni_atmio16d.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix improper use of braces in drivers/staging/comedi/drivers/ni_atmio16d.c

Signed-off-by: Bruce Jones <brucej@linux.com>
---
 drivers/staging/comedi/drivers/ni_atmio16d.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_atmio16d.c b/drivers/staging/comedi/drivers/ni_atmio16d.c
index 1e35ed6..d76663f 100644
--- a/drivers/staging/comedi/drivers/ni_atmio16d.c
+++ b/drivers/staging/comedi/drivers/ni_atmio16d.c
@@ -586,9 +586,8 @@ static int atmio16d_ai_insn_read(struct comedi_device *dev,
 				/* read the data now */
 				data[i] = inw(dev->iobase + AD_FIFO_REG);
 				/* change to two's complement if need be */
-				if (devpriv->adc_coding == adc_2comp) {
+				if (devpriv->adc_coding == adc_2comp)
 					data[i] ^= 0x800;
-				}
 				break;
 			}
 			if (status & STAT_AD_OVERFLOW) {
@@ -618,10 +617,8 @@ static int atmio16d_ao_insn_read(struct comedi_device *dev,
 	printk("atmio16d_ao_insn_read\n");
 #endif
 
-	for (i = 0; i < insn->n; i++) {
+	for (i = 0; i < insn->n; i++)
 		data[i] = devpriv->ao_readback[CR_CHAN(insn->chanspec)];
-	}
-
 	return i;
 }
 
@@ -642,15 +639,13 @@ static int atmio16d_ao_insn_write(struct comedi_device *dev,
 		d = data[i];
 		switch (chan) {
 		case 0:
-			if (devpriv->dac0_coding == dac_2comp) {
+			if (devpriv->dac0_coding == dac_2comp)
 				d ^= 0x800;
-			}
 			outw(d, dev->iobase + DAC0_REG);
 			break;
 		case 1:
-			if (devpriv->dac1_coding == dac_2comp) {
+			if (devpriv->dac1_coding == dac_2comp)
 				d ^= 0x800;
-			}
 			outw(d, dev->iobase + DAC1_REG);
 			break;
 		default:
@@ -855,11 +850,10 @@ static int atmio16d_attach(struct comedi_device *dev,
 
 	/* 8255 subdevice */
 	s++;
-	if (boardtype->has_8255) {
+	if (boardtype->has_8255)
 		subdev_8255_init(dev, s, NULL, dev->iobase);
-	} else {
+	else
 		s->type = COMEDI_SUBD_UNUSED;
-	}
 
 /* don't yet know how to deal with counter/timers */
 #if 0
-- 
1.6.5.rc2

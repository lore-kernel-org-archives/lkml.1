Return-Path: <linux-kernel-owner+w=401wt.eu-S1761408AbZJIUXC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761408AbZJIUXC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 16:23:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761398AbZJIUXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 16:23:01 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:41408 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761395AbZJIUXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 16:23:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=aqHc8HxeifzNrbhoXmzJP9QBkGnbXFDhc6MmBIqNilWoBKNF9YCPx7mInsFqMweNIp
         9mEXrAeKQ+sAGS2CSGJBz4+vRxr+mmIlqaffKjUCe/sH+bj5GD0lZqE+SHuQ9HXAvY8L
         LT9F3Mlac16X54HnyK/SnVJTSl6pcfWbKdbdc=
From: Bruce Beare <bbeare1@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Bill Pemberton <wfp5p@virginia.edu>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, Bruce Beare <bbeare1@gmail.com>
Subject: [PATCH] Cleanup: indent/format errors, printk calls.
Date: Fri,  9 Oct 2009 13:22:19 -0700
Message-Id: <1255119739-566-1-git-send-email-bbeare1@gmail.com>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/comedi/drivers/pcmad.c |   20 +++++++++-----------
 1 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcmad.c b/drivers/staging/comedi/drivers/pcmad.c
index acac670..43283c2 100644
--- a/drivers/staging/comedi/drivers/pcmad.c
+++ b/drivers/staging/comedi/drivers/pcmad.c
@@ -34,11 +34,11 @@ Configuration options:
   [0] - I/O port base
   [1] - unused
   [2] - Analog input reference
-          0 = single ended
-          1 = differential
+	0 = single ended
+	1 = differential
   [3] - Analog input encoding (must match jumpers)
-          0 = straight binary
-          1 = two's complement
+	0 = straight binary
+	1 = two's complement
 */
 
 #include <linux/interrupt.h>
@@ -113,9 +113,8 @@ static int pcmad_ai_insn_read(struct comedi_device *dev,
 		data[n] = inb(dev->iobase + PCMAD_LSB);
 		data[n] |= (inb(dev->iobase + PCMAD_MSB) << 8);
 
-		if (devpriv->twos_comp) {
+		if (devpriv->twos_comp) 
 			data[n] ^= (1 << (this_board->n_ai_bits - 1));
-		}
 	}
 
 	return n;
@@ -135,9 +134,9 @@ static int pcmad_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	unsigned long iobase;
 
 	iobase = it->options[0];
-	printk("comedi%d: pcmad: 0x%04lx ", dev->minor, iobase);
 	if (!request_region(iobase, PCMAD_SIZE, "pcmad")) {
-		printk("I/O port conflict\n");
+		printk(KERN_ERR "comedi%d: pcmad: 0x%04lx: I/O port conflict\n",
+			dev->minor, iobase);
 		return -EIO;
 	}
 	dev->iobase = iobase;
@@ -166,11 +165,10 @@ static int pcmad_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static int pcmad_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: pcmad: remove\n", dev->minor);
+	printk(KERN_NOTICE "comedi%d: pcmad: remove\n", dev->minor);
 
-	if (dev->irq) {
+	if (dev->irq)
 		free_irq(dev->irq, dev);
-	}
 	if (dev->iobase)
 		release_region(dev->iobase, PCMAD_SIZE);
 
-- 
1.6.2.5


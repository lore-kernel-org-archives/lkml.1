Return-Path: <linux-kernel-owner+w=401wt.eu-S1750899AbZIZEd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750899AbZIZEd1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 00:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750820AbZIZEd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 00:33:26 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:35456 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbZIZEdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 00:33:21 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Sep 2009 00:32:54 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=RuqEv+q77h2obxOn3wndI1HqwcAyb1lauwTebGrT9f17i2Hc50Es/SbgWY/jvIIi4L
         P+hGTrJ0KFFrqY4LKOW1dzMjX4+Pp0xc42hhJOAPRpkb28/s5A5EvoB6GJmO2ZTzm17n
         GOllW3Cd4CHBWPsyZuLuPrYorZrCDjlWePoMM=
Message-ID: <4ABD9995.7090600@gmail.com>
Date: Fri, 25 Sep 2009 21:33:25 -0700
From: Bruce Jones <brucej97223@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: gregkh@suse.de
CC: wfp5@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] staging: comedi: cleanup formating in drivers/8255.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the formatting in this driver to conform to the
standard.  Move EXPORT_SYMBOL to under the exported
funtion, and add KERN_INFO to some diagnostic printks.

Signed-off-by: Bruce Jones <brucej@linux.com>

---
 drivers/staging/comedi/drivers/8255.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/comedi/drivers/8255.c b/drivers/staging/comedi/drivers/8255.c
index 8ad3520..400bef4 100644
--- a/drivers/staging/comedi/drivers/8255.c
+++ b/drivers/staging/comedi/drivers/8255.c
@@ -132,6 +132,7 @@ void subdev_8255_interrupt(struct comedi_device *dev,
 
 	comedi_event(dev, s);
 }
+EXPORT_SYMBOL(subdev_8255_interrupt);
 
 static int subdev_8255_cb(int dir, int port, int data, unsigned long arg)
 {
@@ -345,6 +346,7 @@ int subdev_8255_init(struct comedi_device *dev, struct comedi_subdevice *s,
 
 	return 0;
 }
+EXPORT_SYMBOL(subdev_8255_init);
 
 int subdev_8255_init_irq(struct comedi_device *dev, struct comedi_subdevice *s,
 			 int (*cb) (int, int, int, unsigned long),
@@ -364,6 +366,7 @@ int subdev_8255_init_irq(struct comedi_device *dev, struct comedi_subdevice *s,
 
 	return 0;
 }
+EXPORT_SYMBOL(subdev_8255_init_irq);
 
 void subdev_8255_cleanup(struct comedi_device *dev, struct comedi_subdevice *s)
 {
@@ -376,6 +379,7 @@ void subdev_8255_cleanup(struct comedi_device *dev, struct comedi_subdevice *s)
 		kfree(s->private);
 	}
 }
+EXPORT_SYMBOL(subdev_8255_cleanup);
 
 /*
 
@@ -390,7 +394,7 @@ static int dev_8255_attach(struct comedi_device *dev,
 	unsigned long iobase;
 	int i;
 
-	printk("comedi%d: 8255:", dev->minor);
+	printk(KERN_INFO "comedi%d: 8255:", dev->minor);
 
 	dev->board_name = "8255";
 
@@ -400,7 +404,7 @@ static int dev_8255_attach(struct comedi_device *dev,
 			break;
 	}
 	if (i == 0) {
-		printk(" no devices specified\n");
+		printk(KERN_INFO " no devices specified\n");
 		return -EINVAL;
 	}
 
@@ -411,9 +415,9 @@ static int dev_8255_attach(struct comedi_device *dev,
 	for (i = 0; i < dev->n_subdevices; i++) {
 		iobase = it->options[i];
 
-		printk(" 0x%04lx", iobase);
+		printk(KERN_INFO " 0x%04lx", iobase);
 		if (!request_region(iobase, _8255_SIZE, "8255")) {
-			printk(" (I/O port conflict)");
+			printk(KERN_INFO " (I/O port conflict)");
 
 			dev->subdevices[i].type = COMEDI_SUBD_UNUSED;
 		} else {
@@ -422,7 +426,7 @@ static int dev_8255_attach(struct comedi_device *dev,
 		}
 	}
 
-	printk("\n");
+	printk(KERN_INFO "\n");
 
 	return 0;
 }
@@ -433,7 +437,7 @@ static int dev_8255_detach(struct comedi_device *dev)
 	unsigned long iobase;
 	struct comedi_subdevice *s;
 
-	printk("comedi%d: 8255: remove\n", dev->minor);
+	printk(KERN_INFO "comedi%d: 8255: remove\n", dev->minor);
 
 	for (i = 0; i < dev->n_subdevices; i++) {
 		s = dev->subdevices + i;
@@ -446,8 +450,3 @@ static int dev_8255_detach(struct comedi_device *dev)
 
 	return 0;
 }
-
-EXPORT_SYMBOL(subdev_8255_init);
-EXPORT_SYMBOL(subdev_8255_init_irq);
-EXPORT_SYMBOL(subdev_8255_cleanup);
-EXPORT_SYMBOL(subdev_8255_interrupt);
-- 

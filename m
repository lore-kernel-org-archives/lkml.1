Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab0B0Khp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 05:37:45 -0500
Received: from aliencamel.com ([69.93.184.242]:49786 "EHLO aliencamel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994Ab0B0Khn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 05:37:43 -0500
Message-ID: <4B88F5ED.9040405@aliencamel.com>
Date: Sat, 27 Feb 2010 10:37:33 +0000
From: Stewart Robertson <stewart_r@aliencamel.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>, wfp5p@virginia.edu, linux@dominikbrodowski.net,
       keil@b1-systems.de
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       stewart_r@aliencamel.com
Subject: patch Staging-comedi-fix-coding-style-issues.patch
Content-Type: multipart/mixed; boundary="------------000801010004070707050206"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000801010004070707050206
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I've fixed most of the issues found by checkpatch.pl in 
'linux-2.6/drivers/staging/comedi/drivers/ni_daq_dio24.c' and attached the patch.
I forgot to put the driver name in the main description and didn't know if I could
change the name of the patch without messing it up.

I've tried setting Thunderbird to not mangle text but in case it does, I have
attached the patch as well.

I did some research and had a go at fixing the warning
'WARNING: printk() should include KERN_ facility level'
by adding KERN_INFO in front of the quoted text. 
Please let me know if that is the right thing to do and if not,
what I should do instead.

Cheers,

Stewart


>From ce043603489db7592ff7527ae97630d7c6100296 Mon Sep 17 00:00:00 2001
From: Stewart Robertson <str@minty7.(none)>
Date: Sat, 27 Feb 2010 10:03:27 +0000
Subject: [PATCH] Staging: comedi: fix coding style issues
 This is a patch to the ni_daq_dio24.c file that fixes line
 over 80 characters and KERN_INFO issues found by checkpatch.pl
 Signed-off-by: Stewart Robertson <stewart_r@aliencamel.com>

---
 drivers/staging/comedi/drivers/ni_daq_dio24.c |   67 +++++++++++++-----------
 1 files changed, 36 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_dio24.c b/drivers/staging/comedi/drivers/ni_daq_dio24.c
index 9017be3..681df0b 100644
--- a/drivers/staging/comedi/drivers/ni_daq_dio24.c
+++ b/drivers/staging/comedi/drivers/ni_daq_dio24.c
@@ -3,8 +3,8 @@
     Driver for National Instruments PCMCIA DAQ-Card DIO-24
     Copyright (C) 2002 Daniel Vecino Castel <dvecino@able.es>
 
-    PCMCIA crap at end of file is adapted from dummy_cs.c 1.31 2001/08/24 12:13:13
-    from the pcmcia package.
+    PCMCIA crap at end of file is adapted from
+    dummy_cs.c 1.31 2001/08/24 12:13:13 from the pcmcia package.
     The initial developer of the pcmcia dummy_cs.c code is David A. Hinds
     <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
     are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
@@ -37,7 +37,8 @@ This is just a wrapper around the 8255.o driver to properly handle
 the PCMCIA interface.
 */
 
-			    /* #define LABPC_DEBUG *//*  enable debugging messages */
+/* #define LABPC_DEBUG */
+/* enable debugging messages */
 #undef LABPC_DEBUG
 
 #include <linux/interrupt.h>
@@ -55,7 +56,7 @@ the PCMCIA interface.
 
 static struct pcmcia_device *pcmcia_cur_dev = NULL;
 
-#define DIO24_SIZE 4		/*  size of io region used by board */
+#define DIO24_SIZE 4		/* size of io region used by board */
 
 static int dio24_attach(struct comedi_device *dev, struct comedi_devconfig *it);
 static int dio24_detach(struct comedi_device *dev);
@@ -64,10 +65,13 @@ enum dio24_bustype { pcmcia_bustype };
 
 struct dio24_board_struct {
 	const char *name;
-	int device_id;		/*  device id for pcmcia board */
-	enum dio24_bustype bustype;	/*  PCMCIA */
-	int have_dio;		/*  have 8255 chip */
-	/*  function pointers so we can use inb/outb or readb/writeb as appropriate */
+	int device_id;		/* device id for pcmcia board */
+	enum dio24_bustype bustype;	/* PCMCIA */
+	int have_dio;		/* have 8255 chip */
+	/*
+	 * function pointers so we can use inb/outb or
+	 * readb/writeb as appropriate
+	 */
 	unsigned int (*read_byte) (unsigned int address);
 	void (*write_byte) (unsigned int byte, unsigned int address);
 };
@@ -75,16 +79,18 @@ struct dio24_board_struct {
 static const struct dio24_board_struct dio24_boards[] = {
 	{
 	 .name = "daqcard-dio24",
-	 .device_id = 0x475c,	/*  0x10b is manufacturer id, 0x475c is device id */
-	 .bustype = pcmcia_bustype,
-	 .have_dio = 1,
-	 },
+	/* 0x10b is manufacturer id, 0x475c is device id */
+	.device_id = 0x475c,
+	.bustype = pcmcia_bustype,
+	.have_dio = 1,
+	},
 	{
-	 .name = "ni_daq_dio24",
-	 .device_id = 0x475c,	/*  0x10b is manufacturer id, 0x475c is device id */
-	 .bustype = pcmcia_bustype,
-	 .have_dio = 1,
-	 },
+	.name = "ni_daq_dio24",
+	/* 0x10b is manufacturer id, 0x475c is device id */
+	.device_id = 0x475c,
+	.bustype = pcmcia_bustype,
+	.have_dio = 1,
+	},
 };
 
 /*
@@ -134,22 +140,21 @@ static int dio24_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 #endif
 		break;
 	default:
-		printk("bug! couldn't determine board type\n");
+		printk(KERN_INFO "bug! couldn't determine board type\n");
 		return -EINVAL;
 		break;
 	}
-	printk("comedi%d: ni_daq_dio24: %s, io 0x%lx", dev->minor,
+	printk(KERN_INFO "comedi%d: ni_daq_dio24: %s, io 0x%lx", dev->minor,
 	       thisboard->name, iobase);
 #ifdef incomplete
-	if (irq) {
+	if (irq)
 		printk(", irq %u", irq);
-	}
 #endif
 
 	printk("\n");
 
 	if (iobase == 0) {
-		printk("io base address is zero!\n");
+		printk(KERN_INFO "io base address is zero!\n");
 		return -EINVAL;
 	}
 
@@ -174,7 +179,7 @@ static int dio24_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static int dio24_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: ni_daq_dio24: remove\n", dev->minor);
+	printk(KERN_INFO "comedi%d: ni_daq_dio24: remove\n", dev->minor);
 
 	if (dev->subdevices)
 		subdev_8255_cleanup(dev, dev->subdevices + 0);
@@ -390,9 +395,9 @@ static void dio24_config(struct pcmcia_device *link)
 	}
 
 	/*
-	   Allocate an interrupt line.  Note that this does not assign a
-	   handler to the interrupt, unless the 'Handler' member of the
-	   irq structure is initialized.
+	 * Allocate an interrupt line.  Note that this does not assign a
+	 * handler to the interrupt, unless the 'Handler' member of the
+	 * irq structure is initialized.
 	 */
 	if (link->conf.Attributes & CONF_ENABLE_IRQ) {
 		ret = pcmcia_request_irq(link, &link->irq);
@@ -401,17 +406,17 @@ static void dio24_config(struct pcmcia_device *link)
 	}
 
 	/*
-	   This actually configures the PCMCIA socket -- setting up
-	   the I/O windows and the interrupt mapping, and putting the
-	   card and host interface into "Memory and IO" mode.
+	 * This actually configures the PCMCIA socket -- setting up
+	 * the I/O windows and the interrupt mapping, and putting the
+	 * card and host interface into "Memory and IO" mode.
 	 */
 	ret = pcmcia_request_configuration(link, &link->conf);
 	if (ret)
 		goto failed;
 
 	/*
-	   At this point, the dev_node_t structure(s) need to be
-	   initialized and arranged in a linked list at link->dev.
+	 * At this point, the dev_node_t structure(s) need to be
+	 * initialized and arranged in a linked list at link->dev.
 	 */
 	sprintf(dev->node.dev_name, "ni_daq_dio24");
 	dev->node.major = dev->node.minor = 0;
-- 
1.6.0.4



--------------000801010004070707050206
Content-Type: text/x-patch;
 name="0003-Staging-comedi-fix-coding-style-issues.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0003-Staging-comedi-fix-coding-style-issues.patch"

>From ce043603489db7592ff7527ae97630d7c6100296 Mon Sep 17 00:00:00 2001
From: Stewart Robertson <str@minty7.(none)>
Date: Sat, 27 Feb 2010 10:03:27 +0000
Subject: [PATCH] Staging: comedi: fix coding style issues
 This is a patch to the ni_daq_dio24.c file that fixes line
 over 80 characters and KERN_INFO issues found by checkpatch.pl
 Signed-off-by: Stewart Robertson <stewart_r@aliencamel.com>

---
 drivers/staging/comedi/drivers/ni_daq_dio24.c |   67 +++++++++++++-----------
 1 files changed, 36 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_dio24.c b/drivers/staging/comedi/drivers/ni_daq_dio24.c
index 9017be3..681df0b 100644
--- a/drivers/staging/comedi/drivers/ni_daq_dio24.c
+++ b/drivers/staging/comedi/drivers/ni_daq_dio24.c
@@ -3,8 +3,8 @@
     Driver for National Instruments PCMCIA DAQ-Card DIO-24
     Copyright (C) 2002 Daniel Vecino Castel <dvecino@able.es>
 
-    PCMCIA crap at end of file is adapted from dummy_cs.c 1.31 2001/08/24 12:13:13
-    from the pcmcia package.
+    PCMCIA crap at end of file is adapted from
+    dummy_cs.c 1.31 2001/08/24 12:13:13 from the pcmcia package.
     The initial developer of the pcmcia dummy_cs.c code is David A. Hinds
     <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
     are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
@@ -37,7 +37,8 @@ This is just a wrapper around the 8255.o driver to properly handle
 the PCMCIA interface.
 */
 
-			    /* #define LABPC_DEBUG *//*  enable debugging messages */
+/* #define LABPC_DEBUG */
+/* enable debugging messages */
 #undef LABPC_DEBUG
 
 #include <linux/interrupt.h>
@@ -55,7 +56,7 @@ the PCMCIA interface.
 
 static struct pcmcia_device *pcmcia_cur_dev = NULL;
 
-#define DIO24_SIZE 4		/*  size of io region used by board */
+#define DIO24_SIZE 4		/* size of io region used by board */
 
 static int dio24_attach(struct comedi_device *dev, struct comedi_devconfig *it);
 static int dio24_detach(struct comedi_device *dev);
@@ -64,10 +65,13 @@ enum dio24_bustype { pcmcia_bustype };
 
 struct dio24_board_struct {
 	const char *name;
-	int device_id;		/*  device id for pcmcia board */
-	enum dio24_bustype bustype;	/*  PCMCIA */
-	int have_dio;		/*  have 8255 chip */
-	/*  function pointers so we can use inb/outb or readb/writeb as appropriate */
+	int device_id;		/* device id for pcmcia board */
+	enum dio24_bustype bustype;	/* PCMCIA */
+	int have_dio;		/* have 8255 chip */
+	/*
+	 * function pointers so we can use inb/outb or
+	 * readb/writeb as appropriate
+	 */
 	unsigned int (*read_byte) (unsigned int address);
 	void (*write_byte) (unsigned int byte, unsigned int address);
 };
@@ -75,16 +79,18 @@ struct dio24_board_struct {
 static const struct dio24_board_struct dio24_boards[] = {
 	{
 	 .name = "daqcard-dio24",
-	 .device_id = 0x475c,	/*  0x10b is manufacturer id, 0x475c is device id */
-	 .bustype = pcmcia_bustype,
-	 .have_dio = 1,
-	 },
+	/* 0x10b is manufacturer id, 0x475c is device id */
+	.device_id = 0x475c,
+	.bustype = pcmcia_bustype,
+	.have_dio = 1,
+	},
 	{
-	 .name = "ni_daq_dio24",
-	 .device_id = 0x475c,	/*  0x10b is manufacturer id, 0x475c is device id */
-	 .bustype = pcmcia_bustype,
-	 .have_dio = 1,
-	 },
+	.name = "ni_daq_dio24",
+	/* 0x10b is manufacturer id, 0x475c is device id */
+	.device_id = 0x475c,
+	.bustype = pcmcia_bustype,
+	.have_dio = 1,
+	},
 };
 
 /*
@@ -134,22 +140,21 @@ static int dio24_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 #endif
 		break;
 	default:
-		printk("bug! couldn't determine board type\n");
+		printk(KERN_INFO "bug! couldn't determine board type\n");
 		return -EINVAL;
 		break;
 	}
-	printk("comedi%d: ni_daq_dio24: %s, io 0x%lx", dev->minor,
+	printk(KERN_INFO "comedi%d: ni_daq_dio24: %s, io 0x%lx", dev->minor,
 	       thisboard->name, iobase);
 #ifdef incomplete
-	if (irq) {
+	if (irq)
 		printk(", irq %u", irq);
-	}
 #endif
 
 	printk("\n");
 
 	if (iobase == 0) {
-		printk("io base address is zero!\n");
+		printk(KERN_INFO "io base address is zero!\n");
 		return -EINVAL;
 	}
 
@@ -174,7 +179,7 @@ static int dio24_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static int dio24_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: ni_daq_dio24: remove\n", dev->minor);
+	printk(KERN_INFO "comedi%d: ni_daq_dio24: remove\n", dev->minor);
 
 	if (dev->subdevices)
 		subdev_8255_cleanup(dev, dev->subdevices + 0);
@@ -390,9 +395,9 @@ static void dio24_config(struct pcmcia_device *link)
 	}
 
 	/*
-	   Allocate an interrupt line.  Note that this does not assign a
-	   handler to the interrupt, unless the 'Handler' member of the
-	   irq structure is initialized.
+	 * Allocate an interrupt line.  Note that this does not assign a
+	 * handler to the interrupt, unless the 'Handler' member of the
+	 * irq structure is initialized.
 	 */
 	if (link->conf.Attributes & CONF_ENABLE_IRQ) {
 		ret = pcmcia_request_irq(link, &link->irq);
@@ -401,17 +406,17 @@ static void dio24_config(struct pcmcia_device *link)
 	}
 
 	/*
-	   This actually configures the PCMCIA socket -- setting up
-	   the I/O windows and the interrupt mapping, and putting the
-	   card and host interface into "Memory and IO" mode.
+	 * This actually configures the PCMCIA socket -- setting up
+	 * the I/O windows and the interrupt mapping, and putting the
+	 * card and host interface into "Memory and IO" mode.
 	 */
 	ret = pcmcia_request_configuration(link, &link->conf);
 	if (ret)
 		goto failed;
 
 	/*
-	   At this point, the dev_node_t structure(s) need to be
-	   initialized and arranged in a linked list at link->dev.
+	 * At this point, the dev_node_t structure(s) need to be
+	 * initialized and arranged in a linked list at link->dev.
 	 */
 	sprintf(dev->node.dev_name, "ni_daq_dio24");
 	dev->node.major = dev->node.minor = 0;
-- 
1.6.0.4


--------------000801010004070707050206--

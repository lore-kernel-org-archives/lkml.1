Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab0BUM5F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 07:57:05 -0500
Received: from aliencamel.com ([69.93.184.242]:43520 "EHLO aliencamel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810Ab0BUM5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 07:57:01 -0500
X-Greylist: delayed 3597 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Feb 2010 07:56:59 EST
Message-ID: <4B811F7B.2020406@aliencamel.com>
Date: Sun, 21 Feb 2010 11:56:43 +0000
From: Stewart Robertson <stewart_r@aliencamel.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>, wfp5p@virginia.edu, stewart_r@aliencamel.com
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Staging: comedi fix coding style errors
Content-Type: multipart/mixed; boundary="------------080203010107080100020807"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080203010107080100020807
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I did lots of style corrections and created the patch (0001) but when I 
checked it the report said there were errors so I made the changes and 
created a new patch (0002) but it didn't have all my original changes in 
it. This is why have attached two similar patches.

I know it is best if the patches are inside the body of the email 
instead of attached but I do not have an email client set up that can 
send the patches with the correct formatting. I'll work on it ready for 
next time.

Cheers,

Stewart

--------------080203010107080100020807
Content-Type: text/x-patch;
 name="0001-Staging-comedi-fix-coding-style-issues-in-ni_labpc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-Staging-comedi-fix-coding-style-issues-in-ni_labpc.patc";
 filename*1="h"

>From 87d8f06c59da230f3aec6d809b92d6a9ea7ba9bf Mon Sep 17 00:00:00 2001
From: Stewart Robertson <str@minty7.(none)>
Date: Sun, 21 Feb 2010 10:13:21 +0000
Subject: [PATCH] Staging: comedi: fix coding style issues in ni_labpc.c
 This is a patch to the ni_labpc.c file that fixes the brace
 warnings and comments over 80 characters found by the checkpatch.pl
 tool. Some code still goes over 80 characters because I didn't
 know what to do with it.
 Signed-off-by: Stewart Robertson <stewart_r@aliencamel.com>

---
 drivers/staging/comedi/drivers/ni_labpc.c |  303 +++++++++++++++++------------
 1 files changed, 180 insertions(+), 123 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index dc3f398..a602278 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -1,7 +1,8 @@
 /*
     comedi/drivers/ni_labpc.c
     Driver for National Instruments Lab-PC series boards and compatibles
-    Copyright (C) 2001, 2002, 2003 Frank Mori Hess <fmhess@users.sourceforge.net>
+    Copyright (C) 2001, 2002, 2003 Frank Mori Hess
+    <fmhess@users.sourceforge.net>
 
     This program is free software; you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by
@@ -90,8 +91,10 @@ NI manuals:
 
 #define DRV_NAME "ni_labpc"
 
-#define LABPC_SIZE           32	/*  size of io region used by board */
-#define LABPC_TIMER_BASE            500	/*  2 MHz master clock */
+/* size of io region used by board */
+#define LABPC_SIZE           32
+/* 2 MHz master clock */
+#define LABPC_TIMER_BASE            500
 
 /* Registers for the lab-pc+ */
 
@@ -99,69 +102,110 @@ NI manuals:
 #define COMMAND1_REG	0x0
 #define   ADC_GAIN_MASK	(0x7 << 4)
 #define   ADC_CHAN_BITS(x)	((x) & 0x7)
-#define   ADC_SCAN_EN_BIT	0x80	/*  enables multi channel scans */
+/* enables multi channel scans */
+#define   ADC_SCAN_EN_BIT	0x80
 #define COMMAND2_REG	0x1
-#define   PRETRIG_BIT	0x1	/*  enable pretriggering (used in conjunction with SWTRIG) */
-#define   HWTRIG_BIT	0x2	/*  enable paced conversions on external trigger */
-#define   SWTRIG_BIT	0x4	/*  enable paced conversions */
-#define   CASCADE_BIT	0x8	/*  use two cascaded counters for pacing */
+/* enable pretriggering (used in conjunction with SWTRIG) */
+#define   PRETRIG_BIT	0x1
+/* enable paced conversions on external trigger */
+#define   HWTRIG_BIT	0x2
+/* enable paced conversions */
+#define   SWTRIG_BIT	0x4
+/* use two cascaded counters for pacing */
+#define   CASCADE_BIT	0x8
 #define   DAC_PACED_BIT(channel)	(0x40 << ((channel) & 0x1))
 #define COMMAND3_REG	0x2
-#define   DMA_EN_BIT	0x1	/*  enable dma transfers */
-#define   DIO_INTR_EN_BIT	0x2	/*  enable interrupts for 8255 */
-#define   DMATC_INTR_EN_BIT	0x4	/*  enable dma terminal count interrupt */
-#define   TIMER_INTR_EN_BIT	0x8	/*  enable timer interrupt */
-#define   ERR_INTR_EN_BIT	0x10	/*  enable error interrupt */
-#define   ADC_FNE_INTR_EN_BIT	0x20	/*  enable fifo not empty interrupt */
+/* enable dma transfers */
+#define   DMA_EN_BIT	0x1
+/* enable interrupts for 8255 */
+#define   DIO_INTR_EN_BIT	0x2
+/* enable dma terminal count interrupt */
+#define   DMATC_INTR_EN_BIT	0x4
+/* enable timer interrupt */
+#define   TIMER_INTR_EN_BIT	0x8
+/* enable error interrupt */
+#define   ERR_INTR_EN_BIT	0x10
+/* enable fifo not empty interrupt */
+#define   ADC_FNE_INTR_EN_BIT	0x20
 #define ADC_CONVERT_REG	0x3
 #define DAC_LSB_REG(channel)	(0x4 + 2 * ((channel) & 0x1))
 #define DAC_MSB_REG(channel)	(0x5 + 2 * ((channel) & 0x1))
 #define ADC_CLEAR_REG	0x8
 #define DMATC_CLEAR_REG	0xa
 #define TIMER_CLEAR_REG	0xc
-#define COMMAND6_REG	0xe	/*  1200 boards only */
-#define   ADC_COMMON_BIT	0x1	/*  select ground or common-mode reference */
-#define   ADC_UNIP_BIT	0x2	/*  adc unipolar */
-#define   DAC_UNIP_BIT(channel)	(0x4 << ((channel) & 0x1))	/*  dac unipolar */
-#define   ADC_FHF_INTR_EN_BIT	0x20	/*  enable fifo half full interrupt */
-#define   A1_INTR_EN_BIT	0x40	/*  enable interrupt on end of hardware count */
-#define   ADC_SCAN_UP_BIT 0x80	/*  scan up from channel zero instead of down to zero */
+/* 1200 boards only */
+#define COMMAND6_REG	0xe
+/* select ground or common-mode reference */
+#define   ADC_COMMON_BIT	0x1
+/*  adc unipolar */
+#define   ADC_UNIP_BIT	0x2
+/*  dac unipolar */
+#define   DAC_UNIP_BIT(channel)	(0x4 << ((channel) & 0x1))
+/* enable fifo half full interrupt */
+#define   ADC_FHF_INTR_EN_BIT	0x20
+/* enable interrupt on end of hardware count */
+#define   A1_INTR_EN_BIT	0x40
+/* scan up from channel zero instead of down to zero */
+#define   ADC_SCAN_UP_BIT 0x80
 #define COMMAND4_REG	0xf
-#define   INTERVAL_SCAN_EN_BIT	0x1	/*  enables 'interval' scanning */
-#define   EXT_SCAN_EN_BIT	0x2	/*  enables external signal on counter b1 output to trigger scan */
-#define   EXT_CONVERT_OUT_BIT	0x4	/*  chooses direction (output or input) for EXTCONV* line */
-#define   ADC_DIFF_BIT	0x8	/*  chooses differential inputs for adc (in conjunction with board jumper) */
+/* enables 'interval' scanning */
+#define   INTERVAL_SCAN_EN_BIT	0x1
+/* enables external signal on counter b1 output to trigger scan */
+#define   EXT_SCAN_EN_BIT	0x2
+/* chooses direction (output or input) for EXTCONV* line */
+#define   EXT_CONVERT_OUT_BIT	0x4
+/* chooses differential inputs for adc (in conjunction with board jumper) */
+#define   ADC_DIFF_BIT	0x8
 #define   EXT_CONVERT_DISABLE_BIT	0x10
-#define COMMAND5_REG	0x1c	/*  1200 boards only, calibration stuff */
-#define   EEPROM_WRITE_UNPROTECT_BIT	0x4	/*  enable eeprom for write */
-#define   DITHER_EN_BIT	0x8	/*  enable dithering */
-#define   CALDAC_LOAD_BIT	0x10	/*  load calibration dac */
-#define   SCLOCK_BIT	0x20	/*  serial clock - rising edge writes, falling edge reads */
-#define   SDATA_BIT	0x40	/*  serial data bit for writing to eeprom or calibration dacs */
-#define   EEPROM_EN_BIT	0x80	/*  enable eeprom for read/write */
+/* 1200 boards only, calibration stuff */
+#define COMMAND5_REG	0x1c
+/* enable eeprom for write */
+#define   EEPROM_WRITE_UNPROTECT_BIT	0x4
+/* enable dithering */
+#define   DITHER_EN_BIT	0x8
+/* load calibration dac */
+#define   CALDAC_LOAD_BIT	0x10
+/* serial clock - rising edge writes, falling edge reads */
+#define   SCLOCK_BIT	0x20
+/* serial data bit for writing to eeprom or calibration dacs */
+#define   SDATA_BIT	0x40
+/* enable eeprom for read/write */
+#define   EEPROM_EN_BIT	0x80
 #define INTERVAL_COUNT_REG	0x1e
 #define INTERVAL_LOAD_REG	0x1f
 #define   INTERVAL_LOAD_BITS	0x1
 
 /* read-only registers */
 #define STATUS1_REG	0x0
-#define   DATA_AVAIL_BIT	0x1	/*  data is available in fifo */
-#define   OVERRUN_BIT	0x2	/*  overrun has occurred */
-#define   OVERFLOW_BIT	0x4	/*  fifo overflow */
-#define   TIMER_BIT	0x8	/*  timer interrupt has occured */
-#define   DMATC_BIT	0x10	/*  dma terminal count has occured */
-#define   EXT_TRIG_BIT	0x40	/*  external trigger has occured */
-#define STATUS2_REG	0x1d	/*  1200 boards only */
-#define   EEPROM_OUT_BIT	0x1	/*  programmable eeprom serial output */
-#define   A1_TC_BIT	0x2	/*  counter A1 terminal count */
-#define   FNHF_BIT	0x4	/*  fifo not half full */
+/* data is available in fifo */
+#define   DATA_AVAIL_BIT	0x1
+/* overrun has occurred */
+#define   OVERRUN_BIT	0x2
+/* fifo overflow */
+#define   OVERFLOW_BIT	0x4
+/* timer interrupt has occured */
+#define   TIMER_BIT	0x8
+/* dma terminal count has occured */
+#define   DMATC_BIT	0x10
+/* external trigger has occured */
+#define   EXT_TRIG_BIT	0x40
+/* 1200 boards only */
+#define STATUS2_REG	0x1d
+/* programmable eeprom serial output */
+#define   EEPROM_OUT_BIT	0x1
+/* counter A1 terminal count */
+#define   A1_TC_BIT	0x2
+/* fifo not half full */
+#define   FNHF_BIT	0x4
 #define ADC_FIFO_REG	0xa
 
 #define DIO_BASE_REG	0x10
 #define COUNTER_A_BASE_REG	0x14
 #define COUNTER_A_CONTROL_REG	(COUNTER_A_BASE_REG + 0x3)
-#define   INIT_A0_BITS	0x14	/*  check modes put conversion pacer output in harmless state (a0 mode 2) */
-#define   INIT_A1_BITS	0x70	/*  put hardware conversion counter output in harmless state (a1 mode 0) */
+/* check modes put conversion pacer output in harmless state (a0 mode 2) */
+#define   INIT_A0_BITS	0x14
+/* put hardware conversion counter output in harmless state (a1 mode 0) */
+#define   INIT_A1_BITS	0x70
 #define COUNTER_B_BASE_REG	0x18
 
 static int labpc_attach(struct comedi_device *dev, struct comedi_devconfig *it);
@@ -423,7 +467,7 @@ static const struct labpc_board_struct labpc_boards[] = {
 	 .ai_scan_up = 1,
 	 .memory_mapped_io = 1,
 	 },
-	/*  dummy entry so pci board works when comedi_config is passed driver name */
+/* dummy entry so pci board works when comedi_config is passed driver name */
 	{
 	 .name = DRV_NAME,
 	 .bustype = pci_bustype,
@@ -436,8 +480,10 @@ static const struct labpc_board_struct labpc_boards[] = {
  */
 #define thisboard ((struct labpc_board_struct *)dev->board_ptr)
 
-static const int dma_buffer_size = 0xff00;	/*  size in bytes of dma buffer */
-static const int sample_size = 2;	/*  2 bytes per sample */
+/* size in bytes of dma buffer */
+static const int dma_buffer_size = 0xff00;
+/* 2 bytes per sample */
+static const int sample_size = 2;
 
 #define devpriv ((struct labpc_private *)dev->private)
 
@@ -483,19 +529,17 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 
 	printk("comedi%d: ni_labpc: %s, io 0x%lx", dev->minor, thisboard->name,
 	       iobase);
-	if (irq) {
+	if (irq)
 		printk(", irq %u", irq);
-	}
-	if (dma_chan) {
+	if (dma_chan)
 		printk(", dma %u", dma_chan);
-	}
 	printk("\n");
 
 	if (iobase == 0) {
 		printk("io base address is zero!\n");
 		return -EINVAL;
 	}
-	/*  request io regions for isa boards */
+	/* request io regions for isa boards */
 	if (thisboard->bustype == isa_bustype) {
 		/* check if io addresses are available */
 		if (!request_region(iobase, LABPC_SIZE,
@@ -513,7 +557,7 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 		devpriv->read_byte = labpc_inb;
 		devpriv->write_byte = labpc_outb;
 	}
-	/*  initialize board's command registers */
+	/* initialize board's command registers */
 	devpriv->write_byte(devpriv->command1_bits, dev->iobase + COMMAND1_REG);
 	devpriv->write_byte(devpriv->command2_bits, dev->iobase + COMMAND2_REG);
 	devpriv->write_byte(devpriv->command3_bits, dev->iobase + COMMAND3_REG);
@@ -538,12 +582,12 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 	}
 	dev->irq = irq;
 
-	/*  grab dma channel */
+	/* grab dma channel */
 	if (dma_chan > 3) {
 		printk(" invalid dma channel %u\n", dma_chan);
 		return -EINVAL;
 	} else if (dma_chan) {
-		/*  allocate dma buffer */
+		/* allocate dma buffer */
 		devpriv->dma_buffer =
 		    kmalloc(dma_buffer_size, GFP_KERNEL | GFP_DMA);
 		if (devpriv->dma_buffer == NULL) {
@@ -575,7 +619,7 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 	    SDF_READABLE | SDF_GROUND | SDF_COMMON | SDF_DIFF | SDF_CMD_READ;
 	s->n_chan = 8;
 	s->len_chanlist = 8;
-	s->maxdata = (1 << 12) - 1;	/*  12 bit resolution */
+	s->maxdata = (1 << 12) - 1;	/* 12 bit resolution */
 	s->range_table = thisboard->ai_range_table;
 	s->do_cmd = labpc_ai_cmd;
 	s->do_cmdtest = labpc_ai_cmdtest;
@@ -608,14 +652,15 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 
 	/* 8255 dio */
 	s = dev->subdevices + 2;
-	/*  if board uses io memory we have to give a custom callback function to the 8255 driver */
+	/* if board uses io memory we have to give a custom callback
+	 * function to the 8255 driver */
 	if (thisboard->memory_mapped_io)
 		subdev_8255_init(dev, s, labpc_dio_mem_callback,
 				 (unsigned long)(dev->iobase + DIO_BASE_REG));
 	else
 		subdev_8255_init(dev, s, NULL, dev->iobase + DIO_BASE_REG);
 
-	/*  calibration subdevices for boards that have one */
+	/* calibration subdevices for boards that have one */
 	s = dev->subdevices + 3;
 	if (thisboard->register_layout == labpc_1200_layout) {
 		s->type = COMEDI_SUBD_CALIB;
@@ -640,14 +685,12 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 		s->insn_read = labpc_eeprom_read_insn;
 		s->insn_write = labpc_eeprom_write_insn;
 
-		for (i = 0; i < EEPROM_SIZE; i++) {
+		for (i = 0; i < EEPROM_SIZE; i++)
 			devpriv->eeprom_data[i] = labpc_eeprom_read(dev, i);
-		}
 #ifdef LABPC_DEBUG
 		printk(" eeprom:");
-		for (i = 0; i < EEPROM_SIZE; i++) {
+		for (i = 0; i < EEPROM_SIZE; i++)
 			printk(" %i:0x%x ", i, devpriv->eeprom_data[i]);
-		}
 		printk("\n");
 #endif
 	} else
@@ -669,7 +712,7 @@ static int labpc_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (alloc_private(dev, sizeof(struct labpc_private)) < 0)
 		return -ENOMEM;
 
-	/*  get base address, irq etc. based on bustype */
+	/* get base address, irq etc. based on bustype */
 	switch (thisboard->bustype) {
 	case isa_bustype:
 		iobase = it->options[0];
@@ -679,9 +722,8 @@ static int labpc_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	case pci_bustype:
 #ifdef CONFIG_COMEDI_PCI
 		retval = labpc_find_device(dev, it->options[0], it->options[1]);
-		if (retval < 0) {
+		if (retval < 0)
 			return retval;
-		}
 		retval = mite_setup(devpriv->mite);
 		if (retval < 0)
 			return retval;
@@ -715,7 +757,7 @@ static int labpc_find_device(struct comedi_device *dev, int bus, int slot)
 	for (mite = mite_devices; mite; mite = mite->next) {
 		if (mite->used)
 			continue;
-		/*  if bus/slot are specified then make sure we have the right bus/slot */
+/* if bus/slot are specified then make sure we have the right bus/slot */
 		if (bus || slot) {
 			if (bus != mite->pcidev->bus->number
 			    || slot != PCI_SLOT(mite->pcidev->devfn))
@@ -726,7 +768,7 @@ static int labpc_find_device(struct comedi_device *dev, int bus, int slot)
 				continue;
 			if (mite_device_id(mite) == labpc_boards[i].device_id) {
 				devpriv->mite = mite;
-				/*  fixup board pointer, in case we were using the dummy "ni_labpc" entry */
+/* fixup board pointer, in case we were using the dummy "ni_labpc" entry */
 				dev->board_ptr = &labpc_boards[i];
 				return 0;
 			}
@@ -980,7 +1022,7 @@ static int labpc_ai_cmdtest(struct comedi_device *dev,
 	if (err)
 		return 1;
 
-	/* step 2: make sure trigger sources are unique and mutually compatible */
+/* step 2: make sure trigger sources are unique and mutually compatible */
 
 	if (cmd->start_src != TRIG_NOW && cmd->start_src != TRIG_EXT)
 		err++;
@@ -994,7 +1036,7 @@ static int labpc_ai_cmdtest(struct comedi_device *dev,
 	    cmd->stop_src != TRIG_EXT && cmd->stop_src != TRIG_NONE)
 		err++;
 
-	/*  can't have external stop and start triggers at once */
+	/* can't have external stop and start triggers at once */
 	if (cmd->start_src == TRIG_EXT && cmd->stop_src == TRIG_EXT)
 		err++;
 
@@ -1008,9 +1050,8 @@ static int labpc_ai_cmdtest(struct comedi_device *dev,
 		err++;
 	}
 
-	if (!cmd->chanlist_len) {
+	if (!cmd->chanlist_len)
 		err++;
-	}
 	if (cmd->scan_end_arg != cmd->chanlist_len) {
 		cmd->scan_end_arg = cmd->chanlist_len;
 		err++;
@@ -1022,7 +1063,7 @@ static int labpc_ai_cmdtest(struct comedi_device *dev,
 			err++;
 		}
 	}
-	/*  make sure scan timing is not too fast */
+	/* make sure scan timing is not too fast */
 	if (cmd->scan_begin_src == TRIG_TIMER) {
 		if (cmd->convert_src == TRIG_TIMER &&
 		    cmd->scan_begin_arg <
@@ -1038,7 +1079,7 @@ static int labpc_ai_cmdtest(struct comedi_device *dev,
 			err++;
 		}
 	}
-	/*  stop source */
+	/* stop source */
 	switch (cmd->stop_src) {
 	case TRIG_COUNT:
 		if (!cmd->stop_arg) {
@@ -1052,7 +1093,7 @@ static int labpc_ai_cmdtest(struct comedi_device *dev,
 			err++;
 		}
 		break;
-		/*  TRIG_EXT doesn't care since it doesn't trigger off a numbered channel */
+/* TRIG_EXT doesn't care since it doesn't trigger off a numbered channel */
 	default:
 		break;
 	}
@@ -1095,7 +1136,7 @@ static int labpc_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	range = CR_RANGE(cmd->chanlist[0]);
 	aref = CR_AREF(cmd->chanlist[0]);
 
-	/*  make sure board is disabled before setting up aquisition */
+	/* make sure board is disabled before setting up aquisition */
 	spin_lock_irqsave(&dev->spinlock, flags);
 	devpriv->command2_bits &= ~SWTRIG_BIT & ~HWTRIG_BIT & ~PRETRIG_BIT;
 	devpriv->write_byte(devpriv->command2_bits, dev->iobase + COMMAND2_REG);
@@ -1104,41 +1145,45 @@ static int labpc_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	devpriv->command3_bits = 0;
 	devpriv->write_byte(devpriv->command3_bits, dev->iobase + COMMAND3_REG);
 
-	/*  initialize software conversion count */
-	if (cmd->stop_src == TRIG_COUNT) {
+	/* initialize software conversion count */
+	if (cmd->stop_src == TRIG_COUNT)
 		devpriv->count = cmd->stop_arg * cmd->chanlist_len;
-	}
-	/*  setup hardware conversion counter */
+	/* setup hardware conversion counter */
 	if (cmd->stop_src == TRIG_EXT) {
-		/*  load counter a1 with count of 3 (pc+ manual says this is minimum allowed) using mode 0 */
+		/*
+		 * load counter a1 with count of 3 (pc+ manual says
+		 * this is minimum allowed) using mode 0
+		 */
 		ret = labpc_counter_load(dev, dev->iobase + COUNTER_A_BASE_REG,
 					 1, 3, 0);
 		if (ret < 0) {
 			comedi_error(dev, "error loading counter a1");
 			return -1;
 		}
-	} else			/*  otherwise, just put a1 in mode 0 with no count to set its output low */
+/* otherwise, just put a1 in mode 0 with no count to set its output low */
+	} else
 		devpriv->write_byte(INIT_A1_BITS,
 				    dev->iobase + COUNTER_A_CONTROL_REG);
 
-	/*  figure out what method we will use to transfer data */
+	/* figure out what method we will use to transfer data */
 	if (devpriv->dma_chan &&	/*  need a dma channel allocated */
-	    /*  dma unsafe at RT priority, and too much setup time for TRIG_WAKE_EOS for */
+/*dma unsafe at RT priority, and too much setup time for TRIG_WAKE_EOS for */
 	    (cmd->flags & (TRIG_WAKE_EOS | TRIG_RT)) == 0 &&
-	    /*  only available on the isa boards */
+	    /* only available on the isa boards */
 	    thisboard->bustype == isa_bustype) {
 		xfer = isa_dma_transfer;
-	} else if (thisboard->register_layout == labpc_1200_layout &&	/*  pc-plus has no fifo-half full interrupt */
-		   /*  wake-end-of-scan should interrupt on fifo not empty */
+	/* pc-plus has no fifo-half full interrupt */
+	} else if (thisboard->register_layout == labpc_1200_layout &&
+		   /* wake-end-of-scan should interrupt on fifo not empty */
 		   (cmd->flags & TRIG_WAKE_EOS) == 0 &&
-		   /*  make sure we are taking more than just a few points */
+		   /* make sure we are taking more than just a few points */
 		   (cmd->stop_src != TRIG_COUNT || devpriv->count > 256)) {
 		xfer = fifo_half_full_transfer;
 	} else
 		xfer = fifo_not_empty_transfer;
 	devpriv->current_transfer = xfer;
 
-	/*  setup command6 register for 1200 boards */
+	/* setup command6 register for 1200 boards */
 	if (thisboard->register_layout == labpc_1200_layout) {
 		/*  reference inputs to ground or common? */
 		if (aref != AREF_GROUND)
@@ -1176,17 +1221,18 @@ static int labpc_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		channel = CR_CHAN(cmd->chanlist[cmd->chanlist_len - 1]);
 	else
 		channel = CR_CHAN(cmd->chanlist[0]);
-	/*  munge channel bits for differential / scan disabled mode */
+	/* munge channel bits for differential / scan disabled mode */
 	if (labpc_ai_scan_mode(cmd) != MODE_SINGLE_CHAN && aref == AREF_DIFF)
 		channel *= 2;
 	devpriv->command1_bits |= ADC_CHAN_BITS(channel);
 	devpriv->command1_bits |= thisboard->ai_range_code[range];
 	devpriv->write_byte(devpriv->command1_bits, dev->iobase + COMMAND1_REG);
-	/*  manual says to set scan enable bit on second pass */
+	/* manual says to set scan enable bit on second pass */
 	if (labpc_ai_scan_mode(cmd) == MODE_MULT_CHAN_UP ||
 	    labpc_ai_scan_mode(cmd) == MODE_MULT_CHAN_DOWN) {
 		devpriv->command1_bits |= ADC_SCAN_EN_BIT;
-		/* need a brief delay before enabling scan, or scan list will get screwed when you switch
+		/* need a brief delay before enabling scan, or scan
+		 * list will get screwed when you switch
 		 * between scan up to scan down mode - dunno why */
 		udelay(1);
 		devpriv->write_byte(devpriv->command1_bits,
@@ -1338,7 +1384,7 @@ static irqreturn_t labpc_interrupt(int irq, void *d)
 	cmd = &async->cmd;
 	async->events = 0;
 
-	/*  read board status */
+	/* read board status */
 	devpriv->status1_bits = devpriv->read_byte(dev->iobase + STATUS1_REG);
 	if (thisboard->register_layout == labpc_1200_layout)
 		devpriv->status2_bits =
@@ -1352,7 +1398,7 @@ static irqreturn_t labpc_interrupt(int irq, void *d)
 	}
 
 	if (devpriv->status1_bits & OVERRUN_BIT) {
-		/*  clear error interrupt */
+		/* clear error interrupt */
 		devpriv->write_byte(0x1, dev->iobase + ADC_CLEAR_REG);
 		async->events |= COMEDI_CB_ERROR | COMEDI_CB_EOA;
 		comedi_event(dev, s);
@@ -1361,7 +1407,7 @@ static irqreturn_t labpc_interrupt(int irq, void *d)
 	}
 
 	if (devpriv->current_transfer == isa_dma_transfer) {
-		/*  if a dma terminal count of external stop trigger has occurred */
+	/* if a dma terminal count of external stop trigger has occurred */
 		if (devpriv->status1_bits & DMATC_BIT ||
 		    (thisboard->register_layout == labpc_1200_layout
 		     && devpriv->status2_bits & A1_TC_BIT)) {
@@ -1479,9 +1525,8 @@ static void labpc_drain_dma(struct comedi_device *dev)
 	}
 
 	/* write data to comedi buffer */
-	for (i = 0; i < num_points; i++) {
+	for (i = 0; i < num_points; i++)
 		cfc_write_to_buffer(s, devpriv->dma_buffer[i]);
-	}
 	if (async->cmd.stop_src == TRIG_COUNT)
 		devpriv->count -= num_points;
 
@@ -1537,41 +1582,41 @@ static int labpc_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 	chan = CR_CHAN(insn->chanspec);
 	range = CR_RANGE(insn->chanspec);
 	devpriv->command1_bits |= thisboard->ai_range_code[range];
-	/*  munge channel bits for differential/scan disabled mode */
+	/* munge channel bits for differential/scan disabled mode */
 	if (CR_AREF(insn->chanspec) == AREF_DIFF)
 		chan *= 2;
 	devpriv->command1_bits |= ADC_CHAN_BITS(chan);
 	devpriv->write_byte(devpriv->command1_bits, dev->iobase + COMMAND1_REG);
 
-	/*  setup command6 register for 1200 boards */
+	/* setup command6 register for 1200 boards */
 	if (thisboard->register_layout == labpc_1200_layout) {
 		/*  reference inputs to ground or common? */
 		if (CR_AREF(insn->chanspec) != AREF_GROUND)
 			devpriv->command6_bits |= ADC_COMMON_BIT;
 		else
 			devpriv->command6_bits &= ~ADC_COMMON_BIT;
-		/*  bipolar or unipolar range? */
+		/* bipolar or unipolar range? */
 		if (thisboard->ai_range_is_unipolar[range])
 			devpriv->command6_bits |= ADC_UNIP_BIT;
 		else
 			devpriv->command6_bits &= ~ADC_UNIP_BIT;
-		/*  don't interrupt on fifo half full */
+		/* don't interrupt on fifo half full */
 		devpriv->command6_bits &= ~ADC_FHF_INTR_EN_BIT;
-		/*  don't enable interrupt on counter a1 terminal count? */
+		/* don't enable interrupt on counter a1 terminal count? */
 		devpriv->command6_bits &= ~A1_INTR_EN_BIT;
-		/*  write to register */
+		/* write to register */
 		devpriv->write_byte(devpriv->command6_bits,
 				    dev->iobase + COMMAND6_REG);
 	}
-	/*  setup command4 register */
+	/* setup command4 register */
 	devpriv->command4_bits = 0;
 	devpriv->command4_bits |= EXT_CONVERT_DISABLE_BIT;
-	/*  single-ended/differential */
+	/* single-ended/differential */
 	if (CR_AREF(insn->chanspec) == AREF_DIFF)
 		devpriv->command4_bits |= ADC_DIFF_BIT;
 	devpriv->write_byte(devpriv->command4_bits, dev->iobase + COMMAND4_REG);
 
-	/*  initialize pacer counter output to make sure it doesn't cause any problems */
+/* initialize pacer counter output to make sure it doesn't cause any problems */
 	devpriv->write_byte(INIT_A0_BITS, dev->iobase + COUNTER_A_CONTROL_REG);
 
 	labpc_clear_adc_fifo(dev);
@@ -1608,7 +1653,7 @@ static int labpc_ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 
 	channel = CR_CHAN(insn->chanspec);
 
-	/*  turn off pacing of analog output channel */
+	/* turn off pacing of analog output channel */
 	/* note: hardware bug in daqcard-1200 means pacing cannot
 	 * be independently enabled/disabled for its the two channels */
 	spin_lock_irqsave(&dev->spinlock, flags);
@@ -1616,7 +1661,7 @@ static int labpc_ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 	devpriv->write_byte(devpriv->command2_bits, dev->iobase + COMMAND2_REG);
 	spin_unlock_irqrestore(&dev->spinlock, flags);
 
-	/*  set range */
+	/* set range */
 	if (thisboard->register_layout == labpc_1200_layout) {
 		range = CR_RANGE(insn->chanspec);
 		if (range & AO_RANGE_IS_UNIPOLAR)
@@ -1627,13 +1672,13 @@ static int labpc_ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 		devpriv->write_byte(devpriv->command6_bits,
 				    dev->iobase + COMMAND6_REG);
 	}
-	/*  send data */
+	/* send data */
 	lsb = data[0] & 0xff;
 	msb = (data[0] >> 8) & 0xff;
 	devpriv->write_byte(lsb, dev->iobase + DAC_LSB_REG(channel));
 	devpriv->write_byte(msb, dev->iobase + DAC_MSB_REG(channel));
 
-	/*  remember value for readback */
+	/* remember value for readback */
 	devpriv->ao_value[channel] = data[0];
 
 	return 1;
@@ -1705,14 +1750,14 @@ static unsigned int labpc_suggest_transfer_size(struct comedi_cmd cmd)
 
 	if (cmd.convert_src == TRIG_TIMER)
 		freq = 1000000000 / cmd.convert_arg;
-	/*  return some default value */
+	/* return some default value */
 	else
 		freq = 0xffffffff;
 
-	/*  make buffer fill in no more than 1/3 second */
+	/* make buffer fill in no more than 1/3 second */
 	size = (freq / 3) * sample_size;
 
-	/*  set a minimum and maximum size allowed */
+	/* set a minimum and maximum size allowed */
 	if (size > dma_buffer_size)
 		size = dma_buffer_size - dma_buffer_size % sample_size;
 	else if (size < sample_size)
@@ -1724,13 +1769,21 @@ static unsigned int labpc_suggest_transfer_size(struct comedi_cmd cmd)
 /* figures out what counter values to use based on command */
 static void labpc_adc_timing(struct comedi_device *dev, struct comedi_cmd *cmd)
 {
-	const int max_counter_value = 0x10000;	/*  max value for 16 bit counter in mode 2 */
-	const int min_counter_value = 2;	/*  min value for 16 bit counter in mode 2 */
+	/* max value for 16 bit counter in mode 2 */
+	const int max_counter_value = 0x10000;
+	/* min value for 16 bit counter in mode 2 */
+	const int min_counter_value = 2;
 	unsigned int base_period;
 
-	/*  if both convert and scan triggers are TRIG_TIMER, then they both rely on counter b0 */
+	/*
+	 * if both convert and scan triggers are TRIG_TIMER, then they
+	 * both rely on counter b0
+	 */
 	if (labpc_ai_convert_period(cmd) && labpc_ai_scan_period(cmd)) {
-		/*  pick the lowest b0 divisor value we can (for maximum input clock speed on convert and scan counters) */
+		/*
+		 * pick the lowest b0 divisor value we can (for maximum input
+		 * clock speed on convert and scan counters)
+		 */
 		devpriv->divisor_b0 = (labpc_ai_scan_period(cmd) - 1) /
 		    (LABPC_TIMER_BASE * max_counter_value) + 1;
 		if (devpriv->divisor_b0 < min_counter_value)
@@ -1780,12 +1833,15 @@ static void labpc_adc_timing(struct comedi_device *dev, struct comedi_cmd *cmd)
 					    base_period * devpriv->divisor_a0);
 		labpc_set_ai_scan_period(cmd,
 					 base_period * devpriv->divisor_b1);
-		/*  if only one TRIG_TIMER is used, we can employ the generic cascaded timing functions */
+		/*
+		 * if only one TRIG_TIMER is used, we can employ the generic
+		 * cascaded timing functions
+		 */
 	} else if (labpc_ai_scan_period(cmd)) {
 		unsigned int scan_period;
 
 		scan_period = labpc_ai_scan_period(cmd);
-		/* calculate cascaded counter values that give desired scan timing */
+	/* calculate cascaded counter values that give desired scan timing */
 		i8253_cascade_ns_to_timer_2div(LABPC_TIMER_BASE,
 					       &(devpriv->divisor_b1),
 					       &(devpriv->divisor_b0),
@@ -1796,7 +1852,7 @@ static void labpc_adc_timing(struct comedi_device *dev, struct comedi_cmd *cmd)
 		unsigned int convert_period;
 
 		convert_period = labpc_ai_convert_period(cmd);
-		/* calculate cascaded counter values that give desired conversion timing */
+/* calculate cascaded counter values that give desired conversion timing */
 		i8253_cascade_ns_to_timer_2div(LABPC_TIMER_BASE,
 					       &(devpriv->divisor_a0),
 					       &(devpriv->divisor_b0),
@@ -1864,9 +1920,8 @@ static unsigned int labpc_serial_in(struct comedi_device *dev)
 		udelay(1);
 		devpriv->status2_bits =
 		    devpriv->read_byte(dev->iobase + STATUS2_REG);
-		if (devpriv->status2_bits & EEPROM_OUT_BIT) {
+		if (devpriv->status2_bits & EEPROM_OUT_BIT)
 			value |= 1 << (value_width - i);
-		}
 	}
 
 	return value;
@@ -1876,8 +1931,10 @@ static unsigned int labpc_eeprom_read(struct comedi_device *dev,
 				      unsigned int address)
 {
 	unsigned int value;
-	const int read_instruction = 0x3;	/*  bits to tell eeprom to expect a read */
-	const int write_length = 8;	/*  8 bit write lengths to eeprom */
+	/*  bits to tell eeprom to expect a read */
+	const int read_instruction = 0x3;
+	/*  8 bit write lengths to eeprom */
+	const int write_length = 8;
 
 	/*  enable read/write to eeprom */
 	devpriv->command5_bits &= ~EEPROM_EN_BIT;
-- 
1.6.0.4


--------------080203010107080100020807
Content-Type: text/x-patch;
 name="0002-Staging-comedi-fix-suspect-code-indent-in-ni_labpc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0002-Staging-comedi-fix-suspect-code-indent-in-ni_labpc.patc";
 filename*1="h"

>From 562de120a89f9681691c8adb36c87e020d67df7c Mon Sep 17 00:00:00 2001
From: Stewart Robertson <str@minty7.(none)>
Date: Sun, 21 Feb 2010 11:21:37 +0000
Subject: [PATCH] Staging: comedi: fix suspect code indent in ni_labpc.c
 This is a patch to the ni_labpc.c file that fixes suspect
 code indent for conditional statements found by the checkpatch.pl tool
 Signed-off-by: Stewart Robertson <stewart_r@aliencamel.com>

---
 drivers/staging/comedi/drivers/ni_labpc.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index a602278..3f55a4d 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -629,8 +629,11 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 	/* analog output */
 	s = dev->subdevices + 1;
 	if (thisboard->has_ao) {
-/* Could provide command support, except it only has a one sample
- * hardware buffer for analog output and no underrun flag. */
+		/*
+		 * Could provide command support, except it only has a
+		 * one sample hardware buffer for analog output and no
+		 * underrun flag.
+		 */
 		s->type = COMEDI_SUBD_AO;
 		s->subdev_flags = SDF_READABLE | SDF_WRITABLE | SDF_GROUND;
 		s->n_chan = NUM_AO_CHAN;
@@ -1407,7 +1410,10 @@ static irqreturn_t labpc_interrupt(int irq, void *d)
 	}
 
 	if (devpriv->current_transfer == isa_dma_transfer) {
-	/* if a dma terminal count of external stop trigger has occurred */
+		/*
+		 * if a dma terminal count of external stop trigger
+		 * has occurred
+		 */
 		if (devpriv->status1_bits & DMATC_BIT ||
 		    (thisboard->register_layout == labpc_1200_layout
 		     && devpriv->status2_bits & A1_TC_BIT)) {
-- 
1.6.0.4


--------------080203010107080100020807--

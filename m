Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab0BBRQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 12:16:23 -0500
Received: from mail3.uklinux.net ([80.84.72.33]:45110 "EHLO mail3.uklinux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756664Ab0BBRQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 12:16:20 -0500
X-Greylist: delayed 1393 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Feb 2010 12:16:20 EST
Message-ID: <4B685861.1040406@tonyburrows.uklinux.net>
Date: Tue, 02 Feb 2010 16:52:49 +0000
From: tony <tony@tonyburrows.uklinux.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>, Bill Pemberton <wfp5p@virginia.edu>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: braces style patch for drivers/staging/comedi/ni_labpc.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f294b2c0edff5bc5c394b9d0f63d686ef9a06688 Mon Sep 17 00:00:00 2001
From: tony burrows <tony@tonyburrows.com>
Date: Tue, 2 Feb 2010 15:36:19 +0000
Subject: [PATCH 1/2] Staging: comedi: fix brace coding style issues in ni_labpc.c
 This patch fixes all of the brace style warnings found by the
 checkpatch.pl tool
 Signed-off-by: Tony Burrows <tony@tonyburrows.com>

---
 drivers/staging/comedi/drivers/ni_labpc.c |   36 ++++++++++++-----------------
 1 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index dc3f398..e60f43a 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -483,12 +483,10 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 
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
@@ -585,8 +583,9 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 	/* analog output */
 	s = dev->subdevices + 1;
 	if (thisboard->has_ao) {
-/* Could provide command support, except it only has a one sample
- * hardware buffer for analog output and no underrun flag. */
+		/* Could provide command support, except it only has a
+		 * one sample hardware buffer for analog output and no
+		 * underrun flag. */
 		s->type = COMEDI_SUBD_AO;
 		s->subdev_flags = SDF_READABLE | SDF_WRITABLE | SDF_GROUND;
 		s->n_chan = NUM_AO_CHAN;
@@ -608,7 +607,8 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 
 	/* 8255 dio */
 	s = dev->subdevices + 2;
-	/*  if board uses io memory we have to give a custom callback function to the 8255 driver */
+	/*  if board uses io memory we have to give a custom callback
+	 * function to the 8255 driver */
 	if (thisboard->memory_mapped_io)
 		subdev_8255_init(dev, s, labpc_dio_mem_callback,
 				 (unsigned long)(dev->iobase + DIO_BASE_REG));
@@ -640,14 +640,12 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
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
@@ -679,9 +677,8 @@ static int labpc_attach(struct comedi_device *dev, struct comedi_devconfig *it)
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
@@ -1008,9 +1005,9 @@ static int labpc_ai_cmdtest(struct comedi_device *dev,
 		err++;
 	}
 
-	if (!cmd->chanlist_len) {
+	if (!cmd->chanlist_len)
 		err++;
-	}
+
 	if (cmd->scan_end_arg != cmd->chanlist_len) {
 		cmd->scan_end_arg = cmd->chanlist_len;
 		err++;
@@ -1105,9 +1102,8 @@ static int labpc_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	devpriv->write_byte(devpriv->command3_bits, dev->iobase + COMMAND3_REG);
 
 	/*  initialize software conversion count */
-	if (cmd->stop_src == TRIG_COUNT) {
+	if (cmd->stop_src == TRIG_COUNT)
 		devpriv->count = cmd->stop_arg * cmd->chanlist_len;
-	}
 	/*  setup hardware conversion counter */
 	if (cmd->stop_src == TRIG_EXT) {
 		/*  load counter a1 with count of 3 (pc+ manual says this is minimum allowed) using mode 0 */
@@ -1479,9 +1475,8 @@ static void labpc_drain_dma(struct comedi_device *dev)
 	}
 
 	/* write data to comedi buffer */
-	for (i = 0; i < num_points; i++) {
+	for (i = 0; i < num_points; i++)
 		cfc_write_to_buffer(s, devpriv->dma_buffer[i]);
-	}
 	if (async->cmd.stop_src == TRIG_COUNT)
 		devpriv->count -= num_points;
 
@@ -1864,9 +1859,8 @@ static unsigned int labpc_serial_in(struct comedi_device *dev)
 		udelay(1);
 		devpriv->status2_bits =
 		    devpriv->read_byte(dev->iobase + STATUS2_REG);
-		if (devpriv->status2_bits & EEPROM_OUT_BIT) {
+		if (devpriv->status2_bits & EEPROM_OUT_BIT)
 			value |= 1 << (value_width - i);
-		}
 	}
 
 	return value;

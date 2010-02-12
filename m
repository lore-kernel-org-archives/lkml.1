Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab0BLXFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 18:05:50 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:36820 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223Ab0BLXFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 18:05:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=BPGd3CHqeXAtkoi8ikNKIyBybBCFoodfHwM8ZNiusRGuhAx/403KvWWhqYqoHA5IuW
         eVOjYan7kwL9FrvKH3P52b1yEYuEQF+MKcro/IEnngleOTG3JtLv7OIcFdpClc67xBvo
         EhMk+BchIH4vX7JL2ClIpRRWMbB3Z/1Id43OQ=
From: Graham M Howe <gman.1352@googlemail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Staging: comedi: fix bracing and 80 character stylein ni_at_a2150.c This is a patch to the ni_at_a2150.c file to fix up bracing and 80 character warnings  found by the checkpatch.pl tool Signed-off-by: Graham M Howe <gman.1352@googlemail.com>
Date: Fri, 12 Feb 2010 23:05:37 +0000
Message-Id: <1266015937-3532-1-git-send-email-user@graham-eeepc>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: root <root@graham-eeepc.(none)>

---
 drivers/staging/comedi/drivers/ni_at_a2150.c |   78 ++++++++++++++------------
 1 files changed, 43 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_at_a2150.c b/drivers/staging/comedi/drivers/ni_at_a2150.c
index dd75dfb..4828e9d 100644
--- a/drivers/staging/comedi/drivers/ni_at_a2150.c
+++ b/drivers/staging/comedi/drivers/ni_at_a2150.c
@@ -86,8 +86,10 @@ TRIG_WAKE_EOS
 #define   CLOCK_SELECT_BITS(x)		(((x) & 0x3) << 3)
 #define   CLOCK_DIVISOR_BITS(x)		(((x) & 0x3) << 5)
 #define   CLOCK_MASK		(0xf << 3)
-#define   ENABLE0_BIT		0x80	/*  enable (don't internally ground) channels 0 and 1 */
-#define   ENABLE1_BIT		0x100	/*  enable (don't internally ground) channels 2 and 3 */
+/*  enable (don't internally ground) channels 0 and 1 */
+#define   ENABLE0_BIT		0x80
+/*  enable (don't internally ground) channels 2 and 3 */
+#define   ENABLE1_BIT		0x100
 #define   AC0_BIT		0x200	/*  ac couple channels 0,1 */
 #define   AC1_BIT		0x400	/*  ac couple channels 2,3 */
 #define   APD_BIT		0x800	/*  analog power down */
@@ -99,26 +101,29 @@ TRIG_WAKE_EOS
 #define FIFO_START_REG		0x6	/*  software start aquistion trigger */
 #define FIFO_RESET_REG		0x8	/*  clears fifo + fifo flags */
 #define FIFO_DATA_REG		0xa	/*  read data */
-#define DMA_TC_CLEAR_REG		0xe	/*  clear dma terminal count interrupt */
+#define DMA_TC_CLEAR_REG	0xe	/* clear dma terminal count interrupt*/
 #define STATUS_REG		0x12	/*  read only */
 #define   FNE_BIT		0x1	/*  fifo not empty */
 #define   OVFL_BIT		0x8	/*  fifo overflow */
 #define   EDAQ_BIT		0x10	/*  end of aquisition interrupt */
 #define   DCAL_BIT		0x20	/*  offset calibration in progress */
 #define   INTR_BIT		0x40	/*  interrupt has occured */
-#define   DMA_TC_BIT		0x80	/*  dma terminal count interrupt has occured */
+#define   DMA_TC_BIT		0x80	/*  dma terminal count interrupt
+							has occured */
 #define   ID_BITS(x)	(((x) >> 8) & 0x3)
 #define IRQ_DMA_CNTRL_REG		0x12	/*  write only */
 #define   DMA_CHAN_BITS(x)		((x) & 0x7)	/*  sets dma channel */
 #define   DMA_EN_BIT		0x8	/*  enables dma */
-#define   IRQ_LVL_BITS(x)		(((x) & 0xf) << 4)	/*  sets irq level */
+#define   IRQ_LVL_BITS(x)		(((x) & 0xf) << 4) /*  sets irq level*/
 #define   FIFO_INTR_EN_BIT		0x100	/*  enable fifo interrupts */
 #define   FIFO_INTR_FHF_BIT		0x200	/*  interrupt fifo half full */
-#define   DMA_INTR_EN_BIT 		0x800	/*  enable interrupt on dma terminal count */
+#define   DMA_INTR_EN_BIT 		0x800	/*  enable interrupt on dma
+							terminal count */
 #define   DMA_DEM_EN_BIT	0x1000	/*  enables demand mode dma */
 #define I8253_BASE_REG		0x14
 #define I8253_MODE_REG		0x17
-#define   HW_COUNT_DISABLE		0x30	/*  disable hardware counting of conversions */
+#define   HW_COUNT_DISABLE	0x30	/*  disable hardware counting of
+							conversions */

 struct a2150_board {
 	const char *name;
@@ -158,8 +163,8 @@ static const struct a2150_board a2150_boards[] = {
 #define thisboard ((const struct a2150_board *)dev->board_ptr)

 struct a2150_private {
-
-	volatile unsigned int count;	/* number of data points left to be taken */
+	/* number of data points left to be taken */
+	volatile unsigned int count;
 	unsigned int dma;	/*  dma channel */
 	s16 *dma_buffer;	/*  dma buffer */
 	unsigned int dma_transfer_size;	/*  size in bytes of dma transfers */
@@ -336,16 +341,16 @@ static int a2150_attach(struct comedi_device *dev, struct comedi_devconfig *it)

 	printk("comedi%d: %s: io 0x%lx", dev->minor, driver_a2150.driver_name,
 	       iobase);
-	if (irq) {
+	if (irq)
 		printk(", irq %u", irq);
-	} else {
+	 else
 		printk(", no irq");
-	}
-	if (dma) {
+
+	if (dma)
 		printk(", dma %u", dma);
-	} else {
+	 else
 		printk(", no dma");
-	}
+
 	printk("\n");

 	/* allocate and initialize dev->private */
@@ -527,7 +532,8 @@ static int a2150_ai_cmdtest(struct comedi_device *dev,
 	if (err)
 		return 1;

-	/* step 2: make sure trigger sources are unique and mutually compatible */
+	/* step 2: make sure trigger sources are unique
+				and mutually compatible */

 	if (cmd->start_src != TRIG_NOW && cmd->start_src != TRIG_EXT)
 		err++;
@@ -590,13 +596,13 @@ static int a2150_ai_cmdtest(struct comedi_device *dev,
 		for (i = 1; i < cmd->chanlist_len; i++) {
 			if (CR_CHAN(cmd->chanlist[i]) != (startChan + i)) {
 				comedi_error(dev,
-					     "entries in chanlist must be consecutive channels, counting upwards\n");
+       "entries in chanlist must be consecutive channels, counting upwards\n");
 				err++;
 			}
 		}
 		if (cmd->chanlist_len == 2 && CR_CHAN(cmd->chanlist[0]) == 1) {
 			comedi_error(dev,
-				     "length 2 chanlist must be channels 0,1 or channels 2,3");
+		"length 2 chanlist must be channels 0,1 or channels 2,3");
 			err++;
 		}
 		if (cmd->chanlist_len == 3) {
@@ -607,7 +613,7 @@ static int a2150_ai_cmdtest(struct comedi_device *dev,
 		if (CR_AREF(cmd->chanlist[0]) != CR_AREF(cmd->chanlist[1]) ||
 		    CR_AREF(cmd->chanlist[2]) != CR_AREF(cmd->chanlist[3])) {
 			comedi_error(dev,
-				     "channels 0/1 and 2/3 must have the same analog reference");
+		vvv"channels 0/1 and 2/3 must have the same analog reference");
 			err++;
 		}
 	}
@@ -628,12 +634,12 @@ static int a2150_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)

 	if (!dev->irq || !devpriv->dma) {
 		comedi_error(dev,
-			     " irq and dma required, cannot do hardware conversions");
+		 " irq and dma required, cannot do hardware conversions");
 		return -1;
 	}
 	if (cmd->flags & TRIG_RT) {
 		comedi_error(dev,
-			     " dma incompatible with hard real-time interrupt (TRIG_RT), aborting");
+	" dma incompatible with hard real-time interrupt (TRIG_RT), aborting");
 		return -1;
 	}
 	/*  clear fifo and reset triggering circuitry */
@@ -712,16 +718,17 @@ static int a2150_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	if (cmd->start_src == TRIG_EXT) {
 		trigger_bits |= HW_TRIG_EN;
 	} else if (cmd->start_src == TRIG_OTHER) {
-		/*  XXX add support for level/slope start trigger using TRIG_OTHER */
+		/*  XXX add support for level/slope start trigger using
+							TRIG_OTHER */
 		comedi_error(dev, "you shouldn't see this?");
 	}
 	/*  send trigger config bits */
 	outw(trigger_bits, dev->iobase + TRIGGER_REG);

 	/*  start aquisition for soft trigger */
-	if (cmd->start_src == TRIG_NOW) {
+	if (cmd->start_src == TRIG_NOW)
 		outw(0, dev->iobase + FIFO_START_REG);
-	}
+
 #ifdef A2150_DEBUG
 	ni_dump_regs(dev);
 #endif
@@ -760,7 +767,8 @@ static int a2150_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 	/*  start aquisition for soft trigger */
 	outw(0, dev->iobase + FIFO_START_REG);

-	/* there is a 35.6 sample delay for data to get through the antialias filter */
+	/* there is a 35.6 sample delay for data to get through the
+						antialias filter */
 	for (n = 0; n < filter_delay; n++) {
 		for (i = 0; i < timeout; i++) {
 			if (inw(dev->iobase + STATUS_REG) & FNE_BIT)
@@ -801,8 +809,8 @@ static int a2150_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 	return n;
 }

-/* sets bits in devpriv->clock_bits to nearest approximation of requested period,
- * adjusts requested period to actual timing. */
+/* sets bits in devpriv->clock_bits to nearest approximation of requested
+period, adjusts requested period to actual timing. */
 static int a2150_get_timing(struct comedi_device *dev, unsigned int *period,
 			    int flags)
 {
@@ -848,11 +856,11 @@ static int a2150_get_timing(struct comedi_device *dev, unsigned int *period,
 	case TRIG_ROUND_NEAREST:
 	default:
 		/*  if least upper bound is better approximation */
-		if (lub - *period < *period - glb) {
+		if (lub - *period < *period - glb)
 			*period = lub;
-		} else {
+		else
 			*period = glb;
-		}
+
 		break;
 	case TRIG_ROUND_UP:
 		*period = lub;
@@ -860,7 +868,7 @@ static int a2150_get_timing(struct comedi_device *dev, unsigned int *period,
 	case TRIG_ROUND_DOWN:
 		*period = glb;
 		break;
-	}
+

 	/*  set clock bits for config register appropriately */
 	devpriv->config_bits &= ~CLOCK_MASK;
@@ -891,13 +899,13 @@ static int a2150_set_chanlist(struct comedi_device *dev,
 		devpriv->config_bits |= CHANNEL_BITS(0x4 | start_channel);
 		break;
 	case 2:
-		if (start_channel == 0) {
+		if (start_channel == 0)
 			devpriv->config_bits |= CHANNEL_BITS(0x2);
-		} else if (start_channel == 2) {
+		else if (start_channel == 2)
 			devpriv->config_bits |= CHANNEL_BITS(0x3);
-		} else {
+		else
 			return -1;
-		}
+
 		break;
 	case 4:
 		devpriv->config_bits |= CHANNEL_BITS(0x1);
--
1.6.3.3


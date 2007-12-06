Return-Path: <linux-kernel-owner+w=401wt.eu-S1754875AbXLFVQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbXLFVQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 16:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbXLFVQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 16:16:06 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:3444 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbXLFVQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 16:16:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:content-transfer-encoding:user-agent;
        b=Iu+rab1knE1hdkelyLqjb7s+Y77/jN9Ng5/LIMmPFR2R7qFaT80nmm640qU8/qRwyIE7nE/ibLtAx9iTD0BpOFHCjQiYH3JbVyqRSrR1IfYi9BoRMIAF1hTK6T0cmX6G9iZ/MrXZvzjABYaBKzKajtSAJt+CVP3oSQ8FRG23hTc=
Date: Thu, 6 Dec 2007 22:16:46 +0100
From: Marcin =?utf-8?Q?=C5=9Alusarz?= <marcin.slusarz@gmail.com>
To: perex@perex.cz
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] via82xx: fix some coding style issues
Message-ID: <20071206211619.GA25851@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix trivial coding style issues found by checkpatch.pl:
- assignments in if conditions
- trailing whitespaces
- lines longer then 80 characters (only a couple of them)
- spaces instead of tabs
- spaces after !
- C99 comments
- other tiny changes

Signed-off-by: Marcin Ślusarz <marcin.slusarz@gmail.com>

(patch against current mainline git, errors count fallen from
 76 to 2 - these are checkpatch bugs I think)

diff --git a/sound/pci/via82xx.c b/sound/pci/via82xx.c
index cf62d2a..c6b68cc 100644
--- a/sound/pci/via82xx.c
+++ b/sound/pci/via82xx.c
@@ -43,7 +43,7 @@
  *	  routines for each chipset.
  *
  * Sep. 26, 2005	Karsten Wiese <annabellesgarden@yahoo.de>
- *	- Optimize position calculation for the 823x chips.
+ *	- Optimize position calculation for the 823x chips.
  */

 #include <sound/driver.h>
@@ -73,7 +73,8 @@ MODULE_DESCRIPTION("VIA VT82xx audio");
 MODULE_LICENSE("GPL");
 MODULE_SUPPORTED_DEVICE("{{VIA,VT82C686A/B/C,pci},{VIA,VT8233A/C,8235}}");

-#if defined(CONFIG_GAMEPORT) || (defined(MODULE) && defined(CONFIG_GAMEPORT_MODULE))
+#if defined(CONFIG_GAMEPORT) || \
+	(defined(MODULE) && defined(CONFIG_GAMEPORT_MODULE))
 #define SUPPORT_JOYSTICK 1
 #endif

@@ -102,7 +103,8 @@ MODULE_PARM_DESC(ac97_clock, "AC'97 codec clock (default 48000Hz).");
 module_param(ac97_quirk, charp, 0444);
 MODULE_PARM_DESC(ac97_quirk, "AC'97 workaround for strange hardware.");
 module_param(dxs_support, int, 0444);
-MODULE_PARM_DESC(dxs_support, "Support for DXS channels (0 = auto, 1 = enable, 2 = disable, 3 = 48k only, 4 = no VRA, 5 = enable any sample rate)");
+MODULE_PARM_DESC(dxs_support, "Support for DXS channels (0 = auto, 1 = enable, "
+	"2 = disable, 3 = 48k only, 4 = no VRA, 5 = enable any sample rate)");

 /* just for backward compatibility */
 static int enable;
@@ -147,7 +149,7 @@ module_param(enable, bool, 0444);
 #define   VIA_REG_CTRL_TERMINATE	0x40	/* WO */
 #define   VIA_REG_CTRL_AUTOSTART	0x20
 #define   VIA_REG_CTRL_PAUSE		0x08	/* RW */
-#define   VIA_REG_CTRL_INT_STOP		0x04
+#define   VIA_REG_CTRL_INT_STOP		0x04
 #define   VIA_REG_CTRL_INT_EOL		0x02
 #define   VIA_REG_CTRL_INT_FLAG		0x01
 #define   VIA_REG_CTRL_RESET		0x01	/* RW - probably reset? undocumented */
@@ -319,7 +321,7 @@ struct viadev {
 	unsigned int reg_offset;
 	unsigned long port;
 	int direction;	/* playback = 0, capture = 1 */
-        struct snd_pcm_substream *substream;
+	struct snd_pcm_substream *substream;
 	int running;
 	unsigned int tbl_entries; /* # descriptors */
 	struct snd_dma_buffer table;
@@ -432,9 +434,9 @@ static int build_via_table(struct viadev *dev, struct snd_pcm_substream *substre
 					&dev->table) < 0)
 			return -ENOMEM;
 	}
-	if (! dev->idx_table) {
+	if (!dev->idx_table) {
 		dev->idx_table = kmalloc(sizeof(*dev->idx_table) * VIA_TABLE_SIZE, GFP_KERNEL);
-		if (! dev->idx_table)
+		if (!dev->idx_table)
 			return -ENOMEM;
 	}

@@ -460,14 +462,14 @@ static int build_via_table(struct viadev *dev, struct snd_pcm_substream *substre
 			if (rest < r)
 				r = rest;
 			rest -= r;
-			if (! rest) {
+			if (!rest) {
 				if (i == periods - 1)
 					flag = VIA_TBL_BIT_EOL; /* buffer boundary */
 				else
 					flag = VIA_TBL_BIT_FLAG; /* period boundary */
 			} else
 				flag = 0; /* period continues to the next */
-			// printk("via: tbl %d: at %d  size %d (rest %d)\n", idx, ofs, r, rest);
+			/* printk("via: tbl %d: at %d  size %d (rest %d)\n", idx, ofs, r, rest); */
 			((u32 *)dev->table.area)[(idx<<1) + 1] = cpu_to_le32(r | flag);
 			dev->idx_table[idx].offset = ofs;
 			dev->idx_table[idx].size = r;
@@ -503,34 +505,35 @@ static inline unsigned int snd_via82xx_codec_xread(struct via82xx *chip)
 {
 	return inl(VIAREG(chip, AC97));
 }
-
+
 static inline void snd_via82xx_codec_xwrite(struct via82xx *chip, unsigned int val)
 {
 	outl(val, VIAREG(chip, AC97));
 }
-
+
 static int snd_via82xx_codec_ready(struct via82xx *chip, int secondary)
 {
 	unsigned int timeout = 1000;	/* 1ms */
 	unsigned int val;
-
+
 	while (timeout-- > 0) {
 		udelay(1);
-		if (!((val = snd_via82xx_codec_xread(chip)) & VIA_REG_AC97_BUSY))
+		val = snd_via82xx_codec_xread(chip);
+		if (!(val & VIA_REG_AC97_BUSY))
 			return val & 0xffff;
 	}
 	snd_printk(KERN_ERR "codec_ready: codec %i is not ready [0x%x]\n",
 		   secondary, snd_via82xx_codec_xread(chip));
 	return -EIO;
 }
-
+
 static int snd_via82xx_codec_valid(struct via82xx *chip, int secondary)
 {
 	unsigned int timeout = 1000;	/* 1ms */
 	unsigned int val, val1;
 	unsigned int stat = !secondary ? VIA_REG_AC97_PRIMARY_VALID :
 					 VIA_REG_AC97_SECONDARY_VALID;
-
+
 	while (timeout-- > 0) {
 		val = snd_via82xx_codec_xread(chip);
 		val1 = val & (VIA_REG_AC97_BUSY | stat);
@@ -540,7 +543,7 @@ static int snd_via82xx_codec_valid(struct via82xx *chip, int secondary)
 	}
 	return -EIO;
 }
-
+
 static void snd_via82xx_codec_wait(struct snd_ac97 *ac97)
 {
 	struct via82xx *chip = ac97->private_data;
@@ -575,14 +578,14 @@ static unsigned short snd_via82xx_codec_read(struct snd_ac97 *ac97, unsigned sho
 	xval |= ac97->num ? VIA_REG_AC97_SECONDARY_VALID : VIA_REG_AC97_PRIMARY_VALID;
 	xval |= VIA_REG_AC97_READ;
 	xval |= (reg & 0x7f) << VIA_REG_AC97_CMD_SHIFT;
-      	while (1) {
-      		if (again++ > 3) {
+	while (1) {
+		if (again++ > 3) {
 			snd_printk(KERN_ERR "codec_read: codec %i is not valid [0x%x]\n",
 				   ac97->num, snd_via82xx_codec_xread(chip));
-		      	return 0xffff;
+			return 0xffff;
 		}
 		snd_via82xx_codec_xwrite(chip, xval);
-		udelay (20);
+		udelay(20);
 		if (snd_via82xx_codec_valid(chip, ac97->num) >= 0) {
 			udelay(25);
 			val = snd_via82xx_codec_xread(chip);
@@ -603,7 +606,7 @@ static void snd_via82xx_channel_reset(struct via82xx *chip, struct viadev *viade
 	/* clear interrupts */
 	outb(0x03, VIADEV_REG(viadev, OFFSET_STATUS));
 	outb(0x00, VIADEV_REG(viadev, OFFSET_TYPE)); /* for via686 */
-	// outl(0, VIADEV_REG(viadev, OFFSET_CURR_PTR));
+	/* outl(0, VIADEV_REG(viadev, OFFSET_CURR_PTR)); */
 	viadev->lastpos = 0;
 	viadev->hwptr_done = 0;
 }
@@ -620,7 +623,7 @@ static irqreturn_t snd_via686_interrupt(int irq, void *dev_id)
 	unsigned int i;

 	status = inl(VIAREG(chip, SGD_SHADOW));
-	if (! (status & chip->intr_mask)) {
+	if (!(status & chip->intr_mask)) {
 		if (chip->rmidi)
 			/* check mpu401 interrupt */
 			return snd_mpu401_uart_interrupt(irq, chip->rmidi->private_data);
@@ -632,12 +635,12 @@ static irqreturn_t snd_via686_interrupt(int irq, void *dev_id)
 	for (i = 0; i < chip->num_devs; i++) {
 		struct viadev *viadev = &chip->devs[i];
 		unsigned char c_status = inb(VIADEV_REG(viadev, OFFSET_STATUS));
-		if (! (c_status & (VIA_REG_STAT_EOL|VIA_REG_STAT_FLAG|VIA_REG_STAT_STOPPED)))
+		if (!(c_status & (VIA_REG_STAT_EOL|VIA_REG_STAT_FLAG|VIA_REG_STAT_STOPPED)))
 			continue;
 		if (viadev->substream && viadev->running) {
 			/*
 			 * Update hwptr_done based on 'period elapsed'
-			 * interrupts. We'll use it, when the chip returns 0
+			 * interrupts. We'll use it, when the chip returns 0
 			 * for OFFSET_CURR_COUNT.
 			 */
 			if (c_status & VIA_REG_STAT_EOL)
@@ -686,7 +689,7 @@ static irqreturn_t snd_via8233_interrupt(int irq, void *dev_id)
 		if (substream && viadev->running) {
 			/*
 			 * Update hwptr_done based on 'period elapsed'
-			 * interrupts. We'll use it, when the chip returns 0
+			 * interrupts. We'll use it, when the chip returns 0
 			 * for OFFSET_CURR_COUNT.
 			 */
 			if (c_status & VIA_REG_STAT_EOL)
@@ -784,7 +787,7 @@ static inline unsigned int calc_linear_pos(struct viadev *viadev, unsigned int i
 			   (int)size, (int)count);
 		res = viadev->lastpos;
 	} else {
-		if (! count) {
+		if (!count) {
 			/* Some mobos report count = 0 on the DMA boundary,
 			 * i.e. count = size indeed.
 			 * Let's check whether this step is above the expected size.
@@ -855,7 +858,7 @@ static snd_pcm_uframes_t snd_via8233_pcm_pointer(struct snd_pcm_substream *subst
 	struct viadev *viadev = substream->runtime->private_data;
 	unsigned int idx, count, res;
 	int status;
-
+
 	snd_assert(viadev->tbl_entries, return 0);

 	spin_lock(&chip->reg_lock);
@@ -864,7 +867,7 @@ static snd_pcm_uframes_t snd_via8233_pcm_pointer(struct snd_pcm_substream *subst
 	if (!status)
 		status = inb(VIADEV_REG(viadev, OFFSET_STATUS));

-	/* An apparent bug in the 8251 is worked around by sending a
+	/* An apparent bug in the 8251 is worked around by sending a
 	 * REG_CTRL_START. */
 	if (chip->revision == VIA_REV_8251 && (status & VIA_REG_STAT_EOL))
 		snd_via82xx_pcm_trigger(substream, SNDRV_PCM_TRIGGER_START);
@@ -888,14 +891,12 @@ static snd_pcm_uframes_t snd_via8233_pcm_pointer(struct snd_pcm_substream *subst
 	} else {
 		res = viadev->hwptr_done;
 		if (!viadev->in_interrupt) {
-			if (status & VIA_REG_STAT_EOL) {
+			if (status & VIA_REG_STAT_EOL)
 				res = 0;
-			} else
-				if (status & VIA_REG_STAT_FLAG) {
-					res += viadev->fragsize;
-				}
+			else if (status & VIA_REG_STAT_FLAG)
+				res += viadev->fragsize;
 		}
-	}
+	}
 unlock:
 	viadev->lastpos = res;
 	spin_unlock(&chip->reg_lock);
@@ -1025,7 +1026,8 @@ static int snd_via8233_playback_prepare(struct snd_pcm_substream *substream)
 	int rate_changed;
 	u32 rbits;

-	if ((rate_changed = via_lock_rate(&chip->rates[0], ac97_rate)) < 0)
+	rate_changed = via_lock_rate(&chip->rates[0], ac97_rate);
+	if (rate_changed < 0)
 		return rate_changed;
 	if (rate_changed)
 		snd_ac97_set_rate(chip->ac97, AC97_PCM_FRONT_DAC_RATE,
@@ -1132,8 +1134,7 @@ static int snd_via8233_capture_prepare(struct snd_pcm_substream *substream)
 /*
  * pcm hardware definition, identical for both playback and capture
  */
-static struct snd_pcm_hardware snd_via82xx_hw =
-{
+static struct snd_pcm_hardware snd_via82xx_hw = {
 	.info =			(SNDRV_PCM_INFO_MMAP | SNDRV_PCM_INFO_INTERLEAVED |
 				 SNDRV_PCM_INFO_BLOCK_TRANSFER |
 				 SNDRV_PCM_INFO_MMAP_VALID |
@@ -1165,7 +1166,7 @@ static int snd_via82xx_pcm_open(struct via82xx *chip, struct viadev *viadev,
 	struct via_rate_lock *ratep;

 	runtime->hw = snd_via82xx_hw;
-
+
 	/* set the hw rate condition */
 	ratep = &chip->rates[viadev->direction];
 	spin_lock_irq(&ratep->lock);
@@ -1184,7 +1185,7 @@ static int snd_via82xx_pcm_open(struct via82xx *chip, struct viadev *viadev,
 				     SNDRV_PCM_RATE_8000_48000);
 		runtime->hw.rate_min = 8000;
 		runtime->hw.rate_max = 48000;
-	} else if (! ratep->rate) {
+	} else if (!ratep->rate) {
 		int idx = viadev->direction ? AC97_RATES_ADC : AC97_RATES_FRONT_DAC;
 		runtime->hw.rates = chip->ac97->rates[idx];
 		snd_pcm_limit_hw_rates(runtime);
@@ -1197,7 +1198,8 @@ static int snd_via82xx_pcm_open(struct via82xx *chip, struct viadev *viadev,

 	/* we may remove following constaint when we modify table entries
 	   in interrupt */
-	if ((err = snd_pcm_hw_constraint_integer(runtime, SNDRV_PCM_HW_PARAM_PERIODS)) < 0)
+	err = snd_pcm_hw_constraint_integer(runtime, SNDRV_PCM_HW_PARAM_PERIODS);
+	if (err < 0)
 		return err;

 	runtime->private_data = viadev;
@@ -1216,7 +1218,8 @@ static int snd_via82xx_playback_open(struct snd_pcm_substream *substream)
 	struct viadev *viadev = &chip->devs[chip->playback_devno + substream->number];
 	int err;

-	if ((err = snd_via82xx_pcm_open(chip, viadev, substream)) < 0)
+	err = snd_via82xx_pcm_open(chip, viadev, substream);
+	if (err < 0)
 		return err;
 	return 0;
 }
@@ -1241,7 +1244,8 @@ static int snd_via8233_multi_open(struct snd_pcm_substream *substream)
 		.mask = 0,
 	};

-	if ((err = snd_via82xx_pcm_open(chip, viadev, substream)) < 0)
+	err = snd_via82xx_pcm_open(chip, viadev, substream);
+	if (err < 0)
 		return err;
 	substream->runtime->hw.channels_max = 6;
 	if (chip->revision == VIA_REV_8233A)
@@ -1275,11 +1279,11 @@ static int snd_via82xx_pcm_close(struct snd_pcm_substream *substream)
 	ratep = &chip->rates[viadev->direction];
 	spin_lock_irq(&ratep->lock);
 	ratep->used--;
-	if (! ratep->used)
+	if (!ratep->used)
 		ratep->rate = 0;
 	spin_unlock_irq(&ratep->lock);
-	if (! ratep->rate) {
-		if (! viadev->direction) {
+	if (!ratep->rate) {
+		if (!viadev->direction) {
 			snd_ac97_update_power(chip->ac97,
 					      AC97_PCM_FRONT_DAC_RATE, 0);
 			snd_ac97_update_power(chip->ac97,
@@ -1399,9 +1403,10 @@ static int __devinit snd_via8233_pcm_new(struct via82xx *chip)
 	/* capture */
 	init_viadev(chip, chip->capture_devno, VIA_REG_CAPTURE_8233_STATUS, 6, 1);

-	if ((err = snd_pcm_lib_preallocate_pages_for_all(pcm, SNDRV_DMA_TYPE_DEV_SG,
-							 snd_dma_pci_data(chip->pci),
-							 64*1024, 128*1024)) < 0)
+	err = snd_pcm_lib_preallocate_pages_for_all(pcm, SNDRV_DMA_TYPE_DEV_SG,
+						    snd_dma_pci_data(chip->pci),
+						    64*1024, 128*1024);
+	if (err < 0)
 		return err;

 	/* PCM #1:  multi-channel playback and 2nd capture */
@@ -1418,9 +1423,10 @@ static int __devinit snd_via8233_pcm_new(struct via82xx *chip)
 	/* set up capture */
 	init_viadev(chip, chip->capture_devno + 1, VIA_REG_CAPTURE_8233_STATUS + 0x10, 7, 1);

-	if ((err = snd_pcm_lib_preallocate_pages_for_all(pcm, SNDRV_DMA_TYPE_DEV_SG,
-						         snd_dma_pci_data(chip->pci),
-							 64*1024, 128*1024)) < 0)
+	err = snd_pcm_lib_preallocate_pages_for_all(pcm, SNDRV_DMA_TYPE_DEV_SG,
+						    snd_dma_pci_data(chip->pci),
+						    64*1024, 128*1024);
+	if (err < 0)
 		return err;

 	return 0;
@@ -1454,13 +1460,14 @@ static int __devinit snd_via8233a_pcm_new(struct via82xx *chip)
 	/* capture */
 	init_viadev(chip, chip->capture_devno, VIA_REG_CAPTURE_8233_STATUS, 6, 1);

-	if ((err = snd_pcm_lib_preallocate_pages_for_all(pcm, SNDRV_DMA_TYPE_DEV_SG,
-							 snd_dma_pci_data(chip->pci),
-							 64*1024, 128*1024)) < 0)
+	err = snd_pcm_lib_preallocate_pages_for_all(pcm, SNDRV_DMA_TYPE_DEV_SG,
+						    snd_dma_pci_data(chip->pci),
+						    64*1024, 128*1024);
+	if (err < 0)
 		return err;

 	/* SPDIF supported? */
-	if (! ac97_can_spdif(chip->ac97))
+	if (!ac97_can_spdif(chip->ac97))
 		return 0;

 	/* PCM #1:  DXS3 playback (for spdif) */
@@ -1474,9 +1481,10 @@ static int __devinit snd_via8233a_pcm_new(struct via82xx *chip)
 	/* set up playback */
 	init_viadev(chip, chip->playback_devno, 0x30, 3, 0);

-	if ((err = snd_pcm_lib_preallocate_pages_for_all(pcm, SNDRV_DMA_TYPE_DEV_SG,
-							 snd_dma_pci_data(chip->pci),
-							 64*1024, 128*1024)) < 0)
+	err = snd_pcm_lib_preallocate_pages_for_all(pcm, SNDRV_DMA_TYPE_DEV_SG,
+						    snd_dma_pci_data(chip->pci),
+						    64*1024, 128*1024);
+	if (err < 0)
 		return err;

 	return 0;
@@ -1506,9 +1514,10 @@ static int __devinit snd_via686_pcm_new(struct via82xx *chip)
 	init_viadev(chip, 0, VIA_REG_PLAYBACK_STATUS, 0, 0);
 	init_viadev(chip, 1, VIA_REG_CAPTURE_STATUS, 0, 1);

-	if ((err = snd_pcm_lib_preallocate_pages_for_all(pcm, SNDRV_DMA_TYPE_DEV_SG,
-							 snd_dma_pci_data(chip->pci),
-							 64*1024, 128*1024)) < 0)
+	err = snd_pcm_lib_preallocate_pages_for_all(pcm, SNDRV_DMA_TYPE_DEV_SG,
+						    snd_dma_pci_data(chip->pci),
+						    64*1024, 128*1024);
+	if (err < 0)
 		return err;

 	return 0;
@@ -1605,7 +1614,7 @@ static int snd_via8233_dxs3_spdif_put(struct snd_kcontrol *kcontrol,
 }

 static struct snd_kcontrol_new snd_via8233_dxs3_spdif_control __devinitdata = {
-	.name = SNDRV_CTL_NAME_IEC958("Output ",NONE,SWITCH),
+	.name = SNDRV_CTL_NAME_IEC958("Output ", NONE, SWITCH),
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.info = snd_via8233_dxs3_spdif_info,
 	.get = snd_via8233_dxs3_spdif_get,
@@ -1806,7 +1815,8 @@ static int __devinit snd_via82xx_mixer_new(struct via82xx *chip, const char *qui
 		.wait = snd_via82xx_codec_wait,
 	};

-	if ((err = snd_ac97_bus(chip->card, 0, &ops, chip, &chip->ac97_bus)) < 0)
+	err = snd_ac97_bus(chip->card, 0, &ops, chip, &chip->ac97_bus);
+	if (err < 0)
 		return err;
 	chip->ac97_bus->private_free = snd_via82xx_mixer_free_ac97_bus;
 	chip->ac97_bus->clock = chip->ac97_clock;
@@ -1816,7 +1826,8 @@ static int __devinit snd_via82xx_mixer_new(struct via82xx *chip, const char *qui
 	ac97.private_free = snd_via82xx_mixer_free_ac97;
 	ac97.pci = chip->pci;
 	ac97.scaps = AC97_SCAP_SKIP_MODEM | AC97_SCAP_POWER_SAVE;
-	if ((err = snd_ac97_mixer(chip->ac97_bus, &ac97, &chip->ac97)) < 0)
+	err = snd_ac97_mixer(chip->ac97_bus, &ac97, &chip->ac97);
+	if (err < 0)
 		return err;

 	snd_ac97_tune_hardware(chip->ac97, ac97_quirks, quirk_override);
@@ -1916,14 +1927,12 @@ static int __devinit snd_via8233_init_misc(struct via82xx *chip)
 		memset(&sid, 0, sizeof(sid));
 		strcpy(sid.name, "PCM Playback Volume");
 		sid.iface = SNDRV_CTL_ELEM_IFACE_MIXER;
-		if (! snd_ctl_find_id(chip->card, &sid)) {
+		if (!snd_ctl_find_id(chip->card, &sid)) {
 			snd_printd(KERN_INFO "Using DXS as PCM Playback\n");
 			err = snd_ctl_add(chip->card, snd_ctl_new1(&snd_via8233_pcmdxs_volume_control, chip));
 			if (err < 0)
 				return err;
-		}
-		else /* Using DXS when PCM emulation is enabled is really weird */
-		{
+		} else {/* Using DXS when PCM emulation is enabled is really weird */
 			/* Standalone DXS controls */
 			err = snd_ctl_add(chip->card, snd_ctl_new1(&snd_via8233_dxs_volume_control, chip));
 			if (err < 0)
@@ -2021,18 +2030,17 @@ static void snd_via82xx_proc_read(struct snd_info_entry *entry,
 {
 	struct via82xx *chip = entry->private_data;
 	int i;
-
+
 	snd_iprintf(buffer, "%s\n\n", chip->card->longname);
-	for (i = 0; i < 0xa0; i += 4) {
+	for (i = 0; i < 0xa0; i += 4)
 		snd_iprintf(buffer, "%02x: %08x\n", i, inl(chip->port + i));
-	}
 }

 static void __devinit snd_via82xx_proc_init(struct via82xx *chip)
 {
 	struct snd_info_entry *entry;

-	if (! snd_card_proc_new(chip->card, "via82xx", &entry))
+	if (!snd_card_proc_new(chip->card, "via82xx", &entry))
 		snd_info_set_text_ops(entry, chip, snd_via82xx_proc_read);
 }

@@ -2052,7 +2060,7 @@ static int snd_via82xx_chip_init(struct via82xx *chip)
 		pci_write_config_byte(chip->pci, VIA_FUNC_ENABLE, 0);
 #endif
 	pci_read_config_byte(chip->pci, VIA_ACLINK_STAT, &pval);
-	if (! (pval & VIA_ACLINK_C00_READY)) { /* codec not ready? */
+	if (!(pval & VIA_ACLINK_C00_READY)) { /* codec not ready? */
 		/* deassert ACLink reset, force SYNC */
 		pci_write_config_byte(chip->pci, VIA_ACLINK_CTRL,
 				      VIA_ACLINK_CTRL_ENABLE |
@@ -2073,7 +2081,7 @@ static int snd_via82xx_chip_init(struct via82xx *chip)
 		pci_write_config_byte(chip->pci, VIA_ACLINK_CTRL, VIA_ACLINK_CTRL_INIT);
 		udelay(100);
 	}
-
+
 	/* Make sure VRA is enabled, in case we didn't do a
 	 * complete codec reset, above */
 	pci_read_config_byte(chip->pci, VIA_ACLINK_CTRL, &pval);
@@ -2093,7 +2101,8 @@ static int snd_via82xx_chip_init(struct via82xx *chip)
 		schedule_timeout_uninterruptible(1);
 	} while (time_before(jiffies, end_time));

-	if ((val = snd_via82xx_codec_xread(chip)) & VIA_REG_AC97_BUSY)
+	val = snd_via82xx_codec_xread(chip);
+	if (val & VIA_REG_AC97_BUSY)
 		snd_printk(KERN_ERR "AC'97 codec is not ready [0x%x]\n", val);

 #if 0 /* FIXME: we don't support the second codec yet so skip the detection now.. */
@@ -2105,7 +2114,8 @@ static int snd_via82xx_chip_init(struct via82xx *chip)
 				 VIA_REG_AC97_SECONDARY_VALID |
 				 (VIA_REG_AC97_CODEC_ID_SECONDARY << VIA_REG_AC97_CODEC_ID_SHIFT));
 	do {
-		if ((val = snd_via82xx_codec_xread(chip)) & VIA_REG_AC97_SECONDARY_VALID) {
+		val = snd_via82xx_codec_xread(chip);
+		if (val & VIA_REG_AC97_SECONDARY_VALID) {
 			chip->ac97_secondary = 1;
 			goto __ac97_ok2;
 		}
@@ -2113,7 +2123,7 @@ static int snd_via82xx_chip_init(struct via82xx *chip)
 	} while (time_before(jiffies, end_time));
 	/* This is ok, the most of motherboards have only one codec */

-      __ac97_ok2:
+__ac97_ok2:
 #endif

 	if (chip->chip_type == TYPE_VIA686) {
@@ -2142,7 +2152,7 @@ static int snd_via82xx_chip_init(struct via82xx *chip)
 		for (idx = 0; idx < 4; idx++) {
 			unsigned long port = chip->port + 0x10 * idx;
 			for (i = 0; i < 2; i++) {
-				chip->playback_volume[idx][i]=chip->playback_volume_c[i];
+				chip->playback_volume[idx][i] = chip->playback_volume_c[i];
 				outb(chip->playback_volume_c[i],
 				     port + VIA_REG_OFS_PLAYBACK_VOLUME_L + i);
 			}
@@ -2232,7 +2242,7 @@ static int snd_via82xx_free(struct via82xx *chip)
 	for (i = 0; i < chip->num_devs; i++)
 		snd_via82xx_channel_reset(chip, &chip->devs[i]);
 	synchronize_irq(chip->irq);
-      __end_hw:
+__end_hw:
 	if (chip->irq >= 0)
 		free_irq(chip->irq, chip);
 	release_and_free_resource(chip->mpu_res);
@@ -2259,18 +2269,20 @@ static int __devinit snd_via82xx_create(struct snd_card *card,
 					int chip_type,
 					int revision,
 					unsigned int ac97_clock,
-					struct via82xx ** r_via)
+					struct via82xx **r_via)
 {
 	struct via82xx *chip;
 	int err;
-        static struct snd_device_ops ops = {
+	static struct snd_device_ops ops = {
 		.dev_free =	snd_via82xx_dev_free,
-        };
+	};

-	if ((err = pci_enable_device(pci)) < 0)
+	err = pci_enable_device(pci);
+	if (err < 0)
 		return err;

-	if ((chip = kzalloc(sizeof(*chip), GFP_KERNEL)) == NULL) {
+	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+	if (chip == NULL) {
 		pci_disable_device(pci);
 		return -ENOMEM;
 	}
@@ -2290,7 +2302,8 @@ static int __devinit snd_via82xx_create(struct snd_card *card,
 	pci_write_config_byte(chip->pci, VIA_FUNC_ENABLE,
 			      chip->old_legacy & ~(VIA_FUNC_ENABLE_SB|VIA_FUNC_ENABLE_FM));

-	if ((err = pci_request_regions(pci, card->driver)) < 0) {
+	err = pci_request_regions(pci, card->driver);
+	if (err < 0) {
 		kfree(chip);
 		pci_disable_device(pci);
 		return err;
@@ -2310,12 +2323,14 @@ static int __devinit snd_via82xx_create(struct snd_card *card,
 		chip->ac97_clock = ac97_clock;
 	synchronize_irq(chip->irq);

-	if ((err = snd_via82xx_chip_init(chip)) < 0) {
+	err = snd_via82xx_chip_init(chip);
+	if (err < 0) {
 		snd_via82xx_free(chip);
 		return err;
 	}

-	if ((err = snd_device_new(card, SNDRV_DEV_LOWLEVEL, chip, &ops)) < 0) {
+	err = snd_device_new(card, SNDRV_DEV_LOWLEVEL, chip, &ops);
+	if (err < 0) {
 		snd_via82xx_free(chip);
 		return err;
 	}
@@ -2472,25 +2487,33 @@ static int __devinit snd_via82xx_probe(struct pci_dev *pci,
 		err = -EINVAL;
 		goto __error;
 	}
-
-	if ((err = snd_via82xx_create(card, pci, chip_type, pci->revision,
-				      ac97_clock, &chip)) < 0)
+
+	err = snd_via82xx_create(card, pci, chip_type, pci->revision,
+				 ac97_clock, &chip);
+	if (err < 0)
 		goto __error;
 	card->private_data = chip;
-	if ((err = snd_via82xx_mixer_new(chip, ac97_quirk)) < 0)
+	err = snd_via82xx_mixer_new(chip, ac97_quirk);
+	if (err < 0)
 		goto __error;

 	if (chip_type == TYPE_VIA686) {
-		if ((err = snd_via686_pcm_new(chip)) < 0 ||
-		    (err = snd_via686_init_misc(chip)) < 0)
+		err = snd_via686_pcm_new(chip);
+		if (err < 0)
+			goto __error;
+
+		err = snd_via686_init_misc(chip);
+		if (err < 0)
 			goto __error;
 	} else {
 		if (chip_type == TYPE_VIA8233A) {
-			if ((err = snd_via8233a_pcm_new(chip)) < 0)
+			err = snd_via8233a_pcm_new(chip);
+			if (err < 0)
 				goto __error;
-			// chip->dxs_fixed = 1; /* FIXME: use 48k for DXS #3? */
+			/* chip->dxs_fixed = 1; FIXME: use 48k for DXS #3? */
 		} else {
-			if ((err = snd_via8233_pcm_new(chip)) < 0)
+			err = snd_via8233_pcm_new(chip);
+			if (err < 0)
 				goto __error;
 			if (dxs_support == VIA_DXS_48K)
 				chip->dxs_fixed = 1;
@@ -2501,7 +2524,8 @@ static int __devinit snd_via82xx_probe(struct pci_dev *pci,
 				chip->dxs_src = 1;
 			}
 		}
-		if ((err = snd_via8233_init_misc(chip)) < 0)
+		err = snd_via8233_init_misc(chip);
+		if (err < 0)
 			goto __error;
 	}

@@ -2515,7 +2539,8 @@ static int __devinit snd_via82xx_probe(struct pci_dev *pci,

 	snd_via82xx_proc_init(chip);

-	if ((err = snd_card_register(card)) < 0) {
+	err = snd_card_register(card);
+	if (err < 0) {
 		snd_card_free(card);
 		return err;
 	}

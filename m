Return-Path: <linux-kernel-owner+w=401wt.eu-S1753723AbYKBCuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbYKBCuo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 22:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbYKBCug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 22:50:36 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:31567 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbYKBCuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 22:50:35 -0400
Subject: sound: struct device - replace bus_id with dev_name(),
	dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain
Date: Sun, 02 Nov 2008 03:50:35 +0100
Message-Id: <1225594235.2142.14.camel@nga.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here the next round of sound stuff, which I didn't test or compile. Please
let me know if there is anything to fix.

Thanks,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: sound: struct device - replace bus_id with dev_name(), dev_set_name()

Cc: Takashi Iwai <tiwai@suse.de>
Acked-By: Greg Kroah-Hartman <gregkh@suse.de>
Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---
 sound/aoa/soundbus/core.c    |    2 +-
 sound/drivers/ml403-ac97cr.c |    4 ++--
 sound/isa/ad1848/ad1848.c    |    6 +++---
 sound/isa/adlib.c            |   12 ++++++------
 sound/isa/cs423x/cs4231.c    |    8 ++++----
 sound/isa/cs423x/cs4236.c    |    8 ++++----
 sound/isa/es1688/es1688.c    |    6 +++---
 sound/isa/gus/gusclassic.c   |    8 ++++----
 sound/isa/gus/gusextreme.c   |   12 ++++++------
 sound/isa/sb/sb8.c           |    4 ++--
 sound/soc/soc-core.c         |    4 ++--
 11 files changed, 37 insertions(+), 37 deletions(-)

--- a/sound/aoa/soundbus/core.c
+++ b/sound/aoa/soundbus/core.c
@@ -176,7 +176,7 @@ int soundbus_add_one(struct soundbus_dev
 		return -EINVAL;
 	}
 
-	snprintf(dev->ofdev.dev.bus_id, BUS_ID_SIZE, "soundbus:%x", ++devcount);
+	dev_set_name(&dev->ofdev.dev, "soundbus:%x", ++devcount);
 	dev->ofdev.dev.bus = &soundbus_bus_type;
 	return of_device_register(&dev->ofdev);
 }
--- a/sound/drivers/ml403-ac97cr.c
+++ b/sound/drivers/ml403-ac97cr.c
@@ -1153,7 +1153,7 @@ snd_ml403_ac97cr_create(struct snd_card
 	/* get irq */
 	irq = platform_get_irq(pfdev, 0);
 	if (request_irq(irq, snd_ml403_ac97cr_irq, IRQF_DISABLED,
-			pfdev->dev.bus_id, (void *)ml403_ac97cr)) {
+			dev_name(&pfdev->dev), (void *)ml403_ac97cr)) {
 		snd_printk(KERN_ERR SND_ML403_AC97CR_DRIVER ": "
 			   "unable to grab IRQ %d\n",
 			   irq);
@@ -1166,7 +1166,7 @@ snd_ml403_ac97cr_create(struct snd_card
 		   ml403_ac97cr->irq);
 	irq = platform_get_irq(pfdev, 1);
 	if (request_irq(irq, snd_ml403_ac97cr_irq, IRQF_DISABLED,
-			pfdev->dev.bus_id, (void *)ml403_ac97cr)) {
+			dev_name(&pfdev->dev), (void *)ml403_ac97cr)) {
 		snd_printk(KERN_ERR SND_ML403_AC97CR_DRIVER ": "
 			   "unable to grab IRQ %d\n",
 			   irq);
--- a/sound/isa/ad1848/ad1848.c
+++ b/sound/isa/ad1848/ad1848.c
@@ -70,15 +70,15 @@ static int __devinit snd_ad1848_match(st
 		return 0;
 
 	if (port[n] == SNDRV_AUTO_PORT) {
-		snd_printk(KERN_ERR "%s: please specify port\n", dev->bus_id);
+		snd_printk(KERN_ERR "%s: please specify port\n", dev_name(dev));
 		return 0;
 	}
 	if (irq[n] == SNDRV_AUTO_IRQ) {
-		snd_printk(KERN_ERR "%s: please specify irq\n", dev->bus_id);
+		snd_printk(KERN_ERR "%s: please specify irq\n", dev_name(dev));
 		return 0;	
 	}
 	if (dma1[n] == SNDRV_AUTO_DMA) {
-		snd_printk(KERN_ERR "%s: please specify dma1\n", dev->bus_id);
+		snd_printk(KERN_ERR "%s: please specify dma1\n", dev_name(dev));
 		return 0;
 	}
 	return 1;
--- a/sound/isa/adlib.c
+++ b/sound/isa/adlib.c
@@ -36,7 +36,7 @@ static int __devinit snd_adlib_match(str
 		return 0;
 
 	if (port[n] == SNDRV_AUTO_PORT) {
-		snd_printk(KERN_ERR "%s: please specify port\n", dev->bus_id);
+		snd_printk(KERN_ERR "%s: please specify port\n", dev_name(dev));
 		return 0;
 	}
 	return 1;
@@ -55,13 +55,13 @@ static int __devinit snd_adlib_probe(str
 
 	card = snd_card_new(index[n], id[n], THIS_MODULE, 0);
 	if (!card) {
-		snd_printk(KERN_ERR "%s: could not create card\n", dev->bus_id);
+		snd_printk(KERN_ERR "%s: could not create card\n", dev_name(dev));
 		return -EINVAL;
 	}
 
 	card->private_data = request_region(port[n], 4, CRD_NAME);
 	if (!card->private_data) {
-		snd_printk(KERN_ERR "%s: could not grab ports\n", dev->bus_id);
+		snd_printk(KERN_ERR "%s: could not grab ports\n", dev_name(dev));
 		error = -EBUSY;
 		goto out;
 	}
@@ -73,13 +73,13 @@ static int __devinit snd_adlib_probe(str
 
 	error = snd_opl3_create(card, port[n], port[n] + 2, OPL3_HW_AUTO, 1, &opl3);
 	if (error < 0) {
-		snd_printk(KERN_ERR "%s: could not create OPL\n", dev->bus_id);
+		snd_printk(KERN_ERR "%s: could not create OPL\n", dev_name(dev));
 		goto out;
 	}
 
 	error = snd_opl3_hwdep_new(opl3, 0, 0, NULL);
 	if (error < 0) {
-		snd_printk(KERN_ERR "%s: could not create FM\n", dev->bus_id);
+		snd_printk(KERN_ERR "%s: could not create FM\n", dev_name(dev));
 		goto out;
 	}
 
@@ -87,7 +87,7 @@ static int __devinit snd_adlib_probe(str
 
 	error = snd_card_register(card);
 	if (error < 0) {
-		snd_printk(KERN_ERR "%s: could not register card\n", dev->bus_id);
+		snd_printk(KERN_ERR "%s: could not register card\n", dev_name(dev));
 		goto out;
 	}
 
--- a/sound/isa/cs423x/cs4231.c
+++ b/sound/isa/cs423x/cs4231.c
@@ -74,15 +74,15 @@ static int __devinit snd_cs4231_match(st
 		return 0;
 
 	if (port[n] == SNDRV_AUTO_PORT) {
-		snd_printk(KERN_ERR "%s: please specify port\n", dev->bus_id);
+		snd_printk(KERN_ERR "%s: please specify port\n", dev_name(dev));
 		return 0;
 	}
 	if (irq[n] == SNDRV_AUTO_IRQ) {
-		snd_printk(KERN_ERR "%s: please specify irq\n", dev->bus_id);
+		snd_printk(KERN_ERR "%s: please specify irq\n", dev_name(dev));
 		return 0;
 	}
 	if (dma1[n] == SNDRV_AUTO_DMA) {
-		snd_printk(KERN_ERR "%s: please specify dma1\n", dev->bus_id);
+		snd_printk(KERN_ERR "%s: please specify dma1\n", dev_name(dev));
 		return 0;
 	}
 	return 1;
@@ -133,7 +133,7 @@ static int __devinit snd_cs4231_probe(st
 					mpu_port[n], 0, mpu_irq[n],
 					mpu_irq[n] >= 0 ? IRQF_DISABLED : 0,
 					NULL) < 0)
-			printk(KERN_WARNING "%s: MPU401 not detected\n", dev->bus_id);
+			printk(KERN_WARNING "%s: MPU401 not detected\n", dev_name(dev));
 	}
 
 	snd_card_set_dev(card, dev);
--- a/sound/isa/cs423x/cs4236.c
+++ b/sound/isa/cs423x/cs4236.c
@@ -488,19 +488,19 @@ static int __devinit snd_cs423x_isa_matc
 		return 0;
 
 	if (port[dev] == SNDRV_AUTO_PORT) {
-		snd_printk(KERN_ERR "%s: please specify port\n", pdev->bus_id);
+		snd_printk(KERN_ERR "%s: please specify port\n", dev_name(pdev));
 		return 0;
 	}
 	if (cport[dev] == SNDRV_AUTO_PORT) {
-		snd_printk(KERN_ERR "%s: please specify cport\n", pdev->bus_id);
+		snd_printk(KERN_ERR "%s: please specify cport\n", dev_name(pdev));
 		return 0;
 	}
 	if (irq[dev] == SNDRV_AUTO_IRQ) {
-		snd_printk(KERN_ERR "%s: please specify irq\n", pdev->bus_id);
+		snd_printk(KERN_ERR "%s: please specify irq\n", dev_name(pdev));
 		return 0;
 	}
 	if (dma1[dev] == SNDRV_AUTO_DMA) {
-		snd_printk(KERN_ERR "%s: please specify dma1\n", pdev->bus_id);
+		snd_printk(KERN_ERR "%s: please specify dma1\n", dev_name(pdev));
 		return 0;
 	}
 	return 1;
--- a/sound/isa/es1688/es1688.c
+++ b/sound/isa/es1688/es1688.c
@@ -89,7 +89,7 @@ static int __devinit snd_es1688_legacy_c
 		irq[n] = snd_legacy_find_free_irq(possible_irqs);
 		if (irq[n] < 0) {
 			snd_printk(KERN_ERR "%s: unable to find a free IRQ\n",
-				dev->bus_id);
+				dev_name(dev));
 			return -EBUSY;
 		}
 	}
@@ -97,7 +97,7 @@ static int __devinit snd_es1688_legacy_c
 		dma8[n] = snd_legacy_find_free_dma(possible_dmas);
 		if (dma8[n] < 0) {
 			snd_printk(KERN_ERR "%s: unable to find a free DMA\n",
-				dev->bus_id);
+				dev_name(dev));
 			return -EBUSY;
 		}
 	}
@@ -148,7 +148,7 @@ static int __devinit snd_es1688_probe(st
 	if (snd_opl3_create(card, chip->port, chip->port + 2,
 			OPL3_HW_OPL3, 0, &opl3) < 0)
 		printk(KERN_WARNING "%s: opl3 not detected at 0x%lx\n",
-			dev->bus_id, chip->port);
+			dev_name(dev), chip->port);
 	else {
 		error =	snd_opl3_hwdep_new(opl3, 0, 1, NULL);
 		if (error < 0)
--- a/sound/isa/gus/gusclassic.c
+++ b/sound/isa/gus/gusclassic.c
@@ -91,7 +91,7 @@ static int __devinit snd_gusclassic_crea
 		irq[n] = snd_legacy_find_free_irq(possible_irqs);
 		if (irq[n] < 0) {
 			snd_printk(KERN_ERR "%s: unable to find a free IRQ\n",
-				dev->bus_id);
+				dev_name(dev));
 			return -EBUSY;
 		}
 	}
@@ -99,7 +99,7 @@ static int __devinit snd_gusclassic_crea
 		dma1[n] = snd_legacy_find_free_dma(possible_dmas);
 		if (dma1[n] < 0) {
 			snd_printk(KERN_ERR "%s: unable to find a free DMA1\n",
-				dev->bus_id);
+				dev_name(dev));
 			return -EBUSY;
 		}
 	}
@@ -107,7 +107,7 @@ static int __devinit snd_gusclassic_crea
 		dma2[n] = snd_legacy_find_free_dma(possible_dmas);
 		if (dma2[n] < 0) {
 			snd_printk(KERN_ERR "%s: unable to find a free DMA2\n",
-				dev->bus_id);
+				dev_name(dev));
 			return -EBUSY;
 		}
 	}
@@ -175,7 +175,7 @@ static int __devinit snd_gusclassic_prob
 	error = -ENODEV;
 	if (gus->max_flag || gus->ess_flag) {
 		snd_printk(KERN_ERR "%s: GUS Classic or ACE soundcard was "
-			"not detected at 0x%lx\n", dev->bus_id, gus->gf1.port);
+			"not detected at 0x%lx\n", dev_name(dev), gus->gf1.port);
 		goto out;
 	}
 
--- a/sound/isa/gus/gusextreme.c
+++ b/sound/isa/gus/gusextreme.c
@@ -107,7 +107,7 @@ static int __devinit snd_gusextreme_es16
 		irq[n] = snd_legacy_find_free_irq(possible_irqs);
 		if (irq[n] < 0) {
 			snd_printk(KERN_ERR "%s: unable to find a free IRQ "
-				"for ES1688\n", dev->bus_id);
+				"for ES1688\n", dev_name(dev));
 			return -EBUSY;
 		}
 	}
@@ -115,7 +115,7 @@ static int __devinit snd_gusextreme_es16
 		dma8[n] = snd_legacy_find_free_dma(possible_dmas);
 		if (dma8[n] < 0) {
 			snd_printk(KERN_ERR "%s: unable to find a free DMA "
-				"for ES1688\n", dev->bus_id);
+				"for ES1688\n", dev_name(dev));
 			return -EBUSY;
 		}
 	}
@@ -144,7 +144,7 @@ static int __devinit snd_gusextreme_gus_
 		gf1_irq[n] = snd_legacy_find_free_irq(possible_irqs);
 		if (gf1_irq[n] < 0) {
 			snd_printk(KERN_ERR "%s: unable to find a free IRQ "
-				"for GF1\n", dev->bus_id);
+				"for GF1\n", dev_name(dev));
 			return -EBUSY;
 		}
 	}
@@ -152,7 +152,7 @@ static int __devinit snd_gusextreme_gus_
 		dma1[n] = snd_legacy_find_free_dma(possible_dmas);
 		if (dma1[n] < 0) {
 			snd_printk(KERN_ERR "%s: unable to find a free DMA "
-				"for GF1\n", dev->bus_id);
+				"for GF1\n", dev_name(dev));
 			return -EBUSY;
 		}
 	}
@@ -279,7 +279,7 @@ static int __devinit snd_gusextreme_prob
 	error = -ENODEV;
 	if (!gus->ess_flag) {
 		snd_printk(KERN_ERR "%s: GUS Extreme soundcard was not "
-			"detected at 0x%lx\n", dev->bus_id, gus->gf1.port);
+			"detected at 0x%lx\n", dev_name(dev), gus->gf1.port);
 		goto out;
 	}
 	gus->codec_flag = 1;
@@ -311,7 +311,7 @@ static int __devinit snd_gusextreme_prob
 	if (snd_opl3_create(card, es1688->port, es1688->port + 2,
 			OPL3_HW_OPL3, 0, &opl3) < 0)
 		printk(KERN_ERR "%s: opl3 not detected at 0x%lx\n",
-			dev->bus_id, es1688->port);
+			dev_name(dev), es1688->port);
 	else {
 		error = snd_opl3_hwdep_new(opl3, 0, 2, NULL);
 		if (error < 0)
--- a/sound/isa/sb/sb8.c
+++ b/sound/isa/sb/sb8.c
@@ -85,11 +85,11 @@ static int __devinit snd_sb8_match(struc
 	if (!enable[dev])
 		return 0;
 	if (irq[dev] == SNDRV_AUTO_IRQ) {
-		snd_printk(KERN_ERR "%s: please specify irq\n", pdev->bus_id);
+		snd_printk(KERN_ERR "%s: please specify irq\n", dev_name(pdev));
 		return 0;
 	}
 	if (dma8[dev] == SNDRV_AUTO_DMA) {
-		snd_printk(KERN_ERR "%s: please specify dma8\n", pdev->bus_id);
+		snd_printk(KERN_ERR "%s: please specify dma8\n", dev_name(pdev));
 		return 0;
 	}
 	return 1;
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -95,8 +95,8 @@ static int soc_ac97_dev_register(struct
 	codec->ac97->dev.parent = NULL;
 	codec->ac97->dev.release = soc_ac97_device_release;
 
-	snprintf(codec->ac97->dev.bus_id, BUS_ID_SIZE, "%d-%d:%s",
-		 codec->card->number, 0, codec->name);
+	dev_set_name(&codec->ac97->dev, "%d-%d:%s",
+		     codec->card->number, 0, codec->name);
 	err = device_register(&codec->ac97->dev);
 	if (err < 0) {
 		snd_printk(KERN_ERR "Can't register ac97 bus\n");



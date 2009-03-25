Return-Path: <linux-kernel-owner+w=401wt.eu-S1756993AbZCYAa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993AbZCYAa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755803AbZCYA3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:29:37 -0400
Received: from kroah.org ([198.145.64.141]:54038 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754323AbZCYA3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:29:35 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 03/61] video: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue, 24 Mar 2009 17:26:07 -0700
Message-Id: <1237940825-22904-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/video/pmag-ba-fb.c       |   17 +++++++++--------
 drivers/video/pmagb-b-fb.c       |   17 +++++++++--------
 drivers/video/ps3fb.c            |    2 +-
 drivers/video/sh_mobile_lcdcfb.c |    2 +-
 drivers/video/tmiofb.c           |    2 +-
 5 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/video/pmag-ba-fb.c b/drivers/video/pmag-ba-fb.c
index 3a3f80f..0573ec6 100644
--- a/drivers/video/pmag-ba-fb.c
+++ b/drivers/video/pmag-ba-fb.c
@@ -151,7 +151,7 @@ static int __init pmagbafb_probe(struct device *dev)
 
 	info = framebuffer_alloc(sizeof(struct pmagbafb_par), dev);
 	if (!info) {
-		printk(KERN_ERR "%s: Cannot allocate memory\n", dev->bus_id);
+		printk(KERN_ERR "%s: Cannot allocate memory\n", dev_name(dev));
 		return -ENOMEM;
 	}
 
@@ -160,7 +160,7 @@ static int __init pmagbafb_probe(struct device *dev)
 
 	if (fb_alloc_cmap(&info->cmap, 256, 0) < 0) {
 		printk(KERN_ERR "%s: Cannot allocate color map\n",
-		       dev->bus_id);
+		       dev_name(dev));
 		err = -ENOMEM;
 		goto err_alloc;
 	}
@@ -173,8 +173,9 @@ static int __init pmagbafb_probe(struct device *dev)
 	/* Request the I/O MEM resource.  */
 	start = tdev->resource.start;
 	len = tdev->resource.end - start + 1;
-	if (!request_mem_region(start, len, dev->bus_id)) {
-		printk(KERN_ERR "%s: Cannot reserve FB region\n", dev->bus_id);
+	if (!request_mem_region(start, len, dev_name(dev))) {
+		printk(KERN_ERR "%s: Cannot reserve FB region\n",
+		       dev_name(dev));
 		err = -EBUSY;
 		goto err_cmap;
 	}
@@ -183,7 +184,7 @@ static int __init pmagbafb_probe(struct device *dev)
 	info->fix.mmio_start = start;
 	par->mmio = ioremap_nocache(info->fix.mmio_start, info->fix.mmio_len);
 	if (!par->mmio) {
-		printk(KERN_ERR "%s: Cannot map MMIO\n", dev->bus_id);
+		printk(KERN_ERR "%s: Cannot map MMIO\n", dev_name(dev));
 		err = -ENOMEM;
 		goto err_resource;
 	}
@@ -194,7 +195,7 @@ static int __init pmagbafb_probe(struct device *dev)
 	info->screen_base = ioremap_nocache(info->fix.smem_start,
 					    info->fix.smem_len);
 	if (!info->screen_base) {
-		printk(KERN_ERR "%s: Cannot map FB\n", dev->bus_id);
+		printk(KERN_ERR "%s: Cannot map FB\n", dev_name(dev));
 		err = -ENOMEM;
 		goto err_mmio_map;
 	}
@@ -205,14 +206,14 @@ static int __init pmagbafb_probe(struct device *dev)
 	err = register_framebuffer(info);
 	if (err < 0) {
 		printk(KERN_ERR "%s: Cannot register framebuffer\n",
-		       dev->bus_id);
+		       dev_name(dev));
 		goto err_smem_map;
 	}
 
 	get_device(dev);
 
 	pr_info("fb%d: %s frame buffer device at %s\n",
-		info->node, info->fix.id, dev->bus_id);
+		info->node, info->fix.id, dev_name(dev));
 
 	return 0;
 
diff --git a/drivers/video/pmagb-b-fb.c b/drivers/video/pmagb-b-fb.c
index 9b80597..9874872 100644
--- a/drivers/video/pmagb-b-fb.c
+++ b/drivers/video/pmagb-b-fb.c
@@ -258,7 +258,7 @@ static int __init pmagbbfb_probe(struct device *dev)
 
 	info = framebuffer_alloc(sizeof(struct pmagbbfb_par), dev);
 	if (!info) {
-		printk(KERN_ERR "%s: Cannot allocate memory\n", dev->bus_id);
+		printk(KERN_ERR "%s: Cannot allocate memory\n", dev_name(dev));
 		return -ENOMEM;
 	}
 
@@ -267,7 +267,7 @@ static int __init pmagbbfb_probe(struct device *dev)
 
 	if (fb_alloc_cmap(&info->cmap, 256, 0) < 0) {
 		printk(KERN_ERR "%s: Cannot allocate color map\n",
-		       dev->bus_id);
+		       dev_name(dev));
 		err = -ENOMEM;
 		goto err_alloc;
 	}
@@ -280,8 +280,9 @@ static int __init pmagbbfb_probe(struct device *dev)
 	/* Request the I/O MEM resource.  */
 	start = tdev->resource.start;
 	len = tdev->resource.end - start + 1;
-	if (!request_mem_region(start, len, dev->bus_id)) {
-		printk(KERN_ERR "%s: Cannot reserve FB region\n", dev->bus_id);
+	if (!request_mem_region(start, len, dev_name(dev))) {
+		printk(KERN_ERR "%s: Cannot reserve FB region\n",
+		       dev_name(dev));
 		err = -EBUSY;
 		goto err_cmap;
 	}
@@ -290,7 +291,7 @@ static int __init pmagbbfb_probe(struct device *dev)
 	info->fix.mmio_start = start;
 	par->mmio = ioremap_nocache(info->fix.mmio_start, info->fix.mmio_len);
 	if (!par->mmio) {
-		printk(KERN_ERR "%s: Cannot map MMIO\n", dev->bus_id);
+		printk(KERN_ERR "%s: Cannot map MMIO\n", dev_name(dev));
 		err = -ENOMEM;
 		goto err_resource;
 	}
@@ -301,7 +302,7 @@ static int __init pmagbbfb_probe(struct device *dev)
 	info->fix.smem_start = start + PMAGB_B_FBMEM;
 	par->smem = ioremap_nocache(info->fix.smem_start, info->fix.smem_len);
 	if (!par->smem) {
-		printk(KERN_ERR "%s: Cannot map FB\n", dev->bus_id);
+		printk(KERN_ERR "%s: Cannot map FB\n", dev_name(dev));
 		err = -ENOMEM;
 		goto err_mmio_map;
 	}
@@ -316,7 +317,7 @@ static int __init pmagbbfb_probe(struct device *dev)
 	err = register_framebuffer(info);
 	if (err < 0) {
 		printk(KERN_ERR "%s: Cannot register framebuffer\n",
-		       dev->bus_id);
+		       dev_name(dev));
 		goto err_smem_map;
 	}
 
@@ -328,7 +329,7 @@ static int __init pmagbbfb_probe(struct device *dev)
 		 par->osc1 / 1000, par->osc1 % 1000);
 
 	pr_info("fb%d: %s frame buffer device at %s\n",
-		info->node, info->fix.id, dev->bus_id);
+		info->node, info->fix.id, dev_name(dev));
 	pr_info("fb%d: Osc0: %s, Osc1: %s, Osc%u selected\n",
 		info->node, freq0, par->osc1 ? freq1 : "disabled",
 		par->osc1 != 0);
diff --git a/drivers/video/ps3fb.c b/drivers/video/ps3fb.c
index 87f826e..e00c1df 100644
--- a/drivers/video/ps3fb.c
+++ b/drivers/video/ps3fb.c
@@ -1213,7 +1213,7 @@ static int __devinit ps3fb_probe(struct ps3_system_bus_device *dev)
 	dev->core.driver_data = info;
 
 	dev_info(info->device, "%s %s, using %u KiB of video memory\n",
-		 dev_driver_string(info->dev), info->dev->bus_id,
+		 dev_driver_string(info->dev), dev_name(info->dev),
 		 info->fix.smem_len >> 10);
 
 	task = kthread_run(ps3fbd, info, DEVICE_NAME);
diff --git a/drivers/video/sh_mobile_lcdcfb.c b/drivers/video/sh_mobile_lcdcfb.c
index 2c5d069..1d2636a 100644
--- a/drivers/video/sh_mobile_lcdcfb.c
+++ b/drivers/video/sh_mobile_lcdcfb.c
@@ -687,7 +687,7 @@ static int __init sh_mobile_lcdc_probe(struct platform_device *pdev)
 	}
 
 	error = request_irq(i, sh_mobile_lcdc_irq, IRQF_DISABLED,
-			    pdev->dev.bus_id, priv);
+			    dev_name(&pdev->dev), priv);
 	if (error) {
 		dev_err(&pdev->dev, "unable to request irq\n");
 		goto err1;
diff --git a/drivers/video/tmiofb.c b/drivers/video/tmiofb.c
index 7baf2dd..a1eb086 100644
--- a/drivers/video/tmiofb.c
+++ b/drivers/video/tmiofb.c
@@ -751,7 +751,7 @@ static int __devinit tmiofb_probe(struct platform_device *dev)
 	}
 
 	retval = request_irq(irq, &tmiofb_irq, IRQF_DISABLED,
-					dev->dev.bus_id, info);
+					dev_name(&dev->dev), info);
 
 	if (retval)
 		goto err_request_irq;
-- 
1.6.2


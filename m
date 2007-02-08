Return-Path: <linux-kernel-owner+w=401wt.eu-S1161514AbXBHBAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161514AbXBHBAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 20:00:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161513AbXBHBAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 20:00:24 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:60575 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161512AbXBHBAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 20:00:23 -0500
Message-id: <1836786002432329128@wsc.cz>
In-reply-to: <135662331710109923@wsc.cz>
Subject: [PATCH 2/2] Video: fb, kzalloc changes
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <adaplas@pol.net>
Cc: <sylvain.meyer@worldonline.fr>
Date: Thu,  8 Feb 2007 02:00:22 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

video/fb, kzalloc changes

Use kzalloc instead of kmalloc + memset(0).

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 1e7333622e9abbe0c980c3d42c4691d026be61bb
tree d8029a264c0a2ef88d64d82b760d2c41458d3ce8
parent fd6de4a65b2d83db766a9ad3c137c44e361d6e0d
author Jiri Slaby <jirislaby@gmail.com> Thu, 08 Feb 2007 01:48:59 +0100
committer Jiri Slaby <jirislaby@gmail.com> Thu, 08 Feb 2007 01:48:59 +0100

 drivers/video/au1100fb.c           |    6 ++----
 drivers/video/controlfb.c          |    3 +--
 drivers/video/i810/i810_main.c     |    3 +--
 drivers/video/igafb.c              |    7 ++-----
 drivers/video/intelfb/intelfbdrv.c |    3 +--
 drivers/video/nvidia/nvidia.c      |    4 +---
 drivers/video/riva/fbdev.c         |    3 +--
 7 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/video/au1100fb.c b/drivers/video/au1100fb.c
index ef5c16f..80a81ec 100644
--- a/drivers/video/au1100fb.c
+++ b/drivers/video/au1100fb.c
@@ -468,11 +468,10 @@ int au1100fb_drv_probe(struct device *dev)
 			return -EINVAL;
 
 	/* Allocate new device private */
-	if (!(fbdev = kmalloc(sizeof(struct au1100fb_device), GFP_KERNEL))) {
+	if (!(fbdev = kzalloc(sizeof(struct au1100fb_device), GFP_KERNEL))) {
 		print_err("fail to allocate device private record");
 		return -ENOMEM;
 	}
-	memset((void*)fbdev, 0, sizeof(struct au1100fb_device));
 
 	fbdev->panel = &known_lcd_panels[drv_info.panel_idx];
 
@@ -549,10 +548,9 @@ int au1100fb_drv_probe(struct device *dev)
 	fbdev->info.fbops = &au1100fb_ops;
 	fbdev->info.fix = au1100fb_fix;
 
-	if (!(fbdev->info.pseudo_palette = kmalloc(sizeof(u32) * 16, GFP_KERNEL))) {
+	if (!(fbdev->info.pseudo_palette = kzalloc(sizeof(u32) * 16, GFP_KERNEL))) {
 		return -ENOMEM;
 	}
-	memset(fbdev->info.pseudo_palette, 0, sizeof(u32) * 16);
 
 	if (fb_alloc_cmap(&fbdev->info.cmap, AU1100_LCD_NBR_PALETTE_ENTRIES, 0) < 0) {
 		print_err("Fail to allocate colormap (%d entries)",
diff --git a/drivers/video/controlfb.c b/drivers/video/controlfb.c
index 04c6d92..fd60dba 100644
--- a/drivers/video/controlfb.c
+++ b/drivers/video/controlfb.c
@@ -696,11 +696,10 @@ static int __init control_of_init(struct device_node *dp)
 		printk(KERN_ERR "can't get 2 addresses for control\n");
 		return -ENXIO;
 	}
-	p = kmalloc(sizeof(*p), GFP_KERNEL);
+	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (p == 0)
 		return -ENXIO;
 	control_fb = p;	/* save it for cleanups */
-	memset(p, 0, sizeof(*p));
 
 	/* Map in frame buffer and registers */
 	p->fb_orig_base = fb_res.start;
diff --git a/drivers/video/i810/i810_main.c b/drivers/video/i810/i810_main.c
index e343c0d..29f89db 100644
--- a/drivers/video/i810/i810_main.c
+++ b/drivers/video/i810/i810_main.c
@@ -2021,11 +2021,10 @@ static int __devinit i810fb_init_pci (struct pci_dev *dev,
 	par = info->par;
 	par->dev = dev;
 
-	if (!(info->pixmap.addr = kmalloc(8*1024, GFP_KERNEL))) {
+	if (!(info->pixmap.addr = kzalloc(8*1024, GFP_KERNEL))) {
 		i810fb_release_resource(info, par);
 		return -ENOMEM;
 	}
-	memset(info->pixmap.addr, 0, 8*1024);
 	info->pixmap.size = 8*1024;
 	info->pixmap.buf_align = 8;
 	info->pixmap.access_align = 32;
diff --git a/drivers/video/igafb.c b/drivers/video/igafb.c
index 51355c8..90592fb 100644
--- a/drivers/video/igafb.c
+++ b/drivers/video/igafb.c
@@ -401,12 +401,11 @@ int __init igafb_init(void)
 	
 	size = sizeof(struct fb_info) + sizeof(struct iga_par) + sizeof(u32)*16;
 
-        info = kmalloc(size, GFP_ATOMIC);
+        info = kzalloc(size, GFP_ATOMIC);
         if (!info) {
                 printk("igafb_init: can't alloc fb_info\n");
                 return -ENOMEM;
         }
-        memset(info, 0, size);
 
 	par = (struct iga_par *) (info + 1);
 	
@@ -465,7 +464,7 @@ int __init igafb_init(void)
 	 * one additional region with size == 0. 
 	 */
 
-	par->mmap_map = kmalloc(4 * sizeof(*par->mmap_map), GFP_ATOMIC);
+	par->mmap_map = kzalloc(4 * sizeof(*par->mmap_map), GFP_ATOMIC);
 	if (!par->mmap_map) {
 		printk("igafb_init: can't alloc mmap_map\n");
 		iounmap((void *)par->io_base);
@@ -474,8 +473,6 @@ int __init igafb_init(void)
 		return -ENOMEM;
 	}
 
-	memset(par->mmap_map, 0, 4 * sizeof(*par->mmap_map));
-
 	/*
 	 * Set default vmode and cmode from PROM properties.
 	 */
diff --git a/drivers/video/intelfb/intelfbdrv.c b/drivers/video/intelfb/intelfbdrv.c
index 664fc5c..b75eda8 100644
--- a/drivers/video/intelfb/intelfbdrv.c
+++ b/drivers/video/intelfb/intelfbdrv.c
@@ -540,12 +540,11 @@ intelfb_pci_register(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dinfo->pdev  = pdev;
 
 	/* Reserve pixmap space. */
-	info->pixmap.addr = kmalloc(64 * 1024, GFP_KERNEL);
+	info->pixmap.addr = kzalloc(64 * 1024, GFP_KERNEL);
 	if (info->pixmap.addr == NULL) {
 		ERR_MSG("Cannot reserve pixmap memory.\n");
 		goto err_out_pixmap;
 	}
-	memset(info->pixmap.addr, 0, 64 * 1024);
 
 	/* set early this option because it could be changed by tv encoder
 	   driver */
diff --git a/drivers/video/nvidia/nvidia.c b/drivers/video/nvidia/nvidia.c
index 538e947..f6731da 100644
--- a/drivers/video/nvidia/nvidia.c
+++ b/drivers/video/nvidia/nvidia.c
@@ -1205,13 +1205,11 @@ static int __devinit nvidiafb_probe(struct pci_dev *pd,
 	par = info->par;
 	par->pci_dev = pd;
 
-	info->pixmap.addr = kmalloc(8 * 1024, GFP_KERNEL);
+	info->pixmap.addr = kzalloc(8 * 1024, GFP_KERNEL);
 
 	if (info->pixmap.addr == NULL)
 		goto err_out_kfree;
 
-	memset(info->pixmap.addr, 0, 8 * 1024);
-
 	if (pci_enable_device(pd)) {
 		printk(KERN_ERR PFX "cannot enable PCI device\n");
 		goto err_out_enable;
diff --git a/drivers/video/riva/fbdev.c b/drivers/video/riva/fbdev.c
index 7c19b5c..9316905 100644
--- a/drivers/video/riva/fbdev.c
+++ b/drivers/video/riva/fbdev.c
@@ -1984,12 +1984,11 @@ static int __devinit rivafb_probe(struct pci_dev *pd,
 	default_par = info->par;
 	default_par->pdev = pd;
 
-	info->pixmap.addr = kmalloc(8 * 1024, GFP_KERNEL);
+	info->pixmap.addr = kzalloc(8 * 1024, GFP_KERNEL);
 	if (info->pixmap.addr == NULL) {
 	    	ret = -ENOMEM;
 		goto err_framebuffer_release;
 	}
-	memset(info->pixmap.addr, 0, 8 * 1024);
 
 	ret = pci_enable_device(pd);
 	if (ret < 0) {

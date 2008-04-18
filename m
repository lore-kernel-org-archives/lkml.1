Return-Path: <linux-kernel-owner+w=401wt.eu-S1764054AbYDRVOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764054AbYDRVOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 17:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761560AbYDRUxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 16:53:44 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:21914 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761100AbYDRUwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 16:52:43 -0400
Message-Id: <20080418205057.753579689@ldl.fc.hp.com>
References: <20080418204955.342963315@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Apr 2008 14:50:47 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 52/53] PNP: fill in generic pnp_dev fields earlier
Content-Disposition: inline; filename=pnp-init-pnp_dev-generic-stuff-earlier
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes dev_printk() work better because we have a default driver.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work8/drivers/pnp/core.c
===================================================================
--- work8.orig/drivers/pnp/core.c	2008-04-17 15:05:18.000000000 -0600
+++ work8/drivers/pnp/core.c	2008-04-17 17:13:12.000000000 -0600
@@ -132,8 +132,13 @@
 	INIT_LIST_HEAD(&dev->resources);
 	dev->protocol = protocol;
 	dev->number = id;
+	dev->dma_mask = DMA_24BIT_MASK;
 
 	dev->dev.parent = &dev->protocol->dev;
+	dev->dev.bus = &pnp_bus_type;
+	dev->dev.dma_mask = &dev->dma_mask;
+	dev->dev.coherent_dma_mask = dev->dma_mask;
+	dev->dev.release = &pnp_release_device;
 	sprintf(dev->dev.bus_id, "%02x:%02x", dev->protocol->number,
 		dev->number);
 
@@ -151,10 +156,6 @@
 	int ret;
 
 	pnp_fixup_device(dev);
-	dev->dev.bus = &pnp_bus_type;
-	dev->dev.dma_mask = &dev->dma_mask;
-	dev->dma_mask = dev->dev.coherent_dma_mask = DMA_24BIT_MASK;
-	dev->dev.release = &pnp_release_device;
 	dev->status = PNP_READY;
 	spin_lock(&pnp_lock);
 	list_add_tail(&dev->global_list, &pnp_global);

-- 

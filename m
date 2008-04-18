Return-Path: <linux-kernel-owner+w=401wt.eu-S1763172AbYDRVHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763172AbYDRVHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 17:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761482AbYDRUxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 16:53:10 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:26253 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761114AbYDRUwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 16:52:15 -0400
Message-Id: <20080418205053.333482627@ldl.fc.hp.com>
References: <20080418204955.342963315@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Apr 2008 14:50:25 -0600
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
Subject: [patch 30/53] PNP: convert resource initializers to use pnp_get_resource(), not pnp_resource_table
Content-Disposition: inline; filename=pnp-convert-inits-to-pnp_get_resource
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes more direct references to pnp_resource_table.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work8/drivers/pnp/manager.c
===================================================================
--- work8.orig/drivers/pnp/manager.c	2008-04-10 16:50:03.000000000 -0600
+++ work8/drivers/pnp/manager.c	2008-04-10 16:59:08.000000000 -0600
@@ -232,17 +232,17 @@
  */
 void pnp_init_resources(struct pnp_dev *dev)
 {
-	struct pnp_resource_table *table = &dev->res;
-	int idx;
+	struct resource *res;
+	int i;
 
-	for (idx = 0; idx < PNP_MAX_IRQ; idx++)
-		pnp_init_resource(&table->irq_resource[idx]);
-	for (idx = 0; idx < PNP_MAX_DMA; idx++)
-		pnp_init_resource(&table->dma_resource[idx]);
-	for (idx = 0; idx < PNP_MAX_PORT; idx++)
-		pnp_init_resource(&table->port_resource[idx]);
-	for (idx = 0; idx < PNP_MAX_MEM; idx++)
-		pnp_init_resource(&table->mem_resource[idx]);
+	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_IRQ, i)); i++)
+		pnp_init_resource(res);
+	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_DMA, i)); i++)
+		pnp_init_resource(res);
+	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_IO, i)); i++)
+		pnp_init_resource(res);
+	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_MEM, i)); i++)
+		pnp_init_resource(res);
 }
 
 /**
@@ -251,24 +251,24 @@
  */
 static void pnp_clean_resource_table(struct pnp_dev *dev)
 {
-	struct pnp_resource_table *table = &dev->res;
-	int idx;
+	struct resource *res;
+	int i;
 
-	for (idx = 0; idx < PNP_MAX_IRQ; idx++) {
-		if (table->irq_resource[idx].flags & IORESOURCE_AUTO)
-			pnp_init_resource(&table->irq_resource[idx]);
-	}
-	for (idx = 0; idx < PNP_MAX_DMA; idx++) {
-		if (table->dma_resource[idx].flags & IORESOURCE_AUTO)
-			pnp_init_resource(&table->dma_resource[idx]);
-	}
-	for (idx = 0; idx < PNP_MAX_PORT; idx++) {
-		if (table->port_resource[idx].flags & IORESOURCE_AUTO)
-			pnp_init_resource(&table->port_resource[idx]);
-	}
-	for (idx = 0; idx < PNP_MAX_MEM; idx++) {
-		if (table->mem_resource[idx].flags & IORESOURCE_AUTO)
-			pnp_init_resource(&table->mem_resource[idx]);
+	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_IRQ, i)); i++) {
+		if (res->flags & IORESOURCE_AUTO)
+			pnp_init_resource(res);
+	}
+	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_DMA, i)); i++) {
+		if (res->flags & IORESOURCE_AUTO)
+			pnp_init_resource(res);
+	}
+	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_IO, i)); i++) {
+		if (res->flags & IORESOURCE_AUTO)
+			pnp_init_resource(res);
+	}
+	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_MEM, i)); i++) {
+		if (res->flags & IORESOURCE_AUTO)
+			pnp_init_resource(res);
 	}
 }
 

-- 

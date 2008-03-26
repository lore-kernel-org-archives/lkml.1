Return-Path: <linux-kernel-owner+w=401wt.eu-S1758770AbYCZRT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770AbYCZRT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 13:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761434AbYCZRJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 13:09:40 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:32680 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758095AbYCZRJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 13:09:16 -0400
Message-Id: <20080326171229.768083784@ldl.fc.hp.com>
References: <20080326171058.099442579@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Wed, 26 Mar 2008 11:11:30 -0600
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
Subject: [patch 32/37] PNP: convert resource assign functions to use pnp_get_resource(), not pnp_resource_table
Content-Disposition: inline; filename=pnp-convert-assign-to-pnp_get_resource
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes more direct references to pnp_resource_table.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work7/drivers/pnp/manager.c
===================================================================
--- work7.orig/drivers/pnp/manager.c	2008-03-25 09:11:25.000000000 -0600
+++ work7/drivers/pnp/manager.c	2008-03-25 09:18:54.000000000 -0600
@@ -19,6 +19,7 @@
 
 static int pnp_assign_port(struct pnp_dev *dev, struct pnp_port *rule, int idx)
 {
+	struct resource *res;
 	resource_size_t *start, *end;
 	unsigned long *flags;
 
@@ -28,13 +29,15 @@
 		return 1;
 	}
 
+	res = pnp_get_resource(dev, IORESOURCE_IO, idx);
+
 	/* check if this resource has been manually set, if so skip */
-	if (!(dev->res.port_resource[idx].flags & IORESOURCE_AUTO))
+	if (!(res->flags & IORESOURCE_AUTO))
 		return 1;
 
-	start = &dev->res.port_resource[idx].start;
-	end = &dev->res.port_resource[idx].end;
-	flags = &dev->res.port_resource[idx].flags;
+	start = &res->start;
+	end = &res->end;
+	flags = &res->flags;
 
 	/* set the initial values */
 	*flags |= rule->flags | IORESOURCE_IO;
@@ -60,6 +63,7 @@
 
 static int pnp_assign_mem(struct pnp_dev *dev, struct pnp_mem *rule, int idx)
 {
+	struct resource *res;
 	resource_size_t *start, *end;
 	unsigned long *flags;
 
@@ -69,13 +73,15 @@
 		return 1;
 	}
 
+	res = pnp_get_resource(dev, IORESOURCE_MEM, idx);
+
 	/* check if this resource has been manually set, if so skip */
-	if (!(dev->res.mem_resource[idx].flags & IORESOURCE_AUTO))
+	if (!(res->flags & IORESOURCE_AUTO))
 		return 1;
 
-	start = &dev->res.mem_resource[idx].start;
-	end = &dev->res.mem_resource[idx].end;
-	flags = &dev->res.mem_resource[idx].flags;
+	start = &res->start;
+	end = &res->end;
+	flags = &res->flags;
 
 	/* set the initial values */
 	*flags |= rule->flags | IORESOURCE_MEM;
@@ -111,6 +117,7 @@
 
 static int pnp_assign_irq(struct pnp_dev *dev, struct pnp_irq *rule, int idx)
 {
+	struct resource *res;
 	resource_size_t *start, *end;
 	unsigned long *flags;
 	int i;
@@ -126,13 +133,15 @@
 		return 1;
 	}
 
+	res = pnp_get_resource(dev, IORESOURCE_IRQ, idx);
+
 	/* check if this resource has been manually set, if so skip */
-	if (!(dev->res.irq_resource[idx].flags & IORESOURCE_AUTO))
+	if (!(res->flags & IORESOURCE_AUTO))
 		return 1;
 
-	start = &dev->res.irq_resource[idx].start;
-	end = &dev->res.irq_resource[idx].end;
-	flags = &dev->res.irq_resource[idx].flags;
+	start = &res->start;
+	end = &res->end;
+	flags = &res->flags;
 
 	/* set the initial values */
 	*flags |= rule->flags | IORESOURCE_IRQ;
@@ -161,6 +170,7 @@
 
 static void pnp_assign_dma(struct pnp_dev *dev, struct pnp_dma *rule, int idx)
 {
+	struct resource *res;
 	resource_size_t *start, *end;
 	unsigned long *flags;
 	int i;
@@ -175,13 +185,15 @@
 		return;
 	}
 
+	res = pnp_get_resource(dev, IORESOURCE_DMA, idx);
+
 	/* check if this resource has been manually set, if so skip */
-	if (!(dev->res.dma_resource[idx].flags & IORESOURCE_AUTO))
+	if (!(res->flags & IORESOURCE_AUTO))
 		return;
 
-	start = &dev->res.dma_resource[idx].start;
-	end = &dev->res.dma_resource[idx].end;
-	flags = &dev->res.dma_resource[idx].flags;
+	start = &res->start;
+	end = &res->end;
+	flags = &res->flags;
 
 	/* set the initial values */
 	*flags |= rule->flags | IORESOURCE_DMA;

-- 

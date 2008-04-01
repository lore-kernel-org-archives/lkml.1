Return-Path: <linux-kernel-owner+w=401wt.eu-S1760347AbYDAPaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760347AbYDAPaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 11:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759535AbYDAPTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 11:19:12 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:35256 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759446AbYDAPSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 11:18:46 -0400
Message-Id: <20080401151742.059355078@ldl.fc.hp.com>
References: <20080401151634.730901933@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Tue, 01 Apr 2008 09:17:06 -0600
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

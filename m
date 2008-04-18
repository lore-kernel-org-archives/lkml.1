Return-Path: <linux-kernel-owner+w=401wt.eu-S932106AbYDRVIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106AbYDRVIi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 17:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759492AbYDRUxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 16:53:18 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:26332 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758139AbYDRUwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 16:52:23 -0400
Message-Id: <20080418205054.918890545@ldl.fc.hp.com>
References: <20080418204955.342963315@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Apr 2008 14:50:33 -0600
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
Subject: [patch 38/53] PNP: add pnp_new_resource() to find a new unset pnp_resource
Content-Disposition: inline; filename=pnp-add-pnp_new_resource
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This encapsulates the code to locate a new pnp_resource of the
desired type.  Currently this uses the pnp_resource_table, but
it will soon change to find a resource in a linked list.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work8/drivers/pnp/resource.c
===================================================================
--- work8.orig/drivers/pnp/resource.c	2008-04-17 15:04:41.000000000 -0600
+++ work8/drivers/pnp/resource.c	2008-04-18 11:08:33.000000000 -0600
@@ -516,6 +516,49 @@
 }
 EXPORT_SYMBOL(pnp_get_resource);
 
+static struct pnp_resource *pnp_new_resource(struct pnp_dev *dev, int type)
+{
+	struct pnp_resource *pnp_res;
+	struct resource *res;
+	int i;
+
+	switch (type) {
+	case IORESOURCE_IO:
+		for (i = 0; i < PNP_MAX_PORT; i++) {
+			pnp_res = &dev->res->port[i];
+			res = &pnp_res->res;
+			if (res->flags & IORESOURCE_UNSET)
+				return pnp_res;
+		}
+		break;
+	case IORESOURCE_MEM:
+		for (i = 0; i < PNP_MAX_MEM; i++) {
+			pnp_res = &dev->res->mem[i];
+			res = &pnp_res->res;
+			if (res->flags & IORESOURCE_UNSET)
+				return pnp_res;
+		}
+		break;
+	case IORESOURCE_IRQ:
+		for (i = 0; i < PNP_MAX_IRQ; i++) {
+			pnp_res = &dev->res->irq[i];
+			res = &pnp_res->res;
+			if (res->flags & IORESOURCE_UNSET)
+				return pnp_res;
+		}
+		break;
+	case IORESOURCE_DMA:
+		for (i = 0; i < PNP_MAX_DMA; i++) {
+			pnp_res = &dev->res->dma[i];
+			res = &pnp_res->res;
+			if (res->flags & IORESOURCE_UNSET)
+				return pnp_res;
+		}
+		break;
+	}
+	return NULL;
+}
+
 /* format is: pnp_reserve_irq=irq1[,irq2] .... */
 static int __init pnp_setup_reserve_irq(char *str)
 {

-- 

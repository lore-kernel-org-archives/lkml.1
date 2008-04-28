Return-Path: <linux-kernel-owner+w=401wt.eu-S936533AbYD1W4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936533AbYD1W4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 18:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966748AbYD1Wh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:37:56 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:41169 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966610AbYD1WhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:37:21 -0400
Message-Id: <20080428223625.934583696@ldl.fc.hp.com>
References: <20080428223347.233593713@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 16:34:33 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 46/55] PNP: add pnp_new_resource() to find a new unset pnp_resource
Content-Disposition: inline; filename=pnp-add-pnp_new_resource
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This encapsulates the code to locate a new pnp_resource of the
desired type.  Currently this uses the pnp_resource_table, but
it will soon change to find a resource in a linked list.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work10/drivers/pnp/resource.c
===================================================================
--- work10.orig/drivers/pnp/resource.c	2008-04-28 16:09:43.000000000 -0600
+++ work10/drivers/pnp/resource.c	2008-04-28 16:09:45.000000000 -0600
@@ -538,6 +538,44 @@
 }
 EXPORT_SYMBOL(pnp_get_resource);
 
+static struct pnp_resource *pnp_new_resource(struct pnp_dev *dev, int type)
+{
+	struct pnp_resource *pnp_res;
+	int i;
+
+	switch (type) {
+	case IORESOURCE_IO:
+		for (i = 0; i < PNP_MAX_PORT; i++) {
+			pnp_res = pnp_get_pnp_resource(dev, IORESOURCE_IO, i);
+			if (pnp_res && !pnp_resource_valid(&pnp_res->res))
+				return pnp_res;
+		}
+		break;
+	case IORESOURCE_MEM:
+		for (i = 0; i < PNP_MAX_MEM; i++) {
+			pnp_res = pnp_get_pnp_resource(dev, IORESOURCE_MEM, i);
+			if (pnp_res && !pnp_resource_valid(&pnp_res->res))
+				return pnp_res;
+		}
+		break;
+	case IORESOURCE_IRQ:
+		for (i = 0; i < PNP_MAX_IRQ; i++) {
+			pnp_res = pnp_get_pnp_resource(dev, IORESOURCE_IRQ, i);
+			if (pnp_res && !pnp_resource_valid(&pnp_res->res))
+				return pnp_res;
+		}
+		break;
+	case IORESOURCE_DMA:
+		for (i = 0; i < PNP_MAX_DMA; i++) {
+			pnp_res = pnp_get_pnp_resource(dev, IORESOURCE_DMA, i);
+			if (pnp_res && !pnp_resource_valid(&pnp_res->res))
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

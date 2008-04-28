Return-Path: <linux-kernel-owner+w=401wt.eu-S967834AbYD1Wx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967834AbYD1Wx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 18:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966708AbYD1Whk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:37:40 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:12876 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966741AbYD1WhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:37:11 -0400
Message-Id: <20080428223624.499516896@ldl.fc.hp.com>
References: <20080428223347.233593713@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 16:34:26 -0600
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
Subject: [patch 39/55] PNP: remove PNP_MAX_* uses
Content-Disposition: inline; filename=pnp-remove-max-uses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some PNP_MAX_* uses.  The pnp_resource_table isn't
dynamic yet, but with pnp_get_resource(), we can start moving
away from the table size constants.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 drivers/pnp/interface.c |   43 ++++++++++++++++++------------------
 drivers/pnp/quirks.c    |   13 ++++++-----
 drivers/pnp/resource.c  |   56 +++++++++++++++++++++++++++---------------------
 drivers/pnp/system.c    |   21 ++++++++----------
 4 files changed, 70 insertions(+), 63 deletions(-)

Index: work10/drivers/pnp/interface.c
===================================================================
--- work10.orig/drivers/pnp/interface.c	2008-04-28 16:09:36.000000000 -0600
+++ work10/drivers/pnp/interface.c	2008-04-28 16:09:37.000000000 -0600
@@ -248,6 +248,7 @@
 					  char *buf)
 {
 	struct pnp_dev *dev = to_pnp_dev(dmdev);
+	struct resource *res;
 	int i, ret;
 	pnp_info_buffer_t *buffer;
 
@@ -267,50 +268,46 @@
 	else
 		pnp_printf(buffer, "disabled\n");
 
-	for (i = 0; i < PNP_MAX_PORT; i++) {
-		if (pnp_port_valid(dev, i)) {
+	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_IO, i)); i++) {
+		if (pnp_resource_valid(res)) {
 			pnp_printf(buffer, "io");
-			if (pnp_port_flags(dev, i) & IORESOURCE_DISABLED)
+			if (res->flags & IORESOURCE_DISABLED)
 				pnp_printf(buffer, " disabled\n");
 			else
 				pnp_printf(buffer, " 0x%llx-0x%llx\n",
-					   (unsigned long long)
-					   pnp_port_start(dev, i),
-					   (unsigned long long)pnp_port_end(dev,
-									    i));
+					   (unsigned long long) res->start,
+					   (unsigned long long) res->end);
 		}
 	}
-	for (i = 0; i < PNP_MAX_MEM; i++) {
-		if (pnp_mem_valid(dev, i)) {
+	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_MEM, i)); i++) {
+		if (pnp_resource_valid(res)) {
 			pnp_printf(buffer, "mem");
-			if (pnp_mem_flags(dev, i) & IORESOURCE_DISABLED)
+			if (res->flags & IORESOURCE_DISABLED)
 				pnp_printf(buffer, " disabled\n");
 			else
 				pnp_printf(buffer, " 0x%llx-0x%llx\n",
-					   (unsigned long long)
-					   pnp_mem_start(dev, i),
-					   (unsigned long long)pnp_mem_end(dev,
-									   i));
+					   (unsigned long long) res->start,
+					   (unsigned long long) res->end);
 		}
 	}
-	for (i = 0; i < PNP_MAX_IRQ; i++) {
-		if (pnp_irq_valid(dev, i)) {
+	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_IRQ, i)); i++) {
+		if (pnp_resource_valid(res)) {
 			pnp_printf(buffer, "irq");
-			if (pnp_irq_flags(dev, i) & IORESOURCE_DISABLED)
+			if (res->flags & IORESOURCE_DISABLED)
 				pnp_printf(buffer, " disabled\n");
 			else
 				pnp_printf(buffer, " %lld\n",
-					   (unsigned long long)pnp_irq(dev, i));
+					   (unsigned long long) res->start);
 		}
 	}
-	for (i = 0; i < PNP_MAX_DMA; i++) {
-		if (pnp_dma_valid(dev, i)) {
+	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_DMA, i)); i++) {
+		if (pnp_resource_valid(res)) {
 			pnp_printf(buffer, "dma");
-			if (pnp_dma_flags(dev, i) & IORESOURCE_DISABLED)
+			if (res->flags & IORESOURCE_DISABLED)
 				pnp_printf(buffer, " disabled\n");
 			else
 				pnp_printf(buffer, " %lld\n",
-					   (unsigned long long)pnp_dma(dev, i));
+					   (unsigned long long) res->start);
 		}
 	}
 	ret = (buffer->curr - buf);
Index: work10/drivers/pnp/quirks.c
===================================================================
--- work10.orig/drivers/pnp/quirks.c	2008-04-28 16:09:27.000000000 -0600
+++ work10/drivers/pnp/quirks.c	2008-04-28 16:09:37.000000000 -0600
@@ -138,13 +138,15 @@
 
 			pci_start = pci_resource_start(pdev, i);
 			pci_end = pci_resource_end(pdev, i);
-			for (j = 0; j < PNP_MAX_MEM; j++) {
-				if (!pnp_mem_valid(dev, j) ||
-				    pnp_mem_len(dev, j) == 0)
+			for (j = 0;
+			     (res = pnp_get_resource(dev, IORESOURCE_MEM, j));
+			     j++) {
+				if (res->flags & IORESOURCE_UNSET ||
+				    (res->start == 0 && res->end == 0))
 					continue;
 
-				pnp_start = pnp_mem_start(dev, j);
-				pnp_end = pnp_mem_end(dev, j);
+				pnp_start = res->start;
+				pnp_end = res->end;
 
 				/*
 				 * If the PNP region doesn't overlap the PCI
@@ -177,7 +179,6 @@
 					pci_name(pdev), i,
 					(unsigned long long) pci_start,
 					(unsigned long long) pci_end);
-				res = pnp_get_resource(dev, IORESOURCE_MEM, j);
 				res->flags = 0;
 			}
 		}
Index: work10/drivers/pnp/resource.c
===================================================================
--- work10.orig/drivers/pnp/resource.c	2008-04-28 16:09:34.000000000 -0600
+++ work10/drivers/pnp/resource.c	2008-04-28 16:09:37.000000000 -0600
@@ -269,9 +269,8 @@
 	}
 
 	/* check for internal conflicts */
-	for (i = 0; i < PNP_MAX_PORT; i++) {
-		tres = pnp_get_resource(dev, IORESOURCE_IO, i);
-		if (tres && tres != res && tres->flags & IORESOURCE_IO) {
+	for (i = 0; (tres = pnp_get_resource(dev, IORESOURCE_IO, i)); i++) {
+		if (tres != res && tres->flags & IORESOURCE_IO) {
 			tport = &tres->start;
 			tend = &tres->end;
 			if (ranged_conflict(port, end, tport, tend))
@@ -283,9 +282,10 @@
 	pnp_for_each_dev(tdev) {
 		if (tdev == dev)
 			continue;
-		for (i = 0; i < PNP_MAX_PORT; i++) {
-			tres = pnp_get_resource(tdev, IORESOURCE_IO, i);
-			if (tres && tres->flags & IORESOURCE_IO) {
+		for (i = 0;
+		     (tres = pnp_get_resource(tdev, IORESOURCE_IO, i));
+		     i++) {
+			if (tres->flags & IORESOURCE_IO) {
 				if (cannot_compare(tres->flags))
 					continue;
 				tport = &tres->start;
@@ -329,9 +329,8 @@
 	}
 
 	/* check for internal conflicts */
-	for (i = 0; i < PNP_MAX_MEM; i++) {
-		tres = pnp_get_resource(dev, IORESOURCE_MEM, i);
-		if (tres && tres != res && tres->flags & IORESOURCE_MEM) {
+	for (i = 0; (tres = pnp_get_resource(dev, IORESOURCE_MEM, i)); i++) {
+		if (tres != res && tres->flags & IORESOURCE_MEM) {
 			taddr = &tres->start;
 			tend = &tres->end;
 			if (ranged_conflict(addr, end, taddr, tend))
@@ -343,9 +342,10 @@
 	pnp_for_each_dev(tdev) {
 		if (tdev == dev)
 			continue;
-		for (i = 0; i < PNP_MAX_MEM; i++) {
-			tres = pnp_get_resource(tdev, IORESOURCE_MEM, i);
-			if (tres && tres->flags & IORESOURCE_MEM) {
+		for (i = 0;
+		     (tres = pnp_get_resource(tdev, IORESOURCE_MEM, i));
+		     i++) {
+			if (tres->flags & IORESOURCE_MEM) {
 				if (cannot_compare(tres->flags))
 					continue;
 				taddr = &tres->start;
@@ -388,9 +388,8 @@
 	}
 
 	/* check for internal conflicts */
-	for (i = 0; i < PNP_MAX_IRQ; i++) {
-		tres = pnp_get_resource(dev, IORESOURCE_IRQ, i);
-		if (tres && tres != res && tres->flags & IORESOURCE_IRQ) {
+	for (i = 0; (tres = pnp_get_resource(dev, IORESOURCE_IRQ, i)); i++) {
+		if (tres != res && tres->flags & IORESOURCE_IRQ) {
 			if (tres->start == *irq)
 				return 0;
 		}
@@ -422,9 +421,10 @@
 	pnp_for_each_dev(tdev) {
 		if (tdev == dev)
 			continue;
-		for (i = 0; i < PNP_MAX_IRQ; i++) {
-			tres = pnp_get_resource(tdev, IORESOURCE_IRQ, i);
-			if (tres && tres->flags & IORESOURCE_IRQ) {
+		for (i = 0;
+		     (tres = pnp_get_resource(tdev, IORESOURCE_IRQ, i));
+		     i++) {
+			if (tres->flags & IORESOURCE_IRQ) {
 				if (cannot_compare(tres->flags))
 					continue;
 				if (tres->start == *irq)
@@ -461,9 +461,8 @@
 	}
 
 	/* check for internal conflicts */
-	for (i = 0; i < PNP_MAX_DMA; i++) {
-		tres = pnp_get_resource(dev, IORESOURCE_DMA, i);
-		if (tres && tres != res && tres->flags & IORESOURCE_DMA) {
+	for (i = 0; (tres = pnp_get_resource(dev, IORESOURCE_DMA, i)); i++) {
+		if (tres != res && tres->flags & IORESOURCE_DMA) {
 			if (tres->start == *dma)
 				return 0;
 		}
@@ -481,9 +480,10 @@
 	pnp_for_each_dev(tdev) {
 		if (tdev == dev)
 			continue;
-		for (i = 0; i < PNP_MAX_DMA; i++) {
-			tres = pnp_get_resource(tdev, IORESOURCE_DMA, i);
-			if (tres && tres->flags & IORESOURCE_DMA) {
+		for (i = 0;
+		     (tres = pnp_get_resource(tdev, IORESOURCE_DMA, i));
+		     i++) {
+			if (tres->flags & IORESOURCE_DMA) {
 				if (cannot_compare(tres->flags))
 					continue;
 				if (tres->start == *dma)
Index: work10/drivers/pnp/system.c
===================================================================
--- work10.orig/drivers/pnp/system.c	2008-04-28 15:57:02.000000000 -0600
+++ work10/drivers/pnp/system.c	2008-04-28 16:09:37.000000000 -0600
@@ -56,14 +56,15 @@
 
 static void reserve_resources_of_dev(struct pnp_dev *dev)
 {
+	struct resource *res;
 	int i;
 
-	for (i = 0; i < PNP_MAX_PORT; i++) {
-		if (!pnp_port_valid(dev, i))
+	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_IO, i)); i++) {
+		if (res->flags & IORESOURCE_UNSET)
 			continue;
-		if (pnp_port_start(dev, i) == 0)
+		if (res->start == 0)
 			continue;	/* disabled */
-		if (pnp_port_start(dev, i) < 0x100)
+		if (res->start < 0x100)
 			/*
 			 * Below 0x100 is only standard PC hardware
 			 * (pics, kbd, timer, dma, ...)
@@ -73,19 +74,17 @@
 			 * So, do nothing
 			 */
 			continue;
-		if (pnp_port_end(dev, i) < pnp_port_start(dev, i))
+		if (res->end < res->start)
 			continue;	/* invalid */
 
-		reserve_range(dev, pnp_port_start(dev, i),
-			      pnp_port_end(dev, i), 1);
+		reserve_range(dev, res->start, res->end, 1);
 	}
 
-	for (i = 0; i < PNP_MAX_MEM; i++) {
-		if (!pnp_mem_valid(dev, i))
+	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_MEM, i)); i++) {
+		if (res->flags & IORESOURCE_UNSET)
 			continue;
 
-		reserve_range(dev, pnp_mem_start(dev, i),
-			      pnp_mem_end(dev, i), 0);
+		reserve_range(dev, res->start, res->end, 0);
 	}
 }
 

-- 

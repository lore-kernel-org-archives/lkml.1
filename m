Return-Path: <linux-kernel-owner+w=401wt.eu-S967589AbYD1WtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967589AbYD1WtJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 18:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966773AbYD1WhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:37:18 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:3688 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966610AbYD1Wg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:36:58 -0400
Message-Id: <20080428223622.619125086@ldl.fc.hp.com>
References: <20080428223347.233593713@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 16:34:17 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, Rene Herman <rene.herman@gmail.com>
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 30/55] PNP: use conventional "i" for loop indices
Content-Disposition: inline; filename=pnp-rename-temps
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cosmetic only: just use "i" instead of "tmp".

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-By: Rene Herman <rene.herman@gmail.com>

Index: work10/drivers/pnp/resource.c
===================================================================
--- work10.orig/drivers/pnp/resource.c	2008-04-28 16:09:26.000000000 -0600
+++ work10/drivers/pnp/resource.c	2008-04-28 16:09:31.000000000 -0600
@@ -241,7 +241,7 @@
 
 int pnp_check_port(struct pnp_dev *dev, int idx)
 {
-	int tmp;
+	int i;
 	struct pnp_dev *tdev;
 	resource_size_t *port, *end, *tport, *tend;
 
@@ -260,18 +260,18 @@
 	}
 
 	/* check if the resource is reserved */
-	for (tmp = 0; tmp < 8; tmp++) {
-		int rport = pnp_reserve_io[tmp << 1];
-		int rend = pnp_reserve_io[(tmp << 1) + 1] + rport - 1;
+	for (i = 0; i < 8; i++) {
+		int rport = pnp_reserve_io[i << 1];
+		int rend = pnp_reserve_io[(i << 1) + 1] + rport - 1;
 		if (ranged_conflict(port, end, &rport, &rend))
 			return 0;
 	}
 
 	/* check for internal conflicts */
-	for (tmp = 0; tmp < PNP_MAX_PORT && tmp != idx; tmp++) {
-		if (dev->res.port_resource[tmp].flags & IORESOURCE_IO) {
-			tport = &dev->res.port_resource[tmp].start;
-			tend = &dev->res.port_resource[tmp].end;
+	for (i = 0; i < PNP_MAX_PORT && i != idx; i++) {
+		if (dev->res.port_resource[i].flags & IORESOURCE_IO) {
+			tport = &dev->res.port_resource[i].start;
+			tend = &dev->res.port_resource[i].end;
 			if (ranged_conflict(port, end, tport, tend))
 				return 0;
 		}
@@ -281,13 +281,13 @@
 	pnp_for_each_dev(tdev) {
 		if (tdev == dev)
 			continue;
-		for (tmp = 0; tmp < PNP_MAX_PORT; tmp++) {
-			if (tdev->res.port_resource[tmp].flags & IORESOURCE_IO) {
+		for (i = 0; i < PNP_MAX_PORT; i++) {
+			if (tdev->res.port_resource[i].flags & IORESOURCE_IO) {
 				if (cannot_compare
-				    (tdev->res.port_resource[tmp].flags))
+				    (tdev->res.port_resource[i].flags))
 					continue;
-				tport = &tdev->res.port_resource[tmp].start;
-				tend = &tdev->res.port_resource[tmp].end;
+				tport = &tdev->res.port_resource[i].start;
+				tend = &tdev->res.port_resource[i].end;
 				if (ranged_conflict(port, end, tport, tend))
 					return 0;
 			}
@@ -299,7 +299,7 @@
 
 int pnp_check_mem(struct pnp_dev *dev, int idx)
 {
-	int tmp;
+	int i;
 	struct pnp_dev *tdev;
 	resource_size_t *addr, *end, *taddr, *tend;
 
@@ -318,18 +318,18 @@
 	}
 
 	/* check if the resource is reserved */
-	for (tmp = 0; tmp < 8; tmp++) {
-		int raddr = pnp_reserve_mem[tmp << 1];
-		int rend = pnp_reserve_mem[(tmp << 1) + 1] + raddr - 1;
+	for (i = 0; i < 8; i++) {
+		int raddr = pnp_reserve_mem[i << 1];
+		int rend = pnp_reserve_mem[(i << 1) + 1] + raddr - 1;
 		if (ranged_conflict(addr, end, &raddr, &rend))
 			return 0;
 	}
 
 	/* check for internal conflicts */
-	for (tmp = 0; tmp < PNP_MAX_MEM && tmp != idx; tmp++) {
-		if (dev->res.mem_resource[tmp].flags & IORESOURCE_MEM) {
-			taddr = &dev->res.mem_resource[tmp].start;
-			tend = &dev->res.mem_resource[tmp].end;
+	for (i = 0; i < PNP_MAX_MEM && i != idx; i++) {
+		if (dev->res.mem_resource[i].flags & IORESOURCE_MEM) {
+			taddr = &dev->res.mem_resource[i].start;
+			tend = &dev->res.mem_resource[i].end;
 			if (ranged_conflict(addr, end, taddr, tend))
 				return 0;
 		}
@@ -339,13 +339,13 @@
 	pnp_for_each_dev(tdev) {
 		if (tdev == dev)
 			continue;
-		for (tmp = 0; tmp < PNP_MAX_MEM; tmp++) {
-			if (tdev->res.mem_resource[tmp].flags & IORESOURCE_MEM) {
+		for (i = 0; i < PNP_MAX_MEM; i++) {
+			if (tdev->res.mem_resource[i].flags & IORESOURCE_MEM) {
 				if (cannot_compare
-				    (tdev->res.mem_resource[tmp].flags))
+				    (tdev->res.mem_resource[i].flags))
 					continue;
-				taddr = &tdev->res.mem_resource[tmp].start;
-				tend = &tdev->res.mem_resource[tmp].end;
+				taddr = &tdev->res.mem_resource[i].start;
+				tend = &tdev->res.mem_resource[i].end;
 				if (ranged_conflict(addr, end, taddr, tend))
 					return 0;
 			}
@@ -362,7 +362,7 @@
 
 int pnp_check_irq(struct pnp_dev *dev, int idx)
 {
-	int tmp;
+	int i;
 	struct pnp_dev *tdev;
 	resource_size_t *irq = &dev->res.irq_resource[idx].start;
 
@@ -375,15 +375,15 @@
 		return 0;
 
 	/* check if the resource is reserved */
-	for (tmp = 0; tmp < 16; tmp++) {
-		if (pnp_reserve_irq[tmp] == *irq)
+	for (i = 0; i < 16; i++) {
+		if (pnp_reserve_irq[i] == *irq)
 			return 0;
 	}
 
 	/* check for internal conflicts */
-	for (tmp = 0; tmp < PNP_MAX_IRQ && tmp != idx; tmp++) {
-		if (dev->res.irq_resource[tmp].flags & IORESOURCE_IRQ) {
-			if (dev->res.irq_resource[tmp].start == *irq)
+	for (i = 0; i < PNP_MAX_IRQ && i != idx; i++) {
+		if (dev->res.irq_resource[i].flags & IORESOURCE_IRQ) {
+			if (dev->res.irq_resource[i].start == *irq)
 				return 0;
 		}
 	}
@@ -414,12 +414,12 @@
 	pnp_for_each_dev(tdev) {
 		if (tdev == dev)
 			continue;
-		for (tmp = 0; tmp < PNP_MAX_IRQ; tmp++) {
-			if (tdev->res.irq_resource[tmp].flags & IORESOURCE_IRQ) {
+		for (i = 0; i < PNP_MAX_IRQ; i++) {
+			if (tdev->res.irq_resource[i].flags & IORESOURCE_IRQ) {
 				if (cannot_compare
-				    (tdev->res.irq_resource[tmp].flags))
+				    (tdev->res.irq_resource[i].flags))
 					continue;
-				if ((tdev->res.irq_resource[tmp].start == *irq))
+				if ((tdev->res.irq_resource[i].start == *irq))
 					return 0;
 			}
 		}
@@ -431,7 +431,7 @@
 int pnp_check_dma(struct pnp_dev *dev, int idx)
 {
 #ifndef CONFIG_IA64
-	int tmp;
+	int i;
 	struct pnp_dev *tdev;
 	resource_size_t *dma = &dev->res.dma_resource[idx].start;
 
@@ -444,15 +444,15 @@
 		return 0;
 
 	/* check if the resource is reserved */
-	for (tmp = 0; tmp < 8; tmp++) {
-		if (pnp_reserve_dma[tmp] == *dma)
+	for (i = 0; i < 8; i++) {
+		if (pnp_reserve_dma[i] == *dma)
 			return 0;
 	}
 
 	/* check for internal conflicts */
-	for (tmp = 0; tmp < PNP_MAX_DMA && tmp != idx; tmp++) {
-		if (dev->res.dma_resource[tmp].flags & IORESOURCE_DMA) {
-			if (dev->res.dma_resource[tmp].start == *dma)
+	for (i = 0; i < PNP_MAX_DMA && i != idx; i++) {
+		if (dev->res.dma_resource[i].flags & IORESOURCE_DMA) {
+			if (dev->res.dma_resource[i].start == *dma)
 				return 0;
 		}
 	}
@@ -469,12 +469,12 @@
 	pnp_for_each_dev(tdev) {
 		if (tdev == dev)
 			continue;
-		for (tmp = 0; tmp < PNP_MAX_DMA; tmp++) {
-			if (tdev->res.dma_resource[tmp].flags & IORESOURCE_DMA) {
+		for (i = 0; i < PNP_MAX_DMA; i++) {
+			if (tdev->res.dma_resource[i].flags & IORESOURCE_DMA) {
 				if (cannot_compare
-				    (tdev->res.dma_resource[tmp].flags))
+				    (tdev->res.dma_resource[i].flags))
 					continue;
-				if ((tdev->res.dma_resource[tmp].start == *dma))
+				if ((tdev->res.dma_resource[i].start == *dma))
 					return 0;
 			}
 		}

-- 

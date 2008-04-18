Return-Path: <linux-kernel-owner+w=401wt.eu-S1762147AbYDRVKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762147AbYDRVKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 17:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761232AbYDRUx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 16:53:27 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:21855 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761309AbYDRUwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 16:52:33 -0400
Message-Id: <20080418205056.574167384@ldl.fc.hp.com>
References: <20080418204955.342963315@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Apr 2008 14:50:41 -0600
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
Subject: [patch 46/53] PNP: remove ratelimit on add resource failures
Content-Disposition: inline; filename=pnp-remove-warning-ratelimit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We used to have a fixed-size resource table.  If a device had
twenty resources when the table only had space for ten, we didn't
need ten warnings, so we added the ratelimit.

Now that we can dynamically allocate new resources, we should
only get failures if the allocation fails.  That should be
rare enough that we don't need to ratelimit the messages.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work8/drivers/pnp/resource.c
===================================================================
--- work8.orig/drivers/pnp/resource.c	2008-04-17 14:39:12.000000000 -0600
+++ work8/drivers/pnp/resource.c	2008-04-17 14:40:09.000000000 -0600
@@ -538,15 +538,10 @@
 {
 	struct pnp_resource *pnp_res;
 	struct resource *res;
-	static unsigned char warned;
 
 	pnp_res = pnp_new_resource(dev, IORESOURCE_IRQ);
 	if (!pnp_res) {
-		if (!warned) {
-			dev_err(&dev->dev, "can't add resource for IRQ %d\n",
-				irq);
-			warned = 1;
-		}
+		dev_err(&dev->dev, "can't add resource for IRQ %d\n", irq);
 		return NULL;
 	}
 
@@ -562,15 +557,10 @@
 {
 	struct pnp_resource *pnp_res;
 	struct resource *res;
-	static unsigned char warned;
 
 	pnp_res = pnp_new_resource(dev, IORESOURCE_DMA);
 	if (!pnp_res) {
-		if (!warned) {
-			dev_err(&dev->dev, "can't add resource for DMA %d\n",
-				dma);
-			warned = 1;
-		}
+		dev_err(&dev->dev, "can't add resource for DMA %d\n", dma);
 		return NULL;
 	}
 
@@ -587,16 +577,11 @@
 {
 	struct pnp_resource *pnp_res;
 	struct resource *res;
-	static unsigned char warned;
 
 	pnp_res = pnp_new_resource(dev, IORESOURCE_IO);
 	if (!pnp_res) {
-		if (!warned) {
-			dev_err(&dev->dev, "can't add resource for IO "
-				"0x%llx-0x%llx\n",(unsigned long long) start,
-				(unsigned long long) end);
-			warned = 1;
-		}
+		dev_err(&dev->dev, "can't add resource for IO 0x%llx-0x%llx\n",
+			(unsigned long long) start, (unsigned long long) end);
 		return NULL;
 	}
 
@@ -613,16 +598,11 @@
 {
 	struct pnp_resource *pnp_res;
 	struct resource *res;
-	static unsigned char warned;
 
 	pnp_res = pnp_new_resource(dev, IORESOURCE_MEM);
 	if (!pnp_res) {
-		if (!warned) {
-			dev_err(&dev->dev, "can't add resource for MEM "
-				"0x%llx-0x%llx\n",(unsigned long long) start,
-				(unsigned long long) end);
-			warned = 1;
-		}
+		dev_err(&dev->dev, "can't add resource for MEM 0x%llx-0x%llx\n",
+			(unsigned long long) start, (unsigned long long) end);
 		return NULL;
 	}
 

-- 

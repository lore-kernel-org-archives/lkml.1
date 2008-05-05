Return-Path: <linux-kernel-owner+w=401wt.eu-S1763841AbYEEWm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763841AbYEEWm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 18:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763197AbYEEWkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 18:40:13 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:45641 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760918AbYEEWkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 18:40:04 -0400
Message-Id: <20080505224000.221859052@ldl.fc.hp.com>
References: <20080505223630.682082986@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Mon, 05 May 2008 16:36:37 -0600
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
Subject: [patch 7/8] PNP: remove ratelimit on add resource failures
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

Index: work10/drivers/pnp/resource.c
===================================================================
--- work10.orig/drivers/pnp/resource.c	2008-05-05 11:38:16.000000000 -0600
+++ work10/drivers/pnp/resource.c	2008-05-05 11:49:05.000000000 -0600
@@ -537,15 +537,10 @@ struct pnp_resource *pnp_add_irq_resourc
 {
 	struct pnp_resource *pnp_res;
 	struct resource *res;
-	static unsigned char warned;
 
 	pnp_res = pnp_new_resource(dev);
 	if (!pnp_res) {
-		if (!warned) {
-			dev_err(&dev->dev, "can't add resource for IRQ %d\n",
-				irq);
-			warned = 1;
-		}
+		dev_err(&dev->dev, "can't add resource for IRQ %d\n", irq);
 		return NULL;
 	}
 
@@ -563,15 +558,10 @@ struct pnp_resource *pnp_add_dma_resourc
 {
 	struct pnp_resource *pnp_res;
 	struct resource *res;
-	static unsigned char warned;
 
 	pnp_res = pnp_new_resource(dev);
 	if (!pnp_res) {
-		if (!warned) {
-			dev_err(&dev->dev, "can't add resource for DMA %d\n",
-				dma);
-			warned = 1;
-		}
+		dev_err(&dev->dev, "can't add resource for DMA %d\n", dma);
 		return NULL;
 	}
 
@@ -590,16 +580,12 @@ struct pnp_resource *pnp_add_io_resource
 {
 	struct pnp_resource *pnp_res;
 	struct resource *res;
-	static unsigned char warned;
 
 	pnp_res = pnp_new_resource(dev);
 	if (!pnp_res) {
-		if (!warned) {
-			dev_err(&dev->dev, "can't add resource for IO "
-				"%#llx-%#llx\n",(unsigned long long) start,
-				(unsigned long long) end);
-			warned = 1;
-		}
+		dev_err(&dev->dev, "can't add resource for IO %#llx-%#llx\n",
+			(unsigned long long) start,
+			(unsigned long long) end);
 		return NULL;
 	}
 
@@ -619,16 +605,12 @@ struct pnp_resource *pnp_add_mem_resourc
 {
 	struct pnp_resource *pnp_res;
 	struct resource *res;
-	static unsigned char warned;
 
 	pnp_res = pnp_new_resource(dev);
 	if (!pnp_res) {
-		if (!warned) {
-			dev_err(&dev->dev, "can't add resource for MEM "
-				"%#llx-%#llx\n",(unsigned long long) start,
-				(unsigned long long) end);
-			warned = 1;
-		}
+		dev_err(&dev->dev, "can't add resource for MEM %#llx-%#llx\n",
+			(unsigned long long) start,
+			(unsigned long long) end);
 		return NULL;
 	}
 

-- 

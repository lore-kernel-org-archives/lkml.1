Return-Path: <linux-kernel-owner+w=401wt.eu-S1762151AbYDRVLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762151AbYDRVLo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 17:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760407AbYDRUxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 16:53:31 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:26446 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761015AbYDRUwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 16:52:37 -0400
Message-Id: <20080418205056.963257654@ldl.fc.hp.com>
References: <20080418204955.342963315@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Apr 2008 14:50:43 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, Rene Herman <rene.herman@gmail.com>
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 48/53] PNPACPI: remove some pnp_dbg calls
Content-Disposition: inline; filename=pnpacpi-remove-debug-prints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are turned off by default and don't print much useful information
anyway.  Anybody debugging this area will likely need to add his or her
own printks anyway.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-By: Rene Herman <rene.herman@gmail.com>

Index: work8/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work8.orig/drivers/pnp/pnpacpi/rsparser.c	2008-04-17 16:13:37.000000000 -0600
+++ work8/drivers/pnp/pnpacpi/rsparser.c	2008-04-17 16:14:21.000000000 -0600
@@ -751,7 +751,6 @@
 	buffer->pointer = kzalloc(buffer->length - 1, GFP_KERNEL);
 	if (!buffer->pointer)
 		return -ENOMEM;
-	pnp_dbg("Res cnt %d", res_cnt);
 	resource = (struct acpi_resource *)buffer->pointer;
 	status = acpi_walk_resources(handle, METHOD_NAME__CRS,
 				     pnpacpi_type_resources, &resource);
@@ -909,54 +908,45 @@
 	struct acpi_resource *resource = buffer->pointer;
 	int port = 0, irq = 0, dma = 0, mem = 0;
 
-	pnp_dbg("res cnt %d", res_cnt);
 	while (i < res_cnt) {
 		switch (resource->type) {
 		case ACPI_RESOURCE_TYPE_IRQ:
-			pnp_dbg("Encode irq");
 			pnpacpi_encode_irq(resource,
 				pnp_get_resource(dev, IORESOURCE_IRQ, irq));
 			irq++;
 			break;
 
 		case ACPI_RESOURCE_TYPE_DMA:
-			pnp_dbg("Encode dma");
 			pnpacpi_encode_dma(resource,
 				pnp_get_resource(dev, IORESOURCE_DMA, dma));
 			dma++;
 			break;
 		case ACPI_RESOURCE_TYPE_IO:
-			pnp_dbg("Encode io");
 			pnpacpi_encode_io(resource,
 				pnp_get_resource(dev, IORESOURCE_IO, port));
 			port++;
 			break;
 		case ACPI_RESOURCE_TYPE_FIXED_IO:
-			pnp_dbg("Encode fixed io");
 			pnpacpi_encode_fixed_io(resource,
 				pnp_get_resource(dev, IORESOURCE_IO, port));
 			port++;
 			break;
 		case ACPI_RESOURCE_TYPE_MEMORY24:
-			pnp_dbg("Encode mem24");
 			pnpacpi_encode_mem24(resource,
 				pnp_get_resource(dev, IORESOURCE_MEM, mem));
 			mem++;
 			break;
 		case ACPI_RESOURCE_TYPE_MEMORY32:
-			pnp_dbg("Encode mem32");
 			pnpacpi_encode_mem32(resource,
 				pnp_get_resource(dev, IORESOURCE_MEM, mem));
 			mem++;
 			break;
 		case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
-			pnp_dbg("Encode fixed mem32");
 			pnpacpi_encode_fixed_mem32(resource,
 				pnp_get_resource(dev, IORESOURCE_MEM, mem));
 			mem++;
 			break;
 		case ACPI_RESOURCE_TYPE_EXTENDED_IRQ:
-			pnp_dbg("Encode ext irq");
 			pnpacpi_encode_ext_irq(resource,
 				pnp_get_resource(dev, IORESOURCE_IRQ, irq));
 			irq++;

-- 

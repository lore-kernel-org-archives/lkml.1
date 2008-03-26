Return-Path: <linux-kernel-owner+w=401wt.eu-S1763647AbYCZRRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763647AbYCZRRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 13:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760972AbYCZRJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 13:09:25 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:15734 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760998AbYCZRJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 13:09:07 -0400
Message-Id: <20080326171228.566088642@ldl.fc.hp.com>
References: <20080326171058.099442579@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Wed, 26 Mar 2008 11:11:24 -0600
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
Subject: [patch 26/37] PNPACPI: remove some pnp_dbg calls
Content-Disposition: inline; filename=pnpacpi-remove-debug-prints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are turned off by default and don't print much useful information
anyway.  Anybody debugging this area will likely need to add his or her
own printks anyway.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work7/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work7.orig/drivers/pnp/pnpacpi/rsparser.c	2008-03-25 10:14:46.000000000 -0600
+++ work7/drivers/pnp/pnpacpi/rsparser.c	2008-03-25 10:14:50.000000000 -0600
@@ -701,7 +701,6 @@
 	buffer->pointer = kzalloc(buffer->length - 1, GFP_KERNEL);
 	if (!buffer->pointer)
 		return -ENOMEM;
-	pnp_dbg("Res cnt %d", res_cnt);
 	resource = (struct acpi_resource *)buffer->pointer;
 	status = acpi_walk_resources(handle, METHOD_NAME__CRS,
 				     pnpacpi_type_resources, &resource);
@@ -860,56 +859,47 @@
 	struct acpi_resource *resource = buffer->pointer;
 	int port = 0, irq = 0, dma = 0, mem = 0;
 
-	pnp_dbg("res cnt %d", res_cnt);
 	while (i < res_cnt) {
 		switch (resource->type) {
 		case ACPI_RESOURCE_TYPE_IRQ:
-			pnp_dbg("Encode irq");
 			pnpacpi_encode_irq(resource,
 					   &res_table->irq_resource[irq]);
 			irq++;
 			break;
 
 		case ACPI_RESOURCE_TYPE_DMA:
-			pnp_dbg("Encode dma");
 			pnpacpi_encode_dma(resource,
 					   &res_table->dma_resource[dma]);
 			dma++;
 			break;
 		case ACPI_RESOURCE_TYPE_IO:
-			pnp_dbg("Encode io");
 			pnpacpi_encode_io(resource,
 					  &res_table->port_resource[port]);
 			port++;
 			break;
 		case ACPI_RESOURCE_TYPE_FIXED_IO:
-			pnp_dbg("Encode fixed io");
 			pnpacpi_encode_fixed_io(resource,
 						&res_table->
 						port_resource[port]);
 			port++;
 			break;
 		case ACPI_RESOURCE_TYPE_MEMORY24:
-			pnp_dbg("Encode mem24");
 			pnpacpi_encode_mem24(resource,
 					     &res_table->mem_resource[mem]);
 			mem++;
 			break;
 		case ACPI_RESOURCE_TYPE_MEMORY32:
-			pnp_dbg("Encode mem32");
 			pnpacpi_encode_mem32(resource,
 					     &res_table->mem_resource[mem]);
 			mem++;
 			break;
 		case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
-			pnp_dbg("Encode fixed mem32");
 			pnpacpi_encode_fixed_mem32(resource,
 						   &res_table->
 						   mem_resource[mem]);
 			mem++;
 			break;
 		case ACPI_RESOURCE_TYPE_EXTENDED_IRQ:
-			pnp_dbg("Encode ext irq");
 			pnpacpi_encode_ext_irq(resource,
 					       &res_table->irq_resource[irq]);
 			irq++;

-- 

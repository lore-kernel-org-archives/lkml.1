Return-Path: <linux-kernel-owner+w=401wt.eu-S1761019AbYCZRNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761019AbYCZRNM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 13:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760789AbYCZRIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 13:08:51 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:15553 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760513AbYCZRIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 13:08:45 -0400
Message-Id: <20080326171225.941513702@ldl.fc.hp.com>
References: <20080326171058.099442579@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Wed, 26 Mar 2008 11:11:11 -0600
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
Subject: [patch 13/37] PNPACPI: hoist dma_flags() out of pnpacpi_parse_allocated_dmaresource()
Content-Disposition: inline; filename=pnpacpi-hoist-dma-flags
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hoist dma_flags() out of pnpacpi_parse_allocated_dmaresource() into its
caller.  This makes pnpacpi_parse_allocated_dmaresource() more similar
to pnpbios_parse_allocated_dmaresource().

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work7/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work7.orig/drivers/pnp/pnpacpi/rsparser.c	2008-03-21 15:08:36.000000000 -0600
+++ work7/drivers/pnp/pnpacpi/rsparser.c	2008-03-21 15:10:22.000000000 -0600
@@ -167,8 +167,7 @@
 }
 
 static void pnpacpi_parse_allocated_dmaresource(struct pnp_resource_table *res,
-						u32 dma, int type,
-						int bus_master, int transfer)
+						u32 dma, int flags)
 {
 	int i = 0;
 	static unsigned char warned;
@@ -178,8 +177,7 @@
 		i++;
 	if (i < PNP_MAX_DMA) {
 		res->dma_resource[i].flags = IORESOURCE_DMA;	// Also clears _UNSET flag
-		res->dma_resource[i].flags |=
-		    dma_flags(type, bus_master, transfer);
+		res->dma_resource[i].flags |= flags;
 		if (dma == -1) {
 			res->dma_resource[i].flags |= IORESOURCE_DISABLED;
 			return;
@@ -309,9 +307,8 @@
 		if (dma->channel_count > 0)
 			pnpacpi_parse_allocated_dmaresource(res_table,
 				dma->channels[0],
-				dma->type,
-				dma->bus_master,
-				dma->transfer);
+				dma_flags(dma->type, dma->bus_master,
+					  dma->transfer));
 		break;
 
 	case ACPI_RESOURCE_TYPE_IO:

-- 

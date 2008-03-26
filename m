Return-Path: <linux-kernel-owner+w=401wt.eu-S1762632AbYCZRMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762632AbYCZRMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 13:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760767AbYCZRIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 13:08:49 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:15535 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759527AbYCZRIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 13:08:44 -0400
Message-Id: <20080326171225.743406870@ldl.fc.hp.com>
References: <20080326171058.099442579@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Wed, 26 Mar 2008 11:11:10 -0600
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
Subject: [patch 12/37] PNPACPI: use temporaries to reduce repetition
Content-Disposition: inline; filename=pnpacpi-use-acpi-resource-temporaries
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change, just fewer words and fewer chances for
transcription errors.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work7/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work7.orig/drivers/pnp/pnpacpi/rsparser.c	2008-03-20 12:07:31.000000000 -0600
+++ work7/drivers/pnp/pnpacpi/rsparser.c	2008-03-20 12:14:54.000000000 -0600
@@ -278,6 +278,14 @@
 					      void *data)
 {
 	struct pnp_resource_table *res_table = data;
+	struct acpi_resource_irq *irq;
+	struct acpi_resource_dma *dma;
+	struct acpi_resource_io *io;
+	struct acpi_resource_fixed_io *fixed_io;
+	struct acpi_resource_memory24 *memory24;
+	struct acpi_resource_memory32 *memory32;
+	struct acpi_resource_fixed_memory32 *fixed_memory32;
+	struct acpi_resource_extended_irq *extended_irq;
 	int i;
 
 	switch (res->type) {
@@ -286,29 +294,32 @@
 		 * Per spec, only one interrupt per descriptor is allowed in
 		 * _CRS, but some firmware violates this, so parse them all.
 		 */
-		for (i = 0; i < res->data.irq.interrupt_count; i++) {
+		irq = &res->data.irq;
+		for (i = 0; i < irq->interrupt_count; i++) {
 			pnpacpi_parse_allocated_irqresource(res_table,
-				res->data.irq.interrupts[i],
-				res->data.irq.triggering,
-				res->data.irq.polarity,
-				res->data.irq.sharable);
+				irq->interrupts[i],
+				irq->triggering,
+				irq->polarity,
+				irq->sharable);
 		}
 		break;
 
 	case ACPI_RESOURCE_TYPE_DMA:
-		if (res->data.dma.channel_count > 0)
+		dma = &res->data.dma;
+		if (dma->channel_count > 0)
 			pnpacpi_parse_allocated_dmaresource(res_table,
-				res->data.dma.channels[0],
-				res->data.dma.type,
-				res->data.dma.bus_master,
-				res->data.dma.transfer);
+				dma->channels[0],
+				dma->type,
+				dma->bus_master,
+				dma->transfer);
 		break;
 
 	case ACPI_RESOURCE_TYPE_IO:
+		io = &res->data.io;
 		pnpacpi_parse_allocated_ioresource(res_table,
-			res->data.io.minimum,
-			res->data.io.address_length,
-			res->data.io.io_decode);
+			io->minimum,
+			io->address_length,
+			io->io_decode);
 		break;
 
 	case ACPI_RESOURCE_TYPE_START_DEPENDENT:
@@ -316,9 +327,10 @@
 		break;
 
 	case ACPI_RESOURCE_TYPE_FIXED_IO:
+		fixed_io = &res->data.fixed_io;
 		pnpacpi_parse_allocated_ioresource(res_table,
-			res->data.fixed_io.address,
-			res->data.fixed_io.address_length,
+			fixed_io->address,
+			fixed_io->address_length,
 			ACPI_DECODE_10);
 		break;
 
@@ -329,22 +341,25 @@
 		break;
 
 	case ACPI_RESOURCE_TYPE_MEMORY24:
+		memory24 = &res->data.memory24;
 		pnpacpi_parse_allocated_memresource(res_table,
-			res->data.memory24.minimum,
-			res->data.memory24.address_length,
-			res->data.memory24.write_protect);
+			memory24->minimum,
+			memory24->address_length,
+			memory24->write_protect);
 		break;
 	case ACPI_RESOURCE_TYPE_MEMORY32:
+		memory32 = &res->data.memory32;
 		pnpacpi_parse_allocated_memresource(res_table,
-			res->data.memory32.minimum,
-			res->data.memory32.address_length,
-			res->data.memory32.write_protect);
+			memory32->minimum,
+			memory32->address_length,
+			memory32->write_protect);
 		break;
 	case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
+		fixed_memory32 = &res->data.fixed_memory32;
 		pnpacpi_parse_allocated_memresource(res_table,
-			res->data.fixed_memory32.address,
-			res->data.fixed_memory32.address_length,
-			res->data.fixed_memory32.write_protect);
+			fixed_memory32->address,
+			fixed_memory32->address_length,
+			fixed_memory32->write_protect);
 		break;
 	case ACPI_RESOURCE_TYPE_ADDRESS16:
 	case ACPI_RESOURCE_TYPE_ADDRESS32:
@@ -358,15 +373,16 @@
 		break;
 
 	case ACPI_RESOURCE_TYPE_EXTENDED_IRQ:
-		if (res->data.extended_irq.producer_consumer == ACPI_PRODUCER)
+		extended_irq = &res->data.extended_irq;
+		if (extended_irq->producer_consumer == ACPI_PRODUCER)
 			return AE_OK;
 
-		for (i = 0; i < res->data.extended_irq.interrupt_count; i++) {
+		for (i = 0; i < extended_irq->interrupt_count; i++) {
 			pnpacpi_parse_allocated_irqresource(res_table,
-				res->data.extended_irq.interrupts[i],
-				res->data.extended_irq.triggering,
-				res->data.extended_irq.polarity,
-				res->data.extended_irq.sharable);
+				extended_irq->interrupts[i],
+				extended_irq->triggering,
+				extended_irq->polarity,
+				extended_irq->sharable);
 		}
 		break;
 
@@ -795,122 +811,136 @@
 static void pnpacpi_encode_irq(struct acpi_resource *resource,
 			       struct resource *p)
 {
+	struct acpi_resource_irq *irq = &resource->data.irq;
 	int triggering, polarity;
 
 	decode_irq_flags(p->flags & IORESOURCE_BITS, &triggering, &polarity);
-	resource->data.irq.triggering = triggering;
-	resource->data.irq.polarity = polarity;
+	irq->triggering = triggering;
+	irq->polarity = polarity;
 	if (triggering == ACPI_EDGE_SENSITIVE)
-		resource->data.irq.sharable = ACPI_EXCLUSIVE;
+		irq->sharable = ACPI_EXCLUSIVE;
 	else
-		resource->data.irq.sharable = ACPI_SHARED;
-	resource->data.irq.interrupt_count = 1;
-	resource->data.irq.interrupts[0] = p->start;
+		irq->sharable = ACPI_SHARED;
+	irq->interrupt_count = 1;
+	irq->interrupts[0] = p->start;
 }
 
 static void pnpacpi_encode_ext_irq(struct acpi_resource *resource,
 				   struct resource *p)
 {
+	struct acpi_resource_extended_irq *extended_irq = &resource->data.extended_irq;
 	int triggering, polarity;
 
 	decode_irq_flags(p->flags & IORESOURCE_BITS, &triggering, &polarity);
-	resource->data.extended_irq.producer_consumer = ACPI_CONSUMER;
-	resource->data.extended_irq.triggering = triggering;
-	resource->data.extended_irq.polarity = polarity;
+	extended_irq->producer_consumer = ACPI_CONSUMER;
+	extended_irq->triggering = triggering;
+	extended_irq->polarity = polarity;
 	if (triggering == ACPI_EDGE_SENSITIVE)
-		resource->data.extended_irq.sharable = ACPI_EXCLUSIVE;
+		extended_irq->sharable = ACPI_EXCLUSIVE;
 	else
-		resource->data.extended_irq.sharable = ACPI_SHARED;
-	resource->data.extended_irq.interrupt_count = 1;
-	resource->data.extended_irq.interrupts[0] = p->start;
+		extended_irq->sharable = ACPI_SHARED;
+	extended_irq->interrupt_count = 1;
+	extended_irq->interrupts[0] = p->start;
 }
 
 static void pnpacpi_encode_dma(struct acpi_resource *resource,
 			       struct resource *p)
 {
+	struct acpi_resource_dma *dma = &resource->data.dma;
+
 	/* Note: pnp_assign_dma will copy pnp_dma->flags into p->flags */
 	switch (p->flags & IORESOURCE_DMA_SPEED_MASK) {
 	case IORESOURCE_DMA_TYPEA:
-		resource->data.dma.type = ACPI_TYPE_A;
+		dma->type = ACPI_TYPE_A;
 		break;
 	case IORESOURCE_DMA_TYPEB:
-		resource->data.dma.type = ACPI_TYPE_B;
+		dma->type = ACPI_TYPE_B;
 		break;
 	case IORESOURCE_DMA_TYPEF:
-		resource->data.dma.type = ACPI_TYPE_F;
+		dma->type = ACPI_TYPE_F;
 		break;
 	default:
-		resource->data.dma.type = ACPI_COMPATIBILITY;
+		dma->type = ACPI_COMPATIBILITY;
 	}
 
 	switch (p->flags & IORESOURCE_DMA_TYPE_MASK) {
 	case IORESOURCE_DMA_8BIT:
-		resource->data.dma.transfer = ACPI_TRANSFER_8;
+		dma->transfer = ACPI_TRANSFER_8;
 		break;
 	case IORESOURCE_DMA_8AND16BIT:
-		resource->data.dma.transfer = ACPI_TRANSFER_8_16;
+		dma->transfer = ACPI_TRANSFER_8_16;
 		break;
 	default:
-		resource->data.dma.transfer = ACPI_TRANSFER_16;
+		dma->transfer = ACPI_TRANSFER_16;
 	}
 
-	resource->data.dma.bus_master = !!(p->flags & IORESOURCE_DMA_MASTER);
-	resource->data.dma.channel_count = 1;
-	resource->data.dma.channels[0] = p->start;
+	dma->bus_master = !!(p->flags & IORESOURCE_DMA_MASTER);
+	dma->channel_count = 1;
+	dma->channels[0] = p->start;
 }
 
 static void pnpacpi_encode_io(struct acpi_resource *resource,
 			      struct resource *p)
 {
+	struct acpi_resource_io *io = &resource->data.io;
+
 	/* Note: pnp_assign_port will copy pnp_port->flags into p->flags */
-	resource->data.io.io_decode = (p->flags & PNP_PORT_FLAG_16BITADDR) ?
+	io->io_decode = (p->flags & PNP_PORT_FLAG_16BITADDR) ?
 	    ACPI_DECODE_16 : ACPI_DECODE_10;
-	resource->data.io.minimum = p->start;
-	resource->data.io.maximum = p->end;
-	resource->data.io.alignment = 0;	/* Correct? */
-	resource->data.io.address_length = p->end - p->start + 1;
+	io->minimum = p->start;
+	io->maximum = p->end;
+	io->alignment = 0;	/* Correct? */
+	io->address_length = p->end - p->start + 1;
 }
 
 static void pnpacpi_encode_fixed_io(struct acpi_resource *resource,
 				    struct resource *p)
 {
-	resource->data.fixed_io.address = p->start;
-	resource->data.fixed_io.address_length = p->end - p->start + 1;
+	struct acpi_resource_fixed_io *fixed_io = &resource->data.fixed_io;
+
+	fixed_io->address = p->start;
+	fixed_io->address_length = p->end - p->start + 1;
 }
 
 static void pnpacpi_encode_mem24(struct acpi_resource *resource,
 				 struct resource *p)
 {
+	struct acpi_resource_memory24 *memory24 = &resource->data.memory24;
+
 	/* Note: pnp_assign_mem will copy pnp_mem->flags into p->flags */
-	resource->data.memory24.write_protect =
+	memory24->write_protect =
 	    (p->flags & IORESOURCE_MEM_WRITEABLE) ?
 	    ACPI_READ_WRITE_MEMORY : ACPI_READ_ONLY_MEMORY;
-	resource->data.memory24.minimum = p->start;
-	resource->data.memory24.maximum = p->end;
-	resource->data.memory24.alignment = 0;
-	resource->data.memory24.address_length = p->end - p->start + 1;
+	memory24->minimum = p->start;
+	memory24->maximum = p->end;
+	memory24->alignment = 0;
+	memory24->address_length = p->end - p->start + 1;
 }
 
 static void pnpacpi_encode_mem32(struct acpi_resource *resource,
 				 struct resource *p)
 {
-	resource->data.memory32.write_protect =
+	struct acpi_resource_memory32 *memory32 = &resource->data.memory32;
+
+	memory32->write_protect =
 	    (p->flags & IORESOURCE_MEM_WRITEABLE) ?
 	    ACPI_READ_WRITE_MEMORY : ACPI_READ_ONLY_MEMORY;
-	resource->data.memory32.minimum = p->start;
-	resource->data.memory32.maximum = p->end;
-	resource->data.memory32.alignment = 0;
-	resource->data.memory32.address_length = p->end - p->start + 1;
+	memory32->minimum = p->start;
+	memory32->maximum = p->end;
+	memory32->alignment = 0;
+	memory32->address_length = p->end - p->start + 1;
 }
 
 static void pnpacpi_encode_fixed_mem32(struct acpi_resource *resource,
 				       struct resource *p)
 {
-	resource->data.fixed_memory32.write_protect =
+	struct acpi_resource_fixed_memory32 *fixed_memory32 = &resource->data.fixed_memory32;
+
+	fixed_memory32->write_protect =
 	    (p->flags & IORESOURCE_MEM_WRITEABLE) ?
 	    ACPI_READ_WRITE_MEMORY : ACPI_READ_ONLY_MEMORY;
-	resource->data.fixed_memory32.address = p->start;
-	resource->data.fixed_memory32.address_length = p->end - p->start + 1;
+	fixed_memory32->address = p->start;
+	fixed_memory32->address_length = p->end - p->start + 1;
 }
 
 int pnpacpi_encode_resources(struct pnp_resource_table *res_table,

-- 

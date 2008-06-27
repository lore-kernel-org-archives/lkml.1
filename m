Return-Path: <linux-kernel-owner+w=401wt.eu-S932225AbYF0XLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225AbYF0XLK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 19:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764313AbYF0W7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 18:59:44 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:46265 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764657AbYF0W7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 18:59:13 -0400
Message-Id: <20080627225802.779511611@ldl.fc.hp.com>
References: <20080627225651.663174474@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 16:57:13 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
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
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [patch 22/28] PNP: rename pnp_register_*_resource() local variables
Content-Disposition: inline; filename=pnp-register-renames
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change; just rename "data" to something more
descriptive.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-by: Rene Herman <rene.herman@gmail.com>

Index: work10/drivers/pnp/resource.c
===================================================================
--- work10.orig/drivers/pnp/resource.c	2008-05-20 13:23:06.000000000 -0600
+++ work10/drivers/pnp/resource.c	2008-05-20 13:24:27.000000000 -0600
@@ -80,40 +80,40 @@ struct pnp_option *pnp_register_dependen
 int pnp_register_irq_resource(struct pnp_dev *dev, struct pnp_option *option,
 			      pnp_irq_mask_t *map, unsigned char flags)
 {
-	struct pnp_irq *data, *ptr;
+	struct pnp_irq *irq, *ptr;
 #ifdef DEBUG
 	char buf[PNP_IRQ_NR];   /* hex-encoded, so this is overkill but safe */
 #endif
 
-	data = kzalloc(sizeof(struct pnp_irq), GFP_KERNEL);
-	if (!data)
+	irq = kzalloc(sizeof(struct pnp_irq), GFP_KERNEL);
+	if (!irq)
 		return -ENOMEM;
 
-	data->map = *map;
-	data->flags = flags;
+	irq->map = *map;
+	irq->flags = flags;
 
 	ptr = option->irq;
 	while (ptr && ptr->next)
 		ptr = ptr->next;
 	if (ptr)
-		ptr->next = data;
+		ptr->next = irq;
 	else
-		option->irq = data;
+		option->irq = irq;
 
 #ifdef CONFIG_PCI
 	{
 		int i;
 
 		for (i = 0; i < 16; i++)
-			if (test_bit(i, data->map.bits))
+			if (test_bit(i, irq->map.bits))
 				pcibios_penalize_isa_irq(i, 0);
 	}
 #endif
 
 #ifdef DEBUG
-	bitmap_scnprintf(buf, sizeof(buf), data->map.bits, PNP_IRQ_NR);
+	bitmap_scnprintf(buf, sizeof(buf), irq->map.bits, PNP_IRQ_NR);
 	dev_dbg(&dev->dev, "  irq bitmask %s flags %#x\n", buf,
-		data->flags);
+		irq->flags);
 #endif
 	return 0;
 }
@@ -121,25 +121,25 @@ int pnp_register_irq_resource(struct pnp
 int pnp_register_dma_resource(struct pnp_dev *dev, struct pnp_option *option,
 			      unsigned char map, unsigned char flags)
 {
-	struct pnp_dma *data, *ptr;
+	struct pnp_dma *dma, *ptr;
 
-	data = kzalloc(sizeof(struct pnp_dma), GFP_KERNEL);
-	if (!data)
+	dma = kzalloc(sizeof(struct pnp_dma), GFP_KERNEL);
+	if (!dma)
 		return -ENOMEM;
 
-	data->map = map;
-	data->flags = flags;
+	dma->map = map;
+	dma->flags = flags;
 
 	ptr = option->dma;
 	while (ptr && ptr->next)
 		ptr = ptr->next;
 	if (ptr)
-		ptr->next = data;
+		ptr->next = dma;
 	else
-		option->dma = data;
+		option->dma = dma;
 
-	dev_dbg(&dev->dev, "  dma bitmask %#x flags %#x\n", data->map,
-		data->flags);
+	dev_dbg(&dev->dev, "  dma bitmask %#x flags %#x\n", dma->map,
+		dma->flags);
 	return 0;
 }
 
@@ -148,32 +148,32 @@ int pnp_register_port_resource(struct pn
 			       resource_size_t align, resource_size_t size,
 			       unsigned char flags)
 {
-	struct pnp_port *data, *ptr;
+	struct pnp_port *port, *ptr;
 
-	data = kzalloc(sizeof(struct pnp_port), GFP_KERNEL);
-	if (!data)
+	port = kzalloc(sizeof(struct pnp_port), GFP_KERNEL);
+	if (!port)
 		return -ENOMEM;
 
-	data->min = min;
-	data->max = max;
-	data->align = align;
-	data->size = size;
-	data->flags = flags;
+	port->min = min;
+	port->max = max;
+	port->align = align;
+	port->size = size;
+	port->flags = flags;
 
 	ptr = option->port;
 	while (ptr && ptr->next)
 		ptr = ptr->next;
 	if (ptr)
-		ptr->next = data;
+		ptr->next = port;
 	else
-		option->port = data;
+		option->port = port;
 
 	dev_dbg(&dev->dev, "  io  "
 		"min %#llx max %#llx align %lld size %lld flags %#x\n",
-		(unsigned long long) data->min,
-		(unsigned long long) data->max,
-		(unsigned long long) data->align,
-		(unsigned long long) data->size, data->flags);
+		(unsigned long long) port->min,
+		(unsigned long long) port->max,
+		(unsigned long long) port->align,
+		(unsigned long long) port->size, port->flags);
 	return 0;
 }
 
@@ -182,32 +182,32 @@ int pnp_register_mem_resource(struct pnp
 			      resource_size_t align, resource_size_t size,
 			      unsigned char flags)
 {
-	struct pnp_mem *data, *ptr;
+	struct pnp_mem *mem, *ptr;
 
-	data = kzalloc(sizeof(struct pnp_mem), GFP_KERNEL);
-	if (!data)
+	mem = kzalloc(sizeof(struct pnp_mem), GFP_KERNEL);
+	if (!mem)
 		return -ENOMEM;
 
-	data->min = min;
-	data->max = max;
-	data->align = align;
-	data->size = size;
-	data->flags = flags;
+	mem->min = min;
+	mem->max = max;
+	mem->align = align;
+	mem->size = size;
+	mem->flags = flags;
 
 	ptr = option->mem;
 	while (ptr && ptr->next)
 		ptr = ptr->next;
 	if (ptr)
-		ptr->next = data;
+		ptr->next = mem;
 	else
-		option->mem = data;
+		option->mem = mem;
 
 	dev_dbg(&dev->dev, "  mem "
 		"min %#llx max %#llx align %lld size %lld flags %#x\n",
-		(unsigned long long) data->min,
-		(unsigned long long) data->max,
-		(unsigned long long) data->align,
-		(unsigned long long) data->size, data->flags);
+		(unsigned long long) mem->min,
+		(unsigned long long) mem->max,
+		(unsigned long long) mem->align,
+		(unsigned long long) mem->size, mem->flags);
 	return 0;
 }
 

-- 

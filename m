Return-Path: <linux-kernel-owner+w=401wt.eu-S1754565AbYLNUqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbYLNUqH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 15:46:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbYLNUpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 15:45:55 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:38709 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbYLNUpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 15:45:54 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 14 Dec 2008 21:45:45 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/4] firewire: standardize a variable name
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.aa7114dbd92c6a7d@s5r6.in-berlin.de>
Message-ID: <tkrat.19c7f57f54fd01f3@s5r6.in-berlin.de>
References: <tkrat.aa7114dbd92c6a7d@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"ret" is the new "retval".

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-cdev.c        |   44 ++++++++++++-------------
 drivers/firewire/fw-iso.c         |   12 +++----
 drivers/firewire/fw-ohci.c        |   51 ++++++++++++++----------------
 drivers/firewire/fw-transaction.c |    8 ++--
 4 files changed, 57 insertions(+), 58 deletions(-)

Index: linux/drivers/firewire/fw-cdev.c
===================================================================
--- linux.orig/drivers/firewire/fw-cdev.c
+++ linux/drivers/firewire/fw-cdev.c
@@ -169,13 +169,13 @@ dequeue_event(struct client *client, cha
 	unsigned long flags;
 	struct event *event;
 	size_t size, total;
-	int i, retval;
+	int i, ret;
 
-	retval = wait_event_interruptible(client->wait,
-					  !list_empty(&client->event_list) ||
-					  fw_device_is_shutdown(client->device));
-	if (retval < 0)
-		return retval;
+	ret = wait_event_interruptible(client->wait,
+			!list_empty(&client->event_list) ||
+			fw_device_is_shutdown(client->device));
+	if (ret < 0)
+		return ret;
 
 	if (list_empty(&client->event_list) &&
 		       fw_device_is_shutdown(client->device))
@@ -190,17 +190,17 @@ dequeue_event(struct client *client, cha
 	for (i = 0; i < ARRAY_SIZE(event->v) && total < count; i++) {
 		size = min(event->v[i].size, count - total);
 		if (copy_to_user(buffer + total, event->v[i].data, size)) {
-			retval = -EFAULT;
+			ret = -EFAULT;
 			goto out;
 		}
 		total += size;
 	}
-	retval = total;
+	ret = total;
 
  out:
 	kfree(event);
 
-	return retval;
+	return ret;
 }
 
 static ssize_t
@@ -958,7 +958,7 @@ static int
 dispatch_ioctl(struct client *client, unsigned int cmd, void __user *arg)
 {
 	char buffer[256];
-	int retval;
+	int ret;
 
 	if (_IOC_TYPE(cmd) != '#' ||
 	    _IOC_NR(cmd) >= ARRAY_SIZE(ioctl_handlers))
@@ -970,9 +970,9 @@ dispatch_ioctl(struct client *client, un
 			return -EFAULT;
 	}
 
-	retval = ioctl_handlers[_IOC_NR(cmd)](client, buffer);
-	if (retval < 0)
-		return retval;
+	ret = ioctl_handlers[_IOC_NR(cmd)](client, buffer);
+	if (ret < 0)
+		return ret;
 
 	if (_IOC_DIR(cmd) & _IOC_READ) {
 		if (_IOC_SIZE(cmd) > sizeof(buffer) ||
@@ -980,7 +980,7 @@ dispatch_ioctl(struct client *client, un
 			return -EFAULT;
 	}
 
-	return retval;
+	return ret;
 }
 
 static long
@@ -1014,7 +1014,7 @@ static int fw_device_op_mmap(struct file
 	struct client *client = file->private_data;
 	enum dma_data_direction direction;
 	unsigned long size;
-	int page_count, retval;
+	int page_count, ret;
 
 	if (fw_device_is_shutdown(client->device))
 		return -ENODEV;
@@ -1040,16 +1040,16 @@ static int fw_device_op_mmap(struct file
 	else
 		direction = DMA_FROM_DEVICE;
 
-	retval = fw_iso_buffer_init(&client->buffer, client->device->card,
-				    page_count, direction);
-	if (retval < 0)
-		return retval;
+	ret = fw_iso_buffer_init(&client->buffer, client->device->card,
+				 page_count, direction);
+	if (ret < 0)
+		return ret;
 
-	retval = fw_iso_buffer_map(&client->buffer, vma);
-	if (retval < 0)
+	ret = fw_iso_buffer_map(&client->buffer, vma);
+	if (ret < 0)
 		fw_iso_buffer_destroy(&client->buffer, client->device->card);
 
-	return retval;
+	return ret;
 }
 
 static int shutdown_resource(int id, void *p, void *data)
Index: linux/drivers/firewire/fw-iso.c
===================================================================
--- linux.orig/drivers/firewire/fw-iso.c
+++ linux/drivers/firewire/fw-iso.c
@@ -32,7 +32,7 @@ int
 fw_iso_buffer_init(struct fw_iso_buffer *buffer, struct fw_card *card,
 		   int page_count, enum dma_data_direction direction)
 {
-	int i, j, retval = -ENOMEM;
+	int i, j;
 	dma_addr_t address;
 
 	buffer->page_count = page_count;
@@ -69,19 +69,19 @@ fw_iso_buffer_init(struct fw_iso_buffer 
 	kfree(buffer->pages);
  out:
 	buffer->pages = NULL;
-	return retval;
+	return -ENOMEM;
 }
 
 int fw_iso_buffer_map(struct fw_iso_buffer *buffer, struct vm_area_struct *vma)
 {
 	unsigned long uaddr;
-	int i, retval;
+	int i, ret;
 
 	uaddr = vma->vm_start;
 	for (i = 0; i < buffer->page_count; i++) {
-		retval = vm_insert_page(vma, uaddr, buffer->pages[i]);
-		if (retval)
-			return retval;
+		ret = vm_insert_page(vma, uaddr, buffer->pages[i]);
+		if (ret)
+			return ret;
 		uaddr += PAGE_SIZE;
 	}
 
Index: linux/drivers/firewire/fw-transaction.c
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.c
+++ linux/drivers/firewire/fw-transaction.c
@@ -943,11 +943,11 @@ static struct fw_descriptor model_id_des
 
 static int __init fw_core_init(void)
 {
-	int retval;
+	int ret;
 
-	retval = bus_register(&fw_bus_type);
-	if (retval < 0)
-		return retval;
+	ret = bus_register(&fw_bus_type);
+	if (ret < 0)
+		return ret;
 
 	fw_cdev_major = register_chrdev(0, "firewire", &fw_device_ops);
 	if (fw_cdev_major < 0) {
Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -1209,7 +1209,7 @@ static void
 at_context_transmit(struct context *ctx, struct fw_packet *packet)
 {
 	unsigned long flags;
-	int retval;
+	int ret;
 
 	spin_lock_irqsave(&ctx->ohci->lock, flags);
 
@@ -1220,10 +1220,10 @@ at_context_transmit(struct context *ctx,
 		return;
 	}
 
-	retval = at_context_queue_packet(ctx, packet);
+	ret = at_context_queue_packet(ctx, packet);
 	spin_unlock_irqrestore(&ctx->ohci->lock, flags);
 
-	if (retval < 0)
+	if (ret < 0)
 		packet->callback(packet, &ctx->ohci->card, packet->ack);
 
 }
@@ -1595,7 +1595,7 @@ ohci_set_config_rom(struct fw_card *card
 {
 	struct fw_ohci *ohci;
 	unsigned long flags;
-	int retval = -EBUSY;
+	int ret = -EBUSY;
 	__be32 *next_config_rom;
 	dma_addr_t uninitialized_var(next_config_rom_bus);
 
@@ -1649,7 +1649,7 @@ ohci_set_config_rom(struct fw_card *card
 
 		reg_write(ohci, OHCI1394_ConfigROMmap,
 			  ohci->next_config_rom_bus);
-		retval = 0;
+		ret = 0;
 	}
 
 	spin_unlock_irqrestore(&ohci->lock, flags);
@@ -1661,13 +1661,13 @@ ohci_set_config_rom(struct fw_card *card
 	 * controller could need to access it before the bus reset
 	 * takes effect.
 	 */
-	if (retval == 0)
+	if (ret == 0)
 		fw_core_initiate_bus_reset(&ohci->card, 1);
 	else
 		dma_free_coherent(ohci->card.device, CONFIG_ROM_SIZE,
 				  next_config_rom, next_config_rom_bus);
 
-	return retval;
+	return ret;
 }
 
 static void ohci_send_request(struct fw_card *card, struct fw_packet *packet)
@@ -1689,7 +1689,7 @@ static int ohci_cancel_packet(struct fw_
 	struct fw_ohci *ohci = fw_ohci(card);
 	struct context *ctx = &ohci->at_request_ctx;
 	struct driver_data *driver_data = packet->driver_data;
-	int retval = -ENOENT;
+	int ret = -ENOENT;
 
 	tasklet_disable(&ctx->tasklet);
 
@@ -1704,12 +1704,11 @@ static int ohci_cancel_packet(struct fw_
 	driver_data->packet = NULL;
 	packet->ack = RCODE_CANCELLED;
 	packet->callback(packet, &ohci->card, packet->ack);
-	retval = 0;
-
+	ret = 0;
  out:
 	tasklet_enable(&ctx->tasklet);
 
-	return retval;
+	return ret;
 }
 
 static int
@@ -1720,7 +1719,7 @@ ohci_enable_phys_dma(struct fw_card *car
 #else
 	struct fw_ohci *ohci = fw_ohci(card);
 	unsigned long flags;
-	int n, retval = 0;
+	int n, ret = 0;
 
 	/*
 	 * FIXME:  Make sure this bitmask is cleared when we clear the busReset
@@ -1730,7 +1729,7 @@ ohci_enable_phys_dma(struct fw_card *car
 	spin_lock_irqsave(&ohci->lock, flags);
 
 	if (ohci->generation != generation) {
-		retval = -ESTALE;
+		ret = -ESTALE;
 		goto out;
 	}
 
@@ -1748,7 +1747,8 @@ ohci_enable_phys_dma(struct fw_card *car
 	flush_writes(ohci);
  out:
 	spin_unlock_irqrestore(&ohci->lock, flags);
-	return retval;
+
+	return ret;
 #endif /* CONFIG_FIREWIRE_OHCI_REMOTE_DMA */
 }
 
@@ -1892,7 +1892,7 @@ ohci_allocate_iso_context(struct fw_card
 	descriptor_callback_t callback;
 	u32 *mask, regs;
 	unsigned long flags;
-	int index, retval = -ENOMEM;
+	int index, ret = -ENOMEM;
 
 	if (type == FW_ISO_CONTEXT_TRANSMIT) {
 		mask = &ohci->it_context_mask;
@@ -1928,8 +1928,8 @@ ohci_allocate_iso_context(struct fw_card
 	if (ctx->header == NULL)
 		goto out;
 
-	retval = context_init(&ctx->context, ohci, regs, callback);
-	if (retval < 0)
+	ret = context_init(&ctx->context, ohci, regs, callback);
+	if (ret < 0)
 		goto out_with_header;
 
 	return &ctx->base;
@@ -1941,7 +1941,7 @@ ohci_allocate_iso_context(struct fw_card
 	*mask |= 1 << index;
 	spin_unlock_irqrestore(&ohci->lock, flags);
 
-	return ERR_PTR(retval);
+	return ERR_PTR(ret);
 }
 
 static int ohci_start_iso(struct fw_iso_context *base,
@@ -2291,21 +2291,20 @@ ohci_queue_iso(struct fw_iso_context *ba
 {
 	struct iso_context *ctx = container_of(base, struct iso_context, base);
 	unsigned long flags;
-	int retval;
+	int ret;
 
 	spin_lock_irqsave(&ctx->context.ohci->lock, flags);
 	if (base->type == FW_ISO_CONTEXT_TRANSMIT)
-		retval = ohci_queue_iso_transmit(base, packet, buffer, payload);
+		ret = ohci_queue_iso_transmit(base, packet, buffer, payload);
 	else if (ctx->context.ohci->use_dualbuffer)
-		retval = ohci_queue_iso_receive_dualbuffer(base, packet,
-							 buffer, payload);
+		ret = ohci_queue_iso_receive_dualbuffer(base, packet,
+							buffer, payload);
 	else
-		retval = ohci_queue_iso_receive_packet_per_buffer(base, packet,
-								buffer,
-								payload);
+		ret = ohci_queue_iso_receive_packet_per_buffer(base, packet,
+							buffer, payload);
 	spin_unlock_irqrestore(&ctx->context.ohci->lock, flags);
 
-	return retval;
+	return ret;
 }
 
 static const struct fw_card_driver ohci_driver = {

-- 
Stefan Richter
-=====-==--- ==-- -===-
http://arcgraph.de/sr/


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758113AbXGBWg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113AbXGBWg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 18:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755550AbXGBWfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 18:35:34 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:59369 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855AbXGBWfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 18:35:31 -0400
Date: Mon, 02 Jul 2007 15:34:21 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 1/4] usb: make the usb_device numa_node to get assigned from
 controller
In-reply-to: <200706291326.43563.yinghai.lu@sun.com>
To: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Greg KH <greg@kroah.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200707021534.21379.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200706291326.43563.yinghai.lu@sun.com>
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/4] usb: make the usb_device numa_node to get assigned from controller

So we can use dev_to_node(&usb_dev->dev) later in kmalloc_node to dma buffer

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
index 4a6299b..c611b3c 100644
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -253,6 +253,7 @@ usb_alloc_dev(struct usb_device *parent, struct usb_bus *bus, unsigned port1)
 	dev->dev.bus = &usb_bus_type;
 	dev->dev.type = &usb_device_type;
 	dev->dev.dma_mask = bus->controller->dma_mask;
+	set_dev_node(&dev->dev, dev_to_node(bus->controller));
 	dev->state = USB_STATE_ATTACHED;
 
 	INIT_LIST_HEAD(&dev->ep0.urb_list);

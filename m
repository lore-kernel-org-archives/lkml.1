Return-Path: <linux-kernel-owner+w=401wt.eu-S933547AbXGaSUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933547AbXGaSUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 14:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764318AbXGaSUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 14:20:39 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1547 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757405AbXGaSUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 14:20:37 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 41] drivers/net/irda/irda-usb.c: mostly kmalloc + memset conversion to k[cz]alloc
Date: Tue, 31 Jul 2007 20:20:37 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       samuel@sortiz.org, Nick Fedchik <nick@fedchik.org.ua>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707312020.37331.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/net/irda/irda-usb.c | 59694 -> 59541 (-153 bytes)
 drivers/net/irda/irda-usb.o | 170588 -> 169256 (-1332 bytes)

 drivers/net/irda/irda-usb.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/net/irda/irda-usb.c	2007-07-26 13:07:42.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/net/irda/irda-usb.c	2007-07-31 18:07:03.000000000 +0200
@@ -1561,10 +1561,9 @@ static inline struct irda_class_desc *ir
 	struct irda_class_desc *desc;
 	int ret;

-	desc = kmalloc(sizeof (*desc), GFP_KERNEL);
-	if (desc == NULL)
+	desc = kzalloc(sizeof(*desc), GFP_KERNEL);
+	if (!desc)
 		return NULL;
-	memset(desc, 0, sizeof(*desc));

 	/* USB-IrDA class spec 1.0:
 	 *	6.1.3: Standard "Get Descriptor" Device Request is not
@@ -1617,7 +1616,7 @@ static int irda_usb_probe(struct usb_int
 {
 	struct net_device *net;
 	struct usb_device *dev = interface_to_usbdev(intf);
-	struct irda_usb_cb *self = NULL;
+	struct irda_usb_cb *self;
 	struct usb_host_interface *interface;
 	struct irda_class_desc *irda_desc;
 	int ret = -ENOMEM;
@@ -1655,7 +1654,7 @@ static int irda_usb_probe(struct usb_int
 		self->header_length = USB_IRDA_HEADER;
 	}

-	self->rx_urb = kzalloc(self->max_rx_urb * sizeof(struct urb *),
+	self->rx_urb = kcalloc(self->max_rx_urb, sizeof(struct urb *),
 				GFP_KERNEL);

 	for (i = 0; i < self->max_rx_urb; i++) {
@@ -1715,7 +1714,7 @@ static int irda_usb_probe(struct usb_int
 	/* Find IrDA class descriptor */
 	irda_desc = irda_usb_find_class_desc(intf);
 	ret = -ENODEV;
-	if (irda_desc == NULL)
+	if (!irda_desc)
 		goto err_out_3;

 	if (self->needspatch) {
@@ -1738,15 +1737,13 @@ static int irda_usb_probe(struct usb_int
 	/* Don't change this buffer size and allocation without doing
 	 * some heavy and complete testing. Don't ask why :-(
 	 * Jean II */
-	self->speed_buff = kmalloc(IRDA_USB_SPEED_MTU, GFP_KERNEL);
-	if (self->speed_buff == NULL)
+	self->speed_buff = kzalloc(IRDA_USB_SPEED_MTU, GFP_KERNEL);
+	if (!self->speed_buff)
 		goto err_out_3;

-	memset(self->speed_buff, 0, IRDA_USB_SPEED_MTU);
-
 	self->tx_buff = kzalloc(IRDA_SKB_MAX_MTU + self->header_length,
 				GFP_KERNEL);
-	if (self->tx_buff == NULL)
+	if (!self->tx_buff)
 		goto err_out_4;

 	ret = irda_usb_open(self);
@@ -1767,12 +1764,11 @@ static int irda_usb_probe(struct usb_int

 		/* replace IrDA class descriptor with what patched device is now reporting */
 		irda_desc = irda_usb_find_class_desc (self->usbintf);
-		if (irda_desc == NULL) {
+		if (!irda_desc) {
 			ret = -ENODEV;
 			goto err_out_6;
 		}
-		if (self->irda_desc)
-			kfree (self->irda_desc);
+		kfree(self->irda_desc);
 		self->irda_desc = irda_desc;
 		irda_usb_init_qos(self);
 	}

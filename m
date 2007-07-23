Return-Path: <linux-kernel-owner+w=401wt.eu-S932361AbXGWQha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361AbXGWQha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762068AbXGWQhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:37:22 -0400
Received: from sicnat2.emn.fr ([193.54.76.193]:51514 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756850AbXGWQhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:37:20 -0400
From: Yoann Padioleau <padator@wanadoo.fr>
To: kernel-janitors@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] 0 -> NULL, drivers/usb/gadget/
Date: Mon, 23 Jul 2007 18:34:31 +0200
Message-ID: <874pjvgju0.fsf@wanadoo.fr>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When comparing a pointer, it's clearer to compare it to NULL than to 0.

Here is the semantic patch: 

@@
expression *E;
@@

  E ==
- 0
+ NULL

@@
expression *E;
@@

- 0
+ NULL
  == E

@@
expression *E;
@@

  E !=
- 0
+ NULL

@@
expression *E;
@@

- 0
+ NULL
  != E


PS: I have performed the same transformation on the whole kernel
and it affects around 300 files. I will send the remaining patches
if you are interested in.


Signed-off-by: Yoann Padioleau <padator@wanadoo.fr> 

 config.c      |    2 +-
 ether.c       |    2 +-
 goku_udc.c    |    2 +-
 inode.c       |    2 +-
 lh7a40x_udc.c |    2 +-
 m66592-udc.c  |    2 +-
 net2280.c     |    8 ++++----
 pxa2xx_udc.c  |    4 ++--
 pxa2xx_udc.h  |    2 +-
 s3c2410_udc.c |    2 +-
 10 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/gadget/config.c b/drivers/usb/gadget/config.c
index d18901b..c6760ae 100644
--- a/drivers/usb/gadget/config.c
+++ b/drivers/usb/gadget/config.c
@@ -50,7 +50,7 @@ usb_descriptor_fillbuf(void *buf, unsign
 		return -EINVAL;
 
 	/* fill buffer from src[] until null descriptor ptr */
-	for (; 0 != *src; src++) {
+	for (; NULL != *src; src++) {
 		unsigned		len = (*src)->bLength;
 
 		if (len > buflen)
diff --git a/drivers/usb/gadget/ether.c b/drivers/usb/gadget/ether.c
index dbaf867..2005b74 100644
--- a/drivers/usb/gadget/ether.c
+++ b/drivers/usb/gadget/ether.c
@@ -1719,7 +1719,7 @@ rx_submit (struct eth_dev *dev, struct u
 		size += sizeof (struct rndis_packet_msg_type);
 	size -= size % dev->out_ep->maxpacket;
 
-	if ((skb = alloc_skb (size + NET_IP_ALIGN, gfp_flags)) == 0) {
+	if ((skb = alloc_skb (size + NET_IP_ALIGN, gfp_flags)) == NULL) {
 		DEBUG (dev, "no rx skb\n");
 		goto enomem;
 	}
diff --git a/drivers/usb/gadget/goku_udc.c b/drivers/usb/gadget/goku_udc.c
index 349b816..55fb650 100644
--- a/drivers/usb/gadget/goku_udc.c
+++ b/drivers/usb/gadget/goku_udc.c
@@ -776,7 +776,7 @@ #endif
 
 	} /* else pio or dma irq handler advances the queue. */
 
-	if (likely(req != 0))
+	if (likely(req != NULL))
 		list_add_tail(&req->queue, &ep->queue);
 
 	if (likely(!list_empty(&ep->queue))
diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index e60745f..dcad83b 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -1394,7 +1394,7 @@ gadgetfs_setup (struct usb_gadget *gadge
 	dev->setup_abort = 0;
 	if (dev->state == STATE_DEV_UNCONNECTED) {
 #ifdef	CONFIG_USB_GADGET_DUALSPEED
-		if (gadget->speed == USB_SPEED_HIGH && dev->hs_config == 0) {
+		if (gadget->speed == USB_SPEED_HIGH && dev->hs_config == NULL) {
 			spin_unlock(&dev->lock);
 			ERROR (dev, "no high speed config??\n");
 			return -EINVAL;
diff --git a/drivers/usb/gadget/lh7a40x_udc.c b/drivers/usb/gadget/lh7a40x_udc.c
index e78c2dd..49ceb1b 100644
--- a/drivers/usb/gadget/lh7a40x_udc.c
+++ b/drivers/usb/gadget/lh7a40x_udc.c
@@ -1202,7 +1202,7 @@ static int lh7a40x_queue(struct usb_ep *
 	}
 
 	/* pio or dma irq handler advances the queue. */
-	if (likely(req != 0))
+	if (likely(req != NULL))
 		list_add_tail(&req->queue, &ep->queue);
 
 	spin_unlock_irqrestore(&dev->lock, flags);
diff --git a/drivers/usb/gadget/m66592-udc.c b/drivers/usb/gadget/m66592-udc.c
index 0174a32..6e8d5d9 100644
--- a/drivers/usb/gadget/m66592-udc.c
+++ b/drivers/usb/gadget/m66592-udc.c
@@ -1278,7 +1278,7 @@ static int m66592_queue(struct usb_ep *_
 	req->req.actual = 0;
 	req->req.status = -EINPROGRESS;
 
-	if (ep->desc == 0)	/* control */
+	if (ep->desc == NULL)	/* control */
 		start_ep0(ep, req);
 	else {
 		if (request && !ep->busy)
diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
index c3d364e..aa53a50 100644
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -2120,7 +2120,7 @@ #endif
 		return;
 
 	/* manual DMA queue advance after short OUT */
-	if (likely (ep->dma != 0)) {
+	if (likely (ep->dma != NULL)) {
 		if (t & (1 << SHORT_PACKET_TRANSFERRED_INTERRUPT)) {
 			u32	count;
 			int	stopped = ep->stopped;
@@ -2380,7 +2380,7 @@ #define	w_length	le16_to_cpu(u.r.wLength
 			/* hw handles device and interface status */
 			if (u.r.bRequestType != (USB_DIR_IN|USB_RECIP_ENDPOINT))
 				goto delegate;
-			if ((e = get_ep_by_addr (dev, w_index)) == 0
+			if ((e = get_ep_by_addr (dev, w_index)) == NULL
 					|| w_length > 2)
 				goto do_stall;
 
@@ -2408,7 +2408,7 @@ #define	w_length	le16_to_cpu(u.r.wLength
 			if (w_value != USB_ENDPOINT_HALT
 					|| w_length != 0)
 				goto do_stall;
-			if ((e = get_ep_by_addr (dev, w_index)) == 0)
+			if ((e = get_ep_by_addr (dev, w_index)) == NULL)
 				goto do_stall;
 			clear_halt (e);
 			allow_status (ep);
@@ -2425,7 +2425,7 @@ #define	w_length	le16_to_cpu(u.r.wLength
 			if (w_value != USB_ENDPOINT_HALT
 					|| w_length != 0)
 				goto do_stall;
-			if ((e = get_ep_by_addr (dev, w_index)) == 0)
+			if ((e = get_ep_by_addr (dev, w_index)) == NULL)
 				goto do_stall;
 			set_halt (e);
 			allow_status (ep);
diff --git a/drivers/usb/gadget/pxa2xx_udc.c b/drivers/usb/gadget/pxa2xx_udc.c
index 63b9521..b63710d 100644
--- a/drivers/usb/gadget/pxa2xx_udc.c
+++ b/drivers/usb/gadget/pxa2xx_udc.c
@@ -688,7 +688,7 @@ pxa2xx_ep_queue(struct usb_ep *_ep, stru
 
 	/* kickstart this i/o queue? */
 	if (list_empty(&ep->queue) && !ep->stopped) {
-		if (ep->desc == 0 /* ep0 */) {
+		if (ep->desc == NULL /* ep0 */) {
 			unsigned	length = _req->length;
 
 			switch (dev->ep0state) {
@@ -742,7 +742,7 @@ pxa2xx_ep_queue(struct usb_ep *_ep, stru
 	}
 
 	/* pio or dma irq handler advances the queue. */
-	if (likely (req != 0))
+	if (likely (req != NULL))
 		list_add_tail(&req->queue, &ep->queue);
 	local_irq_restore(flags);
 
diff --git a/drivers/usb/gadget/pxa2xx_udc.h b/drivers/usb/gadget/pxa2xx_udc.h
index 0e5d0e6..ff25984 100644
--- a/drivers/usb/gadget/pxa2xx_udc.h
+++ b/drivers/usb/gadget/pxa2xx_udc.h
@@ -232,7 +232,7 @@ dump_state(struct pxa2xx_udc *dev)
 		dev->stats.read.bytes, dev->stats.read.ops);
 
 	for (i = 1; i < PXA_UDC_NUM_ENDPOINTS; i++) {
-		if (dev->ep [i].desc == 0)
+		if (dev->ep [i].desc == NULL)
 			continue;
 		DMSG ("udccs%d = %02x\n", i, *dev->ep->reg_udccs);
 	}
diff --git a/drivers/usb/gadget/s3c2410_udc.c b/drivers/usb/gadget/s3c2410_udc.c
index 0be80c6..281b69d 100644
--- a/drivers/usb/gadget/s3c2410_udc.c
+++ b/drivers/usb/gadget/s3c2410_udc.c
@@ -1294,7 +1294,7 @@ static int s3c2410_udc_queue(struct usb_
 	}
 
 	/* pio or dma irq handler advances the queue. */
-	if (likely (req != 0))
+	if (likely (req != NULL))
 		list_add_tail(&req->queue, &ep->queue);
 
 	local_irq_restore(flags);


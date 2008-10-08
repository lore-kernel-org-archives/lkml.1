Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbYJHIKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbYJHIKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 04:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbYJHIKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 04:10:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:19138 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbYJHIKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 04:10:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=SuF3/mI+ix0WySbnQC+Sv5I07JGlzVM7ijE/69AamXjiP8kT3XHD4vdS9QpP1ItxbC
         xVzJF0qNDKZVqoKazzKTR4pNsv5ZiJC+DoWM6I89UmXiovcKUxU31Htud5JxvyZiR8Ct
         wLVPPpzyDESlL18AOAgjckNKMkJ+lyyVhrqKQ=
Subject: [PATCH] usb: avoid needless address-taking of function parameters
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 08 Oct 2008 01:10:13 -0700
Message-Id: <1223453413.8195.91.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to take the address of the function params or local variables
when the direct value byteswapping routines are available.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/usb/kaweth.c     |    6 +++---
 drivers/net/usb/pegasus.c    |   12 ++++++------
 drivers/usb/core/message.c   |    6 +++---
 drivers/usb/gadget/net2280.c |    2 +-
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/usb/kaweth.c b/drivers/net/usb/kaweth.c
index d6829db..ba73539 100644
--- a/drivers/net/usb/kaweth.c
+++ b/drivers/net/usb/kaweth.c
@@ -283,9 +283,9 @@ static int kaweth_control(struct kaweth_device *kaweth,
 
 	dr->bRequestType= requesttype;
 	dr->bRequest = request;
-	dr->wValue = cpu_to_le16p(&value);
-	dr->wIndex = cpu_to_le16p(&index);
-	dr->wLength = cpu_to_le16p(&size);
+	dr->wValue = cpu_to_le16(value);
+	dr->wIndex = cpu_to_le16(index);
+	dr->wLength = cpu_to_le16(size);
 
 	return kaweth_internal_control_msg(kaweth->dev,
 					pipe,
diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index 8c19307..98750c0 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -149,8 +149,8 @@ static int get_registers(pegasus_t * pegasus, __u16 indx, __u16 size,
 	pegasus->dr.bRequestType = PEGASUS_REQT_READ;
 	pegasus->dr.bRequest = PEGASUS_REQ_GET_REGS;
 	pegasus->dr.wValue = cpu_to_le16(0);
-	pegasus->dr.wIndex = cpu_to_le16p(&indx);
-	pegasus->dr.wLength = cpu_to_le16p(&size);
+	pegasus->dr.wIndex = cpu_to_le16(indx);
+	pegasus->dr.wLength = cpu_to_le16(size);
 	pegasus->ctrl_urb->transfer_buffer_length = size;
 
 	usb_fill_control_urb(pegasus->ctrl_urb, pegasus->usb,
@@ -207,8 +207,8 @@ static int set_registers(pegasus_t * pegasus, __u16 indx, __u16 size,
 	pegasus->dr.bRequestType = PEGASUS_REQT_WRITE;
 	pegasus->dr.bRequest = PEGASUS_REQ_SET_REGS;
 	pegasus->dr.wValue = cpu_to_le16(0);
-	pegasus->dr.wIndex = cpu_to_le16p(&indx);
-	pegasus->dr.wLength = cpu_to_le16p(&size);
+	pegasus->dr.wIndex = cpu_to_le16(indx);
+	pegasus->dr.wLength = cpu_to_le16(size);
 	pegasus->ctrl_urb->transfer_buffer_length = size;
 
 	usb_fill_control_urb(pegasus->ctrl_urb, pegasus->usb,
@@ -260,7 +260,7 @@ static int set_register(pegasus_t * pegasus, __u16 indx, __u8 data)
 	pegasus->dr.bRequestType = PEGASUS_REQT_WRITE;
 	pegasus->dr.bRequest = PEGASUS_REQ_SET_REG;
 	pegasus->dr.wValue = cpu_to_le16(data);
-	pegasus->dr.wIndex = cpu_to_le16p(&indx);
+	pegasus->dr.wIndex = cpu_to_le16(indx);
 	pegasus->dr.wLength = cpu_to_le16(1);
 	pegasus->ctrl_urb->transfer_buffer_length = 1;
 
@@ -475,7 +475,7 @@ static inline void get_node_id(pegasus_t * pegasus, __u8 * id)
 
 	for (i = 0; i < 3; i++) {
 		read_eprom_word(pegasus, i, &w16);
-		((__le16 *) id)[i] = cpu_to_le16p(&w16);
+		((__le16 *) id)[i] = cpu_to_le16(w16);
 	}
 }
 
diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index 286b443..ace0048 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -139,9 +139,9 @@ int usb_control_msg(struct usb_device *dev, unsigned int pipe, __u8 request,
 
 	dr->bRequestType = requesttype;
 	dr->bRequest = request;
-	dr->wValue = cpu_to_le16p(&value);
-	dr->wIndex = cpu_to_le16p(&index);
-	dr->wLength = cpu_to_le16p(&size);
+	dr->wValue = cpu_to_le16(value);
+	dr->wIndex = cpu_to_le16(index);
+	dr->wLength = cpu_to_le16(size);
 
 	/* dbg("usb_control_msg"); */
 
diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
index 5cfb5eb..ddb2e5b 100644
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -668,7 +668,7 @@ fill_dma_desc (struct net2280_ep *ep, struct net2280_request *req, int valid)
 
 	/* 2280 may be polling VALID_BIT through ep->dma->dmadesc */
 	wmb ();
-	td->dmacount = cpu_to_le32p (&dmacount);
+	td->dmacount = cpu_to_le32(dmacount);
 }
 
 static const u32 dmactl_default =
-- 
1.6.0.2.471.g47a76




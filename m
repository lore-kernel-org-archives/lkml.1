Return-Path: <linux-kernel-owner+w=401wt.eu-S1753805AbYKXPV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbYKXPV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 10:21:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752899AbYKXPUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 10:20:19 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:46414 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbYKXPUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 10:20:13 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/4] USBHID: use GFP_KERNEL in hid_alloc_buffers
Date: Mon, 24 Nov 2008 16:20:06 +0100
Message-Id: <1227540009-14209-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We might sleep, so no problem to use GFP_KERNEL.

While at it bring the function to coding style.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/hid/usbhid/hid-core.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index b73d917..30f3add 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -650,13 +650,16 @@ static int hid_alloc_buffers(struct usb_device *dev, struct hid_device *hid)
 {
 	struct usbhid_device *usbhid = hid->driver_data;
 
-	if (!(usbhid->inbuf = usb_buffer_alloc(dev, usbhid->bufsize, GFP_ATOMIC, &usbhid->inbuf_dma)))
-		return -1;
-	if (!(usbhid->outbuf = usb_buffer_alloc(dev, usbhid->bufsize, GFP_ATOMIC, &usbhid->outbuf_dma)))
-		return -1;
-	if (!(usbhid->cr = usb_buffer_alloc(dev, sizeof(*(usbhid->cr)), GFP_ATOMIC, &usbhid->cr_dma)))
-		return -1;
-	if (!(usbhid->ctrlbuf = usb_buffer_alloc(dev, usbhid->bufsize, GFP_ATOMIC, &usbhid->ctrlbuf_dma)))
+	usbhid->inbuf = usb_buffer_alloc(dev, usbhid->bufsize, GFP_KERNEL,
+			&usbhid->inbuf_dma);
+	usbhid->outbuf = usb_buffer_alloc(dev, usbhid->bufsize, GFP_KERNEL,
+			&usbhid->outbuf_dma);
+	usbhid->cr = usb_buffer_alloc(dev, sizeof(*usbhid->cr), GFP_KERNEL,
+			&usbhid->cr_dma);
+	usbhid->ctrlbuf = usb_buffer_alloc(dev, usbhid->bufsize, GFP_KERNEL,
+			&usbhid->ctrlbuf_dma);
+	if (!usbhid->inbuf || !usbhid->outbuf || !usbhid->cr ||
+			!usbhid->ctrlbuf)
 		return -1;
 
 	return 0;
-- 
1.6.0.4


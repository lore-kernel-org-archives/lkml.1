Return-Path: <linux-kernel-owner+w=401wt.eu-S1758333AbZCYAjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758333AbZCYAjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756876AbZCYAaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:30:07 -0400
Received: from kroah.org ([198.145.64.141]:54103 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756791AbZCYA36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:29:58 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 26/61] usb: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue, 24 Mar 2009 17:26:30 -0700
Message-Id: <1237940825-22904-26-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/usb/gadget/ci13xxx_udc.c |    2 +-
 drivers/usb/gadget/imx_udc.c     |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/ci13xxx_udc.c b/drivers/usb/gadget/ci13xxx_udc.c
index bebf911..7f4e5eb 100644
--- a/drivers/usb/gadget/ci13xxx_udc.c
+++ b/drivers/usb/gadget/ci13xxx_udc.c
@@ -2626,7 +2626,7 @@ static int udc_probe(struct device *dev, void __iomem *regs, const char *name)
 	INIT_LIST_HEAD(&udc->gadget.ep_list);
 	udc->gadget.ep0 = NULL;
 
-	strcpy(udc->gadget.dev.bus_id, "gadget");
+	dev_set_name(&udc->gadget.dev, "gadget");
 	udc->gadget.dev.dma_mask = dev->dma_mask;
 	udc->gadget.dev.parent   = dev;
 	udc->gadget.dev.release  = udc_release;
diff --git a/drivers/usb/gadget/imx_udc.c b/drivers/usb/gadget/imx_udc.c
index 77c5d0a..cd67ac7 100644
--- a/drivers/usb/gadget/imx_udc.c
+++ b/drivers/usb/gadget/imx_udc.c
@@ -1186,8 +1186,8 @@ static struct imx_udc_struct controller = {
 		.ep0		= &controller.imx_ep[0].ep,
 		.name		= driver_name,
 		.dev = {
-			 .bus_id	= "gadget",
-		 },
+			.init_name	= "gadget",
+		},
 	},
 
 	.imx_ep[0] = {
-- 
1.6.2


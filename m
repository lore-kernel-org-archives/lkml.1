Return-Path: <linux-kernel-owner+w=401wt.eu-S1760436AbZAFWbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760436AbZAFWbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:31:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755782AbZAFWOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:14:12 -0500
Received: from kroah.org ([198.145.64.141]:51324 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755805AbZAFWOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:14:08 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 49/60] gadget: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue,  6 Jan 2009 14:12:08 -0800
Message-Id: <1231279939-32728-49-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/gadget/at91_udc.c       |    2 +-
 drivers/usb/gadget/atmel_usba_udc.c |    2 +-
 drivers/usb/gadget/fsl_qe_udc.c     |    2 +-
 drivers/usb/gadget/lh7a40x_udc.c    |    2 +-
 drivers/usb/gadget/pxa25x_udc.c     |    2 +-
 drivers/usb/gadget/pxa27x_udc.c     |    2 +-
 drivers/usb/gadget/s3c2410_udc.c    |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index a8a1de4..0b2bb8f 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -1474,7 +1474,7 @@ static struct at91_udc controller = {
 		.ep0	= &controller.ep[0].ep,
 		.name	= driver_name,
 		.dev	= {
-			.bus_id = "gadget",
+			.init_name = "gadget",
 			.release = nop_release,
 		}
 	},
diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
index ae30ab1..65b03e3 100644
--- a/drivers/usb/gadget/atmel_usba_udc.c
+++ b/drivers/usb/gadget/atmel_usba_udc.c
@@ -1034,7 +1034,7 @@ static struct usba_udc the_udc = {
 		.is_dualspeed	= 1,
 		.name		= "atmel_usba_udc",
 		.dev	= {
-			.bus_id		= "gadget",
+			.init_name	= "gadget",
 			.release	= nop_release,
 		},
 	},
diff --git a/drivers/usb/gadget/fsl_qe_udc.c b/drivers/usb/gadget/fsl_qe_udc.c
index b3408ff..f402725 100644
--- a/drivers/usb/gadget/fsl_qe_udc.c
+++ b/drivers/usb/gadget/fsl_qe_udc.c
@@ -2545,7 +2545,7 @@ static int __devinit qe_udc_probe(struct of_device *ofdev,
 
 	device_initialize(&udc_controller->gadget.dev);
 
-	strcpy(udc_controller->gadget.dev.bus_id, "gadget");
+	dev_set_name(&udc_controller->gadget.dev, "gadget");
 
 	udc_controller->gadget.dev.release = qe_udc_release;
 	udc_controller->gadget.dev.parent = &ofdev->dev;
diff --git a/drivers/usb/gadget/lh7a40x_udc.c b/drivers/usb/gadget/lh7a40x_udc.c
index c6e7df0..d554b08 100644
--- a/drivers/usb/gadget/lh7a40x_udc.c
+++ b/drivers/usb/gadget/lh7a40x_udc.c
@@ -1981,7 +1981,7 @@ static struct lh7a40x_udc memory = {
 		   .ep0 = &memory.ep[0].ep,
 		   .name = driver_name,
 		   .dev = {
-			   .bus_id = "gadget",
+			   .init_name = "gadget",
 			   .release = nop_release,
 			   },
 		   },
diff --git a/drivers/usb/gadget/pxa25x_udc.c b/drivers/usb/gadget/pxa25x_udc.c
index 8c5026b..697a0ca 100644
--- a/drivers/usb/gadget/pxa25x_udc.c
+++ b/drivers/usb/gadget/pxa25x_udc.c
@@ -1833,7 +1833,7 @@ static struct pxa25x_udc memory = {
 		.ep0		= &memory.ep[0].ep,
 		.name		= driver_name,
 		.dev = {
-			.bus_id		= "gadget",
+			.init_name	= "gadget",
 			.release	= nop_release,
 		},
 	},
diff --git a/drivers/usb/gadget/pxa27x_udc.c b/drivers/usb/gadget/pxa27x_udc.c
index 944e4ff..65110d0 100644
--- a/drivers/usb/gadget/pxa27x_udc.c
+++ b/drivers/usb/gadget/pxa27x_udc.c
@@ -2162,7 +2162,7 @@ static struct pxa_udc memory = {
 		.ep0		= &memory.udc_usb_ep[0].usb_ep,
 		.name		= driver_name,
 		.dev = {
-			.bus_id		= "gadget",
+			.init_name	= "gadget",
 		},
 	},
 
diff --git a/drivers/usb/gadget/s3c2410_udc.c b/drivers/usb/gadget/s3c2410_udc.c
index 8d8d651..c7e2556 100644
--- a/drivers/usb/gadget/s3c2410_udc.c
+++ b/drivers/usb/gadget/s3c2410_udc.c
@@ -1727,7 +1727,7 @@ static struct s3c2410_udc memory = {
 		.ep0		= &memory.ep[0].ep,
 		.name		= gadget_name,
 		.dev = {
-			.bus_id		= "gadget",
+			.init_name	= "gadget",
 		},
 	},
 
-- 
1.6.0.4


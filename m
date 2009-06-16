Return-Path: <linux-kernel-owner+w=401wt.eu-S937151AbZFPGE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937151AbZFPGE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936000AbZFPFvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:51:49 -0400
Received: from kroah.org ([198.145.64.141]:48487 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935982AbZFPFvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:47 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: [PATCH 61/64] usb: gadget: at91_udc: remove driver_data direct access of struct device
Date: Mon, 15 Jun 2009 22:46:50 -0700
Message-Id: <1245131213-24168-61-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the near future, the driver core is going to not allow direct access
to the driver_data pointer in struct device.  Instead, the functions
dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
have been around since the beginning, so are backwards compatible with
all older kernel versions.

Cc: linux-usb@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/gadget/at91_udc.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index 0b2bb8f..53bcdd2 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -1574,7 +1574,7 @@ int usb_gadget_register_driver (struct usb_gadget_driver *driver)
 
 	udc->driver = driver;
 	udc->gadget.dev.driver = &driver->driver;
-	udc->gadget.dev.driver_data = &driver->driver;
+	dev_set_drvdata(&udc->gadget.dev, &driver->driver);
 	udc->enabled = 1;
 	udc->selfpowered = 1;
 
@@ -1583,7 +1583,7 @@ int usb_gadget_register_driver (struct usb_gadget_driver *driver)
 		DBG("driver->bind() returned %d\n", retval);
 		udc->driver = NULL;
 		udc->gadget.dev.driver = NULL;
-		udc->gadget.dev.driver_data = NULL;
+		dev_set_drvdata(&udc->gadget.dev, NULL);
 		udc->enabled = 0;
 		udc->selfpowered = 0;
 		return retval;
@@ -1613,7 +1613,7 @@ int usb_gadget_unregister_driver (struct usb_gadget_driver *driver)
 
 	driver->unbind(&udc->gadget);
 	udc->gadget.dev.driver = NULL;
-	udc->gadget.dev.driver_data = NULL;
+	dev_set_drvdata(&udc->gadget.dev, NULL);
 	udc->driver = NULL;
 
 	DBG("unbound from %s\n", driver->driver.name);
-- 
1.6.3.2


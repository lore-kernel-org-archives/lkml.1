Return-Path: <linux-kernel-owner+w=401wt.eu-S1759547AbXJMO6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759547AbXJMO6u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 10:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762284AbXJMOp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 10:45:26 -0400
Received: from 1wt.eu ([62.212.114.60]:3055 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762130AbXJMOpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 10:45:24 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20071013143457.%N@1wt.eu>
References: <20071013142822.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 13 Oct 2007 17:28:40 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Nathael Pajani <nathael.pajani@cpe.fr>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.21 review 18/35] USB: fix linked list insertion bugfix for usb core
Content-Disposition: inline; filename=0062-USB-fix-linked-list-insertion-bugfix-for-usb-core.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit e5dd01154c1e9ca2400f4682602d1a4fa54c25dd in mainline.

This patch fixes the order of list_add_tail() arguments in
usb_store_new_id() so the list can have more than one single element.

Signed-off-by: Nathael Pajani <nathael.pajani@cpe.fr>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/core/driver.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Index: 2.6/drivers/usb/core/driver.c
===================================================================
--- 2.6.orig/drivers/usb/core/driver.c
+++ 2.6/drivers/usb/core/driver.c
@@ -66,7 +66,7 @@ static ssize_t store_new_id(struct devic
 	dynid->id.match_flags = USB_DEVICE_ID_MATCH_DEVICE;
 
 	spin_lock(&usb_drv->dynids.lock);
-	list_add_tail(&usb_drv->dynids.list, &dynid->node);
+	list_add_tail(&dynid->node, &usb_drv->dynids.list);
 	spin_unlock(&usb_drv->dynids.lock);
 
 	if (get_driver(driver)) {

-- 

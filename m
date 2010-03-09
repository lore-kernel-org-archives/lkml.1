Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238Ab0CIFcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 00:32:10 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:32790 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756Ab0CIFcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 00:32:08 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Cc: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] USB: gadget: fix Blackfin builds after gadget cleansing
Date: Tue,  9 Mar 2010 00:35:22 -0500
Message-Id: <1268112922-21601-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent change to clean out dead gadget drivers (90f7976880bbbf99)
missed the call to gadget_is_musbhsfc() behind CONFIG_BLACKFIN.  This
causes Blackfin gadget builds to fail since the function no longer
exists anywhere.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
note: this should be merged for 2.6.34 since it's a regression to 2.6.33

 drivers/usb/gadget/epautoconf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/epautoconf.c b/drivers/usb/gadget/epautoconf.c
index 65a5f94..3568de2 100644
--- a/drivers/usb/gadget/epautoconf.c
+++ b/drivers/usb/gadget/epautoconf.c
@@ -266,7 +266,7 @@ struct usb_ep * __init usb_ep_autoconfig (
 		}
 
 #ifdef CONFIG_BLACKFIN
-	} else if (gadget_is_musbhsfc(gadget) || gadget_is_musbhdrc(gadget)) {
+	} else if (gadget_is_musbhdrc(gadget)) {
 		if ((USB_ENDPOINT_XFER_BULK == type) ||
 		    (USB_ENDPOINT_XFER_ISOC == type)) {
 			if (USB_DIR_IN & desc->bEndpointAddress)
-- 
1.7.0.2


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756573AbXIEFs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573AbXIEFs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 01:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755177AbXIEFsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 01:48:50 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:27822 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866AbXIEFst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 01:48:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=B6MBHg8PlZZCA13b4ZrF3VBh9JgDVGC29mXyoAQE8Vx734r5NlPjKyfLTb81nMVEJ+qCaoaddA8iVeeHSFUjKyY6ddtOrNnjCRtK2ZDvTxBn1g2MtxpJlfkML15jOg/GClzuOCKG6rLzjJFVx0SKpTX3tQfz/CeK6V0KCbbAPfc=
Message-ID: <46DE4386.5050107@gmail.com>
Date: Wed, 05 Sep 2007 13:49:58 +0800
From: Micah Gruber <micah.gruber@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: [PATCH] Remove unneeded pointer intf from speedtch_upload_firmware()
 in drivers/usb/atm/speedtch.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This trivial patch removes the unneeded pointer intf returned from usb_ifnum_to_if(), which is never used. The check for NULL can be simply done by if (!usb_ifnum_to_if(usb_dev, 2)).

Signed-off-by: Micah Gruber <micah.gruber@gmail.com>
---

--- a/drivers/usb/atm/speedtch.c	2007-09-04 23:18:17.000000000 +0800
+++ b/drivers/usb/atm/speedtch.c	2007-09-05 00:51:19.000000000 +0800
@@ -251,7 +251,6 @@
 {
 	unsigned char *buffer;
 	struct usbatm_data *usbatm = instance->usbatm;
-	struct usb_interface *intf;
 	struct usb_device *usb_dev = usbatm->usb_dev;
 	int actual_length;
 	int ret = 0;
@@ -265,7 +264,7 @@
 		goto out;
 	}
 
-	if (!(intf = usb_ifnum_to_if(usb_dev, 2))) {
+	if (!usb_ifnum_to_if(usb_dev, 2)) {
 		ret = -ENODEV;
 		usb_dbg(usbatm, "%s: interface not found!\n", __func__);
 		goto out_free;


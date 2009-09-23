Return-Path: <linux-kernel-owner+w=401wt.eu-S1753185AbZIWOJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbZIWOJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 10:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbZIWOJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 10:09:49 -0400
Received: from server1.wserver.cz ([82.113.45.157]:53583 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbZIWOJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 10:09:48 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] USB: usblcd, fix memory leak
Date: Wed, 23 Sep 2009 16:09:56 +0200
Message-Id: <1253714996-6495-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found a memory leak in lcd_probe. Instead of returning without
releasing the memory, jump to the error label which frees it.

http://stanse.fi.muni.cz/

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/misc/usblcd.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/misc/usblcd.c b/drivers/usb/misc/usblcd.c
index 29092b8..4fb1203 100644
--- a/drivers/usb/misc/usblcd.c
+++ b/drivers/usb/misc/usblcd.c
@@ -313,7 +313,8 @@ static int lcd_probe(struct usb_interface *interface, const struct usb_device_id
 
 	if (le16_to_cpu(dev->udev->descriptor.idProduct) != 0x0001) {
 		dev_warn(&interface->dev, "USBLCD model not supported.\n");
-		return -ENODEV;
+		retval = -ENODEV;
+		goto error;
 	}
 	
 	/* set up the endpoint information */
-- 
1.6.4.2


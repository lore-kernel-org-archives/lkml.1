Return-Path: <linux-kernel-owner+w=401wt.eu-S1762827AbYEUBMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762827AbYEUBMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 21:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764804AbYEUBL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 21:11:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38150 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764760AbYEUBL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 21:11:58 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] caiaq endianness fix
Cc: perex@perex.cz, linux-kernel@vger.kernel.org
Message-Id: <E1Jycs1-0000Ky-2v@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 21 May 2008 02:11:57 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Content-Length: 800
Lines: 23

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 sound/usb/caiaq/caiaq-device.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/usb/caiaq/caiaq-device.c b/sound/usb/caiaq/caiaq-device.c
index e97d8b2..a972f77 100644
--- a/sound/usb/caiaq/caiaq-device.c
+++ b/sound/usb/caiaq/caiaq-device.c
@@ -351,8 +351,8 @@ static struct snd_card* create_card(struct usb_device* usb_dev)
 	dev = caiaqdev(card);
 	dev->chip.dev = usb_dev;
 	dev->chip.card = card;
-	dev->chip.usb_id = USB_ID(usb_dev->descriptor.idVendor,
-					usb_dev->descriptor.idProduct);
+	dev->chip.usb_id = USB_ID(le16_to_cpu(usb_dev->descriptor.idVendor),
+				  le16_to_cpu(usb_dev->descriptor.idProduct));
 	spin_lock_init(&dev->spinlock);
 	snd_card_set_dev(card, &usb_dev->dev);
 
-- 
1.5.3.GIT



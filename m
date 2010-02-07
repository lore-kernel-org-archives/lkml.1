Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab0BGLfo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 06:35:44 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:50772 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759Ab0BGLfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 06:35:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=SnwgDFObPxhKsUdLiArd+PMHmsSXxWzp2XZvXyrsWnrHYsm6T2OzkssMF4Psh0kI59
         VauYGrbGFUfgk85cVRduPNYrRI48h+soGTsHzYEoQaOE/tbokokHtA1UJ6pZOrT9jg16
         K1xOvv0IhpCZ8DjNiKzYCUUVPdhbTrT6xjgj8=
Message-ID: <4B6EA71C.90705@gmail.com>
Date: Sun, 07 Feb 2010 12:42:20 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] usbvision-video: wrong variable tested in usbvision_register_video()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usbvision->vdev was already tested, we should test usbvision->vbi here.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/media/video/usbvision/usbvision-video.c b/drivers/media/video/usbvision/usbvision-video.c
index 1054546..7c17ec6 100644
--- a/drivers/media/video/usbvision/usbvision-video.c
+++ b/drivers/media/video/usbvision/usbvision-video.c
@@ -1487,7 +1487,7 @@ static int __devinit usbvision_register_video(struct usb_usbvision *usbvision)
 		usbvision->vbi = usbvision_vdev_init(usbvision,
 						     &usbvision_vbi_template,
 						     "USBVision VBI");
-		if (usbvision->vdev == NULL) {
+		if (usbvision->vbi == NULL) {
 			goto err_exit;
 		}
 		if (video_register_device(usbvision->vbi,

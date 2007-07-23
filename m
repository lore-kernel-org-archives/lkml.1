Return-Path: <linux-kernel-owner+w=401wt.eu-S1762736AbXGWID6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762736AbXGWID6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 04:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762734AbXGWICj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 04:02:39 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:41706 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762753AbXGWICh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 04:02:37 -0400
Date: Mon, 23 Jul 2007 10:02:03 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Thierry MERLE <thierry.merle@free.fr>,
       "Dwaine P. Garden" <dwainegarden@rogers.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: [2.6.23 regression fix] usbvision: don't return an uninitialized
	value
Message-ID: <20070723080203.GD26212@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c5f48367fe54c46805774eeea8e828de54a5ad7b introduced this return 
of an uninitialized variable.

Spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/media/video/usbvision/usbvision-video.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- linux-2.6.22-rc6-mm1/drivers/media/video/usbvision/usbvision-video.c.old	2007-07-23 01:45:01.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/media/video/usbvision/usbvision-video.c	2007-07-23 01:46:06.000000000 +0200
@@ -525,18 +525,17 @@ static int vidioc_s_register (struct fil
 {
 	struct video_device *dev = video_devdata(file);
 	struct usb_usbvision *usbvision =
 		(struct usb_usbvision *) video_get_drvdata(dev);
-	int errCode;
 
 	if (!v4l2_chip_match_host(reg->match_type, reg->match_chip))
 		return -EINVAL;
 	/* NT100x has a 8-bit register space */
 	reg->val = (u8)usbvision_write_reg(usbvision, reg->reg&0xff, reg->val);
 	if (reg->val < 0) {
 		err("%s: VIDIOC_DBG_S_REGISTER failed: error %d",
-		    __FUNCTION__, errCode);
-		return errCode;
+		    __FUNCTION__, reg->val);
+		return reg->val;
 	}
 	return 0;
 }
 #endif


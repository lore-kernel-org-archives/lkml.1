Return-Path: <linux-kernel-owner+w=401wt.eu-S1757609AbYEKTyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609AbYEKTyQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 15:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbYEKTyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 15:54:04 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:44193 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbYEKTyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 15:54:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=Boaddi+wqlFTY7rKHRoeCr2X9GDfSH2RNKs6RjR5+LYvec0oLw7KLltSXHmTDGUBR89gdeOQIKmGxg2mRhPTEHuw3E3YsuH24rduh0qC3X/QB3Ipxx1IkrjwcDIG6hylP8s3Af+1ZCQGQMup3p2pv7MfkyuzPQSUg8IuAZABox0=
Date: Sun, 11 May 2008 21:53:39 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] v4l: gp8psk_power_ctrl should return negative errors
Message-ID: <20080511195336.GD19058@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
---
compile tested only
---
 drivers/media/dvb/dvb-usb/gp8psk.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/gp8psk.c b/drivers/media/dvb/dvb-usb/gp8psk.c
--- a/drivers/media/dvb/dvb-usb/gp8psk.c
+++ b/drivers/media/dvb/dvb-usb/gp8psk.c
@@ -146,24 +146,24 @@ static int gp8psk_power_ctrl(struct dvb_usb_device *d, int onoff)
 		if (gp_product_id == USB_PID_GENPIX_8PSK_REV_1_WARM)
 			if (! (status & bm8pskFW_Loaded)) /* BCM4500 firmware loaded */
 				if(gp8psk_load_bcm4500fw(d))
-					return EINVAL;
+					return -EINVAL;
 
 		if (! (status & bmIntersilOn)) /* LNB Power */
 			if (gp8psk_usb_in_op(d, START_INTERSIL, 1, 0,
 					&buf, 1))
-				return EINVAL;
+				return -EINVAL;
 
 		/* Set DVB mode to 1 */
 		if (gp_product_id == USB_PID_GENPIX_8PSK_REV_1_WARM)
 			if (gp8psk_usb_out_op(d, SET_DVB_MODE, 1, 0, NULL, 0))
-				return EINVAL;
+				return -EINVAL;
 		/* Abort possible TS (if previous tune crashed) */
 		if (gp8psk_usb_out_op(d, ARM_TRANSFER, 0, 0, NULL, 0))
-			return EINVAL;
+			return -EINVAL;
 	} else {
 		/* Turn off LNB power */
 		if (gp8psk_usb_in_op(d, START_INTERSIL, 0, 0, &buf, 1))
-			return EINVAL;
+			return -EINVAL;
 		/* Turn off 8psk power */
 		if (gp8psk_usb_in_op(d, BOOT_8PSK, 0, 0, &buf, 1))
 			return -EINVAL;
-- 

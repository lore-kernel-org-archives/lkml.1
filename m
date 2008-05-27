Return-Path: <linux-kernel-owner+w=401wt.eu-S1757020AbYE0IDD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020AbYE0IDD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 04:03:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755246AbYE0ICs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 04:02:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55035 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755215AbYE0ICp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 04:02:45 -0400
Message-ID: <483BBFD1.3090204@cn.fujitsu.com>
Date: Tue, 27 May 2008 16:01:21 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: mchehab@infradead.org
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, video4linux-list@redhat.com
Subject: [PATCH] dvb-usb/gp8psk.c: return -errno rather than errno
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gp8psk_power_ctrl() returns -EINVAL in some failing paths, but
returns EINVAL in some other paths.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.cn>
---
 drivers/media/dvb/dvb-usb/gp8psk.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/gp8psk.c b/drivers/media/dvb/dvb-usb/gp8psk.c
index 9a942af..2653120 100644
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
-- 1.5.4.rc3

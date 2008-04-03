Return-Path: <linux-kernel-owner+w=401wt.eu-S1761469AbYDUNVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761469AbYDUNVQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759681AbYDUNSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:18:52 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:9129 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759657AbYDUNSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:18:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:in-reply-to:references:date:subject:cc:from;
        b=E+Z/TzypVtXm7wqRQAdNSokk0VnZDlC0SrPz24Xuq9FHVujaRbCkQHkiihVZF0Tw6YJNVnc5ywECAwh2Pb3IfJAeoTABcIZ1vB3MUsiv+3vG9bhI8cZTMFEBSdOcU0awc/v1YCcex1X7kUudCIX/rQVfXyPl2wu7ZUZ8UZDnqN4=
Message-Id: <97f09cb53da583cefc1ce2930de8f64b52cfc54b.1208783694.git.dmitry.torokhov@gmail.com>
In-Reply-To: <cover.1208783694.git.dmitry.torokhov@gmail.com>
References: <cover.1208783694.git.dmitry.torokhov@gmail.com>
Date: Thu, 3 Apr 2008 16:18:23 -0400
Subject: [PATCH 13/37] Input: xpad - fix inverted Y and RY axes
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, akpm@linux-foundation.org
From: Anssi Hannula <dmitry.torokhov@gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit ae91d10aab2762f81733e9194cb56eff99c8d808 inverted Y and RY
axes on xbox360 so that up is positive and down is negative.
This is wrong, as axes on game controllers have up as negative per
convention. Also, even xpad itself reports HAT0X with up as negative.

Fix that by inverting them again.

Also, according to http://bugzilla.kernel.org/show_bug.cgi?id=10337 the
original xbox controllers also have the Y and RY axes inverted.
Fix that by inverting them as well.

Cc: Brian Magnuson <bdmagnuson@gmail.com>
Signed-off-by: Anssi Hannula <anssi.hannula@gmail.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/joystick/xpad.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 6288c4f..316d987 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -236,13 +236,13 @@ static void xpad_process_packet(struct usb_xpad *xpad, u16 cmd, unsigned char *d
 	input_report_abs(dev, ABS_X,
 			 (__s16) le16_to_cpup((__le16 *)(data + 12)));
 	input_report_abs(dev, ABS_Y,
-			 (__s16) le16_to_cpup((__le16 *)(data + 14)));
+			 ~(__s16) le16_to_cpup((__le16 *)(data + 14)));
 
 	/* right stick */
 	input_report_abs(dev, ABS_RX,
 			 (__s16) le16_to_cpup((__le16 *)(data + 16)));
 	input_report_abs(dev, ABS_RY,
-			 (__s16) le16_to_cpup((__le16 *)(data + 18)));
+			 ~(__s16) le16_to_cpup((__le16 *)(data + 18)));
 
 	/* triggers left/right */
 	input_report_abs(dev, ABS_Z, data[10]);
@@ -330,13 +330,13 @@ static void xpad360_process_packet(struct usb_xpad *xpad,
 	input_report_abs(dev, ABS_X,
 			 (__s16) le16_to_cpup((__le16 *)(data + 6)));
 	input_report_abs(dev, ABS_Y,
-			 (__s16) le16_to_cpup((__le16 *)(data + 8)));
+			 ~(__s16) le16_to_cpup((__le16 *)(data + 8)));
 
 	/* right stick */
 	input_report_abs(dev, ABS_RX,
 			 (__s16) le16_to_cpup((__le16 *)(data + 10)));
 	input_report_abs(dev, ABS_RY,
-			 (__s16) le16_to_cpup((__le16 *)(data + 12)));
+			 ~(__s16) le16_to_cpup((__le16 *)(data + 12)));
 
 	/* triggers left/right */
 	input_report_abs(dev, ABS_Z, data[4]);
-- 
1.5.5.rc2.6.gf58d



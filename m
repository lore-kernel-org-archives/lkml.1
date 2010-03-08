Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab0CHVO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 16:14:28 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:34719 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755941Ab0CHVOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 16:14:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=inLb0DS/HDjRf6/Cz3aQbWMXASwxamzN5Ktu+qdB347k9Sk2kWAT1GMqLqnTx2wVBL
         z3+c5HuSZnSip8UbEFcCWxdOfuZTn46o/A1+Gs5xSt53+k7E9TvaLncwHBmxXnVd5+1M
         mg4PJDa8k6bELbsFYLSMPb3kDOBgc0KjGzYj8=
From: mickib1@gmail.com
To: jkosina@suse.cz, rafi@seas.upenn.edu, chatty@enac.fr, peterhuewe@gmx.de,
       micki@n-trig.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] HID: N-trig MTM Driver fix And cleanup patch 6
Date: Mon,  8 Mar 2010 23:13:46 +0200
Message-Id: <1268082827-2680-6-git-send-email-micki@n-trig.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1268082827-2680-5-git-send-email-micki@n-trig.com>
References: <1268082827-2680-1-git-send-email-micki@n-trig.com>
 <1268082827-2680-2-git-send-email-micki@n-trig.com>
 <1268082827-2680-3-git-send-email-micki@n-trig.com>
 <1268082827-2680-4-git-send-email-micki@n-trig.com>
 <1268082827-2680-5-git-send-email-micki@n-trig.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: micki <micki@micki-laptop.(none)>

Update struct hid_driver ntrig_driver. add debug module parameters

N-trig is changing the way people interact with computers by providing a dual-mode pen and true multi-touch input device, specifically designed for today's advanced computing world.
N-trig DuoSense® solution provides a real Hands-on computing® experience, and sets the stage for OEMs and ISVs to introduce innovative computer products and applications for an intuitive, Hands-on® experience directly onscreen.
DuoSense digitizers are easily integrated into existing technologies, support all LCDs, keep devices slim and light, and can be implemented in a broad range of products, ranging from small notebooks to large LCDs.
N-trig has offices in Israel, the US, Taiwan and Japan.

Signed-off-by: Micki Balanga <micki@n-trig.com>
---
 drivers/hid/hid-ntrig.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
index 8bf796c..f88533e 100644
--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -21,6 +21,9 @@
  *		send set feature command to firmware
  *	1.5 - N-trig udpate ntrig_probe
  *		add call to ntrig_send_report function
+ *	1.6 - N-trig Update ntrig_init print version number
+ *		update struct hid_driver
+ *		update struct hid_device_id
  */
 
 /*
@@ -458,15 +461,11 @@ static void ntrig_remove(struct hid_device *hdev)
 
 static const struct hid_device_id ntrig_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN),
-		.driver_data = NTRIG_DUPLICATE_USAGES },
+		.driver_data = NTRIG_USB_DEVICE_ID },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, ntrig_devices);
 
-static const struct hid_usage_id ntrig_grabbed_usages[] = {
-	{ HID_ANY_ID, HID_ANY_ID, HID_ANY_ID },
-	{ HID_ANY_ID - 1, HID_ANY_ID - 1, HID_ANY_ID - 1 }
-};
 
 static struct hid_driver ntrig_driver = {
 	.name = MODULE_NAME,
@@ -475,12 +474,12 @@ static struct hid_driver ntrig_driver = {
 	.remove = ntrig_remove,
 	.input_mapping = ntrig_input_mapping,
 	.input_mapped = ntrig_input_mapped,
-	.usage_table = ntrig_grabbed_usages,
 	.event = ntrig_event,
 };
 
 static int __init ntrig_init(void)
 {
+	info("N-trig Driver Version 1.6\n");
 	return hid_register_driver(&ntrig_driver);
 }
 
-- 
1.6.3.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883Ab0BRS6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 13:58:07 -0500
Received: from smtp.nokia.com ([192.100.105.134]:34020 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462Ab0BRS53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:57:29 -0500
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: [PATCH 07/12] usb: atm: speedtch: use new hex_to_bin() method
Date: Thu, 18 Feb 2010 20:55:46 +0200
Message-Id: <1266519351-3218-8-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1266519351-3218-7-git-send-email-andy.shevchenko@gmail.com>
References: <1266519351-3218-1-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-2-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-3-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-4-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-5-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-6-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-7-git-send-email-andy.shevchenko@gmail.com>
X-OriginalArrivalTime: 18 Feb 2010 18:57:15.0379 (UTC) FILETIME=[2FB68C30:01CAB0CC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Instead of using own implementation which potentialy has bugs involve
hex_to_bin() function. It requires to have hex_to_bin() implementation
introduced by one of previous path in series.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
---
 drivers/usb/atm/speedtch.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/atm/speedtch.c b/drivers/usb/atm/speedtch.c
index 3e86240..dd1c562 100644
--- a/drivers/usb/atm/speedtch.c
+++ b/drivers/usb/atm/speedtch.c
@@ -128,8 +128,6 @@ MODULE_PARM_DESC(ModemOption, "default: 0x10,0x00,0x00,0x00,0x20");
 #define ENDPOINT_ISOC_DATA	0x07
 #define ENDPOINT_FIRMWARE	0x05
 
-#define hex2int(c) ( (c >= '0') && (c <= '9') ? (c - '0') : ((c & 0xf) + 9) )
-
 struct speedtch_params {
 	unsigned int altsetting;
 	unsigned int BMaxDSL;
@@ -670,7 +668,8 @@ static int speedtch_atm_start(struct usbatm_data *usbatm, struct atm_dev *atm_de
 	memset(atm_dev->esi, 0, sizeof(atm_dev->esi));
 	if (usb_string(usb_dev, usb_dev->descriptor.iSerialNumber, mac_str, sizeof(mac_str)) == 12) {
 		for (i = 0; i < 6; i++)
-			atm_dev->esi[i] = (hex2int(mac_str[i * 2]) * 16) + (hex2int(mac_str[i * 2 + 1]));
+			atm_dev->esi[i] = (hex_to_bin(mac_str[i*2]) << 4) +
+				hex_to_bin(mac_str[i*2+1]);
 	}
 
 	/* Start modem synchronisation */
-- 
1.5.6.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab0BVSLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:11:09 -0500
Received: from smtp.nokia.com ([192.100.105.134]:27393 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127Ab0BVSLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:11:04 -0500
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       Duncan Sands <duncan.sands@free.fr>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 04/11] usb: atm: speedtch: use new hex_to_bin() method
Date: Mon, 22 Feb 2010 20:09:03 +0200
Message-Id: <939cb3c63fbf6639b5d301ddc79c64d5642a6b81.1266861291.git.ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <c515333a5ade859310436de33402a057080ec429.1266861291.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <d8c224af14aa936dcd692c70656559fe9726d997.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <5627f8a3ddb2d746e58409d1d59338a99b77291a.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <c515333a5ade859310436de33402a057080ec429.1266861291.git.ext-andriy.shevchenko@nokia.com>
In-Reply-To: <cover.1266861291.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1266861291.git.ext-andriy.shevchenko@nokia.com>
X-OriginalArrivalTime: 22 Feb 2010 18:10:35.0595 (UTC) FILETIME=[549069B0:01CAB3EA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Instead of using own implementation which potentialy has bugs involve
hex_to_bin() function. It requires to have hex_to_bin() implementation
introduced by starter patch in series.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Duncan Sands <duncan.sands@free.fr>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/atm/speedtch.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/atm/speedtch.c b/drivers/usb/atm/speedtch.c
index 3e86240..f3a454d 100644
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
+			atm_dev->esi[i] = (hex_to_bin(mac_str[i * 2]) << 4) +
+				hex_to_bin(mac_str[i * 2 + 1]);
 	}
 
 	/* Start modem synchronisation */
-- 
1.5.6.5


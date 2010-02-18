Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab0BRS50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 13:57:26 -0500
Received: from smtp.nokia.com ([192.100.122.233]:51744 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312Ab0BRS5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:57:21 -0500
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: [PATCH 12/12] drivers: wireless: use kernel's method to get byte in hex form
Date: Thu, 18 Feb 2010 20:55:51 +0200
Message-Id: <1266519351-3218-13-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1266519351-3218-12-git-send-email-andy.shevchenko@gmail.com>
References: <1266519351-3218-1-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-2-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-3-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-4-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-5-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-6-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-7-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-8-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-9-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-10-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-11-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-12-git-send-email-andy.shevchenko@gmail.com>
X-OriginalArrivalTime: 18 Feb 2010 18:57:15.0660 (UTC) FILETIME=[2FE16CC0:01CAB0CC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
---
 drivers/net/wireless/at76c50x-usb.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index 2517364..d700d13 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -502,7 +502,6 @@ exit:
 
 #define HEX2STR_BUFFERS 4
 #define HEX2STR_MAX_LEN 64
-#define BIN2HEX(x) ((x) < 10 ? '0' + (x) : (x) + 'A' - 10)
 
 /* Convert binary data into hex string */
 static char *hex2str(void *buf, int len)
@@ -522,10 +521,8 @@ static char *hex2str(void *buf, int len)
 	}
 
 	while (len--) {
-		*obuf++ = BIN2HEX(*ibuf >> 4);
-		*obuf++ = BIN2HEX(*ibuf & 0xf);
+		obuf = pack_hex_byte(obuf, *ibuf++);
 		*obuf++ = '-';
-		ibuf++;
 	}
 	*(--obuf) = '\0';
 
-- 
1.5.6.5


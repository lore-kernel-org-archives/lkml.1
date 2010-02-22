Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab0BVSKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:10:49 -0500
Received: from smtp.nokia.com ([192.100.105.134]:27371 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab0BVSKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:10:41 -0500
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       Tilman Schmidt <tilman@imap.cc>
Subject: [PATCH 02/11] drivers: isdn: use new hex_to_bin() method
Date: Mon, 22 Feb 2010 20:09:01 +0200
Message-Id: <5627f8a3ddb2d746e58409d1d59338a99b77291a.1266861291.git.ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <d8c224af14aa936dcd692c70656559fe9726d997.1266861291.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <d8c224af14aa936dcd692c70656559fe9726d997.1266861291.git.ext-andriy.shevchenko@nokia.com>
In-Reply-To: <cover.1266861291.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1266861291.git.ext-andriy.shevchenko@nokia.com>
X-OriginalArrivalTime: 22 Feb 2010 18:10:30.0182 (UTC) FILETIME=[51567460:01CAB3EA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Get rid of own implementation of hex_to_bin().

Please note it requires to have hex_to_bin() introduced by one of previous
patch [1] which is not applied yet.

[1] http://patchwork.kernel.org/patch/80404/

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Tilman Schmidt <tilman@imap.cc>
---
 drivers/isdn/gigaset/capi.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/isdn/gigaset/capi.c b/drivers/isdn/gigaset/capi.c
index 3f5cd06..532ca33 100644
--- a/drivers/isdn/gigaset/capi.c
+++ b/drivers/isdn/gigaset/capi.c
@@ -183,17 +183,6 @@ static inline int ishexdigit(char c)
 }
 
 /*
- * convert hex to binary
- */
-static inline u8 hex2bin(char c)
-{
-	int result = c & 0x0f;
-	if (c & 0x40)
-		result += 9;
-	return result;
-}
-
-/*
  * convert an IE from Gigaset hex string to ETSI binary representation
  * including length byte
  * return value: result length, -1 on error
@@ -204,7 +193,7 @@ static int encode_ie(char *in, u8 *out, int maxlen)
 	while (*in) {
 		if (!ishexdigit(in[0]) || !ishexdigit(in[1]) || l >= maxlen)
 			return -1;
-		out[++l] = (hex2bin(in[0]) << 4) + hex2bin(in[1]);
+		out[++l] = (hex_to_bin(in[0]) << 4) + hex_to_bin(in[1]);
 		in += 2;
 	}
 	out[0] = l;
-- 
1.5.6.5


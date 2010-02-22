Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab0BVSNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:13:11 -0500
Received: from smtp.nokia.com ([192.100.105.134]:27366 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab0BVSKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:10:39 -0500
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 05/11] drivers: net: use new hex_to_bin() method
Date: Mon, 22 Feb 2010 20:09:04 +0200
Message-Id: <d8efe17f827514a0c470191dccaf00afd09c2854.1266861291.git.ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <939cb3c63fbf6639b5d301ddc79c64d5642a6b81.1266861291.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <d8c224af14aa936dcd692c70656559fe9726d997.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <5627f8a3ddb2d746e58409d1d59338a99b77291a.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <c515333a5ade859310436de33402a057080ec429.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <939cb3c63fbf6639b5d301ddc79c64d5642a6b81.1266861291.git.ext-andriy.shevchenko@nokia.com>
In-Reply-To: <cover.1266861291.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1266861291.git.ext-andriy.shevchenko@nokia.com>
X-OriginalArrivalTime: 22 Feb 2010 18:10:30.0120 (UTC) FILETIME=[514CFE80:01CAB3EA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Instead of using own implementation involve hex_to_bin() function. It requires
to have hex_to_bin() introduced by starter patch in series.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/sb1250-mac.c |   32 ++------------------------------
 1 files changed, 2 insertions(+), 30 deletions(-)

diff --git a/drivers/net/sb1250-mac.c b/drivers/net/sb1250-mac.c
index 564d4d7..87c57cb 100644
--- a/drivers/net/sb1250-mac.c
+++ b/drivers/net/sb1250-mac.c
@@ -2184,34 +2184,6 @@ static void sbmac_setmulti(struct sbmac_softc *sc)
 
 #if defined(SBMAC_ETH0_HWADDR) || defined(SBMAC_ETH1_HWADDR) || defined(SBMAC_ETH2_HWADDR) || defined(SBMAC_ETH3_HWADDR)
 /**********************************************************************
- *  SBMAC_PARSE_XDIGIT(str)
- *
- *  Parse a hex digit, returning its value
- *
- *  Input parameters:
- *  	   str - character
- *
- *  Return value:
- *  	   hex value, or -1 if invalid
- ********************************************************************* */
-
-static int sbmac_parse_xdigit(char str)
-{
-	int digit;
-
-	if ((str >= '0') && (str <= '9'))
-		digit = str - '0';
-	else if ((str >= 'a') && (str <= 'f'))
-		digit = str - 'a' + 10;
-	else if ((str >= 'A') && (str <= 'F'))
-		digit = str - 'A' + 10;
-	else
-		return -1;
-
-	return digit;
-}
-
-/**********************************************************************
  *  SBMAC_PARSE_HWADDR(str,hwaddr)
  *
  *  Convert a string in the form xx:xx:xx:xx:xx:xx into a 6-byte
@@ -2231,7 +2203,7 @@ static int sbmac_parse_hwaddr(char *str, unsigned char *hwaddr)
 	int idx = 6;
 
 	while (*str && (idx > 0)) {
-		digit1 = sbmac_parse_xdigit(*str);
+		digit1 = hex_to_bin(*str);
 		if (digit1 < 0)
 			return -1;
 		str++;
@@ -2243,7 +2215,7 @@ static int sbmac_parse_hwaddr(char *str, unsigned char *hwaddr)
 			digit1 = 0;
 		}
 		else {
-			digit2 = sbmac_parse_xdigit(*str);
+			digit2 = hex_to_bin(*str);
 			if (digit2 < 0)
 				return -1;
 			str++;
-- 
1.5.6.5


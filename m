Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976Ab0BRS7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 13:59:24 -0500
Received: from smtp.nokia.com ([192.100.122.233]:51743 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab0BRS5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:57:21 -0500
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: [PATCH 08/12] net: use new hex_to_bin() method
Date: Thu, 18 Feb 2010 20:55:47 +0200
Message-Id: <1266519351-3218-9-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1266519351-3218-8-git-send-email-andy.shevchenko@gmail.com>
References: <1266519351-3218-1-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-2-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-3-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-4-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-5-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-6-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-7-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-8-git-send-email-andy.shevchenko@gmail.com>
X-OriginalArrivalTime: 18 Feb 2010 18:57:14.0905 (UTC) FILETIME=[2F6E3890:01CAB0CC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Instead of using own implementation involve hex_to_bin() function. It requires
to have hex_to_bin() introduced by one of previous path in series.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811Ab0BRS5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 13:57:33 -0500
Received: from smtp.nokia.com ([192.100.122.233]:51763 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235Ab0BRS5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:57:25 -0500
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: [PATCH 11/12] drivers: isdn: use new hex_to_bin() method
Date: Thu, 18 Feb 2010 20:55:50 +0200
Message-Id: <1266519351-3218-12-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1266519351-3218-11-git-send-email-andy.shevchenko@gmail.com>
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
X-OriginalArrivalTime: 18 Feb 2010 18:57:15.0077 (UTC) FILETIME=[2F887750:01CAB0CC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Get rid of own implementation of hex_to_bin(). It requires to have hex_to_bin()
introduced by one of previous path in series.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
---
 drivers/isdn/gigaset/capi.c |   14 ++------------
 1 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/isdn/gigaset/capi.c b/drivers/isdn/gigaset/capi.c
index 83c4e2f..72adcfb 100644
--- a/drivers/isdn/gigaset/capi.c
+++ b/drivers/isdn/gigaset/capi.c
@@ -13,6 +13,7 @@
 
 #include "gigaset.h"
 #include <linux/ctype.h>
+#include <linux/kernel.h>
 #include <linux/isdn/capilli.h>
 #include <linux/isdn/capicmd.h>
 #include <linux/isdn/capiutil.h>
@@ -169,17 +170,6 @@ static inline void ignore_cstruct_param(struct cardstate *cs, _cstruct param,
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
@@ -190,7 +180,7 @@ static int encode_ie(char *in, u8 *out, int maxlen)
 	while (*in) {
 		if (!isxdigit(in[0]) || !isxdigit(in[1]) || l >= maxlen)
 			return -1;
-		out[++l] = (hex2bin(in[0]) << 4) + hex2bin(in[1]);
+		out[++l] = (hex_to_bin(in[0]) << 4) + hex_to_bin(in[1]);
 		in += 2;
 	}
 	out[0] = l;
-- 
1.5.6.5


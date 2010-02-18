Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071Ab0BRTA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 14:00:56 -0500
Received: from smtp.nokia.com ([192.100.105.134]:34000 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242Ab0BRS5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:57:18 -0500
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: [PATCH 01/12] isdn: remove ishexdigit() in regard to isxdigit()
Date: Thu, 18 Feb 2010 20:55:40 +0200
Message-Id: <1266519351-3218-2-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1266519351-3218-1-git-send-email-andy.shevchenko@gmail.com>
References: <1266519351-3218-1-git-send-email-andy.shevchenko@gmail.com>
X-OriginalArrivalTime: 18 Feb 2010 18:57:15.0379 (UTC) FILETIME=[2FB68C30:01CAB0CC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Samll cleanup in drivers/isdn/gigaset/capi.c where own implementation of
isxdigit() has been changed to kernel native one.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
---
 drivers/isdn/gigaset/capi.c |   16 +---------------
 1 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/drivers/isdn/gigaset/capi.c b/drivers/isdn/gigaset/capi.c
index 3f5cd06..83c4e2f 100644
--- a/drivers/isdn/gigaset/capi.c
+++ b/drivers/isdn/gigaset/capi.c
@@ -169,20 +169,6 @@ static inline void ignore_cstruct_param(struct cardstate *cs, _cstruct param,
 }
 
 /*
- * check for legal hex digit
- */
-static inline int ishexdigit(char c)
-{
-	if (c >= '0' && c <= '9')
-		return 1;
-	if (c >= 'A' && c <= 'F')
-		return 1;
-	if (c >= 'a' && c <= 'f')
-		return 1;
-	return 0;
-}
-
-/*
  * convert hex to binary
  */
 static inline u8 hex2bin(char c)
@@ -202,7 +188,7 @@ static int encode_ie(char *in, u8 *out, int maxlen)
 {
 	int l = 0;
 	while (*in) {
-		if (!ishexdigit(in[0]) || !ishexdigit(in[1]) || l >= maxlen)
+		if (!isxdigit(in[0]) || !isxdigit(in[1]) || l >= maxlen)
 			return -1;
 		out[++l] = (hex2bin(in[0]) << 4) + hex2bin(in[1]);
 		in += 2;
-- 
1.5.6.5


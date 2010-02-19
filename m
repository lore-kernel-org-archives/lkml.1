Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab0BSJyz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 04:54:55 -0500
Received: from smtp.nokia.com ([192.100.122.230]:36322 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab0BSJyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 04:54:53 -0500
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       Tilman Schmidt <tilman@imap.cc>
Subject: [PATCHv2] drivers: isdn: use new hex_to_bin() method
Date: Fri, 19 Feb 2010 11:53:17 +0200
Message-Id: <1266573197-5687-1-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <4B7DD363.4050402@imap.cc>
References: <4B7DD363.4050402@imap.cc>
X-OriginalArrivalTime: 19 Feb 2010 09:54:44.0911 (UTC) FILETIME=[90890BF0:01CAB149]
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
index 83c4e2f..82ee085 100644
--- a/drivers/isdn/gigaset/capi.c
+++ b/drivers/isdn/gigaset/capi.c
@@ -169,17 +169,6 @@ static inline void ignore_cstruct_param(struct cardstate *cs, _cstruct param,
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
@@ -190,7 +179,7 @@ static int encode_ie(char *in, u8 *out, int maxlen)
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


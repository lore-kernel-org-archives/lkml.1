Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab0BRS5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 13:57:48 -0500
Received: from smtp.nokia.com ([192.100.105.134]:34022 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757584Ab0BRS5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:57:30 -0500
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: [PATCH 09/12] drivers: net: use kernel's method to get byte in hex form
Date: Thu, 18 Feb 2010 20:55:48 +0200
Message-Id: <1266519351-3218-10-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1266519351-3218-9-git-send-email-andy.shevchenko@gmail.com>
References: <1266519351-3218-1-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-2-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-3-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-4-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-5-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-6-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-7-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-8-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-9-git-send-email-andy.shevchenko@gmail.com>
X-OriginalArrivalTime: 18 Feb 2010 18:57:15.0233 (UTC) FILETIME=[2FA04510:01CAB0CC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
---
 drivers/net/ppp_synctty.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ppp_synctty.c b/drivers/net/ppp_synctty.c
index 3a13cec..e4b3cf6 100644
--- a/drivers/net/ppp_synctty.c
+++ b/drivers/net/ppp_synctty.c
@@ -108,12 +108,10 @@ static void
 ppp_print_hex (register __u8 * out, const __u8 * in, int count)
 {
 	register __u8 next_ch;
-	static const char hex[] = "0123456789ABCDEF";
 
 	while (count-- > 0) {
 		next_ch = *in++;
-		*out++ = hex[(next_ch >> 4) & 0x0F];
-		*out++ = hex[next_ch & 0x0F];
+		out = pack_hex_byte(out, next_ch);
 		++out;
 	}
 }
-- 
1.5.6.5


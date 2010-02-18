Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880Ab0BRS6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 13:58:33 -0500
Received: from smtp.nokia.com ([192.100.122.233]:51754 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685Ab0BRS5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:57:23 -0500
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: [PATCH 02/12] audit: use kernel's method to get byte in hex form
Date: Thu, 18 Feb 2010 20:55:41 +0200
Message-Id: <1266519351-3218-3-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1266519351-3218-2-git-send-email-andy.shevchenko@gmail.com>
References: <1266519351-3218-1-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-2-git-send-email-andy.shevchenko@gmail.com>
X-OriginalArrivalTime: 18 Feb 2010 18:57:19.0561 (UTC) FILETIME=[3234AB90:01CAB0CC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
---
 kernel/audit.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 5feed23..160abad 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -58,6 +58,7 @@
 #include <linux/inotify.h>
 #include <linux/freezer.h>
 #include <linux/tty.h>
+#include <linux/kernel.h>
 
 #include "audit.h"
 
@@ -1308,7 +1309,6 @@ void audit_log_n_hex(struct audit_buffer *ab, const unsigned char *buf,
 	int i, avail, new_len;
 	unsigned char *ptr;
 	struct sk_buff *skb;
-	static const unsigned char *hex = "0123456789ABCDEF";
 
 	if (!ab)
 		return;
@@ -1326,10 +1326,8 @@ void audit_log_n_hex(struct audit_buffer *ab, const unsigned char *buf,
 	}
 
 	ptr = skb_tail_pointer(skb);
-	for (i=0; i<len; i++) {
-		*ptr++ = hex[(buf[i] & 0xF0)>>4]; /* Upper nibble */
-		*ptr++ = hex[buf[i] & 0x0F];	  /* Lower nibble */
-	}
+	for (i=0; i<len; i++)
+		ptr = pack_hex_byte(ptr, buf[i]);
 	*ptr = 0;
 	skb_put(skb, len << 1); /* new string is twice the old string */
 }
-- 
1.5.6.5


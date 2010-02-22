Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab0BVSMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:12:06 -0500
Received: from smtp.nokia.com ([192.100.105.134]:27416 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576Ab0BVSL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:11:56 -0500
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 01/11] lib: introduce common method to convert hex digits
Date: Mon, 22 Feb 2010 20:09:00 +0200
Message-Id: <d8c224af14aa936dcd692c70656559fe9726d997.1266861291.git.ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <cover.1266861291.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1266861291.git.ext-andriy.shevchenko@nokia.com>
In-Reply-To: <cover.1266861291.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1266861291.git.ext-andriy.shevchenko@nokia.com>
X-OriginalArrivalTime: 22 Feb 2010 18:10:35.0220 (UTC) FILETIME=[54573140:01CAB3EA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

hex_to_bin() is a little method which converts hex digit to its actual value.
There are plenty of places where such functionality is needed.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 include/linux/kernel.h |    2 ++
 lib/hexdump.c          |   19 +++++++++++++++++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 328bca6..bbbf885 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -361,6 +361,8 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
 	return buf;
 }
 
+extern int hex_to_bin(char ch);
+
 #ifndef pr_fmt
 #define pr_fmt(fmt) fmt
 #endif
diff --git a/lib/hexdump.c b/lib/hexdump.c
index 39af256..d79b166 100644
--- a/lib/hexdump.c
+++ b/lib/hexdump.c
@@ -16,6 +16,25 @@ const char hex_asc[] = "0123456789abcdef";
 EXPORT_SYMBOL(hex_asc);
 
 /**
+ * hex_to_bin - convert a hex digit to its real value
+ * @ch: ascii character represents hex digit
+ *
+ * hex_to_bin() converts one hex digit to its actual value or -1 in case of bad
+ * input.
+ */
+int hex_to_bin(char ch)
+{
+	if ((ch >= 'a') && (ch <= 'f'))
+		return ch - 'a' + 10;
+	if ((ch >= '0') && (ch <= '9'))
+		return ch - '0';
+	if ((ch >= 'A') && (ch <= 'F'))
+		return ch - 'A' + 10;
+	return -1;
+}
+EXPORT_SYMBOL(hex_to_bin);
+
+/**
  * hex_dump_to_buffer - convert a blob of data to "hex ASCII" in memory
  * @buf: data blob to dump
  * @len: number of bytes in the @buf
-- 
1.5.6.5


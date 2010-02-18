Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106Ab0BRS67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 13:58:59 -0500
Received: from smtp.nokia.com ([192.100.105.134]:34007 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334Ab0BRS5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:57:21 -0500
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: [PATCH 05/12] lib: introduce common method to convert hex digits
Date: Thu, 18 Feb 2010 20:55:44 +0200
Message-Id: <1266519351-3218-6-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1266519351-3218-5-git-send-email-andy.shevchenko@gmail.com>
References: <1266519351-3218-1-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-2-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-3-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-4-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-5-git-send-email-andy.shevchenko@gmail.com>
X-OriginalArrivalTime: 18 Feb 2010 18:57:15.0223 (UTC) FILETIME=[2F9EBE70:01CAB0CC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

hex_to_bin() is a little method which converts hex digit to its actual value.
There are plenty of places where such functionality is needed.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
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


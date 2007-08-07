Return-Path: <linux-kernel-owner+w=401wt.eu-S934681AbXHGS4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934681AbXHGS4u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 14:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755469AbXHGS4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 14:56:42 -0400
Received: from smtp.nokia.com ([131.228.20.171]:44412 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055AbXHGS4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 14:56:41 -0400
Message-ID: <46B8C056.2090608@yandex.ru>
Date: Tue, 07 Aug 2007 21:56:22 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: dedekind@infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH + forgotten signed-off] hexdump: use const notation
References: <1186511620.19606.20.camel@sauron>
In-Reply-To: <1186511620.19606.20.camel@sauron>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 07 Aug 2007 18:56:22.0647 (UTC) FILETIME=[A5C3C870:01C7D924]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date: Tue, 7 Aug 2007 23:43:14 +0300
Subject: [PATCH] hexdump: use const notation

Trivial fix: mark the buffer to hexdump as const so callers could avoid
casting their const buffers when calling print_hex_dump().

The patch is really trivial and I suggest to consider it as a fix
(it fixes GCC warnings) and push it to current tree.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 include/linux/kernel.h |    2 +-
 lib/hexdump.c          |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 4300bb4..b4f5b81 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -224,7 +224,7 @@ extern void hex_dump_to_buffer(const void *buf, size_t len,
 				char *linebuf, size_t linebuflen, bool ascii);
 extern void print_hex_dump(const char *level, const char *prefix_str,
 				int prefix_type, int rowsize, int groupsize,
-				void *buf, size_t len, bool ascii);
+				const void *buf, size_t len, bool ascii);
 extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
 			void *buf, size_t len);
 #define hex_asc(x)	"0123456789abcdef"[x]
diff --git a/lib/hexdump.c b/lib/hexdump.c
index 473f5ae..16f2e29 100644
--- a/lib/hexdump.c
+++ b/lib/hexdump.c
@@ -145,9 +145,9 @@ EXPORT_SYMBOL(hex_dump_to_buffer);
  */
 void print_hex_dump(const char *level, const char *prefix_str, int prefix_type,
 			int rowsize, int groupsize,
-			void *buf, size_t len, bool ascii)
+			const void *buf, size_t len, bool ascii)
 {
-	u8 *ptr = buf;
+	const u8 *ptr = buf;
 	int i, linelen, remaining = len;
 	unsigned char linebuf[200];
 
-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

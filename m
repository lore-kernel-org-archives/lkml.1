Return-Path: <linux-kernel-owner+w=401wt.eu-S1759134AbXHGSd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759134AbXHGSd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 14:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbXHGSdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 14:33:49 -0400
Received: from smtp.nokia.com ([131.228.20.170]:30201 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbXHGSds convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 14:33:48 -0400
Subject: [PATCH] hexdump: use const notation
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Tue, 07 Aug 2007 21:33:40 +0300
Message-Id: <1186511620.19606.20.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 07 Aug 2007 18:33:40.0181 (UTC) FILETIME=[79ABF850:01C7D921]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial fix: mark the buffer to hexdump as const so callers could avoid
casting their const buffers when calling print_hex_dump().

The patch is really trivial and I suggest to consider it as a fix
(it fixes GCC warnings) and push it to current tree.


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
Best regards,
Artem Bityutskiy (Битюцкий Артём)


Return-Path: <linux-kernel-owner+w=401wt.eu-S1751553AbYJLJcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553AbYJLJcR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 05:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbYJLJbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 05:31:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51734 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbYJLJbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 05:31:45 -0400
Message-ID: <48F1C37B.5090508@cn.fujitsu.com>
Date: Sun, 12 Oct 2008 17:29:31 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alexey Dobriyan <adobriyan@gmail.com>, Paul Menage <menage@google.com>,
       Paul Jackson <pj@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] bitmask: remove bitmap_scnprintf_len()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


bitmap_scnprintf_len() is not used now, so we remove it.

Otherwise we have to maintain it and make its return
value always equal to bitmap_scnprintf()'s return value.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 89781fd..1abfe66 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -110,7 +110,6 @@ extern int __bitmap_weight(const unsigned long *bitmap, int bits);
 
 extern int bitmap_scnprintf(char *buf, unsigned int len,
 			const unsigned long *src, int nbits);
-extern int bitmap_scnprintf_len(unsigned int nr_bits);
 extern int __bitmap_parse(const char *buf, unsigned int buflen, int is_user,
 			unsigned long *dst, int nbits);
 extern int bitmap_parse_user(const char __user *ubuf, unsigned int ulen,
diff --git a/lib/bitmap.c b/lib/bitmap.c
index 06fb57c..482df94 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -316,17 +316,6 @@ int bitmap_scnprintf(char *buf, unsigned int buflen,
 EXPORT_SYMBOL(bitmap_scnprintf);
 
 /**
- * bitmap_scnprintf_len - return buffer length needed to convert
- * bitmap to an ASCII hex string
- * @nr_bits: number of bits to be converted
- */
-int bitmap_scnprintf_len(unsigned int nr_bits)
-{
-	unsigned int nr_nibbles = ALIGN(nr_bits, 4) / 4;
-	return nr_nibbles + ALIGN(nr_nibbles, CHUNKSZ / 4) / (CHUNKSZ / 4) - 1;
-}
-
-/**
  * __bitmap_parse - convert an ASCII hex string into a bitmap.
  * @buf: pointer to buffer containing string.
  * @buflen: buffer size in bytes.  If string is smaller than this



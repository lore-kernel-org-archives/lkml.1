Return-Path: <linux-kernel-owner+w=401wt.eu-S934300AbYEGXGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934300AbYEGXGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 19:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757371AbYEGXFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 19:05:42 -0400
Received: from relay2.sgi.com ([192.48.171.30]:46440 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765699AbYEGXFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 19:05:36 -0400
From: Paul Jackson <pj@sgi.com>
To: akpm@linux-foundation.org
Cc: "WANG Cong" <xiyou.wangcong@gmail.com>, "Mike Travis" <travis@sgi.com>,
       "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Bert Wesarg" <bert.wesarg@googlemail.com>,
       linux-kernel@vger.kernel.org, Paul Jackson <pj@sgi.com>
Date: Wed, 07 May 2008 16:05:34 -0700
Message-Id: <20080507230534.2458.93668.sendpatchset@jackhammer.engr.sgi.com>
Subject: [PATCH] cpusets: remove bitmap_scnprintf_len and cpumask_scnprintf_len
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

Remove bitmap_scnprintf_len and cpumask_scnprintf_len.

They aren't used.  They were briefly used as part of some
other patches to provide an alternative format for displaying
some /proc and /sys cpumasks.  They probably should have been
removed when those other patches were dropped, in favor of a
different solution.

Signed-off-by: Paul Jackson <pj@sgi.com>
Cc: "Mike Travis" <travis@sgi.com>
Cc: "Bert Wesarg" <bert.wesarg@googlemail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>

---
 include/linux/bitmap.h  |    1 -
 include/linux/cpumask.h |    7 -------
 lib/bitmap.c            |   16 ----------------
 3 files changed, 24 deletions(-)

--- 2.6.26-rc1-mmotm.orig/include/linux/bitmap.h	2008-05-06 20:54:24.000000000 -0700
+++ 2.6.26-rc1-mmotm/include/linux/bitmap.h	2008-05-07 15:26:06.740970436 -0700
@@ -110,7 +110,6 @@ extern int __bitmap_weight(const unsigne
 
 extern int bitmap_scnprintf(char *buf, unsigned int len,
 			const unsigned long *src, int nbits);
-extern int bitmap_scnprintf_len(unsigned int len);
 extern int __bitmap_parse(const char *buf, unsigned int buflen, int is_user,
 			unsigned long *dst, int nbits);
 extern int bitmap_parse_user(const char __user *ubuf, unsigned int ulen,
--- 2.6.26-rc1-mmotm.orig/include/linux/cpumask.h	2008-05-06 21:01:11.000000000 -0700
+++ 2.6.26-rc1-mmotm/include/linux/cpumask.h	2008-05-07 15:26:38.049493817 -0700
@@ -297,13 +297,6 @@ static inline int __cpumask_scnprintf(ch
 	return bitmap_scnprintf(buf, len, srcp->bits, nbits);
 }
 
-#define cpumask_scnprintf_len(len) \
-			__cpumask_scnprintf_len((len))
-static inline int __cpumask_scnprintf_len(int len)
-{
-	return bitmap_scnprintf_len(len);
-}
-
 #define cpumask_parse_user(ubuf, ulen, dst) \
 			__cpumask_parse_user((ubuf), (ulen), &(dst), NR_CPUS)
 static inline int __cpumask_parse_user(const char __user *buf, int len,
--- 2.6.26-rc1-mmotm.orig/lib/bitmap.c	2008-05-06 20:54:27.000000000 -0700
+++ 2.6.26-rc1-mmotm/lib/bitmap.c	2008-05-07 15:27:01.161880188 -0700
@@ -316,22 +316,6 @@ int bitmap_scnprintf(char *buf, unsigned
 EXPORT_SYMBOL(bitmap_scnprintf);
 
 /**
- * bitmap_scnprintf_len - return buffer length needed to convert
- * bitmap to an ASCII hex string.
- * @len: number of bits to be converted
- */
-int bitmap_scnprintf_len(unsigned int len)
-{
-	/* we need 9 chars per word for 32 bit words (8 hexdigits + sep/null) */
-	int bitslen = ALIGN(len, CHUNKSZ);
-	int wordlen = CHUNKSZ / 4;
-	int buflen = (bitslen / wordlen) * (wordlen + 1) * sizeof(char);
-
-	return buflen;
-}
-EXPORT_SYMBOL(bitmap_scnprintf_len);
-
-/**
  * __bitmap_parse - convert an ASCII hex string into a bitmap.
  * @buf: pointer to buffer containing string.
  * @buflen: buffer size in bytes.  If string is smaller than this

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373

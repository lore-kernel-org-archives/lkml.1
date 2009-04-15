Return-Path: <linux-kernel-owner+w=401wt.eu-S1755532AbZDOT3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbZDOT3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 15:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755674AbZDOT3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 15:29:17 -0400
Received: from exprod6og112.obsmtp.com ([64.18.1.29]:33726 "HELO
	exprod6og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755562AbZDOT3Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 15:29:16 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] lib/crc32.c: fix sparse warnings
Date: Wed, 15 Apr 2009 15:28:14 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE1909015F8D05@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] lib/crc32.c: fix sparse warnings
Thread-Index: Acm+AFJIcV/fgOhZSY2nmfqU5YrvbA==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 15 Apr 2009 19:29:14.0150 (UTC) FILETIME=[75BF0460:01C9BE00]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix four sparse warnings in lib/crc32.c.

	warning: symbol 'p' shadows an earlier one

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/lib/crc32.c b/lib/crc32.c
index 49d1c9e..14a2e5a 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -85,9 +85,9 @@ u32 __pure crc32_le(u32 crc, unsigned char const *p,
size_t len)
 	/* Align it */
 	if(unlikely(((long)b)&3 && len)){
 		do {
-			u8 *p = (u8 *)b;
-			DO_CRC(*p++);
-			b = (void *)p;
+			u8 *_p = (u8 *)b;
+			DO_CRC(*_p++);
+			b = (void *)_p;
 		} while ((--len) && ((long)b)&3 );
 	}
 	if(likely(len >= 4)){
@@ -108,9 +108,9 @@ u32 __pure crc32_le(u32 crc, unsigned char const *p,
size_t len)
 	/* And the last few bytes */
 	if(len){
 		do {
-			u8 *p = (u8 *)b;
-			DO_CRC(*p++);
-			b = (void *)p;
+			u8 *_p = (u8 *)b;
+			DO_CRC(*_p++);
+			b = (void *)_p;
 		} while (--len);
 	}
 
@@ -183,9 +183,9 @@ u32 __pure crc32_be(u32 crc, unsigned char const *p,
size_t len)
 	/* Align it */
 	if(unlikely(((long)b)&3 && len)){
 		do {
-			u8 *p = (u8 *)b;
-			DO_CRC(*p++);
-			b = (u32 *)p;
+			u8 *_p = (u8 *)b;
+			DO_CRC(*_p++);
+			b = (u32 *)_p;
 		} while ((--len) && ((long)b)&3 );
 	}
 	if(likely(len >= 4)){
@@ -206,9 +206,9 @@ u32 __pure crc32_be(u32 crc, unsigned char const *p,
size_t len)
 	/* And the last few bytes */
 	if(len){
 		do {
-			u8 *p = (u8 *)b;
-			DO_CRC(*p++);
-			b = (void *)p;
+			u8 *_p = (u8 *)b;
+			DO_CRC(*_p++);
+			b = (void *)_p;
 		} while (--len);
 	}
 	return __be32_to_cpu(crc);
@@ -346,7 +346,7 @@ EXPORT_SYMBOL(crc32_be);
  * in the correct multiple to subtract, we can shift a byte at a time.
  * This produces a 40-bit (rather than a 33-bit) intermediate
remainder,
  * but again the multiple of the polynomial to subtract depends only on
- * the high bits, the high 8 bits in this case.  
+ * the high bits, the high 8 bits in this case.
  *
  * The multiple we need in that case is the low 32 bits of a 40-bit
  * value whose high 8 bits are given, and which is a multiple of the 

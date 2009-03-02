Return-Path: <linux-kernel-owner+w=401wt.eu-S1756246AbZCBPSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbZCBPSg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 10:18:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbZCBPS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 10:18:27 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:46353 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbZCBPS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 10:18:27 -0500
Subject: [PATCH] crc32: remove useless __pure modifier from functions
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Date: Mon, 02 Mar 2009 17:18:23 +0200
Message-Id: <1236007103.18284.83.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

The pure attribute has absolutely no effect with GCC 4.2:

   text	   data	    bss	    dec	    hex	filename
   2456	      0	      0	   2456	    998	lib/crc32.o.old
   2456	      0	      0	   2456	    998	lib/crc32.o.new

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 lib/crc32.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/lib/crc32.c b/lib/crc32.c
index 49d1c9e..9ff76ad 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -49,7 +49,7 @@ MODULE_LICENSE("GPL");
  * @p: pointer to buffer over which CRC is run
  * @len: length of buffer @p
  */
-u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len);
+u32 crc32_le(u32 crc, unsigned char const *p, size_t len);
 
 #if CRC_LE_BITS == 1
 /*
@@ -57,7 +57,7 @@ u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len);
  * simplified by inlining the table in ?: form.
  */
 
-u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
+u32 crc32_le(u32 crc, unsigned char const *p, size_t len)
 {
 	int i;
 	while (len--) {
@@ -69,7 +69,7 @@ u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
 }
 #else				/* Table-based approach */
 
-u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
+u32 crc32_le(u32 crc, unsigned char const *p, size_t len)
 {
 # if CRC_LE_BITS == 8
 	const u32      *b =(u32 *)p;
@@ -145,7 +145,7 @@ u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
  * @p: pointer to buffer over which CRC is run
  * @len: length of buffer @p
  */
-u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len);
+u32 crc32_be(u32 crc, unsigned char const *p, size_t len);
 
 #if CRC_BE_BITS == 1
 /*
@@ -153,7 +153,7 @@ u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len);
  * simplified by inlining the table in ?: form.
  */
 
-u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
+u32 crc32_be(u32 crc, unsigned char const *p, size_t len)
 {
 	int i;
 	while (len--) {
@@ -167,7 +167,7 @@ u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
 }
 
 #else				/* Table-based approach */
-u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
+u32 crc32_be(u32 crc, unsigned char const *p, size_t len)
 {
 # if CRC_BE_BITS == 8
 	const u32      *b =(u32 *)p;
-- 
1.5.4.3




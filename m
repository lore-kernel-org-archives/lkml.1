Return-Path: <linux-kernel-owner+w=401wt.eu-S1758208AbXEXWyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208AbXEXWyb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750778AbXEXWyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:54:23 -0400
Received: from tim.rpsys.net ([194.106.48.114]:39578 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701AbXEXWyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:54:22 -0400
Subject: [PATCH -mm] reiser4: remove lzo compression security hole
From: Richard Purdie <rpurdie@rpsys.net>
To: akpm <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, edward@namesys.com, vs@namesys.com
Content-Type: text/plain
Date: Thu, 24 May 2007 23:54:00 +0100
Message-Id: <1180047240.12821.48.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Switch reiser4 to use lzo1x_decompress_safe instead of lzo1x_decompress
as otherwise it presents a security hole (lzo1x_decompress doesn't
perform bounds checking on the decompressed data).

Signed-off-by: Richard Purdie <rpurdie@rpsys.net>

---
 fs/reiser4/plugin/compress/compress.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.21/fs/reiser4/plugin/compress/compress.c
===================================================================
--- linux-2.6.21.orig/fs/reiser4/plugin/compress/compress.c	2007-05-16 20:47:45.000000000 +0100
+++ linux-2.6.21/fs/reiser4/plugin/compress/compress.c	2007-05-24 23:43:28.000000000 +0100
@@ -319,7 +319,7 @@ lzo1_decompress(coa_t coa, __u8 * src_fi
 	assert("edward-851", coa == NULL);
 	assert("edward-852", src_len != 0);
 
-	result = lzo1x_decompress(src_first, src_len, dst_first, &dstlen, NULL);
+	result = lzo1x_decompress_safe(src_first, src_len, dst_first, &dstlen, NULL);
 	if (result != LZO_E_OK)
 		warning("edward-853", "lzo1x_1_decompress failed\n");
 	*dst_len = dstlen;



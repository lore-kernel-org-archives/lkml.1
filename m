Return-Path: <linux-kernel-owner+w=401wt.eu-S1764670AbXGKMxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764670AbXGKMxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 08:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762973AbXGKMxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 08:53:40 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:24600 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764436AbXGKMxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 08:53:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=aZEEMK/mUkyWT1X9gqT3yvQ305Wbi2IcJeW1imvZSW0/o3oqmESRn6er+Gagc5EPwsh0MlZef7J3HAL2RdwD08Xogb0IwwN7LvlYTqM8jmOxm6yPsw4iQ5LvlvrULUs1dtD2PxZjJzaowQOoyKUZkck2SmTuS8lX6rVhJPr6gkg=
Message-ID: <4cefeab80707110553l4fbe2270ndc98e5c125c786f6@mail.gmail.com>
Date: Wed, 11 Jul 2007 18:23:38 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: akpm <akpm@linux-foundation.org>
Subject: Correction to LZO1X
Cc: linux-kernel@vger.kernel.org,
       "Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
       "Richard Purdie" <rpurdie@openedhand.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is correction for macro that gives worst case compressed data
size by LZO1X.


This patch was provided by the LZO author (Markus Oberhumer).

Signed-off-by: Nitin Gupta <nitingupta910@gmail.com>
---

diff --git a/include/linux/lzo.h b/include/linux/lzo.h
index 582d8b7..d793497 100644
--- a/include/linux/lzo.h
+++ b/include/linux/lzo.h
@@ -17,7 +17,7 @@
 #define LZO1X_MEM_COMPRESS     (16384 * sizeof(unsigned char *))
 #define LZO1X_1_MEM_COMPRESS   LZO1X_MEM_COMPRESS

-#define lzo1x_worst_compress(x) (x + (x / 64) + 16 + 3)
+#define lzo1x_worst_compress(x) ((x) + ((x) / 16) + 64 + 3)

 /* This requires 'workmem' of size LZO1X_1_MEM_COMPRESS */
 int lzo1x_1_compress(const unsigned char *src, size_t src_len,

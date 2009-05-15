Return-Path: <linux-kernel-owner+w=401wt.eu-S1754665AbZESHtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbZESHtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 03:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbZESHtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 03:49:15 -0400
Received: from mail.atmel.fr ([81.80.104.162]:36146 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339AbZESHtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 03:49:15 -0400
X-Mozilla-Keys: 
Message-ID: <4A0D452A.4000805@atmel.com>
Date: Fri, 15 May 2009 12:34:18 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Andrew Victor <avictor.za@gmail.com>
CC: linux-fbdev-devel@lists.sourceforge.net,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH] atmel_lcdfb: Correct fifo size for some products
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove wrong fifo size definition for some AT91 products.

Due to a misunderstanding of some AT91 datasheets, a fifo size of 2048 (words)
has been introduced by mistake. In fact, all products (AT91/AT32) are sharing
the same fifo size of 512 words.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Can we consider this fix for .30-final ?

 drivers/video/atmel_lcdfb.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
index 9a577a8..2fb63f6 100644
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -29,14 +29,8 @@
 
 /* configurable parameters */
 #define ATMEL_LCDC_CVAL_DEFAULT		0xc8
-#define ATMEL_LCDC_DMA_BURST_LEN	8
-
-#if defined(CONFIG_ARCH_AT91SAM9263) || defined(CONFIG_ARCH_AT91CAP9) || \
-	defined(CONFIG_ARCH_AT91SAM9RL)
-#define ATMEL_LCDC_FIFO_SIZE		2048
-#else
-#define ATMEL_LCDC_FIFO_SIZE		512
-#endif
+#define ATMEL_LCDC_DMA_BURST_LEN	8	/* words */
+#define ATMEL_LCDC_FIFO_SIZE		512	/* words */
 
 #if defined(CONFIG_ARCH_AT91)
 #define	ATMEL_LCDFB_FBINFO_DEFAULT	(FBINFO_DEFAULT \
-- 
1.5.3.7





Return-Path: <linux-kernel-owner+w=401wt.eu-S1762554AbZGAAk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762554AbZGAAk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760906AbZGAAcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:32:45 -0400
Received: from kroah.org ([198.145.64.141]:59770 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760888AbZGAAcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:32:43 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:15:49 2009
Message-Id: <20090701001549.750098757@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:14:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       Andrew Victor <avictor.za@gmail.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [patch 10/35] atmel_lcdfb: correct fifo size for some products
References: <20090701001356.007288418@mini.kroah.org>
Content-Disposition: inline; filename=atmel_lcdfb-correct-fifo-size-for-some-products.patch
In-Reply-To: <20090701002825.GA6518@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nicolas Ferre <nicolas.ferre@atmel.com>

commit 53b7479bbdaedcc7846c66fd608fe66f1b5aa35b upstream.

Remove wrong fifo size definition for some AT91 products.

Due to a misunderstanding of some AT91 datasheets, a fifo size of 2048
(words) has been introduced by mistake.  In fact, all products (AT91/AT32)
are sharing the same fifo size of 512 words.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Andrew Victor <avictor.za@gmail.com>
Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/atmel_lcdfb.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

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



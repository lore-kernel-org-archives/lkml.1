Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab0CCNGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 08:06:42 -0500
Received: from mail.atmel.fr ([81.80.104.162]:35422 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753742Ab0CCNGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 08:06:41 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: akpm@linux-foundation.org, linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       wolfgang.mues@auerswald.de, avictor.za@gmail.com,
       Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] mmc: at91_mci: correct kunmap_atomic()
Date: Wed,  3 Mar 2010 15:17:35 +0100
Message-Id: <1267625855-32695-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20100302133434.761df661.akpm@linux-foundation.org>
References: <20100302133434.761df661.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kunmap_atomic() accepts a pointer to any location in the page so we do not need
the subtraction and cast.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Andrew,
I created a new patch that you can stack at the top of the previous
patch series. I guess that you cannot fold it in other patches as the
kunmap_atomic() correction impacts two different patches.

Thanks.

 drivers/mmc/host/at91_mci.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
index 55507da..91dc60c 100644
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -248,7 +248,7 @@ static inline void at91_mci_sg_to_dma(struct at91mci_host *host, struct mmc_data
 			dmabuf = (unsigned *)tmpv;
 		}
 
-		kunmap_atomic(((void *)sgbuffer) - sg->offset, KM_BIO_SRC_IRQ);
+		kunmap_atomic(sgbuffer, KM_BIO_SRC_IRQ);
 
 		if (size == 0)
 			break;
@@ -313,7 +313,7 @@ static void at91_mci_post_dma_read(struct at91mci_host *host)
 			dmabuf = (unsigned *)tmpv;
 		}
 
-		kunmap_atomic(((void *)sgbuffer)-sg->offset, KM_BIO_SRC_IRQ);
+		kunmap_atomic(sgbuffer, KM_BIO_SRC_IRQ);
 		dmac_flush_range((void *)sgbuffer, ((void *)sgbuffer) + amount);
 		data->bytes_xfered += amount;
 		if (size == 0)
-- 
1.5.6.5


Return-Path: <linux-kernel-owner+w=401wt.eu-S1757901AbZBFHNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901AbZBFHNF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 02:13:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbZBFHLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 02:11:22 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:13578 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbZBFHLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 02:11:18 -0500
X-IronPort-AV: E=Sophos;i="4.37,390,1231131600"; 
   d="scan'208";a="82422009"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, akpm@linux-foundation.org
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 04/20] Blackfin SPI Driver: use len_in_bytes when we care about the number of bytes transferred
Date: Fri,  6 Feb 2009 15:12:52 +0800
Message-Id: <1233904388-5765-5-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1233904388-5765-1-git-send-email-cooloney@kernel.org>
References: <1233904388-5765-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Use len_in_bytes when we care about the number of bytes transferred
rather than the number of spi transactions. (this value will be the
same for 8bit transfers, but not any other sizes)

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/spi/spi_bfin5xx.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 1e046b1..4a67770 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -804,7 +804,7 @@ static void pump_transfers(unsigned long data)
 			if (bfin_addr_dcachable((unsigned long) drv_data->rx))
 				invalidate_dcache_range((unsigned long) drv_data->rx,
 							(unsigned long) (drv_data->rx +
-							drv_data->len));
+							drv_data->len_in_bytes));
 
 			/* clear tx reg soformer data is not shifted out */
 			write_TDBR(drv_data, 0xFFFF);
@@ -830,7 +830,7 @@ static void pump_transfers(unsigned long data)
 			if (bfin_addr_dcachable((unsigned long) drv_data->tx))
 				flush_dcache_range((unsigned long) drv_data->tx,
 						(unsigned long) (drv_data->tx +
-						drv_data->len));
+						drv_data->len_in_bytes));
 
 			/* start dma */
 			dma_enable_irq(drv_data->dma_channel);
@@ -893,7 +893,7 @@ static void pump_transfers(unsigned long data)
 			message->state = ERROR_STATE;
 		} else {
 			/* Update total byte transfered */
-			message->actual_length += drv_data->len;
+			message->actual_length += drv_data->len_in_bytes;
 
 			/* Move to next transfer of this msg */
 			message->state = next_transfer(drv_data);
-- 
1.5.6.3

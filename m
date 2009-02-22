Return-Path: <linux-kernel-owner+w=401wt.eu-S1755643AbZBVMTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbZBVMTl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 07:19:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbZBVMTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 07:19:32 -0500
Received: from cathcart.site5.com ([74.54.107.137]:43131 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbZBVMTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 07:19:31 -0500
From: Mike Rapoport <mike@compulab.co.il>
To: dbrownell@users.sourceforge.net
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       dcbw@redhat.com, andrey@cozybit.com,
       Mike Rapoport <mike@compulab.co.il>
Subject: [PATCH RESEND 2/3] pxa2xx_spi: set spi_master.dma_alignment = 8
Date: Sun, 22 Feb 2009 14:19:17 +0200
Message-Id: <60c923e5a328f72fee1e7f91eccb31f120329eb3.1234167048.git.mike@compulab.co.il>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <cover.1234167048.git.mike@compulab.co.il>
References: <cover.1234167048.git.mike@compulab.co.il>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
---
 drivers/spi/pxa2xx_spi.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/pxa2xx_spi.c b/drivers/spi/pxa2xx_spi.c
index d0fc4ca..e38f6e0 100644
--- a/drivers/spi/pxa2xx_spi.c
+++ b/drivers/spi/pxa2xx_spi.c
@@ -55,6 +55,7 @@ MODULE_ALIAS("platform:pxa2xx-spi");
 #define RESET_DMA_CHANNEL	(DCSR_NODESC | DMA_INT_MASK)
 #define IS_DMA_ALIGNED(x)	((((u32)(x)) & 0x07) == 0)
 #define MAX_DMA_LEN		8191
+#define DMA_ALIGNMENT		8
 
 /*
  * for testing SSCR1 changes that require SSP restart, basically
@@ -1440,6 +1441,7 @@ static int __init pxa2xx_spi_probe(struct platform_device *pdev)
 
 	master->bus_num = pdev->id;
 	master->num_chipselect = platform_info->num_chipselect;
+	master->dma_alignment = DMA_ALIGNMENT;
 	master->cleanup = cleanup;
 	master->setup = setup;
 	master->transfer = transfer;
-- 
1.5.6.4


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753820AbYKRHxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbYKRHxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 02:53:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYKRHv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 02:51:28 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:43724 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbYKRHvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 02:51:24 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62690398"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 09/16] Blackfin SPI Driver: do not check for SPI errors if DMA itself did not flag any
Date: Tue, 18 Nov 2008 15:52:33 +0800
Message-Id: <1226994760-4301-10-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1226994760-4301-1-git-send-email-cooloney@kernel.org>
References: <1226994760-4301-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/spi/spi_bfin5xx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index e293d19..3f4a603 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -587,7 +587,7 @@ static irqreturn_t dma_irq_handler(int irq, void *dev_id)
 	while (!(read_STAT(drv_data) & SPIF))
 		cpu_relax();
 
-	if (spistat & RBSY) {
+	if ((dmastat & DMA_ERR) && (spistat & RBSY)) {
 		msg->state = ERROR_STATE;
 		dev_err(&drv_data->pdev->dev, "dma receive: fifo/buffer overflow\n");
 	} else {
-- 
1.5.6.3

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758657AbYA3JRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758657AbYA3JRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 04:17:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755863AbYA3JNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 04:13:54 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:56219 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799AbYA3JNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 04:13:47 -0500
X-IronPort-AV: E=Sophos;i="4.25,276,1199682000"; 
   d="scan'208";a="61203871"
From: Bryan Wu <bryan.wu@analog.com>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 2/6] [Blackfin] SPI driver: Use SPI device name to do gpio peripheral request
Date: Wed, 30 Jan 2008 17:13:37 +0800
Message-Id: <1201684421-26124-3-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1201684421-26124-1-git-send-email-bryan.wu@analog.com>
References: <1201684421-26124-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When got some gpio conflict, it is easy to know which SPI device driver not just got "bfin-spi"

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/spi/spi_bfin5xx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 8fd1365..c3f9ed4 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -1176,7 +1176,7 @@ static int setup(struct spi_device *spi)
 	if ((chip->chip_select_num > 0)
 		&& (chip->chip_select_num <= spi->master->num_chipselect))
 		peripheral_request(ssel[spi->master->bus_num]
-			[chip->chip_select_num-1], DRV_NAME);
+			[chip->chip_select_num-1], spi->modalias);
 
 	cs_deactive(drv_data, chip);
 
-- 
1.5.3.4

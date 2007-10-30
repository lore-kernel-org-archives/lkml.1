Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbXJ3JVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbXJ3JVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbXJ3JSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:18:25 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:15274 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbXJ3JSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:18:16 -0400
X-IronPort-AV: i="4.21,346,1188792000"; 
   d="scan'208"; a="55175271:sNHT29958306"
From: Bryan Wu <bryan.wu@analog.com>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 12/14] Blackfin SPI driver: Fix bug in u16_cs_chg_reader to read data_len-2 bytes data firstly, then read out the last 2 bytes data
Date: Tue, 30 Oct 2007 17:18:03 +0800
Message-Id: <1193735885-8202-13-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1193735885-8202-1-git-send-email-bryan.wu@analog.com>
References: <1193735885-8202-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/spi/spi_bfin5xx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 5924903..41282bf 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -501,7 +501,7 @@ static void u16_cs_chg_reader(struct driver_data *drv_data)
 	cs_active(drv_data, chip);
 	dummy_read(drv_data);
 
-	while (drv_data->rx < drv_data->rx_end) {
+	while (drv_data->rx < drv_data->rx_end - 2) {
 		cs_deactive(drv_data, chip);
 
 		if (chip->cs_chg_udelay)
-- 
1.5.3.4

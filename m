Return-Path: <linux-kernel-owner+w=401wt.eu-S1753424AbYA3JOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbYA3JOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 04:14:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754916AbYA3JNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 04:13:49 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:56219 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbYA3JNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 04:13:45 -0500
X-IronPort-AV: E=Sophos;i="4.25,276,1199682000"; 
   d="scan'208";a="61203870"
From: Bryan Wu <bryan.wu@analog.com>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 1/6] [Blackfin] SPI driver: remove useless return status check in restore_state function pointed by Michael.
Date: Wed, 30 Jan 2008 17:13:36 +0800
Message-Id: <1201684421-26124-2-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1201684421-26124-1-git-send-email-bryan.wu@analog.com>
References: <1201684421-26124-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/spi/spi_bfin5xx.c |   15 ++-------------
 1 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 7ef39a6..8fd1365 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -223,10 +223,9 @@ static void cs_deactive(struct driver_data *drv_data, struct chip_data *chip)
 #define MAX_SPI_SSEL	7
 
 /* stop controller and re-config current chip*/
-static int restore_state(struct driver_data *drv_data)
+static void restore_state(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
-	int ret = 0;
 
 	/* Clear status and disable clock */
 	write_STAT(drv_data, BIT_STAT_CLR);
@@ -239,13 +238,6 @@ static int restore_state(struct driver_data *drv_data)
 
 	bfin_spi_enable(drv_data);
 	cs_active(drv_data, chip);
-
-	if (ret)
-		dev_dbg(&drv_data->pdev->dev,
-			": request chip select number %d failed\n",
-			chip->chip_select_num);
-
-	return ret;
 }
 
 /* used to kick off transfer in rx mode */
@@ -978,10 +970,7 @@ static void pump_messages(struct work_struct *work)
 
 	/* Setup the SSP using the per chip configuration */
 	drv_data->cur_chip = spi_get_ctldata(drv_data->cur_msg->spi);
-	if (restore_state(drv_data)) {
-		spin_unlock_irqrestore(&drv_data->lock, flags);
-		return;
-	};
+	restore_state(drv_data);
 
 	list_del_init(&drv_data->cur_msg->queue);
 
-- 
1.5.3.4

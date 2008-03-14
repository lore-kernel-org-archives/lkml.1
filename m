Return-Path: <linux-kernel-owner+w=401wt.eu-S1759686AbYCNTmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759686AbYCNTmp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 15:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758640AbYCNTlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 15:41:22 -0400
Received: from smtp.nokia.com ([192.100.122.233]:46107 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759228AbYCNTlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 15:41:20 -0400
Message-ID: <47DAD3C9.5070501@indt.org.br>
Date: Fri, 14 Mar 2008 15:36:41 -0400
From: Carlos Aguiar <carlos.aguiar@indt.org.br>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 12/18] MMC: OMAP: Using setup_timer instead of init_timer
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Mar 2008 19:39:21.0540 (UTC) FILETIME=[19C8A040:01C8860B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>

Using setup_timer() instead of init_timer() on omap.c file.

Signed-off-by: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/mmc/host/omap.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index f9cbda3..e6bf5e7 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -1245,9 +1245,8 @@ static int __init mmc_omap_new_slot(struct mmc_omap_host *host, int id)
 			goto err_remove_slot_name;
 
 		INIT_WORK(&slot->switch_work, mmc_omap_cover_handler);
-		init_timer(&slot->switch_timer);
-		slot->switch_timer.function = mmc_omap_switch_timer;
-		slot->switch_timer.data = (unsigned long) slot;
+		setup_timer(&slot->switch_timer, mmc_omap_switch_timer,
+			    (unsigned long) slot);
 		schedule_work(&slot->switch_work);
 	}
 
@@ -1324,18 +1323,13 @@ static int __init mmc_omap_probe(struct platform_device *pdev)
 	}
 
 	INIT_WORK(&host->cmd_abort, mmc_omap_abort_command);
-	init_timer(&host->cmd_timer);
-	host->cmd_timer.function = mmc_omap_cmd_timer;
-	host->cmd_timer.data = (unsigned long) host;
+	setup_timer(&host->cmd_timer, mmc_omap_cmd_timer, (unsigned long) host);
 
 	spin_lock_init(&host->dma_lock);
-	init_timer(&host->dma_timer);
+	setup_timer(&host->dma_timer, mmc_omap_dma_timer, (unsigned long) host);
 	spin_lock_init(&host->slot_lock);
 	init_waitqueue_head(&host->slot_wq);
 
-	host->dma_timer.function = mmc_omap_dma_timer;
-	host->dma_timer.data = (unsigned long) host;
-
 	host->pdata = pdata;
 	host->dev = &pdev->dev;
 	platform_set_drvdata(pdev, host);
-- 1.5.3.GIT


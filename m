Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646AbYISTKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbYISTKD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 15:10:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbYISTJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 15:09:52 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:39981 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbYISTJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 15:09:51 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: linux-kernel@vger.kernel.org, kernel@avr32linux.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH 4/4] atmel-mci: Set MMC_CAP_NEEDS_POLL if no detect_pin
Date: Fri, 19 Sep 2008 21:09:30 +0200
Message-Id: <1221851370-20189-5-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1221851370-20189-4-git-send-email-haavard.skinnemoen@atmel.com>
References: <1221851370-20189-1-git-send-email-haavard.skinnemoen@atmel.com>
 <1221851370-20189-2-git-send-email-haavard.skinnemoen@atmel.com>
 <1221851370-20189-3-git-send-email-haavard.skinnemoen@atmel.com>
 <1221851370-20189-4-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 19 Sep 2008 19:09:20.0321 (UTC) FILETIME=[383F2B10:01C91A8B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows the mmc core to detect card insertion/removal for slots that
don't have any CD pin wired up.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 drivers/mmc/host/atmel-mci.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 3909608..917035e 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -1059,6 +1059,10 @@ static int __init atmci_probe(struct platform_device *pdev)
 			host->present = !gpio_get_value(host->detect_pin);
 		}
 	}
+
+	if (!gpio_is_valid(host->detect_pin))
+		mmc->caps |= MMC_CAP_NEEDS_POLL;
+
 	if (gpio_is_valid(host->wp_pin)) {
 		if (gpio_request(host->wp_pin, "mmc_wp")) {
 			dev_dbg(&mmc->class_dev, "no WP pin available\n");
-- 
1.5.6.5


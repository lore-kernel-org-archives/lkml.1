Return-Path: <linux-kernel-owner+w=401wt.eu-S1758521AbZBEI0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521AbZBEI0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 03:26:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757176AbZBEIZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 03:25:04 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:52331 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756841AbZBEIZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 03:25:00 -0500
X-IronPort-AV: E=Sophos;i="4.37,384,1231131600"; 
   d="scan'208";a="82346617"
From: Bryan Wu <cooloney@kernel.org>
To: dwmw2@infradead.org
Cc: inux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 3/3] mtd/maps: blackfin async flash maps: fix up memory leak
Date: Thu,  5 Feb 2009 16:26:51 +0800
Message-Id: <1233822411-10210-4-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1233822411-10210-1-git-send-email-cooloney@kernel.org>
References: <1233822411-10210-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/mtd/maps/bfin-async-flash.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/maps/bfin-async-flash.c b/drivers/mtd/maps/bfin-async-flash.c
index 576611f..15d11cb 100644
--- a/drivers/mtd/maps/bfin-async-flash.c
+++ b/drivers/mtd/maps/bfin-async-flash.c
@@ -170,6 +170,7 @@ static int __devinit bfin_flash_probe(struct platform_device *pdev)
 	if (ret > 0) {
 		pr_devinit(KERN_NOTICE DRIVER_NAME ": Using commandline partition definition\n");
 		add_mtd_partitions(state->mtd, pdata->parts, ret);
+		kfree(pdata->parts);
 
 	} else if (pdata->nr_parts) {
 		pr_devinit(KERN_NOTICE DRIVER_NAME ": Using board partition definition\n");
-- 
1.5.6.3

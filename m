Return-Path: <linux-kernel-owner+w=401wt.eu-S1754474AbZEYT2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbZEYT2n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 15:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbZEYT2C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 15:28:02 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:9307 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbZEYT2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 15:28:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HJIbeXQ5SS501xgvBPdNe64IXFE6rgUgjR8RenaBAlhZbV4K3XNAr0y4UTdDn30ubu
         CEL05kdYYx56HFWtjg4UXD6ESEAqmgLo6BIharQBpF+agj3sEteHaM7fFqYDk1WjRVc3
         O+WS0cnR/hcv7eIHbZ4EjMfTThmjWxUoBRkOY=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Molton <spyro@f2s.com>, Philipp Zabel <philipp.zabel@gmail.com>,
       Pierre Ossman <pierre@ossman.eu>
Subject: [PATCH 4/5] mmc: tmio_mmc: correct probe return value for num_resources != 3
Date: Mon, 25 May 2009 21:28:00 +0200
Message-Id: <1243279681-4233-5-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1243279681-4233-1-git-send-email-philipp.zabel@gmail.com>
References: <1243279681-4233-1-git-send-email-philipp.zabel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Ian Molton <spyro@f2s.com>
---
 drivers/mmc/host/tmio_mmc.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
index 9a3dc54..b1b4e6c 100644
--- a/drivers/mmc/host/tmio_mmc.c
+++ b/drivers/mmc/host/tmio_mmc.c
@@ -521,23 +521,21 @@ static int __devinit tmio_mmc_probe(struct platform_device *dev)
 	struct resource *res_ctl, *res_cnf;
 	struct tmio_mmc_host *host;
 	struct mmc_host *mmc;
-	int ret = -ENOMEM;
+	int ret = -EINVAL;
 
 	if (dev->num_resources != 3)
 		goto out;
 
 	res_ctl = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	res_cnf = platform_get_resource(dev, IORESOURCE_MEM, 1);
-	if (!res_ctl || !res_cnf) {
-		ret = -EINVAL;
+	if (!res_ctl || !res_cnf)
 		goto out;
-	}
 
 	pdata = cell->driver_data;
-	if (!pdata || !pdata->hclk) {
-		ret = -EINVAL;
+	if (!pdata || !pdata->hclk)
 		goto out;
-	}
+
+	ret = -ENOMEM;
 
 	mmc = mmc_alloc_host(sizeof(struct tmio_mmc_host), &dev->dev);
 	if (!mmc)
-- 
1.6.3.1


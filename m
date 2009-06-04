Return-Path: <linux-kernel-owner+w=401wt.eu-S1753852AbZFDSNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbZFDSNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 14:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbZFDSMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 14:12:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:53296 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbZFDSMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 14:12:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hU/ClF8lWMz0fCR5/uqNLwK4Rost/FLAW338Knw6y8Hn1kisMQ4o3be8G8FDvUJE8s
         iDuqhulu+P4AvNesQ3uKjUt6XZKHmOme4qlS9j9tjOIy1qmIrmJgcD3xzUogUvFmMBBk
         b2JA7cOlWzJchKRWpTgS0WQDp0n304c4F1lG0=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Molton <ian@mnementh.co.uk>, Pierre Ossman <pierre@ossman.eu>,
       Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 4/7] mmc: tmio_mmc: correct probe return value for num_resources != 3
Date: Thu,  4 Jun 2009 20:12:34 +0200
Message-Id: <1244139157-16404-5-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244139157-16404-1-git-send-email-philipp.zabel@gmail.com>
References: <1244139157-16404-1-git-send-email-philipp.zabel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Acked-by: Ian Molton <ian@mnementh.co.uk>
Cc: Pierre Ossman <pierre@ossman.eu>
---
 drivers/mmc/host/tmio_mmc.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
index bbcbd72..b576640 100644
--- a/drivers/mmc/host/tmio_mmc.c
+++ b/drivers/mmc/host/tmio_mmc.c
@@ -522,23 +522,21 @@ static int __devinit tmio_mmc_probe(struct platform_device *dev)
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


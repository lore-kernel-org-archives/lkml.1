Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab0BSTss (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 14:48:48 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:59860 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753371Ab0BSTsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 14:48:33 -0500
Date: Fri, 19 Feb 2010 22:48:31 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard =?utf-8?Q?R=C3=B6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>,
       Pierre Ossman <pierre@ossman.eu>, Ben Dooks <ben@simtec.co.uk>,
       linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] sdhci-pltfm: Do not print errors in case of an
 extended iomem size
Message-ID: <20100219194831.GC16636@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some hosts have an extended SDHCI iomem size, so the driver should
only print errors if the iomem size is less than 0x100.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/mmc/host/sdhci-pltfm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pltfm.c b/drivers/mmc/host/sdhci-pltfm.c
index d0a52cb..3e65221 100644
--- a/drivers/mmc/host/sdhci-pltfm.c
+++ b/drivers/mmc/host/sdhci-pltfm.c
@@ -61,7 +61,7 @@ static int __devinit sdhci_pltfm_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	if (resource_size(iomem) != 0x100)
+	if (resource_size(iomem) < 0x100)
 		dev_err(&pdev->dev, "Invalid iomem size. You may "
 			"experience problems.\n");
 
-- 
1.7.0

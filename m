Return-Path: <linux-kernel-owner+w=401wt.eu-S1758552AbYCNTjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552AbYCNTjh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 15:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbYCNTjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 15:39:14 -0400
Received: from smtp.nokia.com ([192.100.122.230]:50387 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbYCNTjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 15:39:12 -0400
Message-ID: <47DAD3A9.1020609@indt.org.br>
Date: Fri, 14 Mar 2008 15:36:09 -0400
From: Carlos Aguiar <carlos.aguiar@indt.org.br>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 03/18] MMC: OMAP: Fix the BYTEBLOCK capability removal
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Mar 2008 19:38:49.0461 (UTC) FILETIME=[06A9C250:01C8860B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Francisco Alecrim <francisco.alecrim@indt.org.br>

According with commit 255d01af9a990fd5166f04ed0cc0b30b7b67e81e
from Linux-OMAP tree, the BYTEBLOCK capability was removed by Pierre Ossman.
MMC_CAP_BYTEBLOCK is not defined causing the compile error:

drivers/mmc/host/omap.c: In function `mmc_omap_probe':
drivers/mmc/host/omap.c:1077: error: `MMC_CAP_BYTEBLOCK' undeclared (first use in this function)
drivers/mmc/host/omap.c:1077: error: (Each undeclared identifier is reported only once
drivers/mmc/host/omap.c:1077: error: for each function it appears in.)

Signed-off-by: Francisco Alecrim <francisco.alecrim@indt.org.br>
Signed-off-by: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/mmc/host/omap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index d02f67b..e4e54ff 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -1070,7 +1070,7 @@ static int __init mmc_omap_probe(struct platform_device *pdev)
 	mmc->f_min = 400000;
 	mmc->f_max = 24000000;
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
-	mmc->caps = MMC_CAP_MULTIWRITE | MMC_CAP_BYTEBLOCK;
+	mmc->caps = MMC_CAP_MULTIWRITE;
 
 	if (minfo->wire4)
 		 mmc->caps |= MMC_CAP_4_BIT_DATA;
-- 1.5.3.GIT


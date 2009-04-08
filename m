Return-Path: <linux-kernel-owner+w=401wt.eu-S1762195AbZDHIXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762195AbZDHIXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 04:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763618AbZDHISG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 04:18:06 -0400
Received: from smtp.nokia.com ([192.100.122.230]:27081 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763616AbZDHISD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 04:18:03 -0400
Message-ID: <49DC5DD8.2070208@nokia.com>
Date: Wed, 08 Apr 2009 11:18:32 +0300
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
CC: "Lavinen Jarkko (Nokia-M/Helsinki)" <jarkko.lavinen@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH] HSMMC: mmc_omap_irq: Do not expect cmd/data to be non-null
 when CC/TC occurs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Apr 2009 08:17:31.0002 (UTC) FILETIME=[764E6DA0:01C9B822]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarkko Lavinen <jarkko.lavinen@nokia.com>

With spurious interrupt cmd can be null even when we have CC
set in irq status.

Fixes: NB#106295 - prevent potential kernel crash in the MMC driver

Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 drivers/mmc/host/omap_hsmmc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index d183be6..0268992 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -490,7 +490,7 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 
 	OMAP_HSMMC_WRITE(host->base, STAT, status);
 
-	if (end_cmd || (status & CC))
+	if (end_cmd || ((status & CC) && host->cmd))
 		mmc_omap_cmd_done(host, host->cmd);
 	if (end_trans || (status & TC))
 		mmc_omap_xfer_done(host, data);
-- 
1.5.6.3

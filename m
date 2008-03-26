Return-Path: <linux-kernel-owner+w=401wt.eu-S1759244AbYCZUQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244AbYCZUQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 16:16:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757797AbYCZUMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 16:12:53 -0400
Received: from smtp.nokia.com ([192.100.122.233]:46752 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758548AbYCZUMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 16:12:52 -0400
Message-ID: <47EAAD6C.3050502@indt.org.br>
Date: Wed, 26 Mar 2008 16:09:16 -0400
From: Carlos Aguiar <carlos.aguiar@indt.org.br>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: ext Pierre Ossman <drzeus-list@drzeus.cx>
CC: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 08/18] MMC: OMAP: Fix timeout calculation for MMC multislot
 support
References: <47DAD39C.90405@indt.org.br> <20080324132631.1e0d2125@mjolnir.drzeus.cx>
In-Reply-To: <20080324132631.1e0d2125@mjolnir.drzeus.cx>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Mar 2008 20:11:59.0546 (UTC) FILETIME=[A5CDA1A0:01C88F7D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Juha Yrjola <juha.yrjola@solidboot.com>

Fix the data timeout calculation for MMC multislot support.

Signed-off-by: Juha Yrjola <juha.yrjola@solidboot.com>
Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Signed-off-by: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/mmc/host/omap.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index f652de9..e4e7537 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -861,13 +861,12 @@ static inline void set_cmd_timeout(struct mmc_omap_host *host, struct mmc_reques
 
 static inline void set_data_timeout(struct mmc_omap_host *host, struct mmc_request *req)
 {
-	int timeout;
+	unsigned int timeout, cycle_ns;
 	u16 reg;
 
-	/* Convert ns to clock cycles by assuming 20MHz frequency
-	 * 1 cycle at 20MHz = 500 ns
-	 */
-	timeout = req->data->timeout_clks + req->data->timeout_ns / 500;
+	cycle_ns = 1000000000 / host->current_slot->fclk_freq;
+	timeout = req->data->timeout_ns / cycle_ns;
+	timeout += req->data->timeout_clks;
 
 	/* Check if we need to use timeout multiplier register */
 	reg = OMAP_MMC_READ(host, SDIO);
-- 1.5.3.GIT


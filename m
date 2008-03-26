Return-Path: <linux-kernel-owner+w=401wt.eu-S1760006AbYCZUNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760006AbYCZUNI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 16:13:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754986AbYCZUM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 16:12:29 -0400
Received: from smtp.nokia.com ([192.100.105.134]:62240 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246AbYCZUM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 16:12:28 -0400
Message-ID: <47EAAD49.9030600@indt.org.br>
Date: Wed, 26 Mar 2008 16:08:41 -0400
From: Carlos Aguiar <carlos.aguiar@indt.org.br>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: ext Pierre Ossman <drzeus-list@drzeus.cx>
CC: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 01/18] MMC: OMAP: Remove some opcodes from host driver
References: <47DAD39C.90405@indt.org.br> <20080324132631.1e0d2125@mjolnir.drzeus.cx>
In-Reply-To: <20080324132631.1e0d2125@mjolnir.drzeus.cx>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Mar 2008 20:11:24.0483 (UTC) FILETIME=[90E77130:01C88F7D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>

This patch removes some opcodes from host driver so there's no need on putting
'#include <linux/mmc/mmc.h>', that should not be needed in host drivers.

Signed-off-by: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
---
 drivers/mmc/host/omap.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index c9dfeb1..eb7175a 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -495,15 +495,10 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 		if (status & OMAP_MMC_STAT_CMD_TOUT) {
 			/* Timeouts are routine with some commands */
 			if (host->cmd) {
-				if (host->cmd->opcode != MMC_ALL_SEND_CID &&
-						host->cmd->opcode !=
-						MMC_SEND_OP_COND &&
-						host->cmd->opcode !=
-						MMC_APP_CMD &&
-						!mmc_omap_cover_is_open(host))
+				if (!mmc_omap_cover_is_open(host))
 					dev_err(mmc_dev(host->mmc),
-						"command timeout, CMD %d\n",
-						host->cmd->opcode);
+					"command timeout, CMD %d\n",
+					host->cmd->opcode);
 				host->cmd->error = -ETIMEDOUT;
 				end_command = 1;
 			}
-- 1.5.3.GIT


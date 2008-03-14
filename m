Return-Path: <linux-kernel-owner+w=401wt.eu-S1755313AbYCNTkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbYCNTkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 15:40:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754083AbYCNTjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 15:39:15 -0400
Received: from smtp.nokia.com ([192.100.122.230]:50388 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbYCNTjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 15:39:12 -0400
Message-ID: <47DAD3A1.9090702@indt.org.br>
Date: Fri, 14 Mar 2008 15:36:01 -0400
From: Carlos Aguiar <carlos.aguiar@indt.org.br>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 01/18] MMC: OMAP: Remove some opcodes from host driver
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Mar 2008 19:38:40.0914 (UTC) FILETIME=[01919720:01C8860B]
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


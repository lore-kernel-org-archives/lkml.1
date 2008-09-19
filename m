Return-Path: <linux-kernel-owner+w=401wt.eu-S1755372AbYISTLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbYISTLE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 15:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbYISTJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 15:09:54 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:39979 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796AbYISTJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 15:09:52 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: linux-kernel@vger.kernel.org, kernel@avr32linux.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH 1/4] atmel-mci: debugfs: enable clock before dumping regs
Date: Fri, 19 Sep 2008 21:09:27 +0200
Message-Id: <1221851370-20189-2-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1221851370-20189-1-git-send-email-haavard.skinnemoen@atmel.com>
References: <1221851370-20189-1-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 19 Sep 2008 19:09:20.0227 (UTC) FILETIME=[3830D330:01C91A8B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure that the peripheral clock is enabled before reading the MMIO
registers for the debugfs "regs" dump.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 drivers/mmc/host/atmel-mci.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 0bd06f5..6de773d 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -195,7 +195,9 @@ static int atmci_regs_show(struct seq_file *s, void *v)
 
 	/* Grab a more or less consistent snapshot */
 	spin_lock_irq(&host->mmc->lock);
+	clk_enable(host->mck);
 	memcpy_fromio(buf, host->regs, MCI_REGS_SIZE);
+	clk_disable(host->mck);
 	spin_unlock_irq(&host->mmc->lock);
 
 	seq_printf(s, "MR:\t0x%08x%s%s CLKDIV=%u\n",
-- 
1.5.6.5


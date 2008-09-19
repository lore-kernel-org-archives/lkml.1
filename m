Return-Path: <linux-kernel-owner+w=401wt.eu-S1755956AbYISTL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbYISTL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 15:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753818AbYISTJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 15:09:55 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:39984 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491AbYISTJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 15:09:53 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: linux-kernel@vger.kernel.org, kernel@avr32linux.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH 2/4] atmel-mci: Fix memory leak in atmci_regs_show
Date: Fri, 19 Sep 2008 21:09:28 +0200
Message-Id: <1221851370-20189-3-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1221851370-20189-2-git-send-email-haavard.skinnemoen@atmel.com>
References: <1221851370-20189-1-git-send-email-haavard.skinnemoen@atmel.com>
 <1221851370-20189-2-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 19 Sep 2008 19:09:20.0258 (UTC) FILETIME=[38358E20:01C91A8B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The debugfs hook atmci_regs_show allocates a temporary buffer for
storing a register snapshot, but it doesn't free it before returning.
Plug this leak.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 drivers/mmc/host/atmel-mci.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 6de773d..becca91 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -218,6 +218,8 @@ static int atmci_regs_show(struct seq_file *s, void *v)
 	atmci_show_status_reg(s, "SR", buf[MCI_SR / 4]);
 	atmci_show_status_reg(s, "IMR", buf[MCI_IMR / 4]);
 
+	kfree(buf);
+
 	return 0;
 }
 
-- 
1.5.6.5


Return-Path: <linux-kernel-owner+w=401wt.eu-S1759817AbZE2Nla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759817AbZE2Nla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 09:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758973AbZE2NlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 09:41:20 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:40578 "EHLO
	teyla.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757931AbZE2NlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 09:41:20 -0400
From: Ben Dooks <ben-linux@fluff.org>
To: pierre@ossman.eu, linux-kernel@vger.kernel.org
Cc: Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH] sdhci: consider ADMA error interrupt as data interrupt
Date: Fri, 29 May 2009 14:35:59 +0100
Message-Id: <1243604159-17526-1-git-send-email-ben-linux@fluff.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently any SDHCI_INT_ADMA_ERROR response is processed by
sdhci_data_irq() producing an -EIO for the transfer, but is
not in the SDHCI_INT_DATA_MASK so sdhci_irq() produces a
warning of "Unexpected interrupt 0x02000000".

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
---
 drivers/mmc/host/sdhci.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index f20a834..c9dd8bf 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -125,7 +125,7 @@
 #define  SDHCI_INT_DATA_MASK	(SDHCI_INT_DATA_END | SDHCI_INT_DMA_END | \
 		SDHCI_INT_DATA_AVAIL | SDHCI_INT_SPACE_AVAIL | \
 		SDHCI_INT_DATA_TIMEOUT | SDHCI_INT_DATA_CRC | \
-		SDHCI_INT_DATA_END_BIT)
+		SDHCI_INT_DATA_END_BIT | SDHCI_INT_ADMA_ERROR)
 #define SDHCI_INT_ALL_MASK	((unsigned int)-1)
 
 #define SDHCI_ACMD12_ERR	0x3C
-- 
1.5.6.5


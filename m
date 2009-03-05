Return-Path: <linux-kernel-owner+w=401wt.eu-S1756759AbZCEUaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbZCEUaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 15:30:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755579AbZCEU2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 15:28:38 -0500
Received: from [213.79.90.228] ([213.79.90.228]:46806 "EHLO
	buildserver.ru.mvista.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755132AbZCEU2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 15:28:38 -0500
Date: Thu, 5 Mar 2009 23:28:35 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-sdhci@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 05/11] sdhci: Add support for hosts reporting inverted
	write-protect state
Message-ID: <20090305202835.GE28709@oksana.dev.rtsoft.ru>
References: <20090305202737.GA24166@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090305202737.GA24166@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds SDHCI_QUIRK_INVERTED_WRITE_PROTECT quirk. When
specified, the sdhci driver will invert WP state.

p.s. Actually, the quirk is more board-specific than
     controller-specific.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/mmc/host/sdhci.c |    2 ++
 drivers/mmc/host/sdhci.h |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index d71c877..8aaf3a5 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1204,6 +1204,8 @@ static int sdhci_get_ro(struct mmc_host *mmc)
 
 	spin_unlock_irqrestore(&host->lock, flags);
 
+	if (host->quirks & SDHCI_QUIRK_INVERTED_WRITE_PROTECT)
+		return !!(present & SDHCI_WRITE_PROTECT);
 	return !(present & SDHCI_WRITE_PROTECT);
 }
 
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 09a4363..d0d812e 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -214,6 +214,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_NO_BUSY_IRQ				(1<<14)
 /* Controller has unreliable card detection */
 #define SDHCI_QUIRK_BROKEN_CARD_DETECTION		(1<<15)
+/* Controller reports inverted write-protect state */
+#define SDHCI_QUIRK_INVERTED_WRITE_PROTECT		(1<<16)
 
 	int			irq;		/* Device IRQ */
 	void __iomem *		ioaddr;		/* Mapped address */
-- 
1.5.6.5


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756045AbZBFSIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbZBFSIc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 13:08:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758796AbZBFSGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 13:06:54 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:3214 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758596AbZBFSGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 13:06:53 -0500
Date: Fri, 6 Feb 2009 21:06:52 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-sdhci@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 05/11] sdhci: Add support for hosts reporting inverted
	write-protect state
Message-ID: <20090206180652.GE11548@oksana.dev.rtsoft.ru>
References: <20090206180520.GA16123@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090206180520.GA16123@oksana.dev.rtsoft.ru>
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
index 45c5f1f..85f3780 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1121,6 +1121,8 @@ static int sdhci_get_ro(struct mmc_host *mmc)
 
 	spin_unlock_irqrestore(&host->lock, flags);
 
+	if (host->quirks & SDHCI_QUIRK_INVERTED_WRITE_PROTECT)
+		return !!(present & SDHCI_WRITE_PROTECT);
 	return !(present & SDHCI_WRITE_PROTECT);
 }
 
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 03f035e..fd151a1 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -229,6 +229,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_NO_BUSY_IRQ				(1<<15)
 /* Controller has unreliable card detection */
 #define SDHCI_QUIRK_BROKEN_CARD_DETECTION		(1<<16)
+/* Controller reports inverted write-protect state */
+#define SDHCI_QUIRK_INVERTED_WRITE_PROTECT		(1<<17)
 
 	int			irq;		/* Device IRQ */
 	void __iomem *		ioaddr;		/* Mapped address */
-- 
1.5.6.5


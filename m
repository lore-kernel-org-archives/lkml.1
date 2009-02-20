Return-Path: <linux-kernel-owner+w=401wt.eu-S1759997AbZBTReo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997AbZBTReo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:34:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756362AbZBTRdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:33:21 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:2982 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754948AbZBTRdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:33:20 -0500
Date: Fri, 20 Feb 2009 20:33:19 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-sdhci@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 06/13] sdhci: Add support for hosts reporting inverted
	write-protect state
Message-ID: <20090220173319.GF7583@oksana.dev.rtsoft.ru>
References: <20090220173228.GA5091@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20090220173228.GA5091@oksana.dev.rtsoft.ru>
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
index 782fb58..d668625 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1202,6 +1202,8 @@ static int sdhci_get_ro(struct mmc_host *mmc)
 
 	spin_unlock_irqrestore(&host->lock, flags);
 
+	if (host->quirks & SDHCI_QUIRK_INVERTED_WRITE_PROTECT)
+		return !!(present & SDHCI_WRITE_PROTECT);
 	return !(present & SDHCI_WRITE_PROTECT);
 }
 
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index b10920d..051fef5 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -219,6 +219,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_NO_BUSY_IRQ				(1<<15)
 /* Controller has unreliable card detection */
 #define SDHCI_QUIRK_BROKEN_CARD_DETECTION		(1<<16)
+/* Controller reports inverted write-protect state */
+#define SDHCI_QUIRK_INVERTED_WRITE_PROTECT		(1<<17)
 
 	int			irq;		/* Device IRQ */
 	void __iomem *		ioaddr;		/* Mapped address */
-- 
1.5.6.5


Return-Path: <linux-kernel-owner+w=401wt.eu-S933357AbZHGT6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933357AbZHGT6H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 15:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933270AbZHGT6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 15:58:06 -0400
Received: from ru.mvista.com ([213.79.90.228]:2234 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933264AbZHGT6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 15:58:04 -0400
Date: Fri, 7 Aug 2009 23:58:04 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pierre Ossman <pierre@ossman.eu>, Kumar Gala <galak@kernel.crashing.org>,
       David Vrabel <david.vrabel@csr.com>, Ben Dooks <ben@fluff.org>,
       Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
       sdhci-devel@lists.ossman.eu, linuxppc-dev@ozlabs.org
Subject: [PATCH 1/7] sdhci-of: Fix SD clock calculation
Message-ID: <20090807195804.GA2735@oksana.dev.rtsoft.ru>
References: <20090807195724.GA24020@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090807195724.GA24020@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linear divisor's values in a register start at 0 (zero means
"divide by 1"). Before this patch the code didn't account that
fact, so SD cards were running underclocked.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/mmc/host/sdhci-of.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/sdhci-of.c b/drivers/mmc/host/sdhci-of.c
index 9088443..92b5667 100644
--- a/drivers/mmc/host/sdhci-of.c
+++ b/drivers/mmc/host/sdhci-of.c
@@ -136,6 +136,7 @@ static void esdhc_set_clock(struct sdhci_host *host, unsigned int clock)
 	}
 
 	pre_div >>= 1;
+	div--;
 
 	setbits32(host->ioaddr + ESDHC_SYSTEM_CONTROL, ESDHC_CLOCK_IPGEN |
 		  ESDHC_CLOCK_HCKEN | ESDHC_CLOCK_PEREN |
-- 
1.6.3.3


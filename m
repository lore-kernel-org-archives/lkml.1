Return-Path: <linux-kernel-owner+w=401wt.eu-S1756674AbZLYTIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674AbZLYTIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 14:08:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756576AbZLYTIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 14:08:52 -0500
Received: from mail.gmx.net ([213.165.64.20]:52515 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756348AbZLYTIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 14:08:51 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/dGNRAVJ3dAPxDtiKU/pHCpchDbsk0dg7jvi8yc4
	FsmzjV1WTrCXpf
From: Peter Huewe <PeterHuewe@gmx.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] arch/avr32: Fix build failure for avr32 caused by typo
Date: Fri, 25 Dec 2009 20:08:45 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.27-05415-g69a8594; KDE/4.3.3; x86_64; ; )
Cc: "Hans-Christian Egtvedt" <hans-christian.egtvedt@atmel.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Ma <pma@mediamatech.com>, linux-kernel@vger.kernel.org,
       linux-mmc@vger.kernel.org, peterhuewe@gmx.de
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912252008.45602.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a build failure introduced by the patch
  atmel-mci: change use of dma slave interface by Nicolas Ferre
by changing mci_dma_slave to the correct name of mci_dma_data

This should make the avr32 tree build again.

References:
http://kisskb.ellerman.id.au/kisskb/buildresult/1893610/
http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commitdiff;h=2635d1ba711560d521f6218c585a3e0401f566e1

Patch against Linus' tree.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 arch/avr32/mach-at32ap/at32ap700x.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index 1aa1ea5..7d4ed42 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -1325,7 +1325,7 @@ struct platform_device *__init
 at32_add_device_mci(unsigned int id, struct mci_platform_data *data)
 {
 	struct platform_device		*pdev;
-	struct mci_dma_slave		*slave;
+	struct mci_dma_data	        *slave;
 	u32				pioa_mask;
 	u32				piob_mask;
 
@@ -1344,7 +1344,7 @@ at32_add_device_mci(unsigned int id, struct mci_platform_data *data)
 				ARRAY_SIZE(atmel_mci0_resource)))
 		goto fail;
 
-	slave = kzalloc(sizeof(struct mci_dma_slave), GFP_KERNEL);
+	slave = kzalloc(sizeof(struct mci_dma_data), GFP_KERNEL);
 
 	slave->sdata.dma_dev = &dw_dmac0_device.dev;
 	slave->sdata.reg_width = DW_DMA_SLAVE_WIDTH_32BIT;
-- 
1.6.4.4


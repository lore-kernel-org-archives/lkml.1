Return-Path: <linux-kernel-owner+w=401wt.eu-S1752812AbZJVEwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbZJVEwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 00:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbZJVEwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 00:52:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:38352 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbZJVEwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 00:52:08 -0400
Subject: [PATCH 2.4] net: Fix 64 bit DMA addressing for 8139cp and r8169
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Willy Tarreau <w@1wt.eu>, David Miller <davem@davemloft.net>,
       Francois Romieu <romieu@fr.zoreil.com>,
       Edward Hsu <edward_hsu@realtek.com.tw>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 22 Oct 2009 10:20:47 +0530
Message-Id: <1256187047.3184.2.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sizeof(dma_addr_t) will be either 4(32 bit) or 8(64 bit)

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/net/8139cp.c |    2 +-
 drivers/net/r8169.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/8139cp.c b/drivers/net/8139cp.c
index 9b427e4..dbc9ba2 100644
--- a/drivers/net/8139cp.c
+++ b/drivers/net/8139cp.c
@@ -1701,7 +1701,7 @@ static int cp_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	/* Configure DMA attributes. */
-	if ((sizeof(dma_addr_t) > 32) &&
+	if ((sizeof(dma_addr_t) > 4) &&
 	    !pci_set_dma_mask(pdev, 0xffffffffffffffffULL)) {
 		pci_using_dac = 1;
 	} else {
diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 8c7c202..8f37969 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -729,7 +729,7 @@ rtl8169_init_board(struct pci_dev *pdev, struct net_device **dev_out,
 
 	tp->cp_cmd = PCIMulRW | RxChkSum;
 
-	if ((sizeof(dma_addr_t) > 32) &&
+	if ((sizeof(dma_addr_t) > 4) &&
 	    !pci_set_dma_mask(pdev, DMA_64BIT_MASK))
 		tp->cp_cmd |= PCIDAC;
 	else {
-- 
1.6.0.6



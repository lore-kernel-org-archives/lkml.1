Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbYG1K2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbYG1K2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 06:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbYG1K21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 06:28:27 -0400
Received: from mail.suse.de ([195.135.220.2]:42540 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593AbYG1K20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 06:28:26 -0400
Date: Mon, 28 Jul 2008 12:28:25 +0200
From: Karsten Keil <kkeil@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Remove deprecated virt_to_bus()
Message-ID: <20080728102825.GB25509@pingi.kke.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from git://git.kernel.org/pub/scm/linux/kernel/git/kkeil/ISDN-2.6.git master

This was a forgotten item in a printk from the old driver,
the DMA allocation use already the new interface.

Signed-off-by: Karsten Keil <kkeil@suse.de>
---
 drivers/isdn/hardware/mISDN/Kconfig  |    1 -
 drivers/isdn/hardware/mISDN/hfcpci.c |    3 +--
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/Kconfig b/drivers/isdn/hardware/mISDN/Kconfig
index 9cd5f5f..1479348 100644
--- a/drivers/isdn/hardware/mISDN/Kconfig
+++ b/drivers/isdn/hardware/mISDN/Kconfig
@@ -7,7 +7,6 @@ config MISDN_HFCPCI
 	tristate "Support for HFC PCI cards"
 	depends on MISDN
 	depends on PCI
-	depends on VIRT_TO_BUS
 	help
 	  Enable support for cards with Cologne Chip AG's
           HFC PCI chip.
diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index 9179685..3231814 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -1988,8 +1988,7 @@ setup_hw(struct hfc_pci *hc)
 	printk(KERN_INFO
 		"HFC-PCI: defined at mem %#lx fifo %#lx(%#lx) IRQ %d HZ %d\n",
 		(u_long) hc->hw.pci_io, (u_long) hc->hw.fifos,
-		(u_long) virt_to_bus(hc->hw.fifos),
-		hc->irq, HZ);
+		(u_long) hc->hw.dmahandle, hc->irq, HZ);
 	/* enable memory mapped ports, disable busmaster */
 	pci_write_config_word(hc->pdev, PCI_COMMAND, PCI_ENA_MEMIO);
 	hc->hw.int_m2 = 0;
-- 
1.5.6.4


-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)

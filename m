Return-Path: <linux-kernel-owner+w=401wt.eu-S1751316AbZDHHmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316AbZDHHmn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758444AbZDHHmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:42:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57013 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757856AbZDHHm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:42:29 -0400
Message-ID: <49DC5567.3030508@cn.fujitsu.com>
Date: Wed, 08 Apr 2009 15:42:31 +0800
From: Yang Hongyang <yanghy@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH]Replace all DMA_nBIT_MASK macro with DMA_BIT_MASK(n)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second go through of the old DMA_nBIT_MASK macro,and there're not
so many of them left,so I put them into one patch.I hope this is the last round.
After this the definition of the old DMA_nBIT_MASK macro could be removed.

Signed-off-by: Yang Hongyang<yanghy@cn.fujitsu.com>

---
 arch/arm/mach-omap2/usb-musb.c      |    8 ++++----
 arch/ia64/kernel/pci-swiotlb.c      |    2 +-
 drivers/atm/solos-pci.c             |    2 +-
 drivers/block/cciss.c               |    2 +-
 drivers/net/atl1c/atl1c_main.c      |    4 ++--
 drivers/net/benet/be_main.c         |    4 ++--
 drivers/net/jme.c                   |    8 ++++----
 drivers/net/wireless/ath9k/pci.c    |    4 ++--
 drivers/net/wireless/p54/p54pci.c   |    4 ++--
 drivers/scsi/3w-9xxx.c              |    8 ++++----
 drivers/scsi/aacraid/aachba.c       |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c |   10 +++++-----
 drivers/staging/b3dfg/b3dfg.c       |    2 +-
 drivers/usb/otg/nop-usb-xceiv.c     |    4 ++--
 sound/pci/hda/hda_intel.c           |    8 ++++----
 15 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/arch/arm/mach-omap2/usb-musb.c b/arch/arm/mach-omap2/usb-musb.c
index fc74e91..34a56a1 100644
--- a/arch/arm/mach-omap2/usb-musb.c
+++ b/arch/arm/mach-omap2/usb-musb.c
@@ -131,14 +131,14 @@ static struct musb_hdrc_platform_data musb_plat = {
 	.power		= 50,			/* up to 100 mA */
 };
 
-static u64 musb_dmamask = DMA_32BIT_MASK;
+static u64 musb_dmamask = DMA_BIT_MASK(32);
 
 static struct platform_device musb_device = {
 	.name		= "musb_hdrc",
 	.id		= -1,
 	.dev = {
 		.dma_mask		= &musb_dmamask,
-		.coherent_dma_mask	= DMA_32BIT_MASK,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
 		.platform_data		= &musb_plat,
 	},
 	.num_resources	= ARRAY_SIZE(musb_resources),
@@ -146,14 +146,14 @@ static struct platform_device musb_device = {
 };
 
 #ifdef CONFIG_NOP_USB_XCEIV
-static u64 nop_xceiv_dmamask = DMA_32BIT_MASK;
+static u64 nop_xceiv_dmamask = DMA_BIT_MASK(32);
 
 static struct platform_device nop_xceiv_device = {
 	.name		= "nop_usb_xceiv",
 	.id		= -1,
 	.dev = {
 		.dma_mask		= &nop_xceiv_dmamask,
-		.coherent_dma_mask	= DMA_32BIT_MASK,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
 		.platform_data		= NULL,
 	},
 };
diff --git a/arch/ia64/kernel/pci-swiotlb.c b/arch/ia64/kernel/pci-swiotlb.c
index 573f02c..285aae8 100644
--- a/arch/ia64/kernel/pci-swiotlb.c
+++ b/arch/ia64/kernel/pci-swiotlb.c
@@ -16,7 +16,7 @@ EXPORT_SYMBOL(swiotlb);
 static void *ia64_swiotlb_alloc_coherent(struct device *dev, size_t size,
 					 dma_addr_t *dma_handle, gfp_t gfp)
 {
-	if (dev->coherent_dma_mask != DMA_64BIT_MASK)
+	if (dev->coherent_dma_mask != DMA_BIT_MASK(64))
 		gfp |= GFP_DMA;
 	return swiotlb_alloc_coherent(dev, size, dma_handle, gfp);
 }
diff --git a/drivers/atm/solos-pci.c b/drivers/atm/solos-pci.c
index be20430..9359613 100644
--- a/drivers/atm/solos-pci.c
+++ b/drivers/atm/solos-pci.c
@@ -1059,7 +1059,7 @@ static int fpga_probe(struct pci_dev *dev, const struct pci_device_id *id)
 		goto out;
 	}
 
-	err = pci_set_dma_mask(dev, DMA_32BIT_MASK);
+	err = pci_set_dma_mask(dev, DMA_BIT_MASK(32));
 	if (err) {
 		dev_warn(&dev->dev, "Failed to set 32-bit DMA mask\n");
 		goto out;
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 0ef6f08..4d4d5e0 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3505,7 +3505,7 @@ static __devinit int cciss_message(struct pci_dev *pdev, unsigned char opcode, u
 	/* The Inbound Post Queue only accepts 32-bit physical addresses for the
 	   CCISS commands, so they must be allocated from the lower 4GiB of
 	   memory. */
-	err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+	err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (err) {
 		iounmap(vaddr);
 		return -ENOMEM;
diff --git a/drivers/net/atl1c/atl1c_main.c b/drivers/net/atl1c/atl1c_main.c
index deb7b53..83a1212 100644
--- a/drivers/net/atl1c/atl1c_main.c
+++ b/drivers/net/atl1c/atl1c_main.c
@@ -2532,8 +2532,8 @@ static int __devinit atl1c_probe(struct pci_dev *pdev,
 	 * various kernel subsystems to support the mechanics required by a
 	 * fixed-high-32-bit system.
 	 */
-	if ((pci_set_dma_mask(pdev, DMA_32BIT_MASK) != 0) ||
-	    (pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK) != 0)) {
+	if ((pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) != 0) ||
+	    (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)) != 0)) {
 		dev_err(&pdev->dev, "No usable DMA configuration,aborting\n");
 		goto err_dma;
 	}
diff --git a/drivers/net/benet/be_main.c b/drivers/net/benet/be_main.c
index 9b75aa6..30d0c81 100644
--- a/drivers/net/benet/be_main.c
+++ b/drivers/net/benet/be_main.c
@@ -1821,11 +1821,11 @@ static int __devinit be_probe(struct pci_dev *pdev,
 
 	be_msix_enable(adapter);
 
-	status = pci_set_dma_mask(pdev, DMA_64BIT_MASK);
+	status = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
 	if (!status) {
 		netdev->features |= NETIF_F_HIGHDMA;
 	} else {
-		status = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		status = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (status) {
 			dev_err(&pdev->dev, "Could not set PCI DMA Mask\n");
 			goto free_netdev;
diff --git a/drivers/net/jme.c b/drivers/net/jme.c
index ece3504..621a7c0 100644
--- a/drivers/net/jme.c
+++ b/drivers/net/jme.c
@@ -2591,13 +2591,13 @@ static int
 jme_pci_dma64(struct pci_dev *pdev)
 {
 	if (pdev->device == PCI_DEVICE_ID_JMICRON_JMC250 &&
-	    !pci_set_dma_mask(pdev, DMA_64BIT_MASK))
-		if (!pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK))
+	    !pci_set_dma_mask(pdev, DMA_BIT_MASK(64)))
+		if (!pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64)))
 			return 1;
 
 	if (pdev->device == PCI_DEVICE_ID_JMICRON_JMC250 &&
-	    !pci_set_dma_mask(pdev, DMA_40BIT_MASK))
-		if (!pci_set_consistent_dma_mask(pdev, DMA_40BIT_MASK))
+	    !pci_set_dma_mask(pdev, DMA_BIT_MASK(40)))
+		if (!pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(40)))
 			return 1;
 
 	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32)))
diff --git a/drivers/net/wireless/ath9k/pci.c b/drivers/net/wireless/ath9k/pci.c
index 6dbc585..168411d 100644
--- a/drivers/net/wireless/ath9k/pci.c
+++ b/drivers/net/wireless/ath9k/pci.c
@@ -93,14 +93,14 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (pci_enable_device(pdev))
 		return -EIO;
 
-	ret =  pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+	ret =  pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 
 	if (ret) {
 		printk(KERN_ERR "ath9k: 32-bit DMA not available\n");
 		goto bad;
 	}
 
-	ret = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+	ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 
 	if (ret) {
 		printk(KERN_ERR "ath9k: 32-bit DMA consistent "
diff --git a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
index e3569a0..b1610ea 100644
--- a/drivers/net/wireless/p54/p54pci.c
+++ b/drivers/net/wireless/p54/p54pci.c
@@ -492,8 +492,8 @@ static int __devinit p54p_probe(struct pci_dev *pdev,
 		goto err_disable_dev;
 	}
 
-	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK) ||
-	    pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK)) {
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) ||
+	    pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32))) {
 		dev_err(&pdev->dev, "No suitable DMA available\n");
 		goto err_free_reg;
 	}
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index fdb14ec..8b7983a 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -2234,10 +2234,10 @@ static int twa_resume(struct pci_dev *pdev)
 	pci_set_master(pdev);
 	pci_try_set_mwi(pdev);
 
-	if (pci_set_dma_mask(pdev, DMA_64BIT_MASK)
-	    || pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK))
-		if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)
-		    || pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK)) {
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64))
+	    || pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64)))
+		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))
+		    || pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32))) {
 			TW_PRINTK(host, TW_DRIVER, 0x40, "Failed to set dma mask during resume");
 			retval = -ENODEV;
 			goto out_disable_device;
diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 280261c..2a88985 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1378,7 +1378,7 @@ int aac_get_adapter_info(struct aac_dev* dev)
 	if (dev->nondasd_support && !dev->in_reset)
 		printk(KERN_INFO "%s%d: Non-DASD support enabled.\n",dev->name, dev->id);
 
-	if (dma_get_required_mask(&dev->pdev->dev) > DMA_32BIT_MASK)
+	if (dma_get_required_mask(&dev->pdev->dev) > DMA_BIT_MASK(32))
 		dev->needs_dac = 1;
 	dev->dac_support = 0;
 	if ((sizeof(dma_addr_t) > 4) && dev->needs_dac &&
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 52427a8..a91f514 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -855,9 +855,9 @@ _base_config_dma_addressing(struct MPT2SAS_ADAPTER *ioc, struct pci_dev *pdev)
 	if (sizeof(dma_addr_t) > 4) {
 		const uint64_t required_mask =
 		    dma_get_required_mask(&pdev->dev);
-		if ((required_mask > DMA_32BIT_MASK) && !pci_set_dma_mask(pdev,
-		    DMA_64BIT_MASK) && !pci_set_consistent_dma_mask(pdev,
-		    DMA_64BIT_MASK)) {
+		if ((required_mask > DMA_BIT_MASK(32)) && !pci_set_dma_mask(pdev,
+		    DMA_BIT_MASK(64)) && !pci_set_consistent_dma_mask(pdev,
+		    DMA_BIT_MASK(64))) {
 			ioc->base_add_sg_single = &_base_add_sg_single_64;
 			ioc->sge_size = sizeof(Mpi2SGESimple64_t);
 			desc = "64";
@@ -865,8 +865,8 @@ _base_config_dma_addressing(struct MPT2SAS_ADAPTER *ioc, struct pci_dev *pdev)
 		}
 	}
 
-	if (!pci_set_dma_mask(pdev, DMA_32BIT_MASK)
-	    && !pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK)) {
+	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))
+	    && !pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32))) {
 		ioc->base_add_sg_single = &_base_add_sg_single_32;
 		ioc->sge_size = sizeof(Mpi2SGESimple32_t);
 		desc = "32";
diff --git a/drivers/staging/b3dfg/b3dfg.c b/drivers/staging/b3dfg/b3dfg.c
index 0348072..75ebe33 100644
--- a/drivers/staging/b3dfg/b3dfg.c
+++ b/drivers/staging/b3dfg/b3dfg.c
@@ -1000,7 +1000,7 @@ static int __devinit b3dfg_probe(struct pci_dev *pdev,
 
 	pci_set_master(pdev);
 
-	r = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+	r = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (r) {
 		dev_err(&pdev->dev, "no usable DMA configuration\n");
 		goto err_free_res;
diff --git a/drivers/usb/otg/nop-usb-xceiv.c b/drivers/usb/otg/nop-usb-xceiv.c
index 4b933f6..c567168 100644
--- a/drivers/usb/otg/nop-usb-xceiv.c
+++ b/drivers/usb/otg/nop-usb-xceiv.c
@@ -36,14 +36,14 @@ struct nop_usb_xceiv {
 	struct device		*dev;
 };
 
-static u64 nop_xceiv_dmamask = DMA_32BIT_MASK;
+static u64 nop_xceiv_dmamask = DMA_BIT_MASK(32);
 
 static struct platform_device nop_xceiv_device = {
 	.name           = "nop_usb_xceiv",
 	.id             = -1,
 	.dev = {
 		.dma_mask               = &nop_xceiv_dmamask,
-		.coherent_dma_mask      = DMA_32BIT_MASK,
+		.coherent_dma_mask      = DMA_BIT_MASK(32),
 		.platform_data          = NULL,
 	},
 };
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 30829ee..7ba8db5 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2260,11 +2260,11 @@ static int __devinit azx_create(struct snd_card *card, struct pci_dev *pci,
 		gcap &= ~0x01;
 
 	/* allow 64bit DMA address if supported by H/W */
-	if ((gcap & 0x01) && !pci_set_dma_mask(pci, DMA_64BIT_MASK))
-		pci_set_consistent_dma_mask(pci, DMA_64BIT_MASK);
+	if ((gcap & 0x01) && !pci_set_dma_mask(pci, DMA_BIT_MASK(64)))
+		pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(64));
 	else {
-		pci_set_dma_mask(pci, DMA_32BIT_MASK);
-		pci_set_consistent_dma_mask(pci, DMA_32BIT_MASK);
+		pci_set_dma_mask(pci, DMA_BIT_MASK(32));
+		pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(32));
 	}
 
 	/* read number of streams from GCAP register instead of using
-- 
1.6.0.3

-- 
Regards
Yang Hongyang

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753319AbYI2H1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbYI2H1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 03:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbYI2H07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 03:26:59 -0400
Received: from colo.lackof.org ([198.49.126.79]:42970 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbYI2H05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 03:26:57 -0400
Date: Mon, 29 Sep 2008 01:26:43 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: introduce users of ioremap_pcibar()
Message-ID: <20080929072643.GA28871@colo.lackof.org>
References: <20080926163641.288bf868@infradead.org> <20080926163718.32f0867e@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080926163718.32f0867e@infradead.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 04:37:18PM -0700, Arjan van de Ven wrote:
> >From b94333809306543604f8bf23da6dddca3efac451 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Fri, 26 Sep 2008 16:36:00 -0700
> Subject: [PATCH] pci: introduce users of ioremap_pcibar()
> 
> one big patch for now; I'll split this up after the first review round to avoid
> to have to redo that many times

*nod*

FTR, I like this interface better since most drivers use ioremap() instead
of ioremap_nocache(). They generally should be using the latter.

> ---
>  drivers/block/sx8.c                        |    3 +--
>  drivers/edac/i82875p_edac.c                |    4 +---
>  drivers/i2c/busses/i2c-hydra.c             |    2 +-
>  drivers/ide/pci/sgiioc4.c                  |    2 +-
>  drivers/media/common/saa7146_core.c        |    3 +--
>  drivers/media/video/cx23885/cx23885-core.c |    3 +--
>  drivers/media/video/cx88/cx88-cards.c      |    3 +--
>  drivers/mfd/sm501.c                        |    3 +--
>  drivers/misc/ibmasm/module.c               |    3 +--
>  drivers/misc/tifm_7xx1.c                   |    3 +--
>  drivers/mmc/host/sdhci-pci.c               |    2 +-
>  drivers/mtd/maps/pci.c                     |    3 +--
>  drivers/net/bnx2x_main.c                   |    3 +--
>  drivers/net/e1000/e1000_main.c             |    7 ++-----
>  drivers/net/epic100.c                      |    2 +-
>  drivers/net/ixgb/ixgb_main.c               |    3 +--
>  drivers/net/qla3xxx.c                      |    4 +---
>  drivers/net/s2io.c                         |    6 ++----
>  drivers/net/wan/dscc4.c                    |    3 +--
>  drivers/net/wan/pc300too.c                 |    2 +-
>  drivers/net/wan/pci200syn.c                |    2 +-
>  drivers/net/wireless/hostap/hostap_pci.c   |    2 +-
>  drivers/net/wireless/ipw2200.c             |    2 +-
>  drivers/net/wireless/rt2x00/rt2x00pci.c    |    3 +--
>  drivers/pci/hotplug/cpcihp_zt5550.c        |    3 +--
>  drivers/pci/hotplug/cpqphp_core.c          |    3 +--
>  drivers/scsi/advansys.c                    |    3 +--
>  drivers/scsi/arcmsr/arcmsr_hba.c           |    8 +++-----
>  drivers/scsi/ipr.c                         |    2 +-
>  drivers/scsi/nsp32.c                       |    3 +--
>  drivers/scsi/qla1280.c                     |    3 +--
>  drivers/scsi/stex.c                        |    3 +--
>  drivers/serial/8250_pci.c                  |    6 ++----
>  drivers/serial/icom.c                      |    3 +--
>  drivers/uio/uio_cif.c                      |    3 +--
>  drivers/usb/host/pci-quirks.c              |   13 +++++++------
>  drivers/video/aty/aty128fb.c               |    2 +-
>  drivers/video/cyber2000fb.c                |    3 +--
>  drivers/video/geode/gx1fb_core.c           |    3 +--
>  drivers/video/geode/gxfb_core.c            |    8 +++-----
>  drivers/video/geode/lxfb_core.c            |    9 +++------
>  drivers/video/gxt4500.c                    |    4 ++--
>  drivers/watchdog/i6300esb.c                |    3 +--
>  43 files changed, 59 insertions(+), 99 deletions(-)
> 
> diff --git a/drivers/block/sx8.c b/drivers/block/sx8.c
> index a18e1ca..81a1fe7 100644
> --- a/drivers/block/sx8.c
> +++ b/drivers/block/sx8.c
> @@ -1625,8 +1625,7 @@ static int carm_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
>  	for (i = 0; i < ARRAY_SIZE(host->req); i++)
>  		host->req[i].tag = i;
>  
> -	host->mmio = ioremap(pci_resource_start(pdev, 0),
> -			     pci_resource_len(pdev, 0));
> +	host->mmio = ioremap_pcibar(pdev, 0);
>  	if (!host->mmio) {
>  		printk(KERN_ERR DRV_NAME "(%s): MMIO alloc failure\n",
>  		       pci_name(pdev));
> diff --git a/drivers/edac/i82875p_edac.c b/drivers/edac/i82875p_edac.c
> index e43bdc4..d1e77af 100644
> --- a/drivers/edac/i82875p_edac.c
> +++ b/drivers/edac/i82875p_edac.c
> @@ -312,9 +312,7 @@ static int i82875p_setup_overfl_dev(struct pci_dev *pdev,
>  	}
>  
>  	/* cache is irrelevant for PCI bus reads/writes */
> -	window = ioremap_nocache(pci_resource_start(dev, 0),
> -				 pci_resource_len(dev, 0));
> -
> +	window = ioremap_pcibar(dev, 0);

Should the comment be deleted?
It made sense (sort of) for the orginal code and maybe including
a comment like it in the new ioremap_pcibar() would be good.

Alternatively, the ioremap_pcibar() code needs to check for
cacheable attribute and DTRT.

>  	if (window == NULL) {
>  		i82875p_printk(KERN_ERR, "%s(): Failed to ioremap bar6\n",
>  			__func__);
> diff --git a/drivers/i2c/busses/i2c-hydra.c b/drivers/i2c/busses/i2c-hydra.c
> index 1098f21..9f15d78 100644
> --- a/drivers/i2c/busses/i2c-hydra.c
> +++ b/drivers/i2c/busses/i2c-hydra.c
> @@ -123,7 +123,7 @@ static int __devinit hydra_probe(struct pci_dev *dev,
>  				hydra_adap.name))
>  		return -EBUSY;
>  
> -	hydra_bit_data.data = ioremap(base, pci_resource_len(dev, 0));
> +	hydra_bit_data.data = ioremap_pcibar(dev, 0);
>  	if (hydra_bit_data.data == NULL) {
>  		release_mem_region(base+offsetof(struct Hydra, CachePD), 4);
>  		return -ENODEV;
> diff --git a/drivers/ide/pci/sgiioc4.c b/drivers/ide/pci/sgiioc4.c
> index 681306c..4e1eed7 100644
> --- a/drivers/ide/pci/sgiioc4.c
> +++ b/drivers/ide/pci/sgiioc4.c
> @@ -607,7 +607,7 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
>  
>  	/*  Get the CmdBlk and CtrlBlk Base Registers */
>  	bar0 = pci_resource_start(dev, 0);
> -	virt_base = ioremap(bar0, pci_resource_len(dev, 0));
> +	virt_base = ioremap_pcibar(dev, 0);
>  	if (virt_base == NULL) {
>  		printk(KERN_ERR "%s: Unable to remap BAR 0 address: 0x%lx\n",
>  				DRV_NAME, bar0);
> diff --git a/drivers/media/common/saa7146_core.c b/drivers/media/common/saa7146_core.c
> index d01965e..23b6d17 100644
> --- a/drivers/media/common/saa7146_core.c
> +++ b/drivers/media/common/saa7146_core.c
> @@ -391,8 +391,7 @@ static int saa7146_init_one(struct pci_dev *pci, const struct pci_device_id *ent
>  	if (err < 0)
>  		goto err_disable;
>  
> -	dev->mem = ioremap(pci_resource_start(pci, 0),
> -			   pci_resource_len(pci, 0));
> +	dev->mem = ioremap_pcibar(pci, 0);
>  	if (!dev->mem) {
>  		ERR(("ioremap() failed.\n"));
>  		err = -ENODEV;
> diff --git a/drivers/media/video/cx23885/cx23885-core.c b/drivers/media/video/cx23885/cx23885-core.c
> index 25fb099..d55da7d 100644
> --- a/drivers/media/video/cx23885/cx23885-core.c
> +++ b/drivers/media/video/cx23885/cx23885-core.c
> @@ -831,8 +831,7 @@ static int cx23885_dev_setup(struct cx23885_dev *dev)
>  	}
>  
>  	/* PCIe stuff */
> -	dev->lmmio = ioremap(pci_resource_start(dev->pci,0),
> -			     pci_resource_len(dev->pci,0));
> +	dev->lmmio = ioremap_pcibar(dev->pci, 0);
>  
>  	dev->bmmio = (u8 __iomem *)dev->lmmio;
>  
> diff --git a/drivers/media/video/cx88/cx88-cards.c b/drivers/media/video/cx88/cx88-cards.c
> index de199a2..3875c55 100644
> --- a/drivers/media/video/cx88/cx88-cards.c
> +++ b/drivers/media/video/cx88/cx88-cards.c
> @@ -2715,8 +2715,7 @@ struct cx88_core *cx88_core_create(struct pci_dev *pci, int nr)
>  
>  	/* PCI stuff */
>  	cx88_pci_quirks(core->name, pci);
> -	core->lmmio = ioremap(pci_resource_start(pci, 0),
> -			      pci_resource_len(pci, 0));
> +	core->lmmio = ioremap_pcibar(pci, 0);

Is there any easy way to tell if the device driver should be using
uncached mappings vs cacheable mappings?
(Just from looking at the source code)

This patch changes that behavior of the device driver so it uses
uncacheable instead of cacheable mappings.  This is the only thing
I'm uncertain about for this patch.

For storage/networking/audio cards I'm comfortable with the generalization
that they all should use uncacheable mappings (I'm sure there are some
exceptions.) I'm not with video devices.

I'm pretty sure this patch won't break anything. Good chance it will
fix some existing drivers on platforms that really do map the BAR cacheable.
But it might hurt performance on a few devices that really intended
to use cacheable mappings for stuff like write coalescing.


And I have a second issue less important issue.
What is the result of ioremap_pcibar(pci, 1) when BAR0 is a 64-bit bar?
Given the name, I expect to call "ioremap_pcibar(pci,2)" to get the
desired result.  Maybe just document how to handle this correctly
in Documentation/pci.txt would be sufficient.

hth,
grant

>  	core->bmmio = (u8 __iomem *)core->lmmio;
>  
>  	/* board config */
> diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
> index 7aebad4..d562f41 100644
> --- a/drivers/mfd/sm501.c
> +++ b/drivers/mfd/sm501.c
> @@ -1625,8 +1625,7 @@ static int sm501_pci_probe(struct pci_dev *dev,
>  		goto err3;
>  	}
>  
> -	sm->regs = ioremap(pci_resource_start(dev, 1),
> -			   pci_resource_len(dev, 1));
> +	sm->regs = ioremap_pcibar(dev, 1);
>  
>  	if (sm->regs == NULL) {
>  		dev_err(&dev->dev, "cannot remap registers\n");
> diff --git a/drivers/misc/ibmasm/module.c b/drivers/misc/ibmasm/module.c
> index b5f6add..a5aca05 100644
> --- a/drivers/misc/ibmasm/module.c
> +++ b/drivers/misc/ibmasm/module.c
> @@ -104,8 +104,7 @@ static int __devinit ibmasm_init_one(struct pci_dev *pdev, const struct pci_devi
>  	}
>  
>  	sp->irq = pdev->irq;
> -	sp->base_address = ioremap(pci_resource_start(pdev, 0),
> -					pci_resource_len(pdev, 0));
> +	sp->base_address = ioremap_pcibar(pdev, 0);
>  	if (!sp->base_address) {
>  		dev_err(sp->dev, "Failed to ioremap pci memory\n");
>  		result =  -ENODEV;
> diff --git a/drivers/misc/tifm_7xx1.c b/drivers/misc/tifm_7xx1.c
> index 67503ea..e2f177e 100644
> --- a/drivers/misc/tifm_7xx1.c
> +++ b/drivers/misc/tifm_7xx1.c
> @@ -354,8 +354,7 @@ static int tifm_7xx1_probe(struct pci_dev *dev,
>  	fm->has_ms_pif = tifm_7xx1_has_ms_pif;
>  	pci_set_drvdata(dev, fm);
>  
> -	fm->addr = ioremap(pci_resource_start(dev, 0),
> -			   pci_resource_len(dev, 0));
> +	fm->addr = ioremap_pcibar(dev, 0);
>  	if (!fm->addr)
>  		goto err_out_free;
>  
> diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
> index fcb14c2..b8be3f1 100644
> --- a/drivers/mmc/host/sdhci-pci.c
> +++ b/drivers/mmc/host/sdhci-pci.c
> @@ -544,7 +544,7 @@ static struct sdhci_pci_slot * __devinit sdhci_pci_probe_slot(
>  	}
>  
>  	addr = pci_resource_start(pdev, bar);
> -	host->ioaddr = ioremap_nocache(addr, pci_resource_len(pdev, bar));
> +	host->ioaddr = ioremap_pcibar(pdev, bar);
>  	if (!host->ioaddr) {
>  		dev_err(&pdev->dev, "failed to remap registers\n");
>  		goto release;
> diff --git a/drivers/mtd/maps/pci.c b/drivers/mtd/maps/pci.c
> index 5c6a25c..e53612a 100644
> --- a/drivers/mtd/maps/pci.c
> +++ b/drivers/mtd/maps/pci.c
> @@ -120,8 +120,7 @@ intel_iq80310_init(struct pci_dev *dev, struct map_pci_info *map)
>  	map->map.write = mtd_pci_write8,
>  
>  	map->map.size     = 0x00800000;
> -	map->base         = ioremap_nocache(pci_resource_start(dev, 0),
> -					    pci_resource_len(dev, 0));
> +	map->base         = ioremap_pcibar(dev, 0);
>  
>  	if (!map->base)
>  		return -ENOMEM;
> diff --git a/drivers/net/bnx2x_main.c b/drivers/net/bnx2x_main.c
> index a8eb3c4..2f4dd50 100644
> --- a/drivers/net/bnx2x_main.c
> +++ b/drivers/net/bnx2x_main.c
> @@ -10089,8 +10089,7 @@ static int __devinit bnx2x_init_dev(struct pci_dev *pdev,
>  
>  	dev->irq = pdev->irq;
>  
> -	bp->regview = ioremap_nocache(dev->base_addr,
> -				      pci_resource_len(pdev, 0));
> +	bp->regview = ioremap_pcibar(pdev, 0);
>  	if (!bp->regview) {
>  		printk(KERN_ERR PFX "Cannot map register space, aborting\n");
>  		rc = -ENOMEM;
> diff --git a/drivers/net/e1000/e1000_main.c b/drivers/net/e1000/e1000_main.c
> index ad6da7b..617761c 100644
> --- a/drivers/net/e1000/e1000_main.c
> +++ b/drivers/net/e1000/e1000_main.c
> @@ -973,8 +973,7 @@ static int __devinit e1000_probe(struct pci_dev *pdev,
>  	hw->back = adapter;
>  
>  	err = -EIO;
> -	hw->hw_addr = ioremap(pci_resource_start(pdev, BAR_0),
> -			      pci_resource_len(pdev, BAR_0));
> +	hw->hw_addr = ioremap_pcibar(pdev, BAR_0);
>  	if (!hw->hw_addr)
>  		goto err_ioremap;
>  
> @@ -1022,9 +1021,7 @@ static int __devinit e1000_probe(struct pci_dev *pdev,
>  	 * because it depends on mac_type */
>  	if ((hw->mac_type == e1000_ich8lan) &&
>  	   (pci_resource_flags(pdev, 1) & IORESOURCE_MEM)) {
> -		hw->flash_address =
> -			ioremap(pci_resource_start(pdev, 1),
> -				pci_resource_len(pdev, 1));
> +		hw->flash_address = ioremap_pcibar(pdev, 1);
>  		if (!hw->flash_address)
>  			goto err_flashmap;
>  	}
> diff --git a/drivers/net/epic100.c b/drivers/net/epic100.c
> index 76118dd..71e9e84 100644
> --- a/drivers/net/epic100.c
> +++ b/drivers/net/epic100.c
> @@ -364,7 +364,7 @@ static int __devinit epic_init_one (struct pci_dev *pdev,
>  	ioaddr = pci_resource_start (pdev, 0);
>  #else
>  	ioaddr = pci_resource_start (pdev, 1);
> -	ioaddr = (long) ioremap (ioaddr, pci_resource_len (pdev, 1));
> +	ioaddr = (long) ioremap_pcibar(pdev, 1);
>  	if (!ioaddr) {
>  		dev_err(&pdev->dev, "ioremap failed\n");
>  		goto err_out_free_netdev;
> diff --git a/drivers/net/ixgb/ixgb_main.c b/drivers/net/ixgb/ixgb_main.c
> index aa75385..bf7553d 100644
> --- a/drivers/net/ixgb/ixgb_main.c
> +++ b/drivers/net/ixgb/ixgb_main.c
> @@ -381,8 +381,7 @@ ixgb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	adapter->hw.back = adapter;
>  	adapter->msg_enable = netif_msg_init(debug, DEFAULT_DEBUG_LEVEL_SHIFT);
>  
> -	adapter->hw.hw_addr = ioremap(pci_resource_start(pdev, BAR_0),
> -	                              pci_resource_len(pdev, BAR_0));
> +	adapter->hw.hw_addr = ioremap_pcibar(pdev, BAR_0);
>  	if (!adapter->hw.hw_addr) {
>  		err = -EIO;
>  		goto err_ioremap;
> diff --git a/drivers/net/qla3xxx.c b/drivers/net/qla3xxx.c
> index 3cdd07c..0a97470 100644
> --- a/drivers/net/qla3xxx.c
> +++ b/drivers/net/qla3xxx.c
> @@ -3978,9 +3978,7 @@ static int __devinit ql3xxx_probe(struct pci_dev *pdev,
>  	if (qdev->device_id == QL3032_DEVICE_ID)
>  		ndev->features |= NETIF_F_IP_CSUM | NETIF_F_SG;
>  
> -	qdev->mem_map_registers =
> -	    ioremap_nocache(pci_resource_start(pdev, 1),
> -			    pci_resource_len(qdev->pdev, 1));
> +	qdev->mem_map_registers = ioremap_pcibar(pdev, 1);
>  	if (!qdev->mem_map_registers) {
>  		printk(KERN_ERR PFX "%s: cannot map device registers\n",
>  		       pci_name(pdev));
> diff --git a/drivers/net/s2io.c b/drivers/net/s2io.c
> index a2b0730..a7f7c45 100644
> --- a/drivers/net/s2io.c
> +++ b/drivers/net/s2io.c
> @@ -7921,8 +7921,7 @@ s2io_init_nic(struct pci_dev *pdev, const struct pci_device_id *pre)
>  		goto mem_alloc_failed;
>  	}
>  
> -	sp->bar0 = ioremap(pci_resource_start(pdev, 0),
> -				     pci_resource_len(pdev, 0));
> +	sp->bar0 = ioremap_pcibar(pdev, 0);
>  	if (!sp->bar0) {
>  		DBG_PRINT(ERR_DBG, "%s: Neterion: cannot remap io mem1\n",
>  			  dev->name);
> @@ -7930,8 +7929,7 @@ s2io_init_nic(struct pci_dev *pdev, const struct pci_device_id *pre)
>  		goto bar0_remap_failed;
>  	}
>  
> -	sp->bar1 = ioremap(pci_resource_start(pdev, 2),
> -				     pci_resource_len(pdev, 2));
> +	sp->bar1 = ioremap_pcibar(pdev, 2);
>  	if (!sp->bar1) {
>  		DBG_PRINT(ERR_DBG, "%s: Neterion: cannot remap io mem2\n",
>  			  dev->name);
> diff --git a/drivers/net/wan/dscc4.c b/drivers/net/wan/dscc4.c
> index f5d55ad..a2984aa 100644
> --- a/drivers/net/wan/dscc4.c
> +++ b/drivers/net/wan/dscc4.c
> @@ -730,8 +730,7 @@ static int __devinit dscc4_init_one(struct pci_dev *pdev,
>  	        goto err_free_mmio_region_1;
>  	}
>  
> -	ioaddr = ioremap(pci_resource_start(pdev, 0),
> -					pci_resource_len(pdev, 0));
> +	ioaddr = ioremap_pcibar(pdev, 0);
>  	if (!ioaddr) {
>  		printk(KERN_ERR "%s: cannot remap MMIO region %llx @ %llx\n",
>  			DRV_NAME, (unsigned long long)pci_resource_len(pdev, 0),
> diff --git a/drivers/net/wan/pc300too.c b/drivers/net/wan/pc300too.c
> index bf1b015..a6a3234 100644
> --- a/drivers/net/wan/pc300too.c
> +++ b/drivers/net/wan/pc300too.c
> @@ -379,7 +379,7 @@ static int __devinit pc300_pci_init_one(struct pci_dev *pdev,
>  	card->scabase = ioremap(scaphys, PC300_SCA_SIZE);
>  
>  	ramphys = pci_resource_start(pdev,3) & PCI_BASE_ADDRESS_MEM_MASK;
> -	card->rambase = ioremap(ramphys, pci_resource_len(pdev,3));
> +	card->rambase = ioremap_pcibar(pdev, 3);
>  
>  	if (card->plxbase == NULL ||
>  	    card->scabase == NULL ||
> diff --git a/drivers/net/wan/pci200syn.c b/drivers/net/wan/pci200syn.c
> index b595b64..bb21980 100644
> --- a/drivers/net/wan/pci200syn.c
> +++ b/drivers/net/wan/pci200syn.c
> @@ -343,7 +343,7 @@ static int __devinit pci200_pci_init_one(struct pci_dev *pdev,
>  	card->scabase = ioremap(scaphys, PCI200SYN_SCA_SIZE);
>  
>  	ramphys = pci_resource_start(pdev,3) & PCI_BASE_ADDRESS_MEM_MASK;
> -	card->rambase = ioremap(ramphys, pci_resource_len(pdev,3));
> +	card->rambase = ioremap_pcibar(pdev, 3);
>  
>  	if (card->plxbase == NULL ||
>  	    card->scabase == NULL ||
> diff --git a/drivers/net/wireless/hostap/hostap_pci.c b/drivers/net/wireless/hostap/hostap_pci.c
> index 3a874fc..adb4c10 100644
> --- a/drivers/net/wireless/hostap/hostap_pci.c
> +++ b/drivers/net/wireless/hostap/hostap_pci.c
> @@ -312,7 +312,7 @@ static int prism2_pci_probe(struct pci_dev *pdev,
>  		goto err_out_disable;
>  	}
>  
> -	mem = ioremap(phymem, pci_resource_len(pdev, 0));
> +	mem = ioremap_pcibar(pdev, 0);
>  	if (mem == NULL) {
>  		printk(KERN_ERR "prism2: Cannot remap PCI memory region\n") ;
>  		goto fail;
> diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
> index dcce354..22bfe83 100644
> --- a/drivers/net/wireless/ipw2200.c
> +++ b/drivers/net/wireless/ipw2200.c
> @@ -11648,7 +11648,7 @@ static int __devinit ipw_pci_probe(struct pci_dev *pdev,
>  	length = pci_resource_len(pdev, 0);
>  	priv->hw_len = length;
>  
> -	base = ioremap_nocache(pci_resource_start(pdev, 0), length);
> +	base = ioremap_pcibar(pdev, 0);
>  	if (!base) {
>  		err = -ENODEV;
>  		goto out_pci_release_regions;
> diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
> index adf2876..7ce1abb 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
> @@ -222,8 +222,7 @@ static int rt2x00pci_alloc_reg(struct rt2x00_dev *rt2x00dev)
>  {
>  	struct pci_dev *pci_dev = to_pci_dev(rt2x00dev->dev);
>  
> -	rt2x00dev->csr.base = ioremap(pci_resource_start(pci_dev, 0),
> -				      pci_resource_len(pci_dev, 0));
> +	rt2x00dev->csr.base = ioremap_pcibar(pci_dev, 0);
>  	if (!rt2x00dev->csr.base)
>  		goto exit;
>  
> diff --git a/drivers/pci/hotplug/cpcihp_zt5550.c b/drivers/pci/hotplug/cpcihp_zt5550.c
> index 41f6a8d..f7bc30a 100644
> --- a/drivers/pci/hotplug/cpcihp_zt5550.c
> +++ b/drivers/pci/hotplug/cpcihp_zt5550.c
> @@ -105,8 +105,7 @@ static int zt5550_hc_config(struct pci_dev *pdev)
>  		goto exit_disable_device;
>  	}
>  
> -	hc_registers =
> -	    ioremap(pci_resource_start(hc_dev, 1), pci_resource_len(hc_dev, 1));
> +	hc_registers = ioremap_pcibar(hc_dev, 1);
>  	if(!hc_registers) {
>  		err("cannot remap MMIO region %llx @ %llx",
>  			(unsigned long long)pci_resource_len(hc_dev, 1),
> diff --git a/drivers/pci/hotplug/cpqphp_core.c b/drivers/pci/hotplug/cpqphp_core.c
> index 54defec..342382b 100644
> --- a/drivers/pci/hotplug/cpqphp_core.c
> +++ b/drivers/pci/hotplug/cpqphp_core.c
> @@ -1102,8 +1102,7 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  		goto err_free_bus;
>  	}
>  
> -	ctrl->hpc_reg = ioremap(pci_resource_start(pdev, 0),
> -					pci_resource_len(pdev, 0));
> +	ctrl->hpc_reg = ioremap_pcibar(pdev, 0);
>  	if (!ctrl->hpc_reg) {
>  		err("cannot remap MMIO region %llx @ %llx\n",
>  		    (unsigned long long)pci_resource_len(pdev, 0),
> diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
> index 218777b..00c4e27 100644
> --- a/drivers/scsi/advansys.c
> +++ b/drivers/scsi/advansys.c
> @@ -13425,8 +13425,7 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
>  		}
>  
>  		boardp->asc_n_io_port = pci_resource_len(pdev, 1);
> -		boardp->ioremap_addr = ioremap(pci_resource_start(pdev, 1),
> -					       boardp->asc_n_io_port);
> +		boardp->ioremap_addr = ioremap_pcibar(pdev, 1);
>  		if (!boardp->ioremap_addr) {
>  			shost_printk(KERN_ERR, shost, "ioremap(%lx, %d) "
>  					"returned NULL\n",
> diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
> index f91f79c..e522cf6 100644
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
> @@ -235,7 +235,7 @@ static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
>  		uint32_t intmask_org;
>  		int i, j;
>  
> -		acb->pmuA = ioremap(pci_resource_start(pdev, 0), pci_resource_len(pdev, 0));
> +		acb->pmuA = ioremap_pcibar(pdev, 0);
>  		if (!acb->pmuA) {
>  			printk(KERN_NOTICE "arcmsr%d: memory mapping region fail \n",
>  							acb->host->host_no);
> @@ -329,13 +329,11 @@ static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
>  		reg = (struct MessageUnit_B *)(dma_coherent +
>  		ARCMSR_MAX_FREECCB_NUM * sizeof(struct CommandControlBlock));
>  		acb->pmuB = reg;
> -		mem_base0 = ioremap(pci_resource_start(pdev, 0),
> -					pci_resource_len(pdev, 0));
> +		mem_base0 = ioremap_pcibar(pdev, 0);
>  		if (!mem_base0)
>  			goto out;
>  
> -		mem_base1 = ioremap(pci_resource_start(pdev, 2),
> -					pci_resource_len(pdev, 2));
> +		mem_base1 = ioremap_pcibar(pdev, 2);
>  		if (!mem_base1) {
>  			iounmap(mem_base0);
>  			goto out;
> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> index e7a3a65..5fc4eab 100644
> --- a/drivers/scsi/ipr.c
> +++ b/drivers/scsi/ipr.c
> @@ -7478,7 +7478,7 @@ static int __devinit ipr_probe_ioa(struct pci_dev *pdev,
>  		goto out_scsi_host_put;
>  	}
>  
> -	ipr_regs = ioremap(ipr_regs_pci, pci_resource_len(pdev, 0));
> +	ipr_regs = ioremap_pcibar(pdev, 0);
>  
>  	if (!ipr_regs) {
>  		dev_err(&pdev->dev,
> diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
> index 22052bb..520f9e0 100644
> --- a/drivers/scsi/nsp32.c
> +++ b/drivers/scsi/nsp32.c
> @@ -3401,8 +3401,7 @@ static int __devinit nsp32_probe(struct pci_dev *pdev, const struct pci_device_i
>  	data->IrqNumber   = pdev->irq;
>  	data->BaseAddress = pci_resource_start(pdev, 0);
>  	data->NumAddress  = pci_resource_len  (pdev, 0);
> -	data->MmioAddress = ioremap_nocache(pci_resource_start(pdev, 1),
> -					       pci_resource_len  (pdev, 1));
> +	data->MmioAddress = ioremap_pcibar(pdev, 1);
>  	data->MmioLength  = pci_resource_len  (pdev, 1);
>  
>  	pci_set_master(pdev);
> diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
> index 37f9ba0..219ad65 100644
> --- a/drivers/scsi/qla1280.c
> +++ b/drivers/scsi/qla1280.c
> @@ -4294,8 +4294,7 @@ qla1280_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
>  	error = -ENODEV;
>  
>  #if MEMORY_MAPPED_IO
> -	ha->mmpbase = ioremap(pci_resource_start(ha->pdev, 1),
> -			      pci_resource_len(ha->pdev, 1));
> +	ha->mmpbase = ioremap_pcibar(ha->pdev, 1);
>  	if (!ha->mmpbase) {
>  		printk(KERN_INFO "qla1280: Unable to map I/O memory\n");
>  		goto error_free_response_ring;
> diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
> index 3790906..0c0fed9 100644
> --- a/drivers/scsi/stex.c
> +++ b/drivers/scsi/stex.c
> @@ -1108,8 +1108,7 @@ stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  		goto out_scsi_host_put;
>  	}
>  
> -	hba->mmio_base = ioremap_nocache(pci_resource_start(pdev, 0),
> -		pci_resource_len(pdev, 0));
> +	hba->mmio_base = ioremap_pcibar(pdev, 0);
>  	if ( !hba->mmio_base) {
>  		printk(KERN_ERR DRV_NAME "(%s): memory map failed\n",
>  			pci_name(pdev));
> diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
> index c2f2393..dbcebd4 100644
> --- a/drivers/serial/8250_pci.c
> +++ b/drivers/serial/8250_pci.c
> @@ -339,8 +339,7 @@ static int sbs_init(struct pci_dev *dev)
>  {
>  	u8 __iomem *p;
>  
> -	p = ioremap_nocache(pci_resource_start(dev, 0),
> -						pci_resource_len(dev, 0));
> +	p = ioremap_pcibar(dev, 0);
>  
>  	if (p == NULL)
>  		return -ENOMEM;
> @@ -364,8 +363,7 @@ static void __devexit sbs_exit(struct pci_dev *dev)
>  {
>  	u8 __iomem *p;
>  
> -	p = ioremap_nocache(pci_resource_start(dev, 0),
> -					pci_resource_len(dev, 0));
> +	p = ioremap_pcibar(dev, 0);
>  	/* FIXME: What if resource_len < OCT_REG_CR_OFF */
>  	if (p != NULL)
>  		writeb(0, p + OCT_REG_CR_OFF);
> diff --git a/drivers/serial/icom.c b/drivers/serial/icom.c
> index 2b7531d..da19874 100644
> --- a/drivers/serial/icom.c
> +++ b/drivers/serial/icom.c
> @@ -1553,8 +1553,7 @@ static int __devinit icom_probe(struct pci_dev *dev,
>  		goto probe_exit1;
>  	}
>  
> -	 icom_adapter->base_addr = ioremap(icom_adapter->base_addr_pci,
> -						pci_resource_len(dev, 0));
> +	 icom_adapter->base_addr = ioremap_pcibar(dev, 0);
>  
>  	if (!icom_adapter->base_addr)
>  		goto probe_exit1;
> diff --git a/drivers/uio/uio_cif.c b/drivers/uio/uio_cif.c
> index 5737606..bc907b1 100644
> --- a/drivers/uio/uio_cif.c
> +++ b/drivers/uio/uio_cif.c
> @@ -57,8 +57,7 @@ static int __devinit hilscher_pci_probe(struct pci_dev *dev,
>  	info->mem[0].addr = pci_resource_start(dev, 0);
>  	if (!info->mem[0].addr)
>  		goto out_release;
> -	info->mem[0].internal_addr = ioremap(pci_resource_start(dev, 0),
> -					     pci_resource_len(dev, 0));
> +	info->mem[0].internal_addr = ioremap_pcibar(dev, 0);
>  	if (!info->mem[0].internal_addr)
>  		goto out_release;
>  
> diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
> index ae6e70e..b342669 100644
> --- a/drivers/usb/host/pci-quirks.c
> +++ b/drivers/usb/host/pci-quirks.c
> @@ -14,6 +14,7 @@
>  #include <linux/init.h>
>  #include <linux/delay.h>
>  #include <linux/acpi.h>
> +#include <linux/io.h>
>  #include "pci-quirks.h"
>  
>  
> @@ -172,9 +173,9 @@ static void __devinit quirk_usb_handoff_ohci(struct pci_dev *pdev)
>  	if (!mmio_resource_enabled(pdev, 0))
>  		return;
>  
> -	base = ioremap_nocache(pci_resource_start(pdev, 0),
> -				     pci_resource_len(pdev, 0));
> -	if (base == NULL) return;
> +	base = ioremap_pcibar(pdev, 0);
> +	if (base == NULL)
> +		return;
>  
>  /* On PA-RISC, PDC can leave IR set incorrectly; ignore it there. */
>  #ifndef __hppa__
> @@ -221,9 +222,9 @@ static void __devinit quirk_usb_disable_ehci(struct pci_dev *pdev)
>  	if (!mmio_resource_enabled(pdev, 0))
>  		return;
>  
> -	base = ioremap_nocache(pci_resource_start(pdev, 0),
> -				pci_resource_len(pdev, 0));
> -	if (base == NULL) return;
> +	base = ioremap_pcibar(pdev, 0);
> +	if (base == NULL)
> +		return;
>  
>  	cap_length = readb(base);
>  	op_reg_base = base + cap_length;
> diff --git a/drivers/video/aty/aty128fb.c b/drivers/video/aty/aty128fb.c
> index 243ea4a..0a8cafe 100644
> --- a/drivers/video/aty/aty128fb.c
> +++ b/drivers/video/aty/aty128fb.c
> @@ -2051,7 +2051,7 @@ static int __devinit aty128_probe(struct pci_dev *pdev, const struct pci_device_
>  
>  	/* Virtualize mmio region */
>  	info->fix.mmio_start = reg_addr;
> -	par->regbase = ioremap(reg_addr, pci_resource_len(pdev, 2));
> +	par->regbase = ioremap_pcibar(pdev, 2);
>  	if (!par->regbase)
>  		goto err_free_info;
>  
> diff --git a/drivers/video/cyber2000fb.c b/drivers/video/cyber2000fb.c
> index 41d6263..887ec8b 100644
> --- a/drivers/video/cyber2000fb.c
> +++ b/drivers/video/cyber2000fb.c
> @@ -1583,8 +1583,7 @@ cyberpro_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
>  		goto failed_release;
>  
>  	cfb->dev = dev;
> -	cfb->region = ioremap(pci_resource_start(dev, 0),
> -			      pci_resource_len(dev, 0));
> +	cfb->region = ioremap_pcibar(dev, 0);
>  	if (!cfb->region)
>  		goto failed_ioremap;
>  
> diff --git a/drivers/video/geode/gx1fb_core.c b/drivers/video/geode/gx1fb_core.c
> index bb20a22..32cd9d7 100644
> --- a/drivers/video/geode/gx1fb_core.c
> +++ b/drivers/video/geode/gx1fb_core.c
> @@ -217,8 +217,7 @@ static int __init gx1fb_map_video_memory(struct fb_info *info, struct pci_dev *d
>  	ret = pci_request_region(dev, 0, "gx1fb (video)");
>  	if (ret < 0)
>  		return ret;
> -	par->vid_regs = ioremap(pci_resource_start(dev, 0),
> -				pci_resource_len(dev, 0));
> +	par->vid_regs = ioremap_pcibar(dev, 0);
>  	if (!par->vid_regs)
>  		return -ENOMEM;
>  
> diff --git a/drivers/video/geode/gxfb_core.c b/drivers/video/geode/gxfb_core.c
> index de2b8f9..bab8c8f 100644
> --- a/drivers/video/geode/gxfb_core.c
> +++ b/drivers/video/geode/gxfb_core.c
> @@ -242,23 +242,21 @@ static int __init gxfb_map_video_memory(struct fb_info *info, struct pci_dev *de
>  	ret = pci_request_region(dev, 3, "gxfb (video processor)");
>  	if (ret < 0)
>  		return ret;
> -	par->vid_regs = ioremap(pci_resource_start(dev, 3),
> -				pci_resource_len(dev, 3));
> +	par->vid_regs = ioremap_pcibar(dev, 3);
>  	if (!par->vid_regs)
>  		return -ENOMEM;
>  
>  	ret = pci_request_region(dev, 2, "gxfb (display controller)");
>  	if (ret < 0)
>  		return ret;
> -	par->dc_regs = ioremap(pci_resource_start(dev, 2), pci_resource_len(dev, 2));
> +	par->dc_regs = ioremap_pcibar(dev, 2);
>  	if (!par->dc_regs)
>  		return -ENOMEM;
>  
>  	ret = pci_request_region(dev, 1, "gxfb (graphics processor)");
>  	if (ret < 0)
>  		return ret;
> -	par->gp_regs = ioremap(pci_resource_start(dev, 1),
> -	pci_resource_len(dev, 1));
> +	par->gp_regs = ioremap_pcibar(dev, 1);
>  
>  	if (!par->gp_regs)
>  		return -ENOMEM;
> diff --git a/drivers/video/geode/lxfb_core.c b/drivers/video/geode/lxfb_core.c
> index 2cd9b74..9027542 100644
> --- a/drivers/video/geode/lxfb_core.c
> +++ b/drivers/video/geode/lxfb_core.c
> @@ -379,20 +379,17 @@ static int __init lxfb_map_video_memory(struct fb_info *info,
>  	if (info->screen_base == NULL)
>  		return ret;
>  
> -	par->gp_regs = ioremap(pci_resource_start(dev, 1),
> -				pci_resource_len(dev, 1));
> +	par->gp_regs = ioremap_pcibar(dev, 1);
>  
>  	if (par->gp_regs == NULL)
>  		return ret;
>  
> -	par->dc_regs = ioremap(pci_resource_start(dev, 2),
> -			       pci_resource_len(dev, 2));
> +	par->dc_regs = ioremap_pcibar(dev, 2);
>  
>  	if (par->dc_regs == NULL)
>  		return ret;
>  
> -	par->vp_regs = ioremap(pci_resource_start(dev, 3),
> -			       pci_resource_len(dev, 3));
> +	par->vp_regs = ioremap_pcibar(dev, 3);
>  
>  	if (par->vp_regs == NULL)
>  		return ret;
> diff --git a/drivers/video/gxt4500.c b/drivers/video/gxt4500.c
> index 5645577..78ca660 100644
> --- a/drivers/video/gxt4500.c
> +++ b/drivers/video/gxt4500.c
> @@ -648,7 +648,7 @@ static int __devinit gxt4500_probe(struct pci_dev *pdev,
>  	info->pseudo_palette = par->pseudo_palette;
>  
>  	info->fix.mmio_start = reg_phys;
> -	par->regs = ioremap(reg_phys, pci_resource_len(pdev, 0));
> +	par->regs = ioremap_pcibar(pdev, 0);
>  	if (!par->regs) {
>  		dev_err(&pdev->dev, "gxt4500: cannot map registers\n");
>  		goto err_free_all;
> @@ -656,7 +656,7 @@ static int __devinit gxt4500_probe(struct pci_dev *pdev,
>  
>  	info->fix.smem_start = fb_phys;
>  	info->fix.smem_len = pci_resource_len(pdev, 1);
> -	info->screen_base = ioremap(fb_phys, pci_resource_len(pdev, 1));
> +	info->screen_base = ioremap_pcibar(pdev, 1);
>  	if (!info->screen_base) {
>  		dev_err(&pdev->dev, "gxt4500: cannot map framebuffer\n");
>  		goto err_unmap_regs;
> diff --git a/drivers/watchdog/i6300esb.c b/drivers/watchdog/i6300esb.c
> index c13383f..680e982 100644
> --- a/drivers/watchdog/i6300esb.c
> +++ b/drivers/watchdog/i6300esb.c
> @@ -394,8 +394,7 @@ static unsigned char __init esb_getdevice(void)
>  			goto err_disable;
>  		}
>  
> -		BASEADDR = ioremap(pci_resource_start(esb_pci, 0),
> -				   pci_resource_len(esb_pci, 0));
> +		BASEADDR = ioremap_pcibar(esb_pci, 0);
>  		if (BASEADDR == NULL) {
>  			/* Something's wrong here, BASEADDR has to be set */
>  			printk(KERN_ERR PFX "failed to get BASEADDR\n");
> -- 
> 1.5.5.1
> 
> 
> 
> -- 
> Arjan van de Ven 	Intel Open Source Technology Centre
> For development, discussion and tips for power savings, 
> visit http://www.lesswatts.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbYLGO3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbYLGO3k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 09:29:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbYLGO32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 09:29:28 -0500
Received: from ik-out-1112.google.com ([66.249.90.181]:16758 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbYLGO30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 09:29:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=hqcYbilu7QB78zyE+a7ZA5YvconAbag/NXN3BMg+Qqw9N6bEP/zkIpQrZgi7U1HGD9
         5tV+gknJtOwgEw9kLViLXQwgghHk6Z0QYiWV3IOC60psbFm2GadyZvjs20N9qvENeo/f
         ctKXz972BRe2yeuHxHfRig6ZNzXMCesIPHK5g=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: benh@kernel.crashing.org
Subject: Re: linux-next: Tree for October 24 - powerpc - build failure with !CONFIG_BLK_DEV_IDEDMA_PMAC
Date: Sun, 7 Dec 2008 15:27:52 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rc6-next-20081128; KDE/4.1.3; i686; ; )
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
References: <20081024171932.1e8131d0.sfr@canb.auug.org.au> <1224889818.7654.466.camel@pasglop> <200810251519.57543.bzolnier@gmail.com>
In-Reply-To: <200810251519.57543.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812071527.52886.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id mB7ETjdq031752

On Saturday 25 October 2008, Bartlomiej Zolnierkiewicz wrote:> On Saturday 25 October 2008, Benjamin Herrenschmidt wrote:> > On Sat, 2008-10-25 at 02:39 +0400, Sergei Shtylyov wrote:> > > >>    Hm, looks like this configuration was never buildable --> > > #ifdef's are > > > >> missing and wrongly placed. CCing Ben Herrenschmidt...> > > >>     > > > >> > > > What configuration ?> > > >   > > > > > >    See the subject.> > > > Ah ok. We should probably just remove the option...> > Fine with me.  Anybody want an easy +1 patch-point? :)
Seems like ppc people are either very busy or don't care...  Oh well...
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>Subject: [PATCH] ide: build-fix for CONFIG_BLK_DEV_IDEDMA_PMAC=n
IDE pmac host driver build fails with CONFIG_BLK_DEV_IDEDMA_PMAC=nas reported by Kamalesh:
> drivers/ide/pmac.c: In function 'pmac_ide_set_pio_mode':> drivers/ide/pmac.c:527: error: implicit declaration of function 'kauai_lookup_timing'> drivers/ide/pmac.c:527: error: 'shasta_pio_timings' undeclared (first use in this function)> drivers/ide/pmac.c:527: error: (Each undeclared identifier is reported only once> drivers/ide/pmac.c:527: error: for each function it appears in.)> drivers/ide/pmac.c:534: error: 'kauai_pio_timings' undeclared (first use in this function)> drivers/ide/pmac.c: In function 'pmac_ide_do_resume':> drivers/ide/pmac.c:914: error: 'IDE_WAKEUP_DELAY' undeclared (first use in this function)> drivers/ide/pmac.c: At top level:> drivers/ide/pmac.c:1007: error: 'pmac_ide_init_dma' undeclared here (not in a function)> drivers/ide/pmac.c: In function 'pmac_ide_setup_device':> drivers/ide/pmac.c:1107: error: 'IDE_WAKEUP_DELAY' undeclared (first use in this function)> drivers/ide/pmac.c: In function 'pmac_ide_macio_attach':> drivers/ide/pmac.c:1209: error: 'pmac_ide_hwif_t' has no member named 'dma_regs'> drivers/ide/pmac.c:1210: error: 'pmac_ide_hwif_t' has no member named 'dma_regs'> make[2]: *** [drivers/ide/pmac.o] Error 1
Fix it by removing the superfluous config option.
Reported-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>Cc: Stephen Rothwell <sfr@canb.auug.org.au>Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>--- drivers/ide/Kconfig |   14 +++----------- drivers/ide/pmac.c  |   30 +++--------------------------- 2 files changed, 6 insertions(+), 38 deletions(-)
Index: b/drivers/ide/Kconfig===================================================================--- a/drivers/ide/Kconfig+++ b/drivers/ide/Kconfig@@ -655,10 +655,12 @@ config BLK_DEV_CELLEB  endif +# TODO: BLK_DEV_IDEDMA_PCI -> BLK_DEV_IDEDMA_SFF config BLK_DEV_IDE_PMAC 	tristate "PowerMac on-board IDE support" 	depends on PPC_PMAC && IDE=y 	select IDE_TIMINGS+	select BLK_DEV_IDEDMA_PCI 	help 	  This driver provides support for the on-board IDE controller on 	  most of the recent Apple Power Macintoshes and PowerBooks.@@ -675,16 +677,6 @@ config BLK_DEV_IDE_PMAC_ATA100FIRST 	  CD-ROM on hda. This option changes this to more natural hda for 	  hard disk and hdc for CD-ROM. -config BLK_DEV_IDEDMA_PMAC-	bool "PowerMac IDE DMA support"-	depends on BLK_DEV_IDE_PMAC-	select BLK_DEV_IDEDMA_PCI-	help-	  This option allows the driver for the on-board IDE controller on-	  Power Macintoshes and PowerBooks to use DMA (direct memory access)-	  to transfer data to and from memory.  Saying Y is safe and improves-	  performance.- config BLK_DEV_IDE_AU1XXX        bool "IDE for AMD Alchemy Au1200"        depends on SOC_AU1200@@ -903,7 +895,7 @@ config BLK_DEV_UMC8672 endif  config BLK_DEV_IDEDMA-	def_bool BLK_DEV_IDEDMA_SFF || BLK_DEV_IDEDMA_PMAC || \+	def_bool BLK_DEV_IDEDMA_SFF || \ 		 BLK_DEV_IDEDMA_ICS || BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA  endif # IDEIndex: b/drivers/ide/pmac.c===================================================================--- a/drivers/ide/pmac.c+++ b/drivers/ide/pmac.c@@ -66,7 +66,6 @@ typedef struct pmac_ide_hwif { 	struct macio_dev		*mdev; 	u32				timings[4]; 	volatile u32 __iomem *		*kauai_fcr;-#ifdef CONFIG_BLK_DEV_IDEDMA_PMAC 	/* Those fields are duplicating what is in hwif. We currently 	 * can't use the hwif ones because of some assumptions that are 	 * beeing done by the generic code about the kind of dma controller@@ -74,8 +73,6 @@ typedef struct pmac_ide_hwif { 	 */ 	volatile struct dbdma_regs __iomem *	dma_regs; 	struct dbdma_cmd*		dma_table_cpu;-#endif-	 } pmac_ide_hwif_t;  enum {@@ -222,8 +219,6 @@ static const char* model_name[] = { #define KAUAI_FCR_UATA_RESET_N		0x00000002 #define KAUAI_FCR_UATA_ENABLE		0x00000001 -#ifdef CONFIG_BLK_DEV_IDEDMA_PMAC- /* Rounded Multiword DMA timings  *   * I gave up finding a generic formula for all controller@@ -413,8 +408,6 @@ static int pmac_ide_build_dmatable(ide_d static void pmac_ide_selectproc(ide_drive_t *drive); static void pmac_ide_kauai_selectproc(ide_drive_t *drive); -#endif /* CONFIG_BLK_DEV_IDEDMA_PMAC */- #define PMAC_IDE_REG(x) \ 	((void __iomem *)((drive)->hwif->io_ports.data_addr + (x))) @@ -584,8 +577,6 @@ pmac_ide_set_pio_mode(ide_drive_t *drive 	pmac_ide_do_update_timings(drive); } -#ifdef CONFIG_BLK_DEV_IDEDMA_PMAC- /*  * Calculate KeyLargo ATA/66 UDMA timings  */@@ -786,7 +777,6 @@ set_timings_mdma(ide_drive_t *drive, int 		drive->name, speed & 0xf,  *timings); #endif	 }-#endif /* #ifdef CONFIG_BLK_DEV_IDEDMA_PMAC */  static void pmac_ide_set_dma_mode(ide_drive_t *drive, const u8 speed) {@@ -804,7 +794,6 @@ static void pmac_ide_set_dma_mode(ide_dr 	tl[0] = *timings; 	tl[1] = *timings2; -#ifdef CONFIG_BLK_DEV_IDEDMA_PMAC 	if (speed >= XFER_UDMA_0) { 		if (pmif->kind == controller_kl_ata4) 			ret = set_timings_udma_ata4(&tl[0], speed);@@ -817,7 +806,7 @@ static void pmac_ide_set_dma_mode(ide_dr 			ret = -1; 	} else 		set_timings_mdma(drive, pmif->kind, &tl[0], &tl[1], speed);-#endif /* CONFIG_BLK_DEV_IDEDMA_PMAC */+ 	if (ret) 		return; @@ -1008,9 +997,7 @@ static const struct ide_port_info pmac_p 	.chipset		= ide_pmac, 	.tp_ops			= &pmac_tp_ops, 	.port_ops		= &pmac_ide_port_ops,-#ifdef CONFIG_BLK_DEV_IDEDMA_PMAC 	.dma_ops		= &pmac_dma_ops,-#endif 	.host_flags		= IDE_HFLAG_SET_PIO_MODE_KEEP_DMA | 				  IDE_HFLAG_POST_SET_MODE | 				  IDE_HFLAG_MMIO |@@ -1182,7 +1169,7 @@ pmac_ide_macio_attach(struct macio_dev * 	pmif->regbase = regbase; 	pmif->irq = irq; 	pmif->kauai_fcr = NULL;-#ifdef CONFIG_BLK_DEV_IDEDMA_PMAC+ 	if (macio_resource_count(mdev) >= 2) { 		if (macio_request_resource(mdev, 1, "ide-pmac (dma)")) 			printk(KERN_WARNING "ide-pmac: can't request DMA "@@ -1192,7 +1179,7 @@ pmac_ide_macio_attach(struct macio_dev * 			pmif->dma_regs = ioremap(macio_resource_start(mdev, 1), 0x1000); 	} else 		pmif->dma_regs = NULL;-#endif /* CONFIG_BLK_DEV_IDEDMA_PMAC */+ 	dev_set_drvdata(&mdev->ofdev.dev, pmif);  	memset(&hw, 0, sizeof(hw));@@ -1300,9 +1287,7 @@ pmac_ide_pci_attach(struct pci_dev *pdev  	base = ioremap(rbase, rlen); 	pmif->regbase = (unsigned long) base + 0x2000;-#ifdef CONFIG_BLK_DEV_IDEDMA_PMAC 	pmif->dma_regs = base + 0x1000;-#endif /* CONFIG_BLK_DEV_IDEDMA_PMAC */ 	pmif->kauai_fcr = base; 	pmif->irq = pdev->irq; @@ -1434,8 +1419,6 @@ out: 	return error; } -#ifdef CONFIG_BLK_DEV_IDEDMA_PMAC- /*  * pmac_ide_build_dmatable builds the DBDMA command list  * for a transfer and sets the DBDMA channel to point to it.@@ -1723,13 +1706,6 @@ static int __devinit pmac_ide_init_dma(i  	return 0; }-#else-static int __devinit pmac_ide_init_dma(ide_hwif_t *hwif,-				       const struct ide_port_info *d)-{-	return -EOPNOTSUPP;-}-#endif /* CONFIG_BLK_DEV_IDEDMA_PMAC */  module_init(pmac_ide_probe);  ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

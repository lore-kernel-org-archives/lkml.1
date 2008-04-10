Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbYDJTBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbYDJTBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 15:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbYDJTBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 15:01:13 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:65422 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbYDJTBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 15:01:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=BCjgKb0cp6Yqu3Jd2zeOvNGLyOJS8NfIAisyPQ+pu1Uv34wlfXwWLZtI2Z1YVD3ei4Z79i9zwLtCDvxoLpHSMBaT5nrzKiNgeDteApwBqkb1pFJi/DJCal0UJwBJ164fKAUFTlqDRk17lezg3BdhFurK5ybX9+jQPe9sxBLhEn8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: [BUG] linux-next: Tree for April 10 - kernel panic while loading ata driver on powermac
Date: Thu, 10 Apr 2008 21:16:28 +0200
User-Agent: KMail/1.9.9
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080410181404.b76939a6.sfr@canb.auug.org.au> <200804101914.04254.bzolnier@gmail.com> <47FE5B96.9090207@linux.vnet.ibm.com>
In-Reply-To: <47FE5B96.9090207@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804102116.28637.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 April 2008, Kamalesh Babulal wrote:
> Bartlomiej Zolnierkiewicz wrote:
> > On Thursday 10 April 2008, Bartlomiej Zolnierkiewicz wrote:
> >> Hi,
> >>
> >> On Thu, Apr 10, 2008 at 12:24 PM, Kamalesh Babulal
> >> <kamalesh@linux.vnet.ibm.com> wrote:
> >>> Hi Stephen,
> >>>
> >>>  The next-20080410 kernel panics while bootup over the PowerMac G5 box, while
> >>>  loading the ATA driver.
> >>>
> >>>  [    3.704000] Faulting instruction address: 0xc0000000000222a8
> >>>  [    3.704000] Oops: Kernel access of bad area, sig: 11 [#1]
> >>>  [    3.704000] SMP NR_CPUS=32 NUMA PowerMac
> >>>  [    3.704000] Modules linked in:
> >>>  [    3.704000] NIP: c0000000000222a8 LR: c00000000021cd10 CTR: 0000000000000100
> >>>  [    3.704000] REGS: c0000002760db070 TRAP: 0300   Not tainted  (2.6.25-rc8-next-20080410-autokern1)
> >>>  [    3.704000] MSR: 9000000000009032 <EE,ME,IR,DR>  CR: 44000042  XER: 20000000
> >>>  [    3.704000] DAR: a0001000822fa000, DSISR: 0000000040000000
> >>>  [    3.704000] TASK = c0000002760d7100[1] 'swapper' THREAD: c0000002760d8000 CPU: 0
> >>>  [    3.704000] GPR00: 0000000000000100 c0000002760db2f0 c000000000498310 a0001000822fa000
> >>>  [    3.704000] GPR04: c000000274806a00 0000000000000100 0000000000000201 c00000000000fed4
> >>>  [    3.704000] GPR08: c0000002760daf20 c0000000003ee0d8 c0000000004f1428 0000000000000000
> >>>  [    3.704000] GPR12: 0000000000000000 c0000000003fa700 0000000000000000 0000000000000000
> >>>  [    3.704000] GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
> >>>  [    3.704000] GPR20: 0000000000000001 0000000000000027 0000000000000027 0000000000000000
> >>>  [    3.704000] GPR24: c0000000004f1400 0000000000000000 0000000000000201 c0000000004f1490
> >>>  [    3.704000] GPR28: a0001000822fa000 0000000000000200 c00000000044cf50 c000000274806a00
> >>>  [    3.704000] NIP [c0000000000222a8] ._insw_ns+0x10/0x30
> >>>  [    3.704000] LR [c00000000021cd10] .ata_input_data+0x1f4/0x264
> >> Could you please add printk() for 'hwif->host_flags', 'mmio' and 'io_32bit'
> >> to ide-iops.c::ata_input_data() so we know more on what is going on?
> > 
> > No longer needed - please test the hot-fix below instead:
> > 
> > ---
> > thanks to Andrew for noticing me about the gcc warning
> > 
> >  drivers/ide/ppc/pmac.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Index: b/drivers/ide/ppc/pmac.c
> > ===================================================================
> > --- a/drivers/ide/ppc/pmac.c
> > +++ b/drivers/ide/ppc/pmac.c
> > @@ -941,7 +941,7 @@ static const struct ide_port_info pmac_p
> >  	.port_ops		= &pmac_ide_port_ops,
> >  	.host_flags		= IDE_HFLAG_SET_PIO_MODE_KEEP_DMA |
> >  				  IDE_HFLAG_POST_SET_MODE |
> > -				  IDE_HFLAG_UNMASK_IRQS,
> > +				  IDE_HFLAG_UNMASK_IRQS |
> >  				  IDE_HFLAG_MMIO,
> >  	.pio_mask		= ATA_PIO4,
> >  	.mwdma_mask		= ATA_MWDMA2,
> > 
> > --
> Thanks, the kernel panic is solved after applying the patch.
> 
> Tested-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

Thanks.

I integrated the fix with the guilty patch and pushed it to IDE tree
(Andrew, you may drop the revert-patch now).

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: add IDE_HFLAG_MMIO host flag (take 2)

* Add IDE_HFLAG_MMIO host flag and set it for hosts which use
  default_hwif_mmiops().

v2:
* Fix kernel panic in pmac host driver (',' should be '|').

  Thanks to Kamalesh for reporting it + testing the fix
  and to Andrew for hinting me about the source of the issue.

Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/icside.c          |    2 +-
 drivers/ide/arm/palm_bk3710.c     |    1 +
 drivers/ide/arm/rapide.c          |    1 +
 drivers/ide/legacy/ide_platform.c |    4 +++-
 drivers/ide/mips/swarm.c          |    1 +
 drivers/ide/pci/sgiioc4.c         |    1 +
 drivers/ide/pci/siimage.c         |    1 +
 drivers/ide/ppc/pmac.c            |    1 +
 include/linux/ide.h               |    2 ++
 9 files changed, 12 insertions(+), 2 deletions(-)

Index: b/drivers/ide/arm/icside.c
===================================================================
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -481,7 +481,7 @@ static const struct ide_port_info icside
 	.init_dma		= icside_dma_off_init,
 	.port_ops		= &icside_v6_no_dma_port_ops,
 	.dma_ops		= &icside_v6_dma_ops,
-	.host_flags		= IDE_HFLAG_SERIALIZE,
+	.host_flags		= IDE_HFLAG_SERIALIZE | IDE_HFLAG_MMIO,
 	.mwdma_mask		= ATA_MWDMA2,
 	.swdma_mask		= ATA_SWDMA2,
 };
Index: b/drivers/ide/arm/palm_bk3710.c
===================================================================
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -342,6 +342,7 @@ static const struct ide_port_ops palm_bk
 static const struct ide_port_info __devinitdata palm_bk3710_port_info = {
 	.init_dma		= palm_bk3710_init_dma,
 	.port_ops		= &palm_bk3710_ports_ops,
+	.host_flags		= IDE_HFLAG_MMIO,
 	.pio_mask		= ATA_PIO4,
 	.udma_mask		= ATA_UDMA4,	/* (input clk 99MHz) */
 	.mwdma_mask		= ATA_MWDMA2,
Index: b/drivers/ide/arm/rapide.c
===================================================================
--- a/drivers/ide/arm/rapide.c
+++ b/drivers/ide/arm/rapide.c
@@ -53,6 +53,7 @@ rapide_probe(struct expansion_card *ec, 
 
 		ide_init_port_hw(hwif, &hw);
 
+		hwif->host_flags = IDE_HFLAG_MMIO;
 		default_hwif_mmiops(hwif);
 
 		idx[0] = hwif->index;
Index: b/drivers/ide/legacy/ide_platform.c
===================================================================
--- a/drivers/ide/legacy/ide_platform.c
+++ b/drivers/ide/legacy/ide_platform.c
@@ -101,8 +101,10 @@ static int __devinit plat_ide_probe(stru
 
 	ide_init_port_hw(hwif, &hw);
 
-	if (mmio)
+	if (mmio) {
+		hwif->host_flags = IDE_HFLAG_MMIO;
 		default_hwif_mmiops(hwif);
+	}
 
 	idx[0] = hwif->index;
 
Index: b/drivers/ide/mips/swarm.c
===================================================================
--- a/drivers/ide/mips/swarm.c
+++ b/drivers/ide/mips/swarm.c
@@ -109,6 +109,7 @@ static int __devinit swarm_ide_probe(str
 	base = ioremap(offset, size);
 
 	/* Setup MMIO ops.  */
+	hwif->host_flags = IDE_HFLAG_MMIO;
 	default_hwif_mmiops(hwif);
 
 	hwif->chipset = ide_generic;
Index: b/drivers/ide/pci/sgiioc4.c
===================================================================
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -573,6 +573,7 @@ static const struct ide_port_info sgiioc
 	.init_dma		= ide_dma_sgiioc4,
 	.port_ops		= &sgiioc4_port_ops,
 	.dma_ops		= &sgiioc4_dma_ops,
+	.host_flags		= IDE_HFLAG_MMIO,
 	.mwdma_mask		= ATA_MWDMA2_ONLY,
 };
 
Index: b/drivers/ide/pci/siimage.c
===================================================================
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -630,6 +630,7 @@ static void __devinit init_mmio_iops_sii
 	 *	Fill in the basic HWIF bits
 	 */
 
+	hwif->host_flags |= IDE_HFLAG_MMIO;
 	default_hwif_mmiops(hwif);
 	hwif->hwif_data			= addr;
 
Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -941,6 +941,7 @@ static const struct ide_port_info pmac_p
 	.port_ops		= &pmac_ide_port_ops,
 	.host_flags		= IDE_HFLAG_SET_PIO_MODE_KEEP_DMA |
 				  IDE_HFLAG_POST_SET_MODE |
+				  IDE_HFLAG_MMIO |
 				  IDE_HFLAG_UNMASK_IRQS,
 	.pio_mask		= ATA_PIO4,
 	.mwdma_mask		= ATA_MWDMA2,
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1056,6 +1056,8 @@ enum {
 	IDE_HFLAG_NO_DMA		= (1 << 14),
 	/* check if host is PCI IDE device before allowing DMA */
 	IDE_HFLAG_NO_AUTODMA		= (1 << 15),
+	/* host uses MMIO */
+	IDE_HFLAG_MMIO			= (1 << 16),
 	/* host is CS5510/CS5520 */
 	IDE_HFLAG_CS5520		= IDE_HFLAG_VDMA,
 	/* no LBA48 */

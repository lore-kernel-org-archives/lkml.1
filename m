Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbYGUTKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbYGUTKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 15:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445AbYGUTJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 15:09:38 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:36406 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360AbYGUTJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 15:09:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=es3N6io7KgqoDNRiWISyS/8fl8jkSLCfhxAPrrYd3uzI8613Tt/beCc8MLr+r4VADt
         PNgbIkfWNBL48AWELHXjh8wneqA4BulvavQ97yGxJ+RshagHoAQbU7R4NtX4NdAdQiQ0
         PNhzG4eg2BWqMBh0Dmbovd3cYIUaOG4rMMJWg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH] ide-floppy fix
Date: Mon, 21 Jul 2008 21:03:36 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, stable@kernel.org
References: <20080715053356.GA18628@gollum.tnic> <200807161956.46981.bzolnier@gmail.com> <20080720120629.GA16529@gollum.tnic>
In-Reply-To: <20080720120629.GA16529@gollum.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807212103.36804.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 July 2008, Borislav Petkov wrote:
> Hi Bart,
> 
> On Wed, Jul 16, 2008 at 07:56:46PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Wednesday 16 July 2008, Borislav Petkov wrote:
> > > On Tue, Jul 15, 2008 at 10:58:48PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > > > On Tuesday 15 July 2008, Borislav Petkov wrote:
> > > > > On Wed, Jul 16, 2008 at 05:59:16PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > > > > > 
> > > > > > Hi,
> > > > > > 
> > > > > > On Tuesday 15 July 2008, Borislav Petkov wrote:
> > > > > > 
> > > > > > [...]
> > > > > > 
> > > > > > > On a different note, the current pata tree on top of v2.6.25-2125-g50515af blows
> > > > > > > up here with the following error:
> > > > > > > 
> > > > > > > [    4.296729] Uniform Multi-Platform E-IDE driver
> > > > > > > [    4.297905] ICH4: IDE controller (0x8086:0x24cb rev 0x02) at  PCI slot 0000:00:1f.1
> > > > > > > [    4.297986] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
> > > > > > > [    4.298153] ICH4: not 100% native mode: will probe irqs later
> > > > > > > [    4.298213]     ide0: BM-DMA at 0xfc00-0xfc07
> > > > > > > [    4.298282]     ide1: BM-DMA at 0xfc08-0xfc0f
> > > > > > > [    4.561768] hda: QUANTUM FIREBALLlct10 20, ATA DISK drive
> > > > > > > [    4.816724] hdb: SAMSUNG SP2014N, ATA DISK drive
> > > > > > > [    4.867959] hda: drive side 80-wire cable detection failed, limiting max speed to UDMA33
> > > > > > > [    4.868027] hda: UDMA/33 mode selected
> > > > > > > [    4.868441] hdb: UDMA/100 mode selected
> > > > > > > [    5.540683] hdc: IOMEGA ZIP 100 ATAPI, ATAPI FLOPPY drive
> > > > > > > [    5.795564] hdd: IC35L120AVV207-0, ATA DISK drive
> > > > > > > [    5.847295] hdd: host side 80-wire cable detection failed, limiting max speed to UDMA33
> > > > > > > [    5.847362] hdd: UDMA/33 mode selected
> > > > > > > [    5.847715] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> > > > > > > [    5.855487] ide1 at 0x170-0x177,0x376 on irq 15
> > > > > > > [    5.875927] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
> > > > > > > [    5.876012] ide_generic: I/O resource 0x1F0-0x1F7 not free.
> > > > > > > [    5.876074] ide_generic: I/O resource 0x170-0x177 not free.
> > > > > > > [   11.342504] hde: no response (status = 0xa1), resetting drive
> > > > > > > [   17.206535] hdf: no response (status = 0xa1), resetting drive
> > > > > > 
> > > > > > hde? hdf?
> > > > > > 
> > > > > > [...]
> > > > > 
> > > > > yep, looks strange to me too. Isn't that the MAX_HWIFS upper bound of a loop.. ?
> > > > 
> > > > Close, it is related to MAX_HWIFS being upper bound on hws[]
> > > > in ide_generic.c but now we loop for ARRAY_SIZE(legacy_bases).
> > > > 
> > > > IOW there is a memset(hws, 0, MAX_HWIFS) missing at the top of
> > > > ide_generic_init() (please re-test after adding it).
> > > > 
> > > > This may also explain the later problems with ide_host_register().
> > 
> > I fixed this in pata tree now with:
> > 
> > "ide-generic: remove ide_default_{io_base,irq}() inlines (take 2)" patch
> 
> here's the root cause for the problem: I had both Intel ICH chipset
> (BLK_DEV_PIIX) und generic ide (BLK_DEV_GENERIC) selected in Kconfig and since
> ICH4 uses the generic driver detection routine, the second(!) generic detection after the
> ICH4 one failed and died. This is why request_region()-resources are shown as
> not being free above:
> 
> > > > > > > [    5.875927] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
> > > > > > > [    5.876012] ide_generic: I/O resource 0x1F0-0x1F7 not free.
> > > > > > > [    5.876074] ide_generic: I/O resource 0x170-0x177 not free.

I also use BLK_DEV_PIIX + BLK_DEV_GENERIC configuration
(for testing purposes) and it works fine here.

[ Besides it shouldn't result in phantom hde & hdf devices
  and ide_generic blowing up on failure. ]

Have you tried the memset() fix that I proposed
(pata tree contains the revised patch now)?

> One of the possible fixes is adding
> 
> depends on !BLK_DEV_GENERIC
> 
> after each IDE chipset driver using the generic detection in drivers/ide/Kconfig
> but it's a not-that-elegant one. Another thing would be using a dummy one like
> BLK_DEV_IDEDMA_PCI, but I'm not that sure. Will look into it. I'm pretty sure
> you have a better idea...

pata_legacy.c has a proper fix which needs porting into ide-generic.c
(it should be pretty easy thing to do).

[ The fix is to skip automatic-probing of primary port and/or secondary
  one if a PCI controller using legacy I/O bases is detected:

	for_each_pci_dev(p) {
		int r;
		/* Check for any overlap of the system ATA mappings. Native
		   mode controllers stuck on these addresses or some devices
		   in 'raid' mode won't be found by the storage class test */
		for (r = 0; r < 6; r++) {
			if (pci_resource_start(p, r) == 0x1f0)
				primary = 1;
			if (pci_resource_start(p, r) == 0x170)
				secondary = 1;
		}
		/* Check for special cases */
		legacy_check_special_cases(p, &primary, &secondary); ]

Thanks,
Bart

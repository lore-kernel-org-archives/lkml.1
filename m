Return-Path: <linux-kernel-owner+w=401wt.eu-S1755452AbXLWR40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbXLWR40 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 12:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbXLWR4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 12:56:16 -0500
Received: from mx1.ukfsn.org ([77.75.108.10]:33752 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752387AbXLWR4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 12:56:15 -0500
X-Greylist: delayed 1512 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Dec 2007 12:56:15 EST
Date: Sun, 23 Dec 2007 17:30:55 +0000
From: Nick Warne <nick@ukfsn.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Mark Lord <lkml@rtr.ca>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Peculiar out-of-sync boot log lines
Message-ID: <20071223173055.5ffa711f@linuxamd.linicks.net>
In-Reply-To: <200712021930.34413.bzolnier@gmail.com>
References: <20071129193728.2f1c237e@linuxamd.linicks.net>
	<200712012259.35152.bzolnier@gmail.com>
	<20071201151419.39a169f1.randy.dunlap@oracle.com>
	<200712021930.34413.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Dec 2007 19:30:34 +0100
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

Hi Bart,

Top posting! grrrr.

This patch works fine on my system with this peculiar DVD drive, and
log reports are perfect.

Updated to Linus' git today - 2.6.24-rc6-g5b825ed2

/var/log/messages:

Dec 23 09:36:04 linuxamd kernel:     ide0: BM-DMA at 0xd000-0xd007, BIOS settings: hda:DMA, hdb:DMA
Dec 23 09:36:04 linuxamd kernel:     ide1: BM-DMA at 0xd008-0xd00f, BIOS settings: hdc:DMA, hdd:DMA
Dec 23 09:36:04 linuxamd kernel: hda: UDMA/66 mode selected
Dec 23 09:36:04 linuxamd kernel: hdb: UDMA/66 mode selected
Dec 23 09:36:04 linuxamd kernel: hdc: UDMA/66 mode selected
Dec 23 09:36:04 linuxamd kernel: hdd: UDMA/66 mode selected
Dec 23 09:36:04 linuxamd kernel: hda: max request size: 128KiB
Dec 23 09:36:04 linuxamd kernel: hda: 160086528 sectors (81964 MB) w/2048KiB Cache, CHS=65535/16/63
Dec 23 09:36:04 linuxamd kernel: hda: cache flushes supported
Dec 23 09:36:04 linuxamd kernel:  hda: hda1 hda2 hda3 hda4
Dec 23 09:36:04 linuxamd kernel: hdb: max request size: 128KiB
Dec 23 09:36:04 linuxamd kernel: hdb: 30015216 sectors (15367 MB) w/2048KiB Cache, CHS=29777/16/63
Dec 23 09:36:04 linuxamd kernel: hdb: cache flushes not supported
Dec 23 09:36:04 linuxamd kernel:  hdb: hdb1
Dec 23 09:36:04 linuxamd kernel: hdc: max request size: 128KiB
Dec 23 09:36:04 linuxamd kernel: hdc: 39876480 sectors (20416 MB) w/2048KiB Cache, CHS=39560/16/63
Dec 23 09:36:04 linuxamd kernel: hdc: cache flushes not supported
Dec 23 09:36:04 linuxamd kernel:  hdc: hdc1
Dec 23 09:36:04 linuxamd kernel: hdd: ATAPI 48X DVD-ROM DVD-R-RAM
CD-R/RW drive, 2048kB Cache

and

/var/log/syslog

Dec 23 09:36:04 linuxamd kernel: hdb: Maxtor 51536H2, ATA DISK drive
Dec 23 09:36:04 linuxamd kernel: hda: Maxtor 6Y080L0, ATA DISK drive
Dec 23 09:36:04 linuxamd kernel: hdd: TSSTcorp CDDVDW SH-S202J, ATAPI CD/DVD-ROM drive
Dec 23 09:36:04 linuxamd kernel: hdc: Maxtor 52049H3, ATA DISK drive


> On Sunday 02 December 2007, Randy Dunlap wrote:
> > On Sat, 1 Dec 2007 22:59:35 +0100 Bartlomiej Zolnierkiewicz wrote:
> > 
> > > Thanks for reporting/debugging it guys!
> > > 
> > > > Something in there needs to insert a '\n' before the "skipping
> > > > word" message. Since it doesn't do that right now, the
> > > > KERN_DEBUG string appears as "<7>"
> > > 
> > > This seems like a good occasion to fix ide_dma_verbose() for good
> > > so... :)
> > > 
> > > [ patch is against current Linus tree so might not apply to
> > > 2.6.23.9 ]
> > > 
> > > [PATCH] ide: DMA reporting and validity checking fixes
> > > 
> > > * ide_xfer_verbose() fixups:
> > >   - beautify returned mode names
> > >   - fix PIO5 reporting
> > >   - make it return 'const char *'
> > > 
> > > * Change printk() level from KERN_DEBUG to KERN_INFO in
> > > ide_find_dma_mode().
> > > 
> > > * Add ide_id_dma_bug() helper based on ide_dma_verbose() to check
> > > for invalid DMA info in identify block.
> > > 
> > > * Use ide_id_dma_bug() in ide_tune_dma() and ide_driveid_update().
> > > 
> > >   As a result DMA won't be tuned or will be disabled after tuning
> > > if device reports inconsistent info about enabled DMA mode
> > > (ide_dma_verbose() does the same checks while the IDE device is
> > > probed by ide-{cd,disk} device driver).
> > > 
> > > * Since (id->capability & 1) && id->tDMA is a valid configuration
> > > handle it correctly in ide_id_dma_bug().
> > > 
> > > * Remove no longer needed ide_dma_verbose().
> > > 
> > > This patch should fix the following problem with out-of-sync IDE
> > > messages reported by Nick Warned:
> > > 
> > >        hdd: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB
> > > Cache<7>hdd: skipping word 93 validity check
> > >         , UDMA(66)
> > > 
> > > and later debugged by Mark Lord to be caused by:
> > > 
> > >         ide_dma_verbose()
> > >                 printk( ... "2048kB Cache");
> > >         eighty_ninty_three()
> > >                 printk(KERN_DEBUG "%s: skipping word 93 validity
> > > check\n"); ide_dma_verbose()
> > >                 printk(", UDMA(66)"
> > > 
> > > Please note that as a result ide-{cd,disk} device drivers won't
> > > report the DMA speed used but this is intended since now DMA mode
> > > being used is always reported by IDE core code.
> > > 
> > > Cc: Nick Warne <nick@ukfsn.org>
> > > Cc: Mark Lord <lkml@rtr.ca>
> > > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

~ skip

Nick
-- 
Free Software Foundation Associate Member 5508

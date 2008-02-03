Return-Path: <linux-kernel-owner+w=401wt.eu-S1751405AbYBCSQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405AbYBCSQZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 13:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750740AbYBCSQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 13:16:14 -0500
Received: from keil-draco.com ([216.193.185.50]:50229 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbYBCSQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 13:16:13 -0500
From: Daniel Hazelton <dhazelton@enter.net>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [BUG] 2.6.24 refuses to boot - ATA problem?
Date: Sun, 3 Feb 2008 13:16:00 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Chris Rankin <rankincj@yahoo.com>, linux-kernel@vger.kernel.org
References: <643979.82914.qm@web52904.mail.re2.yahoo.com> <200802021938.12096.dhazelton@enter.net> <47A5FBA1.1090208@garzik.org>
In-Reply-To: <47A5FBA1.1090208@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802031316.01707.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 February 2008 12:36:33 Jeff Garzik wrote:
> Daniel Hazelton wrote:
> > On Saturday 02 February 2008 18:40:55 Chris Rankin wrote:
> >> Hi,
> >>
> >> I have tried to boot a 2.6.24 kernel on my 1 GHz Coppermine / 512 MB RAM
> >> PC. (This is without the nmi_watchdog=1 option.) However, the ATA layer
> >> is failing to initialise:
> >
> > <snip>
> >
> >> Driver 'sd' needs updating - please use bus_type methods
> >> scsi0 : ata_piix
> >> scsi1 : ata_piix
> >> ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xa800 irq 14
> >> ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xa808 irq 15
> >> ata1.00: ATA-4: ST320420A, 3.12, max UDMA/66
> >> ata1.00: 39851760 sectors, multi 16: LBA
> >> ata1.00: configured for UDMA/66
> >> ata2.00: ATAPI: Pioneer DVD-ROM ATAPIModel DVD-116  0122, E1.22, max
> >> UDMA/66 ata2.01: ATAPI: SONY    CD-RW  CRX145E, 1.0b, max UDMA/33
> >> ata2.00: configured for UDMA/66
> >> ata2.01: configured for UDMA/33
> >> scsi 0:0:0:0: Direct-Access     ATA      ST320420A        3.12 PQ: 0
> >> ANSI: 5 sd 0:0:0:0: [sda] 39851760 512-byte hardware sectors (20404 MB)
> >> sd 0:0:0:0: [sda] Write Protect is off
> >> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
> >> support DPO or FUA sd 0:0:0:0: [sda] 39851760 512-byte hardware sectors
> >> (20404 MB)
> >> sd 0:0:0:0: [sda] Write Protect is off
> >> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
> >> support DPO or FUA sda:<4>ehci_hcd 0000:03:0d.2: Unlink after no-IRQ?
> >> Controller is probably using the wrong IRQ. ata1.00: exception Emask 0x0
> >> SAct 0x0 SErr 0x0 action 0x2 frozen
> >> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
> >>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> >> ata1.00: status: { DRDY }
> >> ata1: soft resetting link
> >> ata1.00: configured for UDMA/66
> >> ata1: EH complete
> >> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> >> ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
> >>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> >> ata1.00: status: { DRDY }
> >> ata1: soft resetting link
> >> ata1.00: configured for UDMA/66
> >> ata1: EH complete
> >> SysRq : Emergency Sync
> >> Emergency Sync complete
> >> SysRq : Emergency Remount R/O
> >> Emergency Remount complete
> >> SysRq : Resetting
> >
> > This error is what I mentioned in a post yesterday that mentioned several
> > errors I've seen with a recent kernel built from linus' git.
> >
> > The only difference is that here the kernel starts at UDMA/133 and
> > devolves all the way down to PIO0 before spinning forever at that. A
> > fully "cold" boot (ie: removing all power from the system for a period of
> > several minutes and then powering it back on) seems to fix this problem.
> >
> > I've got a kernel here built from git b036555adc but I haven't tested it
> > yet. If the problem still occurs with it, I'll try to get a copy of the
> > output posted here.
>
> If its reproducible, please bisect...  That will tell us precisely the
> problematic change.
>
> 	Jeff

It doesn't occur with 36555adc here - at least, it didn't the two times I've 
booted a kernel built from that tree. With 36555adc I have other problems and 
will be refreshing my copy of the code first. But I will start bisecting if 
the problem persists.

I'm also going to make sure it wasn't caused by something strange, although, 
IIRC, the only real differences in the configs from the kernel that booted 
but had the somewhat random libata problem and the "strange xchat lockup"
problem is the CPA code and the "pre-emptible RCU" - so I'm going to turning 
off one and then both of those options.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.

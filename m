Return-Path: <linux-kernel-owner+w=401wt.eu-S1760783AbXGDKUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760783AbXGDKUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 06:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758767AbXGDKUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 06:20:14 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46933 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757433AbXGDKUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 06:20:12 -0400
Date: Wed, 4 Jul 2007 20:20:00 +1000
From: David Chinner <dgc@sgi.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: David Chinner <dgc@sgi.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Regression: 2.6.22-rcX: hda: lost interrupt
Message-ID: <20070704102000.GN989688@sgi.com>
References: <20070629124248.GJ989688@sgi.com> <468516B9.1080300@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <468516B9.1080300@garzik.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2007 at 10:27:05AM -0400, Jeff Garzik wrote:
> David Chinner wrote:
> >Folks,
> >
> >After updating an x86_64 machine from 2.6.21 to 2.6.22-rc6 and
> >fighting off the where-the-fuck-did-my-serial-console-go blues
> >(legacy_serial.force), I finally discovered why the damn thing
> >wasn't booting - the machine was sitting there in a loop outputting
> >"hda: lost interrupt" over and over again during hardware
> >discovery (hda = dvd drive).
> >
> >It doesn't happen on every boot - more boots hung than failed,
> >though, while I was trying to work out where my serial port
> >went and get some work done.
> >
> >Since I've had the console operative, the boot hangs are
> >basically like:
> >
> >ESB2: IDE controller at PCI slot 0000:00:1f.1
> >ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 20 (level, low) -> IRQ20
> >ESB2: chipset revision 9
> >ESB2: not 100% native mode: will probe irqs later
> >    ide0: DM-DMA at 0x50a0-0x50a7, BIOS settings: hda:DMA, hdb:pio
> >    ide1: DM-DMA at 0x50a8-0x50af, BIOS settings: hda:pio, hdb:pio
> >Probing IDE interface ide0...
> >hda: probing with STATUS(0xa0) instead of ALTSTATUS(0x58)
> >hda: <some ctrl char>, ATAPI UNKNOWN (type 31) drive
> >hdb: probing with STATUS(0xb0) instead of ALTSTATUS(0x00)
> >hdb: probing with STATUS(0xa1) instead of ALTSTATUS(0x51)
> >hdb: <some ctrl char>, ATAPI UNKNOWN (type 31) drive
> >hda: set_drive_speed_status: status=0x58 { DriveReady SeekComplete 
> >DataRequest }
> >hda: set_drive_speed_status: status=0x51 { DriveReady SeekComplete Error }
> >hda: set_drive_speed_status: error=0x04 { AbortedCommand }
> >ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> >hda: lost interrupt
> >hda: lost interrupt
> >hda: lost interrupt
> >hda: lost interrupt
> >hda: lost interrupt
> >hda: lost interrupt
> >hda: lost interrupt
> >hda: lost interrupt
> >hda: lost interrupt
> >hda: lost interrupt
> >hda: lost interrupt
> 
> What is the behavior under libata?
> 
> If you see timeouts/etc. there too, it might be an interrupt routing or 
> hardware problem.

Sorry to take so long to get back to this, Jeff.

I think the problem is on my side. It looks like a dodgy initrd
was causing the problems - a statically built kernel detects
the DVD drive without any issues so there may not be a problem
here at all. I'll continue trying to track down why the initrd
was not being built properly...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

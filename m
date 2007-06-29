Return-Path: <linux-kernel-owner+w=401wt.eu-S932802AbXF2O1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802AbXF2O1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 10:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760475AbXF2O1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 10:27:08 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:57736 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759077AbXF2O1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 10:27:07 -0400
Message-ID: <468516B9.1080300@garzik.org>
Date: Fri, 29 Jun 2007 10:27:05 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Regression: 2.6.22-rcX: hda: lost interrupt
References: <20070629124248.GJ989688@sgi.com>
In-Reply-To: <20070629124248.GJ989688@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
> Folks,
> 
> After updating an x86_64 machine from 2.6.21 to 2.6.22-rc6 and
> fighting off the where-the-fuck-did-my-serial-console-go blues
> (legacy_serial.force), I finally discovered why the damn thing
> wasn't booting - the machine was sitting there in a loop outputting
> "hda: lost interrupt" over and over again during hardware
> discovery (hda = dvd drive).
> 
> It doesn't happen on every boot - more boots hung than failed,
> though, while I was trying to work out where my serial port
> went and get some work done.
> 
> Since I've had the console operative, the boot hangs are
> basically like:
> 
> ESB2: IDE controller at PCI slot 0000:00:1f.1
> ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 20 (level, low) -> IRQ20
> ESB2: chipset revision 9
> ESB2: not 100% native mode: will probe irqs later
>     ide0: DM-DMA at 0x50a0-0x50a7, BIOS settings: hda:DMA, hdb:pio
>     ide1: DM-DMA at 0x50a8-0x50af, BIOS settings: hda:pio, hdb:pio
> Probing IDE interface ide0...
> hda: probing with STATUS(0xa0) instead of ALTSTATUS(0x58)
> hda: <some ctrl char>, ATAPI UNKNOWN (type 31) drive
> hdb: probing with STATUS(0xb0) instead of ALTSTATUS(0x00)
> hdb: probing with STATUS(0xa1) instead of ALTSTATUS(0x51)
> hdb: <some ctrl char>, ATAPI UNKNOWN (type 31) drive
> hda: set_drive_speed_status: status=0x58 { DriveReady SeekComplete DataRequest }
> hda: set_drive_speed_status: status=0x51 { DriveReady SeekComplete Error }
> hda: set_drive_speed_status: error=0x04 { AbortedCommand }
> ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> hda: lost interrupt
> hda: lost interrupt
> hda: lost interrupt
> hda: lost interrupt
> hda: lost interrupt
> hda: lost interrupt
> hda: lost interrupt
> hda: lost interrupt
> hda: lost interrupt
> hda: lost interrupt
> hda: lost interrupt

What is the behavior under libata?

If you see timeouts/etc. there too, it might be an interrupt routing or 
hardware problem.

	Jeff




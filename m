Return-Path: <linux-kernel-owner+w=401wt.eu-S932446AbYBVV0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446AbYBVV0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 16:26:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756744AbYBVVZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 16:25:58 -0500
Received: from rtr.ca ([76.10.145.34]:1650 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbYBVVZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 16:25:57 -0500
Message-ID: <47BF3DE3.4000100@rtr.ca>
Date: Fri, 22 Feb 2008 16:25:55 -0500
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Anders Eriksson <aeriksson@fastmail.fm>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.25-rc2 + smartd = hang
References: <20080222165122.8D2BB93C12F@tippex.mynet.homeunix.org> <47BF0DCD.4060400@garzik.org> <20080222185645.9DD9C93C12F@tippex.mynet.homeunix.org>
In-Reply-To: <20080222185645.9DD9C93C12F@tippex.mynet.homeunix.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anders Eriksson wrote:
> 
> jeff@garzik.org said:
>> The sysrq-e output is probably just standard ext3 journalling unrelated  to
>> the problem...  what does dmesg say?  lspci?  What's your hardware setup? 
> 
> 
> dmesg ; smartd ; dmesg yields no new entries in dmesg. It seems on disk 
> accesses are dead. it still routes packets fine.
> 
> This is an old PII-300 with 2 IDS disks and a DVD R/W. 
...
> Feb 22 17:38:49 tippex Uniform Multi-Platform E-IDE driver
> Feb 22 17:38:49 tippex ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
> Feb 22 17:38:49 tippex PIIX4: IDE controller (0x8086:0x7111 rev 0x01) at  PCI slot 0000:00:07.1
> Feb 22 17:38:49 tippex PIIX4: not 100% native mode: will probe irqs later
> Feb 22 17:38:49 tippex ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:PIO
> Feb 22 17:38:49 tippex ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings: hdc:PIO, hdd:PIO
> Feb 22 17:38:49 tippex Probing IDE interface ide0...
> Feb 22 17:38:49 tippex hdb: IC35L120AVV207-0, ATA DISK drive
> Feb 22 17:38:49 tippex hda: IBM-DTTA-371010, ATA DISK drive
> Feb 22 17:38:49 tippex hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
> Feb 22 17:38:49 tippex hda: UDMA/33 mode selected
> Feb 22 17:38:49 tippex hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
> Feb 22 17:38:49 tippex hdb: UDMA/33 mode selected
> Feb 22 17:38:49 tippex Probing IDE interface ide1...
> Feb 22 17:38:49 tippex hdd: Maxtor 6L250R0, ATA DISK drive
> Feb 22 17:38:49 tippex hdc: AOPEN DUW1608/ARR, ATAPI CD/DVD-ROM drive
> Feb 22 17:38:49 tippex hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
> Feb 22 17:38:49 tippex hdc: UDMA/33 mode selected
> Feb 22 17:38:49 tippex hdd: host max PIO4 wanted PIO255(auto-tune) selected PIO4
> Feb 22 17:38:49 tippex hdd: UDMA/33 mode selected
> Feb 22 17:38:49 tippex ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> Feb 22 17:38:49 tippex ide1 at 0x170-0x177,0x376 on irq 15
..

So that's using the old IDE drivers.
And the network and USB are sharing IRQ#11 with each other.

If you are going to be using newer kernels like this (2.6.23+),
then you might consider shifting those drives over to libata drivers.

This involves a little bit of work -- building a kernel with libata
and "ata_piix" built-in instead of the old IDE drivers,
and then rearranging /etc/fstab to match the new device names
(eg. /dev/sda instead of /dev/hda).

But at this point libata is working much better than the old IDE stuff,
and it really is worth moving things over if you can.

Cheers

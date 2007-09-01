Return-Path: <linux-kernel-owner+w=401wt.eu-S1755787AbXIAPfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbXIAPfq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 11:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753796AbXIAPfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 11:35:37 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:49007 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753965AbXIAPff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 11:35:35 -0400
Message-ID: <46D9876F.1070405@ru.mvista.com>
Date: Sat, 01 Sep 2007 19:38:23 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: John Sigler <linux.kernel@free.fr>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: hda: set_drive_speed_status: status=0x51 { DriveReady SeekComplete
 Error }
References: <46D59ED2.4000900@free.fr>
In-Reply-To: <46D59ED2.4000900@free.fr>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

John Sigler wrote:

> When my system boots, I get several set_drive_speed_status errors.
> (Please see attached dmesg output.)

> Can someone explain what they mean? How do I get rid of them?

    IDE code attempts to autotune PIO mode and fails at that because your 
device is too old (or its manufacturer was too lazy) to support ATA-2 (or EIDE 
from marketing PoV) is its full glory.

> Is there something I need to set in the config? or something I should 
> not have set?

    No, it just means that the IDE code is *too young* to support such 
pre-EIDE devices. :-D

> Bonus question: is there some way to turn on DMA for hda?

> Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
> ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
> VP_IDE: IDE controller at PCI slot 0000:00:07.1
> VP_IDE: chipset revision 6
> VP_IDE: not 100% native mode: will probe irqs later
> VP_IDE: VIA vt82c686b (rev 40) IDE UDMA100 controller on pci0000:00:07.1
>     ide0: BM-DMA at 0xd000-0xd007, BIOS settings: hda:pio, hdb:pio
>     ide1: BM-DMA at 0xd008-0xd00f, BIOS settings: hdc:pio, hdd:pio
> Probing IDE interface ide0...
> hda: PQI IDE DiskOnModule, ATA DISK drive
> hda: set_drive_speed_status: status=0x51 { DriveReady SeekComplete Error }
> hda: set_drive_speed_status: error=0x04 { DriveStatusError }
> hda: set_drive_speed_status: status=0x51 { DriveReady SeekComplete Error }
> hda: set_drive_speed_status: error=0x04 { DriveStatusError }

   That means that you've managed to find pre-EIDE/ATA hardware which doesn't 
support setting arbitrary PIO modes. What's funny is that resently being 
discussed here, so expect a patch RSN. :-)

> ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> Probing IDE interface ide1...
> hda: max request size: 128KiB
> hda: 128000 sectors (65 MB) w/1KiB Cache, CHS=500/8/32
>  hda: hda1 hda2

> # hdparm -v /dev/hda
> 
> /dev/hda:
>  multcount     =  0 (off)
>  IO_support    =  1 (32-bit)
>  unmaskirq     =  1 (on)
>  using_dma     =  0 (off)
>  keepsettings  =  0 (off)
>  readonly      =  0 (off)
>  readahead     = 256 (on)
>  geometry      = 500/8/32, sectors = 128000, start = 0

    Oh, interesting geometery, and the size too. :-)

> # hdparm -I /dev/hda
> 
> /dev/hda:
> 
> ATA device, with non-removable media
>         Model Number:       PQI IDE DiskOnModule

    That explains it. :-)

>         Serial Number:      DOM6B00011677
>         Firmware Revision:  ra03.00e
> Standards:
>         Likely used: 1
> Configuration:
>         hard sectored
>         not MFM encoded
>         head switch time > 15us
>         fixed drive
>         disk xfer rate > 5Mbs
>         Logical         max     current
>         cylinders       500     500
>         heads           8       8
>         sectors/track   32      32
>         --
>         bytes/track: 0  bytes/sector: 528
>         CHS current addressable sectors:     128000
>         LBA    user addressable sectors:     128000
>         device size with M = 1024*1024:          62 MBytes
>         device size with M = 1000*1000:          65 MBytes
> Capabilities:
>         LBA, IORDY not likely
>         Buffer type: 0002: dual port, multi-sector
>         Buffer size: 1.0kB      bytes avail on r/w long: 4
>         Cannot perform double-word IO

    That's generally not the device task (although there probably were IDE 
devices with 32-bit data bus?.. :-O

>         R/W multiple sector transfer: Max = 1   Current = 0
>         DMA: not supported
>         PIO: pio0 pio1 pio2

[the rest of logs didn't show anything particurarly interesting]

MBR, Sergei

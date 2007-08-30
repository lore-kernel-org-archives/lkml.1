Return-Path: <linux-kernel-owner+w=401wt.eu-S1762654AbXH3PLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762654AbXH3PLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 11:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759988AbXH3PLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 11:11:07 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:36800 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896AbXH3PLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 11:11:06 -0400
Message-ID: <46D6DDF6.6080400@free.fr>
Date: Thu, 30 Aug 2007 17:10:46 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-ide@vger.kernel.org
CC: linux-kernel@vger.kernel.org, vojtech@suse.cz
Subject: Re: hda: set_drive_speed_status: status=0x51 { DriveReady SeekComplete
 Error }
References: <46D59ED2.4000900@free.fr> <20070829174657.09c7de3c@the-village.bc.nu> <46D67D09.6090101@free.fr> <46D69E03.9080403@vc.cvut.cz> <46D6B85C.5050509@free.fr>
In-Reply-To: <46D6B85C.5050509@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Sigler wrote:

> Petr Vandrovec wrote:
> 
>> John Sigler wrote:
>>
>>> Alan Cox wrote:
>>>
>>>> Basically your dinosaur is working correctly.
>>>
>>> What do the warnings mean? :-)
>>
>> That your drive does not support set transfer mode/speed command at 
>> all, or that value which kernel tried is not supported by the drive...
>>
>> I would guess that some contractor wrote firmware for device for PQI 
>> in one day for $100, and before that somebody else designed ATA-SD 
>> bridge for PQI for another $100.
>>
>> I guess that these two printk()s happen because drive claims to 
>> support pio0,1,2 - so Linux tries pio2, drive refuses, Linux tries 
>> pio1, drive refuses, and finally as pio0 is default, that one gets 
>> used.  Which is more or less confirmed by having no '*' sign in front 
>> of any pio - with "real" drives you should see '*' in front of one of 
>> listed dma/pio modes.
>>
>> You should ask reseller how they can ship drive which does not conform 
>> to any ATA standard...
> 
> I took drivers/ide/pci/via82cxxx.c and sprinkled ENTER/EXIT printk's.
> http://lxr.linux.no/source/drivers/ide/pci/via82cxxx.c
> 
> via82cxxx_tune_drive() and via82cxxx_ide_dma_check() both call 
> via_set_drive() which calls ide_config_drive_speed().
> 
> http://lxr.linux.no/source/drivers/ide/ide-iops.c#L769
> 
>   if (error)
>   {
>     (void) ide_dump_status(drive, "set_drive_speed_status", stat);
>     printk(KERN_INFO "EXIT %s error\n", __func__);
>     return error;
>   }
> 
> Does someone know why error is not set to 0?
> 
> 
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
> ENTER via82cxxx_tune_drive
> ENTER via_set_drive
> ENTER ide_config_drive_speed
> hda: set_drive_speed_status: status=0x51 { DriveReady SeekComplete Error }
> hda: set_drive_speed_status: error=0x04 { DriveStatusError }
> EXIT ide_config_drive_speed error
> ENTER via_set_speed
> EXIT via_set_speed
> EXIT via_set_drive
> EXIT via82cxxx_tune_drive pio == 255
> ENTER via82cxxx_ide_dma_check
> ENTER via_set_drive
> ENTER ide_config_drive_speed
> hda: set_drive_speed_status: status=0x51 { DriveReady SeekComplete Error }
> hda: set_drive_speed_status: error=0x04 { DriveStatusError }
> EXIT ide_config_drive_speed error
> ENTER via_set_speed
> EXIT via_set_speed
> EXIT via_set_drive
> EXIT via82cxxx_ide_dma_check
> ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> Probing IDE interface ide1...
> hda: max request size: 128KiB
> hda: 128000 sectors (65 MB) w/1KiB Cache, CHS=500/8/32
>  hda: hda1 hda2

According to my supplier, herre is the data sheet for the DOMs:
http://www.pqimemory.com/documents/domdata.pdf

PIO mode 2 is mentioned. Even DMA seems to be supported.
Or am I mistaken?

Could there be a bug in my south bridge?

Regards.


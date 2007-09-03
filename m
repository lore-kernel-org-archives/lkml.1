Return-Path: <linux-kernel-owner+w=401wt.eu-S1756542AbXICNiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbXICNiF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 09:38:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753824AbXICNhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 09:37:54 -0400
Received: from ns2.mvista.com ([63.81.120.155]:61175 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753808AbXICNhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 09:37:53 -0400
Message-ID: <46DC0EDA.10807@ru.mvista.com>
Date: Mon, 03 Sep 2007 17:40:42 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: John Sigler <linux.kernel@free.fr>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: hda: set_drive_speed_status: status=0x51 { DriveReady SeekComplete
 Error }
References: <46D59ED2.4000900@free.fr> <46D9876F.1070405@ru.mvista.com> <46DC0976.10003@free.fr>
In-Reply-To: <46DC0976.10003@free.fr>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

John Sigler wrote:

>>> When my system boots, I get several set_drive_speed_status errors.
>>> (Please see attached dmesg output.)

>>> Can someone explain what they mean? How do I get rid of them?

>>    IDE code attempts to autotune PIO mode and fails at that because 
>> your device is too old (or its manufacturer was too lazy) to support 
>> ATA-2 (or EIDE from marketing PoV) is its full glory.

> But the data sheet seems to state the drive supports PIO modes 1 and 2?

    So what? PIO mode != ATA spec version. ATA-1 specified modes 0 thru 2.

>>> Is there something I need to set in the config? or something I should 
>>> not have set?

>>    No, it just means that the IDE code is *too young* to support such 
>> pre-EIDE devices. :-D

> Wow! This is a device that was purchased only a few months ago...

    I think we'll take care of it soon -- as I said we've discovered pre-EIDE 
disk support lately, just before your report...

>>> Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
>>> ide: Assuming 33MHz system bus speed for PIO modes; override with 
>>> idebus=xx
>>> VP_IDE: IDE controller at PCI slot 0000:00:07.1
>>> VP_IDE: chipset revision 6
>>> VP_IDE: not 100% native mode: will probe irqs later
>>> VP_IDE: VIA vt82c686b (rev 40) IDE UDMA100 controller on pci0000:00:07.1
>>>     ide0: BM-DMA at 0xd000-0xd007, BIOS settings: hda:pio, hdb:pio
>>>     ide1: BM-DMA at 0xd008-0xd00f, BIOS settings: hdc:pio, hdd:pio
>>> Probing IDE interface ide0...
>>> hda: PQI IDE DiskOnModule, ATA DISK drive
>>> hda: set_drive_speed_status: status=0x51 { DriveReady SeekComplete 
>>> Error }
>>> hda: set_drive_speed_status: error=0x04 { DriveStatusError }
>>> hda: set_drive_speed_status: status=0x51 { DriveReady SeekComplete 
>>> Error }
>>> hda: set_drive_speed_status: error=0x04 { DriveStatusError }

>>   That means that you've managed to find pre-EIDE/ATA hardware which 
>> doesn't support setting arbitrary PIO modes. What's funny is that 
>> recently being discussed here, so expect a patch RSN. :-)

> In 2.6.23?

    Yeah, hopefully.
    The mode interesting question is how to diable IORDY throrling on host if 
a device doesn't have it connected (that was addressed by Alan in libata, IIRC.

> Regards.

MBR as well. :-)

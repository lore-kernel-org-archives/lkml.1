Return-Path: <linux-kernel-owner+w=401wt.eu-S935101AbYEUBJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935101AbYEUBJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 21:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933047AbYEUBIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 21:08:31 -0400
Received: from cnrelay03.alcatel-sbell.com.cn ([211.144.215.19]:40362 "EHLO
	mail.alcatel-sbell.com.cn" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934243AbYEUBI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 21:08:29 -0400
Message-ID: <48337608.7010000@alcatel-lucent.com>
Date: Wed, 21 May 2008 09:08:24 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: PIIX4 DMA Timeout
References: <003b01c8ba7a$19f01500$01fca8c0@microsof60b8d6> 
	<Pine.LNX.4.55.0805201746130.31790@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0805201746130.31790@cliff.in.clinika.pl>
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 May 2008 01:07:57.0670 (UTC) 
	FILETIME=[1B309060:01C8BADF]
X-imss-version: 2.050
X-imss-result: Passed
X-imss-scores: Clean:96.46463 C:2 M:3 S:5 R:5
X-imss-settings: Baseline:2 C:1 M:1 S:1 R:1 (0.1500 0.1500)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:
> On Tue, 20 May 2008, Gavin Shan wrote:
>
>   
>> There has one MV64460 on my board, which includes 2 PCI bridges. PIIX4 is on slot 3 of PCI1.
>> But now, IDE driver reported it's timeouted on DMA operation. Thanks in advance for your
>> suggestions.
>>     
> [...]
>   
>> PIIX4: chipset revision 1
>> PIIX4: not 100% native mode: will probe irqs later
>>     ide0: BM-DMA at 0xd8000000-0xd8000007, BIOS settings: hda:pio, hdb:pio
>>     ide1: BM-DMA at 0xd8000008-0xd800000f, BIOS settings: hdc:pio, hdd:pio
>> hdc: HTE721010G9AT00, ATA DISK drive
>> hdc: max request size: 512KiB
>> hdc: 195371568 sectors (100030 MB) w/7539KiB Cache, CHS=16383/255/63, UDMA(33)
>> hdc: cache flushes supported
>>  hdc:<4>hdc: dma_timer_expiry: dma status == 0x26
>> hdc: DMA interrupt recovery
>> hdc: lost interrupt
>> hdc: dma_intr: status=0x58 { DriveReady SeekComplete DataRequest }
>> ide: failed opcode was: unknown
>> hdc: DMA disabled
>> ide1: reset: success
>>  hdc2 hdc3 hdc4
>>     
>
>  It looks like some problem with interrupt routing.  At least with some of
> the PIIX chips I recall there was some limitation about how the IDE
> interrupts had to be used for DMA to be operational.  For PIO modes there
> were no restrictions.  Do you have chip-level documentation for your
> board?
>
>   Maciej
>   
Maciej, thank you very much for your reply. I don't think this was caused by
interrupt routing. I added lots of "printk" before following output, and saw
interrupts could be triggered correctly.

hdc: 195371568 sectors (100030 MB) w/7539KiB Cache, CHS=16383/255/63, UDMA(33)

LynxOS has been run successfully on this board, and we want port it to Linux recently.

I'm not sure which resource (I/O or Memory space) should be used for DMA operation because
all memory resources haven't been set (the flag is 0x2xxxxxxx). So my question is DMA operation
could succeed with I/O resource?



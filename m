Return-Path: <linux-kernel-owner+w=401wt.eu-S1759214AbYG3BIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759214AbYG3BIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 21:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753680AbYG3BIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 21:08:10 -0400
Received: from cnrelay03.alcatel-sbell.com.cn ([211.144.215.19]:55470 "EHLO
	mail.alcatel-sbell.com.cn" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753157AbYG3BII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 21:08:08 -0400
Message-ID: <488FBC6F.2080800@alcatel-lucent.com>
Date: Wed, 30 Jul 2008 08:57:19 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: PIIX4: DMA timeout issue
References: <488ED837.2060509@alcatel-lucent.com> 
	<488F1C6C.9000002@garzik.org> <200807291713.29580.bzolnier@gmail.com>
In-Reply-To: <200807291713.29580.bzolnier@gmail.com>
Content-Type: text/plain;
	charset=iso-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jul 2008 00:57:09.0758 (UTC) 
	FILETIME=[31EB89E0:01C8F1DF]
X-imss-version: 2.051
X-imss-result: Passed
X-imss-scores: Clean:99.90000 C:2 M:3 S:5 R:5
X-imss-settings: Baseline:2 C:1 M:1 S:1 R:1 (0.1500 0.1500)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
> Hmmm?
>
> Maciej was investigating this:
>
> 	http://lkml.org/lkml/2008/5/20/724
>
> but you didn't follow up and started new thread with:
>
> 	http://lkml.org/lkml/2008/7/14/452
>   
I'm sorry for this :-(
> [ It could be that the original IRQ routing issue was fixed
>   (or wasn't really the source of problem) but you didn't tell
>   us about it and ignored previous discussions. ]
>   
The IRQ routing issue has been fixed. IRQ routing system
on my board is somewhat complicated: i8259->mlba (FPGA based
PCI device)->MV64460(system controller). I forgot to set MV64460
IRQ pin to level sensitive and edge sensitive was used, which caused
interrupt lost finally. After changing this to level sensitive, everything
seems fine. Now, the problem isn't interrupt lost, but suspending DMA
operations.
> Also is the problem still present in 2.6.26 or 2.6.27-rc1?
>
> [ I don't see an information about the kernel version that is
>   being used in either of threads? ]
>   
Sorry, I'm using 2.6.21 kernel.
>   
>>> There are 2 types of board for me. The hardware configuration for
>>> those 2 boards are almost same except that one of them has 100GB
>>> harddisk, and another type of board has 60GB harddisk. All harddisk
>>> was access through PIIX4. I found this issue on board with 60GB
>>> disk, but can't reproduce it on that with 100GB disk.
>>>
>>> When I uncompressed a large file (600MB) to a logic partition with 8GB
>>> size, following errors was report on middle way (5 minutes about from 
>>> start).
>>> Anybody has ideas?
>>>
>>> hdc: dma_timer_expiry: dma status == 0x21
>>> hdc: DMA timeout error
>>> hdc: dma timeout error: status=0x58 { DriveReady SeekComplete DataRequest }
>>> ide: failed opcode was: unknown
>>> hdc: DMA disabled
>>> ide1: reset: success
>>>       
>> Can you try disabling the IDE driver (CONFIG_IDE) and enabling the newer 
>> libata driver?  (CONFIG_ATA)
>>
>> 	Jeff
>>     


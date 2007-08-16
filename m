Return-Path: <linux-kernel-owner+w=401wt.eu-S1759831AbXHPMj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759831AbXHPMj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 08:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755470AbXHPMjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 08:39:48 -0400
Received: from linux.dunaweb.hu ([62.77.196.1]:40563 "EHLO linux.dunaweb.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112AbXHPMjr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 08:39:47 -0400
Message-ID: <46C4457D.5030703@dunaweb.hu>
Date: Thu, 16 Aug 2007 14:39:25 +0200
From: Zoltan Boszormenyi <zboszor@dunaweb.hu>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: 7eggert@gmx.de
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: Bad CD disk disables IDE DMA
References: <8Squ5-2cU-19@gated-at.bofh.it> <8SIKl-5IK-13@gated-at.bofh.it> <E1ILeCg-0000iH-2W@be1.lrz>
In-Reply-To: <E1ILeCg-0000iH-2W@be1.lrz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert írta:
> Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
>   
>> On 15/08/07, Zoltan Boszormenyi <zboszor@dunaweb.hu> wrote:
>>     
>
>   
>>> I noticed that a bad CD of mine makes DMA disabled:
>>>       
>
> [...]
>   
>>> hda: cdrom_decode_status: error=0x40 { LastFailedSense=0x04 }
>>> ide: failed opcode was: unknown
>>> hda: DMA disabled
>>> hda: ide_intr: huh? expected NULL handler on exit
>>> hda: ATAPI reset complete
>>>
>>> Every time I put the said CD into to drive and DMA is on, I get the
>>> above messages.
>>>       
>> This might be intended.
>>     
>
> Maybe, and maybe only a certain effect might be intended. And maybe I can
> help by asking these questions:
>
> 1) Does disabling DMA fix the seek errors, or does it hide them by the PIO
>    interfce not printing them?
>   

With DMA off no seek error occurs. When the transfer rate is
limited to UDMA3 I get this:

hda: drive_cmd: status=0x51 { DriveReady SeekComplete Error }
hda: drive_cmd: error=0x04 { AbortedCommand }
ide: failed opcode was: 0xec

Note the difference: the error code is different and
it knows the failed opcode as well. But DMA remains on.
Can it be a bad 80w cable? I don't think so, considering that
it doesn't occur for DVDs when using UDMA4...

> 2) If it does hide them, would filtering for seek errors be a sane thing to
>    do, or does the DMA engine (or HDD) behave badly on these errors, or
>    do bad-DMA devices report seek errors, too?
>
> 3) If it does not hide them, would re-enabling DMA on disk change be a
>    feasable workaround?
>    (proposed interface: use hdparm -d $num where $num =
>      0, 1: as before
>      3: DMA on, if switched off automatically, will be set to 2
>      2: DMA off, will be turned on (set to 3) on disk change)
>   

The automatic DMA re-enabling would be a good solution.

> 4) Does libata work well enough for making all effort put into that old
>    IDE layer be a waste of time?
>   

Unfortunately libata (or pata_amd) doesn't work very well on this machine,
I tried to switch to libata for the CD drive but it lost the DVD-playing 
capability.
It seems the error was that libdvdcss couldn't get the keys via the scd 
device.
This is the main obstacle that stops me switching to Fedora 7 from FC6.
I reported it some time ago but got no answer. Look for subject
"DVD-playing, ide-cd vs scsi-cd drivers".

Best regards,
Zoltán Böszörményi



Return-Path: <linux-kernel-owner+w=401wt.eu-S932478AbXBJOqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478AbXBJOqB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 09:46:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932520AbXBJOqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 09:46:00 -0500
Received: from wx-out-0506.google.com ([66.249.82.227]:62956 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461AbXBJOp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 09:45:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=m1U4J4hOuG0IRPm+bOArxBas0vvJ2IJwn9nI5EJAOxcdmxeCWxMHjz+L7CMCDqYvhi15yIE7WoYjqD6qAlX/G7x0Jplw/LZ1ykUvZmPGoaDgLc9EXwZbjNG1OeRCgvjfYsLHXXgOLxq3bHxudwCmhmIOm+sdPSPQ3OyEXBLGPpY=
Message-ID: <45CDDA86.2000607@gmail.com>
Date: Sat, 10 Feb 2007 09:45:26 -0500
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: lepalom@wol.es
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jean Delvare <jdelvare@suse.de>
Subject: Re: Sata_via problems in a Vintage2-AE1
References: <200702090010.06897.lepalom@wol.es> <45CC42FF.5030507@gmail.com> <200702091814.02530.lepalom@wol.es> <200702092109.25029.lepalom@wol.es>
In-Reply-To: <200702092109.25029.lepalom@wol.es>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[cc'ing Alan and Jean, Hi!]

Leopold Palomo Avellaneda wrote:
> A Divendres 09 Febrer 2007 18:13, Leopold Palomo Avellaneda va escriure:
>> A Divendres 09 Febrer 2007 10:46, Tejun Heo va escriure:
>>> Leopold Palomo Avellaneda wrote:
>>>> Dear people,
>>>>
>>>> I have a barebone Asus Vintage2-AE1 [1]. This box has a mobo Asus
>>>> A8V-MQ. The board has:
>>>> - the Socket 939 for AMD Athlon 64FX/Athlon 64.
>>>> - North Bridge: VIA K8M800
>>>> - South Bridge: VIA VT8251
>>>> - VIA Graphics Integrated
>>>> - IDE 2 x UltraDMA 133
>>>> - 4 x Serial ATA
>>>> ...
>>>>
>>>> I'm using the bios version 0206. The 0210 doesn't show me the vga card,
>>>> so I don't have graphics mode. I think that is a buggy bios.
>>>>
>>>> The bios is configured with vt8251 in AHCI mode and bios boot up
>>>> activated, so the hd is recognized in the beginning. I don't have any
>>>> raid, only one hd. The hd is a Maxtor 6V250F0.
>>>>
>>>> I'm using a debian etch but the i386 version. The only way that I can
>>>> use the hd is using a 2.6.16 standard kernel with the modifications
>>>> explained in this page [2]. Basically you have to use their ahci.c and
>>>> sata_via.c. The modifications are small from the original code from Mr
>>>> Jeff Garzik.
>>>>
>>>> I have tried to use the 2.6.18 and 2.6.20rc6 and the result is the
>>>> same. The kernel boots, but when arrives at the ata3,
>>>>
>>>> scsi2 : ahci
>>>> ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>>>> ata3.00: qc timeout (cmd 0xec)
>>>> ata3.00: failed to IDENTIFY (I/O error, err_mask=0x104)
>>>> .... repeated some times ...
>>>> scsi3 : ahci
>>>> ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>>>> scsi4 : ahci
>>>> ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>>>> scsi5 : ahci
>>>> ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>>>> Done.
>>>> Begin: Mounting root file system... ...
>>>> Begin: Running /scripts/local-top
>>>> ide0: I/O resource 0x3F6-0x3F6 not free.
>>>> ide0: ports already in use, skipping probe.
>>>> ide1: I/O resource 0x376-0x376 not free.
>>>> ide1: ports already in use, skipping probe.
>>>> Done.
>>>> Begin: Waiting for root file system ...
>>> It might be VIA IRQ quirk problem.
>>>
>>> 1. Does giving 'irqpoll' parameter to kernel make any difference?
>> yes. Now it boots. However I'm having a lot of messages:
>> APIC error on CPU0
>> and I begin to have problems with the network card.
>>
>>> 2. Can you give a shot at 2.6.20?
>> yes, I'm doing it now.
>>
>> Thank's a lot. But, why with irqpoll works and without no?
> 
> well, I summarize. 
> 
> With the default options of the kernel I cannot boot in this device with any 
> kernel. Only with 2.6.20 and the irqpoll or the 2.6.16 modified files I can 
> boot.
> 
> I have a lot of APIC error on CPU0.

It seems one of via pci routing quirk problem.  Can you give a shot at 
'acpi=off' or 'acpi=noirq' without 'irqpoll'?

I dunno much about what's going on there.  Alan, Jean, any ideas?

Thanks.

-- 
tejun

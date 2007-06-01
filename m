Return-Path: <linux-kernel-owner+w=401wt.eu-S1762752AbXFASK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762752AbXFASK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 14:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761633AbXFASKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 14:10:12 -0400
Received: from lucidpixels.com ([75.144.35.66]:44073 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761320AbXFASKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 14:10:10 -0400
Date: Fri, 1 Jun 2007 14:10:09 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Robert Hancock <hancockr@shaw.ca>
cc: Parag Warudkar <parag.warudkar@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Case: 7454422: Re: Kernel 2.6.21.3 does not work with 8GB of
 RAM on Intel 965WH motherboards. (FULL DMESG)
In-Reply-To: <Pine.LNX.4.64.0706011355520.3716@p34.internal.lan>
Message-ID: <Pine.LNX.4.64.0706011409590.3716@p34.internal.lan>
References: <82e4877d0705301757v580a4ca5yebe2a565f0b97552@mail.gmail.com>
 <465E513E.60903@shaw.ca> <Pine.LNX.4.64.0706011233100.18986@p34.internal.lan>
 <Pine.LNX.4.64.0706011355520.3716@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 1 Jun 2007, Justin Piszcz wrote:

>
>
> On Fri, 1 Jun 2007, Justin Piszcz wrote:
>
>> 
>> 
>> On Wed, 30 May 2007, Robert Hancock wrote:
>> 
>>> Parag Warudkar wrote:
>>>> Robert Hancock wrote:
>>>> 
>>>> 
>>>>> 0-3319MB
>>>>> 4096-8832MB
>>>>> 
>>>>> leaving 64MB of memory at the top of RAM uncached. What do you want to
>>>>> bet that something important (kernel code?) is getting loaded there..
>>>>> 
>>>>> So essentially it's a BIOS problem, it's not setting up the MTRRs
>>>>> properly in order to map all of RAM as cacheable. As Andi says, complain
>>>>> to Intel.
>>>>> 
>>>> 
>>>> Could the BADRAM patch be useful for him?
>>>> http://rick.vanrein.org/linux/badram/download.html has 2.6.21 version.
>>>> It says it supports x86_64. May be using this patch he can exclude
>>>> that RAM from being used/accessed?
>>> 
>>> I think that mem=8832M would work as well, to make the kernel use only the 
>>> memory that is marked cacheable. (It looks like this parameter takes the 
>>> highest memory address we want the kernel to use, not the highest memory 
>>> amount.)
>>> 
>>> -- 
>>> Robert Hancock      Saskatoon, SK, Canada
>>> To email, remove "nospam" from hancockr@nospamshaw.ca
>>> Home Page: http://www.roberthancock.com/
>>> 
>> 
>> Is 8832MB a typo?  8GB of memory is ~8192MB right?  Did you mean 8132MB or? 
>> Intel wants me to flash my bios and reset everything to the defaults to see 
>> if it is still an issue, I'd prefer to try the mem= option first.
>> 
>> Justin.
>> 
>
> mem=8064M" [top: Mem:   7264144k total]
> mem=8832M" [top: Mem:   8039820k total]
>
> I am using 8832MB and it does not have the bug/slowness!  How did you 
> calculate that from the MTRR output?
>
> $ cat /proc/mtrr
> reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
> reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
> reg02: base=0xc0000000 (3072MB), size= 256MB: write-back, count=1
> reg03: base=0xcf800000 (3320MB), size=   8MB: uncachable, count=1
> reg04: base=0xcf700000 (3319MB), size=   1MB: uncachable, count=1
> reg05: base=0x100000000 (4096MB), size=4096MB: write-back, count=1
> reg06: base=0x200000000 (8192MB), size= 512MB: write-back, count=1
> reg07: base=0x220000000 (8704MB), size= 128MB: write-back, count=1
>
> It sees 7.66GB now!
>
> 8039820 / 1024 / 1024
> 7.66GB
>
> top - 13:56:48 up 3 min,  5 users,  load average: 0.12, 0.14, 0.06
> Tasks: 163 total,   1 running, 162 sleeping,   0 stopped,   0 zombie
> Cpu0  :  4.4%us,  1.4%sy,  0.2%ni, 89.7%id,  4.1%wa,  0.0%hi,  0.1%si, 
> 0.0%st
> Cpu1  :  0.1%us,  0.5%sy,  0.6%ni, 98.4%id,  0.3%wa,  0.0%hi,  0.0%si, 
> 0.0%st
> Cpu2  :  1.2%us,  0.3%sy,  0.1%ni, 97.9%id,  0.5%wa,  0.0%hi,  0.0%si, 
> 0.0%st
> Cpu3  :  0.2%us,  1.9%sy,  0.7%ni, 96.0%id,  1.1%wa,  0.0%hi,  0.0%si, 
> 0.0%st
> Mem:   8039820k total,  1039588k used,  7000232k free,     3552k buffers
> Swap: 16787768k total,        0k used, 16787768k free,   141480k cached
>
>
>
>

Ahh here we go:

Justin Piszcz wrote:
> That output looked nasty, attaching entries from syslog.
>
> Justin.

Here's your E820 memory map, from dmesg:

BIOS-e820: 0000000000000000 - 000000000008f000 (usable)
BIOS-e820: 000000000008f000 - 00000000000a0000 (reserved)
BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
BIOS-e820: 0000000000100000 - 00000000cf58f000 (usable)
BIOS-e820: 00000000cf58f000 - 00000000cf59c000 (reserved)
BIOS-e820: 00000000cf59c000 - 00000000cf653000 (usable)
BIOS-e820: 00000000cf653000 - 00000000cf6a5000 (ACPI NVS)
BIOS-e820: 00000000cf6a5000 - 00000000cf6a8000 (ACPI data)
BIOS-e820: 00000000cf6a8000 - 00000000cf6ef000 (ACPI NVS)
BIOS-e820: 00000000cf6ef000 - 00000000cf6f1000 (ACPI data)
BIOS-e820: 00000000cf6f1000 - 00000000cf6f2000 (usable)
BIOS-e820: 00000000cf6f2000 - 00000000cf6ff000 (ACPI data)
BIOS-e820: 00000000cf6ff000 - 00000000cf700000 (usable)
BIOS-e820: 00000000cf700000 - 00000000d0000000 (reserved)
BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
BIOS-e820: 0000000100000000 - 000000022c000000 (usable)

so the usable memory ranges are:

0-572K
1MB-3317.55MB
3317.60MB-3317.75MB
3318.94MB-3318.945MB
3318.996MB-3319MB
4096MB-8896MB

and the MTRRs (from /proc/mtrr, from private email):

reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
reg02: base=0xc0000000 (3072MB), size= 256MB: write-back, count=1
reg03: base=0xcf800000 (3320MB), size=   8MB: uncachable, count=1
reg04: base=0xcf700000 (3319MB), size=   1MB: uncachable, count=1
reg05: base=0x100000000 (4096MB), size=4096MB: write-back, count=1
reg06: base=0x200000000 (8192MB), size= 512MB: write-back, count=1
reg07: base=0x220000000 (8704MB), size= 128MB: write-back, count=1

so the ranges mapped as cacheable are:

0-3319MB
4096-8832MB

leaving 64MB of memory at the top of RAM uncached. What do you want to
bet that something important (kernel code?) is getting loaded there..

So essentially it's a BIOS problem, it's not setting up the MTRRs
properly in order to map all of RAM as cacheable. As Andi says, complain
to Intel.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


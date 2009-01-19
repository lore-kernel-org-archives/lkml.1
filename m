Return-Path: <linux-kernel-owner+w=401wt.eu-S1755204AbZASXF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbZASXF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 18:05:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbZASXFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 18:05:16 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.123]:57121 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbZASXFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 18:05:15 -0500
X-Greylist: delayed 123996 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Jan 2009 18:05:15 EST
Message-ID: <49750728.8060005@cfl.rr.com>
Date: Mon, 19 Jan 2009 18:05:12 -0500
From: Mark Hounschell <dmarkh@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: markh@compro.net
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: Can't boot a (HZ = 1000) kernel using an AMD Phenom-II
 processor
References: <497322CC.7050900@cfl.rr.com> <49743E52.7010906@cfl.rr.com> <200901191341.54081.bzolnier@gmail.com> <49749208.9060807@compro.net>
In-Reply-To: <49749208.9060807@compro.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Hounschell wrote:
> Bartlomiej Zolnierkiewicz wrote:
>> On Monday 19 January 2009, Mark Hounschell wrote:
>>> Mark Hounschell wrote:
>>>> I upgraded from a Phenom to a Phenom-II processor and I could no longer boot.
>>>>
>>>> I have tried kernels from 2.6.26 through 2.6.28.
>>>>
>>>> I _can_ however boot these kernels when they are configured for HZ = 250. I
>>>> haven't tried HZ = 300. But certainly if HZ = 1000 the boot hangs at the spot
>>>> indicated below in the dmesg output.
>>>>
>>>> The machine is up and stable running 2.6.26.8 with a (HZ = 1000) configured kernel.
>>>>
>>> The machine is up and stable running 2.6.26.8 with a (HZ = 250) configured
>>> kernel. Sorry.
>>>
>>>> While running a 2.6.26.8 kernel configured for HZ = 250:
>> [...]
>>
>>>> Checking if this processor honours the WP bit even in supervisor mode...Ok.
>>>>
>>>>
>>>>       The 2.6.26.8 kernel hangs up right here.
>>>>
>>>>
>>>> CPA: page pool initialized 1 of 1 pages preallocated
>>>> SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
>>>> hpet clockevent registered
>>>> calibrate_delay_direct() failed to get a good estimate for loops_per_jiffy.
>>>> Probably due to long platform interrupts. Consider using "lpj=" boot option.
>>>> Calibrating delay loop... 3956.73 BogoMIPS (lpj=7913472)
>> Even if it boots it may not work reliably since lpj/BogoMIPS are too small
>> (they should be the same as for other CPUs) which in turn could result in too
>> short delay loops.
>>
>>>> Security Framework initialized
>>>> Capability LSM initialized
>>>> Mount-cache hash table entries: 512
>>>> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
>>>> CPU: L2 Cache: 512K (64 bytes/line)
>>>> CPU 0(4) -> Core 0
>>>> Checking 'hlt' instruction... OK.
>>>> ACPI: Core revision 20080321
>>>> ENABLING IO-APIC IRQs
>>>> ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
>>>> CPU0: AMD Processor model unknown stepping 02
>>>> Booting processor 1/1 ip 2000
>>>> Initializing CPU#1
>>>> Calibrating delay using timer specific routine.. 6000.60 BogoMIPS (lpj=12001200)
>> Here are the proper values.
>>
>>>> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
>>>> CPU: L2 Cache: 512K (64 bytes/line)
>>>> CPU 1(4) -> Core 2
>>>> x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
>>>> CPU1: AMD Processor model unknown stepping 02
>>>> Booting processor 2/2 ip 2000
>>>> Initializing CPU#2
>>>> Calibrating delay using timer specific routine.. 6000.47 BogoMIPS (lpj=12000950)
>> also OK
>>
>>>> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
>>>> CPU: L2 Cache: 512K (64 bytes/line)
>>>> CPU 2(4) -> Core 1
>>>> x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
>>>> CPU2: AMD Processor model unknown stepping 02
>>>> Booting processor 3/3 ip 2000
>>>> Initializing CPU#3
>>>> Calibrating delay using timer specific routine.. 6000.47 BogoMIPS (lpj=12000955)
>> ditto
>>
>> That being said I don't know why delay calibration loop fails on CPU0.
>>
>> You may try booting with "lpj=12001200" kernel parameter to workaround
>> the issue (it should fix booting with HZ == 1000) and/or try 2.6.29-rc2
>> (the problem may have been already fixed).
>>
>> Thanks,
>> Bart
>>
> 
> I'll try "lpj=12001200" and 2.6.29-rc2 later when I get home this ev.
> 
> But I noticed CPU2 is different too. Is CPU1 the correct one?
> 
>>>> Initializing CPU#0
>>>> Calibrating delay loop... 3956.73 BogoMIPS (lpj=7913472)
> 
>>>> Initializing CPU#1
>>>> Calibrating delay using timer specific routine.. 6000.60 BogoMIPS (lpj=12001200)
> 
>>>> Initializing CPU#2
>>>> Calibrating delay using timer specific routine.. 6000.47 BogoMIPS (lpj=12000950)
> 
>>>> Initializing CPU#3
>>>> Calibrating delay using timer specific routine.. 6000.47 BogoMIPS (lpj=12000955)
> 

None of the lpj values made any difference. 2.6.29-rc2 did print a couple more
messages. The last one was

Using C1E aware idle routine
Checking 'hlt' in


Surely I can't be the only Linux user with this processor???

Regards
Mark



Return-Path: <linux-kernel-owner+w=401wt.eu-S1755999AbYBIMqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbYBIMqi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 07:46:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754155AbYBIMqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 07:46:30 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:37910 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034AbYBIMq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 07:46:29 -0500
Date: Sat, 09 Feb 2008 07:46:25 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [PATCH] Replace nvidia timer override quirk with pci id list
In-reply-to: <200802081839.18267.prakash@punnoor.de>
To: Prakash Punnoor <prakash@punnoor.de>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
       lenb@kernel.org, linux-kernel@vger.kernel.org
Message-id: <200802090746.25310.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <20080207195519.GA21772@basil.nowhere.org>
 <20080208160906.GA9642@one.firstfloor.org>
 <200802081839.18267.prakash@punnoor.de>
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 February 2008, Prakash Punnoor wrote:
>On the day of Friday 08 February 2008 Andi Kleen hast written:
>> On Fri, Feb 08, 2008 at 04:13:35PM +0100, Prakash Punnoor wrote:
>> > Sorry, I meant the opposite. I needed the acpi_skip_timer_override
>> > kernel parameter for nforce2, thus no override. So this chipset is
>> > missing here. At least I remember that my nforce2 needed the skipping,
>>
>> I hope you remember correctly and mean it this time. It would be better
>> if you could double check.
>
>Yes, confirmed. timer w/o the skipping stays XT-PIC on nforce2.
>
>w/o skipping:
>
>  0:     153413    XT-PIC-XT        timer
>  1:         10   IO-APIC-edge      i8042
>  8:          2   IO-APIC-edge      rtc
>  9:          0   IO-APIC-fasteoi   acpi
> 12:        112   IO-APIC-edge      i8042
> 14:         37   IO-APIC-edge      ide0
> 16:     165137   IO-APIC-fasteoi   eth0
> 17:          0   IO-APIC-fasteoi   Technisat/B2C2 FlexCop II/IIb/III
> Digital TV PCI Driver
> 18:          0   IO-APIC-fasteoi   NVidia nForce2
> 19:       7922   IO-APIC-fasteoi   nvidia
>NMI:          0
>LOC:     153209
>ERR:          0
>MIS:          0
>
Sort of coming in in the middle of this because I just realized this may have 
something to do with the "exception Emask" errors. I have an NF2, and the 
above 0: type is what I'm getting with, or without, the apparently opposite 
kernel argument, acpi_use_timer_override.  Should I instead be seeing 0: as 
shown below?  If so, what do I change to effect this?  My current .config:

[root@coyote linux-2.6.24]# grep HPET .config
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_HPET=y
# CONFIG_HPET_RTC_IRQ is not set
# CONFIG_HPET_MMAP is not set

Thanks.

>w/ skipping:
>           CPU0
>  0:      47834   IO-APIC-edge      timer
>  1:         10   IO-APIC-edge      i8042
>  8:          2   IO-APIC-edge      rtc
>  9:          0   IO-APIC-fasteoi   acpi
> 12:        112   IO-APIC-edge      i8042
> 14:         37   IO-APIC-edge      ide0
> 16:     152413   IO-APIC-fasteoi   eth0
> 17:          0   IO-APIC-fasteoi   Technisat/B2C2 FlexCop II/IIb/III
> Digital TV PCI Driver
> 18:          0   IO-APIC-fasteoi   NVidia nForce2
> 19:       1582   IO-APIC-fasteoi   nvidia
>NMI:          0
>LOC:      47736
>ERR:          0
>MIS:          0
>
>
>lspci -n:
>00:00.0 0600: 10de:01e0 (rev c1)
>00:00.1 0500: 10de:01eb (rev c1)
>00:00.2 0500: 10de:01ee (rev c1)
>00:00.3 0500: 10de:01ed (rev c1)
>00:00.4 0500: 10de:01ec (rev c1)
>00:00.5 0500: 10de:01ef (rev c1)
>00:01.0 0601: 10de:0060 (rev a3)
>00:01.1 0c05: 10de:0064 (rev a2)
>00:02.0 0c03: 10de:0067 (rev a3)
>00:02.1 0c03: 10de:0067 (rev a3)
>00:02.2 0c03: 10de:0068 (rev a3)
>00:04.0 0200: 10de:0066 (rev a1)
>00:05.0 0401: 10de:006b (rev a2)
>00:06.0 0401: 10de:006a (rev a1)
>00:08.0 0604: 10de:006c (rev a3)
>00:09.0 0101: 10de:0065 (rev a2)
>00:0d.0 0c00: 10de:006e (rev a3)
>00:1e.0 0604: 10de:01e8 (rev c1)
>01:08.0 0280: 13d0:2103 (rev 01)
>02:00.0 0300: 10de:0281 (rev a1)
>
>> I'm a little sceptical because we had this patch in OpenSUSE 10.3
>> and I didn't think there were complaints from NF2 users.
>> With the changes you're requesting it turns from something
>> very well tested into something experimental.
>
>Well, even w/o the skipping my nforce2 system wasn't unstable, AFAIK. So I
>don't think just because of the XT-PIC entry people would complain.
>
>See why I don't want the quirk to be applied more than needed? *NOT*
> applying the quirk on nforce2 didn't cause any obvious side effects.
> APPLYING to mcp51 causes hard lock-ups.
>
>> But NF2 should not need a timer override anyways so probably
>> ignoring it there is ok.
>>
>> Actually checking CK804 is already an Nforce2, but you might
>> have NF2S which has a different ID. Do you have full lspci/lspci -n
>> output?
>
>My nforce2 board has different id then the listed ones, so that one needs to
>be included.
>
>> Ok I'm appending another patch that adds the NF2S too, can
>> you please test it on that machine?
>
>No point if the quirk doesn't get triggered.
>
>> > > I'm appending a revised patch. Does it work for you?
>> >
>> > I haven't tested it, but it would "work" as it would bail out in my case
>>
>> Can you please test it?
>
>Will try the final version...
>
>> > or not. Are you actually sure that so many nforceX boards have broken
>> > bioses?
>>
>> Yes, it was a problem in the Nvidia reference BIOS that they sent to OEMs
>> to base their own BIOS on, so pretty much everybody had this problem.
>>
>> We went over this with Nvidia engineers with a fine comb at this
>> point. If you search the mailing list archives you might even
>> find the discussions.
>
>Yes, I actually linked to that discussion in the previous mail and there
> Allen Martin only stated that nforce2 and 3 may be affected. So I wonder
> why you (or Len) include nforce4 and mcp51 and so on?
>
>Can't the quirk be made more intelligent? Ie. if we want APIC mode and timer
>stays as XT-PIC, then and only then rewire the timer and don't use the
>override, ie apply quirk? If rewiring isn't possible, then the kernel should
>als least print out a big fat warning that the user should probably skip the
>override. I don't know enough on the subject to explain it more precisely.
>
>bye,


-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
You are in a maze of little twisting passages, all alike.

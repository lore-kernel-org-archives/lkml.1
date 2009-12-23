Return-Path: <linux-kernel-owner+w=401wt.eu-S1754430AbZLWP55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430AbZLWP55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 10:57:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753028AbZLWP55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 10:57:57 -0500
Received: from mx2.compro.net ([12.186.155.4]:33078 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859AbZLWP54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 10:57:56 -0500
X-IronPort-AV: E=Sophos;i="4.47,442,1257138000"; 
   d="scan'208";a="4811588"
Message-ID: <4B323E02.4030107@compro.net>
Date: Wed, 23 Dec 2009 10:57:54 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: markh@compro.net
CC: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "fdutils@fdutils.linux.lu" <fdutils@fdutils.linux.lu>,
       "Li, Shaohua" <shaohua.li@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Fdutils] DMA cache consistency bug introduced in 2.6.28 (Was:
 Re: Cannot format floppies under kernel 2.6.*?)
References: <4AFB3962.2020106@ntlworld.com> <4B2A6394.3080705@knaff.lu>		<alpine.LFD.2.00.0912170916420.15740@localhost.locald! omain>		<4B2A98BB.5080406@knaff.lu>		<alpine.LFD.2.00.0912171256560.15740@localhost.localdomain>		<4B2AAC87.5000703@knaff.lu>		<alpine.LFD.2.00.0912171440420.15740@localhost.localdomain>		<4B2ABDC8.6090104@knaff.lu> <4B2B4485.6000305@cfl.rr.com>		<4B2B5F86.1090403@cfl.rr.com>		<alpine.LFD.2.00.0912180716400.3712@localhost.localdomain>		<4B2B9F9F.7040802@compro.net>		<alpine.LFD.2.00.0912180734220.3712@localhost.localdomain>		<4B2BE05B.9050006@compro.net>		<alpine.LFD.2.00.0912181213540.3712@localhost.localdomain>		<4B30E1B4.7000702@compro.net>		<alpine.LFD.2.00.0912220922250.31313@localhost.localdomain>		<4B310879.9050701@compro.net>	<1261525076.16916.4.camel@localhost.localdo main>	<4B3162BC.9000508@cfl.rr.com> <4B3214EC.6020308@compro.net>	<6598A4E21F1DB24D80BF72956484F59802EFD1C6@orsmsx001.amr.corp.intel.com> <4B32386B.2060509@compro.net>
In-Reply-To: <4B32386B.2060509@compro.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2009 10:34 AM, Mark Hounschell wrote:
> On 12/23/2009 10:10 AM, Pallipadi, Venkatesh wrote:
>>  
>>
>>> -----Original Message-----
>>> From: Mark Hounschell [mailto:markh@compro.net] 
>>> Sent: Wednesday, December 23, 2009 5:03 AM
>>> To: Pallipadi, Venkatesh
>>> Cc: dmarkh@cfl.rr.com; Linus Torvalds; Alain Knaff; Linux 
>>> Kernel Mailing List; fdutils@fdutils.linux.lu; Li, Shaohua; Ingo Molnar
>>> Subject: Re: [Fdutils] DMA cache consistency bug introduced in 
>>> 2.6.28 (Was: Re: Cannot format floppies under kernel 2.6.*?)
>>>
>>> On 12/22/2009 07:22 PM, Mark Hounschell wrote:
>>>> On 12/22/2009 06:37 PM, Pallipadi, Venkatesh wrote:
>>>>> On Tue, 2009-12-22 at 09:57 -0800, Mark Hounschell wrote:
>>>>>> On 12/22/2009 12:38 PM, Linus Torvalds wrote:
>>>>>>>
>>>>>>> [ Ingo, Venki and Shaohua added to cc: see the whole 
>>> thread on lkml for 
>>>>>>>   details, but Mark is basically chasing down a situation 
>>> where the floppy 
>>>>>>>   driver seems to have trouble formatting floppies, and 
>>> it happened 
>>>>>>>   between 2.6.27 and .28. The trouble seems to be that a 
>>> DMA transfer of a 
>>>>>>>   memory block transfers the wrong value for the first 
>>> byte of the block.
>>>>>>>
>>>>>>>   Which should be impossible, but whatever. Some part of 
>>> the system has a 
>>>>>>>   cached buffer that isn't flushed.
>>>>>>>
>>>>>>>   What gets _you_ guys involved is that Mark cannot 
>>> reproduce the bug if 
>>>>>>>   HPET is disabled in the BIOS or by using 'nohpet'. He 
>>> found that out by 
>>>>>>>   pure luck while bisecting, because some time during his 
>>> bisect, his 
>>>>>>>   machine wouldn't even boot with HPET.
>>>>>>>
>>>>>>>   So the problem is: with HPET enabled, 2.6.27.4 _used_ 
>>> to work. But 
>>>>>>>   2.6.28 (and current -git) does not.  Any ideas? ]
>>>>>>>
>>>>>>> On Tue, 22 Dec 2009, Mark Hounschell wrote:
>>>>>>>>
>>>>>>>> Ok, I may have something that might help.
>>>>>>>>
>>>>>>>> # git bisect bad
>>>>>>>> 26afe5f2fbf06ea0765aaa316640c4dd472310c0 is the first bad commit
>>>>>>>> commit 26afe5f2fbf06ea0765aaa316640c4dd472310c0
>>>>>>>> Author: venkatesh.pallipadi@intel.com 
>>> <venkatesh.pallipadi@intel.com>
>>>>>>>> Date:   Fri Sep 5 18:02:18 2008 -0700
>>>>>>>>
>>>>>>>>     x86: HPET_MSI Initialise per-cpu HPET timers
>>>>>>>>
>>>>>>>>     Initialize a per CPU HPET MSI timer when possible. 
>>> We retain the HPET
>>>>>>>>     timer 0 (IRQ 0) and timer 1 (IRQ 8) as is when 
>>> legacy mode is being used. We
>>>>>>>>     setup the remaining HPET timers as per CPU MSI based 
>>> timers. This per CPU
>>>>>>>>     timer will eliminate the need for timer broadcasting 
>>> with IRQ 0 when there
>>>>>>>>     is non-functional LAPIC timer across CPU deep C-states.
>>>>>>>>
>>>>>>>>     If there are more CPUs than number of available 
>>> timers, CPUs that do not
>>>>>>>>     find any timer to use will continue using LAPIC and 
>>> IRQ 0 broadcast.
>>>>>>>>
>>>>>>>>     Signed-off-by: Venkatesh Pallipadi 
>>> <venkatesh.pallipadi@intel.com>
>>>>>>>>     Signed-off-by: Shaohua Li <shaohua.li@intel.com>
>>>>>>>>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>>>>>>>
>>>>>>>> And of coarse this was the first commit that I could not 
>>> boot if I had hpet
>>>>>>>> enabled. To get this one to boot (single user mode only) 
>>> I had to add the
>>>>>>>> the quiet cmdline option and following patch from to 
>>> arch/x86/kernel/hpet.c
>>>>>>>>
>>>>>>>> commit  5ceb1a04187553e08c6ab60d30cee7c454ee139a
>>>>>>>>
>>>>>>>> @ -445,7 +445,7 @@ static int hpet_setup_irq(struct 
>>> hpet_dev *dev)
>>>>>>>>  {
>>>>>>>>
>>>>>>>>         if (request_irq(dev->irq, hpet_interrupt_handler,
>>>>>>>> -                       IRQF_SHARED|IRQF_NOBALANCING, 
>>> dev->name, dev))
>>>>>>>> +                       IRQF_DISABLED|IRQF_NOBALANCING, 
>>> dev->name, dev))
>>>>>>>>                 return -1;
>>>>>>>>
>>>>>>>>         disable_irq(dev->irq);
>>>>>>>>
>>>>>>>> AND add the quiet cmdline option.
>>>>>>>
>>>>>>> Ok, so we know why HPET didn't boot for you, and that was 
>>> fixed later (by 
>>>>>>> that 5ceb1a04). But is this also when the floppy started 
>>> mis-behaving?
>>>>>>>
>>>>>>
>>>>>> Commit 26afe5f2fbf06ea0765aaa316640c4dd472310c0 is when 
>>> the floppy stops
>>>>>> working
>>>>>> and also when I could no longer boot with hpet enabled.
>>>>>
>>>>>
>>>>> I am missing something here. Commit 26afe5f2 is where 
>>> system does not
>>>>> boot with HPET or is it where the floppy stops working when you boot
>>>>> with HPET enabled.
>>>>>
>>>>
>>>> As it happens, both happen there. Commit 5ceb1a04 is where it starts
>>>> booting _again_ with hpet enabled. So I took that patch 
>>> (5ceb1a04) and
>>>> applied it to (26afe5f2f) to be able to boot with hpet 
>>> enabled.  I had to
>>>> use the quiet option to get to a login prompt, but there is where the
>>>> floppy format first fails, just as it does in 2.6.28 and up.
>>>>
>>>>> Can you try "idle=halt" with both .27 and .28 with /proc/interrupts
>>>>> output in each case. With that option, we should be using local APIC
>>>>> timer and PIT, HPET or HPET with MSI should not really 
>>> matter. Does it
>>>>> still fail with .28 with that option?
>>>>>
>>>
>>> 2.6.28 still fails with that option.
>>>
>>> 2.6.27.41 /proc/interrupts with idle=halt
>>>
>>>           CPU0       CPU1       CPU2       CPU3
>>>  0:        126          0          0          1   
>>> IO-APIC-edge      timer
>>>  1:          0          0          1        157   
>>> IO-APIC-edge      i8042
>>>  3:          0          0          0          6   IO-APIC-edge
>>>  4:          0          0          0          6   IO-APIC-edge
>>>  6:          0          0          0          4   
>>> IO-APIC-edge      floppy
>>>  8:          0          0          0          1   
>>> IO-APIC-edge      rtc0
>>>  9:          0          0          0          0   
>>> IO-APIC-fasteoi   acpi
>>> 12:          0          0          1        128   
>>> IO-APIC-edge      i8042
>>> 14:          0          0         34       4457   IO-APIC-edge
>>> pata_atiixp
>>> 15:          0          0          4        480   IO-APIC-edge
>>> pata_atiixp
>>> 16:          0          0          0        397   IO-APIC-fasteoi
>>> aic79xx, ohci_hcd:usb3, ohci_hcd:usb4, HDA Intel
>>> 17:          0          0          0          2   IO-APIC-fasteoi
>>> ehci_hcd:usb1
>>> 18:          0          0          0          0   IO-APIC-fasteoi
>>> ohci_hcd:usb5, ohci_hcd:usb6, ohci_hcd:usb7
>>> 19:          0          0          0        142   IO-APIC-fasteoi
>>> aic7xxx, ehci_hcd:usb2, ttySLG0, eth1
>>> 22:          0          0          4       1154   
>>> IO-APIC-fasteoi   ahci
>>> 219:          0          0          3         63   
>>> PCI-MSI-edge      eth0
>>> NMI:          0          0          0          0   
>>> Non-maskable interrupts
>>> LOC:      91539      91964      92525      91181   Local timer 
>>> interrupts
>>> RES:       2888       3873       2434       2721   
>>> Rescheduling interrupts
>>> CAL:        240        245        247         84   function 
>>> call interrupts
>>> TLB:        768        628        526        512   TLB shootdowns
>>> SPU:          0          0          0          0   Spurious interrupts
>>> ERR:          0
>>> MIS:          0
>>>
>>> 2.6.28 /proc/interrupts with idle=halt
>>>
>>>           CPU0       CPU1       CPU2       CPU3
>>>  0:        126          0          2          0   
>>> IO-APIC-edge      timer
>>>  1:          0          0        192          0   
>>> IO-APIC-edge      i8042
>>>  3:          0          0          6          0   IO-APIC-edge
>>>  4:          0          0          6          0   IO-APIC-edge
>>>  6:          0          0          4          0   
>>> IO-APIC-edge      floppy
>>>  8:          0          0          1          0   
>>> IO-APIC-edge      rtc0
>>>  9:          0          0          0          0   
>>> IO-APIC-fasteoi   acpi
>>> 12:          0          0        128          1   
>>> IO-APIC-edge      i8042
>>> 14:          0          1     147114        396   IO-APIC-edge
>>> pata_atiixp
>>> 15:          0          0        646          2   IO-APIC-edge
>>> pata_atiixp
>>> 16:          0          0        396          0   IO-APIC-fasteoi
>>> aic79xx, ohci_hcd:usb2, ohci_hcd:usb4, HDA Intel
>>> 17:          0          0          0          0   IO-APIC-fasteoi
>>> ehci_hcd:usb1
>>> 18:          0          0          0          0   IO-APIC-fasteoi
>>> ohci_hcd:usb5, ohci_hcd:usb6, ohci_hcd:usb7
>>> 19:          0          0        362          1   IO-APIC-fasteoi
>>> aic7xxx, ehci_hcd:usb3, ttySLG0, eth1
>>> 22:          0          0        874          1   
>>> IO-APIC-fasteoi   ahci
>>> 1274:          0          0        193          4   
>>> PCI-MSI-edge      eth0
>>> 1279:     513207          0          0          0  
>>> HPET_MSI-edge      hpet2
>>> NMI:          0          0          0          0   
>>> Non-maskable interrupts
>>> LOC:        268     513395     513138     522088   Local timer 
>>> interrupts
>>> RES:       3262       3679       2573       3746   
>>> Rescheduling interrupts
>>> CAL:        131        166         57        147   Function 
>>> call interrupts
>>> TLB:        680        438        450        639   TLB shootdowns
>>> SPU:          0          0          0          0   Spurious interrupts
>>> ERR:          0
>>> MIS:          0
>>>
>>
>> Hmm. Looks like hpet2 is still getting used instead of local APIC timer in .28 case.
>>
>> I was expecting some low number in hpet2 and local timer on all CPU to be around the same value. Above shows CPU 0 is depending on hpet2 for some reason even with idle=halt. Can you send the output of below two in case of .28
>> /proc/timer_list
> 
> Attached.
> 
>> grep . /sys/devices/system/cpu/cpu0/cpuidle/*/*
> 
> I have no /sys/devices/system/cpu/cpu0/cpuidle on this machine.
> Maybe because of
> 
> #
> # CPU Frequency scaling
> #
> # CONFIG_CPU_FREQ is not set
> # CONFIG_CPU_IDLE is not set
> 
> Would it be OK if when you ask for 2.6.28 info, I use a 2.6.32.2 kernel?
> That kernel also fails fdformat with hpet enabled on these machines.
> 

I do have this on 2.6.32.2 though.

# grep . /sys/devices/system/cpu/cpuidle/current_*
/sys/devices/system/cpu/cpuidle/current_driver:acpi_idle
/sys/devices/system/cpu/cpuidle/current_governor_ro:ladder

Want me to go back to 2.6.28 and show this?

Mark


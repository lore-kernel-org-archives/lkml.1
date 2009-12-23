Return-Path: <linux-kernel-owner+w=401wt.eu-S1753696AbZLWPeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbZLWPeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 10:34:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbZLWPeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 10:34:08 -0500
Received: from mx2.compro.net ([12.186.155.4]:57927 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbZLWPeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 10:34:07 -0500
X-IronPort-AV: E=Sophos;i="4.47,442,1257138000"; 
   d="txt'?scan'208";a="4811492"
Message-ID: <4B32386B.2060509@compro.net>
Date: Wed, 23 Dec 2009 10:34:03 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
CC: "dmarkh@cfl.rr.com" <dmarkh@cfl.rr.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alain Knaff <alain@knaff.lu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "fdutils@fdutils.linux.lu" <fdutils@fdutils.linux.lu>,
       "Li, Shaohua" <shaohua.li@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Fdutils] DMA cache consistency bug introduced in 2.6.28 (Was:
 Re: Cannot format floppies under kernel 2.6.*?)
References: <4AFB3962.2020106@ntlworld.com> <4B2A530D.3080606@knaff! .lu>	 <4B2A6394.3080705@knaff.lu>	 <alpine.LFD.2.00.0912170916420.15740@localhost.locald! omain>	 <4B2A98BB.5080406@knaff.lu>	 <alpine.LFD.2.00.0912171256560.15740@localhost.localdomain>	 <4B2AAC87.5000703@knaff.lu>	 <alpine.LFD.2.00.0912171440420.15740@localhost.localdomain>	 <4B2ABDC8.6090104@knaff.lu> <4B2B4485.6000305@cfl.rr.com>	 <4B2B5F86.1090403@cfl.rr.com>	 <alpine.LFD.2.00.0912180716400.3712@localhost.localdomain>	 <4B2B9F9F.7040802@compro.net>	 <alpine.LFD.2.00.0912180734220.3712@localhost.localdomain>	 <4B2BE05B.9050006@compro.net>	 <alpine.LFD.2.00.0912181213540.3712@localhost.localdomain>	 <4B30E1B4.7000702@compro.net>	 <alpine.LFD.2.00.0912220922250.31313@localhost.localdomain>	 <4B310879.9050701@compro.net> <1261525076.16916.4.camel@localhost.localdo main> <4B3162BC.9000508@cfl.rr.com> <4B3214EC.6020308@compro.net> <6598A4E21F1DB24D80BF72956484F59802EFD1C6@orsmsx001.amr.corp.intel.com>
In-Reply-To: <6598A4E21F1DB24D80BF72956484F59802EFD1C6@orsmsx001.amr.corp.intel.com>
Content-Type: multipart/mixed;
 boundary="------------000301000203010605090802"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000301000203010605090802
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 12/23/2009 10:10 AM, Pallipadi, Venkatesh wrote:
>  
> 
>> -----Original Message-----
>> From: Mark Hounschell [mailto:markh@compro.net] 
>> Sent: Wednesday, December 23, 2009 5:03 AM
>> To: Pallipadi, Venkatesh
>> Cc: dmarkh@cfl.rr.com; Linus Torvalds; Alain Knaff; Linux 
>> Kernel Mailing List; fdutils@fdutils.linux.lu; Li, Shaohua; Ingo Molnar
>> Subject: Re: [Fdutils] DMA cache consistency bug introduced in 
>> 2.6.28 (Was: Re: Cannot format floppies under kernel 2.6.*?)
>>
>> On 12/22/2009 07:22 PM, Mark Hounschell wrote:
>>> On 12/22/2009 06:37 PM, Pallipadi, Venkatesh wrote:
>>>> On Tue, 2009-12-22 at 09:57 -0800, Mark Hounschell wrote:
>>>>> On 12/22/2009 12:38 PM, Linus Torvalds wrote:
>>>>>>
>>>>>> [ Ingo, Venki and Shaohua added to cc: see the whole 
>> thread on lkml for 
>>>>>>   details, but Mark is basically chasing down a situation 
>> where the floppy 
>>>>>>   driver seems to have trouble formatting floppies, and 
>> it happened 
>>>>>>   between 2.6.27 and .28. The trouble seems to be that a 
>> DMA transfer of a 
>>>>>>   memory block transfers the wrong value for the first 
>> byte of the block.
>>>>>>
>>>>>>   Which should be impossible, but whatever. Some part of 
>> the system has a 
>>>>>>   cached buffer that isn't flushed.
>>>>>>
>>>>>>   What gets _you_ guys involved is that Mark cannot 
>> reproduce the bug if 
>>>>>>   HPET is disabled in the BIOS or by using 'nohpet'. He 
>> found that out by 
>>>>>>   pure luck while bisecting, because some time during his 
>> bisect, his 
>>>>>>   machine wouldn't even boot with HPET.
>>>>>>
>>>>>>   So the problem is: with HPET enabled, 2.6.27.4 _used_ 
>> to work. But 
>>>>>>   2.6.28 (and current -git) does not.  Any ideas? ]
>>>>>>
>>>>>> On Tue, 22 Dec 2009, Mark Hounschell wrote:
>>>>>>>
>>>>>>> Ok, I may have something that might help.
>>>>>>>
>>>>>>> # git bisect bad
>>>>>>> 26afe5f2fbf06ea0765aaa316640c4dd472310c0 is the first bad commit
>>>>>>> commit 26afe5f2fbf06ea0765aaa316640c4dd472310c0
>>>>>>> Author: venkatesh.pallipadi@intel.com 
>> <venkatesh.pallipadi@intel.com>
>>>>>>> Date:   Fri Sep 5 18:02:18 2008 -0700
>>>>>>>
>>>>>>>     x86: HPET_MSI Initialise per-cpu HPET timers
>>>>>>>
>>>>>>>     Initialize a per CPU HPET MSI timer when possible. 
>> We retain the HPET
>>>>>>>     timer 0 (IRQ 0) and timer 1 (IRQ 8) as is when 
>> legacy mode is being used. We
>>>>>>>     setup the remaining HPET timers as per CPU MSI based 
>> timers. This per CPU
>>>>>>>     timer will eliminate the need for timer broadcasting 
>> with IRQ 0 when there
>>>>>>>     is non-functional LAPIC timer across CPU deep C-states.
>>>>>>>
>>>>>>>     If there are more CPUs than number of available 
>> timers, CPUs that do not
>>>>>>>     find any timer to use will continue using LAPIC and 
>> IRQ 0 broadcast.
>>>>>>>
>>>>>>>     Signed-off-by: Venkatesh Pallipadi 
>> <venkatesh.pallipadi@intel.com>
>>>>>>>     Signed-off-by: Shaohua Li <shaohua.li@intel.com>
>>>>>>>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>>>>>>
>>>>>>> And of coarse this was the first commit that I could not 
>> boot if I had hpet
>>>>>>> enabled. To get this one to boot (single user mode only) 
>> I had to add the
>>>>>>> the quiet cmdline option and following patch from to 
>> arch/x86/kernel/hpet.c
>>>>>>>
>>>>>>> commit  5ceb1a04187553e08c6ab60d30cee7c454ee139a
>>>>>>>
>>>>>>> @ -445,7 +445,7 @@ static int hpet_setup_irq(struct 
>> hpet_dev *dev)
>>>>>>>  {
>>>>>>>
>>>>>>>         if (request_irq(dev->irq, hpet_interrupt_handler,
>>>>>>> -                       IRQF_SHARED|IRQF_NOBALANCING, 
>> dev->name, dev))
>>>>>>> +                       IRQF_DISABLED|IRQF_NOBALANCING, 
>> dev->name, dev))
>>>>>>>                 return -1;
>>>>>>>
>>>>>>>         disable_irq(dev->irq);
>>>>>>>
>>>>>>> AND add the quiet cmdline option.
>>>>>>
>>>>>> Ok, so we know why HPET didn't boot for you, and that was 
>> fixed later (by 
>>>>>> that 5ceb1a04). But is this also when the floppy started 
>> mis-behaving?
>>>>>>
>>>>>
>>>>> Commit 26afe5f2fbf06ea0765aaa316640c4dd472310c0 is when 
>> the floppy stops
>>>>> working
>>>>> and also when I could no longer boot with hpet enabled.
>>>>
>>>>
>>>> I am missing something here. Commit 26afe5f2 is where 
>> system does not
>>>> boot with HPET or is it where the floppy stops working when you boot
>>>> with HPET enabled.
>>>>
>>>
>>> As it happens, both happen there. Commit 5ceb1a04 is where it starts
>>> booting _again_ with hpet enabled. So I took that patch 
>> (5ceb1a04) and
>>> applied it to (26afe5f2f) to be able to boot with hpet 
>> enabled.  I had to
>>> use the quiet option to get to a login prompt, but there is where the
>>> floppy format first fails, just as it does in 2.6.28 and up.
>>>
>>>> Can you try "idle=halt" with both .27 and .28 with /proc/interrupts
>>>> output in each case. With that option, we should be using local APIC
>>>> timer and PIT, HPET or HPET with MSI should not really 
>> matter. Does it
>>>> still fail with .28 with that option?
>>>>
>>
>> 2.6.28 still fails with that option.
>>
>> 2.6.27.41 /proc/interrupts with idle=halt
>>
>>           CPU0       CPU1       CPU2       CPU3
>>  0:        126          0          0          1   
>> IO-APIC-edge      timer
>>  1:          0          0          1        157   
>> IO-APIC-edge      i8042
>>  3:          0          0          0          6   IO-APIC-edge
>>  4:          0          0          0          6   IO-APIC-edge
>>  6:          0          0          0          4   
>> IO-APIC-edge      floppy
>>  8:          0          0          0          1   
>> IO-APIC-edge      rtc0
>>  9:          0          0          0          0   
>> IO-APIC-fasteoi   acpi
>> 12:          0          0          1        128   
>> IO-APIC-edge      i8042
>> 14:          0          0         34       4457   IO-APIC-edge
>> pata_atiixp
>> 15:          0          0          4        480   IO-APIC-edge
>> pata_atiixp
>> 16:          0          0          0        397   IO-APIC-fasteoi
>> aic79xx, ohci_hcd:usb3, ohci_hcd:usb4, HDA Intel
>> 17:          0          0          0          2   IO-APIC-fasteoi
>> ehci_hcd:usb1
>> 18:          0          0          0          0   IO-APIC-fasteoi
>> ohci_hcd:usb5, ohci_hcd:usb6, ohci_hcd:usb7
>> 19:          0          0          0        142   IO-APIC-fasteoi
>> aic7xxx, ehci_hcd:usb2, ttySLG0, eth1
>> 22:          0          0          4       1154   
>> IO-APIC-fasteoi   ahci
>> 219:          0          0          3         63   
>> PCI-MSI-edge      eth0
>> NMI:          0          0          0          0   
>> Non-maskable interrupts
>> LOC:      91539      91964      92525      91181   Local timer 
>> interrupts
>> RES:       2888       3873       2434       2721   
>> Rescheduling interrupts
>> CAL:        240        245        247         84   function 
>> call interrupts
>> TLB:        768        628        526        512   TLB shootdowns
>> SPU:          0          0          0          0   Spurious interrupts
>> ERR:          0
>> MIS:          0
>>
>> 2.6.28 /proc/interrupts with idle=halt
>>
>>           CPU0       CPU1       CPU2       CPU3
>>  0:        126          0          2          0   
>> IO-APIC-edge      timer
>>  1:          0          0        192          0   
>> IO-APIC-edge      i8042
>>  3:          0          0          6          0   IO-APIC-edge
>>  4:          0          0          6          0   IO-APIC-edge
>>  6:          0          0          4          0   
>> IO-APIC-edge      floppy
>>  8:          0          0          1          0   
>> IO-APIC-edge      rtc0
>>  9:          0          0          0          0   
>> IO-APIC-fasteoi   acpi
>> 12:          0          0        128          1   
>> IO-APIC-edge      i8042
>> 14:          0          1     147114        396   IO-APIC-edge
>> pata_atiixp
>> 15:          0          0        646          2   IO-APIC-edge
>> pata_atiixp
>> 16:          0          0        396          0   IO-APIC-fasteoi
>> aic79xx, ohci_hcd:usb2, ohci_hcd:usb4, HDA Intel
>> 17:          0          0          0          0   IO-APIC-fasteoi
>> ehci_hcd:usb1
>> 18:          0          0          0          0   IO-APIC-fasteoi
>> ohci_hcd:usb5, ohci_hcd:usb6, ohci_hcd:usb7
>> 19:          0          0        362          1   IO-APIC-fasteoi
>> aic7xxx, ehci_hcd:usb3, ttySLG0, eth1
>> 22:          0          0        874          1   
>> IO-APIC-fasteoi   ahci
>> 1274:          0          0        193          4   
>> PCI-MSI-edge      eth0
>> 1279:     513207          0          0          0  
>> HPET_MSI-edge      hpet2
>> NMI:          0          0          0          0   
>> Non-maskable interrupts
>> LOC:        268     513395     513138     522088   Local timer 
>> interrupts
>> RES:       3262       3679       2573       3746   
>> Rescheduling interrupts
>> CAL:        131        166         57        147   Function 
>> call interrupts
>> TLB:        680        438        450        639   TLB shootdowns
>> SPU:          0          0          0          0   Spurious interrupts
>> ERR:          0
>> MIS:          0
>>
> 
> Hmm. Looks like hpet2 is still getting used instead of local APIC timer in .28 case.
> 
> I was expecting some low number in hpet2 and local timer on all CPU to be around the same value. Above shows CPU 0 is depending on hpet2 for some reason even with idle=halt. Can you send the output of below two in case of .28
> /proc/timer_list

Attached.

> grep . /sys/devices/system/cpu/cpu0/cpuidle/*/*

I have no /sys/devices/system/cpu/cpu0/cpuidle on this machine.
Maybe because of

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
# CONFIG_CPU_IDLE is not set

Would it be OK if when you ask for 2.6.28 info, I use a 2.6.32.2 kernel?
That kernel also fails fdformat with hpet enabled on these machines.

Thanks
Mark

--------------000301000203010605090802
Content-Type: text/plain;
 name="timer_list.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="timer_list.txt"

Timer List Version: v0.4
HRTIMER_MAX_CLOCK_BASES: 2
now at 123990857169 nsecs

cpu: 0
 clock 0:
  .base:       c2a13320
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1261581506376548727 nsecs
active timers:
 clock 1:
  .base:       c2a1334c
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <c2a133a4>, tick_sched_timer, S:01
 # expires at 123991000000-123991000000 nsecs [in 142831 to 142831 nsecs]
 #1: <f1987544>, it_real_fn, S:01
 # expires at 124645673184-124645673184 nsecs [in 654816015 to 654816015 nsecs]
 #2: <f2823b4c>, hrtimer_wakeup, S:01
 # expires at 125434022644-125439022643 nsecs [in 1443165475 to 1448165474 nsecs]
 #3: <f1ab3e94>, hrtimer_wakeup, S:01
 # expires at 3668872852847-3668872902847 nsecs [in 3544881995678 to 3544882045678 nsecs]
 #4: <f2269b4c>, hrtimer_wakeup, S:01
 # expires at 4295018153722969-4295018153772969 nsecs [in 4294894162865800 to 4294894162915800 nsecs]
  .expires_next   : 123991000000 nsecs
  .hres_active    : 1
  .nr_events      : 125349
  .nohz_mode      : 0
  .idle_tick      : 0 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 0
  .idle_calls     : 0
  .idle_sleeps    : 0
  .idle_entrytime : 0 nsecs
  .idle_waketime  : 0 nsecs
  .idle_exittime  : 0 nsecs
  .idle_sleeptime : 0 nsecs
  .last_jiffies   : 0
  .next_jiffies   : 0
  .idle_expires   : 0 nsecs
jiffies: 4294791286

cpu: 1
 clock 0:
  .base:       c2a1c320
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1261581506376548727 nsecs
active timers:
 clock 1:
  .base:       c2a1c34c
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <c2a1c3a4>, tick_sched_timer, S:01
 # expires at 123991125000-123991125000 nsecs [in 267831 to 267831 nsecs]
 #1: <c043b230>, sched_rt_period_timer, S:01
 # expires at 124000000000-124000000000 nsecs [in 9142831 to 9142831 nsecs]
 #2: <f1ab5bc4>, hrtimer_wakeup, S:01
 # expires at 129199139399-129219139398 nsecs [in 5208282230 to 5228282229 nsecs]
 #3: <f1a77b4c>, hrtimer_wakeup, S:01
 # expires at 139203140160-139233140159 nsecs [in 15212282991 to 15242282990 nsecs]
 #4: <f1aade94>, hrtimer_wakeup, S:01
 # expires at 28868872949729-28868872999729 nsecs [in 28744882092560 to 28744882142560 nsecs]
  .expires_next   : 123991125000 nsecs
  .hres_active    : 1
  .nr_events      : 123377
  .nohz_mode      : 0
  .idle_tick      : 0 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 0
  .idle_calls     : 0
  .idle_sleeps    : 0
  .idle_entrytime : 0 nsecs
  .idle_waketime  : 0 nsecs
  .idle_exittime  : 0 nsecs
  .idle_sleeptime : 0 nsecs
  .last_jiffies   : 0
  .next_jiffies   : 0
  .idle_expires   : 0 nsecs
jiffies: 4294791286

cpu: 2
 clock 0:
  .base:       c2a25320
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1261581506376548727 nsecs
active timers:
 clock 1:
  .base:       c2a2534c
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <c2a253a4>, tick_sched_timer, S:01
 # expires at 123991250000-123991250000 nsecs [in 392831 to 392831 nsecs]
 #1: <f1eb9bc4>, hrtimer_wakeup, S:01
 # expires at 124623691750-124625680749 nsecs [in 632834581 to 634823580 nsecs]
 #2: <f1f7dbc4>, hrtimer_wakeup, S:01
 # expires at 127624283651-127628265650 nsecs [in 3633426482 to 3637408481 nsecs]
 #3: <f1cf1bc4>, hrtimer_wakeup, S:01
 # expires at 136624366877-136654360876 nsecs [in 12633509708 to 12663503707 nsecs]
 #4: <f1ad7bc4>, hrtimer_wakeup, S:01
 # expires at 153654620007-153692611006 nsecs [in 29663762838 to 29701753837 nsecs]
 #5: <f1b25f58>, hrtimer_wakeup, S:01
 # expires at 155514242261-155514292261 nsecs [in 31523385092 to 31523435092 nsecs]
 #6: <f198de94>, hrtimer_wakeup, S:01
 # expires at 668873371418-668873421418 nsecs [in 544882514249 to 544882564249 nsecs]
 #7: <f1f3fb4c>, hrtimer_wakeup, S:01
 # expires at 86508836731823-86508936731823 nsecs [in 86384845874654 to 86384945874654 nsecs]
  .expires_next   : 123991250000 nsecs
  .hres_active    : 1
  .nr_events      : 123166
  .nohz_mode      : 0
  .idle_tick      : 0 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 0
  .idle_calls     : 0
  .idle_sleeps    : 0
  .idle_entrytime : 0 nsecs
  .idle_waketime  : 0 nsecs
  .idle_exittime  : 0 nsecs
  .idle_sleeptime : 0 nsecs
  .last_jiffies   : 0
  .next_jiffies   : 0
  .idle_expires   : 0 nsecs
jiffies: 4294791286

cpu: 3
 clock 0:
  .base:       c2a2e320
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1261581506376548727 nsecs
active timers:
 clock 1:
  .base:       c2a2e34c
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <c2a2e3a4>, tick_sched_timer, S:01
 # expires at 123991375000-123991375000 nsecs [in 517831 to 517831 nsecs]
 #1: <f1935bc4>, hrtimer_wakeup, S:01
 # expires at 124624395215-124626393214 nsecs [in 633538046 to 635536045 nsecs]
 #2: <f1aafbc4>, hrtimer_wakeup, S:01
 # expires at 169815643582-169875643581 nsecs [in 45824786413 to 45884786412 nsecs]
 #3: <f23cdbc4>, hrtimer_wakeup, S:01
 # expires at 346123697800-346223697800 nsecs [in 222132840631 to 222232840631 nsecs]
 #4: <f1b04204>, it_real_fn, S:01
 # expires at 403383744722-403383744722 nsecs [in 279392887553 to 279392887553 nsecs]
 #5: <f1b09e04>, it_real_fn, S:01
 # expires at 403383795968-403383795968 nsecs [in 279392938799 to 279392938799 nsecs]
 #6: <f19871c4>, it_real_fn, S:01
 # expires at 403383804795-403383804795 nsecs [in 279392947626 to 279392947626 nsecs]
 #7: <f199be94>, hrtimer_wakeup, S:01
 # expires at 668872854209-668872904209 nsecs [in 544881997040 to 544882047040 nsecs]
  .expires_next   : 123991375000 nsecs
  .hres_active    : 1
  .nr_events      : 122962
  .nohz_mode      : 0
  .idle_tick      : 0 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 0
  .idle_calls     : 0
  .idle_sleeps    : 0
  .idle_entrytime : 0 nsecs
  .idle_waketime  : 0 nsecs
  .idle_exittime  : 0 nsecs
  .idle_sleeptime : 0 nsecs
  .last_jiffies   : 0
  .next_jiffies   : 0
  .idle_expires   : 0 nsecs
jiffies: 4294791286


Tick Device: mode:     1
Broadcast device
Clock Event Device: hpet
 max_delta_ns:   2147483647
 min_delta_ns:   5000
 mult:           61510048
 shift:          32
 mode:           3
 next_event:     9223372036854775807 nsecs
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode
 event_handler:  tick_handle_oneshot_broadcast
tick_broadcast_mask: 00000000
tick_broadcast_oneshot_mask: 00000000


Tick Device: mode:     1
Per CPU device: 0
Clock Event Device: hpet2
 max_delta_ns:   2147483647
 min_delta_ns:   5000
 mult:           61510047
 shift:          32
 mode:           3
 next_event:     123991000000 nsecs
 set_next_event: hpet_msi_next_event
 set_mode:       hpet_msi_set_mode
 event_handler:  hrtimer_interrupt

Tick Device: mode:     1
Per CPU device: 1
Clock Event Device: lapic
 max_delta_ns:   670831998
 min_delta_ns:   1199
 mult:           53707624
 shift:          32
 mode:           3
 next_event:     123991125000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

Tick Device: mode:     1
Per CPU device: 2
Clock Event Device: lapic
 max_delta_ns:   670831998
 min_delta_ns:   1199
 mult:           53707624
 shift:          32
 mode:           3
 next_event:     123991250000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

Tick Device: mode:     1
Per CPU device: 3
Clock Event Device: lapic
 max_delta_ns:   670831998
 min_delta_ns:   1199
 mult:           53707624
 shift:          32
 mode:           3
 next_event:     123991375000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt


--------------000301000203010605090802--

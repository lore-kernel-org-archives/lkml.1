Return-Path: <linux-kernel-owner+w=401wt.eu-S1754983AbYCXWdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbYCXWdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 18:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbYCXWdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 18:33:14 -0400
Received: from fonzie.hosting9000.com ([85.214.50.12]:36786 "EHLO
	fonzie.hosting9000.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbYCXWdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 18:33:14 -0400
Message-ID: <47E82C1F.7070304@frugalware.org>
Date: Mon, 24 Mar 2008 23:33:03 +0100
From: Gabriel C <crazy@frugalware.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Gabriel C <nix.or.die@googlemail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, andi-bz@firstfloor.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc5-git6: Reported regressions from 2.6.24
References: <200803170018.52663.rjw@sisk.pl> <47E3D322.1090902@googlemail.com> <alpine.LFD.1.00.0803211720340.3781@apollo.tec.linutronix.de> <47E3E66F.9040006@frugalware.org> <47E3FA4F.9060509@frugalware.org> <alpine.LFD.1.00.0803211944250.3781@apollo.tec.linutronix.de> <47E40B1C.30407@frugalware.org> <47E420C5.1050407@frugalware.org> <alpine.LFD.1.00.0803212208300.3781@apollo.tec.linutronix.de> <47E42FAB.6000906@frugalware.org> <alpine.LFD.1.00.0803212302390.3781@apollo.tec.linutronix.de> <alpine.LFD.1.00.0803220847020.3781@apollo.tec.linutronix.de> <47E50AF9.5070801@frugalware.org> <alpine.LFD.1.00.0803221441370.3781@apollo.tec.linutronix.de> <47E5221B.5040900@frugalware.org> <alpine.LFD.1.00.0803221730560.3781@apollo.tec.linutronix.de> <alpine.LFD.1.00.0803222113541.3781@apollo.tec.linutronix.de> <47E58B06.8020905@frugalware.org> <47E63851.7000702@frugalware.org> <47E6E85E.9030008@frugalware.org> <alpine.LFD.1.00.0803241038420.3781@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.00.0803241038420.3781@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Mon, 24 Mar 2008, Gabriel C wrote:
>>>>> Can you please give it a test ride ?
>>>> Done , git head + Andi's patch + this version of your patch does work here.
>>>>
>>>> Also time-warp-test is just fine and everything else seems to work.
>>> Also I've tested with my other motherboard and is fine too :)
>>>
>>> Feel free to add my Tested-by when you push this patch.
>> Heh :/
>>
>> ...
>>
>> [ 5902.632878] Clocksource tsc unstable (delta = 4686687272 ns)
>> [ 5920.650516] Time: acpi_pm clocksource has been installed.
>>
>> ...
>>
>> Seems like something still triggers that :/ 
> 
> Hmm. Can you please apply the patch below. It add some more info and
> triggers the sysrq-q timer list printout when the watchdog
> triggers. That might us give some insight into this.

Sorry for the lag , I was out the whole day.

Here is what I've found in dmesg ( the box was idling at that time , as said I was not around ):

...

[34528.893366] Clocksource tsc unstable (delta = 4686697613 ns) E:34204592 J:34210723
[34528.893380] Timer List Version: v0.3
[34528.893386] HRTIMER_MAX_CLOCK_BASES: 2
[34528.893392] now at 34510722407314 nsecs
[34528.893396]
[34528.893399] cpu: 0
[34528.893402]  clock 0:
[34528.893404]   .index:      0
[34528.893407]   .resolution: 1 nsecs
[34528.893409]   .get_time:   ktime_get_real
[34528.893422]   .offset:     1206358214734619011 nsecs
[34528.893425] active timers:
[34528.893428]  clock 1:
[34528.893430]   .index:      1
[34528.893433]   .resolution: 1 nsecs
[34528.893435]   .get_time:   ktime_get
[34528.893440]   .offset:     0 nsecs
[34528.893443] active timers:
[34528.893445]  #0: <e26a7d68>, tick_sched_timer, S:01
[34528.893467]  # expires at 34510723000000 nsecs [in 592686 nsecs]
[34528.893470]  #1: <e26a7d68>, it_real_fn, S:01
[34528.893481]  # expires at 34510724648354 nsecs [in 2241040 nsecs]
[34528.893485]  #2: <e26a7d68>, hrtimer_wakeup, S:01
[34528.893495]  # expires at 34510997616597 nsecs [in 275209283 nsecs]
[34528.893498]  #3: <e26a7d68>, hrtimer_wakeup, S:01
[34528.893508]  # expires at 34511115498292 nsecs [in 393090978 nsecs]
[34528.893512]  #4: <e26a7d68>, hrtimer_wakeup, S:01
[34528.893521]  # expires at 34511328809630 nsecs [in 606402316 nsecs]
[34528.893525]  #5: <e26a7d68>, it_real_fn, S:01
[34528.893534]  # expires at 34511515619673 nsecs [in 793212359 nsecs]
[34528.893537]  #6: <e26a7d68>, hrtimer_wakeup, S:01
[34528.893547]  # expires at 34512265383335 nsecs [in 1542976021 nsecs]
[34528.893551]  #7: <e26a7d68>, hrtimer_wakeup, S:01
[34528.893561]  # expires at 34518835323224 nsecs [in 8112915910 nsecs]
[34528.893564]  #8: <e26a7d68>, hrtimer_wakeup, S:01
[34528.893574]  # expires at 34546891223588 nsecs [in 36168816274 nsecs]
[34528.893578]  #9: <e26a7d68>, hrtimer_wakeup, S:01
[34528.893588]  # expires at 36035545999324 nsecs [in 1524823592010 nsecs]
[34528.893592]  #10: <e26a7d68>, hrtimer_wakeup, S:01
[34528.893601]  # expires at 36035980869577 nsecs [in 1525258462263 nsecs]
[34528.893606]   .expires_next   : 34510723000000 nsecs
[34528.893609]   .hres_active    : 1
[34528.893612]   .nr_events      : 3447408
[34528.893615]   .nohz_mode      : 2
[34528.893618]   .idle_tick      : 34510712000000 nsecs
[34528.893621]   .tick_stopped   : 0
[34528.893624]   .idle_jiffies   : 34210712
[34528.893627]   .idle_calls     : 3267634
[34528.893630]   .idle_sleeps    : 1588325
[34528.893633]   .idle_entrytime : 34510722486118 nsecs
[34528.893636]   .idle_waketime  : 34510722348607 nsecs
[34528.893640]   .idle_exittime  : 34510722383780 nsecs
[34528.893643]   .idle_sleeptime : 33379861006002 nsecs
[34528.893646]   .last_jiffies   : 34210723
[34528.893649]   .next_jiffies   : 34210725
[34528.893652]   .idle_expires   : 34510724000000 nsecs
[34528.893655] jiffies: 34210723
[34528.893657]
[34528.893660] cpu: 1
[34528.893662]  clock 0:
[34528.893664]   .index:      0
[34528.893666]   .resolution: 1 nsecs
[34528.893669]   .get_time:   ktime_get_real
[34528.893675]   .offset:     1206358214734619011 nsecs
[34528.893677] active timers:
[34528.893680]  clock 1:
[34528.893682]   .index:      1
[34528.893685]   .resolution: 1 nsecs
[34528.893687]   .get_time:   ktime_get
[34528.893692]   .offset:     0 nsecs
[34528.893694] active timers:
[34528.893697]  #0: <e26a7d68>, tick_sched_timer, S:01
[34528.893706]  # expires at 34510996000000 nsecs [in 273592686 nsecs]
[34528.893710]   .expires_next   : 34510996000000 nsecs
[34528.893713]   .hres_active    : 1
[34528.893716]   .nr_events      : 3081558
[34528.893719]   .nohz_mode      : 2
[34528.893722]   .idle_tick      : 34510713125000 nsecs
[34528.893725]   .tick_stopped   : 1
[34528.893727]   .idle_jiffies   : 34210713
[34528.893730]   .idle_calls     : 2673472
[34528.893733]   .idle_sleeps    : 1233326
[34528.893736]   .idle_entrytime : 34510712135468 nsecs
[34528.893740]   .idle_waketime  : 34507995998292 nsecs
[34528.893743]   .idle_exittime  : 34510711012024 nsecs
[34528.893746]   .idle_sleeptime : 33654735968486 nsecs
[34528.893749]   .last_jiffies   : 34210713
[34528.893752]   .next_jiffies   : 34210997
[34528.893755]   .idle_expires   : 34510996000000 nsecs
[34528.893758] jiffies: 34210723
[34528.893760]
[34528.893763] cpu: 2
[34528.893765]  clock 0:
[34528.893767]   .index:      0
[34528.893769]   .resolution: 1 nsecs
[34528.893772]   .get_time:   ktime_get_real
[34528.893778]   .offset:     1206358214734619011 nsecs
[34528.893780] active timers:
[34528.893783]  clock 1:
[34528.893785]   .index:      1
[34528.893787]   .resolution: 1 nsecs
[34528.893790]   .get_time:   ktime_get
[34528.893795]   .offset:     0 nsecs
[34528.893797] active timers:
[34528.893799]  #0: <e26a7d68>, tick_sched_timer, S:01
[34528.893809]  # expires at 34511541000000 nsecs [in 818592686 nsecs]
[34528.893813]   .expires_next   : 34511541000000 nsecs
[34528.893815]   .hres_active    : 1
[34528.893818]   .nr_events      : 2005329
[34528.893821]   .nohz_mode      : 2
[34528.893824]   .idle_tick      : 34510562250000 nsecs
[34528.893827]   .tick_stopped   : 1
[34528.893830]   .idle_jiffies   : 34210562
[34528.893833]   .idle_calls     : 1749202
[34528.893836]   .idle_sleeps    : 898585
[34528.893839]   .idle_entrytime : 34510561258541 nsecs
[34528.893842]   .idle_waketime  : 34509285251187 nsecs
[34528.893845]   .idle_exittime  : 34510176022616 nsecs
[34528.893848]   .idle_sleeptime : 33931425421772 nsecs
[34528.893851]   .last_jiffies   : 34210562
[34528.893854]   .next_jiffies   : 34211542
[34528.893858]   .idle_expires   : 34511541000000 nsecs
[34528.893860] jiffies: 34210723
[34528.893863]
[34528.893865] cpu: 3
[34528.893867]  clock 0:
[34528.893869]   .index:      0
[34528.893872]   .resolution: 1 nsecs
[34528.893874]   .get_time:   ktime_get_real
[34528.893880]   .offset:     1206358214734619011 nsecs
[34528.893883] active timers:
[34528.893885]  clock 1:
[34528.893887]   .index:      1
[34528.893890]   .resolution: 1 nsecs
[34528.893892]   .get_time:   ktime_get
[34528.893897]   .offset:     0 nsecs
[34528.893899] active timers:
[34528.893902]  #0: <e26a7d68>, tick_sched_timer, S:01
[34528.893911]  # expires at 34510723375000 nsecs [in 967686 nsecs]
[34528.893915]   .expires_next   : 34510723375000 nsecs
[34528.893918]   .hres_active    : 1
[34528.893921]   .nr_events      : 1532911
[34528.893923]   .nohz_mode      : 2
[34528.893926]   .idle_tick      : 34510713375000 nsecs
[34528.893929]   .tick_stopped   : 0
[34528.893932]   .idle_jiffies   : 34210714
[34528.893935]   .idle_calls     : 1350449
[34528.893938]   .idle_sleeps    : 896094
[34528.893941]   .idle_entrytime : 34510713334805 nsecs
[34528.893944]   .idle_waketime  : 34509973216268 nsecs
[34528.893947]   .idle_exittime  : 34510722367621 nsecs
[34528.893951]   .idle_sleeptime : 34031256949569 nsecs
[34528.893954]   .last_jiffies   : 34210714
[34528.893957]   .next_jiffies   : 34240714
[34528.893960]   .idle_expires   : 34540713000000 nsecs
[34528.893963] jiffies: 34210723
[34528.893965]
[34528.893967]
[34528.893969] Tick Device: mode:     1
[34528.893972] Clock Event Device: pit
[34528.893976]  max_delta_ns:   27461866
[34528.893979]  min_delta_ns:   12571
[34528.893982]  mult:           5124677
[34528.893984]  shift:          32
[34528.893987]  mode:           1
[34528.893990]  next_event:     9223372036854775807 nsecs
[34528.893992]  set_next_event: pit_next_event
[34528.894000]  set_mode:       init_pit_timer
[34528.894005]  event_handler:  tick_handle_oneshot_broadcast
[34528.894013] tick_broadcast_mask: 00000000
[34528.894016] tick_broadcast_oneshot_mask: 00000000
[34528.894019]
[34528.894021]
[34528.894023] Tick Device: mode:     1
[34528.894026] Clock Event Device: lapic
[34528.894030]  max_delta_ns:   1346255303
[34528.894033]  min_delta_ns:   2407
[34528.894035]  mult:           26762229
[34528.894038]  shift:          32
[34528.894041]  mode:           3
[34528.894044]  next_event:     34510724000000 nsecs
[34528.894046]  set_next_event: lapic_next_event
[34528.894054]  set_mode:       lapic_timer_setup
[34528.894059]  event_handler:  hrtimer_interrupt
[34528.894064]
[34528.894066] Tick Device: mode:     1
[34528.894069] Clock Event Device: lapic
[34528.894073]  max_delta_ns:   1346255303
[34528.894075]  min_delta_ns:   2407
[34528.894078]  mult:           26762229
[34528.894081]  shift:          32
[34528.894083]  mode:           3
[34528.894086]  next_event:     34510996000000 nsecs
[34528.894089]  set_next_event: lapic_next_event
[34528.894094]  set_mode:       lapic_timer_setup
[34528.894099]  event_handler:  hrtimer_interrupt
[34528.894104]
[34528.894107] Tick Device: mode:     1
[34528.894109] Clock Event Device: lapic
[34528.894113]  max_delta_ns:   1346255303
[34528.894115]  min_delta_ns:   2407
[34528.894118]  mult:           26762229
[34528.894121]  shift:          32
[34528.894123]  mode:           3
[34528.894126]  next_event:     34511541000000 nsecs
[34528.894129]  set_next_event: lapic_next_event
[34528.894134]  set_mode:       lapic_timer_setup
[34528.894139]  event_handler:  hrtimer_interrupt
[34528.894144]
[34528.894146] Tick Device: mode:     1
[34528.894149] Clock Event Device: lapic
[34528.894153]  max_delta_ns:   1346255303
[34528.894155]  min_delta_ns:   2407
[34528.894158]  mult:           26762229
[34528.894161]  shift:          32
[34528.894163]  mode:           3
[34528.894166]  next_event:     34510723375000 nsecs
[34528.894169]  set_next_event: lapic_next_event
[34528.894174]  set_mode:       lapic_timer_setup
[34528.894179]  event_handler:  hrtimer_interrupt
[34528.894184]
[34528.894350] Time: acpi_pm clocksource has been installed.

...

And that made irqbalance go mad which got killed by OOM , very strange.

                                                                                                 
> 
> Thanks,
> 	tglx


Gabriel

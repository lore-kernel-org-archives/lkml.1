Return-Path: <linux-kernel-owner+w=401wt.eu-S1754288AbZAaJQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbZAaJQS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 04:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751025AbZAaJQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 04:16:05 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.121]:62738 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbZAaJQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 04:16:01 -0500
Message-ID: <498416CE.4040101@cfl.rr.com>
Date: Sat, 31 Jan 2009 04:15:58 -0500
From: Mark Hounschell <dmarkh@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: Mark Hounschell <markh@compro.net>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       john stultz <johnstul@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PROBLEM: Can't boot a (HZ = 1000) kernel using an AMD	Phenom-II
 processor
References: <497322CC.7050900@cfl.rr.com> <1f1b08da0901191625i6ac12312g9ae9ab599958a818@mail.gmail.com> <49759499.4050708@cfl.rr.com> <20090120093732.GC3764@alberich.amd.com> <49763D49.7050907@compro.net> <49798F33.8070906@cfl.rr.com> <20090123130416.GA27616@alberich.amd.com> <497A48D5.9040904@cfl.rr.com> <497E0072.7000500@compro.net> <20090127163843.GA1628@aftab> <497FA725.7020503@cfl.rr.com> <497FA7F2.3060709@cfl.rr.com>
In-Reply-To: <497FA7F2.3060709@cfl.rr.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Hounschell wrote:
> Mark Hounschell wrote:
>> Borislav Petkov wrote:
>>> On Mon, Jan 26, 2009 at 01:26:58PM -0500, Mark Hounschell wrote:
>>>
>>> [.. ]
>>>
>>>> If there is anything else I can try, I'm at your disposal.
>>> Ok, I just boot-tested a 1000 HZ kernel here and I can't reproduce
>>> your problem. Can you please send the failing .config. And also where
>>> exactly does your kernel hang during the boot process, can you capture
>>> any output and/or enable SysRq to dump backtrace on all cores (SysRq-T)
>>> if possible. Finally, what does 'cat /proc/timer_list' on the working
>>> kernel say?
>>>
>>> Thanks.
>>>
>>
>> You test booted using a Phenom-II?
>>
>> The config file is attached. The timer_list while running the 250 Hz 2.6.26.8
>> kernel output is below. When it happens I have no keyboard at all. SysRq is not
>> functional at this time. Sorry.
>>
>> Sorry it took so long. I was out of town today.
>>
>> Timer List Version: v0.3
>> HRTIMER_MAX_CLOCK_BASES: 2
>> now at 675544989236 nsecs
>>
>> cpu: 0
>>  clock 0:
>>   .index:      0
>>   .resolution: 1 nsecs
>>   .get_time:   ktime_get_real
>>   .offset:     1233101890018929078 nsecs
>> active timers:
>>  clock 1:
>>   .index:      1
>>   .resolution: 1 nsecs
>>   .get_time:   ktime_get
>>   .offset:     0 nsecs
>> active timers:
>>  #0: <f31ffec0>, tick_sched_timer, S:01, tick_setup_sched_timer, swapper/0
>>  # expires at 675548000000 nsecs [in 3010764 nsecs]
>>   .expires_next   : 675548000000 nsecs
>>   .hres_active    : 1
>>   .nr_events      : 170138
>>   .nohz_mode      : 0
>>   .idle_tick      : 0 nsecs
>>   .tick_stopped   : 0
>>   .idle_jiffies   : 0
>>   .idle_calls     : 0
>>   .idle_sleeps    : 0
>>   .idle_entrytime : 0 nsecs
>>   .idle_waketime  : 0 nsecs
>>   .idle_exittime  : 0 nsecs
>>   .idle_sleeptime : 0 nsecs
>>   .last_jiffies   : 0
>>   .next_jiffies   : 0
>>   .idle_expires   : 0 nsecs
>> jiffies: 93886
>>
>> cpu: 1
>>  clock 0:
>>   .index:      0
>>   .resolution: 1 nsecs
>>   .get_time:   ktime_get_real
>>   .offset:     1233101890018929078 nsecs
>> active timers:
>>  clock 1:
>>   .index:      1
>>   .resolution: 1 nsecs
>>   .get_time:   ktime_get
>>   .offset:     0 nsecs
>> active timers:
>>  #0: <f31ffec0>, tick_sched_timer, S:01, tick_setup_sched_timer, swapper/0
>>  # expires at 675548500000 nsecs [in 3510764 nsecs]
>>  #1: <f31ffec0>, it_real_fn, S:01, do_setitimer, ntpd/4446
>>  # expires at 676081032589 nsecs [in 536043353 nsecs]
>>  #2: <f31ffec0>, hrtimer_wakeup, S:01, futex_wait, nscd/4456
>>  # expires at 683136927993 nsecs [in 7591938757 nsecs]
>>  #3: <f31ffec0>, hrtimer_wakeup, S:01, do_nanosleep, cron/4539
>>  # expires at 711791265959 nsecs [in 36246276723 nsecs]
>>  #4: <f31ffec0>, it_real_fn, S:01, do_setitimer, qmgr/4549
>>  # expires at 1001716635269 nsecs [in 326171646033 nsecs]
>>  #5: <f31ffec0>, it_real_fn, S:01, do_setitimer, master/4517
>>  # expires at 1001716661669 nsecs [in 326171672433 nsecs]
>>  #6: <f31ffec0>, hrtimer_wakeup, S:01, futex_wait, nscd/4459
>>  # expires at 28868136987269 nsecs [in 28192591998033 nsecs]
>>   .expires_next   : 675548500000 nsecs
>>   .hres_active    : 1
>>   .nr_events      : 169510
>>   .nohz_mode      : 0
>>   .idle_tick      : 0 nsecs
>>   .tick_stopped   : 0
>>   .idle_jiffies   : 0
>>   .idle_calls     : 0
>>   .idle_sleeps    : 0
>>   .idle_entrytime : 0 nsecs
>>   .idle_waketime  : 0 nsecs
>>   .idle_exittime  : 0 nsecs
>>   .idle_sleeptime : 0 nsecs
>>   .last_jiffies   : 0
>>   .next_jiffies   : 0
>>   .idle_expires   : 0 nsecs
>> jiffies: 93886
>>
>> cpu: 2
>>  clock 0:
>>   .index:      0
>>   .resolution: 1 nsecs
>>   .get_time:   ktime_get_real
>>   .offset:     1233101890018929078 nsecs
>> active timers:
>>  clock 1:
>>   .index:      1
>>   .resolution: 1 nsecs
>>   .get_time:   ktime_get
>>   .offset:     0 nsecs
>> active timers:
>>  #0: <f31ffec0>, tick_sched_timer, S:01, tick_setup_sched_timer, swapper/0
>>  # expires at 675549000000 nsecs [in 4010764 nsecs]
>>  #1: <f31ffec0>, it_real_fn, S:01, do_setitimer, Xorg/3325
>>  # expires at 675563416492 nsecs [in 18427256 nsecs]
>>  #2: <f31ffec0>, hrtimer_wakeup, S:01, do_nanosleep, kwrapper/4982
>>  # expires at 676109815468 nsecs [in 564826232 nsecs]
>>  #3: <f31ffec0>, hrtimer_wakeup, S:01, futex_wait, nscd/4458
>>  # expires at 683435589386 nsecs [in 7890600150 nsecs]
>>  #4: <f31ffec0>, it_real_fn, S:01, do_setitimer, pickup/4548
>>  # expires at 1001716659224 nsecs [in 326171669988 nsecs]
>>   .expires_next   : 675549000000 nsecs
>>   .hres_active    : 1
>>   .nr_events      : 172253
>>   .nohz_mode      : 0
>>   .idle_tick      : 0 nsecs
>>   .tick_stopped   : 0
>>   .idle_jiffies   : 0
>>   .idle_calls     : 0
>>   .idle_sleeps    : 0
>>   .idle_entrytime : 0 nsecs
>>   .idle_waketime  : 0 nsecs
>>   .idle_exittime  : 0 nsecs
>>   .idle_sleeptime : 0 nsecs
>>   .last_jiffies   : 0
>>   .next_jiffies   : 0
>>   .idle_expires   : 0 nsecs
>> jiffies: 93886
>>
>> cpu: 3
>>  clock 0:
>>   .index:      0
>>   .resolution: 1 nsecs
>>   .get_time:   ktime_get_real
>>   .offset:     1233101890018929078 nsecs
>> active timers:
>>  clock 1:
>>   .index:      1
>>   .resolution: 1 nsecs
>>   .get_time:   ktime_get
>>   .offset:     0 nsecs
>> active timers:
>>  #0: <f31ffec0>, tick_sched_timer, S:01, tick_setup_sched_timer, swapper/0
>>  # expires at 675545500000 nsecs [in 510764 nsecs]
>>  #1: <f31ffec0>, sched_rt_period_timer, S:01, enqueue_task_rt, swapper/1
>>  # expires at 676000000000 nsecs [in 455010764 nsecs]
>>  #2: <f31ffec0>, hrtimer_wakeup, S:01, futex_wait, thunderbird-bin/5123
>>  # expires at 689314480389 nsecs [in 13769491153 nsecs]
>>  #3: <f31ffec0>, hrtimer_wakeup, S:01, futex_wait, thunderbird-bin/5209
>>  # expires at 689361744389 nsecs [in 13816755153 nsecs]
>>  #4: <f31ffec0>, hrtimer_wakeup, S:01, futex_wait, nscd/4457
>>  # expires at 3668136917342 nsecs [in 2992591928106 nsecs]
>>   .expires_next   : 675545500000 nsecs
>>   .hres_active    : 1
>>   .nr_events      : 171267
>>   .nohz_mode      : 0
>>   .idle_tick      : 0 nsecs
>>   .tick_stopped   : 0
>>   .idle_jiffies   : 0
>>   .idle_calls     : 0
>>   .idle_sleeps    : 0
>>   .idle_entrytime : 0 nsecs
>>   .idle_waketime  : 0 nsecs
>>   .idle_exittime  : 0 nsecs
>>   .idle_sleeptime : 0 nsecs
>>   .last_jiffies   : 0
>>   .next_jiffies   : 0
>>   .idle_expires   : 0 nsecs
>> jiffies: 93886
>>
>>
>> Tick Device: mode:     1
>> Clock Event Device: hpet
>>  max_delta_ns:   2147483647
>>  min_delta_ns:   5000
>>  mult:           61496114
>>  shift:          32
>>  mode:           3
>>  next_event:     9223372036854775807 nsecs
>>  set_next_event: hpet_legacy_next_event
>>  set_mode:       hpet_legacy_set_mode
>>  event_handler:  tick_handle_oneshot_broadcast
>> tick_broadcast_mask: 00000000
>> tick_broadcast_oneshot_mask: 00000000
>>
>>
>> Tick Device: mode:     1
>> Clock Event Device: lapic
>>  max_delta_ns:   671091850
>>  min_delta_ns:   1200
>>  mult:           53686828
>>  shift:          32
>>  mode:           3
>>  next_event:     675548000000 nsecs
>>  set_next_event: lapic_next_event
>>  set_mode:       lapic_timer_setup
>>  event_handler:  hrtimer_interrupt
>>
>> Tick Device: mode:     1
>> Clock Event Device: lapic
>>  max_delta_ns:   671091850
>>  min_delta_ns:   1200
>>  mult:           53686828
>>  shift:          32
>>  mode:           3
>>  next_event:     675548500000 nsecs
>>  set_next_event: lapic_next_event
>>  set_mode:       lapic_timer_setup
>>  event_handler:  hrtimer_interrupt
>>
>> Tick Device: mode:     1
>> Clock Event Device: lapic
>>  max_delta_ns:   671091850
>>  min_delta_ns:   1200
>>  mult:           53686828
>>  shift:          32
>>  mode:           3
>>  next_event:     675549000000 nsecs
>>  set_next_event: lapic_next_event
>>  set_mode:       lapic_timer_setup
>>  event_handler:  hrtimer_interrupt
>>
>> Tick Device: mode:     1
>> Clock Event Device: lapic
>>  max_delta_ns:   671091850
>>  min_delta_ns:   1200
>>  mult:           53686828
>>  shift:          32
>>  mode:           3
>>  next_event:     675545500000 nsecs
>>  set_next_event: lapic_next_event
>>  set_mode:       lapic_timer_setup
>>  event_handler:  hrtimer_interrupt
>>
>>
>>
>> Regards
>> Mark
>>
> 
> Oh I Forgot. The last thing I see on the screen is.
> 
> Checking if this processor honours the WP bit even in hypervisor mode... OK.
> SLUB: Genslabs=12, HWalign=64, Order=0,3, MinObjects=0, CPUs=4, Nodes=1
> 
> Mark
> --

So were you able to reproduce this with my .config. Has anyone booted a Hz=1000
kernel on an AMD Phenom-II? Is there something wrong with my .config? Is there
anything else I can do?

Thanks
Mark

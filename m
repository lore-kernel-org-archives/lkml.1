Return-Path: <linux-kernel-owner+w=401wt.eu-S934236AbXFFApn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934236AbXFFApn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 20:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932772AbXFFApe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 20:45:34 -0400
Received: from smtpa3.netcabo.pt ([212.113.174.18]:52883 "EHLO
	exch01smtp02.hdi.tvcabo" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764985AbXFFApc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 20:45:32 -0400
Message-ID: <46660369.2070104@rncbc.org>
Date: Wed, 06 Jun 2007 01:44:25 +0100
From: Rui Nuno Capela <rncbc@rncbc.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Rui Nuno Capela <rncbc@rncbc.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: 2.6.21-rt2..8 troubles
References: <23932.213.58.131.130.1170156409.squirrel@www.rncbc.org>	 <460FE7F3.4060303@rncbc.org> <20070401183928.GB27614@elte.hu>	 <46574DE4.2080900@rncbc.org> <1180195709.4264.7.camel@chaos> <4658A4F4.1080204@rncbc.org>
In-Reply-To: <4658A4F4.1080204@rncbc.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jun 2007 00:45:27.0914 (UTC) FILETIME=[FA17A4A0:01C7A7D3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rui Nuno Capela wrote:
> Thomas Gleixner wrote:
>> On Fri, 2007-05-25 at 21:58 +0100, Rui Nuno Capela wrote:
>>> Is there anything I can do better to help myself figuring out this
>>> issue? As this is a  modern laptop such things like a serial console are
>>> unavailable, but it would be nice to track things up over netconsole
>>> perhaps?
>>>
>>> I just need some bright and nice directions now ;) Hope someone finds
>>> this worth of attention too. Meanwhile, I'll be happy with 2.6.21-rt1 :)
>> Can you boot with "hpet=disable" on the command line ?
>>
> 
> Nope. It doesn't seem to have significant effect. Same time-bomb
> behavior: after an indeterminate period of uptime, the systems stops
> responding and cannot spawn new processes (current running ones still
> live on, strange).
> 
>> If that does not help, please provide the output of /proc/timer_list.
>>
> 
> This is with my latest iteration:
>   http://www.rncbc.org/datahub/config-2.6.21.1-rt8.0
> 
> Normal boot on which it behaves as badly as reported:
>   http://www.rncbc.org/datahub/dmesg-2.6.21.1-rt8.0
> 
> # cat /proc/timer_list
> Timer List Version: v0.3
> HRTIMER_MAX_CLOCK_BASES: 2
> now at 131736771907 nsecs
> 
> cpu: 0
>  clock 0:
>   .index:      0
>   .resolution: 1 nsecs
>   .get_time:   ktime_get_real
>   .offset:     1180213690448299114 nsecs
> active timers:
>  clock 1:
>   .index:      1
>   .resolution: 1 nsecs
>   .get_time:   ktime_get
>   .offset:     0 nsecs
> active timers:
>  #0: <ed7c4ef4>, tick_sched_timer, S:01
>  # expires at 131737000000 nsecs [in 228093 nsecs]
>  #1: <ed7c4ef4>, it_real_fn, S:01
>  # expires at 131751277843 nsecs [in 14505936 nsecs]
>  #2: <ed7c4ef4>, hrtimer_wakeup, S:01
>  # expires at 131802703679 nsecs [in 65931772 nsecs]
>  #3: <ed7c4ef4>, hrtimer_wakeup, S:01
>  # expires at 131802705006 nsecs [in 65933099 nsecs]
>  #4: <ed7c4ef4>, hrtimer_wakeup, S:01
>  # expires at 132412838830 nsecs [in 676066923 nsecs]
>  #5: <ed7c4ef4>, it_real_fn, S:01
>  # expires at 137026607454 nsecs [in 5289835547 nsecs]
>  #6: <ed7c4ef4>, hrtimer_wakeup, S:01
>  # expires at 141381493725 nsecs [in 9644721818 nsecs]
>  #7: <ed7c4ef4>, hrtimer_wakeup, S:01
>  # expires at 170796028701 nsecs [in 39059256794 nsecs]
>   .expires_next   : 131737000000 nsecs
>   .hres_active    : 1
>   .nr_events      : 40634
>   .nohz_mode      : 2
>   .idle_tick      : 131724000000 nsecs
>   .tick_stopped   : 0
>   .idle_jiffies   : 4294799020
>   .idle_calls     : 178848
>   .idle_sleeps    : 133212
>   .idle_entrytime : 131736069830 nsecs
>   .idle_sleeptime : 100895567465 nsecs
>   .last_jiffies   : 4294799033
>   .next_jiffies   : 4294799039
>   .idle_expires   : 131736000000 nsecs
> jiffies: 4294799033
> 
> cpu: 1
>  clock 0:
>   .index:      0
>   .resolution: 1 nsecs
>   .get_time:   ktime_get_real
>   .offset:     1180213690448299114 nsecs
> active timers:
>  clock 1:
>   .index:      1
>   .resolution: 1 nsecs
>   .get_time:   ktime_get
>   .offset:     0 nsecs
> active timers:
>  #0: <ed7c4ef4>, hrtimer_wakeup, S:01
>  # expires at 131737067173 nsecs [in 295266 nsecs]
>  #1: <ed7c4ef4>, tick_sched_timer, S:01
>  # expires at 131737250000 nsecs [in 478093 nsecs]
>  #2: <ed7c4ef4>, hrtimer_wakeup, S:01
>  # expires at 139151071745 nsecs [in 7414299838 nsecs]
>  #3: <ed7c4ef4>, hrtimer_wakeup, S:01
>  # expires at 139151133755 nsecs [in 7414361848 nsecs]
>  #4: <ed7c4ef4>, hrtimer_wakeup, S:01
>  # expires at 139151154005 nsecs [in 7414382098 nsecs]
>   .expires_next   : 131737067173 nsecs
>   .hres_active    : 1
>   .nr_events      : 31510
>   .nohz_mode      : 2
>   .idle_tick      : 131734250000 nsecs
>   .tick_stopped   : 0
>   .idle_jiffies   : 4294799030
>   .idle_calls     : 151213
>   .idle_sleeps    : 107018
>   .idle_entrytime : 131735193036 nsecs
>   .idle_sleeptime : 108256832194 nsecs
>   .last_jiffies   : 4294799032
>   .next_jiffies   : 4294799040
>   .idle_expires   : 131743000000 nsecs
> jiffies: 4294799033
> 
> 
> Tick Device: mode:     1
> Clock Event Device: hpet
>  max_delta_ns:   2147483647
>  min_delta_ns:   3352
>  mult:           61496110
>  shift:          32
>  mode:           3
>  next_event:     131737000000 nsecs
>  set_next_event: hpet_legacy_next_event
>  set_mode:       hpet_legacy_set_mode
>  event_handler:  tick_handle_oneshot_broadcast
> tick_broadcast_mask: 00000003
> tick_broadcast_oneshot_mask: 00000001
> 
> 
> Tick Device: mode:     1
> Clock Event Device: lapic
>  max_delta_ns:   806914928
>  min_delta_ns:   1442
>  mult:           44650051
>  shift:          32
>  mode:           1
>  next_event:     131737000000 nsecs
>  set_next_event: lapic_next_event
>  set_mode:       lapic_timer_setup
>  event_handler:  hrtimer_interrupt
> 
> Tick Device: mode:     1
> Clock Event Device: lapic
>  max_delta_ns:   806914928
>  min_delta_ns:   1442
>  mult:           44650051
>  shift:          32
>  mode:           3
>  next_event:     131737067173 nsecs
>  set_next_event: lapic_next_event
>  set_mode:       lapic_timer_setup
>  event_handler:  hrtimer_interrupt
> --
> 
> 
> Alternate boot with hpet=disabled as suggested, but no better results:
>   http://www.rncbc.org/datahub/dmesg-2.6.21.1-rt8.0-hpet_disabled
> 
> # cat /proc/timer_list
> Timer List Version: v0.3
> HRTIMER_MAX_CLOCK_BASES: 2
> now at 269529706096 nsecs
> 
> cpu: 0
>  clock 0:
>   .index:      0
>   .resolution: 1 nsecs
>   .get_time:   ktime_get_real
>   .offset:     1180214106093436428 nsecs
> active timers:
>  clock 1:
>   .index:      1
>   .resolution: 1 nsecs
>   .get_time:   ktime_get
>   .offset:     0 nsecs
> active timers:
>  #0: <ed2a2ef4>, tick_sched_timer, S:01
>  # expires at 269530000000 nsecs [in 293904 nsecs]
>  #1: <ed2a2ef4>, hrtimer_wakeup, S:01
>  # expires at 269554568320 nsecs [in 24862224 nsecs]
>  #2: <ed2a2ef4>, hrtimer_wakeup, S:01
>  # expires at 269585566924 nsecs [in 55860828 nsecs]
>  #3: <ed2a2ef4>, hrtimer_wakeup, S:01
>  # expires at 269822782823 nsecs [in 293076727 nsecs]
>  #4: <ed2a2ef4>, hrtimer_wakeup, S:01
>  # expires at 272726158017 nsecs [in 3196451921 nsecs]
>  #5: <ed2a2ef4>, it_real_fn, S:01
>  # expires at 278007767018 nsecs [in 8478060922 nsecs]
>  #6: <ed2a2ef4>, hrtimer_wakeup, S:01
>  # expires at 283716431029 nsecs [in 14186724933 nsecs]
>  #7: <ed2a2ef4>, hrtimer_wakeup, S:01
>  # expires at 283716456168 nsecs [in 14186750072 nsecs]
>  #8: <ed2a2ef4>, hrtimer_wakeup, S:01
>  # expires at 295789281627 nsecs [in 26259575531 nsecs]
>   .expires_next   : 269530000000 nsecs
>   .hres_active    : 1
>   .nr_events      : 63228
>   .nohz_mode      : 2
>   .idle_tick      : 269527000000 nsecs
>   .tick_stopped   : 0
>   .idle_jiffies   : 4294936823
>   .idle_calls     : 217590
>   .idle_sleeps    : 168323
>   .idle_entrytime : 269528785728 nsecs
>   .idle_sleeptime : 230915526366 nsecs
>   .last_jiffies   : 4294936825
>   .next_jiffies   : 4294936840
>   .idle_expires   : 269543000000 nsecs
> jiffies: 4294936826
> 
> cpu: 1
>  clock 0:
>   .index:      0
>   .resolution: 1 nsecs
>   .get_time:   ktime_get_real
>   .offset:     1180214106093436428 nsecs
> active timers:
>  clock 1:
>   .index:      1
>   .resolution: 1 nsecs
>   .get_time:   ktime_get
>   .offset:     0 nsecs
> active timers:
>  #0: <ed2a2ef4>, tick_sched_timer, S:01
>  # expires at 269530250000 nsecs [in 543904 nsecs]
>  #1: <ed2a2ef4>, it_real_fn, S:01
>  # expires at 269546379364 nsecs [in 16673268 nsecs]
>  #2: <ed2a2ef4>, hrtimer_wakeup, S:01
>  # expires at 283723356553 nsecs [in 14193650457 nsecs]
>   .expires_next   : 269530250000 nsecs
>   .hres_active    : 1
>   .nr_events      : 64947
>   .nohz_mode      : 2
>   .idle_tick      : 269527250000 nsecs
>   .tick_stopped   : 0
>   .idle_jiffies   : 4294936824
>   .idle_calls     : 172684
>   .idle_sleeps    : 111081
>   .idle_entrytime : 269529298565 nsecs
>   .idle_sleeptime : 234502295072 nsecs
>   .last_jiffies   : 4294936826
>   .next_jiffies   : 4294936833
>   .idle_expires   : 269536000000 nsecs
> jiffies: 4294936826
> 
> 
> Tick Device: mode:     1
> Clock Event Device: pit
>  max_delta_ns:   27461866
>  min_delta_ns:   12571
>  mult:           5124677
>  shift:          32
>  mode:           3
>  next_event:     269530250000 nsecs
>  set_next_event: pit_next_event
>  set_mode:       init_pit_timer
>  event_handler:  tick_handle_oneshot_broadcast
> tick_broadcast_mask: 00000003
> tick_broadcast_oneshot_mask: 00000002
> 
> 
> Tick Device: mode:     1
> Clock Event Device: lapic
>  max_delta_ns:   807031401
>  min_delta_ns:   1443
>  mult:           44643607
>  shift:          32
>  mode:           3
>  next_event:     269530000000 nsecs
>  set_next_event: lapic_next_event
>  set_mode:       lapic_timer_setup
>  event_handler:  hrtimer_interrupt
> 
> Tick Device: mode:     1
> Clock Event Device: lapic
>  max_delta_ns:   807031401
>  min_delta_ns:   1443
>  mult:           44643607
>  shift:          32
>  mode:           1
>  next_event:     269530250000 nsecs
>  set_next_event: lapic_next_event
>  set_mode:       lapic_timer_setup
>  event_handler:  hrtimer_interrupt
> --
> 

Just for the heads-up, I'm still suffering from this same illness, and
it seems even worse (big freeze happens earlier) on 2.6.21.3-rt9.

There's no way around. On one box it works flawlessly (desktop,
P4@3.3Ghz) while on the patient one (laptop, core2 T7200) it bricks
silently.

Shrugs:)
-- 
rncbc aka Rui Nuno Capela
rncbc@rncbc.org

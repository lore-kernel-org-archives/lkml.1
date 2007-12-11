Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbXLKEtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbXLKEtv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 23:49:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbXLKEtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 23:49:42 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:31123 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbXLKEtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 23:49:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DJPHj12HwnC5tgjDHtSolSFb1vdE1AlZsErFuGrRzVUEbvyQiiDAifV/GOA3vdAHZ7bolPtWDGDXjcmB8gLfoEG+IvQEo/HYw3Lus8oqV/StW8EV3TzJyTEUi9nkhGOigvhDs8tRygR9k0isgLQueqFn1EkuoEP8nEJarZ3aBEw=
Message-ID: <82e4877d0712102049g4830a573n86b7f72f31a42f11@mail.gmail.com>
Date: Mon, 10 Dec 2007 23:49:38 -0500
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: soft lockup - CPU#1 stuck for 15s! [swapper:0]
Cc: "Arjan van de Ven" <arjan@infradead.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <alpine.LFD.0.99999.0712101117300.11977@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <924EFEDD5F540B4284297C4DC59F3DEE38C3C2@orsmsx423.amr.corp.intel.com>
	 <20071208194211.GA579@elte.hu>
	 <82e4877d0712081208u335c968csd1d3e9259cdd2920@mail.gmail.com>
	 <20071208201137.GA13451@elte.hu>
	 <82e4877d0712081246x4d788c36i908916185611fa94@mail.gmail.com>
	 <20071208125144.734e9f81@laptopd505.fenrus.org>
	 <82e4877d0712081304r19721b43w78b294ea8d470405@mail.gmail.com>
	 <82e4877d0712081512s2b5a72aewbe396f28305ac963@mail.gmail.com>
	 <82e4877d0712091357u41973a24v38c4ad18ad596de5@mail.gmail.com>
	 <alpine.LFD.0.99999.0712101117300.11977@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 10, 2007 12:49 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Can you please apply the patch below ? It prints out the internal
> state of the clockevents/timer system when the softlockup is detected.
>

Below is the relevant output after multiple soft lockups.

Thanks
Parag

BUG: soft lockup - CPU#1 stuck for 14s! [squid_redirect:3109]

Pid: 3109, comm: squid_redirect Not tainted (2.6.24-rc4 #15)
EIP: 0073:[<0077a362>] EFLAGS: 00000202 CPU: 1
EIP is at 0x77a362
EAX: 0804c008 EBX: 007ca5cc ECX: 08199947 EDX: 0846da74
ESI: 0846da74 EDI: 08199968 EBP: bfcc2d58 ESP: bfcc2d20
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
CR0: 80050033 CR2: b7ea2c84 CR3: 3721b000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 =======================
Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 2899263521779 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197343983635176004 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f6eb1e9c>, tick_sched_timer, S:01, tick_nohz_restart_sched_tick, swapper/0
 # expires at 2899384000000 nsecs [in 120478221 nsecs]
 #1: <f6eb1e9c>, hrtimer_wakeup, S:01, do_nanosleep, irqbalance/2663
 # expires at 2902364827067 nsecs [in 3101305288 nsecs]
 #2: <f6eb1e9c>, it_real_fn, S:01, do_setitimer, syslogd/2643
 # expires at 2918995045613 nsecs [in 19731523834 nsecs]
 #3: <f6eb1e9c>, hrtimer_wakeup, S:01, do_nanosleep, crond/3083
 # expires at 2938118668932 nsecs [in 38855147153 nsecs]
 #4: <f6eb1e9c>, hrtimer_wakeup, S:01, do_nanosleep, atd/3184
 # expires at 3037524193866 nsecs [in 138260672087 nsecs]
 #5: <f6eb1e9c>, hrtimer_wakeup, S:01, do_nanosleep, smartd/3313
 # expires at 3645576708660 nsecs [in 746313186881 nsecs]
  .expires_next   : 2899500000000 nsecs
  .hres_active    : 1
  .nr_events      : 113175
  .nohz_mode      : 2
  .idle_tick      : 2899000000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 649750
  .idle_calls     : 848768
  .idle_sleeps    : 642128
  .idle_entrytime : 2899580013124 nsecs
  .idle_sleeptime : 2675153362437 nsecs
  .last_jiffies   : 649900
  .next_jiffies   : 649918
  .idle_expires   : 2899496000000 nsecs
jiffies: 649906

cpu: 1
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197343983635176004 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f6eb1e9c>, it_real_fn, S:01, do_setitimer, sendmail/3036
 # expires at 3634545118202 nsecs [in 735281596423 nsecs]
 #1: <f6eb1e9c>, it_real_fn, S:01, do_setitimer, sendmail/3047
 # expires at 3634633106605 nsecs [in 735369584826 nsecs]
  .expires_next   : 2899261000000 nsecs
  .hres_active    : 1
  .nr_events      : 51469
  .nohz_mode      : 2
  .idle_tick      : 2883861000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 645965
  .idle_calls     : 59946
  .idle_sleeps    : 21647
  .idle_entrytime : 2883857038167 nsecs
  .idle_sleeptime : 2760707498759 nsecs
  .last_jiffies   : 645965
  .next_jiffies   : 652750
  .idle_expires   : 2910996000000 nsecs
jiffies: 649967


Tick Device: mode:     1
Clock Event Device: hpet
 max_delta_ns:   2147483647
 min_delta_ns:   3352
 mult:           61496110
 shift:          32
 mode:           3
 next_event:     2899924000000 nsecs
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode
 event_handler:  tick_handle_oneshot_broadcast
tick_broadcast_mask: 00000003
tick_broadcast_oneshot_mask: 00000001


Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805384969
 min_delta_ns:   1440
 mult:           44734871
 shift:          32
 mode:           1
 next_event:     2900012000000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805384969
 min_delta_ns:   1440
 mult:           44734871
 shift:          32
 mode:           3
 next_event:     9223372036854775807 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

BUG: soft lockup - CPU#1 stuck for 13s! [squid_redirect:3110]

Pid: 3110, comm: squid_redirect Not tainted (2.6.24-rc4 #15)
EIP: 0073:[<00725c40>] EFLAGS: 00000246 CPU: 1
EIP is at 0x725c40
EAX: 0829da00 EBX: 007ca5cc ECX: 080bb420 EDX: 00000000
ESI: 0804c008 EDI: 00000003 EBP: bfd26158 ESP: bfd2613c
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
CR0: 80050033 CR2: b7ea2c84 CR3: 37c06000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 =======================
Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 2925319278498 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197343983635176004 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f6eb5e9c>, tick_sched_timer, S:01, tick_nohz_restart_sched_tick, swapper/0
 # expires at 2925436000000 nsecs [in 116721502 nsecs]
 #1: <f6eb5e9c>, hrtimer_wakeup, S:01, do_nanosleep, irqbalance/2663
 # expires at 2932364827220 nsecs [in 7045548722 nsecs]
 #2: <f6eb5e9c>, hrtimer_wakeup, S:01, do_nanosleep, crond/3083
 # expires at 2938118668932 nsecs [in 12799390434 nsecs]
 #3: <f6eb5e9c>, it_real_fn, S:01, do_setitimer, syslogd/2643
 # expires at 2948995090537 nsecs [in 23675812039 nsecs]
 #4: <f6eb5e9c>, hrtimer_wakeup, S:01, do_nanosleep, atd/3184
 # expires at 3037524193866 nsecs [in 112204915368 nsecs]
 #5: <f6eb5e9c>, hrtimer_wakeup, S:01, do_nanosleep, smartd/3313
 # expires at 3645576708660 nsecs [in 720257430162 nsecs]
  .expires_next   : 2925532000000 nsecs
  .hres_active    : 1
  .nr_events      : 113548
  .nohz_mode      : 2
  .idle_tick      : 2925000000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 656250
  .idle_calls     : 849830
  .idle_sleeps    : 642265
  .idle_entrytime : 2925608012256 nsecs
  .idle_sleeptime : 2700129054859 nsecs
  .last_jiffies   : 656311
  .next_jiffies   : 656321
  .idle_expires   : 2925496000000 nsecs
jiffies: 656311

cpu: 1
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197343983635176004 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f6eb5e9c>, it_real_fn, S:01, do_setitimer, sendmail/3036
 # expires at 3634545118202 nsecs [in 709225839704 nsecs]
 #1: <f6eb5e9c>, it_real_fn, S:01, do_setitimer, sendmail/3047
 # expires at 3634633106605 nsecs [in 709313828107 nsecs]
  .expires_next   : 2925241000000 nsecs
  .hres_active    : 1
  .nr_events      : 51474
  .nohz_mode      : 2
  .idle_tick      : 2911001000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 652750
  .idle_calls     : 59951
  .idle_sleeps    : 21649
  .idle_entrytime : 2910997024596 nsecs
  .idle_sleeptime : 2785834078493 nsecs
  .last_jiffies   : 652750
  .next_jiffies   : 660250
  .idle_expires   : 2940996000000 nsecs
jiffies: 656311


Tick Device: mode:     1
Clock Event Device: hpet
 max_delta_ns:   2147483647
 min_delta_ns:   3352
 mult:           61496110
 shift:          32
 mode:           3
 next_event:     2925952000000 nsecs
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode
 event_handler:  tick_handle_oneshot_broadcast
tick_broadcast_mask: 00000003
tick_broadcast_oneshot_mask: 00000001


Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805384969
 min_delta_ns:   1440
 mult:           44734871
 shift:          32
 mode:           1
 next_event:     2926044000000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805384969
 min_delta_ns:   1440
 mult:           44734871
 shift:          32
 mode:           3
 next_event:     9223372036854775807 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

BUG: soft lockup - CPU#1 stuck for 107s! [swapper:0]

Pid: 0, comm: swapper Not tainted (2.6.24-rc4 #15)
EIP: 0060:[<c0533d06>] EFLAGS: 00000202 CPU: 1
EIP is at acpi_idle_enter_simple+0x166/0x1d0
EAX: f7829f88 EBX: 00000dab ECX: 00000266 EDX: 00000000
ESI: 00000000 EDI: 00bcbed8 EBP: 00bcb12d ESP: f7829f88
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 086e902c CR3: 3720a000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c058cf03>] cpuidle_idle_call+0x53/0x78
 [<c058ceb0>] cpuidle_idle_call+0x0/0x78
 [<c0402575>] cpu_idle+0x97/0xb8
 =======================
Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 3175981092730 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197343983635176004 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f7829e34>, tick_sched_timer, S:01, tick_nohz_stop_sched_tick, swapper/0
 # expires at 3175984000000 nsecs [in 2907270 nsecs]
 #1: <f7829e34>, hrtimer_wakeup, S:01, do_nanosleep, crond/3083
 # expires at 3178119140931 nsecs [in 2138048201 nsecs]
 #2: <f7829e34>, hrtimer_wakeup, S:01, do_nanosleep, irqbalance/2663
 # expires at 3182364827430 nsecs [in 6383734700 nsecs]
 #3: <f7829e34>, it_real_fn, S:01, do_setitimer, syslogd/2643
 # expires at 3188995455070 nsecs [in 13014362340 nsecs]
 #4: <f7829e34>, hrtimer_wakeup, S:01, do_nanosleep, atd/3184
 # expires at 3337524287270 nsecs [in 161543194540 nsecs]
 #5: <f7829e34>, hrtimer_wakeup, S:01, do_nanosleep, smartd/3313
 # expires at 3645576708660 nsecs [in 469595615930 nsecs]
  .expires_next   : 3175984000000 nsecs
  .hres_active    : 1
  .nr_events      : 116977
  .nohz_mode      : 2
  .idle_tick      : 3175872000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 718969
  .idle_calls     : 982424
  .idle_sleeps    : 768351
  .idle_entrytime : 3175868036812 nsecs
  .idle_sleeptime : 2942681121008 nsecs
  .last_jiffies   : 718968
  .next_jiffies   : 718995
  .idle_expires   : 3175976000000 nsecs
jiffies: 718996

cpu: 1
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197343983635176004 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f7829e34>, it_real_fn, S:01, do_setitimer, sendmail/3036
 # expires at 3634545118202 nsecs [in 458564025472 nsecs]
 #1: <f7829e34>, it_real_fn, S:01, do_setitimer, sendmail/3047
 # expires at 3634633106605 nsecs [in 458652013875 nsecs]
  .expires_next   : 3175981000000 nsecs
  .hres_active    : 1
  .nr_events      : 52243
  .nohz_mode      : 2
  .idle_tick      : 3061841000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 690460
  .idle_calls     : 61325
  .idle_sleeps    : 22249
  .idle_entrytime : 3175980020722 nsecs
  .idle_sleeptime : 3034270703089 nsecs
  .last_jiffies   : 718996
  .next_jiffies   : 732728
  .idle_expires   : 3230908000000 nsecs
jiffies: 718996


Tick Device: mode:     1
Clock Event Device: hpet
 max_delta_ns:   2147483647
 min_delta_ns:   3352
 mult:           61496110
 shift:          32
 mode:           3
 next_event:     9223372036854775807 nsecs
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode
 event_handler:  tick_handle_oneshot_broadcast
tick_broadcast_mask: 00000003
tick_broadcast_oneshot_mask: 00000002


Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805384969
 min_delta_ns:   1440
 mult:           44734871
 shift:          32
 mode:           3
 next_event:     3175984000000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805384969
 min_delta_ns:   1440
 mult:           44734871
 shift:          32
 mode:           1
 next_event:     9223372036854775807 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

BUG: soft lockup - CPU#1 stuck for 13s! [swapper:0]

Pid: 0, comm: swapper Not tainted (2.6.24-rc4 #15)
EIP: 0060:[<c0533d06>] EFLAGS: 00000206 CPU: 1
EIP is at acpi_idle_enter_simple+0x166/0x1d0
EAX: f7829f88 EBX: 00000da2 ECX: 00000266 EDX: 00000000
ESI: 00000000 EDI: 009232c2 EBP: 00922520 ESP: f7829f88
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 086e902c CR3: 37890000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c058cf03>] cpuidle_idle_call+0x53/0x78
 [<c058ceb0>] cpuidle_idle_call+0x0/0x78
 [<c0402575>] cpu_idle+0x97/0xb8
 =======================
Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 3315910720388 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197343983635176004 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f7829e34>, tick_sched_timer, S:01, tick_nohz_restart_sched_tick, swapper/0
 # expires at 3316024000000 nsecs [in 113279612 nsecs]
 #1: <f7829e34>, hrtimer_wakeup, S:01, do_nanosleep, irqbalance/2663
 # expires at 3322364826957 nsecs [in 6454106569 nsecs]
 #2: <f7829e34>, hrtimer_wakeup, S:01, do_nanosleep, atd/3184
 # expires at 3337524287270 nsecs [in 21613566882 nsecs]
 #3: <f7829e34>, it_real_fn, S:01, do_setitimer, syslogd/2643
 # expires at 3338995684982 nsecs [in 23084964594 nsecs]
 #4: <f7829e34>, hrtimer_wakeup, S:01, do_nanosleep, crond/3083
 # expires at 3358119467677 nsecs [in 42208747289 nsecs]
 #5: <f7829e34>, hrtimer_wakeup, S:01, do_nanosleep, smartd/3313
 # expires at 3645576708660 nsecs [in 329665988272 nsecs]
  .expires_next   : 3316124000000 nsecs
  .hres_active    : 1
  .nr_events      : 118223
  .nohz_mode      : 2
  .idle_tick      : 3315500000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 753875
  .idle_calls     : 985645
  .idle_sleeps    : 770122
  .idle_entrytime : 3316196013563 nsecs
  .idle_sleeptime : 3079535676376 nsecs
  .last_jiffies   : 754054
  .next_jiffies   : 754085
  .idle_expires   : 3315996000000 nsecs
jiffies: 754060

cpu: 1
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197343983635176004 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f7829e34>, it_real_fn, S:01, do_setitimer, sendmail/3036
 # expires at 3634545118202 nsecs [in 318634397814 nsecs]
 #1: <f7829e34>, it_real_fn, S:01, do_setitimer, sendmail/3047
 # expires at 3634633106605 nsecs [in 318722386217 nsecs]
  .expires_next   : 3315813000000 nsecs
  .hres_active    : 1
  .nr_events      : 52555
  .nohz_mode      : 2
  .idle_tick      : 3302001000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 750500
  .idle_calls     : 61676
  .idle_sleeps    : 22325
  .idle_entrytime : 3315812024367 nsecs
  .idle_sleeptime : 3172329298971 nsecs
  .last_jiffies   : 753954
  .next_jiffies   : 825443
  .idle_expires   : 3601768000000 nsecs
jiffies: 754122


Tick Device: mode:     1
Clock Event Device: hpet
 max_delta_ns:   2147483647
 min_delta_ns:   3352
 mult:           61496110
 shift:          32
 mode:           3
 next_event:     3316544000000 nsecs
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode
 event_handler:  tick_handle_oneshot_broadcast
tick_broadcast_mask: 00000003
tick_broadcast_oneshot_mask: 00000003


Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805384969
 min_delta_ns:   1440
 mult:           44734871
 shift:          32
 mode:           1
 next_event:     3316636000000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805384969
 min_delta_ns:   1440
 mult:           44734871
 shift:          32
 mode:           1
 next_event:     9223372036854775807 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

BUG: soft lockup - CPU#1 stuck for 17s! [swapper:0]

Pid: 0, comm: swapper Not tainted (2.6.24-rc4 #15)
EIP: 0060:[<c0533d06>] EFLAGS: 00000206 CPU: 1
EIP is at acpi_idle_enter_simple+0x166/0x1d0
EAX: f7829f88 EBX: 0000000a ECX: 00000266 EDX: 00000000
ESI: 00000000 EDI: 00855ac8 EBP: 00855abe ESP: f7829f88
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 086e902c CR3: 3721b000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c058cf03>] cpuidle_idle_call+0x53/0x78
 [<c058ceb0>] cpuidle_idle_call+0x0/0x78
 [<c0402575>] cpu_idle+0x97/0xb8
 =======================
Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 3339110116699 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197343983635176004 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f7829e34>, tick_sched_timer, S:01, tick_nohz_restart_sched_tick, swapper/0
 # expires at 3339224000000 nsecs [in 113883301 nsecs]
 #1: <f7829e34>, hrtimer_wakeup, S:01, do_nanosleep, irqbalance/2663
 # expires at 3342364827041 nsecs [in 3254710342 nsecs]
 #2: <f7829e34>, hrtimer_wakeup, S:01, do_nanosleep, crond/3083
 # expires at 3358119467677 nsecs [in 19009350978 nsecs]
 #3: <f7829e34>, it_real_fn, S:01, do_setitimer, syslogd/2643
 # expires at 3368995727615 nsecs [in 29885610916 nsecs]
 #4: <f7829e34>, hrtimer_wakeup, S:01, do_nanosleep, atd/3184
 # expires at 3637524360558 nsecs [in 298414243859 nsecs]
 #5: <f7829e34>, hrtimer_wakeup, S:01, do_nanosleep, smartd/3313
 # expires at 3645576708660 nsecs [in 306466591961 nsecs]
  .expires_next   : 3339320000000 nsecs
  .hres_active    : 1
  .nr_events      : 118638
  .nohz_mode      : 2
  .idle_tick      : 3339000000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 759750
  .idle_calls     : 986993
  .idle_sleeps    : 770348
  .idle_entrytime : 3339396057527 nsecs
  .idle_sleeptime : 3101499603762 nsecs
  .last_jiffies   : 759854
  .next_jiffies   : 759875
  .idle_expires   : 3339396000000 nsecs
jiffies: 759860

cpu: 1
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197343983635176004 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f7829e34>, it_real_fn, S:01, do_setitimer, sendmail/3036
 # expires at 3634545118202 nsecs [in 295435001503 nsecs]
 #1: <f7829e34>, it_real_fn, S:01, do_setitimer, sendmail/3047
 # expires at 3634633106605 nsecs [in 295522989906 nsecs]
  .expires_next   : 3339013000000 nsecs
  .hres_active    : 1
  .nr_events      : 52575
  .nohz_mode      : 2
  .idle_tick      : 3320845000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 755211
  .idle_calls     : 61702
  .idle_sleeps    : 22333
  .idle_entrytime : 3339010504626 nsecs
  .idle_sleeptime : 3194546573260 nsecs
  .last_jiffies   : 759753
  .next_jiffies   : 825443
  .idle_expires   : 3601768000000 nsecs
jiffies: 759921


Tick Device: mode:     1
Clock Event Device: hpet
 max_delta_ns:   2147483647
 min_delta_ns:   3352
 mult:           61496110
 shift:          32
 mode:           3
 next_event:     3339744000000 nsecs
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode
 event_handler:  tick_handle_oneshot_broadcast
tick_broadcast_mask: 00000003
tick_broadcast_oneshot_mask: 00000003


Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805384969
 min_delta_ns:   1440
 mult:           44734871
 shift:          32
 mode:           1
 next_event:     3339832000000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805384969
 min_delta_ns:   1440
 mult:           44734871
 shift:          32
 mode:           1
 next_event:     9223372036854775807 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

BUG: soft lockup - CPU#1 stuck for 15s! [swapper:0]

Pid: 0, comm: swapper Not tainted (2.6.24-rc4 #15)
EIP: 0060:[<c0533d06>] EFLAGS: 00000206 CPU: 1
EIP is at acpi_idle_enter_simple+0x166/0x1d0
EAX: f7829f88 EBX: 00000da7 ECX: 00000266 EDX: 00000000
ESI: 00000000 EDI: 009dd0d4 EBP: 009dc32d ESP: f7829f88
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 086e902c CR3: 3721b000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c058cf03>] cpuidle_idle_call+0x53/0x78
 [<c058ceb0>] cpuidle_idle_call+0x0/0x78
 [<c0402575>] cpu_idle+0x97/0xb8
 =======================
Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 3358306003372 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197343983635176004 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f7829e34>, tick_sched_timer, S:01, tick_nohz_restart_sched_tick, swapper/0
 # expires at 3358420000000 nsecs [in 113996628 nsecs]
 #1: <f7829e34>, hrtimer_wakeup, S:01, do_nanosleep, irqbalance/2663
 # expires at 3362364827247 nsecs [in 4058823875 nsecs]
 #2: <f7829e34>, it_real_fn, S:01, do_setitimer, syslogd/2643
 # expires at 3368995727615 nsecs [in 10689724243 nsecs]
 #3: <f7829e34>, hrtimer_wakeup, S:01, do_nanosleep, crond/3083
 # expires at 3418119574321 nsecs [in 59813570949 nsecs]
 #4: <f7829e34>, hrtimer_wakeup, S:01, do_nanosleep, atd/3184
 # expires at 3637524360558 nsecs [in 279218357186 nsecs]
 #5: <f7829e34>, hrtimer_wakeup, S:01, do_nanosleep, smartd/3313
 # expires at 3645576708660 nsecs [in 287270705288 nsecs]
  .expires_next   : 3358516000000 nsecs
  .hres_active    : 1
  .nr_events      : 119037
  .nohz_mode      : 2
  .idle_tick      : 3358132000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 764533
  .idle_calls     : 988268
  .idle_sleeps    : 770593
  .idle_entrytime : 3358592013279 nsecs
  .idle_sleeptime : 3119453550713 nsecs
  .last_jiffies   : 764653
  .next_jiffies   : 764735
  .idle_expires   : 3358288000000 nsecs
jiffies: 764659

cpu: 1
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197343983635176004 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f7829e34>, it_real_fn, S:01, do_setitimer, sendmail/3036
 # expires at 3634545118202 nsecs [in 276239114830 nsecs]
 #1: <f7829e34>, it_real_fn, S:01, do_setitimer, sendmail/3047
 # expires at 3634633106605 nsecs [in 276327103233 nsecs]
  .expires_next   : 3358209000000 nsecs
  .hres_active    : 1
  .nr_events      : 52601
  .nohz_mode      : 2
  .idle_tick      : 3343153000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 760788
  .idle_calls     : 61735
  .idle_sleeps    : 22340
  .idle_entrytime : 3358208022533 nsecs
  .idle_sleeptime : 3212747374331 nsecs
  .last_jiffies   : 764553
  .next_jiffies   : 825443
  .idle_expires   : 3601768000000 nsecs
jiffies: 764720


Tick Device: mode:     1
Clock Event Device: hpet
 max_delta_ns:   2147483647
 min_delta_ns:   3352
 mult:           61496110
 shift:          32
 mode:           3
 next_event:     3358940000000 nsecs
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode
 event_handler:  tick_handle_oneshot_broadcast
tick_broadcast_mask: 00000003
tick_broadcast_oneshot_mask: 00000003


Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805384969
 min_delta_ns:   1440
 mult:           44734871
 shift:          32
 mode:           1
 next_event:     3359028000000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805384969
 min_delta_ns:   1440
 mult:           44734871
 shift:          32
 mode:           1
 next_event:     9223372036854775807 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

BUG: soft lockup - CPU#1 stuck for 13s! [squid_redirect:3109]

Pid: 3109, comm: squid_redirect Not tainted (2.6.24-rc4 #15)
EIP: 0060:[<c05a0ca2>] EFLAGS: 00010246 CPU: 1
EIP is at __alloc_skb+0x5e/0xfb
EAX: 00000000 EBX: f6ebb300 ECX: 00000022 EDX: f7006800
ESI: 00000080 EDI: f6ebb304 EBP: 000004d0 ESP: f6eb1dd8
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
CR0: 80050033 CR2: 086e902c CR3: 3721b000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c059d70b>] sock_alloc_send_skb+0x6e/0x196
 [<c05fae2d>] unix_stream_sendmsg+0x15c/0x317
 [<c059b0d5>] sock_aio_write+0xe3/0xef
 [<c046ced1>] do_sync_write+0xc7/0x10a
 [<c0430e29>] autoremove_wake_function+0x0/0x35
 [<c0447e34>] audit_syscall_exit+0x2c7/0x2e3
 [<c046d6aa>] vfs_write+0xb5/0x117
 [<c046dc05>] sys_write+0x41/0x67
 [<c0403e26>] syscall_call+0x7/0xb
 =======================
Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 3378758554114 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197343983635176004 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f6eb1c84>, tick_sched_timer, S:01, tick_nohz_restart_sched_tick, swapper/0
 # expires at 3378880000000 nsecs [in 121445886 nsecs]
 #1: <f6eb1c84>, hrtimer_wakeup, S:01, do_nanosleep, irqbalance/2663
 # expires at 3382364827171 nsecs [in 3606273057 nsecs]
 #2: <f6eb1c84>, it_real_fn, S:01, do_setitimer, syslogd/2643
 # expires at 3398995770136 nsecs [in 20237216022 nsecs]
 #3: <f6eb1c84>, hrtimer_wakeup, S:01, do_nanosleep, crond/3083
 # expires at 3418119574321 nsecs [in 39361020207 nsecs]
 #4: <f6eb1c84>, hrtimer_wakeup, S:01, do_nanosleep, atd/3184
 # expires at 3637524360558 nsecs [in 258765806444 nsecs]
 #5: <f6eb1c84>, hrtimer_wakeup, S:01, do_nanosleep, smartd/3313
 # expires at 3645576708660 nsecs [in 266818154546 nsecs]
  .expires_next   : 3378980000000 nsecs
  .hres_active    : 1
  .nr_events      : 119459
  .nohz_mode      : 2
  .idle_tick      : 3378480000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 769621
  .idle_calls     : 989598
  .idle_sleeps    : 770848
  .idle_entrytime : 3379048011858 nsecs
  .idle_sleeptime : 3138622137644 nsecs
  .last_jiffies   : 769655
  .next_jiffies   : 769735
  .idle_expires   : 3378936000000 nsecs
jiffies: 769655

cpu: 1
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197343983635176004 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f6eb1c84>, it_real_fn, S:01, do_setitimer, sendmail/3036
 # expires at 3634545118202 nsecs [in 255786564088 nsecs]
 #1: <f6eb1c84>, it_real_fn, S:01, do_setitimer, sendmail/3047
 # expires at 3634633106605 nsecs [in 255874552491 nsecs]
  .expires_next   : 3378617000000 nsecs
  .hres_active    : 1
  .nr_events      : 52630
  .nohz_mode      : 2
  .idle_tick      : 3365009000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 766253
  .idle_calls     : 61772
  .idle_sleeps    : 22349
  .idle_entrytime : 3365008034288 nsecs
  .idle_sleeptime : 3232136157785 nsecs
  .last_jiffies   : 766253
  .next_jiffies   : 825443
  .idle_expires   : 3601768000000 nsecs
jiffies: 769655


Tick Device: mode:     1
Clock Event Device: hpet
 max_delta_ns:   2147483647
 min_delta_ns:   3352
 mult:           61496110
 shift:          32
 mode:           3
 next_event:     3379392000000 nsecs
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode
 event_handler:  tick_handle_oneshot_broadcast
tick_broadcast_mask: 00000003
tick_broadcast_oneshot_mask: 00000001


Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805384969
 min_delta_ns:   1440
 mult:           44734871
 shift:          32
 mode:           1
 next_event:     3379480000000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805384969
 min_delta_ns:   1440
 mult:           44734871
 shift:          32
 mode:           3
 next_event:     9223372036854775807 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

BUG: soft lockup - CPU#1 stuck for 13s! [swapper:0]

Pid: 0, comm: swapper Not tainted (2.6.24-rc4 #15)
EIP: 0060:[<c0533d06>] EFLAGS: 00000206 CPU: 1
EIP is at acpi_idle_enter_simple+0x166/0x1d0
EAX: f7829f88 EBX: 000003d2 ECX: 00000266 EDX: 00000000
ESI: 00000000 EDI: 004d7480 EBP: 004d70ae ESP: f7829f88
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b7cb8eb4 CR3: 3721b000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c058cf03>] cpuidle_idle_call+0x53/0x78
 [<c058ceb0>] cpuidle_idle_call+0x0/0x78
 [<c0402575>] cpu_idle+0x97/0xb8
 =======================
Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 3399017378968 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197343983635176004 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f7829e34>, tick_sched_timer, S:01, tick_nohz_restart_sched_tick, swapper/0
 # expires at 3399132000000 nsecs [in 114621032 nsecs]
 #1: <f7829e34>, hrtimer_wakeup, S:01, do_nanosleep, irqbalance/2663
 # expires at 3402364827246 nsecs [in 3347448278 nsecs]
 #2: <f7829e34>, hrtimer_wakeup, S:01, do_nanosleep, crond/3083
 # expires at 3418119574321 nsecs [in 19102195353 nsecs]
 #3: <f7829e34>, it_real_fn, S:01, do_setitimer, syslogd/2643
 # expires at 3428995802046 nsecs [in 29978423078 nsecs]
 #4: <f7829e34>, hrtimer_wakeup, S:01, do_nanosleep, atd/3184
 # expires at 3637524360558 nsecs [in 238506981590 nsecs]
 #5: <f7829e34>, hrtimer_wakeup, S:01, do_nanosleep, smartd/3313
 # expires at 3645576708660 nsecs [in 246559329692 nsecs]
  .expires_next   : 3399228000000 nsecs
  .hres_active    : 1
  .nr_events      : 119857
  .nohz_mode      : 2
  .idle_tick      : 3398596000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 774649
  .idle_calls     : 990978
  .idle_sleeps    : 771180
  .idle_entrytime : 3399300011523 nsecs
  .idle_sleeptime : 3157671876745 nsecs
  .last_jiffies   : 774731
  .next_jiffies   : 774741
  .idle_expires   : 3398996000000 nsecs
jiffies: 774731

cpu: 1
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197343983635176004 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f7829e34>, it_real_fn, S:01, do_setitimer, sendmail/3036
 # expires at 3634545118202 nsecs [in 235527739234 nsecs]
 #1: <f7829e34>, it_real_fn, S:01, do_setitimer, sendmail/3047
 # expires at 3634633106605 nsecs [in 235615727637 nsecs]
  .expires_next   : 3398921000000 nsecs
  .hres_active    : 1
  .nr_events      : 52664
  .nohz_mode      : 2
  .idle_tick      : 3384993000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 771248
  .idle_calls     : 61816
  .idle_sleeps    : 22362
  .idle_entrytime : 3398920723452 nsecs
  .idle_sleeptime : 3251373016329 nsecs
  .last_jiffies   : 774731
  .next_jiffies   : 825443
  .idle_expires   : 3601768000000 nsecs
jiffies: 774731


Tick Device: mode:     1
Clock Event Device: hpet
 max_delta_ns:   2147483647
 min_delta_ns:   3352
 mult:           61496110
 shift:          32
 mode:           3
 next_event:     3399644000000 nsecs
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode
 event_handler:  tick_handle_oneshot_broadcast
tick_broadcast_mask: 00000003
tick_broadcast_oneshot_mask: 00000003


Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805384969
 min_delta_ns:   1440
 mult:           44734871
 shift:          32
 mode:           1
 next_event:     3399736000000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805384969
 min_delta_ns:   1440
 mult:           44734871
 shift:          32
 mode:           1
 next_event:     9223372036854775807 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

BUG: soft lockup - CPU#1 stuck for 21s! [swapper:0]

Pid: 0, comm: swapper Not tainted (2.6.24-rc4 #15)
EIP: 0060:[<c0533d06>] EFLAGS: 00000206 CPU: 1
EIP is at acpi_idle_enter_simple+0x166/0x1d0
EAX: f7829f88 EBX: 0000026a ECX: 00000266 EDX: 00000000
ESI: 00000000 EDI: 000dc235 EBP: 000dbfcb ESP: f7829f88
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b7cb8eb4 CR3: 3721b000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c058cf03>] cpuidle_idle_call+0x53/0x78
 [<c058ceb0>] cpuidle_idle_call+0x0/0x78
 [<c0402575>] cpu_idle+0x97/0xb8
 =======================
Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 3425973316433 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197343983635176004 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f7829e34>, tick_sched_timer, S:01, tick_nohz_restart_sched_tick, swapper/0
 # expires at 3426088000000 nsecs [in 114683567 nsecs]
 #1: <f7829e34>, it_real_fn, S:01, do_setitimer, syslogd/2643
 # expires at 3428995802046 nsecs [in 3022485613 nsecs]
 #2: <f7829e34>, hrtimer_wakeup, S:01, do_nanosleep, irqbalance/2663
 # expires at 3432364826941 nsecs [in 6391510508 nsecs]
 #3: <f7829e34>, hrtimer_wakeup, S:01, do_nanosleep, crond/3083
 # expires at 3478119686256 nsecs [in 52146369823 nsecs]
 #4: <f7829e34>, hrtimer_wakeup, S:01, do_nanosleep, atd/3184
 # expires at 3637524360558 nsecs [in 211551044125 nsecs]
 #5: <f7829e34>, hrtimer_wakeup, S:01, do_nanosleep, smartd/3313
 # expires at 3645576708660 nsecs [in 219603392227 nsecs]
  .expires_next   : 3426184000000 nsecs
  .hres_active    : 1
  .nr_events      : 120297
  .nohz_mode      : 2
  .idle_tick      : 3425876000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 781469
  .idle_calls     : 992318
  .idle_sleeps    : 771457
  .idle_entrytime : 3426256011783 nsecs
  .idle_sleeptime : 3183364803024 nsecs
  .last_jiffies   : 781470
  .next_jiffies   : 781480
  .idle_expires   : 3425996000000 nsecs
jiffies: 781470

cpu: 1
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197343983635176004 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f7829e34>, it_real_fn, S:01, do_setitimer, sendmail/3036
 # expires at 3634545118202 nsecs [in 208571801769 nsecs]
 #1: <f7829e34>, it_real_fn, S:01, do_setitimer, sendmail/3047
 # expires at 3634633106605 nsecs [in 208659790172 nsecs]
  .expires_next   : 3425877000000 nsecs
  .hres_active    : 1
  .nr_events      : 52690
  .nohz_mode      : 2
  .idle_tick      : 3404129000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 776032
  .idle_calls     : 61850
  .idle_sleeps    : 22372
  .idle_entrytime : 3425876824416 nsecs
  .idle_sleeptime : 3277331921223 nsecs
  .last_jiffies   : 781470
  .next_jiffies   : 825443
  .idle_expires   : 3601768000000 nsecs
jiffies: 781470


Tick Device: mode:     1
Clock Event Device: hpet
 max_delta_ns:   2147483647
 min_delta_ns:   3352
 mult:           61496110
 shift:          32
 mode:           3
 next_event:     3426600000000 nsecs
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode
 event_handler:  tick_handle_oneshot_broadcast
tick_broadcast_mask: 00000003
tick_broadcast_oneshot_mask: 00000003


Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805384969
 min_delta_ns:   1440
 mult:           44734871
 shift:          32
 mode:           1
 next_event:     3426692000000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805384969
 min_delta_ns:   1440
 mult:           44734871
 shift:          32
 mode:           1
 next_event:     9223372036854775807 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

BUG: soft lockup - CPU#1 stuck for 13s! [squid_redirect:3109]

Pid: 3109, comm: squid_redirect Not tainted (2.6.24-rc4 #15)
EIP: 0060:[<c0406798>] EFLAGS: 00000202 CPU: 1
EIP is at do_syscall_trace+0xfe/0x16a
EAX: f6de15c0 EBX: 00000000 ECX: f6de15c0 EDX: 00000000
ESI: 00000000 EDI: 00000000 EBP: f6eb1fb8 ESP: f6eb1f94
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
CR0: 80050033 CR2: b7cb8eb4 CR3: 3721b000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c046db9e>] sys_read+0x41/0x67
 [<c0403f26>] syscall_exit_work+0x16/0x1b
 =======================
Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 3445397166939 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197343983635176004 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f6eb1e40>, tick_sched_timer, S:01, tick_nohz_restart_sched_tick, swapper/0
 # expires at 3445516000000 nsecs [in 118833061 nsecs]
 #1: <f6eb1e40>, hrtimer_wakeup, S:01, do_nanosleep, irqbalance/2663
 # expires at 3452364827341 nsecs [in 6967660402 nsecs]
 #2: <f6eb1e40>, it_real_fn, S:01, do_setitimer, syslogd/2643
 # expires at 3458995868510 nsecs [in 13598701571 nsecs]
 #3: <f6eb1e40>, hrtimer_wakeup, S:01, do_nanosleep, crond/3083
 # expires at 3478119686256 nsecs [in 32722519317 nsecs]
 #4: <f6eb1e40>, hrtimer_wakeup, S:01, do_nanosleep, atd/3184
 # expires at 3637524360558 nsecs [in 192127193619 nsecs]
 #5: <f6eb1e40>, hrtimer_wakeup, S:01, do_nanosleep, smartd/3313
 # expires at 3645576708660 nsecs [in 200179541721 nsecs]
  .expires_next   : 3445616000000 nsecs
  .hres_active    : 1
  .nr_events      : 120695
  .nohz_mode      : 2
  .idle_tick      : 3445000000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 786250
  .idle_calls     : 993728
  .idle_sleeps    : 771801
  .idle_entrytime : 3445688011834 nsecs
  .idle_sleeptime : 3201567185186 nsecs
  .last_jiffies   : 786327
  .next_jiffies   : 786337
  .idle_expires   : 3445496000000 nsecs
jiffies: 786327

cpu: 1
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197343983635176004 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f6eb1e40>, it_real_fn, S:01, do_setitimer, sendmail/3036
 # expires at 3634545118202 nsecs [in 189147951263 nsecs]
 #1: <f6eb1e40>, it_real_fn, S:01, do_setitimer, sendmail/3047
 # expires at 3634633106605 nsecs [in 189235939666 nsecs]
  .expires_next   : 3445305000000 nsecs
  .hres_active    : 1
  .nr_events      : 52725
  .nohz_mode      : 2
  .idle_tick      : 3432009000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 783003
  .idle_calls     : 61890
  .idle_sleeps    : 22382
  .idle_entrytime : 3432008033864 nsecs
  .idle_sleeptime : 3295603622377 nsecs
  .last_jiffies   : 783003
  .next_jiffies   : 825443
  .idle_expires   : 3601768000000 nsecs
jiffies: 786327


Tick Device: mode:     1
Clock Event Device: hpet
 max_delta_ns:   2147483647
 min_delta_ns:   3352
 mult:           61496110
 shift:          32
 mode:           3
 next_event:     3446036000000 nsecs
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode
 event_handler:  tick_handle_oneshot_broadcast
tick_broadcast_mask: 00000003
tick_broadcast_oneshot_mask: 00000001


Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805384969
 min_delta_ns:   1440
 mult:           44734871
 shift:          32
 mode:           1
 next_event:     3446124000000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805384969
 min_delta_ns:   1440
 mult:           44734871
 shift:          32
 mode:           3
 next_event:     9223372036854775807 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

BUG: soft lockup - CPU#1 stuck for 11s! [swapper:0]

Pid: 0, comm: swapper Not tainted (2.6.24-rc4 #15)
EIP: 0060:[<c0533d06>] EFLAGS: 00000206 CPU: 1
EIP is at acpi_idle_enter_simple+0x166/0x1d0
EAX: f7829f88 EBX: 00000da6 ECX: 00000266 EDX: 00000000
ESI: 00000000 EDI: 00804711 EBP: 0080396b ESP: f7829f88
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b7cb8eb4 CR3: 3721b000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c058cf03>] cpuidle_idle_call+0x53/0x78
 [<c058ceb0>] cpuidle_idle_call+0x0/0x78
 [<c0402575>] cpu_idle+0x97/0xb8
 =======================
Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 3470253369529 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197343983635176004 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f7829e34>, tick_sched_timer, S:01, tick_nohz_restart_sched_tick, swapper/0
 # expires at 3470368000000 nsecs [in 114630471 nsecs]
 #1: <f7829e34>, hrtimer_wakeup, S:01, do_nanosleep, irqbalance/2663
 # expires at 3472364827179 nsecs [in 2111457650 nsecs]
 #2: <f7829e34>, hrtimer_wakeup, S:01, do_nanosleep, crond/3083
 # expires at 3478119686256 nsecs [in 7866316727 nsecs]
 #3: <f7829e34>, it_real_fn, S:01, do_setitimer, syslogd/2643
 # expires at 3488995915727 nsecs [in 18742546198 nsecs]
 #4: <f7829e34>, hrtimer_wakeup, S:01, do_nanosleep, atd/3184
 # expires at 3637524360558 nsecs [in 167270991029 nsecs]
 #5: <f7829e34>, hrtimer_wakeup, S:01, do_nanosleep, smartd/3313
 # expires at 3645576708660 nsecs [in 175323339131 nsecs]
  .expires_next   : 3470464000000 nsecs
  .hres_active    : 1
  .nr_events      : 121145
  .nohz_mode      : 2
  .idle_tick      : 3470000000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 792500
  .idle_calls     : 995079
  .idle_sleeps    : 772053
  .idle_entrytime : 3470532015086 nsecs
  .idle_sleeptime : 3225097811941 nsecs
  .last_jiffies   : 792639
  .next_jiffies   : 792643
  .idle_expires   : 3470496000000 nsecs
jiffies: 792645

cpu: 1
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197343983635176004 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f7829e34>, it_real_fn, S:01, do_setitimer, sendmail/3036
 # expires at 3634545118202 nsecs [in 164291748673 nsecs]
 #1: <f7829e34>, it_real_fn, S:01, do_setitimer, sendmail/3047
 # expires at 3634633106605 nsecs [in 164379737076 nsecs]
  .expires_next   : 3470157000000 nsecs
  .hres_active    : 1
  .nr_events      : 52762
  .nohz_mode      : 2
  .idle_tick      : 3458613000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 789653
  .idle_calls     : 61939
  .idle_sleeps    : 22394
  .idle_entrytime : 3470156022499 nsecs
  .idle_sleeptime : 3319306712683 nsecs
  .last_jiffies   : 792540
  .next_jiffies   : 825443
  .idle_expires   : 3601768000000 nsecs
jiffies: 792706


Tick Device: mode:     1
Clock Event Device: hpet
 max_delta_ns:   2147483647
 min_delta_ns:   3352
 mult:           61496110
 shift:          32
 mode:           3
 next_event:     3470880000000 nsecs
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode
 event_handler:  tick_handle_oneshot_broadcast
tick_broadcast_mask: 00000003
tick_broadcast_oneshot_mask: 00000003


Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805384969
 min_delta_ns:   1440
 mult:           44734871
 shift:          32
 mode:           1
 next_event:     3470968000000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805384969
 min_delta_ns:   1440
 mult:           44734871
 shift:          32
 mode:           1
 next_event:     9223372036854775807 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

BUG: soft lockup - CPU#1 stuck for 13s! [swapper:0]

Pid: 0, comm: swapper Not tainted (2.6.24-rc4 #15)
EIP: 0060:[<c0603eaa>] EFLAGS: 00000202 CPU: 1
EIP is at _spin_lock_irqsave+0x16/0x27
EAX: c06b4110 EBX: 00000001 ECX: f7873808 EDX: 00000293
ESI: 00000005 EDI: f7873808 EBP: 00000000 ESP: f7829f10
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b7cb8eb4 CR3: 37dcc000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c0438293>] tick_broadcast_oneshot_control+0x10/0xda
 [<c0437ce2>] tick_notify+0x1d4/0x2eb
 [<c04281bc>] get_next_timer_interrupt+0x143/0x1b4
 [<c06058a1>] notifier_call_chain+0x2a/0x47
 [<c04345c0>] raw_notifier_call_chain+0x17/0x1a
 [<c043781e>] clockevents_notify+0x19/0x4f
 [<c0533d23>] acpi_idle_enter_simple+0x183/0x1d0
 [<c058cf03>] cpuidle_idle_call+0x53/0x78
 [<c058ceb0>] cpuidle_idle_call+0x0/0x78
 [<c0402575>] cpu_idle+0x97/0xb8
 =======================
Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 3489148567147 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197343983635176004 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f7829dbc>, tick_sched_timer, S:01, tick_nohz_stop_sched_tick, swapper/0
 # expires at 3489004000000 nsecs [in 18446744073564984469 nsecs]
 #1: <f7829dbc>, hrtimer_wakeup, S:01, do_nanosleep, irqbalance/2663
 # expires at 3492364827517 nsecs [in 3216260370 nsecs]
 #2: <f7829dbc>, hrtimer_wakeup, S:01, do_nanosleep, crond/3083
 # expires at 3538119802465 nsecs [in 48971235318 nsecs]
 #3: <f7829dbc>, hrtimer_wakeup, S:01, do_nanosleep, atd/3184
 # expires at 3637524360558 nsecs [in 148375793411 nsecs]
 #4: <f7829dbc>, hrtimer_wakeup, S:01, do_nanosleep, smartd/3313
 # expires at 3645576708660 nsecs [in 156428141513 nsecs]
  .expires_next   : 3489004000000 nsecs
  .hres_active    : 1
  .nr_events      : 121552
  .nohz_mode      : 2
  .idle_tick      : 3488500000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 797126
  .idle_calls     : 996547
  .idle_sleeps    : 772606
  .idle_entrytime : 3489000016669 nsecs
  .idle_sleeptime : 3242430478734 nsecs
  .last_jiffies   : 797251
  .next_jiffies   : 797375
  .idle_expires   : 3488996000000 nsecs
jiffies: 797251

cpu: 1
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197343983635176004 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f7829dbc>, it_real_fn, S:01, do_setitimer, syslogd/2643
 # expires at 3518995976435 nsecs [in 29847409288 nsecs]
 #1: <f7829dbc>, it_real_fn, S:01, do_setitimer, sendmail/3036
 # expires at 3634545118202 nsecs [in 145396551055 nsecs]
 #2: <f7829dbc>, it_real_fn, S:01, do_setitimer, sendmail/3047
 # expires at 3634633106605 nsecs [in 145484539458 nsecs]
  .expires_next   : 3488997000000 nsecs
  .hres_active    : 1
  .nr_events      : 52842
  .nohz_mode      : 2
  .idle_tick      : 3474001000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 793501
  .idle_calls     : 62051
  .idle_sleeps    : 22430
  .idle_entrytime : 3488995988657 nsecs
  .idle_sleeptime : 3336928804329 nsecs
  .last_jiffies   : 797249
  .next_jiffies   : 825443
  .idle_expires   : 3601768000000 nsecs
jiffies: 797251


Tick Device: mode:     1
Clock Event Device: hpet
 max_delta_ns:   2147483647
 min_delta_ns:   3352
 mult:           61496110
 shift:          32
 mode:           3
 next_event:     9223372036854775807 nsecs
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode
 event_handler:  tick_handle_oneshot_broadcast
tick_broadcast_mask: 00000003
tick_broadcast_oneshot_mask: 00000003


Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805384969
 min_delta_ns:   1440
 mult:           44734871
 shift:          32
 mode:           1
 next_event:     3489004000000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805384969
 min_delta_ns:   1440
 mult:           44734871
 shift:          32
 mode:           1
 next_event:     9223372036854775807 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

BUG: soft lockup - CPU#1 stuck for 18s! [squid_redirect:3109]

Pid: 3109, comm: squid_redirect Not tainted (2.6.24-rc4 #15)
EIP: 0073:[<00778e26>] EFLAGS: 00000286 CPU: 1
EIP is at 0x778e26
EAX: 00000000 EBX: 007ca5cc ECX: 0819993b EDX: 00000000
ESI: 082eafb0 EDI: 08199963 EBP: bfcc2d18 ESP: bfcc2ca0
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
CR0: 80050033 CR2: b7cb8eb4 CR3: 3721b000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 =======================
Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 3509959588108 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197343983635176004 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f6eb1e9c>, tick_sched_timer, S:01, tick_nohz_restart_sched_tick, swapper/0
 # expires at 3510076000000 nsecs [in 116411892 nsecs]
 #1: <f6eb1e9c>, hrtimer_wakeup, S:01, do_nanosleep, irqbalance/2663
 # expires at 3512364827593 nsecs [in 2405239485 nsecs]
 #2: <f6eb1e9c>, hrtimer_wakeup, S:01, do_nanosleep, crond/3083
 # expires at 3538119802465 nsecs [in 28160214357 nsecs]
 #3: <f6eb1e9c>, hrtimer_wakeup, S:01, do_nanosleep, atd/3184
 # expires at 3637524360558 nsecs [in 127564772450 nsecs]
 #4: <f6eb1e9c>, hrtimer_wakeup, S:01, do_nanosleep, smartd/3313
 # expires at 3645576708660 nsecs [in 135617120552 nsecs]
  .expires_next   : 3510156000000 nsecs
  .hres_active    : 1
  .nr_events      : 121736
  .nohz_mode      : 2
  .idle_tick      : 3509500000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 802375
  .idle_calls     : 997613
  .idle_sleeps    : 773233
  .idle_entrytime : 3510228013028 nsecs
  .idle_sleeptime : 3262173789757 nsecs
  .last_jiffies   : 802562
  .next_jiffies   : 802590
  .idle_expires   : 3509976000000 nsecs
jiffies: 802568

cpu: 1
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197343983635176004 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f6eb1e9c>, it_real_fn, S:01, do_setitimer, syslogd/2643
 # expires at 3518995976435 nsecs [in 9036388327 nsecs]
 #1: <f6eb1e9c>, it_real_fn, S:01, do_setitimer, sendmail/3036
 # expires at 3634545118202 nsecs [in 124585530094 nsecs]
 #2: <f6eb1e9c>, it_real_fn, S:01, do_setitimer, sendmail/3047
 # expires at 3634633106605 nsecs [in 124673518497 nsecs]
  .expires_next   : 3509881000000 nsecs
  .hres_active    : 1
  .nr_events      : 52891
  .nohz_mode      : 2
  .idle_tick      : 3490217000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 797554
  .idle_calls     : 62239
  .idle_sleeps    : 22472
  .idle_entrytime : 3509880022423 nsecs
  .idle_sleeptime : 3356666831101 nsecs
  .last_jiffies   : 802471
  .next_jiffies   : 825443
  .idle_expires   : 3601768000000 nsecs
jiffies: 802632


Tick Device: mode:     1
Clock Event Device: hpet
 max_delta_ns:   2147483647
 min_delta_ns:   3352
 mult:           61496110
 shift:          32
 mode:           3
 next_event:     3510588000000 nsecs
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode
 event_handler:  tick_handle_oneshot_broadcast
tick_broadcast_mask: 00000003
tick_broadcast_oneshot_mask: 00000001


Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805384969
 min_delta_ns:   1440
 mult:           44734871
 shift:          32
 mode:           1
 next_event:     3510680000000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805384969
 min_delta_ns:   1440
 mult:           44734871
 shift:          32
 mode:           3
 next_event:     9223372036854775807 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

BUG: soft lockup - CPU#1 stuck for 73s! [swapper:0]

Pid: 0, comm: swapper Not tainted (2.6.24-rc4 #15)
EIP: 0060:[<c0533d06>] EFLAGS: 00000206 CPU: 1
EIP is at acpi_idle_enter_simple+0x166/0x1d0
EAX: f7829f88 EBX: 00000009 ECX: 00000266 EDX: 00000000
ESI: 00000000 EDI: 00cd838d EBP: 00cd8384 ESP: f7829f88
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b7cb8eb4 CR3: 3721b000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c058cf03>] cpuidle_idle_call+0x53/0x78
 [<c058ceb0>] cpuidle_idle_call+0x0/0x78
 [<c0402575>] cpu_idle+0x97/0xb8
 =======================
Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 3598217317189 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197343983635176004 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f7829e34>, tick_sched_timer, S:01, tick_nohz_restart_sched_tick, swapper/0
 # expires at 3598332000000 nsecs [in 114682811 nsecs]
 #1: <f7829e34>, hrtimer_wakeup, S:01, do_nanosleep, irqbalance/2663
 # expires at 3602364827289 nsecs [in 4147510100 nsecs]
 #2: <f7829e34>, it_real_fn, S:01, do_setitimer, syslogd/2643
 # expires at 3608996157924 nsecs [in 10778840735 nsecs]
 #3: <f7829e34>, hrtimer_wakeup, S:01, do_nanosleep, atd/3184
 # expires at 3637524360558 nsecs [in 39307043369 nsecs]
 #4: <f7829e34>, hrtimer_wakeup, S:01, do_nanosleep, smartd/3313
 # expires at 3645576708660 nsecs [in 47359391471 nsecs]
 #5: <f7829e34>, hrtimer_wakeup, S:01, do_nanosleep, crond/3083
 # expires at 3658120033497 nsecs [in 59902716308 nsecs]
  .expires_next   : 3598428000000 nsecs
  .hres_active    : 1
  .nr_events      : 122506
  .nohz_mode      : 2
  .idle_tick      : 3598000000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 824500
  .idle_calls     : 999222
  .idle_sleeps    : 773694
  .idle_entrytime : 3598504013419 nsecs
  .idle_sleeptime : 3348824164217 nsecs
  .last_jiffies   : 824631
  .next_jiffies   : 824750
  .idle_expires   : 3598320000000 nsecs
jiffies: 824636

cpu: 1
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197343983635176004 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f7829e34>, it_real_fn, S:01, do_setitimer, sendmail/3036
 # expires at 3634545118202 nsecs [in 36327801013 nsecs]
 #1: <f7829e34>, it_real_fn, S:01, do_setitimer, sendmail/3047
 # expires at 3634633106605 nsecs [in 36415789416 nsecs]
  .expires_next   : 3598121000000 nsecs
  .hres_active    : 1
  .nr_events      : 52922
  .nohz_mode      : 2
  .idle_tick      : 3519005000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 804751
  .idle_calls     : 62274
  .idle_sleeps    : 22480
  .idle_entrytime : 3598120023719 nsecs
  .idle_sleeptime : 3443870779570 nsecs
  .last_jiffies   : 824531
  .next_jiffies   : 825443
  .idle_expires   : 3601768000000 nsecs
jiffies: 824698


Tick Device: mode:     1
Clock Event Device: hpet
 max_delta_ns:   2147483647
 min_delta_ns:   3352
 mult:           61496110
 shift:          32
 mode:           3
 next_event:     3598848000000 nsecs
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode
 event_handler:  tick_handle_oneshot_broadcast
tick_broadcast_mask: 00000003
tick_broadcast_oneshot_mask: 00000003


Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805384969
 min_delta_ns:   1440
 mult:           44734871
 shift:          32
 mode:           1
 next_event:     3598940000000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805384969
 min_delta_ns:   1440
 mult:           44734871
 shift:          32
 mode:           1
 next_event:     9223372036854775807 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

BUG: soft lockup - CPU#1 stuck for 16s! [swapper:0]

Pid: 0, comm: swapper Not tainted (2.6.24-rc4 #15)
EIP: 0060:[<c0603eaa>] EFLAGS: 00000202 CPU: 1
EIP is at _spin_lock_irqsave+0x16/0x27
EAX: c06b4110 EBX: 00000001 ECX: f7873808 EDX: 00000293
ESI: 00000005 EDI: f7873808 EBP: 00000000 ESP: f7829f10
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: bfef28a8 CR3: 37370000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c0438293>] tick_broadcast_oneshot_control+0x10/0xda
 [<c0437ce2>] tick_notify+0x1d4/0x2eb
 [<c04281bc>] get_next_timer_interrupt+0x143/0x1b4
 [<c06058a1>] notifier_call_chain+0x2a/0x47
 [<c04345c0>] raw_notifier_call_chain+0x17/0x1a
 [<c043781e>] clockevents_notify+0x19/0x4f
 [<c0533d23>] acpi_idle_enter_simple+0x183/0x1d0
 [<c058cf03>] cpuidle_idle_call+0x53/0x78
 [<c058ceb0>] cpuidle_idle_call+0x0/0x78
 [<c0402575>] cpu_idle+0x97/0xb8
 =======================
Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 4167069767337 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197343983635176004 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f7829dbc>, tick_sched_timer, S:01, tick_nohz_restart_sched_tick, swapper/0
 # expires at 4166924000000 nsecs [in 18446744073563784279 nsecs]
 #1: <f7829dbc>, hrtimer_wakeup, S:01, do_nanosleep, irqbalance/2663
 # expires at 4172364827191 nsecs [in 5295059854 nsecs]
 #2: <f7829dbc>, it_real_fn, S:01, do_setitimer, syslogd/2643
 # expires at 4178996866281 nsecs [in 11927098944 nsecs]
 #3: <f7829dbc>, hrtimer_wakeup, S:01, do_nanosleep, crond/3083
 # expires at 4198120966920 nsecs [in 31051199583 nsecs]
 #4: <f7829dbc>, hrtimer_wakeup, S:01, do_nanosleep, atd/3184
 # expires at 4237524532033 nsecs [in 70454764696 nsecs]
 #5: <f7829dbc>, hrtimer_wakeup, S:01, do_nanosleep, smartd/3313
 # expires at 5445738202858 nsecs [in 1278668435521 nsecs]
  .expires_next   : 4166924000000 nsecs
  .hres_active    : 1
  .nr_events      : 125855
  .nohz_mode      : 2
  .idle_tick      : 4166872000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 966718
  .idle_calls     : 1003972
  .idle_sleeps    : 777081
  .idle_entrytime : 4166921107361 nsecs
  .idle_sleeptime : 3914047603252 nsecs
  .last_jiffies   : 966731
  .next_jiffies   : 966740
  .idle_expires   : 4166996000000 nsecs
jiffies: 966731

cpu: 1
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197343983635176004 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f7829dbc>, it_real_fn, S:01, do_setitimer, sendmail/3036
 # expires at 7234546066766 nsecs [in 3067476299429 nsecs]
 #1: <f7829dbc>, it_real_fn, S:01, do_setitimer, sendmail/3047
 # expires at 7234633977840 nsecs [in 3067564210503 nsecs]
  .expires_next   : 4166921000000 nsecs
  .hres_active    : 1
  .nr_events      : 53499
  .nohz_mode      : 2
  .idle_tick      : 4150253000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 962563
  .idle_calls     : 62865
  .idle_sleeps    : 22602
  .idle_entrytime : 4166918657364 nsecs
  .idle_sleeptime : 4009849868806 nsecs
  .last_jiffies   : 966730
  .next_jiffies   : 970000
  .idle_expires   : 4179996000000 nsecs
jiffies: 966731


Tick Device: mode:     1
Clock Event Device: hpet
 max_delta_ns:   2147483647
 min_delta_ns:   3352
 mult:           61496110
 shift:          32
 mode:           3
 next_event:     9223372036854775807 nsecs
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode
 event_handler:  tick_handle_oneshot_broadcast
tick_broadcast_mask: 00000003
tick_broadcast_oneshot_mask: 00000003


Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805384969
 min_delta_ns:   1440
 mult:           44734871
 shift:          32
 mode:           1
 next_event:     4166924000000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805384969
 min_delta_ns:   1440
 mult:           44734871
 shift:          32
 mode:           1
 next_event:     9223372036854775807 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

BUG: soft lockup - CPU#1 stuck for 20s! [swapper:0]

Pid: 0, comm: swapper Not tainted (2.6.24-rc4 #15)
EIP: 0060:[<c0533d06>] EFLAGS: 00000202 CPU: 1
EIP is at acpi_idle_enter_simple+0x166/0x1d0
EAX: f7829f88 EBX: 0000000a ECX: 00000266 EDX: 00000000
ESI: 00000000 EDI: 0053a918 EBP: 0053a90e ESP: f7829f88
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 080ff4a8 CR3: 36f0e000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c058cf03>] cpuidle_idle_call+0x53/0x78
 [<c058ceb0>] cpuidle_idle_call+0x0/0x78
 [<c0402575>] cpu_idle+0x97/0xb8
 =======================
Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 4261546668428 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197343983635176004 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f7829e34>, tick_sched_timer, S:01, tick_nohz_restart_sched_tick, swapper/0
 # expires at 4261660000000 nsecs [in 113331572 nsecs]
 #1: <f7829e34>, hrtimer_wakeup, S:01, do_nanosleep, irqbalance/2663
 # expires at 4262364827121 nsecs [in 818158693 nsecs]
 #2: <f7829e34>, it_real_fn, S:01, do_setitimer, syslogd/2643
 # expires at 4268996983467 nsecs [in 7450315039 nsecs]
 #3: <f7829e34>, hrtimer_wakeup, S:01, do_nanosleep, crond/3083
 # expires at 4318121181735 nsecs [in 56574513307 nsecs]
 #4: <f7829e34>, hrtimer_wakeup, S:01, do_nanosleep, atd/3184
 # expires at 4537524611720 nsecs [in 275977943292 nsecs]
 #5: <f7829e34>, hrtimer_wakeup, S:01, do_nanosleep, smartd/3313
 # expires at 5445738202858 nsecs [in 1184191534430 nsecs]
  .expires_next   : 4261756000000 nsecs
  .hres_active    : 1
  .nr_events      : 126606
  .nohz_mode      : 2
  .idle_tick      : 4261356000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 990339
  .idle_calls     : 1007304
  .idle_sleeps    : 779634
  .idle_entrytime : 4261828014556 nsecs
  .idle_sleeptime : 4006637937696 nsecs
  .last_jiffies   : 990462
  .next_jiffies   : 990500
  .idle_expires   : 4261496000000 nsecs
jiffies: 990468

cpu: 1
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197343983635176004 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f7829e34>, it_real_fn, S:01, do_setitimer, sendmail/3036
 # expires at 7234546066766 nsecs [in 2972999398338 nsecs]
 #1: <f7829e34>, it_real_fn, S:01, do_setitimer, sendmail/3047
 # expires at 7234633977840 nsecs [in 2973087309412 nsecs]
  .expires_next   : 4261449000000 nsecs
  .hres_active    : 1
  .nr_events      : 53573
  .nohz_mode      : 2
  .idle_tick      : 4240017000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 985004
  .idle_calls     : 62997
  .idle_sleeps    : 22668
  .idle_entrytime : 4261446283566 nsecs
  .idle_sleeptime : 4103195796783 nsecs
  .last_jiffies   : 990362
  .next_jiffies   : 992500
  .idle_expires   : 4269996000000 nsecs
jiffies: 990529


Tick Device: mode:     1
Clock Event Device: hpet
 max_delta_ns:   2147483647
 min_delta_ns:   3352
 mult:           61496110
 shift:          32
 mode:           3
 next_event:     4262172000000 nsecs
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode
 event_handler:  tick_handle_oneshot_broadcast
tick_broadcast_mask: 00000003
tick_broadcast_oneshot_mask: 00000003


Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805384969
 min_delta_ns:   1440
 mult:           44734871
 shift:          32
 mode:           1
 next_event:     4262264000000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805384969
 min_delta_ns:   1440
 mult:           44734871
 shift:          32
 mode:           1
 next_event:     9223372036854775807 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

BUG: soft lockup - CPU#1 stuck for 11s! [swapper:0]

Pid: 0, comm: swapper Not tainted (2.6.24-rc4 #15)
EIP: 0060:[<c0603eaa>] EFLAGS: 00000202 CPU: 1
EIP is at _spin_lock_irqsave+0x16/0x27
EAX: c06b4110 EBX: 00000001 ECX: f7873808 EDX: 00000293
ESI: 00000005 EDI: f7873808 EBP: 00000000 ESP: f7829f10
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 080ff4a8 CR3: 37344000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c0438293>] tick_broadcast_oneshot_control+0x10/0xda
 [<c0437ce2>] tick_notify+0x1d4/0x2eb
 [<c04281bc>] get_next_timer_interrupt+0x143/0x1b4
 [<c06058a1>] notifier_call_chain+0x2a/0x47
 [<c04345c0>] raw_notifier_call_chain+0x17/0x1a
 [<c043781e>] clockevents_notify+0x19/0x4f
 [<c0533d23>] acpi_idle_enter_simple+0x183/0x1d0
 [<c058cf03>] cpuidle_idle_call+0x53/0x78
 [<c058ceb0>] cpuidle_idle_call+0x0/0x78
 [<c0402575>] cpu_idle+0x97/0xb8
 =======================
Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 4281836818905 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197343983635176004 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f7829dbc>, tick_sched_timer, S:01, tick_nohz_restart_sched_tick, swapper/0
 # expires at 4281692000000 nsecs [in 18446744073564732711 nsecs]
 #1: <f7829dbc>, hrtimer_wakeup, S:01, do_nanosleep, irqbalance/2663
 # expires at 4282364827815 nsecs [in 528008910 nsecs]
 #2: <f7829dbc>, it_real_fn, S:01, do_setitimer, syslogd/2643
 # expires at 4298997022577 nsecs [in 17160203672 nsecs]
 #3: <f7829dbc>, hrtimer_wakeup, S:01, do_nanosleep, crond/3083
 # expires at 4318121181735 nsecs [in 36284362830 nsecs]
 #4: <f7829dbc>, hrtimer_wakeup, S:01, do_nanosleep, atd/3184
 # expires at 4537524611720 nsecs [in 255687792815 nsecs]
 #5: <f7829dbc>, hrtimer_wakeup, S:01, do_nanosleep, smartd/3313
 # expires at 5445738202858 nsecs [in 1163901383953 nsecs]
  .expires_next   : 4281692000000 nsecs
  .hres_active    : 1
  .nr_events      : 126862
  .nohz_mode      : 2
  .idle_tick      : 4281500000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 995375
  .idle_calls     : 1007974
  .idle_sleeps    : 779749
  .idle_entrytime : 4281689136364 nsecs
  .idle_sleeptime : 4025848101273 nsecs
  .last_jiffies   : 995423
  .next_jiffies   : 995438
  .idle_expires   : 4281996000000 nsecs
jiffies: 995423

cpu: 1
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197343983635176004 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f7829dbc>, it_real_fn, S:01, do_setitimer, sendmail/3036
 # expires at 7234546066766 nsecs [in 2952709247861 nsecs]
 #1: <f7829dbc>, it_real_fn, S:01, do_setitimer, sendmail/3047
 # expires at 7234633977840 nsecs [in 2952797158935 nsecs]
  .expires_next   : 4281689000000 nsecs
  .hres_active    : 1
  .nr_events      : 53582
  .nohz_mode      : 2
  .idle_tick      : 4270017000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 992504
  .idle_calls     : 63006
  .idle_sleeps    : 22670
  .idle_entrytime : 4281688022031 nsecs
  .idle_sleeptime : 4122505836637 nsecs
  .last_jiffies   : 995423
  .next_jiffies   : 1000000
  .idle_expires   : 4299996000000 nsecs
jiffies: 995423


Tick Device: mode:     1
Clock Event Device: hpet
 max_delta_ns:   2147483647
 min_delta_ns:   3352
 mult:           61496110
 shift:          32
 mode:           3
 next_event:     9223372036854775807 nsecs
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode
 event_handler:  tick_handle_oneshot_broadcast
tick_broadcast_mask: 00000003
tick_broadcast_oneshot_mask: 00000003


Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805384969
 min_delta_ns:   1440
 mult:           44734871
 shift:          32
 mode:           1
 next_event:     4281692000000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805384969
 min_delta_ns:   1440
 mult:           44734871
 shift:          32
 mode:           1
 next_event:     9223372036854775807 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

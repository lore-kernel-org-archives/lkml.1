Return-Path: <linux-kernel-owner+w=401wt.eu-S1757784AbXLQNIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784AbXLQNIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 08:08:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754928AbXLQNI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 08:08:29 -0500
Received: from nz-out-0506.google.com ([64.233.162.238]:27882 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386AbXLQNI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 08:08:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sPeG6sjnDFW0+0ju0NehTd+dq7LvbUwisVZfJ83ZWOf5N7QloD7rGdpfuUrzmCXUpl/eJiyLm3UOFFe+rH6J101NO2XYbvBTanxT12grmNCKoZyAsiChyjIV32q/VDAF7sJdlo5LM6vuvZHuR4PfyqbyBR6AGyTP4jqvbkuwbM0=
Message-ID: <82e4877d0712170508r69189409l803c8f490e65925d@mail.gmail.com>
Date: Mon, 17 Dec 2007 08:08:24 -0500
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: soft lockup - CPU#1 stuck for 15s! [swapper:0]
Cc: "Len Brown" <lenb@kernel.org>, "Arjan van de Ven" <arjan@infradead.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <alpine.LFD.0.99999.0712170904120.3670@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <924EFEDD5F540B4284297C4DC59F3DEE38C3C2@orsmsx423.amr.corp.intel.com>
	 <alpine.LFD.0.99999.0712101117300.11977@localhost.localdomain>
	 <82e4877d0712102049g4830a573n86b7f72f31a42f11@mail.gmail.com>
	 <200712141817.47581.lenb@kernel.org>
	 <82e4877d0712141651j3965fd85ged2cefed5336e1ef@mail.gmail.com>
	 <alpine.LFD.0.99999.0712150907180.6933@localhost.localdomain>
	 <Pine.LNX.4.64.0712151340060.3807@mini.warudkars.net>
	 <Pine.LNX.4.64.0712160015020.7320@mini.warudkars.net>
	 <82e4877d0712160543t2c7a03b1qb5c77ea6af59b5dd@mail.gmail.com>
	 <alpine.LFD.0.99999.0712170904120.3670@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 17, 2007 3:05 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Sun, 16 Dec 2007, Parag Warudkar wrote:
>
> > On Dec 16, 2007 12:15 AM, Parag Warudkar <parag.warudkar@gmail.com> wrote:
> > > On Sat, 15 Dec 2007, Parag Warudkar wrote:
> > >
> > > >> I will run it for a little longer just to be sure - but I don't think it
> > > >> will be a problem.
> > >
> > > No problems for last 10 hours - I consider this fixed.
> > >
> >
> > Arghh - spoke 8 hours too soon. I left it running overnight and
> > morning I see a bunch of softlockups - so NO NOT FIXED.
> >
> > Parag
> >
> > BUG: soft lockup - CPU#1 stuck for 13s! [swapper:0]
> >
> > Pid: 0, comm: swapper Not tainted (2.6.24-rc5 #21)
> > EIP: 0060:[<c0533ca6>] EFLAGS: 00000206 CPU: 1
> > EIP is at acpi_idle_enter_simple+0x166/0x1d0
> > EAX: f7829f88 EBX: 00000dab ECX: 00000266 EDX: 00000000
> > ESI: 00000000 EDI: 00c056e5 EBP: 00c0493a ESP: f7829f88
> >  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> > CR0: 8005003b CR2: 080f6c78 CR3: 00718000 CR4: 000006d0
> > DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> > DR6: ffff0ff0 DR7: 00000400
>
> Sigh. You did not have the debug patch applied anymore, which printks
> the timer_list data ? Can you apply it again and provide the output
> please ?
>

This keeps getting more and more weird - This time I was running with
CONFIG_CPU_IDLE=N and I have ton of soft lockups after 14hr uptime.

The timer_list data for a few lockups is below. If you need the full
thing grab it from http://warudkars.net/messages.bz2 .

BUG: soft lockup - CPU#1 stuck for 12s! [kjournald:424]

Pid: 424, comm: kjournald Not tainted (2.6.24-rc5 #24)
EIP: 0060:[<c04bbd57>] EFLAGS: 00000206 CPU: 1
EIP is at __journal_remove_journal_head+0x18/0xe8
EAX: dc75e1c0 EBX: dc75e1c0 ECX: f6d539f0 EDX: dc75e1f8
ESI: dc75e1f8 EDI: 00000009 EBP: f712a000 ESP: f7157f28
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b7d18eb4 CR3: 37352000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c04b8680>] __journal_unfile_buffer+0x8/0x11
 [<c04bbe64>] journal_put_journal_head+0x3d/0x4b
 [<c04ba254>] journal_commit_transaction+0x75d/0xbc9
 [<c0428246>] lock_timer_base+0x19/0x35
 [<c04bcda0>] kjournald+0xa2/0x1d0
 [<c0430e29>] autoremove_wake_function+0x0/0x35
 [<c04bccfe>] kjournald+0x0/0x1d0
 [<c0430d63>] kthread+0x38/0x5d
 [<c0430d2b>] kthread+0x0/0x5d
 [<c0404a0f>] kernel_thread_helper+0x7/0x10
 =======================
Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 39080147128907 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197846065352886518 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f7157dd4>, tick_sched_timer, S:01, tick_nohz_stop_sched_tick, swapper/0
 # expires at 39080272000000 nsecs [in 124871093 nsecs]
 #1: <f7157dd4>, it_real_fn, S:01, do_setitimer, syslogd/2522
 # expires at 39086475543333 nsecs [in 6328414426 nsecs]
 #2: <f7157dd4>, hrtimer_wakeup, S:01, do_nanosleep, atd/3039
 # expires at 39332442305024 nsecs [in 252295176117 nsecs]
  .expires_next   : 39080320000000 nsecs
  .hres_active    : 1
  .nr_events      : 81214
  .nohz_mode      : 2
  .idle_tick      : 39078000000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 9694501
  .idle_calls     : 171123
  .idle_sleeps    : 106664
  .idle_entrytime : 39080384013047 nsecs
  .idle_sleeptime : 38923743508612 nsecs
  .last_jiffies   : 9695101
  .next_jiffies   : 9695250
  .idle_expires   : 39079996000000 nsecs
jiffies: 9695106

cpu: 1
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197846065352886518 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f7157dd4>, hrtimer_wakeup, S:01, do_nanosleep, crond/2946
 # expires at 39115730211364 nsecs [in 35583082457 nsecs]
 #1: <f7157dd4>, hrtimer_wakeup, S:01, do_nanosleep, smartd/3480
 # expires at 39641838017337 nsecs [in 561690888430 nsecs]
  .expires_next   : 39079997000000 nsecs
  .hres_active    : 1
  .nr_events      : 48789
  .nohz_mode      : 2
  .idle_tick      : 39066865000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 9691717
  .idle_calls     : 125065
  .idle_sleeps    : 79815
  .idle_entrytime : 39079996603653 nsecs
  .idle_sleeptime : 38923914717954 nsecs
  .last_jiffies   : 9695000
  .next_jiffies   : 9695467
  .idle_expires   : 39081864000000 nsecs
jiffies: 9695162


Tick Device: mode:     1
Clock Event Device: hpet
 max_delta_ns:   2147483647
 min_delta_ns:   3352
 mult:           61496110
 shift:          32
 mode:           3
 next_event:     39080704000000 nsecs
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode
 event_handler:  tick_handle_oneshot_broadcast
tick_broadcast_mask: 00000003
tick_broadcast_oneshot_mask: 00000001


Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805378776
 min_delta_ns:   1440
 mult:           44735215
 shift:          32
 mode:           1
 next_event:     39080796000000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805378776
 min_delta_ns:   1440
 mult:           44735215
 shift:          32
 mode:           3
 next_event:     9223372036854775807 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

BUG: soft lockup - CPU#1 stuck for 12s! [kjournald:424]

Pid: 424, comm: kjournald Not tainted (2.6.24-rc5 #24)
EIP: 0060:[<f8bb3e78>] EFLAGS: 00000202 CPU: 1
EIP is at scsi_request_fn+0x265/0x326 [scsi_mod]
EAX: f7bb8000 EBX: f7bb8000 ECX: f70fe028 EDX: f70fe028
ESI: f70fe000 EDI: f7105400 EBP: f70de408 ESP: f7157e18
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b7d18eb4 CR3: 37d98000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c04e4ca4>] blk_remove_plug+0x4f/0x5b
 [<c04e4ccd>] __generic_unplug_device+0x1d/0x1f
 [<c04e58e8>] generic_unplug_device+0x15/0x21
 [<c04e3919>] blk_unplug+0x72/0x7a
 [<f8b94813>] dm_table_unplug_all+0x1e/0x27 [dm_mod]
 [<f8b92c63>] dm_unplug_all+0x17/0x21 [dm_mod]
 [<c04e3919>] blk_unplug+0x72/0x7a
 [<c0488fe1>] sync_buffer+0x2b/0x33
 [<c0602e5a>] __wait_on_bit+0x33/0x58
 [<c0488fb6>] sync_buffer+0x0/0x33
 [<c0488fb6>] sync_buffer+0x0/0x33
 [<c0602ee2>] out_of_line_wait_on_bit+0x63/0x6b
 [<c0430e5e>] wake_bit_function+0x0/0x3c
 [<c0488f80>] __wait_on_buffer+0x24/0x27
 [<c0489d72>] sync_dirty_buffer+0x7f/0xb4
 [<c04bd21f>] journal_get_descriptor_buffer+0x79/0x7f
 [<c04ba3d3>] journal_commit_transaction+0x8dc/0xbc9
 [<c0428246>] lock_timer_base+0x19/0x35
 [<c04bcda0>] kjournald+0xa2/0x1d0
 [<c0430e29>] autoremove_wake_function+0x0/0x35
 [<c04bccfe>] kjournald+0x0/0x1d0
 [<c0430d63>] kthread+0x38/0x5d
 [<c0430d2b>] kthread+0x0/0x5d
 [<c0404a0f>] kernel_thread_helper+0x7/0x10
 =======================
Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 40490254040892 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197846065352886518 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f7157cc4>, tick_sched_timer, S:01, tick_nohz_stop_sched_tick, swapper/0
 # expires at 40490384000000 nsecs [in 129959108 nsecs]
 #1: <f7157cc4>, it_real_fn, S:01, do_setitimer, syslogd/2522
 # expires at 40496478002707 nsecs [in 6223961815 nsecs]
 #2: <f7157cc4>, hrtimer_wakeup, S:01, do_nanosleep, atd/3039
 # expires at 40532442653957 nsecs [in 42188613065 nsecs]
  .expires_next   : 40490428000000 nsecs
  .hres_active    : 1
  .nr_events      : 83410
  .nohz_mode      : 2
  .idle_tick      : 40489800000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 10047451
  .idle_calls     : 174800
  .idle_sleeps    : 109338
  .idle_entrytime : 40490492012833 nsecs
  .idle_sleeptime : 40331022857511 nsecs
  .last_jiffies   : 10047628
  .next_jiffies   : 10048000
  .idle_expires   : 40489996000000 nsecs
jiffies: 10047633

cpu: 1
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197846065352886518 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f7157cc4>, hrtimer_wakeup, S:01, do_nanosleep, crond/2946
 # expires at 40495766729200 nsecs [in 5512688308 nsecs]
 #1: <f7157cc4>, hrtimer_wakeup, S:01, do_nanosleep, smartd/3480
 # expires at 41441988869277 nsecs [in 951734828385 nsecs]
  .expires_next   : 40489997000000 nsecs
  .hres_active    : 1
  .nr_events      : 49576
  .nohz_mode      : 2
  .idle_tick      : 40476865000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 10044217
  .idle_calls     : 127015
  .idle_sleeps    : 81254
  .idle_entrytime : 40489996578090 nsecs
  .idle_sleeptime : 40331714407873 nsecs
  .last_jiffies   : 10047500
  .next_jiffies   : 10047967
  .idle_expires   : 40491864000000 nsecs
jiffies: 10047688


Tick Device: mode:     1
Clock Event Device: hpet
 max_delta_ns:   2147483647
 min_delta_ns:   3352
 mult:           61496110
 shift:          32
 mode:           3
 next_event:     40490812000000 nsecs
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode
 event_handler:  tick_handle_oneshot_broadcast
tick_broadcast_mask: 00000003
tick_broadcast_oneshot_mask: 00000001


Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805378776
 min_delta_ns:   1440
 mult:           44735215
 shift:          32
 mode:           1
 next_event:     40490904000000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805378776
 min_delta_ns:   1440
 mult:           44735215
 shift:          32
 mode:           3
 next_event:     9223372036854775807 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

BUG: soft lockup - CPU#1 stuck for 12s! [swapper:0]

Pid: 0, comm: swapper Not tainted (2.6.24-rc5 #24)
EIP: 0060:[<c0603b70>] EFLAGS: 00000292 CPU: 1
EIP is at _spin_unlock_irqrestore+0x5/0x6
EAX: f7bdd24c EBX: f7110000 ECX: f70cc000 EDX: 00000292
ESI: f70cc07c EDI: 00000050 EBP: 00000064 ESP: f7829ee8
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b7d18eb4 CR3: 37352000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<f8bd96ca>] ata_interrupt+0x1a8/0x1ba [libata]
 [<c044aa0a>] handle_IRQ_event+0x1a/0x3f
 [<c044bc42>] handle_fasteoi_irq+0x71/0xa4
 [<c0405e8a>] do_IRQ+0x79/0x93
 [<c04047cf>] common_interrupt+0x23/0x28
 [<c041007b>] acpi_map_lsapic+0x2d/0xda
 [<c0533a75>] acpi_processor_idle+0x293/0x43e
 [<c05337e2>] acpi_processor_idle+0x0/0x43e
 [<c05337e2>] acpi_processor_idle+0x0/0x43e
 [<c0402575>] cpu_idle+0x97/0xb8
 =======================
Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 40700144217096 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197846065352886518 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f7829d94>, tick_sched_timer, S:01, tick_nohz_stop_sched_tick, swapper/0
 # expires at 40700264000000 nsecs [in 119782904 nsecs]
 #1: <f7829d94>, it_real_fn, S:01, do_setitimer, syslogd/2522
 # expires at 40706478360651 nsecs [in 6334143555 nsecs]
 #2: <f7829d94>, hrtimer_wakeup, S:01, do_nanosleep, atd/3039
 # expires at 40832442740683 nsecs [in 132298523587 nsecs]
  .expires_next   : 40700308000000 nsecs
  .hres_active    : 1
  .nr_events      : 83948
  .nohz_mode      : 2
  .idle_tick      : 40699800000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 10099951
  .idle_calls     : 175667
  .idle_sleeps    : 109741
  .idle_entrytime : 40700372012887 nsecs
  .idle_sleeptime : 40539661547333 nsecs
  .last_jiffies   : 10100098
  .next_jiffies   : 10100500
  .idle_expires   : 40699996000000 nsecs
jiffies: 10100103

cpu: 1
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1197846065352886518 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f7829d94>, hrtimer_wakeup, S:01, do_nanosleep, crond/2946
 # expires at 40735767233236 nsecs [in 35623016140 nsecs]
 #1: <f7829d94>, hrtimer_wakeup, S:01, do_nanosleep, smartd/3480
 # expires at 41441988869277 nsecs [in 741844652181 nsecs]
  .expires_next   : 40699997000000 nsecs
  .hres_active    : 1
  .nr_events      : 49671
  .nohz_mode      : 2
  .idle_tick      : 40686865000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 10096717
  .idle_calls     : 127753
  .idle_sleeps    : 81895
  .idle_entrytime : 40699996620694 nsecs
  .idle_sleeptime : 40540536046589 nsecs
  .last_jiffies   : 10100000
  .next_jiffies   : 10100467
  .idle_expires   : 40701864000000 nsecs
jiffies: 10100158


Tick Device: mode:     1
Clock Event Device: hpet
 max_delta_ns:   2147483647
 min_delta_ns:   3352
 mult:           61496110
 shift:          32
 mode:           3
 next_event:     40700692000000 nsecs
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode
 event_handler:  tick_handle_oneshot_broadcast
tick_broadcast_mask: 00000003
tick_broadcast_oneshot_mask: 00000003


Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805378776
 min_delta_ns:   1440
 mult:           44735215
 shift:          32
 mode:           1
 next_event:     40700784000000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   805378776
 min_delta_ns:   1440
 mult:           44735215
 shift:          32
 mode:           1
 next_event:     9223372036854775807 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

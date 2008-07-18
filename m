Return-Path: <linux-kernel-owner+w=401wt.eu-S1755379AbYGRKFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbYGRKFb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 06:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbYGRKFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 06:05:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:37685 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbYGRKFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 06:05:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=EYDyE0+jULskG84uied1YggmYgxtcHxxHV3M96sGbcjBRb1MV8vx2PhGBnoyKZYhA/
         JOEizVNKxA08U9t8YwJJJaZ0XyEFU954vaj/B7vh8SGvGf73t5smY/1mTFwgT5RASWF5
         1J4jJig4ny/tQXptc4inDtwOyVJPYro/3hgFY=
Message-ID: <4880789E.2010808@gmail.com>
Date: Fri, 18 Jul 2008 11:03:58 +0000
From: Richard <tuxbox.guru@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080614)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Thomas Renninger <trenn@suse.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "andreas.herrmann3" <andreas.herrmann3@amd.com>, eumaster@gmail.com,
       uli.geins@geins-web.de
Subject: Re: [PATCH] Re: AMD Mobile Semprons (3500+, 3600+,...) break with
 nohz and highres enabled
References: <1213638474.1684.21.camel@queen.suse.de> <200807161827.16898.trenn@suse.de> <alpine.LFD.1.10.0807162100380.4316@apollo.tec.linutronix.de> <200807162156.00983.trenn@suse.de> <487EECDF.1040401@gmail.com> <alpine.LFD.1.10.0807171211310.4316@apollo.tec.linutronix.de> <487F33F2.2060202@gmail.com> <alpine.LFD.1.10.0807171306110.4316@apollo.tec.linutronix.de> <487F39AC.3060805@gmail.com> <alpine.LFD.1.10.0807171400090.4316@apollo.tec.linutronix.de> <487F85C6.9@gmail.com> <alpine.LFD.1.10.0807171856010.4316@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0807171856010.4316@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Thu, 17 Jul 2008, Richard wrote:
>   
>> Here you go.. a 2.6.26-tip dmesg  (the top seems to be missing for some
>> reason!) .. just shout if you need the bits on the top.
>>     
>
> Those are the interesting ones :)
>
> Questions: 
>
> Are CONFIG_HIGHRES_TIMERS and CONFIG_NO_HZ enabled ?
> Is it still necessary to add any command line option ?
> Is the system stable ?
>
> Also please provide the output of
>
> # cat /sys/devices/system/clocksource/clocksource0/current_clocksource
>
> and
>
> # cat /proc/timer_list
>
> Thanks,
>
> 	tglx
>
>   

Hi Thomas,

Sorry for the Delay... but I am having a horrible time getting 
netconsole to work , and syslog doesnt have the initial bootup messages 
in it for some arb reason... When I get netconsole working, I'll be 
posting the logs.

Are CONFIG_HIGHRES_TIMERS and CONFIG_NO_HZ enabled ?

Yes, they are both set to Y in .config

A new thing I have seen is that reboot doesnt work.... issue the command 
reboot and it shuts down linux, blanks the screen, but doesnt actually 
reset the machine... it stays in that state until you power off (holding 
the PWR button)  Below is some of the info you requested, but I do 
realise logs are needed, and am on that case right now.. (just needed to 
let the power button recoder from its morning of abuse)

Richard



-======================= TEST 1 ==========================
1) NO COMMAND PARAMETERS
Booted OK, but hun after  a few minutes..
Current Clocksource : acpi_pm

Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 452837390745 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1216374295000000000 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <ffff88007298fde8>, tick_sched_timer, S:01
 # expires at 452838000000 nsecs [in 609255 nsecs]
 #1: <ffff88007298fde8>, hrtimer_wakeup, S:01
 # expires at 486030389909 nsecs [in 33192999164 nsecs]
  .expires_next   : 452838000000 nsecs
  .hres_active    : 1
  .nr_events      : 321945
  .nohz_mode      : 2
  .idle_tick      : 452705000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 4295120000
  .idle_calls     : 11496
  .idle_sleeps    : 9725
  .idle_entrytime : 452760000161 nsecs
  .idle_waketime  : 452784682635 nsecs
  .idle_exittime  : 452784980997 nsecs
  .idle_sleeptime : 139411764446 nsecs
  .last_jiffies   : 4295120055
  .next_jiffies   : 4295120250
  .idle_expires   : 452954000000 nsecs
jiffies: 4295120134


Tick Device: mode:     1
Clock Event Device: pit
 max_delta_ns:   27461866
 min_delta_ns:   12571
 mult:           5124677
 shift:          32
 mode:           3
 next_event:     9223372036854775807 nsecs
 set_next_event: pit_next_event
 set_mode:       init_pit_timer
 event_handler:  tick_handle_oneshot_broadcast
tick_broadcast_mask: 00000001
tick_broadcast_oneshot_mask: 00000000


Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   672799576
 min_delta_ns:   1203
 mult:           53550558
 shift:          32
 mode:           3
 next_event:     452839000000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt
-------------------- End of Timer list ----------







================================== TEST 2 ======================
2) NOHZ_OFF Parameter
Current Clocksource : acpi_pm

Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 277267789698 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1216375039000000000 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <ffff88007213bde8>, tick_sched_timer, S:01
 # expires at 277269000000 nsecs [in 1210302 nsecs]
 #1: <ffff88007213bde8>, hrtimer_wakeup, S:01
 # expires at 282567959776 nsecs [in 5300170078 nsecs]
  .expires_next   : 277269000000 nsecs
  .hres_active    : 1
  .nr_events      : 282282
  .nohz_mode      : 0
  .idle_tick      : 0 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 0
  .idle_calls     : 0
  .idle_sleeps    : 0
  .idle_entrytime : 277214142641 nsecs
  .idle_waketime  : 0 nsecs
  .idle_exittime  : 0 nsecs
  .idle_sleeptime : 67420060577 nsecs
  .last_jiffies   : 0
  .next_jiffies   : 0
  .idle_expires   : 0 nsecs
jiffies: 4294944564


Tick Device: mode:     1
Clock Event Device: pit
 max_delta_ns:   27461866
 min_delta_ns:   12571
 mult:           5124677
 shift:          32
 mode:           3
 next_event:     9223372036854775807 nsecs
 set_next_event: pit_next_event
 set_mode:       init_pit_timer
 event_handler:  tick_handle_oneshot_broadcast
tick_broadcast_mask: 00000001
tick_broadcast_oneshot_mask: 00000000


Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   672803521
 min_delta_ns:   1203
 mult:           53550244
 shift:          32
 mode:           3
 next_event:     277269000000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt



================================ TEST 3 ===================================0

3) NOAPICTIMER
Current Clocksource : acpi_pm

Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 440206030717 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 999848 nsecs
  .get_time:   ktime_get_real
  .offset:     0 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 999848 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <ffff880072d97de8>, hrtimer_wakeup, S:01
 # expires at 467194846891 nsecs [in 26988816174 nsecs]
  .expires_next   : 9223372036854775807 nsecs
  .hres_active    : 0
  .nr_events      : 0
  .nohz_mode      : 0
  .idle_tick      : 0 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 0
  .idle_calls     : 0
  .idle_sleeps    : 0
  .idle_entrytime : 440149158389 nsecs
  .idle_waketime  : 0 nsecs
  .idle_exittime  : 0 nsecs
  .idle_sleeptime : 118766989831 nsecs
  .last_jiffies   : 0
  .next_jiffies   : 0
  .idle_expires   : 0 nsecs
jiffies: 4295107551


Tick Device: mode:     0
Clock Event Device: pit
 max_delta_ns:   27461866
 min_delta_ns:   12571
 mult:           5124677
 shift:          32
 mode:           2
 next_event:     0 nsecs
 set_next_event: pit_next_event
 set_mode:       init_pit_timer
 event_handler:  tick_handle_periodic_broadcast
tick_broadcast_mask: 00000001
tick_broadcast_oneshot_mask: 00000000


Tick Device: mode:     0
Clock Event Device: lapic
 max_delta_ns:   0
 min_delta_ns:   0
 mult:           1
 shift:          32
 mode:           1
 next_event:     0 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  tick_handle_periodic







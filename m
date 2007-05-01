Return-Path: <linux-kernel-owner+w=401wt.eu-S1031700AbXEANdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031700AbXEANdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 09:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031701AbXEANdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 09:33:21 -0400
Received: from rtr.ca ([64.26.128.89]:3276 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031700AbXEANdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 09:33:20 -0400
Message-ID: <4637419D.8010303@rtr.ca>
Date: Tue, 01 May 2007 09:33:17 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: tglx@linutronix.de
Cc: Daniel Walker <dwalker@mvista.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [BUG] 2.6.21: Kernel won't boot with either/both	of	CONFIG_NO_HZ,
 CONFIG_HIGH_RES_TIMERS
References: <46364EBC.5050804@rtr.ca> <46364F5A.2030208@rtr.ca>	 <463653A3.5040606@rtr.ca>  <46367D7E.6060502@rtr.ca>	 <1177976798.12796.286.camel@imap.mvista.com>  <463683A6.4010505@rtr.ca> <1178026458.5791.305.camel@localhost.localdomain>
In-Reply-To: <1178026458.5791.305.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> Mark,
> 
> On Mon, 2007-04-30 at 20:02 -0400, Mark Lord wrote:
>> When it does boot with the modified .config file,
>> the log looks like the one attached to this email.
> 
> Can you please send me the output of /proc/timer_list ?

Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 3232363876949 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1178023146733550511 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f59f9f08>, tick_sched_timer, S:01
 # expires at 3232378000000 nsecs [in 14123051 nsecs]
 #1: <f59f9f08>, hrtimer_wakeup, S:01
 # expires at 3232578819129 nsecs [in 214942180 nsecs]
 #2: <f59f9f08>, hrtimer_wakeup, S:01
 # expires at 3232837692081 nsecs [in 473815132 nsecs]
 #3: <f59f9f08>, hrtimer_wakeup, S:01
 # expires at 3232838775084 nsecs [in 474898135 nsecs]
 #4: <f59f9f08>, it_real_fn, S:01
 # expires at 3233259312183 nsecs [in 895435234 nsecs]
 #5: <f59f9f08>, it_real_fn, S:01
 # expires at 3239124320054 nsecs [in 6760443105 nsecs]
 #6: <f59f9f08>, it_real_fn, S:01
 # expires at 3258112325550 nsecs [in 25748448601 nsecs]
  .expires_next   : 3232378000000 nsecs
  .hres_active    : 1
  .nr_events      : 599408
  .nohz_mode      : 2
  .idle_tick      : 3232362000000 nsecs
  .tick_stopped   : 1
  .idle_jiffies   : 2932361
  .idle_calls     : 1273043
  .idle_sleeps    : 992602
  .idle_entrytime : 3232361030233 nsecs
  .idle_sleeptime : 2944519354264 nsecs
  .last_jiffies   : 2932361
  .next_jiffies   : 2932378
  .idle_expires   : 3232378000000 nsecs
jiffies: 2932363

cpu: 1
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1178023146733550511 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f59f9f08>, tick_sched_timer, S:01
 # expires at 3232364000000 nsecs [in 123051 nsecs]
 #1: <f59f9f08>, hrtimer_wakeup, S:01
 # expires at 3233992031032 nsecs [in 1628154083 nsecs]
  .expires_next   : 3232364000000 nsecs
  .hres_active    : 1
  .nr_events      : 291166
  .nohz_mode      : 2
  .idle_tick      : 3232355000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 2932354
  .idle_calls     : 619531
  .idle_sleeps    : 478589
  .idle_entrytime : 3232354988977 nsecs
  .idle_sleeptime : 3049656284766 nsecs
  .last_jiffies   : 2932354
  .next_jiffies   : 2932358
  .idle_expires   : 3232358000000 nsecs
jiffies: 2932363


Tick Device: mode:     1
Clock Event Device: hpet
 max_delta_ns:   2147483647
 min_delta_ns:   3352
 mult:           61496110
 shift:          32
 mode:           3
 next_event:     3232378000000 nsecs
 set_next_event: hpet_next_event
 set_mode:       hpet_set_mode
 event_handler:  tick_handle_oneshot_broadcast
tick_broadcast_mask: 00000003
tick_broadcast_oneshot_mask: 00000001


Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   807210821
 min_delta_ns:   1443
 mult:           44633684
 shift:          32
 mode:           1
 next_event:     3232378000000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   807210821
 min_delta_ns:   1443
 mult:           44633684
 shift:          32
 mode:           3
 next_event:     3232365000000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt


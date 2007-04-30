Return-Path: <linux-kernel-owner+w=401wt.eu-S1946430AbXD3QkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946430AbXD3QkY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946431AbXD3QkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 12:40:24 -0400
Received: from phoenix.bawue.net ([193.7.176.60]:52390 "EHLO mail.bawue.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946365AbXD3Qjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 12:39:53 -0400
Date: Mon, 30 Apr 2007 18:39:44 +0200
From: Joerg Sommrey <jo@sommrey.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21: pmtmr losing time
Message-ID: <20070430163944.GA29206@sommrey.de>
Mail-Followup-To: Joerg Sommrey <jo@sommrey.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <20070430125200.GA5379@sommrey.de> <1177950216.5791.241.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177950216.5791.241.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 06:23:36PM +0200, Thomas Gleixner wrote:
> On Mon, 2007-04-30 at 14:52 +0200, Joerg Sommrey wrote:
> > Hi all,
> > 
> > after switching to 2.6.21 the system clock sporadically loses time on my
> > box (i386, Athlon MP).
> > It's always around 4.68 seconds and happened 7 times in the last 12
> > hours.  A simple calculation (2 ^ ACPI_PM_MASK / PMTMR_TICKS_PER_SEC =
> > 2 ^ 24 / 3579545 = 4.686968875) shows: There is almost exactly one
> > pmtmr-cycle missing.  Could this be caused by a pmtmr-wrap when the
> > system is in a sleep state? 
> 
> Hmm, looks like. That's strange we don't sleep 4.68 seconds. Can you
> provide me the output of /proc/timer_list please ?
> 
> 	tglx
> 
> 

Here it is.  Maybe this problem is related to the usage of the
"experimental" amd76x_pm module?

-jo

Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 249154808025750 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1177701795305563440 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <e4a79f00>, tick_sched_timer, S:01
 # expires at 249154808417850 nsecs [in 392100 nsecs]
 #1: <e4a79f00>, it_real_fn, S:01
 # expires at 249154832599897 nsecs [in 24574147 nsecs]
 #2: <e4a79f00>, hrtimer_wakeup, S:01
 # expires at 249154937316640 nsecs [in 129290890 nsecs]
 #3: <e4a79f00>, it_real_fn, S:01
 # expires at 249154940604253 nsecs [in 132578503 nsecs]
 #4: <e4a79f00>, it_real_fn, S:01
 # expires at 249156991584989 nsecs [in 2183559239 nsecs]
 #5: <e4a79f00>, hrtimer_wakeup, S:01
 # expires at 249163930201148 nsecs [in 9122175398 nsecs]
 #6: <e4a79f00>, hrtimer_wakeup, S:01
 # expires at 249163930619465 nsecs [in 9122593715 nsecs]
 #7: <e4a79f00>, it_real_fn, S:01
 # expires at 249164018722673 nsecs [in 9210696923 nsecs]
 #8: <e4a79f00>, it_real_fn, S:01
 # expires at 249164018756764 nsecs [in 9210731014 nsecs]
 #9: <e4a79f00>, hrtimer_wakeup, S:01
 # expires at 249166140491719 nsecs [in 11332465969 nsecs]
 #10: <e4a79f00>, it_real_fn, S:01
 # expires at 249168890475020 nsecs [in 14082449270 nsecs]
 #11: <e4a79f00>, it_real_fn, S:01
 # expires at 249216937518155 nsecs [in 62129492405 nsecs]
 #12: <e4a79f00>, it_real_fn, S:01
 # expires at 249694958542841 nsecs [in 540150517091 nsecs]
 #13: <e4a79f00>, hrtimer_wakeup, S:01
 # expires at 252071939585424 nsecs [in 2917131559674 nsecs]
 #14: <e4a79f00>, it_real_fn, S:01
 # expires at 277954353421786 nsecs [in 28799545396036 nsecs]
  .expires_next   : 249154808417850 nsecs
  .hres_active    : 1
  .nr_events      : 12571303
  .nohz_mode      : 2
  .idle_tick      : 249154808417850 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 74656449
  .idle_calls     : 31252991
  .idle_sleeps    : 18916982
  .idle_entrytime : 249154806452801 nsecs
  .idle_sleeptime : 202805663229475 nsecs
  .last_jiffies   : 74656449
  .next_jiffies   : 74656452
  .idle_expires   : 249154815084516 nsecs
jiffies: 74656449

cpu: 1
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1177701795305563440 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <e4a79f00>, tick_sched_timer, S:01
 # expires at 249154808417850 nsecs [in 392100 nsecs]
 #1: <e4a79f00>, it_real_fn, S:01
 # expires at 249154824005495 nsecs [in 15979745 nsecs]
 #2: <e4a79f00>, hrtimer_wakeup, S:01
 # expires at 249154876721584 nsecs [in 68695834 nsecs]
 #3: <e4a79f00>, hrtimer_wakeup, S:01
 # expires at 249154876724658 nsecs [in 68698908 nsecs]
 #4: <e4a79f00>, it_real_fn, S:01
 # expires at 249156991445550 nsecs [in 2183419800 nsecs]
 #5: <e4a79f00>, hrtimer_wakeup, S:01
 # expires at 249158033258177 nsecs [in 3225232427 nsecs]
 #6: <e4a79f00>, it_real_fn, S:01
 # expires at 249158937910855 nsecs [in 4129885105 nsecs]
 #7: <e4a79f00>, hrtimer_wakeup, S:01
 # expires at 249160645185907 nsecs [in 5837160157 nsecs]
 #8: <e4a79f00>, hrtimer_wakeup, S:01
 # expires at 249288273241617 nsecs [in 133465215867 nsecs]
 #9: <e4a79f00>, it_real_fn, S:01
 # expires at 249688052597900 nsecs [in 533244572150 nsecs]
 #10: <e4a79f00>, hrtimer_wakeup, S:01
 # expires at 250127175002655 nsecs [in 972366976905 nsecs]
 #11: <e4a79f00>, hrtimer_wakeup, S:01
 # expires at 252087970262178 nsecs [in 2933162236428 nsecs]
  .expires_next   : 249154808417850 nsecs
  .hres_active    : 1
  .nr_events      : 13107829
  .nohz_mode      : 2
  .idle_tick      : 249154805084517 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 74656448
  .idle_calls     : 27583722
  .idle_sleeps    : 11208166
  .idle_entrytime : 249154805632934 nsecs
  .idle_sleeptime : 197905845372598 nsecs
  .last_jiffies   : 74656449
  .next_jiffies   : 74656450
  .idle_expires   : 249154935084504 nsecs
jiffies: 74656449


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
tick_broadcast_mask: 00000000
tick_broadcast_oneshot_mask: 00000000


Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   503300116
 min_delta_ns:   1000
 mult:           71585107
 shift:          32
 mode:           3
 next_event:     249154808417850 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   503300116
 min_delta_ns:   1000
 mult:           71585107
 shift:          32
 mode:           3
 next_event:     249154808417850 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

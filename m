Return-Path: <linux-kernel-owner+w=401wt.eu-S966366AbXEHKHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966366AbXEHKHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 06:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966318AbXEHKHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 06:07:35 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:39238 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965805AbXEHKHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 06:07:34 -0400
Date: Tue, 8 May 2007 03:06:57 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Wright <chrisw@sous-sol.org>, LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86-64 highres/dyntick support
Message-ID: <20070508100657.GZ3505@sequoia.sous-sol.org>
References: <1178485128.31213.98.camel@localhost.localdomain> <20070507163110.GP3505@sequoia.sous-sol.org> <1178556361.3042.16.camel@localhost.localdomain> <20070508093957.GS3505@sequoia.sous-sol.org> <1178617864.3042.309.camel@localhost.localdomain> <20070508095130.GY3505@sequoia.sous-sol.org> <1178618304.3042.320.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178618304.3042.320.camel@localhost.localdomain>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner (tglx@linutronix.de) wrote:
> Hmm, that's even more strange. Can you please provide the output
> of /proc/timer_list ?

It's quite normal looking, and a printk in clockevents_set_mode looks normal too.

[chrisw@localhost ~]$ cat /proc/timer_list
Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 313565930359 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 4000250 nsecs
  .get_time:   ktime_get_real
active timers:
 clock 1:
  .index:      1
  .resolution: 4000250 nsecs
  .get_time:   ktime_get
active timers:
 #0: <ffff810150223e38>, hrtimer_wakeup, S:01
 # expires at 313700587872 nsecs [in 134657513 nsecs]
 #1: <ffff810150223e38>, it_real_fn, S:01
 # expires at 332024684987 nsecs [in 18458754628 nsecs]
 #2: <ffff810150223e38>, hrtimer_wakeup, S:01
 # expires at 337032779067 nsecs [in 23466848708 nsecs]
 #3: <ffff810150223e38>, hrtimer_wakeup, S:01
 # expires at 1851212334864 nsecs [in 1537646404505 nsecs]
 #4: <ffff810150223e38>, it_real_fn, S:01
 # expires at 3635317355388 nsecs [in 3321751425029 nsecs]
 #5: <ffff810150223e38>, it_real_fn, S:01
 # expires at 3635630194993 nsecs [in 3322064264634 nsecs]

cpu: 1
 clock 0:
  .index:      0
  .resolution: 4000250 nsecs
  .get_time:   ktime_get_real
active timers:
 clock 1:
  .index:      1
  .resolution: 4000250 nsecs
  .get_time:   ktime_get
active timers:

cpu: 2
 clock 0:
  .index:      0
  .resolution: 4000250 nsecs
  .get_time:   ktime_get_real
active timers:
 clock 1:
  .index:      1
  .resolution: 4000250 nsecs
  .get_time:   ktime_get
active timers:

cpu: 3
 clock 0:
  .index:      0
  .resolution: 4000250 nsecs
  .get_time:   ktime_get_real
active timers:
 clock 1:
  .index:      1
  .resolution: 4000250 nsecs
  .get_time:   ktime_get
active timers:
 #0: <ffff810150223e38>, it_real_fn, S:01
 # expires at 313558625026 nsecs [in -7305333 nsecs]
 #1: <ffff810150223e38>, hrtimer_wakeup, S:01
 # expires at 369334850252 nsecs [in 55768919893 nsecs]
 #2: <ffff810150223e38>, it_real_fn, S:01
 # expires at 3936979059363 nsecs [in 3623413129004 nsecs]


Tick Device: mode:     0
Clock Event Device: hpet
 max_delta_ns:   85899346200
 min_delta_ns:   1920
 mult:           107374182
 shift:          32
 mode:           2
 next_event:     9223372036854775807 nsecs
 set_next_event: hpet_next_event
 set_mode:       hpet_set_mode
 event_handler:  tick_handle_periodic_broadcast
tick_broadcast_mask: 00000001


Tick Device: mode:     0
Clock Event Device: lapic
 max_delta_ns:   671088687
 min_delta_ns:   1200
 mult:           53687081
 shift:          32
 mode:           1
 next_event:     0 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  tick_handle_periodic

Tick Device: mode:     0
Clock Event Device: lapic
 max_delta_ns:   671088687
 min_delta_ns:   1200
 mult:           53687081
 shift:          32
 mode:           2
 next_event:     0 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  tick_handle_periodic

Tick Device: mode:     0
Clock Event Device: lapic
 max_delta_ns:   671088687
 min_delta_ns:   1200
 mult:           53687081
 shift:          32
 mode:           2
 next_event:     0 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  tick_handle_periodic

Tick Device: mode:     0
Clock Event Device: lapic
 max_delta_ns:   671088687
 min_delta_ns:   1200
 mult:           53687081
 shift:          32
 mode:           2
 next_event:     0 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  tick_handle_periodic


[chrisw@localhost ~]$ grep -e 0: -e LOC: /proc/interrupts 
  0:         72          2         58      36008   IO-APIC-edge      timer
LOC:      36655      36772      36725      36683 
[chrisw@localhost ~]$ grep -e 0: -e LOC: /proc/interrupts 
  0:         72          2         58      36165   IO-APIC-edge      timer
LOC:      36812      36929      36882      36840 
[chrisw@localhost ~]$ grep -e 0: -e LOC: /proc/interrupts 
  0:         72          2         58      36297   IO-APIC-edge      timer
LOC:      36944      37061      37014      36972 
[chrisw@localhost ~]$ grep -e 0: -e LOC: /proc/interrupts 
  0:         72          2         58      36424   IO-APIC-edge      timer
LOC:      37071      37188      37141      37099 


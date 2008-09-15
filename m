Return-Path: <linux-kernel-owner+w=401wt.eu-S1756641AbYIOV1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbYIOV1d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 17:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753404AbYIOV1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 17:27:25 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52732 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbYIOV1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 17:27:24 -0400
Date: Mon, 15 Sep 2008 21:26:02 +0200
From: Pavel Machek <pavel@suse.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.27-rc6: nohz + s2ram = need to press keys to get progress
Message-ID: <20080915192600.GA1627@elf.ucw.cz>
References: <20080912083113.GA1625@elf.ucw.cz> <alpine.LFD.1.10.0809140455470.5283@apollo.tec.linutronix.de> <20080914100913.GB7909@elf.ucw.cz> <20080914101406.GA1625@elf.ucw.cz> <20080914173536.GA1687@elf.ucw.cz> <alpine.LFD.1.10.0809141049570.5283@apollo.tec.linutronix.de> <20080914181228.GA18934@elf.ucw.cz> <alpine.LFD.1.10.0809141214110.5283@apollo.tec.linutronix.de> <20080915091925.GB1787@elf.ucw.cz> <alpine.LFD.1.10.0809150704420.5283@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809150704420.5283@apollo.tec.linutronix.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon 2008-09-15 07:08:01, Thomas Gleixner wrote:
> On Mon, 15 Sep 2008, Pavel Machek wrote:
> > > 
> > > Hmm. Can you please provide the output of /proc/timer_list when the
> > > system is in that "sleepy" state.
> 
> Any chance to get that output ?

Yep ;-).

> > -rc5 seems to work ok... is there some patch I should try to revert
> > first?
> 
> The relevant 9 changes are from:
> 
> 7c1e76897492d92b6a1c2d6892494d39ded9680c

I did 

cg-seek 7c1e76897492d92b6a1c2d6892494d39ded9680c

...and resulting kernel seems to work okay.

> to
> 
> 72d43d9bc9210d24d09202eaf219eac09e17b339

cg-seek here, and problem is back. Good. I can get the
/proc/timer_list ;-)... attached.
									Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=delme

Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 78679262236 nsecs

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
 #0: <f5d67eb8>, it_real_fn, S:01, do_setitimer, rpc.nfsd/1488
 # expires at 79800076403 nsecs [in 1120814167 nsecs]
 #1: <f5d67eb8>, it_real_fn, S:01, do_setitimer, rpc.mountd/1486
 # expires at 79800101756 nsecs [in 1120839520 nsecs]
 #2: <f5d67eb8>, it_real_fn, S:01, do_setitimer, syslogd/1446
 # expires at 106836398898 nsecs [in 28157136662 nsecs]
 #3: <f5d67eb8>, it_real_fn, S:01, do_setitimer, qmgr/1603
 # expires at 389997707387 nsecs [in 311318445151 nsecs]
 #4: <f5d67eb8>, it_real_fn, S:01, do_setitimer, pickup/1602
 # expires at 411025536414 nsecs [in 332346274178 nsecs]
 #5: <f5d67eb8>, it_real_fn, S:01, do_setitimer, master/1601
 # expires at 411025663664 nsecs [in 332346401428 nsecs]
 #6: <f5d67eb8>, it_real_fn, S:01, do_setitimer, mutt/1627
 # expires at 949848265489 nsecs [in 871169003253 nsecs]
 #7: <f5d67eb8>, it_real_fn, S:01, do_setitimer, smtp/1606
 # expires at 6056997804606 nsecs [in 5978318542370 nsecs]
 #8: <f5d67eb8>, it_real_fn, S:01, do_setitimer, bounce/1638
 # expires at 6056997871724 nsecs [in 5978318609488 nsecs]
  .nohz_mode      : 1
  .idle_tick      : 78676896750 nsecs
  .tick_stopped   : 1
  .idle_jiffies   : 4294911965
  .idle_calls     : 10530
  .idle_sleeps    : 4823
  .idle_entrytime : 78676079360 nsecs
  .idle_waketime  : 78676019925 nsecs
  .idle_exittime  : 78676052541 nsecs
  .idle_sleeptime : 72788008686 nsecs
  .last_jiffies   : 4294911965
  .next_jiffies   : 4294911988
  .idle_expires   : 78768000000 nsecs
jiffies: 4294911965

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
  .nohz_mode      : 1
  .idle_tick      : 78543351750 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 4294911931
  .idle_calls     : 7365
  .idle_sleeps    : 1350
  .idle_entrytime : 78540354359 nsecs
  .idle_waketime  : 76836307895 nsecs
  .idle_exittime  : 78676087671 nsecs
  .idle_sleeptime : 77463218593 nsecs
  .last_jiffies   : 4294911931
  .next_jiffies   : 2431226
  .idle_expires   : 10024904000000 nsecs
jiffies: 4294911965


Tick Device: mode:     1
Clock Event Device: hpet
 max_delta_ns:   2147483647
 min_delta_ns:   5000
 mult:           61496114
 shift:          32
 mode:           3
 next_event:     26228000000 nsecs
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode
 event_handler:  tick_handle_oneshot_broadcast
tick_broadcast_mask: 00000003
tick_broadcast_oneshot_mask: 00000000


Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   807384766
 min_delta_ns:   1443
 mult:           44624068
 shift:          32
 mode:           3
 next_event:     78680897000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  tick_nohz_handler

Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   807384766
 min_delta_ns:   1443
 mult:           44624068
 shift:          32
 mode:           3
 next_event:     78683360500 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  tick_nohz_handler


--CE+1k2dSO48ffgeK--

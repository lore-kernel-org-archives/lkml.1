Return-Path: <linux-kernel-owner+w=401wt.eu-S1759810AbXEOIsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759810AbXEOIsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 04:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757902AbXEOIry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 04:47:54 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:56956 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757649AbXEOIry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 04:47:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QA2qsNeSk1duA7KrK0k33Q7pHoEghzkOn1T2iy+1pnJPzfcx/eXsWVHPhHOEOmbe5oJH82HQiQLtXmo5ugwUWXLnCoIQmnFRf6JhGgi4hWCv/rbBDPOVaUe6iZFuCFHDDUJRnSVMi2PgYccewS4K1zXWB5AV9YesjHLi1/GCXd8=
Message-ID: <38b2ab8a0705150147s4ce72914qfa30d543ed8a4839@mail.gmail.com>
Date: Tue, 15 May 2007 10:47:52 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: tglx@linutronix.de
Subject: Re: clockevent questions
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1179001391.22481.216.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0705120754l281f54eevd1e91e2f01fff6f2@mail.gmail.com>
	 <1178982892.22481.183.camel@localhost.localdomain>
	 <38b2ab8a0705121313k37be467cy55402b490101ac9c@mail.gmail.com>
	 <1179001391.22481.216.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

On 5/12/07, Thomas Gleixner <tglx@linutronix.de> wrote:
> Well, it ends up in hrtimer_interrupt() and the code there finds out,
> that the next timer is not due right now, so it simply requests the same
> (absolute) time event again, which is processed by the clock events code
> and eventually limited to the max delta of the device again.
>

My timer is finally using the clockevent subsystem. Below is the
output of '/proc/timer_list':

cat /proc/timer_list
Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 64696544360531 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1179151153000000000 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <c03fde10>, tick_sched_timer, S:01
 # expires at 64696546875000 nsecs [in 2514469 nsecs]
  .expires_next   : 64696546875000 nsecs
  .hres_active    : 1
  .nr_events      : 16562163
  .nohz_mode      : 0
  .idle_tick      : 0 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 0
  .idle_calls     : 0
  .idle_sleeps    : 0
  .idle_entrytime : 0 nsecs
  .idle_sleeptime : 0 nsecs
  .last_jiffies   : 0
  .next_jiffies   : 0
  .idle_expires   : 0 nsecs
jiffies: 16485515


Tick Device: mode:     1
Clock Event Device: hrt
 max_delta_ns:   2147483647
 min_delta_ns:   1000
 mult:           206158430
 shift:          32
 mode:           3
 next_event:     64696546875000 nsecs
 set_next_event: hrt_next_event
 set_mode:       hrt_timer_setup
 event_handler:  hrtimer_interrupt

My question is about the clock resolution field which is equal to 1ns.
How is this possible since my timer's frequency is only 100Mhz ?

My 2 cents, it looks like some tabs are missing when printing the list
of hrtimers of each clock...

Thanks
-- 
Francis

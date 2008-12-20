Return-Path: <linux-kernel-owner+w=401wt.eu-S1754376AbYLTUiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376AbYLTUiA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 15:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbYLTUhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 15:37:51 -0500
Received: from www.tglx.de ([62.245.132.106]:47553 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269AbYLTUhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 15:37:51 -0500
Date: Sat, 20 Dec 2008 21:37:32 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Oleg Nesterov <oleg@redhat.com>
cc: Eric Sesterhenn <snakebyte@gmx.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] posix-timers: CLOCK_MONOTONIC_RAW: fix the usage of
 ->it_clock
In-Reply-To: <20081220202425.GA12922@redhat.com>
Message-ID: <alpine.LFD.2.00.0812202134330.3376@localhost.localdomain>
References: <20081219172549.GA25722@alice> <alpine.LFD.2.00.0812192243350.3376@localhost.localdomain> <20081220161457.GA26499@redhat.com> <20081220163033.GB26499@redhat.com> <20081220174817.GA5273@redhat.com> <alpine.LFD.2.00.0812202108180.3376@localhost.localdomain>
 <20081220202425.GA12922@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Dec 2008, Oleg Nesterov wrote:
> On 12/20, Thomas Gleixner wrote:
> >
> > On Sat, 20 Dec 2008, Oleg Nesterov wrote:
> >
> > > -static int common_timer_create(struct k_itimer *new_timer)
> > > +static inline int
> > > +__common_timer_init(struct k_itimer *timer, enum hrtimer_mode mode)
> > >  {
> > > -	hrtimer_init(&new_timer->it.real.timer, new_timer->it_clock, 0);
> > > +	clockid_t clock_id = timer->it_clock ?
> > > +				CLOCK_MONOTONIC : CLOCK_REALTIME;
> > > +	hrtimer_init(&timer->it.real.timer, clock_id, mode);
> > >  	return 0;
> > >  }
> >
> > No, this is wrong. We do not want to create a timer for
> > CLOCK_MONOTONIC_RAW.
> 
> OK, thanks.
> 
> I thought that the intent was to allow the creation.

No. 

1. CLOCK_MONOTONIC_RAW and CLOCK_MONOTONIC are diffferent beasts

2. CLOCK_MONOTONIC_RAW was created to allow user space to read out the
non NTP frequency corrected raw system time. That's mainly for the NTP
folks so they have a better idea what's the hardware's idea of time
is.
 
> Then we should we shoould add clock_monotonic_raw->timer_create()
> which returns -EINVAL ?

That's what I just sent out :) I looked into this offline and had the
fix ready to send out when I noticed yours.

Thanks,

	tglx

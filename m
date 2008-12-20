Return-Path: <linux-kernel-owner+w=401wt.eu-S1754263AbYLTU0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbYLTU0U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 15:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbYLTU0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 15:26:12 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38675 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091AbYLTU0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 15:26:11 -0500
Date: Sat, 20 Dec 2008 21:24:25 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Eric Sesterhenn <snakebyte@gmx.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] posix-timers: CLOCK_MONOTONIC_RAW: fix the usage of
	->it_clock
Message-ID: <20081220202425.GA12922@redhat.com>
References: <20081219172549.GA25722@alice> <alpine.LFD.2.00.0812192243350.3376@localhost.localdomain> <20081220161457.GA26499@redhat.com> <20081220163033.GB26499@redhat.com> <20081220174817.GA5273@redhat.com> <alpine.LFD.2.00.0812202108180.3376@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0812202108180.3376@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20, Thomas Gleixner wrote:
>
> On Sat, 20 Dec 2008, Oleg Nesterov wrote:
>
> > -static int common_timer_create(struct k_itimer *new_timer)
> > +static inline int
> > +__common_timer_init(struct k_itimer *timer, enum hrtimer_mode mode)
> >  {
> > -	hrtimer_init(&new_timer->it.real.timer, new_timer->it_clock, 0);
> > +	clockid_t clock_id = timer->it_clock ?
> > +				CLOCK_MONOTONIC : CLOCK_REALTIME;
> > +	hrtimer_init(&timer->it.real.timer, clock_id, mode);
> >  	return 0;
> >  }
>
> No, this is wrong. We do not want to create a timer for
> CLOCK_MONOTONIC_RAW.

OK, thanks.

I thought that the intent was to allow the creation.

Then we should we shoould add clock_monotonic_raw->timer_create()
which returns -EINVAL ?

Oleg.


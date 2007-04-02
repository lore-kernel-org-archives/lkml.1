Return-Path: <linux-kernel-owner+w=401wt.eu-S965540AbXDBRxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965540AbXDBRxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 13:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965550AbXDBRw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 13:52:59 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:49846 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965540AbXDBRw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 13:52:59 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 2 Apr 2007 10:52:56 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Thomas Gleixner <tglx@linutronix.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 6/13] signal/timer/event fds v9 - timerfd core ...
In-Reply-To: <1175536065.28263.177.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0704021052070.26489@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.16816.1175371772.6> 
 <1175418341.28263.64.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0704010941490.26331@alien.or.mcafeemobile.com> 
 <1175498549.28263.88.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0704021025570.26489@alien.or.mcafeemobile.com>
 <1175536065.28263.177.camel@localhost.localdomain>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Apr 2007, Thomas Gleixner wrote:

> On Mon, 2007-04-02 at 10:30 -0700, Davide Libenzi wrote:
> 
> > > There is no inaccuracy when you rearm the timer on read: hrtimer_forward
> > > takes care, that the period is accurate. It does not start the timer out
> > > of the periodic order, i.e. on a different time frame.
> > > 
> > > Where is the win of keeping the timer running, when nobody cares about
> > > the expiry at all ? It just generates interrupts and events for nothing.
> > 
> > Then you'd lose the ability to know if you lost one or more (yes, you 
> > could figure it out by reading the time and with a few calculations). I 
> > think that the capping (to a sane value) idea solves the DoS issue and at 
> > the same time have the ability to report you missed ticks. What are your 
> > strong points against that solution?
> 
> Err, the read function 
> 
> 	ticks = hrtimer_forward(&ctx->tmr, ktime_get(),
>                                 ctx->tintv);
> 
> does give you the number of (lost) ticks.
> 
> tmr->expires holds the absolute expiry time of the last event.
> hrtimer_forward() adds N intervals to tmr->expires, so that the new
> tmr->expires value is greater than now (ktime_get()). It returns N.
> 
> So the number of lost ticks is N - 1. No time reading and no magic
> math :)

Yack, I missed that part :) Sounds fine then.



- Davide



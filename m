Return-Path: <linux-kernel-owner+w=401wt.eu-S1760162AbXIXPm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760162AbXIXPm6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 11:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759282AbXIXPmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 11:42:51 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:51235 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960AbXIXPmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 11:42:50 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 24 Sep 2007 08:42:47 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Thomas Gleixner <tglx@linutronix.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michael Kerrisk <mtk-manpages@gmx.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 1/3] new timerfd API - new timerfd API
In-Reply-To: <1190622364.4035.182.camel@chaos>
Message-ID: <Pine.LNX.4.64.0709240838250.23830@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.19354.1190587749.1>
 <1190622364.4035.182.camel@chaos>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007, Thomas Gleixner wrote:

> >  struct timerfd_ctx {
> >  	struct hrtimer tmr;
> > +	int clockid;
> >  	ktime_t tintv;
> >  	wait_queue_head_t wqh;
> >  	int expired;
> > +	u64 ticks;
> >  };
> 
> Can you please restructure the struct in a way which does not result in
> padding by the compiler ?
> 
> struct timerfd_ctx {
> 	struct hrtimer tmr;
> 	ktime_t tintv;
> 	wait_queue_head_t wqh;
> 	u64 ticks;
> 	int expired;
> 	int clockid;
> };

Sure.



> > +			ticks += (u64)
> >  				hrtimer_forward(&ctx->tmr,
> >  						hrtimer_cb_get_time(&ctx->tmr),
> 
> You need to use ctx->tmr.base->get_time() here, otherwise you might read
> a stale time value (in case that CONFIG_HIGH_RES_TIMERS is off).

Is the particular position of hrtimer_cb_get_time() in the code that would 
break here? Because function was added by your patch ;)
Did something change later?



> > +err_kfree_ctx:
> > +	kfree(ctx);
> > +	return error;
> 
> You really can avoid the goto here.

Ack.



- Davide



Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbYH1NXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbYH1NXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 09:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbYH1NXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 09:23:30 -0400
Received: from flusers.ccur.com ([12.192.68.2]:53141 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752742AbYH1NX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 09:23:29 -0400
Date: Thu, 28 Aug 2008 09:22:37 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] make poll_idle behave more like the other idle methods
Message-ID: <20080828132237.GA20926@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <20080827143506.GA23166@tsunami.ccur.com> <20080828090036.GC19422@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080828090036.GC19422@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 05:00:36AM -0400, Ingo Molnar wrote:
> 
> * Joe Korty <joe.korty@ccur.com> wrote:
> 
> > Make poll_idle() behave more like the other idle methods.
> >
> > Currently, poll_idle() returns immediately.  The other
> > idle methods all wait indefinately for some condition
> > to come true before returning.  poll_idle should emulate
> > these other methods and also wait for a return condition,
> > in this case, for need_resched() to become 'true'.
> >
> > Without this delay the idle loop spends all of its time
> > in the outer loop that calls poll_idle.  This outer loop,
> > these days, does real work, some of it under rcu locks.
> > That work should only be done when idle is entered and
> > when idle exits, not continuously while idle is spinning.
> 
> i'm wondering, what's the motivation, have you actually seen
> anything bad/undesired happen due to that?

I saw the outer loop running continuously, from the old
trace patch which I had applied.

Nowdays the outer loop runs the NO_HZ stuff, which touches
quite a few memory locations.  Having say two cpus in idle
and there is potential for cache thrashing to suck up a good
part of the local memory bus bandwidth.

And I suspect as time goes on cpu_idle will end up with
more work to do.

Joe

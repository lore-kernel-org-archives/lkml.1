Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751127Ab0CDFS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 00:18:59 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:63550 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab0CDFS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 00:18:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=JPV4WyQ84xo/zi0SWnRLQrV0Wc5iNhsLJ34WMM7wAj+zRx2foX0hKw+CnmnoIdsbn9
         J01/CBJ+/DXQU6Zxh4zyX+62szZ65gkgnWD+AaOB1l/e2IDhaKTvog7JSkq1SpyCG52w
         ugtSOqzaLS04eIrLFMygoddmcaTnvHJXs0fVM=
Date: Thu, 4 Mar 2010 06:18:53 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: rostedt@goodmis.org, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: 2.6.33: ftrace triggers soft lockup
Message-ID: <20100304051852.GA27924@nowhere>
References: <2375c9f91003022204p5bdab1fdj3b3500998575fc28@mail.gmail.com> <20100304014641.GH5194@nowhere> <2375c9f91003031901v19c00c21k4a5d46bbe9ade3f@mail.gmail.com> <1267672706.10871.97.camel@gandalf.stny.rr.com> <2375c9f91003032110n3a7f0e94v1ecf9e2535795b62@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2375c9f91003032110n3a7f0e94v1ecf9e2535795b62@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 01:10:16PM +0800, Américo Wang wrote:
> On Thu, Mar 4, 2010 at 11:18 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Thu, 2010-03-04 at 11:01 +0800, Américo Wang wrote:
> >
> >> >
> >> > So it is stuck in stop machine. I wonder where exactly. I see some do_exit
> >> > at the top but I wonder how much they are reliable.
> >>
> >> Well, I think 'kstop' is just random, sometimes I got 'watchdog' or some other
> >> process.
> >>
> >> >
> >> > Anyway, as Steve said, we really need a full config to reproduce it.
> >> >
> >>
> >> Done in another reply.
> >
> > Thanks!
> >
> > Frederic, I notice that lockdep is on, did anything change that might
> > slow down the code in lockdep, or is the function graph tracer doing
> > more locking?
> >
> > I'm betting that we are hitting a live lock. That is, an interrupt goes
> > off, it is being traced, and the function graph is tracing it, but some
> > locking is happening (although it also tracks disabling of interrupts)
> > and this slows the interrupt handler down enough that when it finishes,
> > another interrupt goes off.
> >
> > Américo,
> >
> > Could you disable LOCKDEP and see if you still encounter this lockup?
> >
> 
> Sure, after disabling LOCKDEP, I can't see the warning, _but_ the system
> is still as unacceptablly slow as when LOCKDEP was enabled.



Looks like a progress. It doesn't appear to be a true lockup but more a
starvation or a livelock.

I'm building your config, hopefully I could reproduce.

Thanks.


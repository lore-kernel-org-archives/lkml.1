Return-Path: <linux-kernel-owner+w=401wt.eu-S1759747AbYDKJBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759747AbYDKJBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 05:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757717AbYDKJBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 05:01:31 -0400
Received: from viefep31-int.chello.at ([62.179.121.49]:53664 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757997AbYDKJBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 05:01:31 -0400
Subject: Re: [PATCH] proc: Add RLIMIT_RTTIME to /proc/<pid>/limits
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, Eugene Teo <eugeneteo@kernel.sg>,
       linux-kernel@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <cfd18e0f0804110156l658107e5x1f2695cacfc3ac75@mail.gmail.com>
References: <20080208145950.GA3910@kernel.sg>
	 <1202483445.6292.1.camel@lappy>
	 <517f3f820802280712o3d756b4fq46461b226515e1f2@mail.gmail.com>
	 <1204212100.12120.9.camel@twins>
	 <cfd18e0f0804110156l658107e5x1f2695cacfc3ac75@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 11 Apr 2008 11:01:25 +0200
Message-Id: <1207904485.7074.28.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-11 at 10:56 +0200, Michael Kerrisk wrote:
> On Thu, Feb 28, 2008 at 5:21 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >
> > On Thu, 2008-02-28 at 16:12 +0100, Michael Kerrisk wrote:
> > > Peter,
> > >
> > > Could you please provide some text describing RLIMIT_RTTIMEfor the
> > > getrlimit.2 man page.
> >
> > The rlimit sets a timeout in [us] for SCHED_RR and SCHED_FIFO tasks.
> > This time is measured between sleeps, so a schedule in RR or a
> > preemption in either is not a sleep - the task needs to be dequeued and
> > enqueued for the timer to reset.
> >
> > Upon reaching the cur limit we start giving SIGXCPU every second, upon
> > reaching the hard limit we give SIGKILL - matching RLIMIT_CPU.
> >
> > Time is measured in tick granularity (for now).
> 
> So I have another question: why is the granularity of this rlimit
> microseconds?  On the one hand, specifying limits down at the
> microsecond level seems (to my naive eye) unlikely to be useful.  (But
> perhaps I have missed a thread where this was explained.)  On the
> other hand, it means that on 32-bit the largest time limit we can set
> is ~4000 seconds, and I wonder if there are scenarios where it might
> be useful to have larger limits than that.
> 
> Why not, for example, have a granularity of milliseconds?

The us scale seemed the best fit in that it allows sub-ms granularity
while still allowing for quite long periods too. I'd preferred ns scale
as that is what we use throughout the scheduler where possible - but
that seemed too restrictive at the high end.

No real hard arguments either way.


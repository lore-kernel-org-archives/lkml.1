Return-Path: <linux-kernel-owner+w=401wt.eu-S1758402AbYHZLKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758402AbYHZLKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 07:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756609AbYHZLKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 07:10:30 -0400
Received: from www.tglx.de ([62.245.132.106]:39908 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758451AbYHZLK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 07:10:29 -0400
Date: Tue, 26 Aug 2008 13:09:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
In-Reply-To: <200808261954.47987.nickpiggin@yahoo.com.au>
Message-ID: <alpine.LFD.1.10.0808261219050.3243@apollo.tec.linutronix.de>
References: <20080819103301.787700742@chello.nl> <200808261900.07383.nickpiggin@yahoo.com.au> <20080826093059.GA471@elte.hu> <200808261954.47987.nickpiggin@yahoo.com.au>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2008, Nick Piggin wrote:

> On Tuesday 26 August 2008 19:30, Ingo Molnar wrote:
> > * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > So... no reply to this? I'm really wondering how it's OK to break
> > > documented standards and previous Linux behaviour by default for
> > > something that it is trivial to solve in userspace? [...]
> >
> > I disagree
> 
> Your arguments were along the line of:
> 
> * It probably doesn't break anything (except we had somebody report
>   that it breaks their app)

I'm a real-time oldtimer. An application which hogs the CPU for 9.9
seconds with SCHED_FIFO priority is just broken. It's broken beyond
all limits, whether POSIX allows to do that or Linux obeyed the
request of the braindamaged application design.

> * If it does break something then they must be doing something stupid
>   (I refuted that because there are several legitimate ways to use rt
>   scheduling that is broken by this)
>
> * We have many other APIs and tools that don't conform to posix (why
>   is that a reason to break this one?)

Simply because we use common sense instead of following every single
POSIX brainfart by the letter.

> * We should break the API to cater for stupid users and distros who
>   create local DoS and/or lock up their boxes (except this is trivial
>   to solve by setting sysctls or having a watchdog or using sysrq)

For the vast majority of users and RT developers a sane default of
sanity measures is useful and sensible. 

If someone wants to shoot himself in the foot then it's not an
unreasonable request that he needs to disable the safety guards before
pulling the trigger.

Thanks,

	tglx

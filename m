Return-Path: <linux-kernel-owner+w=401wt.eu-S1758048AbYHZL1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048AbYHZL1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 07:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756502AbYHZL1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 07:27:36 -0400
Received: from smtp119.mail.mud.yahoo.com ([209.191.84.76]:23322 "HELO
	smtp119.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756465AbYHZL1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 07:27:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=jdVZcfZ37nvqfSsqUNTjJi51+g5SksH9USLQ9cMvjAw1i3YjgnX1Z1H190dg+E4kkYT/Tj2vQJBU+RePCAWzjK+vkzzBiftHgU0H3LYIyCJiLrRVUm03el8BgUnNJOxnyieSQQDjUtRm7cdWRRnMnczwOv5xf3YrMVApk8tyd80=  ;
X-YMail-OSG: zgn3R30VM1kDq5Vp.qIHE43MxPYTPFcO66500IBwcGlNhqK3UiLdiFKI9BRMlN6wm0JJL_MKTSa35HElkleeorNIU63eXNGDcA0TYsx5NZuij3jdhGjAGV2EMiSu1ICl9kqXlKX2ZnIcmC.r_nxJhjvR
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
Date: Tue, 26 Aug 2008 21:27:26 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20080819103301.787700742@chello.nl> <200808261954.47987.nickpiggin@yahoo.com.au> <alpine.LFD.1.10.0808261219050.3243@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0808261219050.3243@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808262127.26803.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 August 2008 21:09, Thomas Gleixner wrote:
> On Tue, 26 Aug 2008, Nick Piggin wrote:
> > On Tuesday 26 August 2008 19:30, Ingo Molnar wrote:
> > > * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > > So... no reply to this? I'm really wondering how it's OK to break
> > > > documented standards and previous Linux behaviour by default for
> > > > something that it is trivial to solve in userspace? [...]
> > >
> > > I disagree
> >
> > Your arguments were along the line of:
> >
> > * It probably doesn't break anything (except we had somebody report
> >   that it breaks their app)
>
> I'm a real-time oldtimer. An application which hogs the CPU for 9.9
> seconds with SCHED_FIFO priority is just broken. It's broken beyond
> all limits, whether POSIX allows to do that or Linux obeyed the
> request of the braindamaged application design.

Oh with this much handwaving from you old timers I feel much better
about it ;) I bet before the bug report and change to 10s, any
application that hogged the CPU for more than 0.9 seconds was just
broken too, right? But 10s is more than enough for everybody?

I may not be an old timer, but I can say the kernel is just broken
if it deliberately deviates from standards to undocumented behaviour,
and even more so if it changes from working to broken behaviour for
reasons that can be worked around in userspace (eg. running a higher
priority watchdog).


> > * If it does break something then they must be doing something stupid
> >   (I refuted that because there are several legitimate ways to use rt
> >   scheduling that is broken by this)
> >
> > * We have many other APIs and tools that don't conform to posix (why
> >   is that a reason to break this one?)
>
> Simply because we use common sense instead of following every single
> POSIX brainfart by the letter.

How is that a brainfart? It is simple, relatively unambiguous, and not
arbitrary. You really say the POSIX specified behaviour is "a brainfart",
but adding an arbitrary 10s throttle "but the process might be preempted
and lose the CPU to a lower priority task if it uses 10s of consecutive
CPU time" would eliminate that brainfart? I have to laugh.


> > * We should break the API to cater for stupid users and distros who
> >   create local DoS and/or lock up their boxes (except this is trivial
> >   to solve by setting sysctls or having a watchdog or using sysrq)
>
> For the vast majority of users and RT developers a sane default of
> sanity measures is useful and sensible.

You seriously develop complex rt tasks without having at least a simple
watchdog task?


> If someone wants to shoot himself in the foot then it's not an
> unreasonable request that he needs to disable the safety guards before
> pulling the trigger.

root is allowed to shoot themselves in the foot. root is the safeguard.

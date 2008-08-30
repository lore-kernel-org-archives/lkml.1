Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbYH3Gdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbYH3Gdm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 02:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbYH3Gdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 02:33:33 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:32063 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751256AbYH3Gdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 02:33:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=n/IA51TsYP7aWlOENT3Ru1BhOoodhqJFwIIxioHR3jwoehFENABCjXtaU51my6AB3lF3cbdE4ooB8/jbKvvX5/aR8s7JfZrrDfKmStII3p2mzgClHc8YeM3UI6isfTtXg7IMHr3I9niCDZddJjH2G+lkdlKOYTR/r1r4Y3npuT4=  ;
X-YMail-OSG: s3XVPEwVM1nnicNzmNp.14pj8jmVOGNAVeekJP2M9V5ucquyp3Kx6.GAU1wTe.cF1zYxSu9duRylLIyM5KTBgoVX9B1xVXEB4Mx9yRYMMaXz20eEP..pwoDWjZptT9PtwhA-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
Date: Sat, 30 Aug 2008 16:33:23 +1000
User-Agent: KMail/1.9.5
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080819103301.787700742@chello.nl> <alpine.DEB.1.10.0808281142280.14580@gandalf.stny.rr.com> <alpine.LFD.1.10.0808281024060.3300@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808281024060.3300@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808301633.23764.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 August 2008 03:26, Linus Torvalds wrote:
> On Thu, 28 Aug 2008, Steven Rostedt wrote:
> > I've always thought that the policy settings belong in the distro, and
> > the kernel should never enforce a policy (by setting this as default, it
> > is enforcing a policy, even though an RT user can change it).
>
> The kernel has always done a certain amount of "default policy".
>
> What do you think things like "swappiness" etc are? Or things like
> oevrcommit settings? They're all policies, and there is always a default
> one. So in that sense the kernel always has - and fundamentally _must_ -
> set some kind of policy.

There is a difference. You *have* to pick some value for those things.
The settings can't necessarily be called correct or incorrect.

The default rt sched policy is definitely "broken" in that it very clearly
changes our previous behaviour, documentation, and what other systems do.

You could say that "realtime" in general is not really a single accepted
definition, but *SCHED_FIFO* and *SCHED_RR* in particular do have a well
defined, simple, and widely accepted definition that is undeniably changed
by this "policy".

Given that a) we can easily introduce new SCHED_xxx policies to implement
the new behaviour, and b) there are quite a few users of this API in this
thread who are concerned about the change, I think it is wisest just to
revert to our old behaviour.

I thought the rule of thumb is "if in doubt, we don't break user APIs".
It's funny that nobody has really answered any of my points of concern.

Anyway, I won't keep harping on about it.


> And the default policy should generally be the one that makes sense for
> most people. Quite frankly, if it's an issue where all normal distros
> would basically be expected to set a value, then that value should _be_
> the default policy, and none of the normal distros should ever need to
> worry.
>
> Whether this case is one such, I dunno. Quite frankly, I don't think it's
> even _nearly_ important enough to get this kind of noise.

That's cause you don't care about rt that much. You do care about back
compatibility though so I thought you'd be more interested. Anyway, I won't
post any more.

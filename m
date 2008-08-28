Return-Path: <linux-kernel-owner+w=401wt.eu-S1756360AbYH1SFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360AbYH1SFR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 14:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbYH1SFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 14:05:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34349 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbYH1SFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 14:05:02 -0400
Date: Thu, 28 Aug 2008 14:04:59 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
In-Reply-To: <alpine.LFD.1.10.0808281024060.3300@nehalem.linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0808281356010.6278@gandalf.stny.rr.com>
References: <20080819103301.787700742@chello.nl> <200808290036.35817.nickpiggin@yahoo.com.au> <alpine.DEB.1.10.0808281110570.14580@gandalf.stny.rr.com> <200808290134.35093.nickpiggin@yahoo.com.au> <alpine.DEB.1.10.0808281142280.14580@gandalf.stny.rr.com>
 <alpine.LFD.1.10.0808281024060.3300@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 28 Aug 2008, Linus Torvalds wrote:

> 
> 
> On Thu, 28 Aug 2008, Steven Rostedt wrote:
> > 
> > I've always thought that the policy settings belong in the distro, and the 
> > kernel should never enforce a policy (by setting this as default, it is 
> > enforcing a policy, even though an RT user can change it).
> 
> The kernel has always done a certain amount of "default policy". 
> 
> What do you think things like "swappiness" etc are? Or things like 
> oevrcommit settings? They're all policies, and there is always a default 
> one. So in that sense the kernel always has - and fundamentally _must_ - 
> set some kind of policy.
> 
> And the default policy should generally be the one that makes sense for 
> most people. Quite frankly, if it's an issue where all normal distros 
> would basically be expected to set a value, then that value should _be_ 
> the default policy, and none of the normal distros should ever need to 
> worry.
> 
> Whether this case is one such, I dunno. Quite frankly, I don't think it's 
> even _nearly_ important enough to get this kind of noise.

I guess the reason that this is getting so much noise over other default 
policies, is that this default policy is changing a well known definition:
The meaning of FIFO.

By making the default policy limit the time an RT task runs, we have, in 
essence, changed a user API. Applications that expect to be able to run  
uninterrupted by SCHED_OTHER tasks, will now break.

No one is arguing that this new feature is not useful. The argument is, 
should the kernel set the default policy of an old well known scheduling 
policy to something different than what is expected?

Distros set SE Linux on by default, should the kernel do that too?

-- Steve


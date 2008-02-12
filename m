Return-Path: <linux-kernel-owner+w=401wt.eu-S1760001AbYBLPgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001AbYBLPgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 10:36:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751112AbYBLPg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 10:36:27 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37086 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbYBLPg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 10:36:27 -0500
Date: Tue, 12 Feb 2008 17:11:52 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] kgdb-light -v10
Message-ID: <20080212161152.GA3281@one.firstfloor.org>
References: <y0mhcgf4ig1.fsf@ton.toronto.redhat.com> <20080211162141.GA31434@elte.hu> <20080211171039.GA20446@one.firstfloor.org> <20080211230335.GA16102@elte.hu> <20080212100327.GA30873@one.firstfloor.org> <20080212112747.GA1569@elte.hu> <20080212121903.GA419@one.firstfloor.org> <20080212123839.GA15360@elte.hu> <20080212135027.GA1343@one.firstfloor.org> <20080212152846.GC3078@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212152846.GC3078@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 04:28:46PM +0100, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > do spinning for now: we dont _ever_ want to break a correctly 
> > > working system with kgdb.
> > 
> > Stopping all CPUs for indefinite time very much seems like "breaking a 
> > correctly working system" to me. [...]
> 
> well, this is a small detail, but still you are wrong, and on a 
> correctly working system this will not occur. (if yes, tell me how)
> 
> KGDB does a very straightforward "all CPUs enter controlled state" 
> transition when the session begins, and at the end an "all CPUs 
> continue" transition.

Yes and the session has no fixed time limit.

> 
> I'm not sure what you mean exactly under "stopping all CPUs for 
> indefinite amount of time" (your statement is sufficiently vague to be 

Stopping with interrupts off. Nothing scheduled anymore. 

An easy definition for the condition is anything that requires 
touch_{nmi,softlockup}_watchdog [which kgdb definitely does, 
although in a quite convoluted way]

> yes, we could "time out" and force a KGDB session even if some CPUs do 
> not respond. But it's obviously not a completely safe system state, 
> because other CPUs might be changing things under the feet of the 
> debugger. So the safest first-level approach is to not enter the 

While that is a slight risk that problem is already there anyways.
Lots of agents in the system could do that. Do you plan to stop
all DMA too for example if you're so worried about this? 
Or how about SMM code changing something? 

Anyways the slight risk of the other CPUs eventually recovering
would seem a acceptable trade off versus not being able to use
the debugger to debug the system with hanging CPUs. 

A possible compromise between my and your position on this would 
be also having an option for this, with default to off
(although I would expect that would be a inconvenient default for
many people)

-Andi (who retires from this thread now, I already spent too much on this)


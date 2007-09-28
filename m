Return-Path: <linux-kernel-owner+w=401wt.eu-S1760377AbXI1KAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760377AbXI1KAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 06:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754776AbXI1KAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 06:00:38 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1270 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbXI1KAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 06:00:37 -0400
Date: Fri, 28 Sep 2007 11:00:24 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.10
Message-ID: <20070928100024.GB18163@shadowen.org>
References: <bf97f66cfc0696c8574921d53eaafcb7@pinky> <20070928084003.GA18882@elte.hu> <20070928020132.f6c6f528.akpm@linux-foundation.org> <20070928092235.GA31180@shadowen.org> <20070928093902.GA28455@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070928093902.GA28455@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 11:39:02AM +0200, Ingo Molnar wrote:
> 
> * Andy Whitcroft <apw@shadowen.org> wrote:
> 
> > > >   WARNING: multiple assignments should be avoided
> > > >   #2319:
> > > >   +       max_load = this_load = total_load = total_pwr = 0;
> > > 
> > > That warning is non-bogus, although this is one of the bogosities 
> > > which I personally don't bother fixing or making a fuss about.
> > > 
> > > But I do think it detracts from the readability of the code, and 
> > > from patches which later alter that code.  A bit.
> > 
> > I tend to agree, watching the automatic replies from checkpatch, the 
> > majority of these are "justifiable" in their context.  I think I'll 
> > lower this one to a CHECK in the next release.
> 
> what matters is that only items should be displayed that i _can_ fix. 
> With v8 i was able to make kernel/sched*.c almost noise-free, but with 
> v9 and v10 that's not possible anymore. And the moment the default 
> output of the tool cannot be made 'empty', we've lost the biggest 
> battle. Seeing the same bogus (or borderline) warnings again and again 
> destroys the biggest dynamic that could get people to use this tool more 
> often: the gratification of having a 'perfectly clean' file/patch.
> 
> And this is not about any particular false positive. I dont mind an 
> "advanced mode" non-default opt-in option for the script, if someone is 
> interested in borderline or hard to judge warnings too, but these 
> default false positives are _lethal_ for a tool like this. (and i made 
> this point before.) This is a _fundamental_ thing, and i'm still not 
> sure whether you accept and understand that point. This is very basic 
> and very important, and this isnt the first (or second) time i raised 
> this.

You are striving for a level of perfection that is simply not achieveable.
v8 is silent about sched.c because it is not checking very much of it,
the logical extension of your position is to run 0.1 as that didn't check
anything.  v9 and 10 carry checks for most of the binary operators which
were not there before.  Due as I have mentioned before to the complexity
of handling the unary/binary scism that C has for those operators and
our different spacing requirement for each mode.

Whilst I can see that it is gratifying that a patch or file is
violations free where there are stylistic aberations in it they should
be reported.  Where those are questionble showing those as "CHECK" is
not unreasonable.  I will add a "--no-check" for you so that those are
suppressed based on the assumption you know what you are doing.

I think it is clear that we differ on what should and should not be
output by default.  Clever people are able to opt out of the warnings,
of things they think they dissagree with.  It is the people with little
experience who need the most guidance and those people who the tool
should target by default.  You cannot expect someone with no experience
to know they need to add '--i-need-more-help' whereas _you_ I can expect
to say '--leave-me-alone' or indeed to make the call that the output is
plain wrong and _you_ know you should ignore it.

Fundamentally I am not trying to help the people who are careful but
those who do not know better.  As for the false positives, those I am
always interested in and always striving to remove, as they annoy me as
much as the next man.

-apw

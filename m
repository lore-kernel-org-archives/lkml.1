Return-Path: <linux-kernel-owner+w=401wt.eu-S1762530AbZEAPvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762530AbZEAPvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 11:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbZEAPve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 11:51:34 -0400
Received: from gir.skynet.ie ([193.1.99.77]:44657 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbZEAPve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 11:51:34 -0400
Date: Fri, 1 May 2009 16:51:30 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Eric Lacombe <goretux@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       davej@redhat.com, tglx@linutronix.de
Subject: Re: [unused symbol] need to use init_mm
Message-ID: <20090501155130.GF27831@csn.ul.ie>
References: <200904301232.05302.goretux@gmail.com> <20090430140957.GD21997@csn.ul.ie> <20090430144057.GA14897@elte.hu> <200904301955.55407.goretux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200904301955.55407.goretux@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 07:55:54PM +0200, Eric Lacombe wrote:
> On Thu, Apr 30, 2009, Ingo Molnar wrote :
> > * Mel Gorman <mel@csn.ul.ie> wrote:
> > > On Thu, Apr 30, 2009 at 12:32:04PM +0200, Eric Lacombe wrote:
> > > > Hi,
> > > >
> > > > Within a module I work on, I need to access to init_mm, but as it is
> > > > marked UNUSED, I wonder if there is another way (an API) to access to
> > > > it. Otherwise, what can I do to have this mark removed from init_mm in
> > > > the mainline? as my module is really not yet ready for inclusion.
> > > >
> > > > Thanks in advance for your response,
> > >
> > > It looks to be that it was removed already, somewhat behind schedule, in
> > > commit 9470565579f29486f4ed0ffa50774268b64994b0 after an initial attempt
> > > was made in commit 3abf024d2abb79614d8c4cb25a70d5596f77d0ad.  I don't
> > > know if there is a procedure for bringing it back but I would guess it's
> > > a call for the x86 maintainers. I imagine they will want to at least
> > > know;
> > >
> > > 1. Why do you need init_mm exported?
> 
> In brief, my module use hardware virtualization technologies (only Intel ones 
> for the moment) in order to prevent the kernel from behaving maliciously 
> (because of a kernel malware) and to prevent the installation of many kernel 
> malwares. One of my approaches is to preserve some kernel-constrained objects: 
> for instance, some simple objects like idtr, gdtr, ... or some more 
> complicated objects like the kernel address space layout, ...
> For the latter I use init_mm.pgd.
> 

If it's the kernel portion of the address space is what you care about,
is current->mm->pgd usable?

> I wrote a paper and will talk about it at the EICAR conference (May 11th and 
> 12th) this year (http://www.eicar.org/conference/index.htm).
> 
> > > 2. Is there an alternative approach to using init_mm?
> 
> I don't really take the time to think about another approach, but it seems 
> natural to access to init_mm.pgd. Maybe, I could access to it by other means,  
> but that would certainly be ugly :/
> 
> > > 3. Assuming yes, what are the downsides?
> 
> ugliness ;) maybe kernel version dependent.
> 

Unfortunately, you are already hit with the kernel version problem as
2.6.29 has been released without init_mm exported for the x86 arch.

> > > 4. When do you think the module will be ready for posting?  i.e. is this
> > >    really something destined for mainline or some perma-out-of-tree?
> 
> It is destined for mainline as far as I'm concerned. But it needs to be 
> accepted by the kernel community when it will be ready.
> (I work for a french public laboratory, so it will be GPL 2 or 3 licensed 
> anyway)
> 

If it really is absolutly necessary that you have init_mm and the
alternatives really are too ugly, patch 1 of your set becomes a
re-export of init_mm. The leader of that patch should explain why the
alternatives to init_mm suck.

You can try posting a patch to export init_mm without an in-tree user but
I wouldn't bet money on the x86 maintainers picking it up without an
extremely compelling reason.

> >
> > yes, those questions have to be answered.
> 
> I hope to have adequately answered to your questions.
> 

We can't go back in time so check out if current->mm->pgd will do the job. If
not, make patch 1 of your set a re-export of init_mm until you're ready to
post. At that point, people can see what you are doing and suggest what an
alternative might be or if indeed the symbol should be exported after all.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753129AbYH0Rgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbYH0Rgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 13:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbYH0Rgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 13:36:38 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:41819 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbYH0Rgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 13:36:37 -0400
Date: Wed, 27 Aug 2008 20:35:44 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Paul Mundt <lethal@linux-sh.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-embedded@vger.kernel.org
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
	bisected
Message-ID: <20080827173544.GH11734@cs181140183.pp.htv.fi>
References: <20080826183051.GB10925@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0808261144510.3363@nehalem.linux-foundation.org> <20080826205916.GB11734@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0808261403360.3363@nehalem.linux-foundation.org> <20080826232411.GC11734@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0808261648140.3363@nehalem.linux-foundation.org> <20080827002316.GE11734@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0808261726560.3363@nehalem.linux-foundation.org> <20080827115829.GF11734@cs181140183.pp.htv.fi> <20080827160052.GA15968@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080827160052.GA15968@linux-sh.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 01:00:52AM +0900, Paul Mundt wrote:
> On Wed, Aug 27, 2008 at 02:58:30PM +0300, Adrian Bunk wrote:
> > On Tue, Aug 26, 2008 at 05:28:37PM -0700, Linus Torvalds wrote:
> > > On Wed, 27 Aug 2008, Adrian Bunk wrote:
> > > > 
> > > > When did we get callpaths like like nfs+xfs+md+scsi reliably 
> > > > working with 4kB stacks on x86-32?
> > > 
> > > XFS may never have been usable, but the rest, sure.
> > > 
> > > And you seem to be making this whole argument an excuse to SUCK, adn an 
> > > excuse to let gcc crap even more on our stack space.
> > > 
> > > Why?
> > > 
> > > Why aren't you saying that we should be able to do better? Instead, you 
> > > seem to asking us to do even worse than we do now?
> > 
> > My main point is:
> > - getting 4kB stacks working reliably is a hard task
> > - having an eye on gcc increasing the stack usage, and fixing it if
> >   required, is relatively easy
> > 
> > If we should be able to do better at getting (and keeping) 4kB stacks 
> > working, then coping with possible inlining problems caused by gcc
> > should not be a big problem for us.
> > 
> Out of the architectures you've mentioned for 4k stacks, they also tend
> to do IRQ stacks, which is something you seem to have overlooked.

No, I am aware of that, and on i386 IRQ stacks are only used with
4kB stacks.

On i386 it is effectively a step from 6kB to 4kB.

> In addition to that, debugging the runaway stack users on 4k tends to be
> easier anyways since you end up blowing the stack a lot sooner. On sh
> we've had pretty good luck with it, though most of our users are using
> fairly deterministic workloads and continually profiling the footprint.
> Anything that runs away or uses an insane amount of stack space needs to
> be fixed well before that anyways, so catching it sooner is always
> preferable. I imagine the same case is true for m68knommu (even sans IRQ
> stacks).

CONFIG_DEBUG_STACKOVERFLOW should give you the same information, and if
wanted with an arbitrary limit.

> Things might be more sensitive on x86, but it's certainly not something
> that's a huge problem for the various embedded platforms to wire up,
> whether they want to go the IRQ stack route or not.

How many platforms use 4kB stacks on sh?

Only 1 out of 34 defconfigs uses it.

Are there any numbers for real life usage.

> In any event, lack of support for something on embedded architectures in
> the kernel is more often due to apathy/utter indifference on the part of
> the architecture maintainer rather than being indicative of any intrinsic
> difficulty in supporting the thing in question. Most new "features" on the
> lesser maintained architectures tend to end up there either out of peer
> pressure or copying-and-pasting accidents rather than any sort of design.
> ;-)

arm or powerpc aren't exactly lesser maintained architectures.

4kB has shown to be a hard to achieve limit. After more than 4 years in 
mainline being available on i386 there are still cases where 4kB are not 
enough.

IMHO there seems to currently be a mismatch between it's maintainance 
cost and the actual number of users. That's in my opinion the main 
problem with it, no matter in which direction it gets resolved.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


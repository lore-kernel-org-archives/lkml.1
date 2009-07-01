Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400AbZGAUsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbZGAUsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 16:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZGAUsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 16:48:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46297 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbZGAUsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 16:48:23 -0400
Date: Wed, 1 Jul 2009 22:48:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 3/9] x86/moorestown: add moorestown platform flags
Message-ID: <20090701204807.GA30161@elte.hu>
References: <20090626111603.758ec7fb@lxorguk.ukuu.org.uk> <20090626110429.GB12446@elte.hu> <20090626125653.5e30bae4@lxorguk.ukuu.org.uk> <20090626122254.GA9959@elte.hu> <20090626133318.5b8de81b@lxorguk.ukuu.org.uk> <20090626142937.GA19477@elte.hu> <alpine.LFD.2.00.0906261827490.2767@localhost.localdomain> <20090626095454.6f993a9c@jbarnes-g45> <20090630063513.GJ1351@ucw.cz> <20090701102500.696962db@jbarnes-g45>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701102500.696962db@jbarnes-g45>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Tue, 30 Jun 2009 08:35:13 +0200
> Pavel Machek <pavel@ucw.cz> wrote:
> 
> > On Fri 2009-06-26 09:54:54, Jesse Barnes wrote:
> > > On Fri, 26 Jun 2009 18:32:42 +0200 (CEST)
> > > Thomas Gleixner <tglx@linutronix.de> wrote:
> > > 
> > > > On Fri, 26 Jun 2009, Ingo Molnar wrote:
> > > > > [ Although it is beyond me why ABP was done - why wasnt HPET
> > > > > good enough? HPET can do per CPU clockevents too and it's just
> > > > > as off-chip (and hence fundamentally slow) as ABP. ]
> > > > 
> > > > Welcome to the wonderful world of embedded systems. Just have a
> > > > peek into arch/[arm/powerpc/mips] to see what's coming up to us
> > > > with full force. I would not be surprised when we see an x86
> > > > system sharing the device driver for i2c or whatever with an ARM
> > > > SoC in the foreseable future.
> > > 
> > > Ha, yeah I was just going to say "think embedded".  ABP is a much
> > > simpler spec and programming interface than HPET, and since we were
> > > designing new custom silicon, it made sense to just do the simple
> > > thing, rather than butchering an existing spec, then making a
> > > partial HPET that looks like ABP anyway and forcing any future HPET
> > > updates to conform to the new standard (very similar reasoning to
> > > the ACPI vs SFI discussion btw).  Hopefully the technologies we've
> > > come up with for
> > 
> > Very similary wrong, I'd say :-(. While you could have created
> > hpet-lite, where hpet-lite driver would work on hpet system, you went
> > and created something new.
> > 
> > And yes, SFI is similar disaster, you should just define subset of
> > acpi ('acpi-lite').
> > 
> > In the end, you are willing to use silicon for compatibility (arm
> >  instruction set needs less transistors, right?) and wasting millions
> >  of transistors, then try to save thousands with non-compatible
> >  devices :-(.
> 
> You didn't address the essence of either argument; butchering an 
> existing spec and placing an extra burden on all future 
> implementations is a high price to pay, both in terms of 
> complexity and cost.
> 
> But really these are moot points; this is how the platform works.  
> I'd like to see Linux run on it "out of the box" which means 
> integrating support for these features in a maintainable way.  
> Hopefully no one disagrees with that; after all Linux runs on much 
> uglier platforms than this.

I agree and that's fine.

Note that obviously ugliness increases the integration costs and 
latency for Intel: all ugly bits have to be factored out cleanly, 
have to be turned into isolated components and tucked away, so that 
the ugliness does not spread.

If something is just plain 'standard', that makes it really easy to 
merge. The less standard something is, the more trouble integration 
becomes.

Also, i genuinely think that it's perfectly fine to iterate hardware 
specs - to simplify and enhance it. And this is an area where Linux 
is the strongest - we can support just about anything and can do it 
quickly. I just wish that those variations were something to be 
unconditionally proud of from an engineering POV ;-)

So for similar projects in the future - it's OK to be non-standard, 
but the preferred direction should be something genuinely better 
designed, or something that is just a _sub-set_ of the standard. 
Supporting a sub-set is way easier than supporting something that is 
different in some unanticipated way and needs an extension of 
infrastructure.

The IO-APIC bits seems to be the latter in this case - i.e. they are 
an "IO-APIC light" implementation in essence. And that shows 
immediately: the patches arent all that horrible.

And SFI seems useful to me as well, not because it's a sub-set of 
ACPI, but because i find it cleaner than ACPI.

The ABP timer is another matter - it's a completely separate 
from-scratch thing that is dissimilar to everything that exists. 
OTOH, timers are pretty separate entities just (still) not 
abstracted out well enough on x86 yet.

	Ingo

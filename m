Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834AbZDPVGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbZDPVGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 17:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754794AbZDPVGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 17:06:20 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45901 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754667AbZDPVGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 17:06:18 -0400
Subject: Re: [PATCH 00/14] convert voyager over to the x86 quirks model
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>
In-Reply-To: <20090415153511.GA30385@elte.hu>
References: <1239724300-16371-1-git-send-email-James.Bottomley@HansenPartnership.com>
	 <20090414165722.GD2089@elte.hu> <20090414180832.GA25692@elte.hu>
	 <1239750743.3638.12.camel@mulgrave>  <20090415153511.GA30385@elte.hu>
Content-Type: text/plain
Date: Thu, 16 Apr 2009 21:06:16 +0000
Message-Id: <1239915976.3762.88.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-15 at 17:35 +0200, Ingo Molnar wrote: 
> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > On Tue, 2009-04-14 at 20:08 +0200, Ingo Molnar wrote: 
> > > * Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > > 
> > > > * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > > > 
> > > > >  39 files changed, 554 insertions(+), 726 deletions(-)
> > > > 
> > > > That diffstat is not against current mainline, is it? 
> > > > Would you mind to send a proper diffstat with the revert 
> > > > included as well? That will give us a complete picture.
> > > 
> > > ok, i did the calculations, and the effect of adding back 
> > > x86/Voyager is roughly:
> > > 
> > >    48 files changed, 5226 insertions(+), 142 deletions(-)
> > > 
> > > That's quite a lot, and lets put this into perspective.
> > 
> > Hardly ... you're conflating two issues: one is what is the burden 
> > to mainline, which the patch series is about, although only patch 
> > 1 (and possibly patch 5) is truly critical to that, the rest are 
> > assorted code moves.
> 
> This is roughly the diffstat we get when we add x86/Voyager support 
> again. Are you saying that the diffstat is wrong? Could you paste 
> the right diffstat then (which i asked you to do before, and which 
> you have not done), which i'd get if i pulled your tree, if you 
> think this one is wrong?

If you're arguing on maintainability, yes.  You specificially excluded a
bunch of files that are in 2.6.29 because you removed them from the
tree: that makes it a rather artificial benchmark.  I could look at
arch/x86 stats from v2.6.29:

488 files changed, 32782 insertions(+), 31057 deletions(-)

So 64,000 lines of code changed ... that's huge ... and I didn't even
try to inflate the figures by removing any of it before trying to make
the calculation as you did.

The point about all of this is that ad Disreli pointed out, statistics
can be used to prove anything.  If you run the voyager count from
v2.6.29 to the head of my changes, by the way, it's

39 files changed, 554 insertions(+), 726 deletions(-)

More to the point is that the core code sits in about 3,600 lines in
mach-voyager, which isn't executed by core x86 and so doesn't affect its
maintainability.

> > > You are talking about moving ~5000 lines of legacy code back 
> > > into arch/x86/, for a total of *four* Voyager/Linux systems, 
> > > which are using _ancient_ 486/P5 era CPUs.
> > 
> > That's factually incorrect on both counts. [...]
> 
> Please correct my numbers and facts then, if you know them.
> 
> > [...]  But the real point is that kernel development isn't a 
> > popularity contest, it's about the technical merits of the code 
> > ... something you've been conspicuously avoiding.
> 
> The popularity and relevance (and obscolescence) of a hardware 
> platform is certainly a significant factor in architecture 
> maintenance decisions (such as whether and when to merge a piece of 
> code or not) - are you saying it is not?

Well, um, yes, I don't ever run a popularity contest before making those
type of decisions for SCSI.   We recently did a bunch of clean ups for
the m68k SCSI drivers to make them more maintainable, which are for hw
up to a decade older than voyager. 

> This is not just a new, well-isolated driver to put into drivers/* - 
> this is about the most used Linux architecture code.

However, I think even you can agree voyager is well isolated.

> > > Two of these systems are in your house, two are somewhere 
> > > unknown: their owners certainly never sent bugreports against 
> > > recent mainline kernels (Voyager didnt even _build_ for a couple 
> > > of straight kernel releases), and i suspect those boxes are 
> > > probably decommissioned already.
> > > 
> > > A single core on my run-of-the-mill x86 laptop has more 
> > > computing power than all Voyager/Linux systems on the planet, 
> > > combined. And you now want to add back support to the mainline 
> > > arch/x86 code, which we are trying hard to keep running on 
> > > millions of x86 Linux systems?
> > 
> > Well, what can I say, if your laptop is the speed standard for 
> > acceptable architectures, then I suppose you'll be removing all of 
> > the embedded architectures as well?
> 
> I did not say or suggest that, and you clearly misrepresented my 
> argument - so it seems to me you are not really interested in having 
> an objective argument about this.

So if you don't want to get caught in semantic absurdities, don't make
the leading statements.  You want this to be a tautology for voyager
isn't a popular architecture, just repackaged to make it look like a new
argument. 

> My argument was:
> 
>   " A single core on my run-of-the-mill x86 laptop has more
>     computing power than all Voyager/Linux systems on the planet,
>     combined. "
> 
> How can you deform this plain-English fact that exposes the shocking 
> irrelevance of Voyager/Linux into suggesting that i'd be "removing 
> all of the embedded architectures as well" ?

It rather effectively made the point that we don't judge architecture
viability on speed either.

> It's an insane suggestion. [ In reality the combined computing power 
> of all ARM or MIPS chips on this planet would certainly beat the 
> currently fastest supercomputer. (it would be a few orders of 
> magnitude faster, most likely) 

Sigh, so if you stick to your own performance definitions, I can give
you Netwinder, Visual Workstation and NUMAQ, all of which voyager can
outperform in your theoretical global devices faceoff, all of which are
in-kernel and at least two of which you recently worked on.

> > > You still have not given proper justification for doing that ...
> > 
> > The justification is that I'm prepared to maintain it.
> 
> Sorry, but your willingness to maintain it _now_, means little to 
> me. What matters to me is the existing track record of Voyager:
> 
>   v2.6.27.0:   Voyager was broken - it did not even build.
>   v2.6.28.0:   Voyager was broken - it did not even build.
>   v2.6.29-rc5: Voyager was broken - it did not even build.

You forgot:

v2.6.29: Builds and boots

I'm sure that was an accidental oversight given that you're unbiased.

> ... it was broken up to the point where we removed it from the x86 
> devel tree. It only built in your out-of-tree repository. As far as 
> the upstream kernel users are concerned Voyager did not exist since 
> v2.6.27.0.

2.6.29 builds and you were the one who failed to apply the patches sent
to the mailing list for 2.6.28.

> And the further justification (beyond all the things i mentioned in 
> this and prior mails) i'm giving you for not pulling it right now is 
> that Voyager/Linux is obviously irrelevant: with just about 4 boxes 
> on the planet.

Every architecture no longer in production (alpha and parisc to name but
two) has a declining population of boxes, that's a reasonable natural
law. So what population size is statistically irrelevant in your terms?
1000, 100, 10 etc.

The point I'm trying to make is that the best way to judge this is via
bitrot.  We don't have to care about the population size if all we judge
it by is the willingness of people to fix it and make it work.  When the
population drops to zero, that will obviously stop, and if it stops
before the zero point then nobody cared enough.  These are objective
criteria that don't get us into the business of running popularity
contests. 

> If that factor changes materially then the decision could be 
> reconsidered.

You mean like someone starting up a voyager production line?  That's a
nice artificial barrier ... 

> > > Sorry to be the one to say 'no', but the reasons you gave so far 
> > > were not very convincing to me.
> > >  
> > > Anyway, you seem to be willing to maintain this code it out of tree. 
> > > If someone owns such an ancient Voyager box and wants to test a new 
> > > kernel then your tree is a good starting point for doing that. 
> > > There's really no pressing need to have this in mainline.
> > 
> > So the message you want to be giving out as a maintainer is that 
> > everything should be developed upstream, except when it's x86?
> 
> No, the message i'm giving out as a maintainer is that everything 
> that did not get merged due to being judged problematic or 
> irrelevant (or both) by a maintainer can still be maintained out of 
> tree, so that it can _prove_ the maintainer wrong: i.e. that it is 
> useful and still relevant.

That's not what we're currently saying to people ... we tell them to get
it upstream to be maintained there.  Otherwise why shouldn't people like
nVidia maintain their driver out of tree with our blessing as well.  And
thus they have legitimate complaints against us when we break it if we
communicate this expectation.

> Get a user base. Find bugs on those boxes.

It has a user base

>  Prove it that it matters 
> to Linux. Then we can admit our mistake in a couple of cycles and 
> merge it. There's been projects that lived out of tree for a decade, 
> literally. There's life outside the upstream kernel too - it's not 
> like your code has been destroyed. And you already expressed 
> willingness to maintain it - and you are the only developer able to 
> boot such a box. So please do it even if this code is not upstream 
> for a few kernel cycles, for the sake of Voyager users.

A right, this is the moving bar argument.

First you said it had to be converted to your quirks architecture.

Then when that happened, you decided it was too late for you to look at
it and you'd have to remove it from the tree for a cycle so it could be
included next time around

Now you're saying several cycles.

This is basically you trying to avoid the problem and hoping it will go
away.

James



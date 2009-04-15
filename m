Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbZDOPfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbZDOPfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 11:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119AbZDOPfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 11:35:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47555 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbZDOPfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 11:35:22 -0400
Date: Wed, 15 Apr 2009 17:35:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 00/14] convert voyager over to the x86 quirks model
Message-ID: <20090415153511.GA30385@elte.hu>
References: <1239724300-16371-1-git-send-email-James.Bottomley@HansenPartnership.com> <20090414165722.GD2089@elte.hu> <20090414180832.GA25692@elte.hu> <1239750743.3638.12.camel@mulgrave>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239750743.3638.12.camel@mulgrave>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Tue, 2009-04-14 at 20:08 +0200, Ingo Molnar wrote: 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > 
> > > * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > > 
> > > >  39 files changed, 554 insertions(+), 726 deletions(-)
> > > 
> > > That diffstat is not against current mainline, is it? 
> > > Would you mind to send a proper diffstat with the revert 
> > > included as well? That will give us a complete picture.
> > 
> > ok, i did the calculations, and the effect of adding back 
> > x86/Voyager is roughly:
> > 
> >    48 files changed, 5226 insertions(+), 142 deletions(-)
> > 
> > That's quite a lot, and lets put this into perspective.
> 
> Hardly ... you're conflating two issues: one is what is the burden 
> to mainline, which the patch series is about, although only patch 
> 1 (and possibly patch 5) is truly critical to that, the rest are 
> assorted code moves.

This is roughly the diffstat we get when we add x86/Voyager support 
again. Are you saying that the diffstat is wrong? Could you paste 
the right diffstat then (which i asked you to do before, and which 
you have not done), which i'd get if i pulled your tree, if you 
think this one is wrong?

> > You are talking about moving ~5000 lines of legacy code back 
> > into arch/x86/, for a total of *four* Voyager/Linux systems, 
> > which are using _ancient_ 486/P5 era CPUs.
> 
> That's factually incorrect on both counts. [...]

Please correct my numbers and facts then, if you know them.

> [...]  But the real point is that kernel development isn't a 
> popularity contest, it's about the technical merits of the code 
> ... something you've been conspicuously avoiding.

The popularity and relevance (and obscolescence) of a hardware 
platform is certainly a significant factor in architecture 
maintenance decisions (such as whether and when to merge a piece of 
code or not) - are you saying it is not?

This is not just a new, well-isolated driver to put into drivers/* - 
this is about the most used Linux architecture code.

> > Two of these systems are in your house, two are somewhere 
> > unknown: their owners certainly never sent bugreports against 
> > recent mainline kernels (Voyager didnt even _build_ for a couple 
> > of straight kernel releases), and i suspect those boxes are 
> > probably decommissioned already.
> > 
> > A single core on my run-of-the-mill x86 laptop has more 
> > computing power than all Voyager/Linux systems on the planet, 
> > combined. And you now want to add back support to the mainline 
> > arch/x86 code, which we are trying hard to keep running on 
> > millions of x86 Linux systems?
> 
> Well, what can I say, if your laptop is the speed standard for 
> acceptable architectures, then I suppose you'll be removing all of 
> the embedded architectures as well?

I did not say or suggest that, and you clearly misrepresented my 
argument - so it seems to me you are not really interested in having 
an objective argument about this.

My argument was:

  " A single core on my run-of-the-mill x86 laptop has more
    computing power than all Voyager/Linux systems on the planet,
    combined. "

How can you deform this plain-English fact that exposes the shocking 
irrelevance of Voyager/Linux into suggesting that i'd be "removing 
all of the embedded architectures as well" ?

It's an insane suggestion. [ In reality the combined computing power 
of all ARM or MIPS chips on this planet would certainly beat the 
currently fastest supercomputer. (it would be a few orders of 
magnitude faster, most likely) ]

> > You still have not given proper justification for doing that ...
> 
> The justification is that I'm prepared to maintain it.

Sorry, but your willingness to maintain it _now_, means little to 
me. What matters to me is the existing track record of Voyager:

  v2.6.27.0:   Voyager was broken - it did not even build.
  v2.6.28.0:   Voyager was broken - it did not even build.
  v2.6.29-rc5: Voyager was broken - it did not even build.

... it was broken up to the point where we removed it from the x86 
devel tree. It only built in your out-of-tree repository. As far as 
the upstream kernel users are concerned Voyager did not exist since 
v2.6.27.0.

And the further justification (beyond all the things i mentioned in 
this and prior mails) i'm giving you for not pulling it right now is 
that Voyager/Linux is obviously irrelevant: with just about 4 boxes 
on the planet.

If that factor changes materially then the decision could be 
reconsidered.

> > Sorry to be the one to say 'no', but the reasons you gave so far 
> > were not very convincing to me.
> >  
> > Anyway, you seem to be willing to maintain this code it out of tree. 
> > If someone owns such an ancient Voyager box and wants to test a new 
> > kernel then your tree is a good starting point for doing that. 
> > There's really no pressing need to have this in mainline.
> 
> So the message you want to be giving out as a maintainer is that 
> everything should be developed upstream, except when it's x86?

No, the message i'm giving out as a maintainer is that everything 
that did not get merged due to being judged problematic or 
irrelevant (or both) by a maintainer can still be maintained out of 
tree, so that it can _prove_ the maintainer wrong: i.e. that it is 
useful and still relevant.

Get a user base. Find bugs on those boxes. Prove it that it matters 
to Linux. Then we can admit our mistake in a couple of cycles and 
merge it. There's been projects that lived out of tree for a decade, 
literally. There's life outside the upstream kernel too - it's not 
like your code has been destroyed. And you already expressed 
willingness to maintain it - and you are the only developer able to 
boot such a box. So please do it even if this code is not upstream 
for a few kernel cycles, for the sake of Voyager users.

	Ingo

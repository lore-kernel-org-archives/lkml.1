Return-Path: <linux-kernel-owner+w=401wt.eu-S937297AbXGLALc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937297AbXGLALc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936781AbXGKX7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:59:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38633 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934892AbXGKX7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:59:34 -0400
Date: Thu, 12 Jul 2007 01:58:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
Message-ID: <20070711235852.GA625@elte.hu>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu> <alpine.LFD.0.999.0707111438530.20061@woody.linux-foundation.org> <1184191488.12353.160.camel@chaos> <alpine.LFD.0.999.0707111518020.20061@woody.linux-foundation.org> <1184194219.12353.170.camel@chaos> <alpine.LFD.0.999.0707111558250.20061@woody.linux-foundation.org> <20070711233618.GD25510@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070711233618.GD25510@one.firstfloor.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > The same is true of a lot of the APIC timer code. Sure, that patch 
> > has the actual conversion in it, and you don't have the 
> > cross-architecture issues, but more than 50% of the patch seems to 
> > be just cleanup that is independent of the actual switch-over, no?
> 
> I don't think it's that much cleanup. One of my goals for x86-64 was 
> always to have it support modern x86 only; this means in particularly 
> most of the old bug workaround removed. With the APIC timer merging a 
> lot of that crap gets back in.

i dont think "clean, modern x86 code" will ever happen - x86_64 has and 
is going to have the exact same type of crap. And i'll say a weird thing 
now: that is a _blessing_. Why? Because this crap in question originates 
from the _diversity_ of the platform, and that is a much larger asset 
than the cost of the quirks can ever be!

What you suggest does not end up in "clean 64-bit code", it ends up in 
"a bit less crappy 64-bit code", plus a lot of unnecessary duplication 
of effort and duplication of code - which easily introduces more crap 
total than it gets rid of ...

The x86 architecture isnt fully analogous to a random piece of device 
hardware that evolves. It is more of a collector of random pieces of 
hardware that evolve independently, and as such it will always be 
exposed to human messups in a factorized way. "The pristine, clean 
architecture" is an utopia and it will never come until humans design 
hardware.

Under your scheme we'll end up with is two sets of code which share some 
of the workarounds and dont share some others. No, in fact we _already_ 
ended up with two sets of code that is crappy in different ways. We had 
countless cases of bugs fixed in i386 but not fixed in x86_64. (and vice 
versa) Sharing code for similar hardware is almost always good.

I think the PowerPC experience (although it is not a fully equivalent 
case) about them merging their 32-bit and 64-bit architectures was an 
overwhelmingly positive move, and x86 could learn a thing or two from 
that.

The only way to fight crappy hardware is to map it, to understand it and 
to design as cleanly in the presence of it as possible. Having two sets 
of code for the same thing hardly serves that purpose. In fact, having 
_more_ crappy hardware _forces_ us to do a cleaner design (up to a pain 
threshold).

	Ingo

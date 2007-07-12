Return-Path: <linux-kernel-owner+w=401wt.eu-S937636AbXGLAh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937636AbXGLAh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755929AbXGLAhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:37:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50571 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756469AbXGLAhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:37:16 -0400
Date: Thu, 12 Jul 2007 02:37:13 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
Message-ID: <20070712003713.GB26585@one.firstfloor.org>
References: <20070711174252.GA16793@elte.hu> <alpine.LFD.0.999.0707111438530.20061@woody.linux-foundation.org> <1184191488.12353.160.camel@chaos> <alpine.LFD.0.999.0707111518020.20061@woody.linux-foundation.org> <1184194219.12353.170.camel@chaos> <alpine.LFD.0.999.0707111558250.20061@woody.linux-foundation.org> <20070711233618.GD25510@one.firstfloor.org> <20070711235852.GA625@elte.hu> <20070712000720.GA26585@one.firstfloor.org> <20070712001807.GB1946@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070712001807.GB1946@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2007 at 02:18:07AM +0200, Ingo Molnar wrote:
> > > i dont think "clean, modern x86 code" will ever happen - x86_64 has 
> > > and is going to have the exact same type of crap. And i'll say a 
> > > weird thing
> > 
> > Yes, but it will be new crap, but no old crap anymore.
> > 
> > If you always pile the new crap on the old crap at some point the 
> > whole thing might fall over. 64bit was intended as a fresh start.
> 
> I think there's no such thing as a fresh start for a diverse 
> architecture - the ia64 failure has proven that. x86_64 CPUs still do 
> A20 emulation today (!). 

x86-64 doesn't care about a lot of x86 baggage and a lot of
things have been even obsoleted in the platform.

In practice the backwards compatibility on x86 isn't that
great either.  For example a significant number of new systems don't 
even work correctly in PIC mode anymore.

> We still have people running industrial boards 
> on real i386 DX CPUs, with the latest upstream kernel. 15 years ago an 

Yes, but those for example would be perfectly happy with an arch/i386
with all APIC and SMP code stripped out.

Only the few people who still run dual P5s might not, but
those could continue using old kernels.

But eventually I think that would be the right clean way: 

arch/i386 stripped down port for truly old systems like the embedded 386
upto 586 or early 686. No SMP or APIC.
arch/x86 supporting 32bit and 64bit for reasonably modern systems.
NUMAQ/Voyager/P5-SMP/visual workstation gone [frankly the user
base of those is too small to justify the code impact]

It's just quite ugly to get there and when you think through it
the actual advantages of such a setup it is likely not enough to 
justify the significant work to make it work.

Also I wouldn't have any idea how to regression test significant
changes to arch/i386 aimed at old systems. e.g. I don't think
the powerpc people actually tried to still support really
old systems where it is hard to do regression tests anymore,
only really supported platforms.

So while such a setup would be quite nice the practical
problems of getting there are nasty. Also I must admit I prefer
hacking on new code instead.

-Andi

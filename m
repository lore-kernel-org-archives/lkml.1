Return-Path: <linux-kernel-owner+w=401wt.eu-S1760378AbXJLJoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760378AbXJLJoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 05:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755482AbXJLJoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 05:44:30 -0400
Received: from ns.suse.de ([195.135.220.2]:45283 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204AbXJLJo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 05:44:29 -0400
Date: Fri, 12 Oct 2007 11:44:27 +0200
From: Nick Piggin <npiggin@suse.de>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Helge Hafting <helge.hafting@aitel.hist.no>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: [rfc][patch 3/3] x86: optimise barriers
Message-ID: <20071012094427.GC19237@wotan.suse.de>
References: <20071012082534.GB1962@ff.dom.local> <470F337A.9090205@aitel.hist.no> <20071012091213.GC1962@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071012091213.GC1962@ff.dom.local>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 11:12:13AM +0200, Jarek Poplawski wrote:
> On Fri, Oct 12, 2007 at 10:42:34AM +0200, Helge Hafting wrote:
> > Jarek Poplawski wrote:
> > >On 04-10-2007 07:23, Nick Piggin wrote:
> > >  
> > >>According to latest memory ordering specification documents from Intel and
> > >>AMD, both manufacturers are committed to in-order loads from cacheable 
> > >>memory
> > >>for the x86 architecture. Hence, smp_rmb() may be a simple barrier.
> > >>    
> > >...
> > >
> > >Great news!
> > >
> > >First it looks like a really great thing that it's revealed at last.
> > >But then... there is probably some confusion: did we have to use
> > >ineffective code for so long?
> > >  
> > You could have tried the optimization before, and
> > gotten better performance. But if without solid knowledge that
> > the optimization is _valid_, you risk having a kernel
> > that performs great but suffer the occational glitch and
> > therefore is unstable and crash the machine "now and then".
> > This sort of thing can't really be figured out by experimentation, because
> > the bad cases might happen only with some processors, some
> > combinations of memory/chipsets, or with some minimum
> > number of processors.  Such problems can be very hard
> > to find, especially considering that other plain bugs also
> > cause crashes.
> > 
> > Therefore, the "ineffective code" was used because it was
> > the only safe alternative. Now we know, so now we may optimize.
> 
> Sorry, I don't understand this logic at all. Since bad cases
> happen independently from any specifications and Intel doesn't
> take any legal responsibility for such information, it seems we
> should better still not optimize?

We already do in probably more critical and lible to be problematic
cases (notably, spin_unlock).

So unless there is reasonable information for us to believe this
will be a problem, IMO the best thing to do is stick with the
specs. Intel is pretty reasonable with documenting errata I think.

With memory barriers specifically, I'm sure we have many more bugs
in the kernel than AMD or Intel have in their chips ;)


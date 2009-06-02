Return-Path: <linux-kernel-owner+w=401wt.eu-S1756912AbZFBOYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912AbZFBOYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 10:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbZFBOYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 10:24:30 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:56251 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbZFBOY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:24:29 -0400
Date: Tue, 2 Jun 2009 10:18:02 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <npiggin@suse.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native
	kernels
Message-ID: <20090602141802.GC3914@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Avi Kivity <avi@redhat.com>, Arjan van de Ven <arjan@infradead.org>
References: <4A0B62F7.5030802@goop.org> <20090525091527.GA7535@elte.hu> <4A1C3805.7060404@goop.org> <20090528061702.GB6920@wotan.suse.de> <20090530102330.GC16913@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090530102330.GC16913@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Source-IP: abhmt007.oracle.com [141.146.116.16]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010202.4A25349E.00A5:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 30, 2009 at 12:23:30PM +0200, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > FWIW, we had to disable paravirt in our default SLES11 kernel. 
> > (admittedly this was before some of the recent improvements were 
> > made). But there are only so many 1% performance regressions you 
> > can introduce before customers won't upgrade (or vendors won't 
> > publish benchmarks with the new software).
> > 
> > But OTOH, almost any bit feature is going to cost performance. I don't
> > think this is something new (as noted with CONFIG_SECURITY). [...]
> 
> Yes in a way, but the difference is that:
> 
>  - i noted CONFIG_SECURITY as the _worst current example_. It is the
>    largest-overhead feature known to me in this area, and i 
>    benchmark the kernel a lot. CONFIG_PARAVIRT has _even more_
>    overhead so it takes the (dubious) top spot in this category.
> 
>  - CONFIG_SECURITY, in the distros where it's enabled (most of them) 
>    it is actually being relied on by the default user-space. It's 
>    being configured and every default install of the distro has a 
>    real (or at least perceived) advantage from it.
> 
> Not so with CONFIG_PARAVIRT. That feature is almost fully parasitic 
> to native environments: currently it brings no advantage on native 
> hardware _at all_ (and 95% of the users dont care about Xen).
> 
> Still it's impractical for a distro to disable it because adding a 
> separate kernel package has high costs too and PARAVIRT=y is needed 
> for the weird execution environment that Xen requires to run Linux 
> with acceptable speed.

I think all of the distros expect mainline to do a difficult balancing
act.  On the one hand we don't want any performance regressions, and on
the other hand, we need to be able to work with mainline to get the
major features that we're shipping and using every day in.

What we have here is a CONFIG_ that would be heavily used if it were
included.  It may be used as part of a separate kernel build, or it may
be used for a single kernel image.  Either way, this is something for
the distros to decide.  You're arguing to leave it out of mainline
because making a separate kernel package for it is too hard, but by
doing so forcing them to maintain the patches out of tree.  They still
have the same decision about the second package either way.

The xen developers are not dropping this code on mainline and running
away to spend the rest of their lives on the beach.  This is is a step
in long term development, and keeping it out of the kernel is making
testing and continued development much harder on the users.

I'm not suggesting we should take broken code, or that we should lower
standards just for xen.  But, expecting the xen developers to fix the 1%
hit on a very specific micro-benchmark is not a way to promote new
projects for the kernel, and it isn't a good way to convince people to
do continued development in mainline instead of in private trees.

Please reconsider.  Keeping these patches out is only making it harder
on the people that want to make them better.

-chris


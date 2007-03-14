Return-Path: <linux-kernel-owner+w=401wt.eu-S932469AbXCNS33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469AbXCNS33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 14:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932481AbXCNS32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 14:29:28 -0400
Received: from smtp.osdl.org ([65.172.181.24]:49336 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932469AbXCNS31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 14:29:27 -0400
Date: Wed, 14 Mar 2007 11:27:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Andi Kleen <andi@firstfloor.org>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
 Take 2
In-Reply-To: <20070314180933.GA12994@elte.hu>
Message-ID: <Pine.LNX.4.64.0703141120530.9690@woody.linux-foundation.org>
References: <20070314050819.536207642@goodmis.org> <p73slc8863r.fsf@bingen.suse.de>
 <20070314125330.GA13168@elte.hu> <Pine.LNX.4.64.0703140850250.9690@woody.linux-foundation.org>
 <20070314180933.GA12994@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Mar 2007, Ingo Molnar wrote:
> 
> then i decided to analyze the patches: currently they move 13452 lines 
> of code. i386 is 87847 lines of code, x86_64 is 40978 lines of code, a 
> total of 128825. That means we move about 10% of the code. Not 
> insignificant but not earth-shattering either. With alot more effort 
> (and testing) we could realistically go up to maybe 20% - but that's 
> still a bit low to spread out all the files, isnt it?

Well, I'd like it to be 100% _eventually_, and just unify the 
architectures.

We've now done that both for S/390 and POWER, and I think in both cases 
it's been a clear win. So it's not like this is even a radical idea.

The POWER architecture merge was actually done exactly the incremental 
way, one file or directory at a time, and seemed to work out fine.

So while I'd like 100%, I'd be happy to even just get started with the 
really obvious stuff. And the stuff that we *already* share certainly fall 
under that "really obvious" label.

> So i thought it's a better idea to continue with the current more 
> finegrained scheme of sharing some files between the architectures by 
> having arch/x86_64 be the 'main' repository, with i386 inheriting them 
> back, instead of spreading out the files?

That's really illogical, because historially, i386 was the main one, so 
you'd have to either:
 - have a really strange mix
OR
 - move files around just to share them.

So I'd much rather have just a totally new architecture, and hope that we 
can migrate more and more to it. Whether we ever get to the POWER 
situation where only some really odd-ball special cases are still using 
ppc or not, who knows? It might be, for example, that only the odder i386 
cases (ie the "non-PC" subarchitectures - Voyager, Summit, NUMAQ and the 
like) would stay in i386.

There really is almost nothing in i386 that shouldn't be supported on 
x86-64 too, unless it literally is the actual low-level asm files and vm86 
mode support (which in turn is best left as just a config option that 
would just *depend* on 32-bit, so even that could sanely be represented 
in a shared tree without any real downside at all).

			Linus

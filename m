Return-Path: <linux-kernel-owner+w=401wt.eu-S1759303AbYHUONW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759303AbYHUONW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 10:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754801AbYHUONO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 10:13:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:34525 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774AbYHUONN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 10:13:13 -0400
Subject: Re: [ANNOUNCE] mdb: Merkey's Linux Kernel Debugger 
	2.6.27-rc4	released
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: jmerkey@wolfmountaingroup.com, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>
In-Reply-To: <200808212337.38626.nickpiggin@yahoo.com.au>
References: <200808210250.m7L2obNX028353@wolfmountaingroup.com>
	 <48AD5A21.7020801@s5r6.in-berlin.de>
	 <43593.166.70.238.46.1219321595.squirrel@webmail.wolfmountaingroup.com>
	 <200808212337.38626.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Thu, 21 Aug 2008 16:09:59 +0200
Message-Id: <1219327799.8651.134.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-21 at 23:37 +1000, Nick Piggin wrote:
> On Thursday 21 August 2008 22:26, jmerkey@wolfmountaingroup.com wrote:
> 
> > I used the smp_wmb() functions.  I noted a couple of things.  a) some of
> > these macros just emit __asm__ __volatile__ into the code so why not just
> > say "volatile" to begin with
> 
> It is not the same as volatile type. What it does is tell the compiler
> to clobber all registers or temporaries. This something pretty well
> defined and hard to get wrong compared to volatile type.

Right, asm volatile () means that the asm may not be discarted. Very
different from the volatile type qualifier.

> > b) smp_wmb() in some cases worked and in 
> > other cases jut optimized away the global reference.
> 
> Linux barriers aren't going to force a load to be emitted, if it can be
> optimized away. If it optimized away a store, then I'd like to see a
> test case.

Not sure - I think all barrier clobber the full register and memory set.
So if you access a variable after a barrier it will have to issue a
load.

Are we talking about different things?

> > c) I can go back and 
> > break the code again by inserting them and building broken assembler d) I
> > ave been doing hardware and software design since the early 1980;s, I
> > invented SMP affinity scheduling, and yes, I understand barriers and this
> > concept of instruction score-boarding and optimization very well -- its
> > not an excuse for a busted C compiler.
> 
> The point is not whether it is possible to work with volatile types, but
> that we tend not to use them in Linux to deal with concurrency.
> 
> Also, barriers seem to work fine for everybody else, so I think it is
> likely you either aren't using them correctly, or have other bugs in the
> code.

Well, there is of course the third option, which is what Jeff claims,
that gcc is broken. But in that case we should have more problems
elsewhere too.



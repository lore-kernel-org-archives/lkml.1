Return-Path: <linux-kernel-owner+w=401wt.eu-S937577AbXHMXwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937577AbXHMXwF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 19:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763193AbXHMXvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 19:51:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42621 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761547AbXHMXvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 19:51:51 -0400
Date: Tue, 14 Aug 2007 01:51:49 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, sam@ravnborg.org,
       Andre Noll <maan@systemlinux.org>
Subject: Re: binutils trouble was Re: [1/2] 2.6.23-rc3: known regressions with patches
Message-ID: <20070813235149.GA9552@one.firstfloor.org>
References: <46C09C1A.7050706@googlemail.com> <20070813184204.GA6071@one.firstfloor.org> <6bffcb0e0708131324x29211ef5sd5154d44f0c2e79f@mail.gmail.com> <20070813205653.GA7069@one.firstfloor.org> <20070813212947.GK18945@stusta.de> <20070813224205.GA8760@one.firstfloor.org> <20070813225409.GN18945@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070813225409.GN18945@stusta.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2007 at 12:54:10AM +0200, Adrian Bunk wrote:
> On Tue, Aug 14, 2007 at 12:42:05AM +0200, Andi Kleen wrote:
> > On Mon, Aug 13, 2007 at 11:29:47PM +0200, Adrian Bunk wrote:
> > > Debian 4.0 has older ones, and all distributions released more than a 
> > > year ago for sure also have older ones (the required patch went into 
> > > binutils CVS on 2006-05-30 and 2.17.50.0.3 was released on 2006-07-15).
> > 
> > I have no problem on SUSE 10.0 (2.16.91.0.2-8) or SLES9 (2.15.90.0.1.1-32.10) 
> > which are both far older than a year.  Both produce good looking
> > vdso.sos.
> 
> OK sorry, then I misunderstood it and missing -Wl,-z,max-page-size=4096 
> -Wl,-z,common-page-size=4096 support is not the problem.

It might be. The change to default to 1MB pages happened 
some time ago and then the common-page-size options were
added some time after that.

I expect you'll get the obscenly large 1MB vdso if your
binutils happens to fall inside that time window, but before or 
after should be ok.

I haven't tested it, but in theory a 1MB vdso should
work (just waste a lot of memory and probably some CPU time)

I was pondering to add a build time test for this and fail
(not sure it's worth it)

But the header offset problem that actually broke
the compilation seemed to be something else, probably
some sort of bug.

> > sles8 (2.12.90.0.15; it was really one of the first production
> > binutils for x86-64) doesn't work out of the box (looks like as-instr doesn't 
> > work anymore and it has another assembler issue I'll fix) 
> > but with that workarounded it also builds a reasonble looking vdso
> 
> We had several reports of 2.12* not working (AFAIR also on i386), so 
> that's not a surprise.

Ah I didn't see those. I should test it more often perhaps.

I'll take a detailed look later, perhaps it's easy to fix.

> > Sam, can you please take a look at the as-instr issue? It seems
> > to succeed now when it should fail.
> > 
> > It would be useful if someone could find out which binutils versions
> > really not work.
> 
> If Andre is working under Debian 3.1 (as his gcc version indicates) he's 
> using 2.15, and together with your SLES9 test it seems the border is 
> somewhere between 2.15 and 2.16.

Could someone confirm? Then it could be documented.

-Andi

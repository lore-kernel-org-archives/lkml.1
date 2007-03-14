Return-Path: <linux-kernel-owner+w=401wt.eu-S1160996AbXCNKM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1160996AbXCNKM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 06:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161051AbXCNKM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 06:12:26 -0400
Received: from colin.muc.de ([193.149.48.1]:3126 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1160996AbXCNKMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 06:12:25 -0400
Date: 14 Mar 2007 11:12:23 +0100
Date: Wed, 14 Mar 2007 11:12:23 +0100
From: Andi Kleen <ak@muc.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [RFC/PATCH 00/59] Make common x86 arch area for i386 and x86_64
Message-ID: <20070314101223.GA88507@muc.de>
References: <1173820919.28042.3.camel@localhost.localdomain> <Pine.LNX.4.64.0703131432400.9690@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703131432400.9690@woody.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 02:39:33PM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 13 Mar 2007, Steven Rostedt wrote:
> > 
> > What we have currently is a bunch of hacks.  Seems that people can't make
> > up their mind to what to do.

I think they work fine. I don't like such large scale renaming -- they
are a pain for anybody with external patches and make regression hunting
later painful. And the gain is about zero as far as I can see.
It won't fix a single bug, just cause pain.

> 
> I don't mind the patches, but I'd be a lot happier if it also was a stated 
> intention to actually make it be buildable as "x86", the same way that the 
> separate 32-bit and 64-bit POWER architectures were merged into just one 
> architecture that could be built either way.

I've thought about it, but it would be a lot of work and regression
test on old hardware would be a nightmare. 

Besides still x86-64 is a lot cleaner than i386 and imho
easier to hack and with all the 32bit quirks readded it would probably 
become worse than current i386. The only good option would be 
a "modern 32bit only" but even that gets complicated quickly when
you consider all the corner cases. And a clean 32bit port wouldn't
cover enough hardware to be usable by distributions.

And I also don't have really time to work on that.

> The "32-bit code has legcay issues" thing that Andi complained about (eg 
> there's no guarantee of a HPET on 32-bit x86) doesn't really change the 

Most 64bit doesn't neither.

> fact that yes, we have to support those legacy issues *anyway*, and 64-bit 
> x86 certainly has its set of issues already too.

Yes :/  The more supported systems, the more junk.

The recent nmi watchdog issues are a good example. All just because
a few vendors write crappy AML/SMM code.

> We've started to notice that the i386 build gets broken now that most 
> developers tend to have newer CPU's and run mostly on x86-64 (and yes, 
> that's me too), and while I don't think unifying things will guarantee 
> that doesn't happen in the future, it will hopefully at least help make it 
> not get much *worse*.

Build test would be needed anyways, doesn't make much difference I guess.

> As it is, the build environment has to know to pass in "-m32/-m64" 
> anyway..

It already does that.

-Andi


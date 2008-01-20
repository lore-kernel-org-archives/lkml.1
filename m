Return-Path: <linux-kernel-owner+w=401wt.eu-S1756107AbYATFw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbYATFw0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 00:52:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbYATFwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 00:52:17 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55226 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbYATFwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 00:52:17 -0500
Date: Sun, 20 Jan 2008 06:55:44 +0100
From: Andi Kleen <andi@firstfloor.org>
To: David Newall <davidn@davidnewall.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH for mm] Remove iBCS support
Message-ID: <20080120055544.GB19861@one.firstfloor.org>
References: <20080119045918.GA12215@basil.nowhere.org> <4792B191.2060801@davidnewall.com> <20080120031153.GB6275@one.firstfloor.org> <4792D221.1010704@davidnewall.com> <20080120051822.GB19784@one.firstfloor.org> <4792DD22.4070902@davidnewall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4792DD22.4070902@davidnewall.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2008 at 04:03:22PM +1030, David Newall wrote:
> It's not necessarily that simple.  It might be for KFC and Dominoes, but
> for others, SCO is not the complete story.  Many legacy systems are
> written in COBOL, and must pay a per-seat licence for that on top of the
> per-seat licence for UNIX.  It is these systems that are most attracted
> towards SCO compatibility.

Well I'm sure if they migrate they can either recompile or pay someone
to forward port and apply and support the iBCS emulation patchkit.
And for that person it will be only a few minutes to readd these hunks.

However it doesn't make any sense to have all Linux systems ever
out there who can't even run these binaries without significantly
changing the kernel have carry the overhead of these unnecessary checks.

> 
> >>> But it does not make sense for all Linux kernels to always check for iBCS executables
> >>> when they don't have to code to run them anyways.
> >>>   
> >>>       
> >> I don't suppose you're suggesting this will make a big difference.  Even
> >> if every exec did nothing but immediately exit, it still wouldn't make
> >> much difference.
> >>     
> >
> > It's not a big difference, but why do unnecessary work on all 
> > Linux kernels? There are a lot of Linux machines out there and 
> > if all of them only do a little unnecessary work each fork()
> > over a year it adds up to really a lot of wasted cycles.
> >   
> 
> It still adds up to something that nobody can perceive, not even using a
> very fine stopwatch and counting over a period of years.

I'm not sure the cost is that low because they access one (or more likely
two) out of line data cache line for the two strings and kernel often runs
cache cold because userland tends to fill the caches and then a cache miss
can be actually hundreds of cycles, possibly multiplied by two.

But assuming there is no cache miss (which is a very conservative
assumption) and the strcmps cost 20 cycles and you got 1 million
2Ghz Linux systems out there doing 100k execs each day we're talking
about 1000 CPU seconds wasted each day. That should be certainly
measurable on most stop watches.

> 
> > Especially since the few people who might really
> > need it can easily readd it.
> >   
> No.  Very few people can add it, easily or otherwise.

They have to patch the kernel in non trivial ways anyways because they
would need to patch in the whole old iBCS emulation layer.

(e.g. the old default ldt code which was for iBCS was just dropped --
strangely you didn't raise your voice against that)

>  Perhaps KFC could
> employ somebody to add it, but they'd more likely be able to convert
> their entire software stack instead.  The paint shops and mechanics of
> the world would have little chance of that.

Sorry, but I don't think you know what you're talking about here.

-Andi


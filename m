Return-Path: <linux-kernel-owner+w=401wt.eu-S1757705AbYFBIAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705AbYFBIAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 04:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbYFBH75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 03:59:57 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:40175 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbYFBH74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 03:59:56 -0400
Date: Mon, 2 Jun 2008 10:59:37 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
Subject: Re: initialization of static per-cpu variables
Message-ID: <20080602075937.GA29836@cs181133002.pp.htv.fi>
References: <19f34abd0805211128r29fa437fm9e9e4c3d3c196f62@mail.gmail.com> <200805221820.07290.rusty@rustcorp.com.au> <20080523142904.GB28257@cs181133002.pp.htv.fi> <200805252035.24535.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200805252035.24535.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 25, 2008 at 08:35:24PM +1000, Rusty Russell wrote:
> On Saturday 24 May 2008 00:29:04 Adrian Bunk wrote:
> > On Thu, May 22, 2008 at 06:20:06PM +1000, Rusty Russell wrote:
> > > Yep, it was an old toolchain used by Sparc: DaveM found this one.  As you
> > > say, it's ancient: I'm happy to queue a cleanup patch now everyone is on
> > > a modern compiler.
> >
> > The commit says:
> >
> >     GCC3.1 apparently gets confused about uninitialized sections
> >
> > We do still support gcc 3.2 (which is the same as 3.1 except for a C++
> > ABI change) as a compiler for the kernel.
> 
> Adrian, that's a little silly.  There are obviously bug fixes in 3.2 over 
> 3.1.0.

I've checked the announcements of 3.1.1 and 3.2, and at least for me 
nothing looked like it would fix this bug.

> Noone has complained about the introduction of multiple other cases 
> which would screw things up if they experienced this bug.

I doubt there is any serious userbase for gcc 3.2 left.

But your "now everyone is on a modern compiler" does not match what we 
announce as supported compiler versions for the kernel.

If you have a good reason for pushing the minimum required gcc version 
for compiling the kernel to 3.3 or 3.4 [1] you have my full support, but 
as long as we officially support gcc 3.2 we should try to break as few 
as possible - especially since it will take time until anyone will run 
into any breakage.

> Finally, it's a sparc64 problem and DaveM acked already.

Was it a sparc64 problem or a generic problem DaveM happened to run into 
on sparc?

> That's half the userbase!

sparc64 isn't that unpopular...

> Cheers,
> Rusty.

Sorry if I'm sounding overly pedantic, but I want that what we try as 
good as possible that what we announce as being supported also works 
(even if this results in several workarounds shipped).

cu
Adrian

[1] gcc 3.4 still has a serious userbase at least in ARM country, so you
    won't be able to drop support for it

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


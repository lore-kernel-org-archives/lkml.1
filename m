Return-Path: <linux-kernel-owner+w=401wt.eu-S1751778AbXHUTzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778AbXHUTzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 15:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbXHUTza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 15:55:30 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:53439 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750716AbXHUTz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 15:55:29 -0400
Date: Tue, 21 Aug 2007 21:54:33 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andi Kleen <ak@suse.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jarek Poplawski <jarkao2@o2.pl>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: RFC: drop support for gcc < 4.0
Message-ID: <20070821195433.GE30705@stusta.de>
References: <20070821132038.GA22254@ff.dom.local> <20070821093103.3c097d4a.randy.dunlap@oracle.com> <20070821173550.GC30705@stusta.de> <20070821191959.GC2642@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070821191959.GC2642@bingen.suse.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 09:19:59PM +0200, Andi Kleen wrote:
> On Tue, Aug 21, 2007 at 07:35:50PM +0200, Adrian Bunk wrote:
> > Obviously a gcc <= 3.4 [1], and therefore no unit-at-a-time.
> 
> Actually there are widely used 3.3 variants that support unit-at-a-time
> (e.g. 3.3-hammer which was shipped by several distributions for some time)
> 
> There are still a lot of systems around which use gcc 3.3 (less so with
> 3.4). Unless there's a major bug that is hard to work around I would
> prefer to keep it supported.
> 
> Bogus warnings should be relatively harmless.

How many kernel developers use such old gcc versions?

And how many people notice the valid modpost warnings that can indicate
a runtime Oops?

> > And it's becoming a real maintainance problem that not only this problem 
> > but also other problems like some section mismatches [2] are only 
> > present without unit-at-a-time.
> 
> The unit-at-a-time output order is not defined, so even if it works
> with the current compiler a compiler change might still trigger
> that problem. So it would be better to fix those anyways.

The example [2] from my email is guaranteed to not be a problem with 
unit-at-a-time (as long as unit-at-a-time implies 
inline-functions-called-once - and that's although theoretically 
possible quite unlikely to change in practice).

This example is for a bug that should be fixed, but my point is the
maintainability, IOW: issues with older compilers might not be 
discovered and fixed before they go into a stable kernel.

We currently support 6 different stable gcc release series plus heavily 
modified vendor branches like 3.3-hammer. We can discuss whether it is 
now already the right time, and where to make the cut, but medium-term 
we must reduce the number of supported compilers.

> -Andi

cu
Adrian

[2] example: static __init function with exactly one caller, and this
             caller is non-__init

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


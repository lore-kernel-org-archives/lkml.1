Return-Path: <linux-kernel-owner+w=401wt.eu-S1755946AbYJFWCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbYJFWCZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 18:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbYJFWCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 18:02:17 -0400
Received: from smtp.outflux.net ([198.145.64.163]:42568 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752737AbYJFWCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 18:02:17 -0400
Date: Mon, 6 Oct 2008 15:01:01 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       Jakub Jelinek <jakub@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       libc-alpha@sourceware.org
Subject: Re: [PATCH] ELF: implement AT_RANDOM for future glibc use
Message-ID: <20081006220101.GK10357@outflux.net>
References: <20081001201116.GD12527@outflux.net> <48E3EFD6.2010704@redhat.com> <20081001215657.GH12527@outflux.net> <20081001220948.GC32107@sunsite.ms.mff.cuni.cz> <20081001222706.68E7E1544B4@magilla.localdomain> <20081003001616.GN10632@outflux.net> <87ej2untze.fsf@basil.nowhere.org> <20081006175038.GF10357@outflux.net> <20081006192641.GI3180@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081006192641.GI3180@one.firstfloor.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2008 at 09:26:41PM +0200, Andi Kleen wrote:
> > We're already using get_random* for stack, heap, and brk.  Also,
> > get_random* uses the nonblocking pool, so this is the same as if userspace
> > had tried to pull bytes out of /dev/urandom, which (as I understand it)
> 
> Yes exactly that's the problem. Think about it: do you really 
> need the same cryptographic strength for your mmap placement
> as you need for your SSL session keys?

Well, my ultimate intention was to put this into the stack protector
guard value, so I did want something as strong as the ASLR.

> Since so many systems have poor entropy input /dev/urandom has generally 
> replaced /dev/random for near all cryptographic software, so it's
> just the new black.

If I understand, you're suggesting that ASLR doesn't need to be strong,
and that there should be something besides get_random* used to produce
these values?  If that's true, that has nothing to do with the patch
I've suggested (i.e. we have an immediate need and I'm solving it using
the current available solutions.)  (Additionally, I think ASLR should be
as strong as possible.)

If instead, you're saying that the use of urandom has generally caused
a drain on entropy, and ASLR is suffering, then does it matter that a
few more bytes are used for the stack guard?  I'm just not clear what
direction you're trying to aim my patch.  :)

I'd really love to see this solved.  My goal is to get a mainline glibc
patch for a low-cost randomized stack guard value.  Ulrich has a set of
requirements, and it sounds like there's a growing new set of requirements
from the kernel folks.  What's needed to sort this out?

-Kees

-- 
Kees Cook
Ubuntu Security Team

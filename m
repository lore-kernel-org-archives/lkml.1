Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbYJFTUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbYJFTUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 15:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbYJFTUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 15:20:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43051 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbYJFTUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 15:20:40 -0400
Date: Mon, 6 Oct 2008 21:26:41 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Kees Cook <kees.cook@canonical.com>
Cc: Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org, Jakub Jelinek <jakub@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>, libc-alpha@sourceware.org
Subject: Re: [PATCH] ELF: implement AT_RANDOM for future glibc use
Message-ID: <20081006192641.GI3180@one.firstfloor.org>
References: <20081001201116.GD12527@outflux.net> <48E3EFD6.2010704@redhat.com> <20081001215657.GH12527@outflux.net> <20081001220948.GC32107@sunsite.ms.mff.cuni.cz> <20081001222706.68E7E1544B4@magilla.localdomain> <20081003001616.GN10632@outflux.net> <87ej2untze.fsf@basil.nowhere.org> <20081006175038.GF10357@outflux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081006175038.GF10357@outflux.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We're already using get_random* for stack, heap, and brk.  Also,
> get_random* uses the nonblocking pool, so this is the same as if userspace
> had tried to pull bytes out of /dev/urandom, which (as I understand it)

Yes exactly that's the problem. Think about it: do you really 
need the same cryptographic strength for your mmap placement
as you need for your SSL session keys?

And if you need true entropy for your session keys do you
still get it when it was all used for low security 
purposes first?

> > What you should instead do is to initialize some other cryptographic RNG
> > regularly and use the output of that.
> 
> Can you give me some examples of this?  I thought the nonblocking
> entropy pool was specifically for this purpose?

It's definitely not a "general purpose random number generator"
or even a "general purpose secure random number generator"

Since so many systems have poor entropy input /dev/urandom has generally 
replaced /dev/random for near all cryptographic software, so it's
just the new black.

-Andi

-- 
ak@linux.intel.com

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756159AbXJ2DEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbXJ2DEi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 23:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbXJ2DEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 23:04:30 -0400
Received: from waste.org ([66.93.16.53]:50810 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbXJ2DEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 23:04:30 -0400
Date: Sun, 28 Oct 2007 22:03:52 -0500
From: Matt Mackall <mpm@selenic.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Matthew Wilcox <matthew@wil.cx>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 1/4] stringbuf: A string buffer implementation
Message-ID: <20071029030352.GC19691@waste.org>
References: <20071024195847.GE27248@parisc-linux.org> <20071026115727.GR27248@parisc-linux.org> <20071026205714.GQ17536@waste.org> <200710272009.31430.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710272009.31430.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2007 at 08:09:30PM +1000, Rusty Russell wrote:
> On Saturday 27 October 2007 06:57:14 Matt Mackall wrote:
> > Well I expect once you start letting people easily build strings by
> > concatenation, you'll very shortly afterwards have people using them
> > in loops.  And having hidden O(n^2) behavior in there is a little sad, 
> > even though n will tend to be small and well-bounded. If we can do
> > something simple to avoid it, we should.
> 
> Hi Matt,
> 
>         I avoid typing even a single character of optimization until it's 
> justified.  This is partially a reaction against the machoptimization 
> tendencies of many kernel programmers, but it's mainly a concern at the 
> kernel's complexity creep.
> 
> Meanwhile, of course, I've now spent far too long analyzing this :)
> 
> Building a 1000 byte string 1 byte at a time involves 6 reallocs (SLAB) or 10 
> reallocs (SLUB).  Frankly, that's good enough without an explicit alloc 
> length field (better in some ways).

And on SLOB, which doesn't have those bloaty power-of-2 constraints?
Looks like ~500 reallocs, including 250000 bytes of memcpy. Ouch!

SLAB and SLUB (accidentally) internalize the optimization that I'm
proposing: grow the string by a constant factor at each step. Failing
to do that makes the behavior dismal.

-- 
Mathematics is the supreme nostalgia of our time.

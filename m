Return-Path: <linux-kernel-owner+w=401wt.eu-S1752412AbYLDAdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbYLDAdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 19:33:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbYLDAcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 19:32:42 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40908 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbYLDAcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 19:32:41 -0500
Date: Thu, 4 Dec 2008 00:31:44 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>, nico@cam.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Yet more ARM breakage in linux-next
Message-ID: <20081204003143.GA21350@flint.arm.linux.org.uk>
References: <20081203192905.GA12502@flint.arm.linux.org.uk> <20081203124109.79f8f15b.akpm@linux-foundation.org> <200812040952.44957.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812040952.44957.rusty@rustcorp.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2008 at 09:52:44AM +1030, Rusty Russell wrote:
> On Thursday 04 December 2008 07:11:09 Andrew Morton wrote:
> > On Wed, 3 Dec 2008 19:29:05 +0000
> >
> > Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> > > This seems to be causing lots of ARM breakage:
> > >
> > > lib/find_next_bit.c:183: error: implicit declaration of function '__fls'
> > >
> > > Whoever's responsible,
> >
> > git-blame?
> 
> It's me.  Turns out sparc, avr32 and arm all don't define __fls in their
> asm/bitops.h, and I'm the first one to use it in generic code.
> 
> But as I prepared this patch, I note that the armv5 __fls/fls is wrong:

__fls is wrong.

> 
>   /* Implement fls() in C so that 64-bit args are suitably truncated */
>   static inline int fls(int x)
>   {
>       return __fls(x);
>   }
> 
> __fls(x) returns a bit number (0-31).  fls() returns 0 or bitnumber+1.

The 'clz' instruction returns 32 for a zero input, or (31 - most significant
set bit) - which seems to work for fls() but not __fls().

Sending to Nicolas.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

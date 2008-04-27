Return-Path: <linux-kernel-owner+w=401wt.eu-S1763088AbYD0SAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763088AbYD0SAl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 14:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758958AbYD0SAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 14:00:17 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:38297 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757754AbYD0SAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 14:00:15 -0400
Date: Sun, 27 Apr 2008 20:59:47 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH] prepare kconfig inline optimization for all
	architectures
Message-ID: <20080427175947.GC2252@cs181133002.pp.htv.fi>
References: <20080427105100.GA14795@uranus.ravnborg.org> <20080427113158.GY2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804271002360.2896@woody.linux-foundation.org> <20080427172235.GA2252@cs181133002.pp.htv.fi> <20080427174055.GS14990@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080427174055.GS14990@parisc-linux.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 11:40:56AM -0600, Matthew Wilcox wrote:
> On Sun, Apr 27, 2008 at 08:22:35PM +0300, Adrian Bunk wrote:
> > I'm looking at it from a different angle, all code in the kernel should 
> > follow the following rules [1]:
> > - no functions in .c files should be marked inline
> > - all functions in headers should be static inline
> > - all functions in headers should either be very small or collapse
> >   to become very small after inlining
> > 
> > I can simply not see any usecase for a non-forced inline in the kernel,
> > and fixing the kernel should give a superset of the space savings of 
> > this "inline optimization".
> 
> Here's a good counterexample: kernel/mutex.c.
> 
> __mutex_lock_common wants to be inlined into __mutex_lock_*_slowpath.

If we really want to force gcc to emit 6 copies of this not so small 
function then Ingo's commit in Linus' tree has already broken it on x86.

> and *_slowpath *shouldn't* be inlined into mutex_lock_*.

"noinline" is nothing anyone wants to change.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


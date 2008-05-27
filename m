Return-Path: <linux-kernel-owner+w=401wt.eu-S1759456AbYE0WaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456AbYE0WaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 18:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756749AbYE0WaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 18:30:11 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:40173 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756686AbYE0WaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 18:30:09 -0400
Date: Wed, 28 May 2008 01:27:21 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: break mutual header inclusion
Message-ID: <20080527222721.GE11310@cs181133002.pp.htv.fi>
References: <20080527204926.GA15020@damson.getinternet.no> <20080527213819.GC11310@cs181133002.pp.htv.fi> <19f34abd0805271501p5eb4916h5dd37c18be8d21fb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <19f34abd0805271501p5eb4916h5dd37c18be8d21fb@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2008 at 12:01:02AM +0200, Vegard Nossum wrote:
> Hi!
> 
> On Tue, May 27, 2008 at 11:38 PM, Adrian Bunk <bunk@kernel.org> wrote:
> > On Tue, May 27, 2008 at 10:49:26PM +0200, Vegard Nossum wrote:
> >> Hi,
> >>
> >> What do you think about this? The new file (vm86_mask.h) could actually be
> >> embedded completely in processor-flags.h, but I went for what I believe is
> >> the safer approach.
> >
> > Breaking the mutual header inclusion is appreciated, but some comments
> > are below.
> 
> [...]
> 
> >> -/* the DS BTS struct is used for ptrace as well */
> >> -#include <asm/ds.h>
> >> -
> >>  struct task_struct;
> >>
> >>  extern void ptrace_bts_take_timestamp(struct task_struct *, enum bts_qualifier);
> >
> > Moving #include's out of an #ifdef __KERNEL__ can (and does here) break
> > our userspace headers.
> >
> > Running "make headers_check" after touching anything under include/ is
> > recommended since it catches these problems.
> >
> 
> Ah, that's true. My mistake.
> 
>   CHECK   include/asm/ptrace.h
> [...]/usr/include/asm/ptrace.h requires asm/ds.h, which does not exist
> in exported headers
> 
> What do you reckon is better here, to put #ifdef __KERNEL__ around the
> whole of ds.h and export it, or put #ifdef __KERNEL__ around the
> #include in ptrace.h? It feels wasteful to put it around the whole
> ds.h, since what is the point in exporting an empty file? On the other
> hand, it makes much more sense to put it there than in the "caller" in
> order to avoid the duplication of #ifdef __KERNEL__. So unless you
> prefer otherwise, I will choose the former (to export ds.h as well).

Our userspace headers are an API, and offering empty previsously 
unexported headers to userspace sounds like the worse choice to me.

Additionally, asm/segment.h (and asm/vm86_mask.h) have the same problem.

> I hope you agree with the idea of moving the #include line to the top
> of the file, however?

For me it looks good.

> Thanks for the tip, that is very useful. I didn't realize I should use
> that and I'm sorry for wasting your time with the first attempt :-(

No problem, and I don't consider it a waste of time.

>...
> Thanks for the help :-)
> 
> Vegard

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


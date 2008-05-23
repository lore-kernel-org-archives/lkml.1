Return-Path: <linux-kernel-owner+w=401wt.eu-S1757563AbYEWObi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563AbYEWObi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 10:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbYEWOba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 10:31:30 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:39147 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbYEWOb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 10:31:29 -0400
Date: Fri, 23 May 2008 17:29:04 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
Subject: Re: initialization of static per-cpu variables
Message-ID: <20080523142904.GB28257@cs181133002.pp.htv.fi>
References: <19f34abd0805211128r29fa437fm9e9e4c3d3c196f62@mail.gmail.com> <200805221820.07290.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200805221820.07290.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 06:20:06PM +1000, Rusty Russell wrote:
> On Thursday 22 May 2008 04:28:02 Vegard Nossum wrote:
> > Hi,
> >
> > I encountered this comment in kernel/softirq.c:
> >
> > /* Some compilers disobey section attribute on statics when not
> >    initialized -- RR */
> > static DEFINE_PER_CPU(struct tasklet_head, tasklet_vec) = { NULL };
> > static DEFINE_PER_CPU(struct tasklet_head, tasklet_hi_vec) = { NULL };
> >
> > So I assume it's the combination of static and whatever section
> > DFINE_PER_CPU puts the variable in which is the problem.
> >
> > However, there's a LOT of these "static DEFINE_PER_CPU" without any
> > initializer in the rest of the code, e.g.:
> 
> Yep, it was an old toolchain used by Sparc: DaveM found this one.  As you say, 
> it's ancient: I'm happy to queue a cleanup patch now everyone is on a modern 
> compiler.

The commit says:

    [PATCH] softirq.c per_cpu fix
    
    GCC3.1 apparently gets confused about uninitialized sections


We do still support gcc 3.2 (which is the same as 3.1 except for a C++ 
ABI change) as a compiler for the kernel.


> Thanks,
> Rusty.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


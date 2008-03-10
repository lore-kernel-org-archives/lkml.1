Return-Path: <linux-kernel-owner+w=401wt.eu-S1754582AbYCJTii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbYCJTii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 15:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbYCJTia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 15:38:30 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:45998 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618AbYCJTi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 15:38:29 -0400
Date: Mon, 10 Mar 2008 21:38:04 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT pull] time(r) fixes for .25
Message-ID: <20080310193804.GB5727@cs181133002.pp.htv.fi>
References: <alpine.LFD.1.00.0803090857480.3099@apollo.tec.linutronix.de> <20080310164407.GC5040@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080310164407.GC5040@ucw.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2008 at 05:44:07PM +0100, Pavel Machek wrote:
> 
> > @@ -174,6 +174,10 @@ static inline void timespec_add_ns(struct timespec *a, u64 ns)
> >  {
> >  	ns += a->tv_nsec;
> >  	while(unlikely(ns >= NSEC_PER_SEC)) {
> > +		/* The following asm() prevents the compiler from
> > +		 * optimising this loop into a modulo operation.  */
> > +		asm("" : "+r"(ns));
> > +
> 
> optimizing -> pessimizing or "optimizing" or explain that "optimized"
> version is slower than real version?
>...

In this case it's actually gcc's fault to ignore the unlikely(), so the 
optimization would have made the code slower at least on some 
architectures.

But more important, it resulted in build errors on i386 and some other 
32bit architectures.

The underlying (and unresolved) issue is that gcc expects libgcc to be 
available while the kernel does not link with libgcc on many platforms.

> 							Pavel

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


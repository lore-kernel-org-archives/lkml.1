Return-Path: <linux-kernel-owner+w=401wt.eu-S1756555AbXL2IHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555AbXL2IHp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 03:07:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754770AbXL2IHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 03:07:35 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:36530 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756246AbXL2IHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 03:07:30 -0500
Date: Sat, 29 Dec 2007 10:07:16 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andi Kleen <ak@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: unify x86 Makefile(s)
Message-ID: <20071229080716.GF9105@does.not.exist>
References: <20071228212341.GA6939@uranus.ravnborg.org> <20071228221324.GA9105@does.not.exist> <200712290314.23567.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200712290314.23567.ak@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 29, 2007 at 03:14:23AM +0100, Andi Kleen wrote:
> On Friday 28 December 2007 23:13:24 Adrian Bunk wrote:
> > On Fri, Dec 28, 2007 at 10:23:41PM +0100, Sam Ravnborg wrote:
> > >...
> > > Noteworthy remarks on the unification:
> > >...
> > > - -funit-at-a-time should be easy to unify but it looks like we have a bug
> > >   in 32 bit. We only enable -funit-at-a-time for gcc less than 0400 if they
> > >   support it
> > 
> > No, we _dis_able it on 32bit if a gcc < 4.0 supports it.
> > 
> > > (and I recall it is a gcc 4.00 feature). [-lt -> -gt]
> > >...
> > 
> > unit-at-a-time was introduced in upstream gcc 3.4 and backported to some 
> > popular 3.3 x86_64 branch.
> > 
> > i386 and x86_64 go in exactly opposite directions regarding when to use 
> > unit-at-a-time, but that was intentional and we should keep it that way.
> 
> i386 disabled it because there were claims that it increased stack size
> too much, but I haven't seen any real evidence for that. That is why I never
> added it to x86-64. On the other hand it tends to shrink text size considerably.
> 
> I think it should be reevaluated and enabled by default on i386 again.
> 
> BTW there is a patch pending for gcc 4.3+ that prevents optimizations
> that increase stack size unduly. Not sure it has been added there yet,
> but that was the right fix for these problems anyways.

We are talking only about gcc 3.4 on i386 - for gcc >= 4.0 or gcc 3.4 on 
other architectures we always leave unit-at-a-time enabled.

Considering that:
- there were some problems with gcc 3.4 and i386 4kB stacks,
- gcc 3.4 is ancient (and therefore nothing people who want the fastest 
  or smallest code should use) and
- the number of i386 gcc 3.4 users is quite low today
we should simply leave it as it is, and all this will anyway 
automatically vanish when we'll drop support for gcc < 4.0 a few years 
from now.

> -Andi

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


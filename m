Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbZHWJTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbZHWJTK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 05:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755918AbZHWJTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 05:19:09 -0400
Received: from www.tglx.de ([62.245.132.106]:40093 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755907AbZHWJTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 05:19:08 -0400
Date: Sun, 23 Aug 2009 11:15:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>, x86 team <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Pan Jacob jun <jacob.jun.pan@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC patch 00/32] x86: Refactor the setup code to provide a base
 for embedded platforms
In-Reply-To: <20090822105726.GB30434@elte.hu>
Message-ID: <alpine.LFD.2.00.0908231110480.1769@localhost.localdomain>
References: <20090821205008.518392436@linutronix.de> <20090822105726.GB30434@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Aug 2009, Ingo Molnar wrote:
> * Thomas Gleixner <tglx@linutronix.de> wrote:
> >  47 files changed, 622 insertions(+), 808 deletions(-)
> 
> Very nice!
> 
> One small detail, before we spread out these patches. While looking 
> at the patches i noticed that at places our new x86 init namespace 
> is very long:
> 
> > +     platform_setup.timers.setup_percpu_clockev = platform_setup_noop;
> > +     platform_cpuhotplug_setup.setup_percpu_clockev = platform_setup_noop;
> > +
> 
> I think we should shorten the name-space a bit - we'll use it in a 
> _lot_ of places, so the shorter, the better and the easier to use. 
> 
> I'd suggest something like:
> 
>      x86_init.timers.init_percpu_clockev = x86_init_noop;
>      x86_cpuhotplug_init.init_percpu_clockev = x86_init_noop;
> 
> ( This also has the advantage that 'init' is the general term we use 
>   for kernel structure initialization - 'setup' is a more 
>   restrictive term we use related to bootloading, most of the time. )

Fair enough.
 
> An even shorter form would be to use 'x86' as a general template for 
> platform details:
> 
>      x86.timers.init_percpu_ce = x86_init_noop;
>      x86_cpuhotplug.init_percpu_ce = x86_init_noop;
> 
> this is even shorter, plus it allows us to put runtime details into 
> this structure as well. Note that the fields themselves 

We should have a separate struct for runtime details otherwise we need
to keep the full init stuff around forever instead of freeing
it. That's why I already have that separate cpuhotplug struct.

> (init_percpu_clockev) already signal the 'init' property 
> sufficiently. Plus 'ce' is an existing, well-known abbreviation for 
> clockevents. (but 'clockev' would be good too - i might be pushing 
> it)

Yes you do. Next you suggest to have x86_i.pcpu_ce :)
 
Thanks,

	tglx

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754988AbZEKOIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988AbZEKOIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 10:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbZEKOIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 10:08:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57483 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbZEKOIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 10:08:10 -0400
Date: Mon, 11 May 2009 16:07:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC][git-pull -tip] x86: cpu_debug and cpufeature patches
Message-ID: <20090511140754.GB6175@elte.hu>
References: <1240217428.3083.2.camel@ht.satnam> <20090420111619.GE6670@elte.hu> <1240933437.3074.4.camel@ht.satnam> <20090428172828.GA15392@elte.hu> <1240977176.3028.0.camel@ht.satnam> <20090429105021.GG2373@elte.hu> <1241007294.3061.12.camel@ht.satnam> <20090503090908.GA23183@elte.hu> <1241603841.3322.3.camel@localhost.localdomain> <1241894177.8978.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241894177.8978.3.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On Wed, 2009-05-06 at 15:27 +0530, Jaswinder Singh Rajput wrote:
> > On Sun, 2009-05-03 at 11:09 +0200, Ingo Molnar wrote:
> > > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > > 
> > > > We can use cpu_has tests for unknown processors but 'cpu model' is 
> > > > accurate and cover all range.
> > > > 
> > > > cpu_has does not cover following registers:
> > > > 1. platform
> > > > 2. poweron
> > > > 3. control
> > > > 4. bios
> > > > 5. freq
> > > > 6. cache
> > > > 7. misc
> > > > 8. base
> > > > 9. ver
> > > > 10. conf
> > > 
> > > Firstly these should be added to cpufeatures.h.
> > > 
> > > Then add cpu_has_xxx() accessors need to be added for them and 
> > > during CPU init they have to be properly set, via two methods:
> > > 
> > >  - via CPUID (where this is possible+specified in docs)
> > >  - or via "later than CPU version X" checks
> > > 
> > > Your cpu-model table is equivalent to an explicitly enumerated CPU 
> > > version check, but this breaks every time a new CPU comes out. 
> > > 
> > > "Later than" or CPUID based feature bits are a lot more future-proof 
> > > - we only have to add support for new _features_ (and quirks, 
> > > occasionally), and dont have to maintain that full table of specific 
> > > models to specific features mapping tables.
> > > 
> > 
> > I add some cpufeatures for review, I am still adding rest of them.
> > 
> > The following changes since commit c861b6f8ea9b39699f4a35bbf7dc06eb937a34de:
> >   Ingo Molnar (1):
> >         Merge branch 'irq/urgent'
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git master
> 
> 
> I added some more patches for the review.
> 
> The following changes since commit c861b6f8ea9b39699f4a35bbf7dc06eb937a34de:
>   Ingo Molnar (1):
>         Merge branch 'irq/urgent'
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git master
> 
> Jaswinder Singh Rajput (17):
>       x86: cpu_debug.c avoid storing cpu_descriptors locally
>       x86: cpu_debug update Kconfig entry
>       x86: cpu_debug.c remove unwanted header files
>       x86: Add cpufeature for Processor Name
>       x86: Add cpufeatures for Advanced Power Management
>       x86: Add cpufeature for Microcode update
>       x86: Add cpufeature for Cache MSRs
>       x86: Add cpufeature for Hard and Soft Poweron configuration
>       x86: Add cpufeature for Scaleable bus speed
>       x86: Add cpufeature for Miscellaneous Features
>       x86: Add cpufeature for Platform feature
>       x86: Add cpufeature for Hardware configuration
>       x86: Add cpufeature for System configuration
>       x86: Add cpufeature for System management mode (SMM)
>       x86: Add cpufeature for MM configuration
>       x86: Add cpufeature for Bus configuration
>       x86: cpu_debug replace cpu_modelflag with cpu_has
> 
>  arch/x86/Kconfig                  |   11 +-
>  arch/x86/include/asm/cpu_debug.h  |  169 +-----------
>  arch/x86/include/asm/cpufeature.h |   33 ++-
>  arch/x86/include/asm/processor.h  |    1 -
>  arch/x86/kernel/cpu/Makefile      |    2 +-
>  arch/x86/kernel/cpu/amd.c         |   33 ++-
>  arch/x86/kernel/cpu/common.c      |   17 +-
>  arch/x86/kernel/cpu/cpu_debug.c   |  542 ++++++++++++-------------------------
>  arch/x86/kernel/cpu/intel.c       |   93 ++++++-
>  arch/x86/kernel/cpu/powerflags.c  |   20 --
>  arch/x86/kernel/cpu/proc.c        |   14 -
>  arch/x86/kernel/microcode_amd.c   |    3 +
>  arch/x86/kernel/microcode_intel.c |    3 +
>  13 files changed, 339 insertions(+), 602 deletions(-)
>  delete mode 100644 arch/x86/kernel/cpu/powerflags.c

ok, this removes a ton of code, so it's a big step forward.

Logistics-wise, it would be nice to separate out the CPU features 
bits, and submit them in a separate thread, right now. Please base 
that branch on the latest version of tip:x86/cpufeature.

That is where most of the discussion/tweaking will be. The 
arch/x86/kernel/cpu/cpu_debug.c bits then will be obvious cleanups 
and obvious enhancements.

Thanks,

	Ingo

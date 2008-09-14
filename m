Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbYINOWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbYINOWs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 10:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472AbYINOWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 10:22:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47771 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091AbYINOWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 10:22:39 -0400
Date: Sun, 14 Sep 2008 16:22:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>, arjan@linux.intel.com,
       tglx@linutronix.de, hpa@zytor.com, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [patch 1/2] x86: track memtype for RAM in page struct
Message-ID: <20080914142213.GA28162@elte.hu>
References: <20080913000003.732756000@linux-os.sc.intel.com> <20080913000051.819383000@linux-os.sc.intel.com> <48CBF25B.5030107@goop.org> <20080914132952.GC554@elte.hu> <48CD1D1E.1050906@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48CD1D1E.1050906@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> > it should be defined in include/asm-x86/page.h though, not in 
> > page-flags.h - other architectures are using this flag for other 
> > purposes.
> 
> No, other shared-use flags are all defined in page-flags.h:
> 
> enum pageflags {
> [...]
> 	__NR_PAGEFLAGS,
> 
> 	/* Filesystems */
> 	PG_checked = PG_owner_priv_1,
> 
> 	/* XEN */
> 	PG_pinned = PG_owner_priv_1,
> 	PG_savepinned = PG_dirty,
> 
> 	/* SLOB */
> 	PG_slob_page = PG_active,
> 	PG_slob_free = PG_private,
> 
> 	/* SLUB */
> 	PG_slub_frozen = PG_active,
> 	PG_slub_debug = PG_error,
> };
> 
> 
> We could #ifdef CONFIG_X86 just to make it clear we're talking about a 
> specific X86 usage.  But page-flags.h does seem to have become the 
> central authority on all struct page flags usage.

well, in case of the PG_arch_* flags, they are all defined in 
architecture files:

./include/asm-parisc/pgtable.h:#define PG_dcache_dirty         PG_arch_1
./include/asm-mips/cacheflush.h:#define PG_dcache_dirty			PG_arch_1
./arch/sparc64/mm/init.c:#define PG_dcache_dirty		PG_arch_1
./arch/sh/include/cpu-sh4/cpu/cacheflush.h:#define PG_mapped	PG_arch_1
./arch/sh/include/cpu-sh3/cpu/cacheflush.h:#define PG_mapped	PG_arch_1
./arch/arm/include/asm/cacheflush.h:#define PG_dcache_dirty PG_arch_1

they are explicitly reserved for per architecture details.

	Ingo

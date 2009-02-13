Return-Path: <linux-kernel-owner+w=401wt.eu-S1757414AbZBMMTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414AbZBMMTU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 07:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbZBMMTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 07:19:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49313 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbZBMMTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 07:19:09 -0500
Date: Fri, 13 Feb 2009 13:18:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86 headers: remove duplicate pud_large() definition
Message-ID: <20090213121858.GB5483@elte.hu>
References: <49935DD8.8010705@goop.org> <20090213120239.GL15679@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090213120239.GL15679@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > I cleaned up the untangle series.
> >
> > The following changes since commit 9049a11de73d3ecc623f1903100d099f82ede56c:
> >  Jeremy Fitzhardinge (1):
> >        Merge commit 'remotes/tip/x86/paravirt' into x86/untangle2
> >
> > are available in the git repository at:
> >
> >  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git x86/untangle2
> >
> > Jeremy Fitzhardinge (10):
> >      x86: rename *-defs.h to *-_types.h for consistency
> >      Split pgtable.h into pgtable_types.h and pgtable.h
> >      x86: Split pgtable_32.h into pgtable_32.h and pgtable_32_types.h
> >      x86: Split pgtable_64.h into pgtable_64_types.h and pgtable_64.h
> >      x86: Include pgtable_32|64_types.h in pgtable_types.h
> >      x86: create _types.h counterparts for page*.h
> >      x86: move 2 and 3 level asm-generic defs into page-defs
> >      x86: move defs around to allow paravirt.h to just include page_types.h
> >      x86: define pud_flags and pud_large properly to allow non-PAE builds
> >      x86: move pte types into pgtable*.h
> >
> > arch/x86/include/asm/page.h                        |  168 +----------
> > arch/x86/include/asm/page_32.h                     |   89 +------
> > arch/x86/include/asm/page_32_types.h               |   62 ++++
> > arch/x86/include/asm/page_64.h                     |  101 +------
> > arch/x86/include/asm/page_64.h.rej                 |  114 +++++++
> > arch/x86/include/asm/page_64_types.h               |   91 ++++++
> > arch/x86/include/asm/page_types.h                  |   64 ++++
> > arch/x86/include/asm/paravirt.h                    |    2 +-
> > arch/x86/include/asm/pgtable-2level-defs.h         |   20 --
> > arch/x86/include/asm/pgtable-2level_types.h        |   35 +++
> > ...gtable-3level-defs.h => pgtable-3level_types.h} |   18 ++
> > arch/x86/include/asm/pgtable.h                     |  322 ++++----------------
> > arch/x86/include/asm/pgtable_32.h                  |   42 +---
> > arch/x86/include/asm/pgtable_32_types.h            |   46 +++
> > arch/x86/include/asm/pgtable_64.h                  |   48 +---
> > arch/x86/include/asm/pgtable_64_types.h            |   62 ++++
> > arch/x86/include/asm/pgtable_types.h               |  321 +++++++++++++++++++
> > arch/x86/include/asm/processor.h                   |    1 +
> > 18 files changed, 891 insertions(+), 715 deletions(-)
> > create mode 100644 arch/x86/include/asm/page_32_types.h
> > create mode 100644 arch/x86/include/asm/page_64.h.rej
> > create mode 100644 arch/x86/include/asm/page_64_types.h
> > create mode 100644 arch/x86/include/asm/page_types.h
> > delete mode 100644 arch/x86/include/asm/pgtable-2level-defs.h
> > create mode 100644 arch/x86/include/asm/pgtable-2level_types.h
> > rename arch/x86/include/asm/{pgtable-3level-defs.h => pgtable-3level_types.h} (67%)
> > create mode 100644 arch/x86/include/asm/pgtable_32_types.h
> > create mode 100644 arch/x86/include/asm/pgtable_64_types.h
> > create mode 100644 arch/x86/include/asm/pgtable_types.h
> 
> Pulled into tip:x86/headers, thanks Jeremy!

btw., i had to do these conflict resolutions:

    Conflicts:
        arch/x86/include/asm/page.h
        arch/x86/include/asm/pgtable.h
        arch/x86/mach-voyager/voyager_smp.c
        arch/x86/mm/fault.c

and this in kmemcheck:

    Merge branch 'x86/headers' into kmemcheck
    
    Conflicts:
        arch/x86/include/asm/pgtable.h
    
    Merged into:
    
        arch/x86/include/asm/pgtable_types.h
    
Plus the fixlet below.

	Ingo

------------------------->
>From 999c7880cc8eeb0cbe6610b8c6d0ab0ec51cd848 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 13 Feb 2009 13:15:55 +0100
Subject: [PATCH] x86 headers: remove duplicate pud_large() definition

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/pgtable.h |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 62024ff..1c097a3 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -387,13 +387,6 @@ static inline unsigned long pages_to_mb(unsigned long npg)
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot)	\
 	remap_pfn_range(vma, vaddr, pfn, size, prot)
 
-#if PAGETABLE_LEVELS == 2
-static inline int pud_large(pud_t pud)
-{
-	return 0;
-}
-#endif
-
 #if PAGETABLE_LEVELS > 2
 static inline int pud_none(pud_t pud)
 {

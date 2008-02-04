Return-Path: <linux-kernel-owner+w=401wt.eu-S1756163AbYBDQMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbYBDQMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 11:12:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbYBDQMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 11:12:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52663 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111AbYBDQMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 11:12:40 -0500
Date: Mon, 4 Feb 2008 17:12:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [git pull] x86 updates
Message-ID: <20080204161219.GA8092@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
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


Linus, please pull the latest x86 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

Find the shortlog below.

78 commits: most of them are fixes, cleanups and low-risk items. There 
is one group of higher-risk items: the now pretty much rounded up 
CPA/ioremap work [this was needed to fix some of the regressions]. Some 
gbpages bits are included too but it's not enabled. All known x86 
regressions up to date are fixed by this queue.

there's two non-x86 changes:

 include/asm-generic/rtc.h
 include/asm-generic/tlb.h

rtc.h is a fix, the tlb.h one is a revert for a change introduced a week 
ago by x86.git. (as requested by Christoph Lameter)

Thanks,

	Ingo

------------------>
Andi Kleen (14):
      x86: move NUMAQ io handling into arch/x86/pci/numa.c
      x86: remove special NUMAQ support in io_32.h
      x86: cpa, add the PAT bit defines
      x86: cpa, only flush the cache if the caching attributes have changed
      x86: rename LARGE_PAGE_SIZE to PMD_PAGE_SIZE
      x86: switch pci-gart over to using set_memory_np() instead of clear_kernel_mapping()
      x86: remove now unused clear_kernel_mapping
      x86: switch direct mapping setup over to set_pte
      x86: add feature macros for the gbpages cpuid bit
      x86: add PUD_PAGE_SIZE
      x86: add pgtable accessor functions for gbpages
      x86: add gbpages support to lookup_address
      x86: support gbpages in pagetable dump
      x86: implement gbpages support in change_page_attr()

Andrew Morton (1):
      x86: fix RTC lockdep warning: potential hardirq recursion

Arjan van de Ven (2):
      x86: teach the static_protection function about high mappings
      x86: use the pfn from the page when change its attributes

Cyrill Gorcunov (1):
      x86: cleanup - eliminate numbers in LDT allocation code

Florian Fainelli (1):
      x86: mach-rdc321x Kconfig fix

H. Peter Anvin (18):
      x86: add _ASM_EXTABLE macro to <asm/asm.h>
      x86: use _ASM_EXTABLE macro in arch/x86/kernel/test_nx.c
      x86: use _ASM_EXTABLE macro in arch/x86/lib/mmx_32.c
      x86: use _ASM_EXTABLE macro in arch/x86/lib/usercopy_32.c
      x86: use _ASM_EXTABLE macro in arch/x86/lib/usercopy_64.c
      x86: use _ASM_EXTABLE macro in arch/x86/mm/init_32.c
      x86: use _ASM_EXTABLE macro in include/asm-x86/futex.h
      x86: use _ASM_EXTABLE macro in include/asm-x86/i387.h
      x86: use _ASM_EXTABLE macro in include/asm-x86/msr.h
      x86: use _ASM_EXTABLE macro in include/asm-x86/system.h
      x86: use _ASM_EXTABLE macro in include/asm-x86/uaccess_32.h
      x86: use _ASM_EXTABLE macro in include/asm-x86/uaccess_64.h
      x86: cpuid: allow querying %ecx-sensitive CPUID levels
      x86: cpuid, msr: use inode mutex instead of big kernel lock
      x86: reintroduce volatile keyword in prototype to clflush()
      x86: unify CPU feature string names
      x86 setup: print missing CPU features in cleartext
      asm-generic/tlb.h: remove <linux/quicklist.h>

Harvey Harrison (9):
      x86: reduce ifdef sections in fault.c
      x86: remove long dead cyrix mtrr code
      x86: sparse errors from string_32.h
      x86: remove final FASTCALL() uses
      x86: add include to cpu/intel.c
      x86: add function prototype to vm86.h
      x86: small sparse fix in process_32.c
      x86: add cpu init function defintions to cpu.h
      x86: add cpu mtrr init function definitions to mtrr.h

Huang, Ying (1):
      x86: fix EFI mapping

Ian Campbell (1):
      x86: define OBJCOPYFLAGS explicitly for each target.

Ingo Molnar (7):
      x86: relax RAM check in ioremap()
      x86: VMI fix
      x86: AMD Athlon X2 hard hang fix
      x86: remove cpa warning
      x86: cpa, cleanups
      x86: cpa, eliminate CPA_ enum
      x86: cpa, clean up code flow

Jeremy Fitzhardinge (4):
      x86: unify PAE/non-PAE pgd_ctor
      x86: revert "defer cr3 reload when doing pud_clear()"
      x86: pud_clear: only reload cr3 if necessary
      x86: update reference for PAE tlb flushing

Pavel Machek (1):
      x86: remove misleading comments in trampoline_*.S

Rob Landley (1):
      documentation: add Documentation/x86-64/00-INDEX

Sam Ravnborg (2):
      x86: restore correct module name for apm
      x86: rename module scx200_32 to scx200

Thomas Gleixner (14):
      x86: CPA remove bogus NX clear
      x86: CPA use the existing pfn in split as well
      x86: simplify __ioremap
      x86: ioremap remove the range check of cpa
      x86: no CPA on iounmap
      x86: CPA return early when requested feature is not available
      x86: introduce struct cpa_data
      x86: cpa, check if we changed anything and tlb flushing is necessary
      x86: cpa, preserve large pages if possible
      x86: cpa, fix lookup_address
      x86: CPA fix pagetable split
      x86: cpa selftest, skip non present entries
      x86: fix page-present check in cpa_flush_range
      x86: cpa, micro-optimization

Yinghai Lu (1):
      x86: print out node_data addr and bootmap_start addr

 Documentation/x86_64/00-INDEX          |   16 ++
 arch/x86/Kconfig                       |    1 +
 arch/x86/Makefile                      |    1 -
 arch/x86/boot/Makefile                 |   18 +-
 arch/x86/boot/compressed/Makefile      |    1 +
 arch/x86/boot/compressed/head_64.S     |    8 +-
 arch/x86/boot/cpu.c                    |   26 ++-
 arch/x86/boot/mkcpustr.c               |   49 ++++
 arch/x86/kernel/Makefile               |    6 +-
 arch/x86/kernel/cpu/Makefile           |    1 +
 arch/x86/kernel/cpu/common.c           |   10 -
 arch/x86/kernel/cpu/cpu.h              |    9 +
 arch/x86/kernel/cpu/feature_names.c    |   83 +++++++
 arch/x86/kernel/cpu/intel.c            |    1 +
 arch/x86/kernel/cpu/mtrr/cyrix.c       |  107 ---------
 arch/x86/kernel/cpu/mtrr/main.c        |   16 --
 arch/x86/kernel/cpu/mtrr/mtrr.h        |    4 +
 arch/x86/kernel/cpu/proc.c             |   74 ------
 arch/x86/kernel/cpuid.c                |   52 ++---
 arch/x86/kernel/efi.c                  |   57 +++---
 arch/x86/kernel/efi_64.c               |   22 +-
 arch/x86/kernel/head_64.S              |    4 +-
 arch/x86/kernel/ldt.c                  |    3 +-
 arch/x86/kernel/msr.c                  |   14 +-
 arch/x86/kernel/pci-gart_64.c          |    5 +-
 arch/x86/kernel/process_32.c           |    2 +-
 arch/x86/kernel/setup_64.c             |   76 ------
 arch/x86/kernel/test_nx.c              |   12 +-
 arch/x86/kernel/trampoline_32.S        |    7 +-
 arch/x86/kernel/trampoline_64.S        |    3 -
 arch/x86/kernel/vmi_32.c               |    6 +-
 arch/x86/lib/mmx_32.c                  |   31 +--
 arch/x86/lib/usercopy_32.c             |   12 +-
 arch/x86/lib/usercopy_64.c             |   12 +-
 arch/x86/mm/fault.c                    |   34 +--
 arch/x86/mm/init_32.c                  |    6 +-
 arch/x86/mm/init_64.c                  |   49 +----
 arch/x86/mm/ioremap.c                  |   41 +---
 arch/x86/mm/numa_64.c                  |    7 +-
 arch/x86/mm/pageattr-test.c            |    3 +-
 arch/x86/mm/pageattr.c                 |  400 +++++++++++++++++++++++++-------
 arch/x86/mm/pgtable_32.c               |   61 ++----
 arch/x86/pci/numa.c                    |   52 ++++-
 include/asm-generic/rtc.h              |   11 +-
 include/asm-generic/tlb.h              |    1 -
 include/asm-x86/asm.h                  |    7 +
 include/asm-x86/bugs.h                 |    2 +-
 include/asm-x86/cpufeature.h           |   14 +-
 include/asm-x86/efi.h                  |    4 +-
 include/asm-x86/futex.h                |   23 +--
 include/asm-x86/highmem.h              |    4 +-
 include/asm-x86/hw_irq_32.h            |    2 +-
 include/asm-x86/i387.h                 |   16 +-
 include/asm-x86/io_32.h                |   25 --
 include/asm-x86/mach-numaq/mach_apic.h |    2 +
 include/asm-x86/msr.h                  |   10 +-
 include/asm-x86/page.h                 |    4 +-
 include/asm-x86/page_64.h              |    3 +
 include/asm-x86/pgalloc_32.h           |    6 +-
 include/asm-x86/pgtable-3level.h       |   26 +--
 include/asm-x86/pgtable.h              |    4 +
 include/asm-x86/pgtable_32.h           |    2 +
 include/asm-x86/pgtable_64.h           |    7 +-
 include/asm-x86/string_32.h            |    8 +-
 include/asm-x86/system.h               |   23 +--
 include/asm-x86/uaccess_32.h           |   18 +-
 include/asm-x86/uaccess_64.h           |   10 +-
 include/asm-x86/vm86.h                 |    1 +
 68 files changed, 821 insertions(+), 814 deletions(-)
 create mode 100644 Documentation/x86_64/00-INDEX
 create mode 100644 arch/x86/boot/mkcpustr.c
 create mode 100644 arch/x86/kernel/cpu/feature_names.c


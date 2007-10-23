Return-Path: <linux-kernel-owner+w=401wt.eu-S1752725AbXJWVCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbXJWVCj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 17:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbXJWVCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 17:02:30 -0400
Received: from www.tglx.de ([62.245.132.106]:60659 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbXJWVC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 17:02:29 -0400
Date: Tue, 23 Oct 2007 23:02:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [Git pull] x86 updates
Message-ID: <alpine.LFD.0.9999.0710232258190.5181@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, 

please pull from:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

This contains a couple of bug fixes and a large cleanup and
unification section from various authors.

Thanks,
	tglx
---
Adrian Bunk (1):
      x86: add instrumentation menu

Alejandro Martinez Ruiz (1):
      x86: ARRAY_SIZE cleanup

Brian Gerst (1):
      x86: merge required-features.h

Carlos Corbacho (2):
      x86: Force enable HPET for CK804 (nForce 4) chipsets
      x86: Add HPET force support for MCP55 (nForce 5) chipsets

Chris Snook (3):
      x86: merge mmu{,_32,_64}.h
      x86: unify a.out{,_32,_64}.h
      x86: unify div64{,_32,_64}.h

Dave Johnson (2):
      x86: fix TSC clock source calibration error
      x86: fix more TSC clock source calibration errors

H. Peter Anvin (1):
      x86: clean up setup.h and the boot code

Hiroshi Shimamoto (3):
      x86: add lapic_shutdown for x86_64
      x86: add safe_smp_processor_id for x86_64
      x86: unify crash_32/64.c

Nick Piggin (1):
      x86: lock bitops

Rafael J. Wysocki (1):
      x86: Save registers in saved_context during suspend and hibernation

Thomas Gleixner (19):
      x86: Add BITS to allow simple Makefile sharing
      x86: merge arch/x86/crypto Makefiles
      x86: Unify arch/x86/kernel/acpi Makefiles
      x86: prepare consolidation of cpu/ related Makefiles
      x86: prepare consolidation of cpu/ related code usage
      x86: consolidate the cpu/ related code usage
      x86: whitespace cleanup of mce_64.c
      x86: merge byteorder_32/64.h
      x86: merge elf_32/64.h
      x86: merge msgbuf_32/64.h
      x86: merge ptrace_32/64.h
      x86: merge shmbuf_32/64.h
      x86: merge stat_32/64.h
      x86: merge statfs_32/64.h
      x86: merge mttr_32/64.h
      x86: merge msr_32/64.h
      x86: merge sigcontext_32/64.h
      x86: merge signal_32/64.h
      x86: merge setup_32/64.h

 Documentation/kernel-parameters.txt             |    3 +-
 arch/i386/Kconfig                               |    2 +
 arch/i386/Makefile                              |    6 +
 arch/x86/boot/boot.h                            |    2 +-
 arch/x86/boot/compressed/relocs.c               |    6 +-
 arch/x86/boot/main.c                            |    2 -
 arch/x86/crypto/Makefile                        |   20 +-
 arch/x86/crypto/Makefile_32                     |   12 -
 arch/x86/crypto/Makefile_64                     |   12 -
 arch/x86/kernel/Makefile_32                     |    2 +-
 arch/x86/kernel/Makefile_64                     |   19 +-
 arch/x86/kernel/acpi/Makefile                   |   10 +-
 arch/x86/kernel/acpi/Makefile_32                |    7 -
 arch/x86/kernel/acpi/Makefile_64                |    7 -
 arch/x86/kernel/acpi/wakeup_64.S                |  101 ++++---
 arch/x86/kernel/apic_64.c                       |   14 +
 arch/x86/kernel/asm-offsets_64.c                |   28 ++
 arch/x86/kernel/cpu/Makefile                    |   24 +-
 arch/x86/kernel/cpu/mcheck/Makefile             |    8 +-
 arch/x86/kernel/cpu/mcheck/{mce.c => mce_32.c}  |    0 
 arch/x86/kernel/{ => cpu/mcheck}/mce_64.c       |  164 ++++++-----
 arch/x86/kernel/{ => cpu/mcheck}/mce_amd_64.c   |    0 
 arch/x86/kernel/{ => cpu/mcheck}/mce_intel_64.c |    0 
 arch/x86/kernel/{crash_32.c => crash.c}         |   11 +-
 arch/x86/kernel/crash_64.c                      |  135 ---------
 arch/x86/kernel/head_32.S                       |    7 +-
 arch/x86/kernel/quirks.c                        |   55 ++++-
 arch/x86/kernel/smpboot_64.c                    |    2 +-
 arch/x86/kernel/suspend_64.c                    |    6 -
 arch/x86/kernel/suspend_asm_64.S                |   72 +++---
 arch/x86/kernel/tsc_32.c                        |   39 ++-
 arch/x86/oprofile/Kconfig                       |   17 -
 arch/x86_64/Kconfig                             |    2 +
 arch/x86_64/Makefile                            |    6 +
 include/asm-x86/Kbuild                          |   27 +--
 include/asm-x86/a.out.h                         |   33 ++-
 include/asm-x86/a.out_32.h                      |   27 --
 include/asm-x86/a.out_64.h                      |   28 --
 include/asm-x86/apic_64.h                       |    1 +
 include/asm-x86/bitops_32.h                     |   43 +++-
 include/asm-x86/bitops_64.h                     |   42 +++-
 include/asm-x86/byteorder.h                     |   81 +++++-
 include/asm-x86/byteorder_32.h                  |   58 ----
 include/asm-x86/byteorder_64.h                  |   33 --
 include/asm-x86/div64.h                         |   60 ++++-
 include/asm-x86/div64_32.h                      |   52 ----
 include/asm-x86/div64_64.h                      |    1 -
 include/asm-x86/elf.h                           |  299 ++++++++++++++++++-
 include/asm-x86/elf_32.h                        |  165 -----------
 include/asm-x86/elf_64.h                        |  180 ------------
 include/asm-x86/mmu.h                           |   26 ++-
 include/asm-x86/mmu_32.h                        |   18 --
 include/asm-x86/mmu_64.h                        |   21 --
 include/asm-x86/msgbuf.h                        |   50 +++-
 include/asm-x86/msgbuf_32.h                     |   31 --
 include/asm-x86/msgbuf_64.h                     |   27 --
 include/asm-x86/msr.h                           |  357 ++++++++++++++++++++++-
 include/asm-x86/msr_32.h                        |  161 ----------
 include/asm-x86/msr_64.h                        |  187 ------------
 include/asm-x86/mtrr.h                          |  175 +++++++++++-
 include/asm-x86/mtrr_32.h                       |  115 --------
 include/asm-x86/mtrr_64.h                       |  152 ----------
 include/asm-x86/ptrace.h                        |  151 +++++++++-
 include/asm-x86/ptrace_32.h                     |   65 ----
 include/asm-x86/ptrace_64.h                     |   80 -----
 include/asm-x86/required-features.h             |   73 +++++-
 include/asm-x86/required-features_32.h          |   55 ----
 include/asm-x86/required-features_64.h          |   46 ---
 include/asm-x86/setup.h                         |   72 ++++-
 include/asm-x86/setup_32.h                      |   63 ----
 include/asm-x86/setup_64.h                      |   19 --
 include/asm-x86/shmbuf.h                        |   62 ++++-
 include/asm-x86/shmbuf_32.h                     |   42 ---
 include/asm-x86/shmbuf_64.h                     |   38 ---
 include/asm-x86/sigcontext.h                    |  149 +++++++++-
 include/asm-x86/sigcontext_32.h                 |   85 ------
 include/asm-x86/sigcontext_64.h                 |   55 ----
 include/asm-x86/signal.h                        |  273 +++++++++++++++++-
 include/asm-x86/signal_32.h                     |  232 ---------------
 include/asm-x86/signal_64.h                     |  181 ------------
 include/asm-x86/smp_64.h                        |    2 +
 include/asm-x86/stat.h                          |  123 +++++++-
 include/asm-x86/stat_32.h                       |   77 -----
 include/asm-x86/stat_64.h                       |   44 ---
 include/asm-x86/statfs.h                        |   72 ++++-
 include/asm-x86/statfs_32.h                     |    6 -
 include/asm-x86/statfs_64.h                     |   58 ----
 include/asm-x86/suspend_64.h                    |   23 +-
 88 files changed, 2368 insertions(+), 3029 deletions(-)
 delete mode 100644 arch/x86/crypto/Makefile_32
 delete mode 100644 arch/x86/crypto/Makefile_64
 delete mode 100644 arch/x86/kernel/acpi/Makefile_32
 delete mode 100644 arch/x86/kernel/acpi/Makefile_64
 rename arch/x86/kernel/cpu/mcheck/{mce.c => mce_32.c} (100%)
 rename arch/x86/kernel/{ => cpu/mcheck}/mce_64.c (91%)
 rename arch/x86/kernel/{ => cpu/mcheck}/mce_amd_64.c (100%)
 rename arch/x86/kernel/{ => cpu/mcheck}/mce_intel_64.c (100%)
 rename arch/x86/kernel/{crash_32.c => crash.c} (95%)
 delete mode 100644 arch/x86/kernel/crash_64.c
 delete mode 100644 arch/x86/oprofile/Kconfig
 delete mode 100644 include/asm-x86/a.out_32.h
 delete mode 100644 include/asm-x86/a.out_64.h
 delete mode 100644 include/asm-x86/byteorder_32.h
 delete mode 100644 include/asm-x86/byteorder_64.h
 delete mode 100644 include/asm-x86/div64_32.h
 delete mode 100644 include/asm-x86/div64_64.h
 delete mode 100644 include/asm-x86/elf_32.h
 delete mode 100644 include/asm-x86/elf_64.h
 delete mode 100644 include/asm-x86/mmu_32.h
 delete mode 100644 include/asm-x86/mmu_64.h
 delete mode 100644 include/asm-x86/msgbuf_32.h
 delete mode 100644 include/asm-x86/msgbuf_64.h
 delete mode 100644 include/asm-x86/msr_32.h
 delete mode 100644 include/asm-x86/msr_64.h
 delete mode 100644 include/asm-x86/mtrr_32.h
 delete mode 100644 include/asm-x86/mtrr_64.h
 delete mode 100644 include/asm-x86/ptrace_32.h
 delete mode 100644 include/asm-x86/ptrace_64.h
 delete mode 100644 include/asm-x86/required-features_32.h
 delete mode 100644 include/asm-x86/required-features_64.h
 delete mode 100644 include/asm-x86/setup_32.h
 delete mode 100644 include/asm-x86/setup_64.h
 delete mode 100644 include/asm-x86/shmbuf_32.h
 delete mode 100644 include/asm-x86/shmbuf_64.h
 delete mode 100644 include/asm-x86/sigcontext_32.h
 delete mode 100644 include/asm-x86/sigcontext_64.h
 delete mode 100644 include/asm-x86/signal_32.h
 delete mode 100644 include/asm-x86/signal_64.h
 delete mode 100644 include/asm-x86/stat_32.h
 delete mode 100644 include/asm-x86/stat_64.h
 delete mode 100644 include/asm-x86/statfs_32.h
 delete mode 100644 include/asm-x86/statfs_64.h

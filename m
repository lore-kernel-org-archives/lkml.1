Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbZFMIA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbZFMIA3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 04:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754108AbZFMIAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 04:00:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57766 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbZFMIAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 04:00:19 -0400
Date: Sat, 13 Jun 2009 00:59:55 -0700
Message-Id: <200906130759.n5D7xtLF029672@voreg.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixer <tglx@linutronix.de>,
       Huang Ying <ying.huang@intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] x86 MCE for v2.6.31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Updates for the MCE facility.

The following changes since commit f3ad116588151b3371ae4e092290e4f48e62b8bb:
  Linus Torvalds (1):
        Merge branch 'upstream-linus' of git://git.kernel.org/.../jlbec/configfs

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-mce-for-linus

Andi Kleen (43):
      x86, mce: initial steps to make 64bit mce code 32bit clean
      x86, mce: implement the PPro bank 0 quirk in the 64bit machine check code
      x86, mce: port K7 bank 0 quirk to 64bit mce code
      x86, mce: use a call vector to call the 64bit mce handler
      x86, mce: rename 64bit mce_dont_init to mce_disabled
      x86, mce: move mce_disabled option into common 32bit/64bit code
      x86, mce: remove machine check handler idle notify on 64bit
      x86, mce: remove oops_begin() use in 64bit machine check
      x86, mce: use 64bit machine check code on 32bit
      x86, mce: deprecate old 32bit machine check code
      x86, mce: enable MCE_INTEL for 32bit new MCE
      x86, mce: enable MCE_AMD for 32bit NEW_MCE
      x86, mce: document new 32bit mcelog requirement in Documentation/Changes
      Export add_timer_on for modules
      x86, mce: add MSR read wrappers for easier error injection
      x86, mce: add basic error injection infrastructure
      x86, mce: synchronize core after machine check handling
      x86, mce: use extended sysattrs for the check_interval attribute.
      x86, mce: remove unused mce_events variable
      x86, mce: rename and align out2 label
      x86, mce: drop BKL in mce_open
      x86, mce: improve documentation
      x86: trivial clean up for irq_vectors.h
      x86, mce: add machine check exception count in /proc/interrupts
      x86, mce: add MCE poll count to /proc/interrupts
      x86, mce: store record length into memory struct mce anchor
      x86, mce: support more than 256 CPUs in struct mce
      x86, mce: extend struct mce user interface with more information.
      x86, mce: log corrected errors when panicing
      x86, mce: remove TSC print heuristic
      x86, mce: add table driven machine check grading
      x86, mce: check early in exception handler if panic is needed
      x86, mce: implement bootstrapping for machine check wakeups
      x86, mce: implement panic synchronization
      x86, mce: switch x86 machine check handler to Monarch election.
      x86, mce: make non Monarch panic message "Fatal machine check" too
      x86, mce: default to panic timeout for machine checks
      x86, mce: print header/footer only once for multiple MCEs
      x86, mce: implement new status bits
      x86: fix panic with interrupts off (needed for MCE)
      x86, mce: rename mce_notify_user to mce_notify_irq
      x86, mce: define MCE_VECTOR
      x86, mce: support action-optional machine checks

H. Peter Anvin (4):
      x86, mce: add comment about mce_chrdev_ops being writable
      x86, mce: fix comment style in mce-inject.c
      x86, mce: drop "extern" from function prototypes in asm/mce.h
      Merge branch 'irq/numa' into x86/mce3

Hidetoshi Seto (11):
      x86, mce: Cleanup param parser
      x86, mce: use strict_strtoull
      x86, mce: trivial clean up for therm_throt.c
      x86, mce: trivial clean up for mce.c
      x86, mce: trivial clean up for mce_amd_64.c
      x86, mce: trivial clean up for mce_intel_64.c
      x86, mce: trivial clean up for mce-inject.c
      x86: trivial clean up for arch/x86/Kconfig
      x86, mce: fix for mce counters
      x86, mce: Fix mce printing
      x86, mce: Add boot options for corrected errors

Huang Ying (2):
      x86, mce: improve mce_get_rip
      x86, mce: export MCE severities coverage via debugfs

Ingo Molnar (17):
      x86, mce: clean up mce_64.c
      x86, mce: clean up mce_32.c
      x86, mce: clean up p4.c
      x86, mce: clean up p5.c
      x86, mce: clean up p6.c
      x86, mce: clean up k7.c
      x86, mce: clean up winchip.c
      x86, mce: clean up non-fatal.c
      x86, mce: clean up therm_throt.c
      x86, mce: clean up mce_amd_64.c
      x86, mce: unify, prepare 64bit in mce.h
      x86, mce: unify, prepare codes
      x86, mce: unify, prepare for 32-bit v2
      x86, mce: unify
      x86, mce: Rename sysfs variables
      x86, mce: print number of MCE banks
      Merge branch 'linus' into x86/mce3

Thomas Gleixner (5):
      x86, mce: unify Intel thermal init, prepare
      x86, mce: unify Intel thermal init
      x86, mce: Cleanup symbols in intel thermal codes
      x86, mce: Cleanup MCG definitions
      x86, mce: remove mce_init unused argument

 Documentation/Changes                      |   15 +
 Documentation/feature-removal-schedule.txt |   10 +
 Documentation/x86/x86_64/boot-options.txt  |   44 +-
 Documentation/x86/x86_64/machinecheck      |    8 +-
 arch/x86/Kconfig                           |   45 +-
 arch/x86/include/asm/entry_arch.h          |   11 +-
 arch/x86/include/asm/hardirq.h             |    2 +-
 arch/x86/include/asm/hw_irq.h              |    2 +
 arch/x86/include/asm/irq_vectors.h         |   17 +-
 arch/x86/include/asm/mce.h                 |   88 +-
 arch/x86/include/asm/msr-index.h           |    7 +
 arch/x86/kernel/apic/apic.c                |    4 +-
 arch/x86/kernel/apic/nmi.c                 |    2 +-
 arch/x86/kernel/cpu/mcheck/Makefile        |   10 +-
 arch/x86/kernel/cpu/mcheck/k7.c            |   42 +-
 arch/x86/kernel/cpu/mcheck/mce-inject.c    |  127 ++
 arch/x86/kernel/cpu/mcheck/mce-internal.h  |   15 +
 arch/x86/kernel/cpu/mcheck/mce-severity.c  |  218 +++
 arch/x86/kernel/cpu/mcheck/mce.c           | 1964 ++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/mcheck/mce.h           |   26 +-
 arch/x86/kernel/cpu/mcheck/mce_32.c        |   76 --
 arch/x86/kernel/cpu/mcheck/mce_64.c        | 1188 -----------------
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c    |  203 ++--
 arch/x86/kernel/cpu/mcheck/mce_intel.c     |   74 ++
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c  |   65 +-
 arch/x86/kernel/cpu/mcheck/non-fatal.c     |   57 +-
 arch/x86/kernel/cpu/mcheck/p4.c            |   86 +-
 arch/x86/kernel/cpu/mcheck/p5.c            |   48 +-
 arch/x86/kernel/cpu/mcheck/p6.c            |   26 +-
 arch/x86/kernel/cpu/mcheck/therm_throt.c   |   73 +-
 arch/x86/kernel/cpu/mcheck/threshold.c     |    2 +-
 arch/x86/kernel/cpu/mcheck/winchip.c       |   17 +-
 arch/x86/kernel/entry_64.S                 |   11 +-
 arch/x86/kernel/irq.c                      |   19 +-
 arch/x86/kernel/irqinit.c                  |    3 +
 arch/x86/kernel/signal.c                   |    6 +-
 arch/x86/kernel/smp.c                      |   28 +-
 arch/x86/kernel/traps.c                    |    6 +-
 kernel/timer.c                             |    1 +
 39 files changed, 2978 insertions(+), 1668 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/mcheck/mce-inject.c
 create mode 100644 arch/x86/kernel/cpu/mcheck/mce-internal.h
 create mode 100644 arch/x86/kernel/cpu/mcheck/mce-severity.c
 create mode 100644 arch/x86/kernel/cpu/mcheck/mce.c
 delete mode 100644 arch/x86/kernel/cpu/mcheck/mce_32.c
 delete mode 100644 arch/x86/kernel/cpu/mcheck/mce_64.c
 create mode 100644 arch/x86/kernel/cpu/mcheck/mce_intel.c

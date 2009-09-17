Return-Path: <linux-kernel-owner+w=401wt.eu-S1753542AbZIQWup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbZIQWup (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 18:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753350AbZIQWuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 18:50:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39732 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbZIQWum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 18:50:42 -0400
Date: Thu, 17 Sep 2009 15:50:21 -0700
Message-Id: <200909172250.n8HMoL8m001182@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <andi@firstfloor.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Huang Ying <ying.huang@intel.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Borislav Petkov <borislav.petkov@amd.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT PULL] x86/mce for v2.6.32
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.2 (terminus.zytor.com [127.0.0.1]); Thu, 17 Sep 2009 15:50:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following x86/mce commits are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-mce-for-linus

This tree has two trivial conflicts with your top of tree; one in
Documentation/feature-removals, and one in
arch/x86/kernel/cpu/mcheck/mce.c.  The resolution to the latter should
look like:

static int __cpuinit mce_cpu_quirks(struct cpuinfo_x86 *c)

for the first, and use your master version of the latter.

Thanks,

	-hpa

Andi Kleen (9):
      x86: mce: Make CONFIG_X86_ANCIENT_MCE dependent on CONFIG_X86_MCE
      x86: mce: Update X86_MCE description in x86/Kconfig
      x86: mce: Remove old i386 machine check code
      x86: mce: Rename CONFIG_X86_NEW_MCE to CONFIG_X86_MCE
      x86: mce: Move code in mce.c
      x86: mce: Move per bank data in a single datastructure
      x86: mce: macros to compute banks MSRs
      x86: mce: Lower maximum number of banks to architecture limit
      x86, mce: Fix compilation with !CONFIG_DEBUG_FS in mce-severity.c

Bartlomiej Zolnierkiewicz (5):
      x86, mce: don't log boot MCEs on Pentium M (model == 13) CPUs
      x86, mce: fix "mce" boot option handling for CONFIG_X86_NEW_MCE
      x86, mce: add missing __cpuinit tags
      x86, mce: remove never executed code
      x86, mce: fix reporting of Thermal Monitoring mechanism enabled

Borislav Petkov (2):
      x86, mce: fix typo in comment in asm/mce.h
      x86, mce: use atomic_inc_return() instead of add by 1

Hidetoshi Seto (1):
      x86, mce: CE in last bank prevents panic by unknown MCE

Huang Ying (4):
      x86, mce: Support specifying context for software mce injection
      x86, mce: Support specifying raise mode for software MCE injection
      x86, mce: Move debugfs mce dir creating to mce.c
      x86, mce: Fake panic support for MCE testing

 Documentation/feature-removal-schedule.txt |   10 -
 arch/x86/Kconfig                           |   62 +-----
 arch/x86/include/asm/entry_arch.h          |    2 +-
 arch/x86/include/asm/mce.h                 |   32 ++--
 arch/x86/include/asm/msr-index.h           |   11 +
 arch/x86/kernel/apic/nmi.c                 |    2 +-
 arch/x86/kernel/cpu/mcheck/Makefile        |    5 +-
 arch/x86/kernel/cpu/mcheck/k7.c            |  116 -----------
 arch/x86/kernel/cpu/mcheck/mce-inject.c    |  158 ++++++++++++---
 arch/x86/kernel/cpu/mcheck/mce-internal.h  |   15 ++
 arch/x86/kernel/cpu/mcheck/mce-severity.c  |    8 +-
 arch/x86/kernel/cpu/mcheck/mce.c           |  308 +++++++++++++++-------------
 arch/x86/kernel/cpu/mcheck/mce_intel.c     |   10 +-
 arch/x86/kernel/cpu/mcheck/non-fatal.c     |   94 ---------
 arch/x86/kernel/cpu/mcheck/p4.c            |  163 ---------------
 arch/x86/kernel/cpu/mcheck/p6.c            |  127 ------------
 arch/x86/kernel/cpu/mcheck/therm_throt.c   |   13 +-
 arch/x86/kernel/irq.c                      |    4 +-
 arch/x86/kernel/irqinit.c                  |    2 +-
 arch/x86/kernel/signal.c                   |    2 +-
 20 files changed, 367 insertions(+), 777 deletions(-)
 delete mode 100644 arch/x86/kernel/cpu/mcheck/k7.c
 delete mode 100644 arch/x86/kernel/cpu/mcheck/non-fatal.c
 delete mode 100644 arch/x86/kernel/cpu/mcheck/p4.c
 delete mode 100644 arch/x86/kernel/cpu/mcheck/p6.c

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755745AbYE2I6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbYE2I6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 04:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754297AbYE2I4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 04:56:12 -0400
Received: from brick.kernel.dk ([87.55.233.238]:17948 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbYE2Iz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 04:55:59 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, npiggin@suse.de, linux-arch@vger.kernel.org,
       jeremy@goop.org, mingo@elte.hu, paulmck@linux.vnet.ibm.com
Subject: [PATCH 0/10] Add generic helpers for arch IPI function calls #4
Date: Thu, 29 May 2008 10:58:14 +0200
Message-Id: <1212051504-12561-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.6.rc0.40.gd683
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Jeremy sent me a ping about this patchset, so here's an updated
version against the current kernel (2.6.26-rc4'ish). Changes since
last post:

- Incorporate Pauls changes and suggestions to make
  smp_call_function_single() both cleaner and (hopefull) deadlock free
  within the restrictions set.
- Fix various compile problems with some archs and .config configurations.

Not really a lot of churn, it's mostly solid and works well on the
archs that I test (x86, x86-64, ppc) and I know that it works well
on ia64 as well.

The nice diffstat is below, enjoy.

 arch/Kconfig                               |    3 
 arch/alpha/Kconfig                         |    1 
 arch/alpha/kernel/core_marvel.c            |    6 
 arch/alpha/kernel/smp.c                    |  170 ---------
 arch/arm/Kconfig                           |    1 
 arch/arm/kernel/smp.c                      |  157 ---------
 arch/ia64/Kconfig                          |    1 
 arch/ia64/kernel/smp.c                     |  242 --------------
 arch/m32r/Kconfig                          |    1 
 arch/m32r/kernel/m32r_ksyms.c              |    3 
 arch/m32r/kernel/smp.c                     |  128 -------
 arch/m32r/kernel/traps.c                   |    3 
 arch/mips/Kconfig                          |    1 
 arch/mips/kernel/smp.c                     |  139 --------
 arch/mips/kernel/smtc.c                    |    1 
 arch/parisc/Kconfig                        |    1 
 arch/parisc/kernel/smp.c                   |  134 +------
 arch/powerpc/Kconfig                       |    1 
 arch/powerpc/kernel/smp.c                  |  220 ------------
 arch/powerpc/platforms/cell/interrupt.c    |    1 
 arch/powerpc/platforms/ps3/smp.c           |    7 
 arch/powerpc/platforms/pseries/xics.c      |    6 
 arch/powerpc/sysdev/mpic.c                 |    2 
 arch/sh/Kconfig                            |    1 
 arch/sh/kernel/smp.c                       |   48 --
 arch/sparc64/kernel/smp.c                  |   11 
 arch/x86/Kconfig                           |    1 
 arch/x86/kernel/apic_32.c                  |    4 
 arch/x86/kernel/entry_64.S                 |    3 
 arch/x86/kernel/i8259_64.c                 |    4 
 arch/x86/kernel/smp.c                      |  152 +-------
 arch/x86/kernel/smpcommon.c                |   56 ---
 arch/x86/mach-voyager/voyager_smp.c        |   94 -----
 arch/x86/xen/enlighten.c                   |    4 
 arch/x86/xen/smp.c                         |  133 ++-----
 arch/x86/xen/xen-ops.h                     |    9 
 include/asm-alpha/smp.h                    |    2 
 include/asm-ia64/smp.h                     |    3 
 include/asm-m32r/smp.h                     |    1 
 include/asm-mips/smp.h                     |   10 
 include/asm-powerpc/smp.h                  |    5 
 include/asm-sh/smp.h                       |   12 
 include/asm-x86/hw_irq_32.h                |    1 
 include/asm-x86/hw_irq_64.h                |    2 
 include/asm-x86/mach-default/entry_arch.h  |    1 
 include/asm-x86/mach-default/irq_vectors.h |    1 
 include/asm-x86/mach-voyager/entry_arch.h  |    2 
 include/asm-x86/mach-voyager/irq_vectors.h |    4 
 include/asm-x86/smp.h                      |   19 -
 include/asm-x86/xen/events.h               |    1 
 include/linux/smp.h                        |   34 +
 init/main.c                                |    2 
 kernel/Makefile                            |    1 
 kernel/smp.c                               |  362 +++++++++++++++++++++
 54 files changed, 661 insertions(+), 1551 deletions(-)

-- 
Jens Axboe



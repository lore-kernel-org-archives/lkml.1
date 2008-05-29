Return-Path: <linux-kernel-owner+w=401wt.eu-S1756573AbYE2I74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573AbYE2I74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 04:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756188AbYE2I6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 04:58:36 -0400
Received: from brick.kernel.dk ([87.55.233.238]:15864 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756174AbYE2I6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 04:58:33 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, npiggin@suse.de, linux-arch@vger.kernel.org,
       jeremy@goop.org, mingo@elte.hu, paulmck@linux.vnet.ibm.com
Subject: [PATCH 0/2] Kill unused parameter to smp_call_function and friends
Date: Thu, 29 May 2008 11:00:59 +0200
Message-Id: <1212051661-12733-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.6.rc0.40.gd683
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It bothers me how the smp call functions accept a 'nonatomic' or 'retry'
parameter (depending on who you ask), but don't do anything with it.
So kill that silly thing.

Two patches here, one for smp_call_function*() and one for on_each_cpu().
This patchset applies on top of the generic-ipi patchset just sent out.

 arch/alpha/kernel/core_marvel.c        |    2 +-
 arch/alpha/kernel/process.c            |    2 +-
 arch/alpha/kernel/smp.c                |   10 +++++-----
 arch/alpha/oprofile/common.c           |    6 +++---
 arch/arm/kernel/smp.c                  |    6 +++---
 arch/arm/oprofile/op_model_mpcore.c    |    2 +-
 arch/arm/vfp/vfpmodule.c               |    2 +-
 arch/cris/arch-v32/kernel/smp.c        |    5 ++---
 arch/ia64/kernel/mca.c                 |    6 +++---
 arch/ia64/kernel/palinfo.c             |    2 +-
 arch/ia64/kernel/perfmon.c             |    6 +++---
 arch/ia64/kernel/process.c             |    2 +-
 arch/ia64/kernel/smp.c                 |    4 ++--
 arch/ia64/kernel/smpboot.c             |    2 +-
 arch/ia64/kernel/uncached.c            |    5 ++---
 arch/ia64/sn/kernel/sn2/sn_hwperf.c    |    2 +-
 arch/m32r/kernel/smp.c                 |    4 ++--
 arch/mips/kernel/irq-rm9000.c          |    4 ++--
 arch/mips/kernel/smp.c                 |    8 ++++----
 arch/mips/mm/c-r4k.c                   |   18 +++++++++---------
 arch/mips/oprofile/common.c            |    6 +++---
 arch/mips/pmc-sierra/yosemite/prom.c   |    2 +-
 arch/mips/sibyte/cfe/setup.c           |    2 +-
 arch/mips/sibyte/sb1250/prom.c         |    2 +-
 arch/parisc/kernel/cache.c             |    6 +++---
 arch/parisc/kernel/smp.c               |    2 +-
 arch/parisc/mm/init.c                  |    2 +-
 arch/powerpc/kernel/rtas.c             |    2 +-
 arch/powerpc/kernel/smp.c              |    2 +-
 arch/powerpc/kernel/tau_6xx.c          |    4 ++--
 arch/powerpc/kernel/time.c             |    2 +-
 arch/powerpc/mm/slice.c                |    2 +-
 arch/powerpc/oprofile/common.c         |    6 +++---
 arch/s390/appldata/appldata_base.c     |    4 ++--
 arch/s390/kernel/smp.c                 |   22 +++++++++-------------
 arch/s390/kernel/time.c                |    6 +++---
 arch/sh/kernel/smp.c                   |   14 +++++++-------
 arch/sparc64/kernel/smp.c              |   12 ++++--------
 arch/sparc64/mm/hugetlbpage.c          |    2 +-
 arch/um/kernel/smp.c                   |    3 +--
 arch/x86/kernel/cpu/mcheck/mce_64.c    |    6 +++---
 arch/x86/kernel/cpu/mcheck/non-fatal.c |    2 +-
 arch/x86/kernel/cpu/mtrr/main.c        |    4 ++--
 arch/x86/kernel/cpu/perfctr-watchdog.c |    4 ++--
 arch/x86/kernel/cpuid.c                |    2 +-
 arch/x86/kernel/io_apic_32.c           |    2 +-
 arch/x86/kernel/io_apic_64.c           |    2 +-
 arch/x86/kernel/ldt.c                  |    2 +-
 arch/x86/kernel/nmi_32.c               |    6 +++---
 arch/x86/kernel/nmi_64.c               |    6 +++---
 arch/x86/kernel/smp.c                  |    2 +-
 arch/x86/kernel/tlb_32.c               |    2 +-
 arch/x86/kernel/tlb_64.c               |    2 +-
 arch/x86/kernel/vsyscall_64.c          |    4 ++--
 arch/x86/kvm/vmx.c                     |    4 ++--
 arch/x86/kvm/x86.c                     |    2 +-
 arch/x86/lib/msr-on-cpu.c              |    8 ++++----
 arch/x86/mach-voyager/voyager_smp.c    |    4 ++--
 arch/x86/mm/pageattr.c                 |    4 ++--
 arch/x86/oprofile/nmi_int.c            |   10 +++++-----
 arch/x86/xen/smp.c                     |    2 +-
 drivers/acpi/processor_idle.c          |    2 +-
 drivers/char/agp/generic.c             |    2 +-
 drivers/cpuidle/cpuidle.c              |    2 +-
 drivers/lguest/x86/core.c              |    4 ++--
 fs/buffer.c                            |    2 +-
 include/asm-alpha/smp.h                |    2 +-
 include/asm-sparc/smp.h                |    2 +-
 include/linux/smp.h                    |   12 ++++++------
 kernel/hrtimer.c                       |    2 +-
 kernel/profile.c                       |    6 +++---
 kernel/rcupdate.c                      |    2 +-
 kernel/smp.c                           |    6 ++----
 kernel/softirq.c                       |    4 ++--
 kernel/time/tick-broadcast.c           |    2 +-
 mm/page_alloc.c                        |    2 +-
 mm/slab.c                              |    4 ++--
 mm/slub.c                              |    2 +-
 net/core/flow.c                        |    2 +-
 net/iucv/iucv.c                        |   16 ++++++++--------
 virt/kvm/kvm_main.c                    |   14 +++++++-------
 81 files changed, 179 insertions(+), 192 deletions(-)

-- 
Jens Axboe



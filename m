Return-Path: <linux-kernel-owner+w=401wt.eu-S1752375AbZIXA0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375AbZIXA0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 20:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751134AbZIXA0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 20:26:53 -0400
Received: from ozlabs.org ([203.10.76.45]:34642 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbZIXA0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 20:26:52 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] cpumask conversions and obsolescence removal
Date: Thu, 24 Sep 2009 09:56:53 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>,
       Hirokazu Takata <takata@linux-m32r.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909240956.54370.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Finally!  These have been in linux-next in various forms for at least two
cycles.  Glad to get rid of some of the deprecated functions so people don't
keep adding more usages.

Thanks,
Rusty.

The following changes since commit a724eada8c2a7b62463b73ccf73fd0bb6e928aeb:
  Linus Torvalds (1):
        Merge branch 'ixp4xx' of git://git.kernel.org/.../chris/linux-2.6

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Bjorn Helgaas (1):
      ACPI: remove cpumask_t usage

Li Zefan (1):
      cpumask: use zalloc_cpumask_var() where possible

Nobuhiro Iwamatsu (1):
      cpumask: Remove mask field from comments

Rusty Russell (36):
      cpumask: remove the now-obsoleted pcibus_to_cpumask(): alpha
      cpumask: remove the now-obsoleted pcibus_to_cpumask(): mips
      cpumask: remove the now-obsoleted pcibus_to_cpumask(): powerpc
      cpumask: remove obsolete node_to_cpumask now everyone uses cpumask_of_node
      cpumask: remove dangerous CPU_MASK_ALL_PTR
      cpumask: remove dangerous CPU_MASK_ALL_PTR, &CPU_MASK_ALL.: mips
      cpumask: remove unused cpu_mask_all
      cpumask: remove last assignment to mask field of struct irqaction.
      cpumask: remove unused mask field from struct irqaction.
      cpumask: don't define set_cpus_allowed() if CONFIG_CPUMASK_OFFSTACK=y
      ia64: convert last user of smp_call_function_mask
      cpumask: remove the deprecated smp_call_function_mask()
      cpumask: remove obsolete topology_core_siblings and topology_thread_siblings: core
      cpumask: remove obsolete topology_core_siblings and topology_thread_siblings: sparc
      cpumask: remove obsolete topology_core_siblings and topology_thread_siblings: s390
      cpumask: remove obsolete topology_core_siblings and topology_thread_siblings: powerpc
      cpumask: remove obsolete topology_core_siblings and topology_thread_siblings: ia64
      cpumask: arch_send_call_function_ipi_mask: alpha
      cpumask: arch_send_call_function_ipi_mask: m32r
      cpumask: arch_send_call_function_ipi_mask: mips
      cpumask: arch_send_call_function_ipi_mask: powerpc
      cpumask: arch_send_call_function_ipi_mask: s390
      cpumask: remove arch_send_call_function_ipi
      cpumask: Use accessors for cpu_*_mask: m32r
      cpumask: Use accessors for cpu_*_mask: mips
      cpumask: Use accessors for cpu_*_mask: powerpc
      cpumask: Use accessors for cpu_*_mask: um
      cpumask: use mm_cpumask() wrapper: arm
      cpumask: use mm_cpumask() wrapper: m32r
      cpumask: use mm_cpumask() wrapper: mn10300
      cpumask: use mm_cpumask() wrapper: mips
      cpumask: use mm_cpumask() wrapper: um
      cpumask: use mm_cpumask() wrapper: x86
      cpumask: use new-style cpumask ops in mm/quicklist.
      cpumask: remove unused deprecated functions, avoid accusations of insanity
      cpumask: Move deprecated functions to end of header.

 arch/alpha/include/asm/smp.h                 |    2 +-
 arch/alpha/include/asm/topology.h            |   18 -
 arch/alpha/kernel/smp.c                      |   14 +-
 arch/arm/include/asm/cacheflush.h            |    8 +-
 arch/arm/include/asm/mmu_context.h           |    7 +-
 arch/arm/include/asm/smp.h                   |    1 -
 arch/arm/include/asm/tlbflush.h              |    4 +-
 arch/arm/kernel/smp.c                        |   10 +-
 arch/arm/mm/context.c                        |    2 +-
 arch/arm/mm/flush.c                          |   10 +-
 arch/ia64/include/asm/smp.h                  |    1 -
 arch/ia64/include/asm/topology.h             |    3 -
 arch/ia64/kernel/smp.c                       |    2 +-
 arch/m32r/include/asm/mmu_context.h          |    4 +-
 arch/m32r/include/asm/smp.h                  |    2 +-
 arch/m32r/kernel/smp.c                       |   30 +-
 arch/m32r/kernel/smpboot.c                   |    2 +-
 arch/mips/alchemy/common/time.c              |    2 +-
 arch/mips/include/asm/mach-ip27/topology.h   |    2 -
 arch/mips/include/asm/mmu_context.h          |   10 +-
 arch/mips/include/asm/smp-ops.h              |    2 +-
 arch/mips/include/asm/smp.h                  |    2 +-
 arch/mips/kernel/smp-cmp.c                   |    6 +-
 arch/mips/kernel/smp-mt.c                    |    6 +-
 arch/mips/kernel/smp-up.c                    |    3 +-
 arch/mips/kernel/smp.c                       |    8 +-
 arch/mips/kernel/smtc.c                      |    6 +-
 arch/mips/mipssim/sim_smtc.c                 |    5 +-
 arch/mips/mm/c-octeon.c                      |    2 +-
 arch/mips/mti-malta/malta-smtc.c             |    4 +-
 arch/mips/pmc-sierra/yosemite/smp.c          |    4 +-
 arch/mips/sgi-ip27/ip27-memory.c             |    2 +-
 arch/mips/sgi-ip27/ip27-smp.c                |    4 +-
 arch/mips/sibyte/bcm1480/smp.c               |    5 +-
 arch/mips/sibyte/sb1250/smp.c                |    5 +-
 arch/mn10300/include/asm/mmu_context.h       |   12 +-
 arch/parisc/include/asm/smp.h                |    1 -
 arch/powerpc/include/asm/smp.h               |    2 +-
 arch/powerpc/include/asm/topology.h          |   12 -
 arch/powerpc/kernel/setup-common.c           |    6 +-
 arch/powerpc/kernel/smp.c                    |   12 +-
 arch/powerpc/platforms/powermac/smp.c        |    6 +-
 arch/powerpc/platforms/pseries/hotplug-cpu.c |    6 +-
 arch/s390/include/asm/smp.h                  |    2 +-
 arch/s390/include/asm/topology.h             |    1 -
 arch/s390/kernel/smp.c                       |    4 +-
 arch/sh/include/asm/smp.h                    |    1 -
 arch/sh/include/asm/topology.h               |    1 -
 arch/sparc/include/asm/smp_64.h              |    1 -
 arch/sparc/include/asm/topology_64.h         |   16 -
 arch/um/include/asm/mmu_context.h            |    4 +-
 arch/um/kernel/smp.c                         |    2 +-
 arch/x86/include/asm/mmu_context.h           |    6 +-
 arch/x86/include/asm/smp.h                   |    1 -
 arch/x86/kernel/apic/io_apic.c               |    7 +-
 arch/x86/kernel/ldt.c                        |    4 +-
 arch/x86/kernel/process.c                    |    6 +-
 arch/x86/kernel/smpboot.c                    |    9 +-
 arch/x86/kernel/time.c                       |    1 -
 arch/x86/mm/tlb.c                            |   15 +-
 arch/x86/xen/mmu.c                           |    4 +-
 drivers/acpi/osl.c                           |    2 +-
 drivers/acpi/processor_perflib.c             |    3 +-
 drivers/acpi/processor_throttling.c          |    3 +-
 drivers/net/sfc/efx.c                        |    3 +-
 drivers/oprofile/buffer_sync.c               |    3 +-
 include/asm-generic/topology.h               |   17 -
 include/linux/cpumask.h                      |  709 +++++++++-----------------
 include/linux/interrupt.h                    |    2 -
 include/linux/sched.h                        |    3 +
 include/linux/smp.h                          |   11 -
 include/linux/topology.h                     |    6 -
 init/main.c                                  |    5 -
 kernel/smp.c                                 |    7 -
 kernel/trace/trace.c                         |    7 +-
 mm/quicklist.c                               |    3 +-
 virt/kvm/kvm_main.c                          |    3 +-
 77 files changed, 403 insertions(+), 724 deletions(-)

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754144AbYL0L4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbYL0L4o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 06:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbYL0L4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 06:56:35 -0500
Received: from relay1.sgi.com ([192.48.179.29]:43705 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753383AbYL0L4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 06:56:34 -0500
Message-ID: <495617EF.1040606@sgi.com>
Date: Sat, 27 Dec 2008 03:56:31 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>
Subject: [git pull] cpumask updates for tip/cpus4096
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Please pull the following cpus4096 patches from

  git://git.kernel.org/pub/scm/linux/kernel/git/travis/linux-2.6-cpus4096-for-ingo.git master

This gets us near the end of the arch x86 specific changes to accomodate
the new cpumask API.  Of the original 4000 or so references to the old
"cpumask_t" API there remains 98 references (which 33 are 'cpumask_t'.)

The ultimate goal remains to allocate variable-sized cpumasks, which will
dramatically reduce the memory usage when running configurations built
for 4096 cpus, on systems which have far fewer cpus present in the system.
The main obstruction is functions that reference cpumask bits using NR_CPUS
instead of nr_cpu_ids. 

Included below is the (git) "pull back" of the cpumask patches scheduled
for linux-next to allow integration and testing of more x86-specific
cpumask changes.

Thanks,
Mike

Mike Travis (12):
      cpumask: Add alloc_cpumask_var_node()
      cpumask: documentation for cpumask_var_t
      cpumask: add sysfs displays for configured and disabled cpu maps
      sysfs: add documentation to cputopology.txt for system cpumasks
      Merge branch 'master' of git://.../rusty/linux-2.6-cpumask into tip/cpus4096
      x86: enable cpus display of kernel_max and offlined cpus
      x86: cleanup remaining cpumask_t ops in smpboot code
      sched: put back some stack hog changes that were undone in kernel/sched.c
      x86: cleanup some remaining usages of NR_CPUS where s/b nr_cpu_ids
      x86: cleanup remaining cpumask_t code in mce_amd_64.c
      x86: cleanup remaining cpumask_t code in microcode_core.c
      cpumask: use alloc_cpumask_var_node where appropriate

Rusty Russell (13):
      cpumask: x86: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask
      cpumask: sparc: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask
      cpumask: sh: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask
      cpumask: powerpc: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask
      cpumask: IA64: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask
      cpumask: Mips: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask
      cpumask: alpha: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask
      cpumask: cpu_coregroup_mask(): x86
      cpumask: cpu_coregroup_mask(): sparc
      cpumask: cpu_coregroup_mask(): s390
      cpumask: Replace cpu_coregroup_map with cpu_coregroup_mask
      x86: use cpumask_var_t in acpi/boot.c
      cpumask: convert shared_cpu_map in acpi_processor* structs to cpumask_var_t

 Documentation/cputopology.txt                |   48 +++++++++
 arch/alpha/include/asm/topology.h            |   17 +++
 arch/alpha/kernel/setup.c                    |    5 +
 arch/ia64/include/asm/topology.h             |    7 +-
 arch/ia64/kernel/acpi.c                      |    2 +-
 arch/ia64/kernel/iosapic.c                   |   23 ++--
 arch/ia64/sn/kernel/sn2/sn_hwperf.c          |   27 ++---
 arch/mips/include/asm/mach-ip27/topology.h   |    4 +-
 arch/powerpc/include/asm/topology.h          |   10 ++-
 arch/powerpc/platforms/cell/spu_priv1_mmio.c |    6 +-
 arch/powerpc/platforms/cell/spufs/sched.c    |    4 +-
 arch/s390/include/asm/topology.h             |    1 +
 arch/s390/kernel/topology.c                  |    5 +
 arch/sh/include/asm/topology.h               |    1 +
 arch/sparc/include/asm/topology_64.h         |   11 ++-
 arch/sparc64/kernel/of_device.c              |    2 +-
 arch/sparc64/kernel/pci_msi.c                |    2 +-
 arch/x86/include/asm/es7000/apic.h           |   32 +------
 arch/x86/include/asm/lguest.h                |    2 +-
 arch/x86/include/asm/numaq/apic.h            |    4 +-
 arch/x86/include/asm/pci.h                   |   10 ++-
 arch/x86/include/asm/smp.h                   |   32 ++++++-
 arch/x86/include/asm/summit/apic.h           |   42 ++------
 arch/x86/include/asm/topology.h              |   36 +++++--
 arch/x86/kernel/acpi/boot.c                  |   31 ++++--
 arch/x86/kernel/apic.c                       |    4 +-
 arch/x86/kernel/cpu/common.c                 |   28 ++++-
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c   |   28 +++++-
 arch/x86/kernel/cpu/cpufreq/powernow-k7.c    |    9 ++
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c    |   24 +++--
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c      |   23 +++--
 arch/x86/kernel/cpuid.c                      |    2 +-
 arch/x86/kernel/io_apic.c                    |    6 +-
 arch/x86/kernel/microcode_core.c             |   83 ++++++++-------
 arch/x86/kernel/msr.c                        |    2 +-
 arch/x86/kernel/reboot.c                     |    4 +-
 arch/x86/kernel/setup_percpu.c               |   33 +++++-
 arch/x86/kernel/smp.c                        |   17 ++-
 arch/x86/kernel/smpboot.c                    |  141 ++++++++++++++------------
 arch/x86/mach-voyager/voyager_smp.c          |    7 +-
 block/blk.h                                  |    4 +-
 drivers/acpi/processor_core.c                |   14 ++-
 drivers/acpi/processor_perflib.c             |   28 +++--
 drivers/acpi/processor_throttling.c          |   80 ++++++++++-----
 drivers/base/cpu.c                           |   44 ++++++++
 include/acpi/processor.h                     |    4 +-
 include/linux/cpumask.h                      |    7 ++
 include/linux/smp.h                          |    3 +
 kernel/sched.c                               |   53 +++-------
 kernel/sched_rt.c                            |    3 +-
 lib/cpumask.c                                |   54 +++++++++-
 51 files changed, 690 insertions(+), 379 deletions(-)


Return-Path: <linux-kernel-owner+w=401wt.eu-S1762267AbYDSSNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762267AbYDSSNW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 14:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755879AbYDSSNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 14:13:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45375 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755804AbYDSSNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 14:13:14 -0400
Date: Sat, 19 Apr 2008 20:13:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] scheduler changes for v2.6.26
Message-ID: <20080419181304.GB21353@elte.hu>
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


Linus, please pull the latest scheduler git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git for-linus

The cpumask changes (needed for 4096 CPU support) also touch the x86 
tree - the recent x86.git pull i sent will cleanly merge with this tree, 
in either order. The only real complication the 4K CPU related changes 
have are in the scheduler code - that's why they were merged and tested 
in this tree. They have wider API impact than the scheduler but those 
are straightforward/trivial. It was all tested in linux-next as well.

Thanks!

	Ingo

------------------>
Dhaval Giani (4):
      sched: cleanup cpuacct variable names
      sched: allow cpuacct stats to be reset
      sched: mix tasks and groups
      sched: allow the group scheduler to have multiple levels

Dmitry Adamushko (1):
      latencytop: optimize LT_BACKTRACEDEPTH loops a bit

Gregory Haskins (1):
      sched: fix cpus_allowed settings

Guillaume Chazarain (1):
      sched: fix rq->clock overflows detection with CONFIG_NO_HZ

Hidetoshi Seto (2):
      sched, cpuset: customize sched domains, docs
      sched, cpuset: customize sched domains, core

Ingo Molnar (12):
      sched: re-do "sched: fix fair sleepers"
      sched: make cpu_clock() globally synchronous
      sched: introduce SCHED_FEAT_SYNC_WAKEUPS, turn it off
      sched: feat affine wakeups
      sched: cache hot buddy
      sched: reenable sync wakeups
      sched: remove sysctl_sched_batch_wakeup_granularity
      time: add ns_to_ktime()
      sched: fix checks
      sched: add SCHED_FEAT_DEADLINE
      sched: features fix
      sched: build fix

Mike Travis (21):
      cpumask: add cpumask_scnprintf_len function
      x86: reduce memory and stack usage in intel_cacheinfo
      x86: oprofile: remove NR_CPUS arrays in arch/x86/oprofile/nmi_int.c
      asm-generic: add node_to_cpumask_ptr macro
      numa: move large array from stack to _initdata section
      cpumask: Cleanup more uses of CPU_MASK and NODE_MASK
      sched: remove fixed NR_CPUS sized arrays in kernel_sched_c
      x86: use new set_cpus_allowed_ptr function
      generic: use new set_cpus_allowed_ptr function
      cpuset: modify cpuset_set_cpus_allowed to use cpumask pointer
      generic: reduce stack pressure in sched_affinity
      nodemask: use new node_to_cpumask_ptr function
      cpumask: reduce stack usage in SD_x_INIT initializers
      cpumask: add CPU_MASK_ALL_PTR macro
      x86: convert cpumask_of_cpu macro to allocated array
      x86: modify show_shared_cpu_map in intel_cacheinfo
      cpumask: use new cpus_scnprintf function
      cpumask: add show cpu map functions
      sched: remove another cpumask_t variable from stack
      init: move setup of nr_cpu_ids to as early as possible
      sched: add new set_cpus_allowed_ptr function

Olof Johansson (1):
      tasklets: execute tasklets in the same order they were queued

Peter Zijlstra (17):
      sched: fix wakeup granularity for buddies
      sched: fix regression with sched yield
      sched: rt-group: synchonised bandwidth period
      sched: rt-group: smp balancing
      sched: old sleeper bonus
      sched: fix the task_group hierarchy for UID grouping
      sched: task_group hierarchy
      sched: rt: multi level group constraints
      sched: prepatory code movement
      sched: fair-group: SMP-nice for group scheduling
      sched: debug: add some debug code to handle the full hierarchy
      sched: rt-group: optimize dequeue_rt_stack
      sched: fair-group scheduling vs latency
      sched: fair-group: de-couple load-balancing from the rb-trees
      sched: fair: weight calculations
      sched: debug: show a weight tree
      sched: /debug/sched_features

Reynes Philippe (1):
      sched: sched.c needs tick.h

Viktor Radnai (1):
      sched: better rt-group documentation

 Documentation/cpusets.txt                        |   72 +-
 Documentation/scheduler/sched-rt-group.txt       |  188 ++-
 arch/x86/Kconfig                                 |    3 +
 arch/x86/kernel/acpi/cstate.c                    |    4 +-
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c       |   28 +-
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c        |   32 +-
 arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c |   13 +-
 arch/x86/kernel/cpu/cpufreq/speedstep-ich.c      |   20 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c            |   92 +-
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c          |   46 +-
 arch/x86/kernel/io_apic_64.c                     |    2 +-
 arch/x86/kernel/microcode.c                      |   16 +-
 arch/x86/kernel/reboot.c                         |    2 +-
 arch/x86/kernel/setup.c                          |   28 +-
 arch/x86/mm/numa_64.c                            |    3 +-
 arch/x86/oprofile/nmi_int.c                      |   49 +-
 drivers/acpi/processor_throttling.c              |   10 +-
 drivers/base/cpu.c                               |   48 +
 drivers/base/node.c                              |   29 +-
 drivers/base/topology.c                          |   41 +-
 drivers/firmware/dcdbas.c                        |    4 +-
 drivers/pci/pci-driver.c                         |    9 +-
 drivers/pci/pci-sysfs.c                          |   20 +-
 drivers/pci/probe.c                              |   27 +-
 include/asm-alpha/topology.h                     |    3 +-
 include/asm-frv/topology.h                       |    4 +-
 include/asm-generic/topology.h                   |   14 +
 include/asm-ia64/topology.h                      |    7 +-
 include/asm-powerpc/topology.h                   |    3 +-
 include/asm-sh/topology.h                        |    2 +-
 include/asm-x86/topology.h                       |   22 +-
 include/linux/bitmap.h                           |    1 +
 include/linux/cpumask.h                          |   25 +-
 include/linux/cpuset.h                           |   13 +-
 include/linux/init_task.h                        |    3 +
 include/linux/ktime.h                            |    6 +
 include/linux/sched.h                            |   56 +-
 include/linux/sysdev.h                           |   17 +-
 include/linux/topology.h                         |   46 +-
 init/Kconfig                                     |    7 +
 init/main.c                                      |   24 +-
 kernel/compat.c                                  |    2 +-
 kernel/cpu.c                                     |    6 +-
 kernel/cpuset.c                                  |  100 +-
 kernel/irq/chip.c                                |    2 +-
 kernel/kmod.c                                    |    2 +-
 kernel/kthread.c                                 |    1 +
 kernel/latencytop.c                              |   27 +-
 kernel/rcupreempt.c                              |    4 +-
 kernel/rcutorture.c                              |   15 +-
 kernel/sched.c                                   | 1912 ++++++++++++++++++----
 kernel/sched_debug.c                             |   36 +-
 kernel/sched_fair.c                              |  580 +++++---
 kernel/sched_features.h                          |   10 +
 kernel/sched_rt.c                                |  227 ++-
 kernel/sched_stats.h                             |    8 +-
 kernel/softirq.c                                 |   63 +-
 kernel/stop_machine.c                            |    2 +-
 kernel/sysctl.c                                  |   15 +-
 kernel/time/tick-sched.c                         |    5 -
 kernel/user.c                                    |   30 +-
 lib/bitmap.c                                     |   16 +
 mm/allocpercpu.c                                 |    3 +-
 mm/page_alloc.c                                  |    6 +-
 mm/pdflush.c                                     |    4 +-
 mm/slab.c                                        |    5 +-
 mm/vmscan.c                                      |   18 +-
 net/sunrpc/svc.c                                 |   16 +-
 68 files changed, 3157 insertions(+), 997 deletions(-)
 create mode 100644 kernel/sched_features.h


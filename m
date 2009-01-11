Return-Path: <linux-kernel-owner+w=401wt.eu-S1752362AbZAKGba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbZAKGba (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 01:31:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbZAKGbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 01:31:22 -0500
Received: from relay1.sgi.com ([192.48.179.29]:56437 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750893AbZAKGbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 01:31:21 -0500
Message-ID: <4969922B.5050807@sgi.com>
Date: Sat, 10 Jan 2009 22:31:07 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Jack Steiner <steiner@sgi.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PULL] request for tip/cpus4096
X-Priority: 1 (Highest)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

This is a combined "pull request" of both the 1/8/09 pull request for
'merge-0108' changes for cpumasks, as well as the variable irq patches
for setting nr_irqs based on nr_cpu_ids.

Tested on both SPARSE_IRQS/!SPARSE_IRQS and LARGE/SMALL NR_CPUS.

Thanks,
Mike
---

The following changes since commit 36c401a44abcc389a00f9cd14892c9cf9bf0780d:
  Ingo Molnar (1):
        [IA64] fix typo in cpumask_of_pcibus()

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/travis/linux-2.6-cpus4096-for-ingo.git master

Mike Travis (14):
      cpumask: update irq_desc to use cpumask_var_t
      cpumask: fix bug in use cpumask_var_t in irq_desc
      SGI UV cpumask: use static temp cpumask in flush_tlb
      x86: cleanup remaining cpumask_t code in mce_amd_64.c
      x86: cleanup remaining cpumask_t code in microcode_core.c
      x86: reduce stack usage in init_intel_cacheinfo
      cpumask: use cpumask_var_t in dcdbas.c
      cpumask: reduce stack usage in find_lowest_rq
      Xen: reduce memory required for cpu_evtchn_mask
      irq: change references from NR_IRQS to nr_irqs
      irq: use WARN() instead of WARN_ON().
      irq: allocate irq_desc_ptrs array based on nr_irqs
      irq: initialize nr_irqs based on nr_cpu_ids
      kstat: modify kstat_irqs_legacy to be variable sized

Rusty Russell (5):
      cpumask: Use topology_core_cpumask()/topology_thread_cpumask()
      cpumask: convert misc driver functions
      cpumask: convert drivers/net/sfc
      cpumask: convert other misc kernel functions
      x86: change flush_tlb_others to take a const struct cpumask

 Documentation/cputopology.txt           |    6 +-
 arch/x86/include/asm/apicdef.h          |    8 +--
 arch/x86/include/asm/apicnum.h          |   12 ++++
 arch/x86/include/asm/irq_vectors.h      |   16 ++++--
 arch/x86/include/asm/paravirt.h         |    8 ++-
 arch/x86/include/asm/tlbflush.h         |    8 ++--
 arch/x86/include/asm/uv/uv_bau.h        |    3 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c   |   63 ++++++++++++++++-------
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c |   21 +++++---
 arch/x86/kernel/io_apic.c               |   22 ++++----
 arch/x86/kernel/irq_32.c                |    2 +-
 arch/x86/kernel/irq_64.c                |    2 +-
 arch/x86/kernel/microcode_core.c        |   74 ++++++++++++++++----------
 arch/x86/kernel/tlb_32.c                |   67 ++++++++++--------------
 arch/x86/kernel/tlb_64.c                |   62 ++++++++++++----------
 arch/x86/kernel/tlb_uv.c                |   16 +++---
 arch/x86/xen/enlighten.c                |   31 ++++-------
 drivers/base/cpu.c                      |    2 +-
 drivers/base/topology.c                 |   33 ++++++------
 drivers/firmware/dcdbas.c               |   12 +++--
 drivers/misc/sgi-xp/xpc_main.c          |    2 +-
 drivers/net/sfc/efx.c                   |   17 ++++--
 drivers/oprofile/buffer_sync.c          |   22 +++++++--
 drivers/oprofile/buffer_sync.h          |    4 ++
 drivers/oprofile/oprof.c                |    9 +++-
 drivers/xen/events.c                    |   25 +++++++---
 drivers/xen/manage.c                    |    2 +-
 include/linux/irq.h                     |   86 +++++++++++++++++++++++++++++-
 include/linux/irqnr.h                   |    7 +++
 include/linux/topology.h                |    6 ++
 kernel/irq/chip.c                       |    5 ++-
 kernel/irq/handle.c                     |   57 +++++++++++++--------
 kernel/irq/internals.h                  |    7 +++
 kernel/irq/manage.c                     |   12 ++--
 kernel/irq/migration.c                  |   12 ++--
 kernel/irq/numa_migrate.c               |   19 ++++++-
 kernel/irq/proc.c                       |    4 +-
 kernel/sched_rt.c                       |   36 ++++++++-----
 lib/smp_processor_id.c                  |    2 +-
 39 files changed, 520 insertions(+), 282 deletions(-)
 create mode 100644 arch/x86/include/asm/apicnum.h

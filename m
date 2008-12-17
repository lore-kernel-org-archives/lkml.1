Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753186AbYLQXBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbYLQXBe (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 18:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbYLQXBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 18:01:24 -0500
Received: from relay2.sgi.com ([192.48.179.30]:48035 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752241AbYLQXBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 18:01:24 -0500
Message-ID: <494984C0.4000103@sgi.com>
Date: Wed, 17 Dec 2008 15:01:20 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>, Jack Steiner <steiner@sgi.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] x86/cpumask: fixups and additions
References: <20081216042645.629941000@polaris-admin.engr.sgi.com> <20081216114459.GA21266@elte.hu>
In-Reply-To: <20081216114459.GA21266@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
...
> 
> Since this will all go into tip/cpus4096, would you mind to do a git tree 
> for this stuff?

Hi Ingo,

Please pull the following.

Thanks!
Mike
--- 
The following changes since commit c8cae544bba6aee0f5cb0756dbab1a71d2c68737:
  Mike Travis (1):
        x86: fix build error with post-merge of tip/cpus4096 and rr-for-ingo/master.

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/travis/linux-2.6-cpus4096-for-ingo.git master

Mike Travis (5):
      x86: enable MAXSMP
      x86 smp: modify send_IPI_mask interface to accept cpumask_t pointers
      x86: move and enhance debug printk for nr_cpu_ids etc.
      x86: Add cpu_mask_to_apicid_and
      x86: Update io_apic.c to use new cpumask API

Rusty Russell (11):
      x86: update add-cpu_mask_to_apicid_and to use struct cpumask*
      xen: convert to cpumask_var_t and new cpumask primitives.
      x86: fixup_irqs() doesnt need an argument.
      x86: cosmetic changes apic-related files.
      x86: Set CONFIG_NR_CPUS even on UP
      x86: prepare for cpumask iterators to only go to nr_cpu_ids
      x86: Use cpumask accessors code for possible/present maps.
      x86: Remove cpumask games in x86/kernel/cpu/intel_cacheinfo.c
      x86: use work_on_cpu in x86/kernel/cpu/mcheck/mce_amd_64.c
      x86: xen: use smp_call_function_many()
      x86: Introduce topology_core_cpumask()/topology_thread_cpumask()

 arch/x86/Kconfig                              |   13 +-
 arch/x86/include/asm/bigsmp/apic.h            |   30 ++-
 arch/x86/include/asm/bigsmp/ipi.h             |   13 +-
 arch/x86/include/asm/es7000/apic.h            |   86 +++++--
 arch/x86/include/asm/es7000/ipi.h             |   12 +-
 arch/x86/include/asm/genapic_32.h             |   13 +-
 arch/x86/include/asm/genapic_64.h             |   14 +-
 arch/x86/include/asm/ipi.h                    |   23 ++-
 arch/x86/include/asm/irq.h                    |    2 +-
 arch/x86/include/asm/mach-default/mach_apic.h |   27 ++-
 arch/x86/include/asm/mach-default/mach_ipi.h  |   18 +-
 arch/x86/include/asm/mach-generic/mach_apic.h |    1 +
 arch/x86/include/asm/numaq/apic.h             |   12 +-
 arch/x86/include/asm/numaq/ipi.h              |   13 +-
 arch/x86/include/asm/smp.h                    |    6 +-
 arch/x86/include/asm/summit/apic.h            |   51 ++++-
 arch/x86/include/asm/summit/ipi.h             |    9 +-
 arch/x86/include/asm/topology.h               |    2 +
 arch/x86/kernel/apic.c                        |   12 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c         |   41 ++--
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c       |  108 ++++----
 arch/x86/kernel/crash.c                       |    5 +-
 arch/x86/kernel/genapic_flat_64.c             |  105 ++++++--
 arch/x86/kernel/genx2apic_cluster.c           |   77 ++++--
 arch/x86/kernel/genx2apic_phys.c              |   72 ++++--
 arch/x86/kernel/genx2apic_uv_x.c              |   59 +++--
 arch/x86/kernel/io_apic.c                     |  341 ++++++++++++-------------
 arch/x86/kernel/ipi.c                         |   28 ++-
 arch/x86/kernel/irq_32.c                      |   13 +-
 arch/x86/kernel/irq_64.c                      |   15 +-
 arch/x86/kernel/setup_percpu.c                |   17 +-
 arch/x86/kernel/smp.c                         |    8 +-
 arch/x86/kernel/smpboot.c                     |    2 +-
 arch/x86/kernel/tlb_32.c                      |    2 +-
 arch/x86/kernel/tlb_64.c                      |    2 +-
 arch/x86/mach-generic/bigsmp.c                |    5 +-
 arch/x86/mach-generic/es7000.c                |    5 +-
 arch/x86/mach-generic/numaq.c                 |    5 +-
 arch/x86/mach-generic/summit.c                |    5 +-
 arch/x86/mach-voyager/voyager_smp.c           |    2 +-
 arch/x86/mm/numa_64.c                         |    4 +-
 arch/x86/mm/srat_64.c                         |    2 +-
 arch/x86/xen/mmu.c                            |   20 +-
 arch/x86/xen/smp.c                            |   27 +-
 arch/x86/xen/suspend.c                        |    3 +-
 arch/x86/xen/xen-ops.h                        |    2 +-
 46 files changed, 824 insertions(+), 508 deletions(-)

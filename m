Return-Path: <linux-kernel-owner+w=401wt.eu-S1754026AbYLID6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbYLID6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 22:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbYLID6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 22:58:17 -0500
Received: from ozlabs.org ([203.10.76.45]:58589 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbYLID6Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 22:58:16 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@redhat.com>
Subject: [PULL] x86 cpumask changes for large NR_CPUS
Date: Tue, 9 Dec 2008 14:28:09 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: Mike Travis <travis@sgi.com>, linux-kernel@vger.kernel.org,
       Robert Richter <robert.richter@amd.com>, jacob.shin@amd.com,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Jeremy Fitzhardinge <jeremy@xensource.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200812091428.10400.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-ingo.git

This merges your cpus4096 branch with the cpumask tree, and applies the
x86 patches on top.  There will be more, but this should be ready for
testing and linux-next.

>From now on, I'm handing responsibility for x86 large cpumasks over to
Mike Travis, and I'll be sending *him* patches.

Mike Travis (5):
      x86: enable MAXSMP
      x86 smp: modify send_IPI_mask interface to accept cpumask_t pointers
      x86: move and enhance debug printk for nr_cpu_ids etc.              
      x86: Add cpu_mask_to_apicid_and                                     
      x86: final cleanups in io_apic to use new cpumask API               

Rusty Russell (16):
      x86: update add-cpu_mask_to_apicid_and to use struct cpumask*
      x86: io_apic: change irq_cfg domain & old_domain to cpumask_var_t
      x86: io_apic: set_desc_affinity()                                
      x86: io_apic: send_cleanup_vector()                              
      x86: io_apic: eliminate remaining cpumask_ts from stack          
      x86: fix cpu_mask_to_apicid_cluster() to take cpumask *          
      xen: convert to cpumask_var_t and new cpumask primitives.        
      x86: fixup_irqs() doesn't need an argument.                      
      x86: cosmetic changes apic-related files.                        
      x86: Set CONFIG_NR_CPUS even on UP                               
      x86: prepare for cpumask iterators to only go to nr_cpu_ids      
      x86: Use cpumask accessors code for possible/present maps.       
      x86: Remove cpumask games in x86/kernel/cpu/intel_cacheinfo.c    
      x86: use work_on_cpu in x86/kernel/cpu/mcheck/mce_amd_64.c       
      x86: xen: use smp_call_function_many()                           
      cpumask: Introduce topology_core_cpumask()/topology_thread_cpumask(): x86

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
 arch/x86/kernel/genx2apic_cluster.c           |   77 +++++--
 arch/x86/kernel/genx2apic_phys.c              |   72 ++++--
 arch/x86/kernel/genx2apic_uv_x.c              |   59 +++--
 arch/x86/kernel/io_apic.c                     |  333 +++++++++++--------------
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
 arch/x86/xen/mmu.c                            |   20 ++-
 arch/x86/xen/smp.c                            |   27 ++-
 arch/x86/xen/suspend.c                        |    3 +-
 arch/x86/xen/xen-ops.h                        |    2 +-
 46 files changed, 808 insertions(+), 516 deletions(-)


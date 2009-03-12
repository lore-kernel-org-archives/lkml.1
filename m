Return-Path: <linux-kernel-owner+w=401wt.eu-S1755971AbZCLEYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbZCLEYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 00:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753717AbZCLEXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 00:23:52 -0400
Received: from ozlabs.org ([203.10.76.45]:40641 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755118AbZCLEXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 00:23:51 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PULL] x86 cpumask work
Date: Thu, 12 Mar 2009 14:53:44 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, Mike Travis <travis@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903121453.45163.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phew.  One core patch (the first one), the rest x86-specific.

This doesn't quite get rid of all the cpumask_t and old cpus functions:
the rest are either the work_on_cpus patches (which will come separately)
or require core changes which are in my tree.

Thanks!
Rusty.

The following changes since commit 8851485ba842e892adfa343463ce6b74550bb8b1:    
  Ingo Molnar (1):                                                              
        Merge branch 'x86/urgent'                                               

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-x86.git cpus4096

Rusty Russell (21):
      cpumask: replace node_to_cpumask with cpumask_of_node.
      cpumask: remove dangerous CPU_MASK_ALL_PTR, &CPU_MASK_ALL.: x86
      cpumask: remove the now-obsoleted pcibus_to_cpumask(): x86     
      cpumask: remove cpu_coregroup_map: x86                         
      cpumask: remove obsolete topology_core_siblings and topology_thread_siblings: x86                                                                         
      cpumask: convert c1e_mask in arch/x86/kernel/process.c to cpumask_var_t.  
      cpumask: convert arch/x86/kernel/nmi.c's backtrace_mask to a cpumask_var_t
      cpumask: x86: convert cpu_sibling_map/cpu_core_map to cpumask_var_t       
      cpumask: convert arch/x86/kernel/cpu/mcheck/mce_64.c                      
      x86: arch_send_call_function_ipi_mask                                     
      cpumask: remove x86's node_to_cpumask now everyone uses cpumask_of_node   
      x86: unify 32 and 64-bit node_to_cpumask_map                              
      cpumask: convert node_to_cpumask_map[] to cpumask_var_t                   
      cpumask: convert struct cpuinfo_x86's llc_shared_map to cpumask_var_t     
      x86: unify cpu_callin_mask/cpu_callout_mask/cpu_initialized_mask/cpu_sibling_setup_mask                                                                   
      cpumask: use new cpumask functions throughout x86                         
      cpumask: clean up summit's send_IPI functions                             
      cpumask: make Xen use the new operators.                                  
      cpumask: remove cpumask_t assignment from vector_allocation_domain()      
      cpumask: use cpumask_var_t in uv_flush_tlb_others.                        
      cpumask: remove x86 cpumask_t uses.                                       

 arch/x86/include/asm/cpumask.h              |   18 -----
 arch/x86/include/asm/pci.h                  |    5 -    
 arch/x86/include/asm/processor.h            |    2 +-   
 arch/x86/include/asm/smp.h                  |   13 ++-- 
 arch/x86/include/asm/topology.h             |   89 +++++-----------------
 arch/x86/kernel/apic/bigsmp_32.c            |   16 ++--                  
 arch/x86/kernel/apic/es7000_32.c            |   17 ++--                  
 arch/x86/kernel/apic/nmi.c                  |   11 ++-                   
 arch/x86/kernel/apic/numaq_32.c             |   11 ++-                   
 arch/x86/kernel/apic/probe_32.c             |    3 +-                    
 arch/x86/kernel/apic/summit_32.c            |   21 ++---                 
 arch/x86/kernel/cpu/common.c                |   12 ---                   
 arch/x86/kernel/cpu/cpufreq/p4-clockmod.c   |    2 +-                    
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c   |   13 ++-                   
 arch/x86/kernel/cpu/cpufreq/speedstep-ich.c |    2 +-                    
 arch/x86/kernel/cpu/mcheck/mce_64.c         |   10 ++-                   
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c     |    6 +-                    
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c   |    2 +-                    
 arch/x86/kernel/cpu/proc.c                  |    6 +-                    
 arch/x86/kernel/process.c                   |   12 ++-
 arch/x86/kernel/smpboot.c                   |   51 ++++++------
 arch/x86/kernel/tlb_uv.c                    |    9 ++-
 arch/x86/mm/Makefile                        |    2 +-
 arch/x86/mm/numa.c                          |   67 ++++++++++++++++
 arch/x86/mm/numa_64.c                       |  111 ++-------------------------
 arch/x86/oprofile/op_model_p4.c             |    2 +-
 arch/x86/xen/smp.c                          |    6 +-
 drivers/base/node.c                         |    2 +-
 drivers/pci/pci-driver.c                    |    3 +-
 drivers/xen/cpu_hotplug.c                   |    4 +-
 include/linux/topology.h                    |    6 +-
 mm/page_alloc.c                             |    6 +-
 mm/quicklist.c                              |    2 +-
 mm/slab.c                                   |    2 +-
 mm/vmscan.c                                 |    6 +-
 net/sunrpc/svc.c                            |    3 +-
 36 files changed, 223 insertions(+), 330 deletions(-)
 create mode 100644 arch/x86/mm/numa.c

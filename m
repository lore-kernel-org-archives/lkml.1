Return-Path: <linux-kernel-owner+w=401wt.eu-S933679AbZDBAKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933679AbZDBAKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 20:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758103AbZDBAJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 20:09:48 -0400
Received: from ozlabs.org ([203.10.76.45]:38358 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888AbZDBAJl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 20:09:41 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] x86 cpumask updates (plus a few generic pre-req cpumask cleanups)
Date: Thu, 2 Apr 2009 10:39:21 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Robert Richter <robert.richter@amd.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, x86@kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904021039.22979.rusty@rustcorp.com.au>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(This is Ingo's cpus4096 branch which has been in linux-next for some weeks,
 with a trivial merge.)

The following changes since commit 15f7176eb1cccec0a332541285ee752b935c1c85:                                    
  Linus Torvalds (1):                                                                                           
        Merge git://git.kernel.org/.../davem/net-2.6                                                            

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-cpumask master

Heiko Carstens (1):
      sysrq: include interrupt.h instead of irq.h

Hiroshi Shimamoto (1):
      x86: intel_cacheinfo: fix compiler warning

Ingo Molnar (6):
      fix warning in arch/x86/kernel/cpu/intel_cacheinfo.c
      Merge branch 'x86/core' into cpus4096               
      Merge commit 'v2.6.29-rc8' into cpus4096            
      Merge branch 'cpus4096' of git://git.kernel.org/.../rusty/linux-2.6-x86 into cpus4096
      x86: microcode: cleanup                                                              
      Merge branch 'linus' into cpumask-for-linus                                          

Robert Richter (1):
      cpumask: modifiy oprofile initialization

Rusty Russell (31):
      cpumask: use topology_core_cpumask/topology_thread_cpumask instead of cpu_core_map/cpu_sibling_map
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
      cpumask: convert node_to_cpumask_map[] to cpumask_var_t                                           
      numa, cpumask: move numa_node_id default implementation to topology.h                             
      cpumask: fix CONFIG_CPUMASK_OFFSTACK=y cpu hotunplug crash                                        
      x86: cpumask: use work_on_cpu in arch/x86/kernel/microcode_core.c                                 
      x86: cpumask: update 32-bit APM not to mug current->cpus_allowed                                  
      x86: cpumask: x86 mmio-mod.c use cpumask_var_t for downed_cpus                                    
      cpumask: remove cpumask allocation from idle_balance                                              
      cpumask: remove cpumask allocation from idle_balance, fix                                         
      Merge branch 'cpumask-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip                    

Stephen Rothwell (1):
      numa, cpumask: move numa_node_id default implementation to topology.h, fix

 arch/powerpc/include/asm/mmzone.h           |    1 +
 arch/sparc/include/asm/mmzone.h             |    2 +
 arch/x86/include/asm/cpumask.h              |   18 --
 arch/x86/include/asm/pci.h                  |    5 - 
 arch/x86/include/asm/processor.h            |    3 +-
 arch/x86/include/asm/smp.h                  |   13 +-
 arch/x86/include/asm/topology.h             |   87 ++--------
 arch/x86/kernel/apic/bigsmp_32.c            |   16 +-        
 arch/x86/kernel/apic/es7000_32.c            |   17 +-        
 arch/x86/kernel/apic/nmi.c                  |   11 +-        
 arch/x86/kernel/apic/numaq_32.c             |   11 +-        
 arch/x86/kernel/apic/probe_32.c             |    3 +-        
 arch/x86/kernel/apic/summit_32.c            |   21 +--       
 arch/x86/kernel/apm_32.c                    |  248 ++++++++++++++++-----------
 arch/x86/kernel/cpu/common.c                |   13 +--                        
 arch/x86/kernel/cpu/cpufreq/p4-clockmod.c   |    2 +-                         
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c   |   13 +-                         
 arch/x86/kernel/cpu/cpufreq/speedstep-ich.c |    2 +-                         
 arch/x86/kernel/cpu/intel_cacheinfo.c       |   24 ++--                       
 arch/x86/kernel/cpu/mcheck/mce_64.c         |   10 +-                         
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c     |    6 +-                         
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c   |    2 +-                         
 arch/x86/kernel/cpu/proc.c                  |    6 +-                         
 arch/x86/kernel/microcode_amd.c             |   43 +++---                     
 arch/x86/kernel/microcode_core.c            |  160 ++++++++++--------         
 arch/x86/kernel/microcode_intel.c           |   83 +++++----                  
 arch/x86/kernel/process.c                   |   20 ++-                        
 arch/x86/kernel/smpboot.c                   |   70 +++++---                   
 arch/x86/kernel/tlb_uv.c                    |    9 +-                         
 arch/x86/mm/Makefile                        |    2 +-                         
 arch/x86/mm/mmio-mod.c                      |   19 ++-                        
 arch/x86/mm/numa.c                          |   67 +++++++                    
 arch/x86/mm/numa_64.c                       |  111 +-----------               
 arch/x86/oprofile/op_model_p4.c             |    2 +-                         
 arch/x86/xen/smp.c                          |    6 +-                         
 block/blk.h                                 |    2 +-                         
 drivers/base/node.c                         |    2 +-                         
 drivers/char/sysrq.c                        |    2 +-                         
 drivers/oprofile/buffer_sync.c              |   20 +--                        
 drivers/oprofile/buffer_sync.h              |    4 -                          
 drivers/oprofile/oprof.c                    |    9 +-                         
 drivers/pci/pci-driver.c                    |    3 +-                         
 drivers/xen/cpu_hotplug.c                   |    4 +-                         
 include/linux/gfp.h                         |    1 +                          
 include/linux/mmzone.h                      |    6 -                          
 include/linux/topology.h                    |   11 +-                         
 kernel/sched.c                              |   43 +++---                     
 mm/page_alloc.c                             |    6 +-                         
 mm/quicklist.c                              |    2 +-                         
 mm/slab.c                                   |    2 +-                         
 mm/vmscan.c                                 |    6 +-                         
 net/sunrpc/svc.c                            |    3 +-                         
 52 files changed, 616 insertions(+), 636 deletions(-)                         
 create mode 100644 arch/x86/mm/numa.c                                         

commit 4c50d9ea9ca9e46b65aeffed3e0d6f54ff38c8d4
Author: Robert Richter <robert.richter@amd.com>
Date:   Thu Jan 22 14:14:14 2009 +0100

    cpumask: modifiy oprofile initialization
    
    Delta patch to f7df8ed164996cd2c6aca9674388be6ef78d8b37 for
    tip/cpus4096.
    
    Moved initialization to sync_start()/sync_stop(). No changes needed in
    buffer_sync.h and oprof.c anymore.
    
    Signed-off-by: Robert Richter <robert.richter@amd.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/oprofile/buffer_sync.c |   20 ++++++--------------
 drivers/oprofile/buffer_sync.h |    4 ----
 drivers/oprofile/oprof.c       |    9 +--------
 3 files changed, 7 insertions(+), 26 deletions(-)

diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index c3ea5fa..8574622 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -154,6 +154,10 @@ int sync_start(void)
 {
 	int err;
 
+	if (!alloc_cpumask_var(&marked_cpus, GFP_KERNEL))
+		return -ENOMEM;
+	cpumask_clear(marked_cpus);
+
 	start_cpu_work();
 
 	err = task_handoff_register(&task_free_nb);
@@ -179,6 +183,7 @@ out2:
 	task_handoff_unregister(&task_free_nb);
 out1:
 	end_sync();
+	free_cpumask_var(marked_cpus);
 	goto out;
 }
 
@@ -190,6 +195,7 @@ void sync_stop(void)
 	profile_event_unregister(PROFILE_TASK_EXIT, &task_exit_nb);
 	task_handoff_unregister(&task_free_nb);
 	end_sync();
+	free_cpumask_var(marked_cpus);
 }
 
 
@@ -565,20 +571,6 @@ void sync_buffer(int cpu)
 	mutex_unlock(&buffer_mutex);
 }
 
-int __init buffer_sync_init(void)
-{
-	if (!alloc_cpumask_var(&marked_cpus, GFP_KERNEL))
-		return -ENOMEM;
-
-	cpumask_clear(marked_cpus);
-		return 0;
-}
-
-void __exit buffer_sync_cleanup(void)
-{
-	free_cpumask_var(marked_cpus);
-}
-
 /* The function can be used to add a buffer worth of data directly to
  * the kernel buffer. The buffer is assumed to be a circular buffer.
  * Take the entries from index start and end at index end, wrapping
diff --git a/drivers/oprofile/buffer_sync.h b/drivers/oprofile/buffer_sync.h
index 0ebf5db..3110732 100644
--- a/drivers/oprofile/buffer_sync.h
+++ b/drivers/oprofile/buffer_sync.h
@@ -19,8 +19,4 @@ void sync_stop(void);
 /* sync the given CPU's buffer */
 void sync_buffer(int cpu);
 
-/* initialize/destroy the buffer system. */
-int buffer_sync_init(void);
-void buffer_sync_cleanup(void);
-
 #endif /* OPROFILE_BUFFER_SYNC_H */
diff --git a/drivers/oprofile/oprof.c b/drivers/oprofile/oprof.c
index ced39f6..3cffce9 100644
--- a/drivers/oprofile/oprof.c
+++ b/drivers/oprofile/oprof.c
@@ -183,10 +183,6 @@ static int __init oprofile_init(void)
 {
 	int err;
 
-	err = buffer_sync_init();
-	if (err)
-		return err;
-
 	err = oprofile_arch_init(&oprofile_ops);
 
 	if (err < 0 || timer) {
@@ -195,10 +191,8 @@ static int __init oprofile_init(void)
 	}
 
 	err = oprofilefs_register();
-	if (err) {
+	if (err)
 		oprofile_arch_exit();
-		buffer_sync_cleanup();
-	}
 
 	return err;
 }
@@ -208,7 +202,6 @@ static void __exit oprofile_exit(void)
 {
 	oprofilefs_unregister();
 	oprofile_arch_exit();
-	buffer_sync_cleanup();
 }
 
 

commit 0ee2ad84d36760c8e36a6a6729998dc7a4eacf38
Author: Heiko Carstens <heiko.carstens@de.ibm.com>
Date:   Mon Jan 26 06:45:10 2009 -0800

    sysrq: include interrupt.h instead of irq.h
    
    Impact: fix compile error on s390.
    
    With "cpumask: update irq_desc to use cpumask_var_t" in linux-next
    we get this compile bug on s390:
    
      CC      drivers/char/sysrq.o
    In file included from drivers/char/sysrq.c:38:
    include/linux/irq.h: In function 'init_alloc_desc_masks':
    include/linux/irq.h:442: error: dereferencing pointer to incomplete type
    
    Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
    Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
    Signed-off-by: Mike Travis <travis@sgi.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/char/sysrq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
index d41b9f6..59214db 100644
--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -35,7 +35,7 @@
 #include <linux/vt_kern.h>
 #include <linux/workqueue.h>
 #include <linux/kexec.h>
-#include <linux/irq.h>
+#include <linux/interrupt.h>
 #include <linux/hrtimer.h>
 #include <linux/oom.h>
 

commit bd0838fc48c174cd386447059a414318e78169e1
Author: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Date:   Mon Jan 26 18:08:47 2009 -0800

    x86: intel_cacheinfo: fix compiler warning
    
    fix the following warning:
    
      CC      arch/x86/kernel/cpu/intel_cacheinfo.o
      arch/x86/kernel/cpu/intel_cacheinfo.c:314: warning: 'cpuid4_cache_lookup' defined but not used
    
    Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 58527a9..51b5dfd 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -309,15 +309,6 @@ __cpuinit cpuid4_cache_lookup_regs(int index,
 	return 0;
 }
 
-static int
-__cpuinit cpuid4_cache_lookup(int index, struct _cpuid4_info *this_leaf)
-{
-	struct _cpuid4_info_regs *leaf_regs =
-		(struct _cpuid4_info_regs *)this_leaf;
-
-	return cpuid4_cache_lookup_regs(index, leaf_regs);
-}
-
 static int __cpuinit find_num_cache_leaves(void)
 {
 	unsigned int		eax, ebx, ecx, edx;
@@ -556,6 +547,15 @@ static void __cpuinit free_cache_attributes(unsigned int cpu)
 	per_cpu(cpuid4_info, cpu) = NULL;
 }
 
+static int
+__cpuinit cpuid4_cache_lookup(int index, struct _cpuid4_info *this_leaf)
+{
+	struct _cpuid4_info_regs *leaf_regs =
+		(struct _cpuid4_info_regs *)this_leaf;
+
+	return cpuid4_cache_lookup_regs(index, leaf_regs);
+}
+
 static void __cpuinit get_cpu_leaves(void *_retval)
 {
 	int j, *retval = _retval, cpu = smp_processor_id();

commit ba1d755a36f66101aa88ac9ebb54694def6ec38d
Author: Ingo Molnar <mingo@elte.hu>
Date:   Sat Oct 18 21:24:45 2008 +0200

    fix warning in arch/x86/kernel/cpu/intel_cacheinfo.c
    
    fix this warning:
    
      arch/x86/kernel/cpu/intel_cacheinfo.c:139: warning: ‘k8_nb_id’ defined but not used
      arch/x86/kernel/cpu/intel_cacheinfo.c:527: warning: ‘free_cache_attributes’ defined but not used
      arch/x86/kernel/cpu/intel_cacheinfo.c:538: warning: ‘detect_cache_attributes’ defined but not used
    
    Unused variables in the !CONFIG_SYSCTL case.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 51b5dfd..03f93c5 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -144,7 +144,7 @@ struct _cpuid4_info_regs {
 	unsigned long can_disable;
 };
 
-#ifdef CONFIG_PCI
+#if defined(CONFIG_PCI) && defined(CONFIG_SYSFS)
 static struct pci_device_id k8_nb_id[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x1103) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x1203) },
@@ -484,6 +484,8 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 	return l2;
 }
 
+#ifdef CONFIG_SYSFS
+
 /* pointer to _cpuid4_info array (for each cache leaf) */
 static DEFINE_PER_CPU(struct _cpuid4_info *, cpuid4_info);
 #define CPUID4_INFO_IDX(x, y)	(&((per_cpu(cpuid4_info, x))[y]))
@@ -597,8 +599,6 @@ static int __cpuinit detect_cache_attributes(unsigned int cpu)
 	return retval;
 }
 
-#ifdef CONFIG_SYSFS
-
 #include <linux/kobject.h>
 #include <linux/sysfs.h>
 

commit d95c3578120e5bc4784069439f00ccb1b5f87717
Merge: ba1d755... 78b020d...
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Mar 11 10:49:34 2009 +0100

    Merge branch 'x86/core' into cpus4096

commit c69fc56de1df5769f2ec69c915c7ad5afe63804c
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Mar 13 14:49:46 2009 +1030

    cpumask: use topology_core_cpumask/topology_thread_cpumask instead of cpu_core_map/cpu_sibling_map
    
    Impact: cleanup
    
    This is presumably what those definitions are for, and while all archs
    define cpu_core_map/cpu_sibling map, that's changing (eg. x86 wants to
    change it to a pointer).
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 block/blk.h    |    2 +-
 kernel/sched.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/block/blk.h b/block/blk.h
index 0dce92c..3ee9435 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -102,7 +102,7 @@ static inline int blk_cpu_to_group(int cpu)
 	const struct cpumask *mask = cpu_coregroup_mask(cpu);
 	return cpumask_first(mask);
 #elif defined(CONFIG_SCHED_SMT)
-	return first_cpu(per_cpu(cpu_sibling_map, cpu));
+	return cpumask_first(topology_thread_cpumask(cpu));
 #else
 	return cpu;
 #endif
diff --git a/kernel/sched.c b/kernel/sched.c
index 0a76d0b..5dabd80 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7249,7 +7249,7 @@ cpu_to_core_group(int cpu, const struct cpumask *cpu_map,
 {
 	int group;
 
-	cpumask_and(mask, &per_cpu(cpu_sibling_map, cpu), cpu_map);
+	cpumask_and(mask, topology_thread_cpumask(cpu), cpu_map);
 	group = cpumask_first(mask);
 	if (sg)
 		*sg = &per_cpu(sched_group_core, group).sg;
@@ -7278,7 +7278,7 @@ cpu_to_phys_group(int cpu, const struct cpumask *cpu_map,
 	cpumask_and(mask, cpu_coregroup_mask(cpu), cpu_map);
 	group = cpumask_first(mask);
 #elif defined(CONFIG_SCHED_SMT)
-	cpumask_and(mask, &per_cpu(cpu_sibling_map, cpu), cpu_map);
+	cpumask_and(mask, topology_thread_cpumask(cpu), cpu_map);
 	group = cpumask_first(mask);
 #else
 	group = cpu;
@@ -7621,7 +7621,7 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 		SD_INIT(sd, SIBLING);
 		set_domain_attribute(sd, attr);
 		cpumask_and(sched_domain_span(sd),
-			    &per_cpu(cpu_sibling_map, i), cpu_map);
+			    topology_thread_cpumask(i), cpu_map);
 		sd->parent = p;
 		p->child = sd;
 		cpu_to_cpu_group(i, cpu_map, &sd->groups, tmpmask);
@@ -7632,7 +7632,7 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 	/* Set up CPU (sibling) groups */
 	for_each_cpu(i, cpu_map) {
 		cpumask_and(this_sibling_map,
-			    &per_cpu(cpu_sibling_map, i), cpu_map);
+			    topology_thread_cpumask(i), cpu_map);
 		if (i != cpumask_first(this_sibling_map))
 			continue;
 

commit a70f730282019f487aa33a84e5ac9a5e89c5abd0
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Mar 13 14:49:46 2009 +1030

    cpumask: replace node_to_cpumask with cpumask_of_node.
    
    Impact: cleanup
    
    node_to_cpumask (and the blecherous node_to_cpumask_ptr which
    contained a declaration) are replaced now everyone implements
    cpumask_of_node.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/base/node.c      |    2 +-
 drivers/pci/pci-driver.c |    3 +--
 include/linux/topology.h |    6 +-----
 mm/page_alloc.c          |    6 +++---
 mm/quicklist.c           |    2 +-
 mm/slab.c                |    2 +-
 mm/vmscan.c              |    6 ++++--
 net/sunrpc/svc.c         |    3 +--
 8 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index f8f578a..40b8097 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -24,7 +24,7 @@ static struct sysdev_class node_class = {
 static ssize_t node_read_cpumap(struct sys_device *dev, int type, char *buf)
 {
 	struct node *node_dev = to_node(dev);
-	node_to_cpumask_ptr(mask, node_dev->sysdev.id);
+	const struct cpumask *mask = cpumask_of_node(node_dev->sysdev.id);
 	int len;
 
 	/* 2008/04/07: buf currently PAGE_SIZE, need 9 chars per 32 bits. */
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 93eac14..b522f88 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -212,10 +212,9 @@ static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
 	node = dev_to_node(&dev->dev);
 	if (node >= 0) {
 		int cpu;
-		node_to_cpumask_ptr(nodecpumask, node);
 
 		get_online_cpus();
-		cpu = cpumask_any_and(nodecpumask, cpu_online_mask);
+		cpu = cpumask_any_and(cpumask_of_node(node), cpu_online_mask);
 		if (cpu < nr_cpu_ids)
 			error = work_on_cpu(cpu, local_pci_probe, &ddi);
 		else
diff --git a/include/linux/topology.h b/include/linux/topology.h
index a16b9e0..16b7d68 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -38,11 +38,7 @@
 #endif
 
 #ifndef nr_cpus_node
-#define nr_cpus_node(node)				\
-	({						\
-		node_to_cpumask_ptr(__tmp__, node);	\
-		cpus_weight(*__tmp__);			\
-	})
+#define nr_cpus_node(node) cpumask_weight(cpumask_of_node(node))
 #endif
 
 #define for_each_node_with_cpus(node)			\
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5c44ed4..a92b097 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2134,7 +2134,7 @@ static int find_next_best_node(int node, nodemask_t *used_node_mask)
 	int n, val;
 	int min_val = INT_MAX;
 	int best_node = -1;
-	node_to_cpumask_ptr(tmp, 0);
+	const struct cpumask *tmp = cpumask_of_node(0);
 
 	/* Use the local node if we haven't already */
 	if (!node_isset(node, *used_node_mask)) {
@@ -2155,8 +2155,8 @@ static int find_next_best_node(int node, nodemask_t *used_node_mask)
 		val += (n < node);
 
 		/* Give preference to headless and unused nodes */
-		node_to_cpumask_ptr_next(tmp, n);
-		if (!cpus_empty(*tmp))
+		tmp = cpumask_of_node(n);
+		if (!cpumask_empty(tmp))
 			val += PENALTY_FOR_NODE_WITH_CPUS;
 
 		/* Slight preference for less loaded node */
diff --git a/mm/quicklist.c b/mm/quicklist.c
index 8dbb680..e66d07d 100644
--- a/mm/quicklist.c
+++ b/mm/quicklist.c
@@ -29,7 +29,7 @@ static unsigned long max_pages(unsigned long min_pages)
 	int node = numa_node_id();
 	struct zone *zones = NODE_DATA(node)->node_zones;
 	int num_cpus_on_node;
-	node_to_cpumask_ptr(cpumask_on_node, node);
+	const struct cpumask *cpumask_on_node = cpumask_of_node(node);
 
 	node_free_pages =
 #ifdef CONFIG_ZONE_DMA
diff --git a/mm/slab.c b/mm/slab.c
index 4d00855..2daaca0 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1160,7 +1160,7 @@ static void __cpuinit cpuup_canceled(long cpu)
 	struct kmem_cache *cachep;
 	struct kmem_list3 *l3 = NULL;
 	int node = cpu_to_node(cpu);
-	node_to_cpumask_ptr(mask, node);
+	const struct cpumask *mask = cpumask_of_node(node);
 
 	list_for_each_entry(cachep, &cache_chain, next) {
 		struct array_cache *nc;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6177e3b..cc61355 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1963,7 +1963,7 @@ static int kswapd(void *p)
 	struct reclaim_state reclaim_state = {
 		.reclaimed_slab = 0,
 	};
-	node_to_cpumask_ptr(cpumask, pgdat->node_id);
+	const struct cpumask *cpumask = cpumask_of_node(pgdat->node_id);
 
 	if (!cpumask_empty(cpumask))
 		set_cpus_allowed_ptr(tsk, cpumask);
@@ -2198,7 +2198,9 @@ static int __devinit cpu_callback(struct notifier_block *nfb,
 	if (action == CPU_ONLINE || action == CPU_ONLINE_FROZEN) {
 		for_each_node_state(nid, N_HIGH_MEMORY) {
 			pg_data_t *pgdat = NODE_DATA(nid);
-			node_to_cpumask_ptr(mask, pgdat->node_id);
+			const struct cpumask *mask;
+
+			mask = cpumask_of_node(pgdat->node_id);
 
 			if (cpumask_any_and(cpu_online_mask, mask) < nr_cpu_ids)
 				/* One of our CPUs online: restore mask */
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index c51fed4..3bdd5bf 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -317,8 +317,7 @@ svc_pool_map_set_cpumask(struct task_struct *task, unsigned int pidx)
 	}
 	case SVC_POOL_PERNODE:
 	{
-		node_to_cpumask_ptr(nodecpumask, node);
-		set_cpus_allowed_ptr(task, nodecpumask);
+		set_cpus_allowed_ptr(task, cpumask_of_node(node));
 		break;
 	}
 	}

commit 101aaca1f32d9923331ddc63a7a72b3a7f934c02
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Mar 13 14:49:47 2009 +1030

    cpumask: remove dangerous CPU_MASK_ALL_PTR, &CPU_MASK_ALL.: x86
    
    Impact: cleanup
    
    (Thanks to Al Viro for reminding me of this, via Ingo)
    
    CPU_MASK_ALL is the (deprecated) "all bits set" cpumask, defined as so:
    
    	#define CPU_MASK_ALL (cpumask_t) { { ... } }
    
    Taking the address of such a temporary is questionable at best,
    unfortunately 321a8e9d (cpumask: add CPU_MASK_ALL_PTR macro) added
    CPU_MASK_ALL_PTR:
    
    	#define CPU_MASK_ALL_PTR (&CPU_MASK_ALL)
    
    Which formalizes this practice.  One day gcc could bite us over this
    usage (though we seem to have gotten away with it so far).
    
    So replace everywhere which used &CPU_MASK_ALL or CPU_MASK_ALL_PTR
    with the modern "cpu_all_mask" (a real const struct cpumask *), and remove
    CPU_MASK_ALL_PTR altogether.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Acked-by: Ingo Molnar <mingo@elte.hu>
    Reported-by: Al Viro <viro@zeniv.linux.org.uk>
    Cc: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/apic/es7000_32.c |    2 +-
 arch/x86/kernel/apic/numaq_32.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 19588f2..1322f54 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -457,7 +457,7 @@ static int es7000_apic_id_registered(void)
 
 static const cpumask_t *target_cpus_cluster(void)
 {
-	return &CPU_MASK_ALL;
+	return cpu_all_mask;
 }
 
 static const cpumask_t *es7000_target_cpus(void)
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index ba2fc64..e4ce98a 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -336,7 +336,7 @@ static inline void numaq_smp_callin_clear_local_apic(void)
 
 static inline const cpumask_t *numaq_target_cpus(void)
 {
-	return &CPU_MASK_ALL;
+	return cpu_all_mask;
 }
 
 static inline unsigned long

commit cb3d560f36c1e4aa3c26a1d79e9b6e62ab69896c
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Mar 13 14:49:47 2009 +1030

    cpumask: remove the now-obsoleted pcibus_to_cpumask(): x86
    
    Impact: reduce stack usage for large NR_CPUS
    
    cpumask_of_pcibus() is the new version.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/include/asm/pci.h      |    5 -----
 arch/x86/include/asm/topology.h |    1 -
 2 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index a977de2..93c8dc3 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -109,11 +109,6 @@ static inline int __pcibus_to_node(const struct pci_bus *bus)
 	return sd->node;
 }
 
-static inline cpumask_t __pcibus_to_cpumask(struct pci_bus *bus)
-{
-	return node_to_cpumask(__pcibus_to_node(bus));
-}
-
 static inline const struct cpumask *
 cpumask_of_pcibus(const struct pci_bus *bus)
 {
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 77cfb2c..d772fac 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -143,7 +143,6 @@ extern void setup_node_to_cpumask_map(void);
 #define parent_node(node) (node)
 
 #define pcibus_to_node(bus) __pcibus_to_node(bus)
-#define pcibus_to_cpumask(bus) __pcibus_to_cpumask(bus)
 
 #ifdef CONFIG_X86_32
 extern unsigned long node_start_pfn[];

commit 23c5c9c66263311de1295b42382e5bc1e7c36c47
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Mar 13 14:49:48 2009 +1030

    cpumask: remove cpu_coregroup_map: x86
    
    Impact: cleanup
    
    cpu_coregroup_mask is the New Hotness.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/include/asm/topology.h |    1 -
 arch/x86/kernel/smpboot.c       |    5 -----
 2 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index d772fac..6b954fb 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -244,7 +244,6 @@ static inline int node_to_first_cpu(int node)
 }
 #endif
 
-extern cpumask_t cpu_coregroup_map(int cpu);
 extern const struct cpumask *cpu_coregroup_mask(int cpu);
 
 #ifdef ENABLE_TOPO_DEFINES
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index ef7d101..f534257 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -428,11 +428,6 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
 		return &c->llc_shared_map;
 }
 
-cpumask_t cpu_coregroup_map(int cpu)
-{
-	return *cpu_coregroup_mask(cpu);
-}
-
 static void impress_friends(void)
 {
 	int cpu;

commit d3d2e7f24384cccedd29a0582ad4b014ac646abc
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Mar 13 14:49:48 2009 +1030

    cpumask: remove obsolete topology_core_siblings and topology_thread_siblings: x86
    
    Impact: cleanup
    
    There were replaced by topology_core_cpumask and topology_thread_cpumask.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/include/asm/topology.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 6b954fb..f7c20d0 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -249,8 +249,6 @@ extern const struct cpumask *cpu_coregroup_mask(int cpu);
 #ifdef ENABLE_TOPO_DEFINES
 #define topology_physical_package_id(cpu)	(cpu_data(cpu).phys_proc_id)
 #define topology_core_id(cpu)			(cpu_data(cpu).cpu_core_id)
-#define topology_core_siblings(cpu)		(per_cpu(cpu_core_map, cpu))
-#define topology_thread_siblings(cpu)		(per_cpu(cpu_sibling_map, cpu))
 #define topology_core_cpumask(cpu)		(&per_cpu(cpu_core_map, cpu))
 #define topology_thread_cpumask(cpu)		(&per_cpu(cpu_sibling_map, cpu))
 

commit bc9b83dd1f66402b870301c3c7117b9c1484abb4
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Mar 13 14:49:49 2009 +1030

    cpumask: convert c1e_mask in arch/x86/kernel/process.c to cpumask_var_t.
    
    Impact: reduce kernel size when CONFIG_CPUMASK_OFFSTACK=y
    
    Simple conversion.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/kernel/process.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 6afa523..cad5431 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -474,12 +474,12 @@ static int __cpuinit check_c1e_idle(const struct cpuinfo_x86 *c)
 	return 1;
 }
 
-static cpumask_t c1e_mask = CPU_MASK_NONE;
+static cpumask_var_t c1e_mask;
 static int c1e_detected;
 
 void c1e_remove_cpu(int cpu)
 {
-	cpu_clear(cpu, c1e_mask);
+	cpumask_clear_cpu(cpu, c1e_mask);
 }
 
 /*
@@ -508,8 +508,8 @@ static void c1e_idle(void)
 	if (c1e_detected) {
 		int cpu = smp_processor_id();
 
-		if (!cpu_isset(cpu, c1e_mask)) {
-			cpu_set(cpu, c1e_mask);
+		if (!cpumask_test_cpu(cpu, c1e_mask)) {
+			cpumask_set_cpu(cpu, c1e_mask);
 			/*
 			 * Force broadcast so ACPI can not interfere. Needs
 			 * to run with interrupts enabled as it uses
@@ -556,6 +556,8 @@ void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 		pm_idle = mwait_idle;
 	} else if (check_c1e_idle(c)) {
 		printk(KERN_INFO "using C1E aware idle routine\n");
+		alloc_cpumask_var(&c1e_mask, GFP_KERNEL);
+		cpumask_clear(c1e_mask);
 		pm_idle = c1e_idle;
 	} else
 		pm_idle = default_idle;

commit fcef8576d8a64fc603e719c97d423f9f6d4e0e8b
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Mar 13 14:49:49 2009 +1030

    cpumask: convert arch/x86/kernel/nmi.c's backtrace_mask to a cpumask_var_t
    
    Impact: cleanup, reduce memory usage for CONFIG_CPUMASK_OFFSTACK=y
    
    I *think* every path calls check_nmi_watchdog before using the
    watchdog, so that's the right place for the initialization.
    
    If that's wrong, we'll get a nice NULL-deref with
    CONFIG_CPUMASK_OFFSTACK=y, and have uncovered another bug.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/kernel/apic/nmi.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
index bdfad80..d6bd624 100644
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -39,7 +39,7 @@
 int unknown_nmi_panic;
 int nmi_watchdog_enabled;
 
-static cpumask_t backtrace_mask = CPU_MASK_NONE;
+static cpumask_var_t backtrace_mask;
 
 /* nmi_active:
  * >0: the lapic NMI watchdog is active, but can be disabled
@@ -138,6 +138,7 @@ int __init check_nmi_watchdog(void)
 	if (!prev_nmi_count)
 		goto error;
 
+	alloc_cpumask_var(&backtrace_mask, GFP_KERNEL);
 	printk(KERN_INFO "Testing NMI watchdog ... ");
 
 #ifdef CONFIG_SMP
@@ -413,14 +414,14 @@ nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 		touched = 1;
 	}
 
-	if (cpu_isset(cpu, backtrace_mask)) {
+	if (cpumask_test_cpu(cpu, backtrace_mask)) {
 		static DEFINE_SPINLOCK(lock);	/* Serialise the printks */
 
 		spin_lock(&lock);
 		printk(KERN_WARNING "NMI backtrace for cpu %d\n", cpu);
 		dump_stack();
 		spin_unlock(&lock);
-		cpu_clear(cpu, backtrace_mask);
+		cpumask_clear_cpu(cpu, backtrace_mask);
 	}
 
 	/* Could check oops_in_progress here too, but it's safer not to */
@@ -554,10 +555,10 @@ void __trigger_all_cpu_backtrace(void)
 {
 	int i;
 
-	backtrace_mask = cpu_online_map;
+	cpumask_copy(backtrace_mask, cpu_online_mask);
 	/* Wait for up to 10 seconds for all CPUs to do the backtrace */
 	for (i = 0; i < 10 * 1000; i++) {
-		if (cpus_empty(backtrace_mask))
+		if (cpumask_empty(backtrace_mask))
 			break;
 		mdelay(1);
 	}

commit 7ad728f98162cb1af06a85b2a5fc422dddd4fb78
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Mar 13 14:49:50 2009 +1030

    cpumask: x86: convert cpu_sibling_map/cpu_core_map to cpumask_var_t
    
    Impact: reduce per-cpu size for CONFIG_CPUMASK_OFFSTACK=y
    
    In most places it's cleaner to use the accessors cpu_sibling_mask()
    and cpu_core_mask() wrappers which already exist.
    
    I couldn't avoid cleaning up the access in oprofile, either.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/include/asm/smp.h                  |    8 ++++----
 arch/x86/include/asm/topology.h             |    6 +++---
 arch/x86/kernel/cpu/cpufreq/p4-clockmod.c   |    2 +-
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c   |   13 ++++++++-----
 arch/x86/kernel/cpu/cpufreq/speedstep-ich.c |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c     |    6 +++---
 arch/x86/kernel/cpu/proc.c                  |    2 +-
 arch/x86/kernel/smpboot.c                   |   12 ++++++++++--
 arch/x86/oprofile/op_model_p4.c             |    2 +-
 9 files changed, 32 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 47d0e21..cfb10f1 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -21,19 +21,19 @@
 extern int smp_num_siblings;
 extern unsigned int num_processors;
 
-DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
-DECLARE_PER_CPU(cpumask_t, cpu_core_map);
+DECLARE_PER_CPU(cpumask_var_t, cpu_sibling_map);
+DECLARE_PER_CPU(cpumask_var_t, cpu_core_map);
 DECLARE_PER_CPU(u16, cpu_llc_id);
 DECLARE_PER_CPU(int, cpu_number);
 
 static inline struct cpumask *cpu_sibling_mask(int cpu)
 {
-	return &per_cpu(cpu_sibling_map, cpu);
+	return per_cpu(cpu_sibling_map, cpu);
 }
 
 static inline struct cpumask *cpu_core_mask(int cpu)
 {
-	return &per_cpu(cpu_core_map, cpu);
+	return per_cpu(cpu_core_map, cpu);
 }
 
 DECLARE_EARLY_PER_CPU(u16, x86_cpu_to_apicid);
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index f7c20d0..fa4aa42 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -249,8 +249,8 @@ extern const struct cpumask *cpu_coregroup_mask(int cpu);
 #ifdef ENABLE_TOPO_DEFINES
 #define topology_physical_package_id(cpu)	(cpu_data(cpu).phys_proc_id)
 #define topology_core_id(cpu)			(cpu_data(cpu).cpu_core_id)
-#define topology_core_cpumask(cpu)		(&per_cpu(cpu_core_map, cpu))
-#define topology_thread_cpumask(cpu)		(&per_cpu(cpu_sibling_map, cpu))
+#define topology_core_cpumask(cpu)		(per_cpu(cpu_core_map, cpu))
+#define topology_thread_cpumask(cpu)		(per_cpu(cpu_sibling_map, cpu))
 
 /* indicates that pointers to the topology cpumask_t maps are valid */
 #define arch_provides_topology_pointers		yes
@@ -264,7 +264,7 @@ struct pci_bus;
 void set_pci_bus_resources_arch_default(struct pci_bus *b);
 
 #ifdef CONFIG_SMP
-#define mc_capable()	(cpus_weight(per_cpu(cpu_core_map, 0)) != nr_cpu_ids)
+#define mc_capable()	(cpumask_weight(cpu_core_mask(0)) != nr_cpu_ids)
 #define smt_capable()			(smp_num_siblings > 1)
 #endif
 
diff --git a/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c b/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
index 3178c3a..d8341d1 100644
--- a/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
+++ b/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
@@ -203,7 +203,7 @@ static int cpufreq_p4_cpu_init(struct cpufreq_policy *policy)
 	unsigned int i;
 
 #ifdef CONFIG_SMP
-	cpumask_copy(policy->cpus, &per_cpu(cpu_sibling_map, policy->cpu));
+	cpumask_copy(policy->cpus, cpu_sibling_mask(policy->cpu));
 #endif
 
 	/* Errata workaround */
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 6428aa1..e8fd76f 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -56,7 +56,10 @@ static DEFINE_PER_CPU(struct powernow_k8_data *, powernow_data);
 static int cpu_family = CPU_OPTERON;
 
 #ifndef CONFIG_SMP
-DEFINE_PER_CPU(cpumask_t, cpu_core_map);
+static inline const struct cpumask *cpu_core_mask(int cpu)
+{
+	return cpumask_of(0);
+}
 #endif
 
 /* Return a frequency in MHz, given an input fid */
@@ -654,7 +657,7 @@ static int fill_powernow_table(struct powernow_k8_data *data, struct pst_s *pst,
 
 	dprintk("cfid 0x%x, cvid 0x%x\n", data->currfid, data->currvid);
 	data->powernow_table = powernow_table;
-	if (first_cpu(per_cpu(cpu_core_map, data->cpu)) == data->cpu)
+	if (cpumask_first(cpu_core_mask(data->cpu)) == data->cpu)
 		print_basics(data);
 
 	for (j = 0; j < data->numps; j++)
@@ -808,7 +811,7 @@ static int powernow_k8_cpu_init_acpi(struct powernow_k8_data *data)
 
 	/* fill in data */
 	data->numps = data->acpi_data.state_count;
-	if (first_cpu(per_cpu(cpu_core_map, data->cpu)) == data->cpu)
+	if (cpumask_first(cpu_core_mask(data->cpu)) == data->cpu)
 		print_basics(data);
 	powernow_k8_acpi_pst_values(data, 0);
 
@@ -1224,7 +1227,7 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 	if (cpu_family == CPU_HW_PSTATE)
 		cpumask_copy(pol->cpus, cpumask_of(pol->cpu));
 	else
-		cpumask_copy(pol->cpus, &per_cpu(cpu_core_map, pol->cpu));
+		cpumask_copy(pol->cpus, cpu_core_mask(pol->cpu));
 	data->available_cores = pol->cpus;
 
 	if (cpu_family == CPU_HW_PSTATE)
@@ -1286,7 +1289,7 @@ static unsigned int powernowk8_get (unsigned int cpu)
 	unsigned int khz = 0;
 	unsigned int first;
 
-	first = first_cpu(per_cpu(cpu_core_map, cpu));
+	first = cpumask_first(cpu_core_mask(cpu));
 	data = per_cpu(powernow_data, first);
 
 	if (!data)
diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c b/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
index dedc1e9..1f0ec83 100644
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
@@ -322,7 +322,7 @@ static int speedstep_cpu_init(struct cpufreq_policy *policy)
 
 	/* only run on CPU to be set, or on its sibling */
 #ifdef CONFIG_SMP
-	cpumask_copy(policy->cpus, &per_cpu(cpu_sibling_map, policy->cpu));
+	cpumask_copy(policy->cpus, cpu_sibling_mask(policy->cpu));
 #endif
 
 	cpus_allowed = current->cpus_allowed;
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
index c5a32f9..1f429ee 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -477,7 +477,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 
 #ifdef CONFIG_SMP
 	if (cpu_data(cpu).cpu_core_id && shared_bank[bank]) {	/* symlink */
-		i = cpumask_first(&per_cpu(cpu_core_map, cpu));
+		i = cpumask_first(cpu_core_mask(cpu));
 
 		/* first core not up yet */
 		if (cpu_data(i).cpu_core_id)
@@ -497,7 +497,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 		if (err)
 			goto out;
 
-		cpumask_copy(b->cpus, &per_cpu(cpu_core_map, cpu));
+		cpumask_copy(b->cpus, cpu_core_mask(cpu));
 		per_cpu(threshold_banks, cpu)[bank] = b;
 		goto out;
 	}
@@ -521,7 +521,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 #ifndef CONFIG_SMP
 	cpumask_setall(b->cpus);
 #else
-	cpumask_copy(b->cpus, &per_cpu(cpu_core_map, cpu));
+	cpumask_copy(b->cpus, cpu_core_mask(cpu));
 #endif
 
 	per_cpu(threshold_banks, cpu)[bank] = b;
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index d67e0e4..4dd610e 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -14,7 +14,7 @@ static void show_cpuinfo_core(struct seq_file *m, struct cpuinfo_x86 *c,
 	if (c->x86_max_cores * smp_num_siblings > 1) {
 		seq_printf(m, "physical id\t: %d\n", c->phys_proc_id);
 		seq_printf(m, "siblings\t: %d\n",
-			   cpus_weight(per_cpu(cpu_core_map, cpu)));
+			   cpumask_weight(cpu_sibling_mask(cpu)));
 		seq_printf(m, "core id\t\t: %d\n", c->cpu_core_id);
 		seq_printf(m, "cpu cores\t: %d\n", c->booted_cores);
 		seq_printf(m, "apicid\t\t: %d\n", c->apicid);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index f534257..7f051c1 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -101,11 +101,11 @@ EXPORT_SYMBOL(smp_num_siblings);
 DEFINE_PER_CPU(u16, cpu_llc_id) = BAD_APICID;
 
 /* representing HT siblings of each logical CPU */
-DEFINE_PER_CPU(cpumask_t, cpu_sibling_map);
+DEFINE_PER_CPU(cpumask_var_t, cpu_sibling_map);
 EXPORT_PER_CPU_SYMBOL(cpu_sibling_map);
 
 /* representing HT and core siblings of each logical CPU */
-DEFINE_PER_CPU(cpumask_t, cpu_core_map);
+DEFINE_PER_CPU(cpumask_var_t, cpu_core_map);
 EXPORT_PER_CPU_SYMBOL(cpu_core_map);
 
 /* Per CPU bogomips and other parameters */
@@ -1026,6 +1026,8 @@ static void __init smp_cpu_index_default(void)
  */
 void __init native_smp_prepare_cpus(unsigned int max_cpus)
 {
+	unsigned int i;
+
 	preempt_disable();
 	smp_cpu_index_default();
 	current_cpu_data = boot_cpu_data;
@@ -1039,6 +1041,12 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	boot_cpu_logical_apicid = logical_smp_processor_id();
 #endif
 	current_thread_info()->cpu = 0;  /* needed? */
+	for_each_possible_cpu(i) {
+		alloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
+		alloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
+		cpumask_clear(per_cpu(cpu_core_map, i));
+		cpumask_clear(per_cpu(cpu_sibling_map, i));
+	}
 	set_cpu_sibling_map(0);
 
 	enable_IR_x2apic();
diff --git a/arch/x86/oprofile/op_model_p4.c b/arch/x86/oprofile/op_model_p4.c
index 4c4a51c..819b131 100644
--- a/arch/x86/oprofile/op_model_p4.c
+++ b/arch/x86/oprofile/op_model_p4.c
@@ -380,7 +380,7 @@ static unsigned int get_stagger(void)
 {
 #ifdef CONFIG_SMP
 	int cpu = smp_processor_id();
-	return (cpu != first_cpu(per_cpu(cpu_sibling_map, cpu)));
+	return cpu != cpumask_first(__get_cpu_var(cpu_sibling_map));
 #endif
 	return 0;
 }

commit 996867d0965775dfa62447d0bddb5dc6818a7892
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Mar 13 14:49:51 2009 +1030

    cpumask: convert arch/x86/kernel/cpu/mcheck/mce_64.c
    
    Impact: reduce kernel memory usage when CONFIG_CPUMASK_OFFSTACK=y
    
    Simple conversion of mce_device_initialized to cpumask_var_t.  We don't
    check the alloc_cpumask_var() return since it's boot-time only, and
    the misc_register() in that same function isn't checked.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/kernel/cpu/mcheck/mce_64.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
index ca14604..863f895 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -990,7 +990,7 @@ static struct sysdev_attribute *mce_attributes[] = {
 	NULL
 };
 
-static cpumask_t mce_device_initialized = CPU_MASK_NONE;
+static cpumask_var_t mce_device_initialized;
 
 /* Per cpu sysdev init.  All of the cpus still share the same ctl bank */
 static __cpuinit int mce_create_device(unsigned int cpu)
@@ -1021,7 +1021,7 @@ static __cpuinit int mce_create_device(unsigned int cpu)
 		if (err)
 			goto error2;
 	}
-	cpu_set(cpu, mce_device_initialized);
+	cpumask_set_cpu(cpu, mce_device_initialized);
 
 	return 0;
 error2:
@@ -1043,7 +1043,7 @@ static __cpuinit void mce_remove_device(unsigned int cpu)
 {
 	int i;
 
-	if (!cpu_isset(cpu, mce_device_initialized))
+	if (!cpumask_test_cpu(cpu, mce_device_initialized))
 		return;
 
 	for (i = 0; mce_attributes[i]; i++)
@@ -1053,7 +1053,7 @@ static __cpuinit void mce_remove_device(unsigned int cpu)
 		sysdev_remove_file(&per_cpu(device_mce, cpu),
 			&bank_attrs[i]);
 	sysdev_unregister(&per_cpu(device_mce,cpu));
-	cpu_clear(cpu, mce_device_initialized);
+	cpumask_clear_cpu(cpu, mce_device_initialized);
 }
 
 /* Make sure there are no machine checks on offlined CPUs. */
@@ -1162,6 +1162,8 @@ static __init int mce_init_device(void)
 	if (!mce_available(&boot_cpu_data))
 		return -EIO;
 
+	alloc_cpumask_var(&mce_device_initialized, GFP_KERNEL);
+
 	err = mce_init_banks();
 	if (err)
 		return err;

commit b643decad6c80b6886a01a8c2229be6b7951ff7b
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Mar 13 14:49:51 2009 +1030

    x86: arch_send_call_function_ipi_mask
    
    Impact: implement new API
    
    We define arch_send_call_function_ipi_mask and generic kernel/smp.c
    code creates arch_send_call_function_ipi() as a wrapper.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/include/asm/smp.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index cfb10f1..19e0d88 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -121,9 +121,10 @@ static inline void arch_send_call_function_single_ipi(int cpu)
 	smp_ops.send_call_func_single_ipi(cpu);
 }
 
-static inline void arch_send_call_function_ipi(cpumask_t mask)
+#define arch_send_call_function_ipi_mask arch_send_call_function_ipi_mask
+static inline void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 {
-	smp_ops.send_call_func_ipi(&mask);
+	smp_ops.send_call_func_ipi(mask);
 }
 
 void cpu_disable_common(void);

commit b9c4398ed43a7ed023e091610c23ba7412aec2a8
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Mar 13 14:49:52 2009 +1030

    cpumask: remove x86's node_to_cpumask now everyone uses cpumask_of_node
    
    Impact: cleanup
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/include/asm/topology.h |   41 ---------------------------------------
 arch/x86/mm/numa_64.c           |   26 ------------------------
 2 files changed, 0 insertions(+), 67 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index fa4aa42..216a960 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -57,17 +57,6 @@ static inline int cpu_to_node(int cpu)
 }
 #define early_cpu_to_node(cpu)	cpu_to_node(cpu)
 
-/* Returns a bitmask of CPUs on Node 'node'.
- *
- * Side note: this function creates the returned cpumask on the stack
- * so with a high NR_CPUS count, excessive stack space is used.  The
- * cpumask_of_node function should be used whenever possible.
- */
-static inline cpumask_t node_to_cpumask(int node)
-{
-	return node_to_cpumask_map[node];
-}
-
 /* Returns a bitmask of CPUs on Node 'node'. */
 static inline const struct cpumask *cpumask_of_node(int node)
 {
@@ -92,7 +81,6 @@ DECLARE_PER_CPU(int, node_number);
 extern int cpu_to_node(int cpu);
 extern int early_cpu_to_node(int cpu);
 extern const cpumask_t *cpumask_of_node(int node);
-extern cpumask_t node_to_cpumask(int node);
 
 #else	/* !CONFIG_DEBUG_PER_CPU_MAPS */
 
@@ -114,26 +102,10 @@ static inline const cpumask_t *cpumask_of_node(int node)
 	return &node_to_cpumask_map[node];
 }
 
-/* Returns a bitmask of CPUs on Node 'node'. */
-static inline cpumask_t node_to_cpumask(int node)
-{
-	return node_to_cpumask_map[node];
-}
-
 #endif /* !CONFIG_DEBUG_PER_CPU_MAPS */
 
 extern void setup_node_to_cpumask_map(void);
 
-/*
- * Replace default node_to_cpumask_ptr with optimized version
- * Deprecated: use "const struct cpumask *mask = cpumask_of_node(node)"
- */
-#define node_to_cpumask_ptr(v, node)		\
-		const cpumask_t *v = cpumask_of_node(node)
-
-#define node_to_cpumask_ptr_next(v, node)	\
-			   v = cpumask_of_node(node)
-
 #endif /* CONFIG_X86_64 */
 
 /*
@@ -212,10 +184,6 @@ static inline const cpumask_t *cpumask_of_node(int node)
 {
 	return &cpu_online_map;
 }
-static inline cpumask_t node_to_cpumask(int node)
-{
-	return cpu_online_map;
-}
 static inline int node_to_first_cpu(int node)
 {
 	return first_cpu(cpu_online_map);
@@ -223,15 +191,6 @@ static inline int node_to_first_cpu(int node)
 
 static inline void setup_node_to_cpumask_map(void) { }
 
-/*
- * Replace default node_to_cpumask_ptr with optimized version
- * Deprecated: use "const struct cpumask *mask = cpumask_of_node(node)"
- */
-#define node_to_cpumask_ptr(v, node)		\
-		const cpumask_t *v = cpumask_of_node(node)
-
-#define node_to_cpumask_ptr_next(v, node)	\
-			   v = cpumask_of_node(node)
 #endif
 
 #include <asm-generic/topology.h>
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 64c9cf0..48bf396 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -827,32 +827,6 @@ const cpumask_t *cpumask_of_node(int node)
 EXPORT_SYMBOL(cpumask_of_node);
 
 /*
- * Returns a bitmask of CPUs on Node 'node'.
- *
- * Side note: this function creates the returned cpumask on the stack
- * so with a high NR_CPUS count, excessive stack space is used.  The
- * node_to_cpumask_ptr function should be used whenever possible.
- */
-cpumask_t node_to_cpumask(int node)
-{
-	if (node_to_cpumask_map == NULL) {
-		printk(KERN_WARNING
-			"node_to_cpumask(%d): no node_to_cpumask_map!\n", node);
-		dump_stack();
-		return cpu_online_map;
-	}
-	if (node >= nr_node_ids) {
-		printk(KERN_WARNING
-			"node_to_cpumask(%d): node > nr_node_ids(%d)\n",
-			node, nr_node_ids);
-		dump_stack();
-		return cpu_mask_none;
-	}
-	return node_to_cpumask_map[node];
-}
-EXPORT_SYMBOL(node_to_cpumask);
-
-/*
  * --------- end of debug versions of the numa functions ---------
  */
 

commit 71ee73e72228775a076a502b3c92028fa59e2889
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Mar 13 14:49:52 2009 +1030

    x86: unify 32 and 64-bit node_to_cpumask_map
    
    Impact: cleanup
    
    We take the 64-bit code and use it on 32-bit as well.  The new file
    is called mm/numa.c.
    
    In a minor cleanup, we use cpu_none_mask instead of declaring a local
    cpu_mask_none.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/include/asm/topology.h |   30 ++++++----------
 arch/x86/kernel/smpboot.c       |    5 ---
 arch/x86/mm/Makefile            |    2 +-
 arch/x86/mm/numa.c              |   71 +++++++++++++++++++++++++++++++++++++++
 arch/x86/mm/numa_64.c           |   69 -------------------------------------
 5 files changed, 83 insertions(+), 94 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 216a960..dc31d92 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -44,9 +44,6 @@
 
 #ifdef CONFIG_X86_32
 
-/* Mappings between node number and cpus on that node. */
-extern cpumask_t node_to_cpumask_map[];
-
 /* Mappings between logical cpu number and node number */
 extern int cpu_to_node_map[];
 
@@ -57,19 +54,8 @@ static inline int cpu_to_node(int cpu)
 }
 #define early_cpu_to_node(cpu)	cpu_to_node(cpu)
 
-/* Returns a bitmask of CPUs on Node 'node'. */
-static inline const struct cpumask *cpumask_of_node(int node)
-{
-	return &node_to_cpumask_map[node];
-}
-
-static inline void setup_node_to_cpumask_map(void) { }
-
 #else /* CONFIG_X86_64 */
 
-/* Mappings between node number and cpus on that node. */
-extern cpumask_t *node_to_cpumask_map;
-
 /* Mappings between logical cpu number and node number */
 DECLARE_EARLY_PER_CPU(int, x86_cpu_to_node_map);
 
@@ -80,7 +66,6 @@ DECLARE_PER_CPU(int, node_number);
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
 extern int cpu_to_node(int cpu);
 extern int early_cpu_to_node(int cpu);
-extern const cpumask_t *cpumask_of_node(int node);
 
 #else	/* !CONFIG_DEBUG_PER_CPU_MAPS */
 
@@ -96,18 +81,25 @@ static inline int early_cpu_to_node(int cpu)
 	return early_per_cpu(x86_cpu_to_node_map, cpu);
 }
 
+#endif /* !CONFIG_DEBUG_PER_CPU_MAPS */
+
+#endif /* CONFIG_X86_64 */
+
+/* Mappings between node number and cpus on that node. */
+extern cpumask_t *node_to_cpumask_map;
+
+#ifdef CONFIG_DEBUG_PER_CPU_MAPS
+extern const cpumask_t *cpumask_of_node(int node);
+#else
 /* Returns a pointer to the cpumask of CPUs on Node 'node'. */
 static inline const cpumask_t *cpumask_of_node(int node)
 {
 	return &node_to_cpumask_map[node];
 }
-
-#endif /* !CONFIG_DEBUG_PER_CPU_MAPS */
+#endif
 
 extern void setup_node_to_cpumask_map(void);
 
-#endif /* CONFIG_X86_64 */
-
 /*
  * Returns the number of the node containing Node 'node'. This
  * architecture is flat, so it is a pretty simple function!
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 7f051c1..c55639b 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -115,11 +115,6 @@ EXPORT_PER_CPU_SYMBOL(cpu_info);
 atomic_t init_deasserted;
 
 #if defined(CONFIG_NUMA) && defined(CONFIG_X86_32)
-
-/* which logical CPUs are on which nodes */
-cpumask_t node_to_cpumask_map[MAX_NUMNODES] __read_mostly =
-				{ [0 ... MAX_NUMNODES-1] = CPU_MASK_NONE };
-EXPORT_SYMBOL(node_to_cpumask_map);
 /* which node each logical CPU is on */
 int cpu_to_node_map[NR_CPUS] __read_mostly = { [0 ... NR_CPUS-1] = 0 };
 EXPORT_SYMBOL(cpu_to_node_map);
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 0853774..fdd30d0 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -14,7 +14,7 @@ obj-$(CONFIG_MMIOTRACE)		+= mmiotrace.o
 mmiotrace-y			:= kmmio.o pf_in.o mmio-mod.o
 obj-$(CONFIG_MMIOTRACE_TEST)	+= testmmiotrace.o
 
-obj-$(CONFIG_NUMA)		+= numa_$(BITS).o
+obj-$(CONFIG_NUMA)		+= numa.o numa_$(BITS).o
 obj-$(CONFIG_K8_NUMA)		+= k8topology_64.o
 obj-$(CONFIG_ACPI_NUMA)		+= srat_$(BITS).o
 
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
new file mode 100644
index 0000000..f3a19e9
--- /dev/null
+++ b/arch/x86/mm/numa.c
@@ -0,0 +1,71 @@
+/* Common code for 32 and 64-bit NUMA */
+#include <linux/topology.h>
+#include <linux/module.h>
+#include <linux/bootmem.h>
+
+#ifdef CONFIG_DEBUG_PER_CPU_MAPS
+# define DBG(x...) printk(KERN_DEBUG x)
+#else
+# define DBG(x...)
+#endif
+
+/*
+ * Which logical CPUs are on which nodes
+ */
+cpumask_t *node_to_cpumask_map;
+EXPORT_SYMBOL(node_to_cpumask_map);
+
+/*
+ * Allocate node_to_cpumask_map based on number of available nodes
+ * Requires node_possible_map to be valid.
+ *
+ * Note: node_to_cpumask() is not valid until after this is done.
+ * (Use CONFIG_DEBUG_PER_CPU_MAPS to check this.)
+ */
+void __init setup_node_to_cpumask_map(void)
+{
+	unsigned int node, num = 0;
+	cpumask_t *map;
+
+	/* setup nr_node_ids if not done yet */
+	if (nr_node_ids == MAX_NUMNODES) {
+		for_each_node_mask(node, node_possible_map)
+			num = node;
+		nr_node_ids = num + 1;
+	}
+
+	/* allocate the map */
+	map = alloc_bootmem_low(nr_node_ids * sizeof(cpumask_t));
+	DBG("node_to_cpumask_map at %p for %d nodes\n", map, nr_node_ids);
+
+	pr_debug("Node to cpumask map at %p for %d nodes\n",
+		 map, nr_node_ids);
+
+	/* node_to_cpumask() will now work */
+	node_to_cpumask_map = map;
+}
+
+#ifdef CONFIG_DEBUG_PER_CPU_MAPS
+/*
+ * Returns a pointer to the bitmask of CPUs on Node 'node'.
+ */
+const cpumask_t *cpumask_of_node(int node)
+{
+	if (node_to_cpumask_map == NULL) {
+		printk(KERN_WARNING
+			"cpumask_of_node(%d): no node_to_cpumask_map!\n",
+			node);
+		dump_stack();
+		return cpu_online_mask;
+	}
+	if (node >= nr_node_ids) {
+		printk(KERN_WARNING
+			"cpumask_of_node(%d): node > nr_node_ids(%d)\n",
+			node, nr_node_ids);
+		dump_stack();
+		return cpu_none_mask;
+	}
+	return &node_to_cpumask_map[node];
+}
+EXPORT_SYMBOL(cpumask_of_node);
+#endif
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 48bf396..eee1490 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -20,12 +20,6 @@
 #include <asm/acpi.h>
 #include <asm/k8.h>
 
-#ifdef CONFIG_DEBUG_PER_CPU_MAPS
-# define DBG(x...) printk(KERN_DEBUG x)
-#else
-# define DBG(x...)
-#endif
-
 struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
 EXPORT_SYMBOL(node_data);
 
@@ -49,12 +43,6 @@ DEFINE_EARLY_PER_CPU(int, x86_cpu_to_node_map, NUMA_NO_NODE);
 EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_node_map);
 
 /*
- * Which logical CPUs are on which nodes
- */
-cpumask_t *node_to_cpumask_map;
-EXPORT_SYMBOL(node_to_cpumask_map);
-
-/*
  * Given a shift value, try to populate memnodemap[]
  * Returns :
  * 1 if OK
@@ -661,36 +649,6 @@ void __init init_cpu_to_node(void)
 #endif
 
 
-/*
- * Allocate node_to_cpumask_map based on number of available nodes
- * Requires node_possible_map to be valid.
- *
- * Note: node_to_cpumask() is not valid until after this is done.
- * (Use CONFIG_DEBUG_PER_CPU_MAPS to check this.)
- */
-void __init setup_node_to_cpumask_map(void)
-{
-	unsigned int node, num = 0;
-	cpumask_t *map;
-
-	/* setup nr_node_ids if not done yet */
-	if (nr_node_ids == MAX_NUMNODES) {
-		for_each_node_mask(node, node_possible_map)
-			num = node;
-		nr_node_ids = num + 1;
-	}
-
-	/* allocate the map */
-	map = alloc_bootmem_low(nr_node_ids * sizeof(cpumask_t));
-	DBG("node_to_cpumask_map at %p for %d nodes\n", map, nr_node_ids);
-
-	pr_debug("Node to cpumask map at %p for %d nodes\n",
-		 map, nr_node_ids);
-
-	/* node_to_cpumask() will now work */
-	node_to_cpumask_map = map;
-}
-
 void __cpuinit numa_set_node(int cpu, int node)
 {
 	int *cpu_to_node_map = early_per_cpu_ptr(x86_cpu_to_node_map);
@@ -799,33 +757,6 @@ int early_cpu_to_node(int cpu)
 	return per_cpu(x86_cpu_to_node_map, cpu);
 }
 
-
-/* empty cpumask */
-static const cpumask_t cpu_mask_none;
-
-/*
- * Returns a pointer to the bitmask of CPUs on Node 'node'.
- */
-const cpumask_t *cpumask_of_node(int node)
-{
-	if (node_to_cpumask_map == NULL) {
-		printk(KERN_WARNING
-			"cpumask_of_node(%d): no node_to_cpumask_map!\n",
-			node);
-		dump_stack();
-		return (const cpumask_t *)&cpu_online_map;
-	}
-	if (node >= nr_node_ids) {
-		printk(KERN_WARNING
-			"cpumask_of_node(%d): node > nr_node_ids(%d)\n",
-			node, nr_node_ids);
-		dump_stack();
-		return &cpu_mask_none;
-	}
-	return &node_to_cpumask_map[node];
-}
-EXPORT_SYMBOL(cpumask_of_node);
-
 /*
  * --------- end of debug versions of the numa functions ---------
  */

commit c032ef60d1aa9af33730b7a35bbea751b131adc1
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Mar 13 14:49:53 2009 +1030

    cpumask: convert node_to_cpumask_map[] to cpumask_var_t
    
    Impact: reduce kernel memory usage when CONFIG_CPUMASK_OFFSTACK=y
    
    Straightforward conversion: done for 32 and 64 bit kernels.
    node_to_cpumask_map is now a cpumask_var_t array.
    
    64-bit used to be a dynamic cpumask_t array, and 32-bit used to be a
    static cpumask_t array.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/include/asm/topology.h |    6 +++---
 arch/x86/kernel/smpboot.c       |    4 ++--
 arch/x86/mm/numa.c              |   28 ++++++++++++----------------
 arch/x86/mm/numa_64.c           |   14 +++++++-------
 4 files changed, 24 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index dc31d92..f8b833e 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -86,15 +86,15 @@ static inline int early_cpu_to_node(int cpu)
 #endif /* CONFIG_X86_64 */
 
 /* Mappings between node number and cpus on that node. */
-extern cpumask_t *node_to_cpumask_map;
+extern cpumask_var_t node_to_cpumask_map[MAX_NUMNODES];
 
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
 extern const cpumask_t *cpumask_of_node(int node);
 #else
 /* Returns a pointer to the cpumask of CPUs on Node 'node'. */
-static inline const cpumask_t *cpumask_of_node(int node)
+static inline const struct cpumask *cpumask_of_node(int node)
 {
-	return &node_to_cpumask_map[node];
+	return node_to_cpumask_map[node];
 }
 #endif
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index c55639b..5a58a45 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -123,7 +123,7 @@ EXPORT_SYMBOL(cpu_to_node_map);
 static void map_cpu_to_node(int cpu, int node)
 {
 	printk(KERN_INFO "Mapping cpu %d to node %d\n", cpu, node);
-	cpumask_set_cpu(cpu, &node_to_cpumask_map[node]);
+	cpumask_set_cpu(cpu, node_to_cpumask_map[node]);
 	cpu_to_node_map[cpu] = node;
 }
 
@@ -134,7 +134,7 @@ static void unmap_cpu_to_node(int cpu)
 
 	printk(KERN_INFO "Unmapping cpu %d from all nodes\n", cpu);
 	for (node = 0; node < MAX_NUMNODES; node++)
-		cpumask_clear_cpu(cpu, &node_to_cpumask_map[node]);
+		cpumask_clear_cpu(cpu, node_to_cpumask_map[node]);
 	cpu_to_node_map[cpu] = 0;
 }
 #else /* !(CONFIG_NUMA && CONFIG_X86_32) */
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index f3a19e9..429dc2d 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -12,7 +12,7 @@
 /*
  * Which logical CPUs are on which nodes
  */
-cpumask_t *node_to_cpumask_map;
+cpumask_var_t node_to_cpumask_map[MAX_NUMNODES];
 EXPORT_SYMBOL(node_to_cpumask_map);
 
 /*
@@ -25,7 +25,6 @@ EXPORT_SYMBOL(node_to_cpumask_map);
 void __init setup_node_to_cpumask_map(void)
 {
 	unsigned int node, num = 0;
-	cpumask_t *map;
 
 	/* setup nr_node_ids if not done yet */
 	if (nr_node_ids == MAX_NUMNODES) {
@@ -35,14 +34,11 @@ void __init setup_node_to_cpumask_map(void)
 	}
 
 	/* allocate the map */
-	map = alloc_bootmem_low(nr_node_ids * sizeof(cpumask_t));
-	DBG("node_to_cpumask_map at %p for %d nodes\n", map, nr_node_ids);
+	for (node = 0; node < nr_node_ids; node++)
+		alloc_bootmem_cpumask_var(&node_to_cpumask_map[node]);
 
-	pr_debug("Node to cpumask map at %p for %d nodes\n",
-		 map, nr_node_ids);
-
-	/* node_to_cpumask() will now work */
-	node_to_cpumask_map = map;
+	/* cpumask_of_node() will now work */
+	pr_debug("Node to cpumask map for %d nodes\n", nr_node_ids);
 }
 
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
@@ -51,13 +47,6 @@ void __init setup_node_to_cpumask_map(void)
  */
 const cpumask_t *cpumask_of_node(int node)
 {
-	if (node_to_cpumask_map == NULL) {
-		printk(KERN_WARNING
-			"cpumask_of_node(%d): no node_to_cpumask_map!\n",
-			node);
-		dump_stack();
-		return cpu_online_mask;
-	}
 	if (node >= nr_node_ids) {
 		printk(KERN_WARNING
 			"cpumask_of_node(%d): node > nr_node_ids(%d)\n",
@@ -65,6 +54,13 @@ const cpumask_t *cpumask_of_node(int node)
 		dump_stack();
 		return cpu_none_mask;
 	}
+	if (node_to_cpumask_map[node] == NULL) {
+		printk(KERN_WARNING
+			"cpumask_of_node(%d): no node_to_cpumask_map!\n",
+			node);
+		dump_stack();
+		return cpu_online_mask;
+	}
 	return &node_to_cpumask_map[node];
 }
 EXPORT_SYMBOL(cpumask_of_node);
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index eee1490..9d2b3d2 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -681,12 +681,12 @@ void __cpuinit numa_clear_node(int cpu)
 
 void __cpuinit numa_add_cpu(int cpu)
 {
-	cpu_set(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
+	cpumask_set_cpu(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
 }
 
 void __cpuinit numa_remove_cpu(int cpu)
 {
-	cpu_clear(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
+	cpumask_clear_cpu(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
 }
 
 #else /* CONFIG_DEBUG_PER_CPU_MAPS */
@@ -700,17 +700,17 @@ static void __cpuinit numa_set_cpumask(int cpu, int enable)
 	cpumask_t *mask;
 	char buf[64];
 
-	if (node_to_cpumask_map == NULL) {
-		printk(KERN_ERR "node_to_cpumask_map NULL\n");
+	mask = node_to_cpumask_map[node];
+	if (mask == NULL) {
+		printk(KERN_ERR "node_to_cpumask_map[%i] NULL\n", node);
 		dump_stack();
 		return;
 	}
 
-	mask = &node_to_cpumask_map[node];
 	if (enable)
-		cpu_set(cpu, *mask);
+		cpumask_set_cpu(cpu, mask);
 	else
-		cpu_clear(cpu, *mask);
+		cpumask_clear_cpu(cpu, mask);
 
 	cpulist_scnprintf(buf, sizeof(buf), mask);
 	printk(KERN_DEBUG "%s cpu %d node %d: mask now %s\n",

commit 155dd720d06a219ddf5a56b473cb3325441fc879
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Mar 13 14:49:53 2009 +1030

    cpumask: convert struct cpuinfo_x86's llc_shared_map to cpumask_var_t
    
    Impact: reduce kernel memory usage when CONFIG_CPUMASK_OFFSTACK=y
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/include/asm/processor.h |    2 +-
 arch/x86/kernel/smpboot.c        |   33 ++++++++++++++++++++++++++-------
 2 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 7613950..d794d94 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -94,7 +94,7 @@ struct cpuinfo_x86 {
 	unsigned long		loops_per_jiffy;
 #ifdef CONFIG_SMP
 	/* cpus sharing the last level cache: */
-	cpumask_t		llc_shared_map;
+	cpumask_var_t		llc_shared_map;
 #endif
 	/* cpuid returned max cores value: */
 	u16			 x86_max_cores;
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 5a58a45..d6427aa 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -329,6 +329,23 @@ notrace static void __cpuinit start_secondary(void *unused)
 	cpu_idle();
 }
 
+#ifdef CONFIG_CPUMASK_OFFSTACK
+/* In this case, llc_shared_map is a pointer to a cpumask. */
+static inline void copy_cpuinfo_x86(struct cpuinfo_x86 *dst,
+				    const struct cpuinfo_x86 *src)
+{
+	struct cpumask *llc = dst->llc_shared_map;
+	*dst = *src;
+	dst->llc_shared_map = llc;
+}
+#else
+static inline void copy_cpuinfo_x86(struct cpuinfo_x86 *dst,
+				    const struct cpuinfo_x86 *src)
+{
+	*dst = *src;
+}
+#endif /* CONFIG_CPUMASK_OFFSTACK */
+
 /*
  * The bootstrap kernel entry code has set these up. Save them for
  * a given CPU
@@ -338,7 +355,7 @@ void __cpuinit smp_store_cpu_info(int id)
 {
 	struct cpuinfo_x86 *c = &cpu_data(id);
 
-	*c = boot_cpu_data;
+	copy_cpuinfo_x86(c, &boot_cpu_data);
 	c->cpu_index = id;
 	if (id != 0)
 		identify_secondary_cpu(c);
@@ -362,15 +379,15 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 				cpumask_set_cpu(cpu, cpu_sibling_mask(i));
 				cpumask_set_cpu(i, cpu_core_mask(cpu));
 				cpumask_set_cpu(cpu, cpu_core_mask(i));
-				cpumask_set_cpu(i, &c->llc_shared_map);
-				cpumask_set_cpu(cpu, &o->llc_shared_map);
+				cpumask_set_cpu(i, c->llc_shared_map);
+				cpumask_set_cpu(cpu, o->llc_shared_map);
 			}
 		}
 	} else {
 		cpumask_set_cpu(cpu, cpu_sibling_mask(cpu));
 	}
 
-	cpumask_set_cpu(cpu, &c->llc_shared_map);
+	cpumask_set_cpu(cpu, c->llc_shared_map);
 
 	if (current_cpu_data.x86_max_cores == 1) {
 		cpumask_copy(cpu_core_mask(cpu), cpu_sibling_mask(cpu));
@@ -381,8 +398,8 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 	for_each_cpu(i, cpu_sibling_setup_mask) {
 		if (per_cpu(cpu_llc_id, cpu) != BAD_APICID &&
 		    per_cpu(cpu_llc_id, cpu) == per_cpu(cpu_llc_id, i)) {
-			cpumask_set_cpu(i, &c->llc_shared_map);
-			cpumask_set_cpu(cpu, &cpu_data(i).llc_shared_map);
+			cpumask_set_cpu(i, c->llc_shared_map);
+			cpumask_set_cpu(cpu, cpu_data(i).llc_shared_map);
 		}
 		if (c->phys_proc_id == cpu_data(i).phys_proc_id) {
 			cpumask_set_cpu(i, cpu_core_mask(cpu));
@@ -420,7 +437,7 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
 	if (sched_mc_power_savings || sched_smt_power_savings)
 		return cpu_core_mask(cpu);
 	else
-		return &c->llc_shared_map;
+		return c->llc_shared_map;
 }
 
 static void impress_friends(void)
@@ -1039,8 +1056,10 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	for_each_possible_cpu(i) {
 		alloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
 		alloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
+		alloc_cpumask_var(&cpu_data(i).llc_shared_map, GFP_KERNEL);
 		cpumask_clear(per_cpu(cpu_core_map, i));
 		cpumask_clear(per_cpu(cpu_sibling_map, i));
+		cpumask_clear(cpu_data(i).llc_shared_map);
 	}
 	set_cpu_sibling_map(0);
 

commit 3f76a183de8ad3aeb7425f3d9685bb6003abd1a5
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Mar 13 14:49:54 2009 +1030

    x86: unify cpu_callin_mask/cpu_callout_mask/cpu_initialized_mask/cpu_sibling_setup_mask
    
    Impact: cleanup
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/include/asm/cpumask.h |   18 ------------------
 arch/x86/kernel/cpu/common.c   |   12 ------------
 2 files changed, 0 insertions(+), 30 deletions(-)

diff --git a/arch/x86/include/asm/cpumask.h b/arch/x86/include/asm/cpumask.h
index a7f3c75..61c852f 100644
--- a/arch/x86/include/asm/cpumask.h
+++ b/arch/x86/include/asm/cpumask.h
@@ -3,8 +3,6 @@
 #ifndef __ASSEMBLY__
 #include <linux/cpumask.h>
 
-#ifdef CONFIG_X86_64
-
 extern cpumask_var_t cpu_callin_mask;
 extern cpumask_var_t cpu_callout_mask;
 extern cpumask_var_t cpu_initialized_mask;
@@ -12,21 +10,5 @@ extern cpumask_var_t cpu_sibling_setup_mask;
 
 extern void setup_cpu_local_masks(void);
 
-#else /* CONFIG_X86_32 */
-
-extern cpumask_t cpu_callin_map;
-extern cpumask_t cpu_callout_map;
-extern cpumask_t cpu_initialized;
-extern cpumask_t cpu_sibling_setup_map;
-
-#define cpu_callin_mask		((struct cpumask *)&cpu_callin_map)
-#define cpu_callout_mask	((struct cpumask *)&cpu_callout_map)
-#define cpu_initialized_mask	((struct cpumask *)&cpu_initialized)
-#define cpu_sibling_setup_mask	((struct cpumask *)&cpu_sibling_setup_map)
-
-static inline void setup_cpu_local_masks(void) { }
-
-#endif /* CONFIG_X86_32 */
-
 #endif /* __ASSEMBLY__ */
 #endif /* _ASM_X86_CPUMASK_H */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 826d5c8..82f6cc0 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -41,8 +41,6 @@
 
 #include "cpu.h"
 
-#ifdef CONFIG_X86_64
-
 /* all of these masks are initialized in setup_cpu_local_masks() */
 cpumask_var_t cpu_callin_mask;
 cpumask_var_t cpu_callout_mask;
@@ -60,16 +58,6 @@ void __init setup_cpu_local_masks(void)
 	alloc_bootmem_cpumask_var(&cpu_sibling_setup_mask);
 }
 
-#else /* CONFIG_X86_32 */
-
-cpumask_t cpu_callin_map;
-cpumask_t cpu_callout_map;
-cpumask_t cpu_initialized;
-cpumask_t cpu_sibling_setup_map;
-
-#endif /* CONFIG_X86_32 */
-
-
 static struct cpu_dev *this_cpu __cpuinitdata;
 
 DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {

commit 4f0628963c86d2f97b8cb9acc024a7fe288a6a57
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Mar 13 14:49:54 2009 +1030

    cpumask: use new cpumask functions throughout x86
    
    Impact: cleanup
    
    1) &cpu_online_map -> cpu_online_mask
    2) first_cpu/next_cpu_nr -> cpumask_first/cpumask_next
    3) cpu_*_map manipulation -> init_cpu_* / set_cpu_*
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/include/asm/topology.h           |    4 ++--
 arch/x86/kernel/apic/bigsmp_32.c          |   16 ++++++++--------
 arch/x86/kernel/apic/es7000_32.c          |    6 +++---
 arch/x86/kernel/apic/summit_32.c          |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c |    2 +-
 arch/x86/kernel/cpu/proc.c                |    4 ++--
 arch/x86/kernel/process.c                 |    2 +-
 arch/x86/kernel/smpboot.c                 |   11 +++++------
 arch/x86/xen/smp.c                        |    6 +++---
 9 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index f8b833e..1ce1e1a 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -174,11 +174,11 @@ static inline int early_cpu_to_node(int cpu)
 
 static inline const cpumask_t *cpumask_of_node(int node)
 {
-	return &cpu_online_map;
+	return cpu_online_mask;
 }
 static inline int node_to_first_cpu(int node)
 {
-	return first_cpu(cpu_online_map);
+	return cpumask_first(cpu_online_mask);
 }
 
 static inline void setup_node_to_cpumask_map(void) { }
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index d806eca..676cdac 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -26,12 +26,12 @@ static int bigsmp_apic_id_registered(void)
 	return 1;
 }
 
-static const cpumask_t *bigsmp_target_cpus(void)
+static const struct cpumask *bigsmp_target_cpus(void)
 {
 #ifdef CONFIG_SMP
-	return &cpu_online_map;
+	return cpu_online_mask;
 #else
-	return &cpumask_of_cpu(0);
+	return cpumask_of(0);
 #endif
 }
 
@@ -118,9 +118,9 @@ static int bigsmp_check_phys_apicid_present(int boot_cpu_physical_apicid)
 }
 
 /* As we are using single CPU as destination, pick only one CPU here */
-static unsigned int bigsmp_cpu_mask_to_apicid(const cpumask_t *cpumask)
+static unsigned int bigsmp_cpu_mask_to_apicid(const struct cpumask *cpumask)
 {
-	return bigsmp_cpu_to_logical_apicid(first_cpu(*cpumask));
+	return bigsmp_cpu_to_logical_apicid(cpumask_first(cpumask));
 }
 
 static unsigned int bigsmp_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
@@ -188,10 +188,10 @@ static const struct dmi_system_id bigsmp_dmi_table[] = {
 	{ } /* NULL entry stops DMI scanning */
 };
 
-static void bigsmp_vector_allocation_domain(int cpu, cpumask_t *retmask)
+static void bigsmp_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
-	cpus_clear(*retmask);
-	cpu_set(cpu, *retmask);
+	cpumask_clear(retmask);
+	cpumask_set_cpu(cpu, retmask);
 }
 
 static int probe_bigsmp(void)
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 1322f54..26d3a3e 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -460,9 +460,9 @@ static const cpumask_t *target_cpus_cluster(void)
 	return cpu_all_mask;
 }
 
-static const cpumask_t *es7000_target_cpus(void)
+static const struct cpumask *es7000_target_cpus(void)
 {
-	return &cpumask_of_cpu(smp_processor_id());
+	return cpumask_of(smp_processor_id());
 }
 
 static unsigned long
@@ -517,7 +517,7 @@ static void es7000_setup_apic_routing(void)
 	  "Enabling APIC mode:  %s. Using %d I/O APICs, target cpus %lx\n",
 		(apic_version[apic] == 0x14) ?
 			"Physical Cluster" : "Logical Cluster",
-		nr_ioapics, cpus_addr(*es7000_target_cpus())[0]);
+		nr_ioapics, cpumask_bits(es7000_target_cpus())[0]);
 }
 
 static int es7000_apicid_to_node(int logical_apicid)
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index aac52fa..7f6bd90 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -192,7 +192,7 @@ static const cpumask_t *summit_target_cpus(void)
 	 * dest_LowestPrio mode logical clustered apic interrupt routing
 	 * Just start on cpu 0.  IRQ balancing will spread load
 	 */
-	return &cpumask_of_cpu(0);
+	return cpumask_of(0);
 }
 
 static unsigned long summit_check_apicid_used(physid_mask_t bitmap, int apicid)
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
index aaa7d97..96b2a85 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
@@ -249,7 +249,7 @@ void cmci_rediscover(int dying)
 	for_each_online_cpu (cpu) {
 		if (cpu == dying)
 			continue;
-		if (set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu)))
+		if (set_cpus_allowed_ptr(current, cpumask_of(cpu)))
 			continue;
 		/* Recheck banks in case CPUs don't all have the same */
 		if (cmci_supported(&banks))
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 4dd610e..f93047f 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -143,9 +143,9 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 static void *c_start(struct seq_file *m, loff_t *pos)
 {
 	if (*pos == 0)	/* just in case, cpu 0 is not the first */
-		*pos = first_cpu(cpu_online_map);
+		*pos = cpumask_first(cpu_online_mask);
 	else
-		*pos = next_cpu_nr(*pos - 1, cpu_online_map);
+		*pos = cpumask_next(*pos - 1, cpu_online_mask);
 	if ((*pos) < nr_cpu_ids)
 		return &cpu_data(*pos);
 	return NULL;
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index cad5431..6638294 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -324,7 +324,7 @@ void stop_this_cpu(void *dummy)
 	/*
 	 * Remove this CPU:
 	 */
-	cpu_clear(smp_processor_id(), cpu_online_map);
+	set_cpu_online(smp_processor_id(), false);
 	disable_local_APIC();
 
 	for (;;) {
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index d6427aa..58d24ef 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -296,7 +296,7 @@ notrace static void __cpuinit start_secondary(void *unused)
 	__flush_tlb_all();
 #endif
 
-	/* This must be done before setting cpu_online_map */
+	/* This must be done before setting cpu_online_mask */
 	set_cpu_sibling_map(raw_smp_processor_id());
 	wmb();
 
@@ -904,9 +904,8 @@ int __cpuinit native_cpu_up(unsigned int cpu)
  */
 static __init void disable_smp(void)
 {
-	/* use the read/write pointers to the present and possible maps */
-	cpumask_copy(&cpu_present_map, cpumask_of(0));
-	cpumask_copy(&cpu_possible_map, cpumask_of(0));
+	init_cpu_present(cpumask_of(0));
+	init_cpu_possible(cpumask_of(0));
 	smpboot_clear_io_apic_irqs();
 
 	if (smp_found_config)
@@ -1149,11 +1148,11 @@ early_param("possible_cpus", _setup_possible_cpus);
 
 
 /*
- * cpu_possible_map should be static, it cannot change as cpu's
+ * cpu_possible_mask should be static, it cannot change as cpu's
  * are onlined, or offlined. The reason is per-cpu data-structures
  * are allocated by some modules at init time, and dont expect to
  * do this dynamically on cpu arrival/departure.
- * cpu_present_map on the other hand can change dynamically.
+ * cpu_present_mask on the other hand can change dynamically.
  * In case when cpu_hotplug is not compiled, then we resort to current
  * behaviour, which is cpu_possible == cpu_present.
  * - Ashok Raj
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 8d47056..585a6e3 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -158,7 +158,7 @@ static void __init xen_fill_possible_map(void)
 		rc = HYPERVISOR_vcpu_op(VCPUOP_is_up, i, NULL);
 		if (rc >= 0) {
 			num_processors++;
-			cpu_set(i, cpu_possible_map);
+			set_cpu_possible(i, true);
 		}
 	}
 }
@@ -197,7 +197,7 @@ static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
 	while ((num_possible_cpus() > 1) && (num_possible_cpus() > max_cpus)) {
 		for (cpu = nr_cpu_ids - 1; !cpu_possible(cpu); cpu--)
 			continue;
-		cpu_clear(cpu, cpu_possible_map);
+		set_cpu_possible(cpu, false);
 	}
 
 	for_each_possible_cpu (cpu) {
@@ -210,7 +210,7 @@ static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
 		if (IS_ERR(idle))
 			panic("failed fork for CPU %d", cpu);
 
-		cpu_set(cpu, cpu_present_map);
+		set_cpu_present(cpu, true);
 	}
 }
 

commit 70ba2b6a70f0077707977e3b107478768492040d
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Mar 13 14:49:55 2009 +1030

    cpumask: clean up summit's send_IPI functions
    
    Impact: cleanup, remove cpumask from stack
    
    summit_send_IPI_allbutself might as well call
    default_send_IPI_mask_allbutself_logical().  Also change cpumask_t to
    struct cpumask and &cpu_online_map to cpu_online_mask while here.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/kernel/apic/summit_32.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index 7f6bd90..dda0a77 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -53,23 +53,19 @@ static unsigned summit_get_apic_id(unsigned long x)
 	return (x >> 24) & 0xFF;
 }
 
-static inline void summit_send_IPI_mask(const cpumask_t *mask, int vector)
+static inline void summit_send_IPI_mask(const struct cpumask *mask, int vector)
 {
 	default_send_IPI_mask_sequence_logical(mask, vector);
 }
 
 static void summit_send_IPI_allbutself(int vector)
 {
-	cpumask_t mask = cpu_online_map;
-	cpu_clear(smp_processor_id(), mask);
-
-	if (!cpus_empty(mask))
-		summit_send_IPI_mask(&mask, vector);
+	default_send_IPI_mask_allbutself_logical(cpu_online_mask, vector);
 }
 
 static void summit_send_IPI_all(int vector)
 {
-	summit_send_IPI_mask(&cpu_online_map, vector);
+	summit_send_IPI_mask(cpu_online_mask, vector);
 }
 
 #include <asm/tsc.h>

commit d680eb8bcd0e43b20067fd2c810d76463db5444e
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Mar 13 14:49:56 2009 +1030

    cpumask: make Xen use the new operators.
    
    Impact: cleanup
    
    In particular, *map are deprecated, and you have to use the accessors
    as *mask are const.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    To: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 drivers/xen/cpu_hotplug.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/cpu_hotplug.c b/drivers/xen/cpu_hotplug.c
index 974f56d..5f54c01 100644
--- a/drivers/xen/cpu_hotplug.c
+++ b/drivers/xen/cpu_hotplug.c
@@ -10,7 +10,7 @@ static void enable_hotplug_cpu(int cpu)
 	if (!cpu_present(cpu))
 		arch_register_cpu(cpu);
 
-	cpu_set(cpu, cpu_present_map);
+	set_cpu_present(cpu, true);
 }
 
 static void disable_hotplug_cpu(int cpu)
@@ -18,7 +18,7 @@ static void disable_hotplug_cpu(int cpu)
 	if (cpu_present(cpu))
 		arch_unregister_cpu(cpu);
 
-	cpu_clear(cpu, cpu_present_map);
+	set_cpu_present(cpu, false);
 }
 
 static void vcpu_hotplug(unsigned int cpu)

commit 5c6cb5e2b1798694c859fd3821a34404355e1030
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Mar 13 14:49:56 2009 +1030

    cpumask: remove cpumask_t assignment from vector_allocation_domain()
    
    Impact: cleanup
    
    It's not legal to do assignments into cpumask_var_t; they will soon be of
    variable length.
    
    So explicitly clear the mask and set the first word, rather than using
    assignment.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/kernel/apic/es7000_32.c |    3 ++-
 arch/x86/kernel/apic/numaq_32.c  |    3 ++-
 arch/x86/kernel/apic/probe_32.c  |    3 ++-
 arch/x86/kernel/apic/summit_32.c |    3 ++-
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 26d3a3e..12c8e19 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -420,7 +420,8 @@ static void es7000_vector_allocation_domain(int cpu, cpumask_t *retmask)
 	 * deliver interrupts to the wrong hyperthread when only one
 	 * hyperthread was specified in the interrupt desitination.
 	 */
-	*retmask = (cpumask_t){ { [0] = APIC_ALL_CPUS, } };
+	cpumask_clear(retmask);
+	cpumask_bits(retmask)[0] = APIC_ALL_CPUS;
 }
 
 
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index e4ce98a..9562de1 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -472,7 +472,8 @@ static void numaq_vector_allocation_domain(int cpu, cpumask_t *retmask)
 	 * deliver interrupts to the wrong hyperthread when only one
 	 * hyperthread was specified in the interrupt desitination.
 	 */
-	*retmask = (cpumask_t){ { [0] = APIC_ALL_CPUS, } };
+	cpumask_clear(retmask);
+	cpumask_bits(retmask)[0] = APIC_ALL_CPUS;
 }
 
 static void numaq_setup_portio_remap(void)
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index 141c99a..01eda2a 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -83,7 +83,8 @@ static void default_vector_allocation_domain(int cpu, struct cpumask *retmask)
 	 * deliver interrupts to the wrong hyperthread when only one
 	 * hyperthread was specified in the interrupt desitination.
 	 */
-	*retmask = (cpumask_t) { { [0] = APIC_ALL_CPUS } };
+	cpumask_clear(retmask);
+	cpumask_bits(retmask)[0] = APIC_ALL_CPUS;
 }
 
 /* should be called last. */
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index dda0a77..278e863 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -352,7 +352,8 @@ static void summit_vector_allocation_domain(int cpu, cpumask_t *retmask)
 	 * deliver interrupts to the wrong hyperthread when only one
 	 * hyperthread was specified in the interrupt desitination.
 	 */
-	*retmask = (cpumask_t){ { [0] = APIC_ALL_CPUS, } };
+	cpumask_clear(retmask);
+	cpumask_bits(retmask)[0] = APIC_ALL_CPUS;
 }
 
 #ifdef CONFIG_X86_SUMMIT_NUMA

commit 76ba0ecda0de9accea9a91cb6dbde46782110e1c
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Mar 13 14:49:57 2009 +1030

    cpumask: use cpumask_var_t in uv_flush_tlb_others.
    
    Impact: remove cpumask_t, reduce per-cpu size for CONFIG_CPUMASK_OFFSTACK=y
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/kernel/tlb_uv.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index d038b9c..8afb691 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -275,6 +275,8 @@ const struct cpumask *uv_flush_send_and_wait(int cpu, int this_blade,
 	return NULL;
 }
 
+static DEFINE_PER_CPU(cpumask_var_t, uv_flush_tlb_mask);
+
 /**
  * uv_flush_tlb_others - globally purge translation cache of a virtual
  * address or all TLB's
@@ -304,8 +306,7 @@ const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 					  struct mm_struct *mm,
 					  unsigned long va, unsigned int cpu)
 {
-	static DEFINE_PER_CPU(cpumask_t, flush_tlb_mask);
-	struct cpumask *flush_mask = &__get_cpu_var(flush_tlb_mask);
+	struct cpumask *flush_mask = __get_cpu_var(uv_flush_tlb_mask);
 	int i;
 	int bit;
 	int blade;
@@ -755,6 +756,10 @@ static int __init uv_bau_init(void)
 	if (!is_uv_system())
 		return 0;
 
+	for_each_possible_cpu(cur_cpu)
+		alloc_cpumask_var_node(&per_cpu(uv_flush_tlb_mask, cur_cpu),
+				       GFP_KERNEL, cpu_to_node(cur_cpu));
+
 	uv_bau_retry_limit = 1;
 	uv_nshift = uv_hub_info->n_val;
 	uv_mmask = (1UL << uv_hub_info->n_val) - 1;

commit 73e907de7d5cecef43d9949ab8f4fdca508168c7
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Mar 13 14:49:57 2009 +1030

    cpumask: remove x86 cpumask_t uses.
    
    Impact: cleanup
    
    We are removing cpumask_t in favour of struct cpumask: mainly as a
    marker of what code is now CONFIG_CPUMASK_OFFSTACK-safe.
    
    The only non-trivial change here is vector_allocation_domain():
    explicitly clear the mask and set the first word, rather than using
    assignment.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/include/asm/topology.h  |    4 ++--
 arch/x86/kernel/apic/es7000_32.c |    6 +++---
 arch/x86/kernel/apic/numaq_32.c  |    6 +++---
 arch/x86/kernel/apic/summit_32.c |    6 +++---
 arch/x86/mm/numa.c               |    2 +-
 arch/x86/mm/numa_64.c            |    2 +-
 6 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 1ce1e1a..e3f4198 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -89,7 +89,7 @@ static inline int early_cpu_to_node(int cpu)
 extern cpumask_var_t node_to_cpumask_map[MAX_NUMNODES];
 
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
-extern const cpumask_t *cpumask_of_node(int node);
+extern const struct cpumask *cpumask_of_node(int node);
 #else
 /* Returns a pointer to the cpumask of CPUs on Node 'node'. */
 static inline const struct cpumask *cpumask_of_node(int node)
@@ -172,7 +172,7 @@ static inline int early_cpu_to_node(int cpu)
 	return 0;
 }
 
-static inline const cpumask_t *cpumask_of_node(int node)
+static inline const struct cpumask *cpumask_of_node(int node)
 {
 	return cpu_online_mask;
 }
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 12c8e19..1c11b81 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -410,7 +410,7 @@ static void es7000_enable_apic_mode(void)
 		WARN(1, "Command failed, status = %x\n", mip_status);
 }
 
-static void es7000_vector_allocation_domain(int cpu, cpumask_t *retmask)
+static void es7000_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
 	/* Careful. Some cpus do not strictly honor the set of cpus
 	 * specified in the interrupt destination when using lowest
@@ -456,7 +456,7 @@ static int es7000_apic_id_registered(void)
 	return 1;
 }
 
-static const cpumask_t *target_cpus_cluster(void)
+static const struct cpumask *target_cpus_cluster(void)
 {
 	return cpu_all_mask;
 }
@@ -573,7 +573,7 @@ static int es7000_check_phys_apicid_present(int cpu_physical_apicid)
 	return 1;
 }
 
-static unsigned int es7000_cpu_mask_to_apicid(const cpumask_t *cpumask)
+static unsigned int es7000_cpu_mask_to_apicid(const struct cpumask *cpumask)
 {
 	unsigned int round = 0;
 	int cpu, uninitialized_var(apicid);
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index 9562de1..533e59c 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -334,7 +334,7 @@ static inline void numaq_smp_callin_clear_local_apic(void)
 	clear_local_APIC();
 }
 
-static inline const cpumask_t *numaq_target_cpus(void)
+static inline const struct cpumask *numaq_target_cpus(void)
 {
 	return cpu_all_mask;
 }
@@ -427,7 +427,7 @@ static inline int numaq_check_phys_apicid_present(int boot_cpu_physical_apicid)
  * We use physical apicids here, not logical, so just return the default
  * physical broadcast to stop people from breaking us
  */
-static inline unsigned int numaq_cpu_mask_to_apicid(const cpumask_t *cpumask)
+static unsigned int numaq_cpu_mask_to_apicid(const struct cpumask *cpumask)
 {
 	return 0x0F;
 }
@@ -462,7 +462,7 @@ static int probe_numaq(void)
 	return found_numaq;
 }
 
-static void numaq_vector_allocation_domain(int cpu, cpumask_t *retmask)
+static void numaq_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
 	/* Careful. Some cpus do not strictly honor the set of cpus
 	 * specified in the interrupt destination when using lowest
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index 278e863..9cfe1f4 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -182,7 +182,7 @@ static inline int is_WPEG(struct rio_detail *rio){
 
 #define SUMMIT_APIC_DFR_VALUE	(APIC_DFR_CLUSTER)
 
-static const cpumask_t *summit_target_cpus(void)
+static const struct cpumask *summit_target_cpus(void)
 {
 	/* CPU_MASK_ALL (0xff) has undefined behaviour with
 	 * dest_LowestPrio mode logical clustered apic interrupt routing
@@ -285,7 +285,7 @@ static int summit_check_phys_apicid_present(int boot_cpu_physical_apicid)
 	return 1;
 }
 
-static unsigned int summit_cpu_mask_to_apicid(const cpumask_t *cpumask)
+static unsigned int summit_cpu_mask_to_apicid(const struct cpumask *cpumask)
 {
 	unsigned int round = 0;
 	int cpu, apicid = 0;
@@ -342,7 +342,7 @@ static int probe_summit(void)
 	return 0;
 }
 
-static void summit_vector_allocation_domain(int cpu, cpumask_t *retmask)
+static void summit_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
 	/* Careful. Some cpus do not strictly honor the set of cpus
 	 * specified in the interrupt destination when using lowest
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 429dc2d..ce255e3 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -45,7 +45,7 @@ void __init setup_node_to_cpumask_map(void)
 /*
  * Returns a pointer to the bitmask of CPUs on Node 'node'.
  */
-const cpumask_t *cpumask_of_node(int node)
+const struct cpumask *cpumask_of_node(int node)
 {
 	if (node >= nr_node_ids) {
 		printk(KERN_WARNING
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 9d2b3d2..d73aaa8 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -697,7 +697,7 @@ void __cpuinit numa_remove_cpu(int cpu)
 static void __cpuinit numa_set_cpumask(int cpu, int enable)
 {
 	int node = early_cpu_to_node(cpu);
-	cpumask_t *mask;
+	struct cpumask *mask;
 	char buf[64];
 
 	mask = node_to_cpumask_map[node];

commit 17d85bc7564571a1cce23ffdb2d2a33301876925
Merge: d95c357... 041b623...
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Mar 13 05:54:43 2009 +0100

    Merge commit 'v2.6.29-rc8' into cpus4096

commit 238a5b4bff2e0929a9ceb41f340137f36a6a75d9
Merge: 17d85bc... 73e907d...
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Mar 13 05:54:55 2009 +0100

    Merge branch 'cpus4096' of git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-x86 into cpus4096

commit 0b966252d9e5d95ec2d11e63d7e55b42913aa5b7
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Mar 13 23:42:42 2009 +1030

    cpumask: convert node_to_cpumask_map[] to cpumask_var_t
    
    Impact: fix (CONFIG_MAXSMP=y only) boot crash
    
    c032ef60d1aa9af33730b7a35bbea751b131adc1 "cpumask: convert
    node_to_cpumask_map[] to cpumask_var_t" didn't get this one
    conversion.  There was a compile warning, but I missed it.
    
    Reported-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Cc: Mike Travis <travis@sgi.com>
    LKML-Reference: <200903132342.42813.rusty@rustcorp.com.au>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/numa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index ce255e3..550df48 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -61,7 +61,7 @@ const struct cpumask *cpumask_of_node(int node)
 		dump_stack();
 		return cpu_online_mask;
 	}
-	return &node_to_cpumask_map[node];
+	return node_to_cpumask_map[node];
 }
 EXPORT_SYMBOL(cpumask_of_node);
 #endif

commit 082edb7bf443eb8eda15b482d16ad9dd8137ad24
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Mar 13 23:43:37 2009 +1030

    numa, cpumask: move numa_node_id default implementation to topology.h
    
    Impact: cleanup, potential bugfix
    
    Not sure what changed to expose this, but clearly that numa_node_id()
    doesn't belong in mmzone.h (the inline in gfp.h is probably overkill, too).
    
    In file included from include/linux/topology.h:34,
                     from arch/x86/mm/numa.c:2:
    /home/rusty/patches-cpumask/linux-2.6/arch/x86/include/asm/topology.h:64:1: warning: "numa_node_id" redefined
    In file included from include/linux/topology.h:32,
                     from arch/x86/mm/numa.c:2:
    include/linux/mmzone.h:770:1: warning: this is the location of the previous definition
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Cc: Mike Travis <travis@sgi.com>
    LKML-Reference: <200903132343.37661.rusty@rustcorp.com.au>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/gfp.h      |    1 +
 include/linux/mmzone.h   |    6 ------
 include/linux/topology.h |    5 +++++
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index dd20cd7..0bbc15f 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -4,6 +4,7 @@
 #include <linux/mmzone.h>
 #include <linux/stddef.h>
 #include <linux/linkage.h>
+#include <linux/topology.h>
 
 struct vm_area_struct;
 
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 1aca6ce..e6aacf7 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -764,12 +764,6 @@ extern int numa_zonelist_order_handler(struct ctl_table *, int,
 extern char numa_zonelist_order[];
 #define NUMA_ZONELIST_ORDER_LEN 16	/* string buffer size */
 
-#include <linux/topology.h>
-/* Returns the number of the current Node. */
-#ifndef numa_node_id
-#define numa_node_id()		(cpu_to_node(raw_smp_processor_id()))
-#endif
-
 #ifndef CONFIG_NEED_MULTIPLE_NODES
 
 extern struct pglist_data contig_page_data;
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 16b7d68..7402c1a 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -196,4 +196,9 @@ int arch_update_cpu_topology(void);
 #define topology_core_cpumask(cpu)		cpumask_of(cpu)
 #endif
 
+/* Returns the number of the current Node. */
+#ifndef numa_node_id
+#define numa_node_id()		(cpu_to_node(raw_smp_processor_id()))
+#endif
+
 #endif /* _LINUX_TOPOLOGY_H */

commit 30e1e6d1af2b67558bccf322af2b3e0676b209ae
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Tue Mar 17 14:50:34 2009 +1030

    cpumask: fix CONFIG_CPUMASK_OFFSTACK=y cpu hotunplug crash
    
    Impact: Fix cpu offline when CONFIG_MAXSMP=y
    
    Changeset bc9b83dd1f66402b870301c3c7117b9c1484abb4 "cpumask: convert
    c1e_mask in arch/x86/kernel/process.c to cpumask_var_t" contained a
    bug: c1e_mask is manipulated even if C1E isn't detected (and hence
    not allocated).
    
    This is simply fixed by checking for NULL (which gcc optimizes out
    anyway of CONFIG_CPUMASK_OFFSTACK=n, since it knows ce1_mask can never
    be NULL).
    
    In addition, fix a leak where select_idle_routine re-allocates
    (and re-clears) c1e_mask on every cpu init.
    
    Reported-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Cc: Mike Travis <travis@sgi.com>
    LKML-Reference: <200903171450.34549.rusty@rustcorp.com.au>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/processor.h |    1 +
 arch/x86/kernel/cpu/common.c     |    1 +
 arch/x86/kernel/process.c        |   14 +++++++++++---
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index d794d94..9874dd9 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -733,6 +733,7 @@ static inline void __sti_mwait(unsigned long eax, unsigned long ecx)
 extern void mwait_idle_with_hints(unsigned long eax, unsigned long ecx);
 
 extern void select_idle_routine(const struct cpuinfo_x86 *c);
+extern void init_c1e_mask(void);
 
 extern unsigned long		boot_option_idle_override;
 extern unsigned long		idle_halt;
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 82f6cc0..d7dd3c2 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -812,6 +812,7 @@ static void vgetcpu_set_mode(void)
 void __init identify_boot_cpu(void)
 {
 	identify_cpu(&boot_cpu_data);
+	init_c1e_mask();
 #ifdef CONFIG_X86_32
 	sysenter_setup();
 	enable_sep_cpu();
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 6638294..78533a5 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -479,7 +479,8 @@ static int c1e_detected;
 
 void c1e_remove_cpu(int cpu)
 {
-	cpumask_clear_cpu(cpu, c1e_mask);
+	if (c1e_mask != NULL)
+		cpumask_clear_cpu(cpu, c1e_mask);
 }
 
 /*
@@ -556,13 +557,20 @@ void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 		pm_idle = mwait_idle;
 	} else if (check_c1e_idle(c)) {
 		printk(KERN_INFO "using C1E aware idle routine\n");
-		alloc_cpumask_var(&c1e_mask, GFP_KERNEL);
-		cpumask_clear(c1e_mask);
 		pm_idle = c1e_idle;
 	} else
 		pm_idle = default_idle;
 }
 
+void __init init_c1e_mask(void)
+{
+	/* If we're using c1e_idle, we need to allocate c1e_mask. */
+	if (pm_idle == c1e_idle) {
+		alloc_cpumask_var(&c1e_mask, GFP_KERNEL);
+		cpumask_clear(c1e_mask);
+	}
+}
+
 static int __init idle_setup(char *str)
 {
 	if (!str)

commit af5c820a3169e81af869c113e18ec7588836cd50
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Mar 11 16:32:36 2009 +1030

    x86: cpumask: use work_on_cpu in arch/x86/kernel/microcode_core.c
    
    Impact: don't play with current's cpumask
    
    Straightforward indirection through work_on_cpu().  One change is
    that the error code from microcode_update_cpu() is now actually
    plumbed back to microcode_init_cpu(), so now we printk if it fails
    on cpu hotplug.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>
    Cc: Peter Oruba <peter.oruba@amd.com>
    LKML-Reference: <200903111632.37279.rusty@rustcorp.com.au>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/microcode_core.c |  106 ++++++++++++++++++++++----------------
 1 files changed, 61 insertions(+), 45 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index c9b721b..9a8dbc0 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -108,29 +108,40 @@ struct ucode_cpu_info ucode_cpu_info[NR_CPUS];
 EXPORT_SYMBOL_GPL(ucode_cpu_info);
 
 #ifdef CONFIG_MICROCODE_OLD_INTERFACE
+struct update_for_cpu {
+	const void __user *buf;
+	size_t size;
+};
+
+static long update_for_cpu(void *_ufc)
+{
+	struct update_for_cpu *ufc = _ufc;
+	int error;
+
+	error = microcode_ops->request_microcode_user(smp_processor_id(),
+						      ufc->buf, ufc->size);
+	if (error < 0)
+		return error;
+	if (!error)
+		microcode_ops->apply_microcode(smp_processor_id());
+	return error;
+}
+
 static int do_microcode_update(const void __user *buf, size_t size)
 {
-	cpumask_t old;
 	int error = 0;
 	int cpu;
-
-	old = current->cpus_allowed;
+	struct update_for_cpu ufc = { .buf = buf, .size = size };
 
 	for_each_online_cpu(cpu) {
 		struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 
 		if (!uci->valid)
 			continue;
-
-		set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
-		error = microcode_ops->request_microcode_user(cpu, buf, size);
+		error = work_on_cpu(cpu, update_for_cpu, &ufc);
 		if (error < 0)
-			goto out;
-		if (!error)
-			microcode_ops->apply_microcode(cpu);
+			break;
 	}
-out:
-	set_cpus_allowed_ptr(current, &old);
 	return error;
 }
 
@@ -205,11 +216,26 @@ MODULE_ALIAS_MISCDEV(MICROCODE_MINOR);
 /* fake device for request_firmware */
 static struct platform_device *microcode_pdev;
 
+static long reload_for_cpu(void *unused)
+{
+	struct ucode_cpu_info *uci = ucode_cpu_info + smp_processor_id();
+	int err = 0;
+
+	mutex_lock(&microcode_mutex);
+	if (uci->valid) {
+		err = microcode_ops->request_microcode_fw(smp_processor_id(),
+							  &microcode_pdev->dev);
+		if (!err)
+			microcode_ops->apply_microcode(smp_processor_id());
+	}
+	mutex_unlock(&microcode_mutex);
+	return err;
+}
+
 static ssize_t reload_store(struct sys_device *dev,
 			    struct sysdev_attribute *attr,
 			    const char *buf, size_t sz)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + dev->id;
 	char *end;
 	unsigned long val = simple_strtoul(buf, &end, 0);
 	int err = 0;
@@ -218,21 +244,9 @@ static ssize_t reload_store(struct sys_device *dev,
 	if (end == buf)
 		return -EINVAL;
 	if (val == 1) {
-		cpumask_t old = current->cpus_allowed;
-
 		get_online_cpus();
-		if (cpu_online(cpu)) {
-			set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
-			mutex_lock(&microcode_mutex);
-			if (uci->valid) {
-				err = microcode_ops->request_microcode_fw(cpu,
-						&microcode_pdev->dev);
-				if (!err)
-					microcode_ops->apply_microcode(cpu);
-			}
-			mutex_unlock(&microcode_mutex);
-			set_cpus_allowed_ptr(current, &old);
-		}
+		if (cpu_online(cpu))
+			err = work_on_cpu(cpu, reload_for_cpu, NULL);
 		put_online_cpus();
 	}
 	if (err)
@@ -328,9 +342,9 @@ static int microcode_resume_cpu(int cpu)
 	return 0;
 }
 
-static void microcode_update_cpu(int cpu)
+static long microcode_update_cpu(void *unused)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	struct ucode_cpu_info *uci = ucode_cpu_info + smp_processor_id();
 	int err = 0;
 
 	/*
@@ -338,30 +352,27 @@ static void microcode_update_cpu(int cpu)
 	 * otherwise just request a firmware:
 	 */
 	if (uci->valid) {
-		err = microcode_resume_cpu(cpu);
+		err = microcode_resume_cpu(smp_processor_id());
 	} else {	
-		collect_cpu_info(cpu);
+		collect_cpu_info(smp_processor_id());
 		if (uci->valid && system_state == SYSTEM_RUNNING)
-			err = microcode_ops->request_microcode_fw(cpu,
+			err = microcode_ops->request_microcode_fw(
+					smp_processor_id(),
 					&microcode_pdev->dev);
 	}
 	if (!err)
-		microcode_ops->apply_microcode(cpu);
+		microcode_ops->apply_microcode(smp_processor_id());
+	return err;
 }
 
-static void microcode_init_cpu(int cpu)
+static int microcode_init_cpu(int cpu)
 {
-	cpumask_t old = current->cpus_allowed;
-
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
-	/* We should bind the task to the CPU */
-	BUG_ON(raw_smp_processor_id() != cpu);
-
+	int err;
 	mutex_lock(&microcode_mutex);
-	microcode_update_cpu(cpu);
+	err = work_on_cpu(cpu, microcode_update_cpu, NULL);
 	mutex_unlock(&microcode_mutex);
 
-	set_cpus_allowed_ptr(current, &old);
+	return err;
 }
 
 static int mc_sysdev_add(struct sys_device *sys_dev)
@@ -379,8 +390,11 @@ static int mc_sysdev_add(struct sys_device *sys_dev)
 	if (err)
 		return err;
 
-	microcode_init_cpu(cpu);
-	return 0;
+	err = microcode_init_cpu(cpu);
+	if (err)
+		sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
+
+	return err;
 }
 
 static int mc_sysdev_remove(struct sys_device *sys_dev)
@@ -404,7 +418,7 @@ static int mc_sysdev_resume(struct sys_device *dev)
 		return 0;
 
 	/* only CPU 0 will apply ucode here */
-	microcode_update_cpu(0);
+	microcode_update_cpu(NULL);
 	return 0;
 }
 
@@ -424,7 +438,9 @@ mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-		microcode_init_cpu(cpu);
+		if (microcode_init_cpu(cpu))
+			printk(KERN_ERR "microcode: failed to init CPU%d\n",
+			       cpu);
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
 		pr_debug("microcode: CPU%d added\n", cpu);

commit 4bae1967357bfc78a2fad1be5e81a4b868980ae6
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Mar 11 11:19:46 2009 +0100

    x86: microcode: cleanup
    
    Impact: cleanup
    
    Cc: Rusty Russell <rusty@rustcorp.com.au>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>
    Cc: Peter Oruba <peter.oruba@amd.com>
    LKML-Reference: <200903111632.37279.rusty@rustcorp.com.au>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/microcode_amd.c   |   43 +++++++++----------
 arch/x86/kernel/microcode_core.c  |   58 +++++++++++++-------------
 arch/x86/kernel/microcode_intel.c |   83 +++++++++++++++++++++---------------
 3 files changed, 97 insertions(+), 87 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index c25fdb3..453b579 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -12,31 +12,30 @@
  *
  *  Licensed under the terms of the GNU General Public
  *  License version 2. See file COPYING for details.
-*/
-
+ */
+#include <linux/platform_device.h>
 #include <linux/capability.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/sched.h>
-#include <linux/cpumask.h>
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/vmalloc.h>
 #include <linux/miscdevice.h>
+#include <linux/firmware.h>
 #include <linux/spinlock.h>
-#include <linux/mm.h>
-#include <linux/fs.h>
+#include <linux/cpumask.h>
+#include <linux/pci_ids.h>
+#include <linux/uaccess.h>
+#include <linux/vmalloc.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/sched.h>
+#include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/cpu.h>
-#include <linux/firmware.h>
-#include <linux/platform_device.h>
 #include <linux/pci.h>
-#include <linux/pci_ids.h>
-#include <linux/uaccess.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
 
-#include <asm/msr.h>
-#include <asm/processor.h>
 #include <asm/microcode.h>
+#include <asm/processor.h>
+#include <asm/msr.h>
 
 MODULE_DESCRIPTION("AMD Microcode Update Driver");
 MODULE_AUTHOR("Peter Oruba");
@@ -72,8 +71,8 @@ struct microcode_header_amd {
 } __attribute__((packed));
 
 struct microcode_amd {
-	struct microcode_header_amd hdr;
-	unsigned int mpb[0];
+	struct microcode_header_amd	hdr;
+	unsigned int			mpb[0];
 };
 
 #define UCODE_MAX_SIZE			2048
@@ -184,8 +183,8 @@ static int get_ucode_data(void *to, const u8 *from, size_t n)
 	return 0;
 }
 
-static void *get_next_ucode(const u8 *buf, unsigned int size,
-			    unsigned int *mc_size)
+static void *
+get_next_ucode(const u8 *buf, unsigned int size, unsigned int *mc_size)
 {
 	unsigned int total_size;
 	u8 section_hdr[UCODE_CONTAINER_SECTION_HDR];
@@ -223,7 +222,6 @@ static void *get_next_ucode(const u8 *buf, unsigned int size,
 	return mc;
 }
 
-
 static int install_equiv_cpu_table(const u8 *buf)
 {
 	u8 *container_hdr[UCODE_CONTAINER_HEADER_SIZE];
@@ -372,4 +370,3 @@ struct microcode_ops * __init init_amd_microcode(void)
 {
 	return &microcode_amd_ops;
 }
-
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 9a8dbc0..a0f3851 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -70,47 +70,47 @@
  *		Fix sigmatch() macro to handle old CPUs with pf == 0.
  *		Thanks to Stuart Swales for pointing out this bug.
  */
+#include <linux/platform_device.h>
 #include <linux/capability.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/sched.h>
+#include <linux/miscdevice.h>
+#include <linux/firmware.h>
 #include <linux/smp_lock.h>
+#include <linux/spinlock.h>
 #include <linux/cpumask.h>
-#include <linux/module.h>
-#include <linux/slab.h>
+#include <linux/uaccess.h>
 #include <linux/vmalloc.h>
-#include <linux/miscdevice.h>
-#include <linux/spinlock.h>
-#include <linux/mm.h>
-#include <linux/fs.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/sched.h>
+#include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/cpu.h>
-#include <linux/firmware.h>
-#include <linux/platform_device.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
 
-#include <asm/msr.h>
-#include <asm/uaccess.h>
-#include <asm/processor.h>
 #include <asm/microcode.h>
+#include <asm/processor.h>
+#include <asm/msr.h>
 
 MODULE_DESCRIPTION("Microcode Update Driver");
 MODULE_AUTHOR("Tigran Aivazian <tigran@aivazian.fsnet.co.uk>");
 MODULE_LICENSE("GPL");
 
-#define MICROCODE_VERSION 	"2.00"
+#define MICROCODE_VERSION	"2.00"
 
-static struct microcode_ops *microcode_ops;
+static struct microcode_ops	*microcode_ops;
 
 /* no concurrent ->write()s are allowed on /dev/cpu/microcode */
 static DEFINE_MUTEX(microcode_mutex);
 
-struct ucode_cpu_info ucode_cpu_info[NR_CPUS];
+struct ucode_cpu_info		ucode_cpu_info[NR_CPUS];
 EXPORT_SYMBOL_GPL(ucode_cpu_info);
 
 #ifdef CONFIG_MICROCODE_OLD_INTERFACE
 struct update_for_cpu {
-	const void __user *buf;
-	size_t size;
+	const void __user	*buf;
+	size_t			size;
 };
 
 static long update_for_cpu(void *_ufc)
@@ -209,12 +209,12 @@ static void microcode_dev_exit(void)
 
 MODULE_ALIAS_MISCDEV(MICROCODE_MINOR);
 #else
-#define microcode_dev_init() 0
-#define microcode_dev_exit() do { } while (0)
+#define microcode_dev_init()	0
+#define microcode_dev_exit()	do { } while (0)
 #endif
 
 /* fake device for request_firmware */
-static struct platform_device *microcode_pdev;
+static struct platform_device	*microcode_pdev;
 
 static long reload_for_cpu(void *unused)
 {
@@ -282,8 +282,8 @@ static struct attribute *mc_default_attrs[] = {
 };
 
 static struct attribute_group mc_attr_group = {
-	.attrs = mc_default_attrs,
-	.name = "microcode",
+	.attrs		= mc_default_attrs,
+	.name		= "microcode",
 };
 
 static void __microcode_fini_cpu(int cpu)
@@ -353,7 +353,7 @@ static long microcode_update_cpu(void *unused)
 	 */
 	if (uci->valid) {
 		err = microcode_resume_cpu(smp_processor_id());
-	} else {	
+	} else {
 		collect_cpu_info(smp_processor_id());
 		if (uci->valid && system_state == SYSTEM_RUNNING)
 			err = microcode_ops->request_microcode_fw(
@@ -423,9 +423,9 @@ static int mc_sysdev_resume(struct sys_device *dev)
 }
 
 static struct sysdev_driver mc_sysdev_driver = {
-	.add = mc_sysdev_add,
-	.remove = mc_sysdev_remove,
-	.resume = mc_sysdev_resume,
+	.add		= mc_sysdev_add,
+	.remove		= mc_sysdev_remove,
+	.resume		= mc_sysdev_resume,
 };
 
 static __cpuinit int
@@ -464,7 +464,7 @@ mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
 }
 
 static struct notifier_block __refdata mc_cpu_notifier = {
-	.notifier_call = mc_cpu_callback,
+	.notifier_call	= mc_cpu_callback,
 };
 
 static int __init microcode_init(void)
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index 5e9f4fc..149b9ec 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -70,28 +70,28 @@
  *		Fix sigmatch() macro to handle old CPUs with pf == 0.
  *		Thanks to Stuart Swales for pointing out this bug.
  */
+#include <linux/platform_device.h>
 #include <linux/capability.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/sched.h>
+#include <linux/miscdevice.h>
+#include <linux/firmware.h>
 #include <linux/smp_lock.h>
+#include <linux/spinlock.h>
 #include <linux/cpumask.h>
-#include <linux/module.h>
-#include <linux/slab.h>
+#include <linux/uaccess.h>
 #include <linux/vmalloc.h>
-#include <linux/miscdevice.h>
-#include <linux/spinlock.h>
-#include <linux/mm.h>
-#include <linux/fs.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/sched.h>
+#include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/cpu.h>
-#include <linux/firmware.h>
-#include <linux/platform_device.h>
-#include <linux/uaccess.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
 
-#include <asm/msr.h>
-#include <asm/processor.h>
 #include <asm/microcode.h>
+#include <asm/processor.h>
+#include <asm/msr.h>
 
 MODULE_DESCRIPTION("Microcode Update Driver");
 MODULE_AUTHOR("Tigran Aivazian <tigran@aivazian.fsnet.co.uk>");
@@ -129,12 +129,13 @@ struct extended_sigtable {
 	struct extended_signature sigs[0];
 };
 
-#define DEFAULT_UCODE_DATASIZE 	(2000)
+#define DEFAULT_UCODE_DATASIZE	(2000)
 #define MC_HEADER_SIZE		(sizeof(struct microcode_header_intel))
 #define DEFAULT_UCODE_TOTALSIZE (DEFAULT_UCODE_DATASIZE + MC_HEADER_SIZE)
 #define EXT_HEADER_SIZE		(sizeof(struct extended_sigtable))
 #define EXT_SIGNATURE_SIZE	(sizeof(struct extended_signature))
 #define DWSIZE			(sizeof(u32))
+
 #define get_totalsize(mc) \
 	(((struct microcode_intel *)mc)->hdr.totalsize ? \
 	 ((struct microcode_intel *)mc)->hdr.totalsize : \
@@ -197,30 +198,31 @@ static inline int update_match_cpu(struct cpu_signature *csig, int sig, int pf)
 }
 
 static inline int
-update_match_revision(struct microcode_header_intel *mc_header,	int rev)
+update_match_revision(struct microcode_header_intel *mc_header, int rev)
 {
 	return (mc_header->rev <= rev) ? 0 : 1;
 }
 
 static int microcode_sanity_check(void *mc)
 {
+	unsigned long total_size, data_size, ext_table_size;
 	struct microcode_header_intel *mc_header = mc;
 	struct extended_sigtable *ext_header = NULL;
-	struct extended_signature *ext_sig;
-	unsigned long total_size, data_size, ext_table_size;
 	int sum, orig_sum, ext_sigcount = 0, i;
+	struct extended_signature *ext_sig;
 
 	total_size = get_totalsize(mc_header);
 	data_size = get_datasize(mc_header);
+
 	if (data_size + MC_HEADER_SIZE > total_size) {
 		printk(KERN_ERR "microcode: error! "
-			"Bad data size in microcode data file\n");
+				"Bad data size in microcode data file\n");
 		return -EINVAL;
 	}
 
 	if (mc_header->ldrver != 1 || mc_header->hdrver != 1) {
 		printk(KERN_ERR "microcode: error! "
-			"Unknown microcode update format\n");
+				"Unknown microcode update format\n");
 		return -EINVAL;
 	}
 	ext_table_size = total_size - (MC_HEADER_SIZE + data_size);
@@ -318,11 +320,15 @@ get_matching_microcode(struct cpu_signature *cpu_sig, void *mc, int rev)
 
 static void apply_microcode(int cpu)
 {
+	struct microcode_intel *mc_intel;
+	struct ucode_cpu_info *uci;
 	unsigned long flags;
 	unsigned int val[2];
-	int cpu_num = raw_smp_processor_id();
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-	struct microcode_intel *mc_intel = uci->mc;
+	int cpu_num;
+
+	cpu_num = raw_smp_processor_id();
+	uci = ucode_cpu_info + cpu;
+	mc_intel = uci->mc;
 
 	/* We should bind the task to the CPU */
 	BUG_ON(cpu_num != cpu);
@@ -348,15 +354,17 @@ static void apply_microcode(int cpu)
 	spin_unlock_irqrestore(&microcode_update_lock, flags);
 	if (val[1] != mc_intel->hdr.rev) {
 		printk(KERN_ERR "microcode: CPU%d update from revision "
-			"0x%x to 0x%x failed\n", cpu_num, uci->cpu_sig.rev, val[1]);
+				"0x%x to 0x%x failed\n",
+			cpu_num, uci->cpu_sig.rev, val[1]);
 		return;
 	}
 	printk(KERN_INFO "microcode: CPU%d updated from revision "
-	       "0x%x to 0x%x, date = %04x-%02x-%02x \n",
+			 "0x%x to 0x%x, date = %04x-%02x-%02x \n",
 		cpu_num, uci->cpu_sig.rev, val[1],
 		mc_intel->hdr.date & 0xffff,
 		mc_intel->hdr.date >> 24,
 		(mc_intel->hdr.date >> 16) & 0xff);
+
 	uci->cpu_sig.rev = val[1];
 }
 
@@ -404,18 +412,23 @@ static int generic_load_microcode(int cpu, void *data, size_t size,
 		leftover  -= mc_size;
 	}
 
-	if (new_mc) {
-		if (!leftover) {
-			if (uci->mc)
-				vfree(uci->mc);
-			uci->mc = (struct microcode_intel *)new_mc;
-			pr_debug("microcode: CPU%d found a matching microcode update with"
-				 " version 0x%x (current=0x%x)\n",
-				cpu, new_rev, uci->cpu_sig.rev);
-		} else
-			vfree(new_mc);
+	if (!new_mc)
+		goto out;
+
+	if (leftover) {
+		vfree(new_mc);
+		goto out;
 	}
 
+	if (uci->mc)
+		vfree(uci->mc);
+	uci->mc = (struct microcode_intel *)new_mc;
+
+	pr_debug("microcode: CPU%d found a matching microcode update with"
+		 " version 0x%x (current=0x%x)\n",
+			cpu, new_rev, uci->cpu_sig.rev);
+
+ out:
 	return (int)leftover;
 }
 

commit 89bd55d1855f8e9a4e9add8e93f3144d049c469e
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Mar 11 16:31:29 2009 +1030

    x86: cpumask: update 32-bit APM not to mug current->cpus_allowed
    
    Impact: cleanup, avoid cpumask games
    
    The APM code wants to run on CPU 0: we create an "on_cpu0" wrapper
    which uses work_on_cpu() if we're not already on cpu 0.
    
    This introduces a new failure mode: -ENOMEM, so we add an explicit
    err arg and handle Linux-style errnos in apm_err().
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Cc: Stephen Rothwell <sfr@canb.auug.org.au>
    LKML-Reference: <200903111631.29787.rusty@rustcorp.com.au>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apm_32.c |  248 +++++++++++++++++++++++++++-------------------
 1 files changed, 145 insertions(+), 103 deletions(-)

diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 10033fe..c1941be 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -466,7 +466,7 @@ static const lookup_t error_table[] = {
  *	@err: APM BIOS return code
  *
  *	Write a meaningful log entry to the kernel log in the event of
- *	an APM error.
+ *	an APM error.  Note that this also handles (negative) kernel errors.
  */
 
 static void apm_error(char *str, int err)
@@ -478,43 +478,14 @@ static void apm_error(char *str, int err)
 			break;
 	if (i < ERROR_COUNT)
 		printk(KERN_NOTICE "apm: %s: %s\n", str, error_table[i].msg);
+	else if (err < 0)
+		printk(KERN_NOTICE "apm: %s: linux error code %i\n", str, err);
 	else
 		printk(KERN_NOTICE "apm: %s: unknown error code %#2.2x\n",
 		       str, err);
 }
 
 /*
- * Lock APM functionality to physical CPU 0
- */
-
-#ifdef CONFIG_SMP
-
-static cpumask_t apm_save_cpus(void)
-{
-	cpumask_t x = current->cpus_allowed;
-	/* Some bioses don't like being called from CPU != 0 */
-	set_cpus_allowed(current, cpumask_of_cpu(0));
-	BUG_ON(smp_processor_id() != 0);
-	return x;
-}
-
-static inline void apm_restore_cpus(cpumask_t mask)
-{
-	set_cpus_allowed(current, mask);
-}
-
-#else
-
-/*
- *	No CPU lockdown needed on a uniprocessor
- */
-
-#define apm_save_cpus()		(current->cpus_allowed)
-#define apm_restore_cpus(x)	(void)(x)
-
-#endif
-
-/*
  * These are the actual BIOS calls.  Depending on APM_ZERO_SEGS and
  * apm_info.allow_ints, we are being really paranoid here!  Not only
  * are interrupts disabled, but all the segment registers (except SS)
@@ -568,16 +539,23 @@ static inline void apm_irq_restore(unsigned long flags)
 #	define APM_DO_RESTORE_SEGS
 #endif
 
+struct apm_bios_call {
+	u32 func;
+	/* In and out */
+	u32 ebx;
+	u32 ecx;
+	/* Out only */
+	u32 eax;
+	u32 edx;
+	u32 esi;
+
+	/* Error: -ENOMEM, or bits 8-15 of eax */
+	int err;
+};
+
 /**
- *	apm_bios_call	-	Make an APM BIOS 32bit call
- *	@func: APM function to execute
- *	@ebx_in: EBX register for call entry
- *	@ecx_in: ECX register for call entry
- *	@eax: EAX register return
- *	@ebx: EBX register return
- *	@ecx: ECX register return
- *	@edx: EDX register return
- *	@esi: ESI register return
+ *	__apm_bios_call - Make an APM BIOS 32bit call
+ *	@_call: pointer to struct apm_bios_call.
  *
  *	Make an APM call using the 32bit protected mode interface. The
  *	caller is responsible for knowing if APM BIOS is configured and
@@ -586,80 +564,142 @@ static inline void apm_irq_restore(unsigned long flags)
  *	flag is loaded into AL.  If there is an error, then the error
  *	code is returned in AH (bits 8-15 of eax) and this function
  *	returns non-zero.
+ *
+ *	Note: this makes the call on the current CPU.
  */
-
-static u8 apm_bios_call(u32 func, u32 ebx_in, u32 ecx_in,
-	u32 *eax, u32 *ebx, u32 *ecx, u32 *edx, u32 *esi)
+static long __apm_bios_call(void *_call)
 {
 	APM_DECL_SEGS
 	unsigned long		flags;
-	cpumask_t		cpus;
 	int			cpu;
 	struct desc_struct	save_desc_40;
 	struct desc_struct	*gdt;
-
-	cpus = apm_save_cpus();
+	struct apm_bios_call	*call = _call;
 
 	cpu = get_cpu();
+	BUG_ON(cpu != 0);
 	gdt = get_cpu_gdt_table(cpu);
 	save_desc_40 = gdt[0x40 / 8];
 	gdt[0x40 / 8] = bad_bios_desc;
 
 	apm_irq_save(flags);
 	APM_DO_SAVE_SEGS;
-	apm_bios_call_asm(func, ebx_in, ecx_in, eax, ebx, ecx, edx, esi);
+	apm_bios_call_asm(call->func, call->ebx, call->ecx,
+			  &call->eax, &call->ebx, &call->ecx, &call->edx,
+			  &call->esi);
 	APM_DO_RESTORE_SEGS;
 	apm_irq_restore(flags);
 	gdt[0x40 / 8] = save_desc_40;
 	put_cpu();
-	apm_restore_cpus(cpus);
 
-	return *eax & 0xff;
+	return call->eax & 0xff;
+}
+
+/* Run __apm_bios_call or __apm_bios_call_simple on CPU 0 */
+static int on_cpu0(long (*fn)(void *), struct apm_bios_call *call)
+{
+	int ret;
+
+	/* Don't bother with work_on_cpu in the common case, so we don't
+	 * have to worry about OOM or overhead. */
+	if (get_cpu() == 0) {
+		ret = fn(call);
+		put_cpu();
+	} else {
+		put_cpu();
+		ret = work_on_cpu(0, fn, call);
+	}
+
+	/* work_on_cpu can fail with -ENOMEM */
+	if (ret < 0)
+		call->err = ret;
+	else
+		call->err = (call->eax >> 8) & 0xff;
+
+	return ret;
 }
 
 /**
- *	apm_bios_call_simple	-	make a simple APM BIOS 32bit call
- *	@func: APM function to invoke
- *	@ebx_in: EBX register value for BIOS call
- *	@ecx_in: ECX register value for BIOS call
- *	@eax: EAX register on return from the BIOS call
+ *	apm_bios_call	-	Make an APM BIOS 32bit call (on CPU 0)
+ *	@call: the apm_bios_call registers.
+ *
+ *	If there is an error, it is returned in @call.err.
+ */
+static int apm_bios_call(struct apm_bios_call *call)
+{
+	return on_cpu0(__apm_bios_call, call);
+}
+
+/**
+ *	__apm_bios_call_simple - Make an APM BIOS 32bit call (on CPU 0)
+ *	@_call: pointer to struct apm_bios_call.
  *
  *	Make a BIOS call that returns one value only, or just status.
  *	If there is an error, then the error code is returned in AH
- *	(bits 8-15 of eax) and this function returns non-zero. This is
- *	used for simpler BIOS operations. This call may hold interrupts
- *	off for a long time on some laptops.
+ *	(bits 8-15 of eax) and this function returns non-zero (it can
+ *	also return -ENOMEM). This is used for simpler BIOS operations.
+ *	This call may hold interrupts off for a long time on some laptops.
+ *
+ *	Note: this makes the call on the current CPU.
  */
-
-static u8 apm_bios_call_simple(u32 func, u32 ebx_in, u32 ecx_in, u32 *eax)
+static long __apm_bios_call_simple(void *_call)
 {
 	u8			error;
 	APM_DECL_SEGS
 	unsigned long		flags;
-	cpumask_t		cpus;
 	int			cpu;
 	struct desc_struct	save_desc_40;
 	struct desc_struct	*gdt;
-
-	cpus = apm_save_cpus();
+	struct apm_bios_call	*call = _call;
 
 	cpu = get_cpu();
+	BUG_ON(cpu != 0);
 	gdt = get_cpu_gdt_table(cpu);
 	save_desc_40 = gdt[0x40 / 8];
 	gdt[0x40 / 8] = bad_bios_desc;
 
 	apm_irq_save(flags);
 	APM_DO_SAVE_SEGS;
-	error = apm_bios_call_simple_asm(func, ebx_in, ecx_in, eax);
+	error = apm_bios_call_simple_asm(call->func, call->ebx, call->ecx,
+					 &call->eax);
 	APM_DO_RESTORE_SEGS;
 	apm_irq_restore(flags);
 	gdt[0x40 / 8] = save_desc_40;
 	put_cpu();
-	apm_restore_cpus(cpus);
 	return error;
 }
 
 /**
+ *	apm_bios_call_simple	-	make a simple APM BIOS 32bit call
+ *	@func: APM function to invoke
+ *	@ebx_in: EBX register value for BIOS call
+ *	@ecx_in: ECX register value for BIOS call
+ *	@eax: EAX register on return from the BIOS call
+ *	@err: bits
+ *
+ *	Make a BIOS call that returns one value only, or just status.
+ *	If there is an error, then the error code is returned in @err
+ *	and this function returns non-zero. This is used for simpler
+ *	BIOS operations.  This call may hold interrupts off for a long
+ *	time on some laptops.
+ */
+static int apm_bios_call_simple(u32 func, u32 ebx_in, u32 ecx_in, u32 *eax,
+				int *err)
+{
+	struct apm_bios_call call;
+	int ret;
+
+	call.func = func;
+	call.ebx = ebx_in;
+	call.ecx = ecx_in;
+
+	ret = on_cpu0(__apm_bios_call_simple, &call);
+	*eax = call.eax;
+	*err = call.err;
+	return ret;
+}
+
+/**
  *	apm_driver_version	-	APM driver version
  *	@val:	loaded with the APM version on return
  *
@@ -678,9 +718,10 @@ static u8 apm_bios_call_simple(u32 func, u32 ebx_in, u32 ecx_in, u32 *eax)
 static int apm_driver_version(u_short *val)
 {
 	u32 eax;
+	int err;
 
-	if (apm_bios_call_simple(APM_FUNC_VERSION, 0, *val, &eax))
-		return (eax >> 8) & 0xff;
+	if (apm_bios_call_simple(APM_FUNC_VERSION, 0, *val, &eax, &err))
+		return err;
 	*val = eax;
 	return APM_SUCCESS;
 }
@@ -701,22 +742,21 @@ static int apm_driver_version(u_short *val)
  *	that APM 1.2 is in use. If no messges are pending the value 0x80
  *	is returned (No power management events pending).
  */
-
 static int apm_get_event(apm_event_t *event, apm_eventinfo_t *info)
 {
-	u32 eax;
-	u32 ebx;
-	u32 ecx;
-	u32 dummy;
+	struct apm_bios_call call;
 
-	if (apm_bios_call(APM_FUNC_GET_EVENT, 0, 0, &eax, &ebx, &ecx,
-			  &dummy, &dummy))
-		return (eax >> 8) & 0xff;
-	*event = ebx;
+	call.func = APM_FUNC_GET_EVENT;
+	call.ebx = call.ecx = 0;
+
+	if (apm_bios_call(&call))
+		return call.err;
+
+	*event = call.ebx;
 	if (apm_info.connection_version < 0x0102)
 		*info = ~0; /* indicate info not valid */
 	else
-		*info = ecx;
+		*info = call.ecx;
 	return APM_SUCCESS;
 }
 
@@ -737,9 +777,10 @@ static int apm_get_event(apm_event_t *event, apm_eventinfo_t *info)
 static int set_power_state(u_short what, u_short state)
 {
 	u32 eax;
+	int err;
 
-	if (apm_bios_call_simple(APM_FUNC_SET_STATE, what, state, &eax))
-		return (eax >> 8) & 0xff;
+	if (apm_bios_call_simple(APM_FUNC_SET_STATE, what, state, &eax, &err))
+		return err;
 	return APM_SUCCESS;
 }
 
@@ -770,6 +811,7 @@ static int apm_do_idle(void)
 	u8 ret = 0;
 	int idled = 0;
 	int polling;
+	int err;
 
 	polling = !!(current_thread_info()->status & TS_POLLING);
 	if (polling) {
@@ -782,7 +824,7 @@ static int apm_do_idle(void)
 	}
 	if (!need_resched()) {
 		idled = 1;
-		ret = apm_bios_call_simple(APM_FUNC_IDLE, 0, 0, &eax);
+		ret = apm_bios_call_simple(APM_FUNC_IDLE, 0, 0, &eax, &err);
 	}
 	if (polling)
 		current_thread_info()->status |= TS_POLLING;
@@ -797,8 +839,7 @@ static int apm_do_idle(void)
 		 * Only report the failure the first 5 times.
 		 */
 		if (++t < 5) {
-			printk(KERN_DEBUG "apm_do_idle failed (%d)\n",
-			       (eax >> 8) & 0xff);
+			printk(KERN_DEBUG "apm_do_idle failed (%d)\n", err);
 			t = jiffies;
 		}
 		return -1;
@@ -816,9 +857,10 @@ static int apm_do_idle(void)
 static void apm_do_busy(void)
 {
 	u32 dummy;
+	int err;
 
 	if (clock_slowed || ALWAYS_CALL_BUSY) {
-		(void)apm_bios_call_simple(APM_FUNC_BUSY, 0, 0, &dummy);
+		(void)apm_bios_call_simple(APM_FUNC_BUSY, 0, 0, &dummy, &err);
 		clock_slowed = 0;
 	}
 }
@@ -937,7 +979,7 @@ static void apm_power_off(void)
 
 	/* Some bioses don't like being called from CPU != 0 */
 	if (apm_info.realmode_power_off) {
-		(void)apm_save_cpus();
+		set_cpus_allowed_ptr(current, cpumask_of(0));
 		machine_real_restart(po_bios_call, sizeof(po_bios_call));
 	} else {
 		(void)set_system_power_state(APM_STATE_OFF);
@@ -956,12 +998,13 @@ static void apm_power_off(void)
 static int apm_enable_power_management(int enable)
 {
 	u32 eax;
+	int err;
 
 	if ((enable == 0) && (apm_info.bios.flags & APM_BIOS_DISENGAGED))
 		return APM_NOT_ENGAGED;
 	if (apm_bios_call_simple(APM_FUNC_ENABLE_PM, APM_DEVICE_BALL,
-				 enable, &eax))
-		return (eax >> 8) & 0xff;
+				 enable, &eax, &err))
+		return err;
 	if (enable)
 		apm_info.bios.flags &= ~APM_BIOS_DISABLED;
 	else
@@ -986,24 +1029,23 @@ static int apm_enable_power_management(int enable)
 
 static int apm_get_power_status(u_short *status, u_short *bat, u_short *life)
 {
-	u32 eax;
-	u32 ebx;
-	u32 ecx;
-	u32 edx;
-	u32 dummy;
+	struct apm_bios_call call;
+
+	call.func = APM_FUNC_GET_STATUS;
+	call.ebx = APM_DEVICE_ALL;
+	call.ecx = 0;
 
 	if (apm_info.get_power_status_broken)
 		return APM_32_UNSUPPORTED;
-	if (apm_bios_call(APM_FUNC_GET_STATUS, APM_DEVICE_ALL, 0,
-			  &eax, &ebx, &ecx, &edx, &dummy))
-		return (eax >> 8) & 0xff;
-	*status = ebx;
-	*bat = ecx;
+	if (apm_bios_call(&call))
+		return call.err;
+	*status = call.ebx;
+	*bat = call.ecx;
 	if (apm_info.get_power_status_swabinminutes) {
-		*life = swab16((u16)edx);
+		*life = swab16((u16)call.edx);
 		*life |= 0x8000;
 	} else
-		*life = edx;
+		*life = call.edx;
 	return APM_SUCCESS;
 }
 
@@ -1048,12 +1090,14 @@ static int apm_get_battery_status(u_short which, u_short *status,
 static int apm_engage_power_management(u_short device, int enable)
 {
 	u32 eax;
+	int err;
 
 	if ((enable == 0) && (device == APM_DEVICE_ALL)
 	    && (apm_info.bios.flags & APM_BIOS_DISABLED))
 		return APM_DISABLED;
-	if (apm_bios_call_simple(APM_FUNC_ENGAGE_PM, device, enable, &eax))
-		return (eax >> 8) & 0xff;
+	if (apm_bios_call_simple(APM_FUNC_ENGAGE_PM, device, enable,
+				 &eax, &err))
+		return err;
 	if (device == APM_DEVICE_ALL) {
 		if (enable)
 			apm_info.bios.flags &= ~APM_BIOS_DISENGAGED;
@@ -1682,16 +1726,14 @@ static int apm(void *unused)
 	char 		*power_stat;
 	char 		*bat_stat;
 
-#ifdef CONFIG_SMP
 	/* 2002/08/01 - WT
 	 * This is to avoid random crashes at boot time during initialization
 	 * on SMP systems in case of "apm=power-off" mode. Seen on ASUS A7M266D.
 	 * Some bioses don't like being called from CPU != 0.
 	 * Method suggested by Ingo Molnar.
 	 */
-	set_cpus_allowed(current, cpumask_of_cpu(0));
+	set_cpus_allowed_ptr(current, cpumask_of(0));
 	BUG_ON(smp_processor_id() != 0);
-#endif
 
 	if (apm_info.connection_version == 0) {
 		apm_info.connection_version = apm_info.bios.version;

commit c38da5692e3a4d5d303c04cbf7e526f1eb761076
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Mar 11 16:33:55 2009 +1030

    x86: cpumask: x86 mmio-mod.c use cpumask_var_t for downed_cpus
    
    Impact: cleanup, reduce memory usage for CONFIG_CPUMASK_OFFSTACK=y
    
    Part of the "getting rid of obsolete cpumask_t" patch:
    
     1) Use cpumask_var_t: this is a pointer if CONFIG_CPUMASK_OFFSTACK=y
     2) Call alloc_cpumask_var() on first entry into enter_uniprocessor()
     3) Use modern cpumask_* functions.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Cc: Pekka Paalanen <pq@iki.fi>
    LKML-Reference: <200903111633.55952.rusty@rustcorp.com.au>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/mmio-mod.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index 2c4baa8..c9342ed 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -378,27 +378,34 @@ static void clear_trace_list(void)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-static cpumask_t downed_cpus;
+static cpumask_var_t downed_cpus;
 
 static void enter_uniprocessor(void)
 {
 	int cpu;
 	int err;
 
+	if (downed_cpus == NULL &&
+	    !alloc_cpumask_var(&downed_cpus, GFP_KERNEL)) {
+		pr_notice(NAME "Failed to allocate mask\n");
+		goto out;
+	}
+
 	get_online_cpus();
-	downed_cpus = cpu_online_map;
-	cpu_clear(first_cpu(cpu_online_map), downed_cpus);
+	cpumask_copy(downed_cpus, cpu_online_mask);
+	cpumask_clear_cpu(cpumask_first(cpu_online_mask), downed_cpus);
 	if (num_online_cpus() > 1)
 		pr_notice(NAME "Disabling non-boot CPUs...\n");
 	put_online_cpus();
 
-	for_each_cpu_mask(cpu, downed_cpus) {
+	for_each_cpu(cpu, downed_cpus) {
 		err = cpu_down(cpu);
 		if (!err)
 			pr_info(NAME "CPU%d is down.\n", cpu);
 		else
 			pr_err(NAME "Error taking CPU%d down: %d\n", cpu, err);
 	}
+out:
 	if (num_online_cpus() > 1)
 		pr_warning(NAME "multiple CPUs still online, "
 						"may miss events.\n");
@@ -411,10 +418,10 @@ static void __ref leave_uniprocessor(void)
 	int cpu;
 	int err;
 
-	if (cpus_weight(downed_cpus) == 0)
+	if (downed_cpus == NULL || cpumask_weight(downed_cpus) == 0)
 		return;
 	pr_notice(NAME "Re-enabling CPUs...\n");
-	for_each_cpu_mask(cpu, downed_cpus) {
+	for_each_cpu(cpu, downed_cpus) {
 		err = cpu_up(cpu);
 		if (!err)
 			pr_info(NAME "enabled CPU%d.\n", cpu);

commit df7c8e845e8e2030e8ae947e0ace56d184d0e9a0
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Mar 19 15:22:20 2009 +1030

    cpumask: remove cpumask allocation from idle_balance
    
    Impact: fix circular locking
    
    Steven reports a circular locking from alloc_cpumask_var doing
    a wakeup. We get rid of this using the tried-and-true technique
    of using a per-cpu cpumask_var_t rather than doing an alloc
    every time.
    
    Simpler and more robust than a rare, implicit allocation within
    an atomic codepath.
    
    Reported-by: Steven Rostedt <rostedt@goodmis.org>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    LKML-Reference: <alpine.DEB.2.00.0903181729360.31583@gandalf.stny.rr.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   35 ++++++++++++++++++-----------------
 1 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 5dabd80..48862d4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3448,19 +3448,23 @@ find_busiest_queue(struct sched_group *group, enum cpu_idle_type idle,
  */
 #define MAX_PINNED_INTERVAL	512
 
+/* Working cpumask for load_balance and load_balance_newidle. */
+static DEFINE_PER_CPU(cpumask_var_t, load_balance_tmpmask);
+
 /*
  * Check this_cpu to ensure it is balanced within domain. Attempt to move
  * tasks if there is an imbalance.
  */
 static int load_balance(int this_cpu, struct rq *this_rq,
 			struct sched_domain *sd, enum cpu_idle_type idle,
-			int *balance, struct cpumask *cpus)
+			int *balance)
 {
 	int ld_moved, all_pinned = 0, active_balance = 0, sd_idle = 0;
 	struct sched_group *group;
 	unsigned long imbalance;
 	struct rq *busiest;
 	unsigned long flags;
+	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
 
 	cpumask_setall(cpus);
 
@@ -3615,8 +3619,7 @@ out:
  * this_rq is locked.
  */
 static int
-load_balance_newidle(int this_cpu, struct rq *this_rq, struct sched_domain *sd,
-			struct cpumask *cpus)
+load_balance_newidle(int this_cpu, struct rq *this_rq, struct sched_domain *sd)
 {
 	struct sched_group *group;
 	struct rq *busiest = NULL;
@@ -3624,6 +3627,7 @@ load_balance_newidle(int this_cpu, struct rq *this_rq, struct sched_domain *sd,
 	int ld_moved = 0;
 	int sd_idle = 0;
 	int all_pinned = 0;
+	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
 
 	cpumask_setall(cpus);
 
@@ -3764,10 +3768,6 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
 	struct sched_domain *sd;
 	int pulled_task = 0;
 	unsigned long next_balance = jiffies + HZ;
-	cpumask_var_t tmpmask;
-
-	if (!alloc_cpumask_var(&tmpmask, GFP_ATOMIC))
-		return;
 
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
@@ -3778,7 +3778,7 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
 		if (sd->flags & SD_BALANCE_NEWIDLE)
 			/* If we've pulled tasks over stop searching: */
 			pulled_task = load_balance_newidle(this_cpu, this_rq,
-							   sd, tmpmask);
+							   sd);
 
 		interval = msecs_to_jiffies(sd->balance_interval);
 		if (time_after(next_balance, sd->last_balance + interval))
@@ -3793,7 +3793,6 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
 		 */
 		this_rq->next_balance = next_balance;
 	}
-	free_cpumask_var(tmpmask);
 }
 
 /*
@@ -3943,11 +3942,6 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 	unsigned long next_balance = jiffies + 60*HZ;
 	int update_next_balance = 0;
 	int need_serialize;
-	cpumask_var_t tmp;
-
-	/* Fails alloc?  Rebalancing probably not a priority right now. */
-	if (!alloc_cpumask_var(&tmp, GFP_ATOMIC))
-		return;
 
 	for_each_domain(cpu, sd) {
 		if (!(sd->flags & SD_LOAD_BALANCE))
@@ -3972,7 +3966,7 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 		}
 
 		if (time_after_eq(jiffies, sd->last_balance + interval)) {
-			if (load_balance(cpu, rq, sd, idle, &balance, tmp)) {
+			if (load_balance(cpu, rq, sd, idle, &balance)) {
 				/*
 				 * We've pulled tasks over so either we're no
 				 * longer idle, or one of our SMT siblings is
@@ -4006,8 +4000,6 @@ out:
 	 */
 	if (likely(update_next_balance))
 		rq->next_balance = next_balance;
-
-	free_cpumask_var(tmp);
 }
 
 /*
@@ -8304,6 +8296,9 @@ void __init sched_init(void)
 #ifdef CONFIG_USER_SCHED
 	alloc_size *= 2;
 #endif
+#ifdef CONFIG_CPUMASK_OFFSTACK
+	alloc_size *= num_possible_cpus() * cpumask_size();
+#endif
 	/*
 	 * As sched_init() is called before page_alloc is setup,
 	 * we use alloc_bootmem().
@@ -8341,6 +8336,12 @@ void __init sched_init(void)
 		ptr += nr_cpu_ids * sizeof(void **);
 #endif /* CONFIG_USER_SCHED */
 #endif /* CONFIG_RT_GROUP_SCHED */
+#ifdef CONFIG_CPUMASK_OFFSTACK
+		for_each_possible_cpu(i) {
+			per_cpu(load_balance_tmpmask, i) = (void *)ptr;
+			ptr += cpumask_size();
+		}
+#endif /* CONFIG_CPUMASK_OFFSTACK */
 	}
 
 #ifdef CONFIG_SMP

commit 17ad6ea621b1c7952ebd7330ce65de26b6ee9cca
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Thu Mar 19 22:03:22 2009 +1100

    numa, cpumask: move numa_node_id default implementation to topology.h, fix
    
    Impact: build fix for powerpc and sparc
    
    Today's linux-next build (powerpc allyesconfig) failed like this:
    
    > In file included from include/linux/mmzone.h:776,
    >                  from include/linux/gfp.h:5,
    >                  from include/linux/kmod.h:23,
    >                  from include/linux/module.h:14,
    >                  from init/version.c:11:
    > arch/powerpc/include/asm/mmzone.h:32: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'numa_cpumask_lookup_table'
    
    Caused by commit 082edb7bf443eb8eda15b482d16ad9dd8137ad24 ("numa,
    cpumask: move numa_node_id default implementation to topology.h") from
    the cpus4096 tree which removed the include of linux/topology.h from
    linux/mmzone.h.
    
    Same for sparc64 defconfig.
    
    Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
    Acked-b: Rusty Russell <rusty@rustcorp.com.au>
    Cc: ppc-dev <linuxppc-dev@ozlabs.org>
    LKML-Reference: <20090319220322.3baa4613.sfr@canb.auug.org.au>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/powerpc/include/asm/mmzone.h |    1 +
 arch/sparc/include/asm/mmzone.h   |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/mmzone.h b/arch/powerpc/include/asm/mmzone.h
index 19f299b..35acac9 100644
--- a/arch/powerpc/include/asm/mmzone.h
+++ b/arch/powerpc/include/asm/mmzone.h
@@ -8,6 +8,7 @@
 #define _ASM_MMZONE_H_
 #ifdef __KERNEL__
 
+#include <linux/cpumask.h>
 
 /*
  * generic non-linear memory support:
diff --git a/arch/sparc/include/asm/mmzone.h b/arch/sparc/include/asm/mmzone.h
index ebf5986..e8c6487 100644
--- a/arch/sparc/include/asm/mmzone.h
+++ b/arch/sparc/include/asm/mmzone.h
@@ -3,6 +3,8 @@
 
 #ifdef CONFIG_NEED_MULTIPLE_NODES
 
+#include <linux/cpumask.h>
+
 extern struct pglist_data *node_data[];
 
 #define NODE_DATA(nid)		(node_data[nid])

commit 8c083f081d0014057901c68a0a3e0f8ca7ac8d23
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Mar 19 15:22:20 2009 +1030

    cpumask: remove cpumask allocation from idle_balance, fix
    
    Impact: fix boot crash
    
    Fix typo in the size calculation.
    
    Reported-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    LKML-Reference: <alpine.DEB.2.00.0903181729360.31583@gandalf.stny.rr.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 48862d4..11dd527 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8297,7 +8297,7 @@ void __init sched_init(void)
 	alloc_size *= 2;
 #endif
 #ifdef CONFIG_CPUMASK_OFFSTACK
-	alloc_size *= num_possible_cpus() * cpumask_size();
+	alloc_size += num_possible_cpus() * cpumask_size();
 #endif
 	/*
 	 * As sched_init() is called before page_alloc is setup,

commit 65fb0d23fcddd8697c871047b700c78817bdaa43
Merge: 8c083f0... dfbbe89...
Author: Ingo Molnar <mingo@elte.hu>
Date:   Mon Mar 30 23:53:32 2009 +0200

    Merge branch 'linus' into cpumask-for-linus
    
    Conflicts:
    	arch/x86/kernel/cpu/common.c

commit 558f6ab9106e6be701acb0257e7171df1bbccf04
Merge: 15f7176... 65fb0d2...
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Tue Mar 31 13:33:50 2009 +1030

    Merge branch 'cpumask-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
    
    Conflicts:
    
    	arch/x86/include/asm/topology.h
    	drivers/oprofile/buffer_sync.c
    (Both cases: changed in Linus' tree, removed in Ingo's).

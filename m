Return-Path: <linux-kernel-owner+w=401wt.eu-S1759018AbYDYOBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018AbYDYOBo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 10:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755098AbYDYOBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 10:01:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52210 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754997AbYDYOBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 10:01:22 -0400
Date: Fri, 25 Apr 2008 16:00:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [git pull] Xen guest updates
Message-ID: <20080425140029.GA10973@elte.hu>
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


Linus, please pull the xen-next git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-xen-next.git for-linus

these patches have been in x86.git for quite some time and have been 
tested there. The drivers/ changes touch files outside of the x86 tree, 
that's why this is a separate pull request.

Thanks,

	Ingo

------------------>
Christian Limpach (1):
      xen blkfront: Delay wait for block devices until after the disk is added

Ingo Molnar (1):
      x86: xen unify x86 add common mm pgtable c fix

Isaku Yamahata (12):
      xen: definisions which ia64 needs
      xen: definitions which ia64/xen needs
      xen: add missing definitions for xen grant table which ia64/xen needs
      xen: add missing definitions in include/xen/interface/vcpu.h which ia64/xen needs
      xen: move features.c from arch/x86/xen/features.c to drivers/xen
      xen: move events.c to drivers/xen for IA64/Xen support
      Xen: make events.c portable for ia64/xen support
      xen: add resend_irq_on_evtchn() definition into events.c
      xen: make include/xen/page.h portable moving those definitions under asm dir
      xen: replace callers of alloc_vm_area()/free_vm_area() with xen_ prefixed one
      xen: make grant table arch portable
      xen: import arch generic part of xencomm

Jeremy Fitzhardinge (34):
      x86: convert pgalloc_64.h from macros to inlines
      x86: add common mm/pgtable.c
      x86: put paravirt stubs into common asm/pgalloc.h
      x86: move pte functions into common asm/pgalloc.h
      x86: move pmd functions into common asm/pgalloc.h
      x86: move pgalloc pud and pgd operations into common place
      x86: move all the pgd_list handling to one place
      x86: rename paravirt_alloc_pt etc after the pagetable structure
      x86: add pud_alloc for 4-level pagetables
      x86/pgtable.h: demacro ptep_set_access_flags
      x86/pgtable.h: demacro ptep_test_and_clear_young
      x86/pgtable.h: demacro ptep_clear_flush_young
      x86: demacro pgalloc paravirt stubs
      xen: use appropriate pte types
      xen: make use of pte_t union
      xen: unify pte operations
      xen: use phys_addr_t when referring to physical addresses
      xen: unify pte operations on machine frames
      xen: make sure iret faults are trapped
      x86: unify KERNEL_PGD_PTRS
      x86: unify pgd ctor/dtor
      xen: add support for callbackops hypercall
      xen: support sysenter/sysexit if hypervisor does
      xen: implement a debug-interrupt handler
      xen: make sure retriggered events are set pending
      xen: short-cut for recursive event handling
      xen: no need for domU to worry about MCE/MCA
      xen: jump to iret fixup
      xen/blkfront: use bdget_disk
      xen: disable preemption during tlb flush
      xen: allow set_pte_at on init_mm to be lockless
      xen: fold xen_sysexit into xen_iret
      xen: allow compilation with non-flat memory
      xen: add balloon driver

Mark McLoughlin (2):
      xen: Module autoprobing support for frontend drivers
      xen: Add compatibility aliases for frontend drivers

Markus Armbruster (2):
      xen: Make xen-blkfront write its protocol ABI to xenstore
      xen pvfb: Para-virtual framebuffer, keyboard and pointer driver

 arch/x86/kernel/entry_32.S           |   12 +-
 arch/x86/kernel/paravirt.c           |   12 +-
 arch/x86/kernel/reboot.c             |    4 +-
 arch/x86/kernel/smpboot.c            |    4 +-
 arch/x86/kernel/vmi_32.c             |   22 +-
 arch/x86/mach-voyager/voyager_smp.c  |    4 +-
 arch/x86/mm/Makefile                 |    2 +-
 arch/x86/mm/init_32.c                |    8 +-
 arch/x86/mm/ioremap.c                |    2 +-
 arch/x86/mm/pageattr.c               |    4 +-
 arch/x86/mm/pgtable.c                |  276 +++++++++++++
 arch/x86/mm/pgtable_32.c             |  204 ----------
 arch/x86/xen/Kconfig                 |    2 +-
 arch/x86/xen/Makefile                |    4 +-
 arch/x86/xen/enlighten.c             |   54 ++-
 arch/x86/xen/grant-table.c           |   91 +++++
 arch/x86/xen/mmu.c                   |  143 +++----
 arch/x86/xen/setup.c                 |   21 +
 arch/x86/xen/smp.c                   |   20 +-
 arch/x86/xen/xen-asm.S               |   42 ++-
 arch/x86/xen/xen-ops.h               |    8 +-
 drivers/Kconfig                      |    2 +
 drivers/block/xen-blkfront.c         |   23 +-
 drivers/input/Kconfig                |    9 +
 drivers/input/Makefile               |    2 +
 drivers/input/xen-kbdfront.c         |  340 ++++++++++++++++
 drivers/net/xen-netfront.c           |    2 +
 drivers/video/Kconfig                |   14 +
 drivers/video/Makefile               |    1 +
 drivers/video/xen-fbfront.c          |  550 ++++++++++++++++++++++++++
 drivers/xen/Kconfig                  |   19 +
 drivers/xen/Makefile                 |    4 +-
 drivers/xen/balloon.c                |  712 ++++++++++++++++++++++++++++++++++
 {arch/x86 => drivers}/xen/events.c   |  121 +++++-
 {arch/x86 => drivers}/xen/features.c |    0 
 drivers/xen/grant-table.c            |   37 +--
 drivers/xen/xenbus/xenbus_client.c   |    6 +-
 drivers/xen/xenbus/xenbus_probe.c    |   32 ++-
 drivers/xen/xencomm.c                |  232 +++++++++++
 include/asm-x86/paravirt.h           |   43 ++-
 include/asm-x86/pgalloc.h            |  111 +++++-
 include/asm-x86/pgalloc_32.h         |   95 -----
 include/asm-x86/pgalloc_64.h         |  133 -------
 include/asm-x86/pgtable.h            |   54 ++--
 include/asm-x86/pgtable_32.h         |   18 -
 include/asm-x86/pgtable_64.h         |    2 +-
 include/asm-x86/xen/events.h         |   22 +
 include/asm-x86/xen/grant_table.h    |    7 +
 include/asm-x86/xen/hypercall.h      |    6 +
 include/asm-x86/xen/interface.h      |   28 ++
 include/asm-x86/xen/page.h           |  168 ++++++++
 include/xen/balloon.h                |   61 +++
 include/xen/events.h                 |    9 +-
 include/xen/grant_table.h            |    7 +
 include/xen/interface/callback.h     |  102 +++++
 include/xen/interface/grant_table.h  |   11 +-
 include/xen/interface/io/fbif.h      |  124 ++++++
 include/xen/interface/io/kbdif.h     |  114 ++++++
 include/xen/interface/io/protocols.h |   21 +
 include/xen/interface/memory.h       |   12 +-
 include/xen/interface/vcpu.h         |    5 +
 include/xen/interface/xen.h          |   22 +-
 include/xen/interface/xencomm.h      |   41 ++
 include/xen/page.h                   |  181 +---------
 include/xen/xen-ops.h                |    8 +
 include/xen/xenbus.h                 |    1 +
 include/xen/xencomm.h                |   77 ++++
 67 files changed, 3607 insertions(+), 921 deletions(-)
 create mode 100644 arch/x86/mm/pgtable.c
 create mode 100644 arch/x86/xen/grant-table.c
 create mode 100644 drivers/input/xen-kbdfront.c
 create mode 100644 drivers/video/xen-fbfront.c
 create mode 100644 drivers/xen/Kconfig
 create mode 100644 drivers/xen/balloon.c
 rename {arch/x86 => drivers}/xen/events.c (82%)
 rename {arch/x86 => drivers}/xen/features.c (100%)
 create mode 100644 drivers/xen/xencomm.c
 delete mode 100644 include/asm-x86/pgalloc_32.h
 delete mode 100644 include/asm-x86/pgalloc_64.h
 create mode 100644 include/asm-x86/xen/events.h
 create mode 100644 include/asm-x86/xen/grant_table.h
 create mode 100644 include/asm-x86/xen/page.h
 create mode 100644 include/xen/balloon.h
 create mode 100644 include/xen/interface/callback.h
 create mode 100644 include/xen/interface/io/fbif.h
 create mode 100644 include/xen/interface/io/kbdif.h
 create mode 100644 include/xen/interface/io/protocols.h
 create mode 100644 include/xen/interface/xencomm.h
 create mode 100644 include/xen/xen-ops.h
 create mode 100644 include/xen/xencomm.h

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index f0f8934..2a609dc 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -409,7 +409,7 @@ restore_nocheck_notrace:
 irq_return:
 	INTERRUPT_RETURN
 .section .fixup,"ax"
-iret_exc:
+ENTRY(iret_exc)
 	pushl $0			# no error code
 	pushl $do_iret_error
 	jmp error_code
@@ -1017,6 +1017,13 @@ ENTRY(kernel_thread_helper)
 ENDPROC(kernel_thread_helper)
 
 #ifdef CONFIG_XEN
+/* Xen doesn't set %esp to be precisely what the normal sysenter
+   entrypoint expects, so fix it up before using the normal path. */
+ENTRY(xen_sysenter_target)
+	RING0_INT_FRAME
+	addl $5*4, %esp		/* remove xen-provided frame */
+	jmp sysenter_past_esp
+
 ENTRY(xen_hypervisor_callback)
 	CFI_STARTPROC
 	pushl $0
@@ -1035,8 +1042,9 @@ ENTRY(xen_hypervisor_callback)
 	cmpl $xen_iret_end_crit,%eax
 	jae  1f
 
-	call xen_iret_crit_fixup
+	jmp  xen_iret_crit_fixup
 
+ENTRY(xen_do_upcall)
 1:	mov %esp, %eax
 	call xen_evtchn_do_upcall
 	jmp  ret_from_intr
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 3733412..74f0c5e 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -366,11 +366,13 @@ struct pv_mmu_ops pv_mmu_ops = {
 	.flush_tlb_single = native_flush_tlb_single,
 	.flush_tlb_others = native_flush_tlb_others,
 
-	.alloc_pt = paravirt_nop,
-	.alloc_pd = paravirt_nop,
-	.alloc_pd_clone = paravirt_nop,
-	.release_pt = paravirt_nop,
-	.release_pd = paravirt_nop,
+	.alloc_pte = paravirt_nop,
+	.alloc_pmd = paravirt_nop,
+	.alloc_pmd_clone = paravirt_nop,
+	.alloc_pud = paravirt_nop,
+	.release_pte = paravirt_nop,
+	.release_pmd = paravirt_nop,
+	.release_pud = paravirt_nop,
 
 	.set_pte = native_set_pte,
 	.set_pte_at = native_set_pte_at,
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 19c9386..1791a75 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -8,6 +8,7 @@
 #include <asm/apic.h>
 #include <asm/desc.h>
 #include <asm/hpet.h>
+#include <asm/pgtable.h>
 #include <asm/reboot_fixups.h>
 #include <asm/reboot.h>
 
@@ -15,7 +16,6 @@
 # include <linux/dmi.h>
 # include <linux/ctype.h>
 # include <linux/mc146818rtc.h>
-# include <asm/pgtable.h>
 #else
 # include <asm/iommu.h>
 #endif
@@ -275,7 +275,7 @@ void machine_real_restart(unsigned char *code, int length)
 	/* Remap the kernel at virtual address zero, as well as offset zero
 	   from the kernel segment.  This assumes the kernel segment starts at
 	   virtual address PAGE_OFFSET. */
-	memcpy(swapper_pg_dir, swapper_pg_dir + USER_PGD_PTRS,
+	memcpy(swapper_pg_dir, swapper_pg_dir + KERNEL_PGD_BOUNDARY,
 		sizeof(swapper_pg_dir [0]) * KERNEL_PGD_PTRS);
 
 	/*
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 6a92539..2de2f7a 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1039,8 +1039,8 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 
 #ifdef CONFIG_X86_32
 	/* init low mem mapping */
-	clone_pgd_range(swapper_pg_dir, swapper_pg_dir + USER_PGD_PTRS,
-			min_t(unsigned long, KERNEL_PGD_PTRS, USER_PGD_PTRS));
+	clone_pgd_range(swapper_pg_dir, swapper_pg_dir + KERNEL_PGD_BOUNDARY,
+			min_t(unsigned long, KERNEL_PGD_PTRS, KERNEL_PGD_BOUNDARY));
 	flush_tlb_all();
 #endif
 
diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
index 12affe1..956f389 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -320,7 +320,7 @@ static void check_zeroed_page(u32 pfn, int type, struct page *page)
 	 * pdes need to be zeroed.
 	 */
 	if (type & VMI_PAGE_CLONE)
-		limit = USER_PTRS_PER_PGD;
+		limit = KERNEL_PGD_BOUNDARY;
 	for (i = 0; i < limit; i++)
 		BUG_ON(ptr[i]);
 }
@@ -392,13 +392,13 @@ static void *vmi_kmap_atomic_pte(struct page *page, enum km_type type)
 }
 #endif
 
-static void vmi_allocate_pt(struct mm_struct *mm, u32 pfn)
+static void vmi_allocate_pte(struct mm_struct *mm, u32 pfn)
 {
 	vmi_set_page_type(pfn, VMI_PAGE_L1);
 	vmi_ops.allocate_page(pfn, VMI_PAGE_L1, 0, 0, 0);
 }
 
-static void vmi_allocate_pd(struct mm_struct *mm, u32 pfn)
+static void vmi_allocate_pmd(struct mm_struct *mm, u32 pfn)
 {
  	/*
 	 * This call comes in very early, before mem_map is setup.
@@ -409,20 +409,20 @@ static void vmi_allocate_pd(struct mm_struct *mm, u32 pfn)
 	vmi_ops.allocate_page(pfn, VMI_PAGE_L2, 0, 0, 0);
 }
 
-static void vmi_allocate_pd_clone(u32 pfn, u32 clonepfn, u32 start, u32 count)
+static void vmi_allocate_pmd_clone(u32 pfn, u32 clonepfn, u32 start, u32 count)
 {
  	vmi_set_page_type(pfn, VMI_PAGE_L2 | VMI_PAGE_CLONE);
 	vmi_check_page_type(clonepfn, VMI_PAGE_L2);
 	vmi_ops.allocate_page(pfn, VMI_PAGE_L2 | VMI_PAGE_CLONE, clonepfn, start, count);
 }
 
-static void vmi_release_pt(u32 pfn)
+static void vmi_release_pte(u32 pfn)
 {
 	vmi_ops.release_page(pfn, VMI_PAGE_L1);
 	vmi_set_page_type(pfn, VMI_PAGE_NORMAL);
 }
 
-static void vmi_release_pd(u32 pfn)
+static void vmi_release_pmd(u32 pfn)
 {
 	vmi_ops.release_page(pfn, VMI_PAGE_L2);
 	vmi_set_page_type(pfn, VMI_PAGE_NORMAL);
@@ -871,15 +871,15 @@ static inline int __init activate_vmi(void)
 
 	vmi_ops.allocate_page = vmi_get_function(VMI_CALL_AllocatePage);
 	if (vmi_ops.allocate_page) {
-		pv_mmu_ops.alloc_pt = vmi_allocate_pt;
-		pv_mmu_ops.alloc_pd = vmi_allocate_pd;
-		pv_mmu_ops.alloc_pd_clone = vmi_allocate_pd_clone;
+		pv_mmu_ops.alloc_pte = vmi_allocate_pte;
+		pv_mmu_ops.alloc_pmd = vmi_allocate_pmd;
+		pv_mmu_ops.alloc_pmd_clone = vmi_allocate_pmd_clone;
 	}
 
 	vmi_ops.release_page = vmi_get_function(VMI_CALL_ReleasePage);
 	if (vmi_ops.release_page) {
-		pv_mmu_ops.release_pt = vmi_release_pt;
-		pv_mmu_ops.release_pd = vmi_release_pd;
+		pv_mmu_ops.release_pte = vmi_release_pte;
+		pv_mmu_ops.release_pmd = vmi_release_pmd;
 	}
 
 	/* Set linear is needed in all cases */
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index 96f60c7..394046e 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -560,8 +560,8 @@ static void __init do_boot_cpu(__u8 cpu)
 		hijack_source.idt.Offset, stack_start.sp));
 
 	/* init lowmem identity mapping */
-	clone_pgd_range(swapper_pg_dir, swapper_pg_dir + USER_PGD_PTRS,
-			min_t(unsigned long, KERNEL_PGD_PTRS, USER_PGD_PTRS));
+	clone_pgd_range(swapper_pg_dir, swapper_pg_dir + KERNEL_PGD_BOUNDARY,
+			min_t(unsigned long, KERNEL_PGD_PTRS, KERNEL_PGD_BOUNDARY));
 	flush_tlb_all();
 
 	if (quad_boot) {
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 20941d2..b7b3e4c 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -1,5 +1,5 @@
 obj-y	:=  init_$(BITS).o fault.o ioremap.o extable.o pageattr.o mmap.o \
-	    pat.o
+	    pat.o pgtable.o
 
 obj-$(CONFIG_X86_32)		+= pgtable_32.o
 
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 9ec62da..08aa187 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -71,7 +71,7 @@ static pmd_t * __init one_md_table_init(pgd_t *pgd)
 	if (!(pgd_val(*pgd) & _PAGE_PRESENT)) {
 		pmd_table = (pmd_t *) alloc_bootmem_low_pages(PAGE_SIZE);
 
-		paravirt_alloc_pd(&init_mm, __pa(pmd_table) >> PAGE_SHIFT);
+		paravirt_alloc_pmd(&init_mm, __pa(pmd_table) >> PAGE_SHIFT);
 		set_pgd(pgd, __pgd(__pa(pmd_table) | _PAGE_PRESENT));
 		pud = pud_offset(pgd, 0);
 		BUG_ON(pmd_table != pmd_offset(pud, 0));
@@ -100,7 +100,7 @@ static pte_t * __init one_page_table_init(pmd_t *pmd)
 				(pte_t *)alloc_bootmem_low_pages(PAGE_SIZE);
 		}
 
-		paravirt_alloc_pt(&init_mm, __pa(page_table) >> PAGE_SHIFT);
+		paravirt_alloc_pte(&init_mm, __pa(page_table) >> PAGE_SHIFT);
 		set_pmd(pmd, __pmd(__pa(page_table) | _PAGE_TABLE));
 		BUG_ON(page_table != pte_offset_kernel(pmd, 0));
 	}
@@ -365,7 +365,7 @@ void __init native_pagetable_setup_start(pgd_t *base)
 
 		pte_clear(NULL, va, pte);
 	}
-	paravirt_alloc_pd(&init_mm, __pa(base) >> PAGE_SHIFT);
+	paravirt_alloc_pmd(&init_mm, __pa(base) >> PAGE_SHIFT);
 }
 
 void __init native_pagetable_setup_done(pgd_t *base)
@@ -457,7 +457,7 @@ void zap_low_mappings(void)
 	 * Note that "pgd_clear()" doesn't do it for
 	 * us, because pgd_clear() is a no-op on i386.
 	 */
-	for (i = 0; i < USER_PTRS_PER_PGD; i++) {
+	for (i = 0; i < KERNEL_PGD_BOUNDARY; i++) {
 #ifdef CONFIG_X86_PAE
 		set_pgd(swapper_pg_dir+i, __pgd(1 + __pa(empty_zero_page)));
 #else
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 3a4baf9..36a3f7d 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -407,7 +407,7 @@ void __init early_ioremap_clear(void)
 
 	pmd = early_ioremap_pmd(fix_to_virt(FIX_BTMAP_BEGIN));
 	pmd_clear(pmd);
-	paravirt_release_pt(__pa(bm_pte) >> PAGE_SHIFT);
+	paravirt_release_pte(__pa(bm_pte) >> PAGE_SHIFT);
 	__flush_tlb_all();
 }
 
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index f7823a1..57e762c 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -483,9 +483,7 @@ static int split_large_page(pte_t *kpte, unsigned long address)
 		goto out_unlock;
 
 	pbase = (pte_t *)page_address(base);
-#ifdef CONFIG_X86_32
-	paravirt_alloc_pt(&init_mm, page_to_pfn(base));
-#endif
+	paravirt_alloc_pte(&init_mm, page_to_pfn(base));
 	ref_prot = pte_pgprot(pte_clrhuge(*kpte));
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
new file mode 100644
index 0000000..5015976
--- /dev/null
+++ b/arch/x86/mm/pgtable.c
@@ -0,0 +1,276 @@
+#include <linux/mm.h>
+#include <asm/pgalloc.h>
+#include <asm/pgtable.h>
+#include <asm/tlb.h>
+
+pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
+{
+	return (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
+}
+
+pgtable_t pte_alloc_one(struct mm_struct *mm, unsigned long address)
+{
+	struct page *pte;
+
+#ifdef CONFIG_HIGHPTE
+	pte = alloc_pages(GFP_KERNEL|__GFP_HIGHMEM|__GFP_REPEAT|__GFP_ZERO, 0);
+#else
+	pte = alloc_pages(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO, 0);
+#endif
+	if (pte)
+		pgtable_page_ctor(pte);
+	return pte;
+}
+
+void __pte_free_tlb(struct mmu_gather *tlb, struct page *pte)
+{
+	pgtable_page_dtor(pte);
+	paravirt_release_pte(page_to_pfn(pte));
+	tlb_remove_page(tlb, pte);
+}
+
+#if PAGETABLE_LEVELS > 2
+void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
+{
+	paravirt_release_pmd(__pa(pmd) >> PAGE_SHIFT);
+	tlb_remove_page(tlb, virt_to_page(pmd));
+}
+
+#if PAGETABLE_LEVELS > 3
+void __pud_free_tlb(struct mmu_gather *tlb, pud_t *pud)
+{
+	paravirt_release_pud(__pa(pud) >> PAGE_SHIFT);
+	tlb_remove_page(tlb, virt_to_page(pud));
+}
+#endif	/* PAGETABLE_LEVELS > 3 */
+#endif	/* PAGETABLE_LEVELS > 2 */
+
+static inline void pgd_list_add(pgd_t *pgd)
+{
+	struct page *page = virt_to_page(pgd);
+
+	list_add(&page->lru, &pgd_list);
+}
+
+static inline void pgd_list_del(pgd_t *pgd)
+{
+	struct page *page = virt_to_page(pgd);
+
+	list_del(&page->lru);
+}
+
+#define UNSHARED_PTRS_PER_PGD				\
+	(SHARED_KERNEL_PMD ? KERNEL_PGD_BOUNDARY : PTRS_PER_PGD)
+
+static void pgd_ctor(void *p)
+{
+	pgd_t *pgd = p;
+	unsigned long flags;
+
+	/* Clear usermode parts of PGD */
+	memset(pgd, 0, KERNEL_PGD_BOUNDARY*sizeof(pgd_t));
+
+	spin_lock_irqsave(&pgd_lock, flags);
+
+	/* If the pgd points to a shared pagetable level (either the
+	   ptes in non-PAE, or shared PMD in PAE), then just copy the
+	   references from swapper_pg_dir. */
+	if (PAGETABLE_LEVELS == 2 ||
+	    (PAGETABLE_LEVELS == 3 && SHARED_KERNEL_PMD) ||
+	    PAGETABLE_LEVELS == 4) {
+		clone_pgd_range(pgd + KERNEL_PGD_BOUNDARY,
+				swapper_pg_dir + KERNEL_PGD_BOUNDARY,
+				KERNEL_PGD_PTRS);
+		paravirt_alloc_pmd_clone(__pa(pgd) >> PAGE_SHIFT,
+					 __pa(swapper_pg_dir) >> PAGE_SHIFT,
+					 KERNEL_PGD_BOUNDARY,
+					 KERNEL_PGD_PTRS);
+	}
+
+	/* list required to sync kernel mapping updates */
+	if (!SHARED_KERNEL_PMD)
+		pgd_list_add(pgd);
+
+	spin_unlock_irqrestore(&pgd_lock, flags);
+}
+
+static void pgd_dtor(void *pgd)
+{
+	unsigned long flags; /* can be called from interrupt context */
+
+	if (SHARED_KERNEL_PMD)
+		return;
+
+	spin_lock_irqsave(&pgd_lock, flags);
+	pgd_list_del(pgd);
+	spin_unlock_irqrestore(&pgd_lock, flags);
+}
+
+/*
+ * List of all pgd's needed for non-PAE so it can invalidate entries
+ * in both cached and uncached pgd's; not needed for PAE since the
+ * kernel pmd is shared. If PAE were not to share the pmd a similar
+ * tactic would be needed. This is essentially codepath-based locking
+ * against pageattr.c; it is the unique case in which a valid change
+ * of kernel pagetables can't be lazily synchronized by vmalloc faults.
+ * vmalloc faults work because attached pagetables are never freed.
+ * -- wli
+ */
+
+#ifdef CONFIG_X86_PAE
+/*
+ * Mop up any pmd pages which may still be attached to the pgd.
+ * Normally they will be freed by munmap/exit_mmap, but any pmd we
+ * preallocate which never got a corresponding vma will need to be
+ * freed manually.
+ */
+static void pgd_mop_up_pmds(struct mm_struct *mm, pgd_t *pgdp)
+{
+	int i;
+
+	for(i = 0; i < UNSHARED_PTRS_PER_PGD; i++) {
+		pgd_t pgd = pgdp[i];
+
+		if (pgd_val(pgd) != 0) {
+			pmd_t *pmd = (pmd_t *)pgd_page_vaddr(pgd);
+
+			pgdp[i] = native_make_pgd(0);
+
+			paravirt_release_pmd(pgd_val(pgd) >> PAGE_SHIFT);
+			pmd_free(mm, pmd);
+		}
+	}
+}
+
+/*
+ * In PAE mode, we need to do a cr3 reload (=tlb flush) when
+ * updating the top-level pagetable entries to guarantee the
+ * processor notices the update.  Since this is expensive, and
+ * all 4 top-level entries are used almost immediately in a
+ * new process's life, we just pre-populate them here.
+ *
+ * Also, if we're in a paravirt environment where the kernel pmd is
+ * not shared between pagetables (!SHARED_KERNEL_PMDS), we allocate
+ * and initialize the kernel pmds here.
+ */
+static int pgd_prepopulate_pmd(struct mm_struct *mm, pgd_t *pgd)
+{
+	pud_t *pud;
+	unsigned long addr;
+	int i;
+
+	pud = pud_offset(pgd, 0);
+ 	for (addr = i = 0; i < UNSHARED_PTRS_PER_PGD;
+	     i++, pud++, addr += PUD_SIZE) {
+		pmd_t *pmd = pmd_alloc_one(mm, addr);
+
+		if (!pmd) {
+			pgd_mop_up_pmds(mm, pgd);
+			return 0;
+		}
+
+		if (i >= KERNEL_PGD_BOUNDARY)
+			memcpy(pmd, (pmd_t *)pgd_page_vaddr(swapper_pg_dir[i]),
+			       sizeof(pmd_t) * PTRS_PER_PMD);
+
+		pud_populate(mm, pud, pmd);
+	}
+
+	return 1;
+}
+
+void pud_populate(struct mm_struct *mm, pud_t *pudp, pmd_t *pmd)
+{
+	paravirt_alloc_pmd(mm, __pa(pmd) >> PAGE_SHIFT);
+
+	/* Note: almost everything apart from _PAGE_PRESENT is
+	   reserved at the pmd (PDPT) level. */
+	set_pud(pudp, __pud(__pa(pmd) | _PAGE_PRESENT));
+
+	/*
+	 * According to Intel App note "TLBs, Paging-Structure Caches,
+	 * and Their Invalidation", April 2007, document 317080-001,
+	 * section 8.1: in PAE mode we explicitly have to flush the
+	 * TLB via cr3 if the top-level pgd is changed...
+	 */
+	if (mm == current->active_mm)
+		write_cr3(read_cr3());
+}
+#else  /* !CONFIG_X86_PAE */
+/* No need to prepopulate any pagetable entries in non-PAE modes. */
+static int pgd_prepopulate_pmd(struct mm_struct *mm, pgd_t *pgd)
+{
+	return 1;
+}
+
+static void pgd_mop_up_pmds(struct mm_struct *mm, pgd_t *pgd)
+{
+}
+#endif	/* CONFIG_X86_PAE */
+
+pgd_t *pgd_alloc(struct mm_struct *mm)
+{
+	pgd_t *pgd = (pgd_t *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+
+	/* so that alloc_pmd can use it */
+	mm->pgd = pgd;
+	if (pgd)
+		pgd_ctor(pgd);
+
+	if (pgd && !pgd_prepopulate_pmd(mm, pgd)) {
+		pgd_dtor(pgd);
+		free_page((unsigned long)pgd);
+		pgd = NULL;
+	}
+
+	return pgd;
+}
+
+void pgd_free(struct mm_struct *mm, pgd_t *pgd)
+{
+	pgd_mop_up_pmds(mm, pgd);
+	pgd_dtor(pgd);
+	free_page((unsigned long)pgd);
+}
+
+int ptep_set_access_flags(struct vm_area_struct *vma,
+			  unsigned long address, pte_t *ptep,
+			  pte_t entry, int dirty)
+{
+	int changed = !pte_same(*ptep, entry);
+
+	if (changed && dirty) {
+		*ptep = entry;
+		pte_update_defer(vma->vm_mm, address, ptep);
+		flush_tlb_page(vma, address);
+	}
+
+	return changed;
+}
+
+int ptep_test_and_clear_young(struct vm_area_struct *vma,
+			      unsigned long addr, pte_t *ptep)
+{
+	int ret = 0;
+
+	if (pte_young(*ptep))
+		ret = test_and_clear_bit(_PAGE_BIT_ACCESSED,
+					 &ptep->pte);
+
+	if (ret)
+		pte_update(vma->vm_mm, addr, ptep);
+
+	return ret;
+}
+
+int ptep_clear_flush_young(struct vm_area_struct *vma,
+			   unsigned long address, pte_t *ptep)
+{
+	int young;
+
+	young = ptep_test_and_clear_young(vma, address, ptep);
+	if (young)
+		flush_tlb_page(vma, address);
+
+	return young;
+}
diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
index 6fb9e7c..9ee007b 100644
--- a/arch/x86/mm/pgtable_32.c
+++ b/arch/x86/mm/pgtable_32.c
@@ -173,210 +173,6 @@ void reserve_top_address(unsigned long reserve)
 	__VMALLOC_RESERVE += reserve;
 }
 
-pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
-{
-	return (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
-}
-
-pgtable_t pte_alloc_one(struct mm_struct *mm, unsigned long address)
-{
-	struct page *pte;
-
-#ifdef CONFIG_HIGHPTE
-	pte = alloc_pages(GFP_KERNEL|__GFP_HIGHMEM|__GFP_REPEAT|__GFP_ZERO, 0);
-#else
-	pte = alloc_pages(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO, 0);
-#endif
-	if (pte)
-		pgtable_page_ctor(pte);
-	return pte;
-}
-
-/*
- * List of all pgd's needed for non-PAE so it can invalidate entries
- * in both cached and uncached pgd's; not needed for PAE since the
- * kernel pmd is shared. If PAE were not to share the pmd a similar
- * tactic would be needed. This is essentially codepath-based locking
- * against pageattr.c; it is the unique case in which a valid change
- * of kernel pagetables can't be lazily synchronized by vmalloc faults.
- * vmalloc faults work because attached pagetables are never freed.
- * -- wli
- */
-static inline void pgd_list_add(pgd_t *pgd)
-{
-	struct page *page = virt_to_page(pgd);
-
-	list_add(&page->lru, &pgd_list);
-}
-
-static inline void pgd_list_del(pgd_t *pgd)
-{
-	struct page *page = virt_to_page(pgd);
-
-	list_del(&page->lru);
-}
-
-#define UNSHARED_PTRS_PER_PGD				\
-	(SHARED_KERNEL_PMD ? USER_PTRS_PER_PGD : PTRS_PER_PGD)
-
-static void pgd_ctor(void *p)
-{
-	pgd_t *pgd = p;
-	unsigned long flags;
-
-	/* Clear usermode parts of PGD */
-	memset(pgd, 0, USER_PTRS_PER_PGD*sizeof(pgd_t));
-
-	spin_lock_irqsave(&pgd_lock, flags);
-
-	/* If the pgd points to a shared pagetable level (either the
-	   ptes in non-PAE, or shared PMD in PAE), then just copy the
-	   references from swapper_pg_dir. */
-	if (PAGETABLE_LEVELS == 2 ||
-	    (PAGETABLE_LEVELS == 3 && SHARED_KERNEL_PMD)) {
-		clone_pgd_range(pgd + USER_PTRS_PER_PGD,
-				swapper_pg_dir + USER_PTRS_PER_PGD,
-				KERNEL_PGD_PTRS);
-		paravirt_alloc_pd_clone(__pa(pgd) >> PAGE_SHIFT,
-					__pa(swapper_pg_dir) >> PAGE_SHIFT,
-					USER_PTRS_PER_PGD,
-					KERNEL_PGD_PTRS);
-	}
-
-	/* list required to sync kernel mapping updates */
-	if (!SHARED_KERNEL_PMD)
-		pgd_list_add(pgd);
-
-	spin_unlock_irqrestore(&pgd_lock, flags);
-}
-
-static void pgd_dtor(void *pgd)
-{
-	unsigned long flags; /* can be called from interrupt context */
-
-	if (SHARED_KERNEL_PMD)
-		return;
-
-	spin_lock_irqsave(&pgd_lock, flags);
-	pgd_list_del(pgd);
-	spin_unlock_irqrestore(&pgd_lock, flags);
-}
-
-#ifdef CONFIG_X86_PAE
-/*
- * Mop up any pmd pages which may still be attached to the pgd.
- * Normally they will be freed by munmap/exit_mmap, but any pmd we
- * preallocate which never got a corresponding vma will need to be
- * freed manually.
- */
-static void pgd_mop_up_pmds(struct mm_struct *mm, pgd_t *pgdp)
-{
-	int i;
-
-	for(i = 0; i < UNSHARED_PTRS_PER_PGD; i++) {
-		pgd_t pgd = pgdp[i];
-
-		if (pgd_val(pgd) != 0) {
-			pmd_t *pmd = (pmd_t *)pgd_page_vaddr(pgd);
-
-			pgdp[i] = native_make_pgd(0);
-
-			paravirt_release_pd(pgd_val(pgd) >> PAGE_SHIFT);
-			pmd_free(mm, pmd);
-		}
-	}
-}
-
-/*
- * In PAE mode, we need to do a cr3 reload (=tlb flush) when
- * updating the top-level pagetable entries to guarantee the
- * processor notices the update.  Since this is expensive, and
- * all 4 top-level entries are used almost immediately in a
- * new process's life, we just pre-populate them here.
- *
- * Also, if we're in a paravirt environment where the kernel pmd is
- * not shared between pagetables (!SHARED_KERNEL_PMDS), we allocate
- * and initialize the kernel pmds here.
- */
-static int pgd_prepopulate_pmd(struct mm_struct *mm, pgd_t *pgd)
-{
-	pud_t *pud;
-	unsigned long addr;
-	int i;
-
-	pud = pud_offset(pgd, 0);
- 	for (addr = i = 0; i < UNSHARED_PTRS_PER_PGD;
-	     i++, pud++, addr += PUD_SIZE) {
-		pmd_t *pmd = pmd_alloc_one(mm, addr);
-
-		if (!pmd) {
-			pgd_mop_up_pmds(mm, pgd);
-			return 0;
-		}
-
-		if (i >= USER_PTRS_PER_PGD)
-			memcpy(pmd, (pmd_t *)pgd_page_vaddr(swapper_pg_dir[i]),
-			       sizeof(pmd_t) * PTRS_PER_PMD);
-
-		pud_populate(mm, pud, pmd);
-	}
-
-	return 1;
-}
-#else  /* !CONFIG_X86_PAE */
-/* No need to prepopulate any pagetable entries in non-PAE modes. */
-static int pgd_prepopulate_pmd(struct mm_struct *mm, pgd_t *pgd)
-{
-	return 1;
-}
-
-static void pgd_mop_up_pmds(struct mm_struct *mm, pgd_t *pgdp)
-{
-}
-#endif	/* CONFIG_X86_PAE */
-
-pgd_t *pgd_alloc(struct mm_struct *mm)
-{
-	pgd_t *pgd = (pgd_t *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
-
-	/* so that alloc_pd can use it */
-	mm->pgd = pgd;
-	if (pgd)
-		pgd_ctor(pgd);
-
-	if (pgd && !pgd_prepopulate_pmd(mm, pgd)) {
-		pgd_dtor(pgd);
-		free_page((unsigned long)pgd);
-		pgd = NULL;
-	}
-
-	return pgd;
-}
-
-void pgd_free(struct mm_struct *mm, pgd_t *pgd)
-{
-	pgd_mop_up_pmds(mm, pgd);
-	pgd_dtor(pgd);
-	free_page((unsigned long)pgd);
-}
-
-void __pte_free_tlb(struct mmu_gather *tlb, struct page *pte)
-{
-	pgtable_page_dtor(pte);
-	paravirt_release_pt(page_to_pfn(pte));
-	tlb_remove_page(tlb, pte);
-}
-
-#ifdef CONFIG_X86_PAE
-
-void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
-{
-	paravirt_release_pd(__pa(pmd) >> PAGE_SHIFT);
-	tlb_remove_page(tlb, virt_to_page(pmd));
-}
-
-#endif
-
 int pmd_bad(pmd_t pmd)
 {
 	WARN_ON_ONCE(pmd_bad_v1(pmd) != pmd_bad_v2(pmd));
diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index 4d5f264..2e641be 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -6,7 +6,7 @@ config XEN
 	bool "Xen guest support"
 	select PARAVIRT
 	depends on X86_32
-	depends on X86_CMPXCHG && X86_TSC && !NEED_MULTIPLE_NODES && !(X86_VISWS || X86_VOYAGER)
+	depends on X86_CMPXCHG && X86_TSC && !(X86_VISWS || X86_VOYAGER)
 	help
 	  This is the Linux Xen port.  Enabling this will allow the
 	  kernel to boot in a paravirtualized environment under the
diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index 343df24..3d8df98 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -1,4 +1,4 @@
-obj-y		:= enlighten.o setup.o features.o multicalls.o mmu.o \
-			events.o time.o manage.o xen-asm.o
+obj-y		:= enlighten.o setup.o multicalls.o mmu.o \
+			time.o manage.o xen-asm.o grant-table.o
 
 obj-$(CONFIG_SMP)	+= smp.o
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index c038822..c8a56e4 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -155,7 +155,8 @@ static void xen_cpuid(unsigned int *ax, unsigned int *bx,
 	if (*ax == 1)
 		maskedx = ~((1 << X86_FEATURE_APIC) |  /* disable APIC */
 			    (1 << X86_FEATURE_ACPI) |  /* disable ACPI */
-			    (1 << X86_FEATURE_SEP)  |  /* disable SEP */
+			    (1 << X86_FEATURE_MCE)  |  /* disable MCE */
+			    (1 << X86_FEATURE_MCA)  |  /* disable MCA */
 			    (1 << X86_FEATURE_ACC));   /* thermal monitoring */
 
 	asm(XEN_EMULATE_PREFIX "cpuid"
@@ -531,26 +532,37 @@ static void xen_apic_write(unsigned long reg, u32 val)
 static void xen_flush_tlb(void)
 {
 	struct mmuext_op *op;
-	struct multicall_space mcs = xen_mc_entry(sizeof(*op));
+	struct multicall_space mcs;
+
+	preempt_disable();
+
+	mcs = xen_mc_entry(sizeof(*op));
 
 	op = mcs.args;
 	op->cmd = MMUEXT_TLB_FLUSH_LOCAL;
 	MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);
 
 	xen_mc_issue(PARAVIRT_LAZY_MMU);
+
+	preempt_enable();
 }
 
 static void xen_flush_tlb_single(unsigned long addr)
 {
 	struct mmuext_op *op;
-	struct multicall_space mcs = xen_mc_entry(sizeof(*op));
+	struct multicall_space mcs;
+
+	preempt_disable();
 
+	mcs = xen_mc_entry(sizeof(*op));
 	op = mcs.args;
 	op->cmd = MMUEXT_INVLPG_LOCAL;
 	op->arg1.linear_addr = addr & PAGE_MASK;
 	MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);
 
 	xen_mc_issue(PARAVIRT_LAZY_MMU);
+
+	preempt_enable();
 }
 
 static void xen_flush_tlb_others(const cpumask_t *cpus, struct mm_struct *mm,
@@ -655,15 +667,17 @@ static void xen_write_cr3(unsigned long cr3)
 
 /* Early in boot, while setting up the initial pagetable, assume
    everything is pinned. */
-static __init void xen_alloc_pt_init(struct mm_struct *mm, u32 pfn)
+static __init void xen_alloc_pte_init(struct mm_struct *mm, u32 pfn)
 {
+#ifdef CONFIG_FLATMEM
 	BUG_ON(mem_map);	/* should only be used early */
+#endif
 	make_lowmem_page_readonly(__va(PFN_PHYS(pfn)));
 }
 
-/* Early release_pt assumes that all pts are pinned, since there's
+/* Early release_pte assumes that all pts are pinned, since there's
    only init_mm and anything attached to that is pinned. */
-static void xen_release_pt_init(u32 pfn)
+static void xen_release_pte_init(u32 pfn)
 {
 	make_lowmem_page_readwrite(__va(PFN_PHYS(pfn)));
 }
@@ -697,12 +711,12 @@ static void xen_alloc_ptpage(struct mm_struct *mm, u32 pfn, unsigned level)
 	}
 }
 
-static void xen_alloc_pt(struct mm_struct *mm, u32 pfn)
+static void xen_alloc_pte(struct mm_struct *mm, u32 pfn)
 {
 	xen_alloc_ptpage(mm, pfn, PT_PTE);
 }
 
-static void xen_alloc_pd(struct mm_struct *mm, u32 pfn)
+static void xen_alloc_pmd(struct mm_struct *mm, u32 pfn)
 {
 	xen_alloc_ptpage(mm, pfn, PT_PMD);
 }
@@ -722,12 +736,12 @@ static void xen_release_ptpage(u32 pfn, unsigned level)
 	}
 }
 
-static void xen_release_pt(u32 pfn)
+static void xen_release_pte(u32 pfn)
 {
 	xen_release_ptpage(pfn, PT_PTE);
 }
 
-static void xen_release_pd(u32 pfn)
+static void xen_release_pmd(u32 pfn)
 {
 	xen_release_ptpage(pfn, PT_PMD);
 }
@@ -849,10 +863,10 @@ static __init void xen_pagetable_setup_done(pgd_t *base)
 {
 	/* This will work as long as patching hasn't happened yet
 	   (which it hasn't) */
-	pv_mmu_ops.alloc_pt = xen_alloc_pt;
-	pv_mmu_ops.alloc_pd = xen_alloc_pd;
-	pv_mmu_ops.release_pt = xen_release_pt;
-	pv_mmu_ops.release_pd = xen_release_pd;
+	pv_mmu_ops.alloc_pte = xen_alloc_pte;
+	pv_mmu_ops.alloc_pmd = xen_alloc_pmd;
+	pv_mmu_ops.release_pte = xen_release_pte;
+	pv_mmu_ops.release_pmd = xen_release_pmd;
 	pv_mmu_ops.set_pte = xen_set_pte;
 
 	setup_shared_info();
@@ -994,7 +1008,7 @@ static const struct pv_cpu_ops xen_cpu_ops __initdata = {
 	.read_pmc = native_read_pmc,
 
 	.iret = xen_iret,
-	.irq_enable_syscall_ret = NULL,  /* never called */
+	.irq_enable_syscall_ret = xen_sysexit,
 
 	.load_tr_desc = paravirt_nop,
 	.set_ldt = xen_set_ldt,
@@ -1059,11 +1073,11 @@ static const struct pv_mmu_ops xen_mmu_ops __initdata = {
 	.pte_update = paravirt_nop,
 	.pte_update_defer = paravirt_nop,
 
-	.alloc_pt = xen_alloc_pt_init,
-	.release_pt = xen_release_pt_init,
-	.alloc_pd = xen_alloc_pt_init,
-	.alloc_pd_clone = paravirt_nop,
-	.release_pd = xen_release_pt_init,
+	.alloc_pte = xen_alloc_pte_init,
+	.release_pte = xen_release_pte_init,
+	.alloc_pmd = xen_alloc_pte_init,
+	.alloc_pmd_clone = paravirt_nop,
+	.release_pmd = xen_release_pte_init,
 
 #ifdef CONFIG_HIGHPTE
 	.kmap_atomic_pte = xen_kmap_atomic_pte,
diff --git a/arch/x86/xen/grant-table.c b/arch/x86/xen/grant-table.c
new file mode 100644
index 0000000..49ba9b5
--- /dev/null
+++ b/arch/x86/xen/grant-table.c
@@ -0,0 +1,91 @@
+/******************************************************************************
+ * grant_table.c
+ * x86 specific part
+ *
+ * Granting foreign access to our memory reservation.
+ *
+ * Copyright (c) 2005-2006, Christopher Clark
+ * Copyright (c) 2004-2005, K A Fraser
+ * Copyright (c) 2008 Isaku Yamahata <yamahata at valinux co jp>
+ *                    VA Linux Systems Japan. Split out x86 specific part.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation; or, when distributed
+ * separately from the Linux kernel or incorporated into other
+ * software packages, subject to the following license:
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this source file (the "Software"), to deal in the Software without
+ * restriction, including without limitation the rights to use, copy, modify,
+ * merge, publish, distribute, sublicense, and/or sell copies of the Software,
+ * and to permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
+ * IN THE SOFTWARE.
+ */
+
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/vmalloc.h>
+
+#include <xen/interface/xen.h>
+#include <xen/page.h>
+#include <xen/grant_table.h>
+
+#include <asm/pgtable.h>
+
+static int map_pte_fn(pte_t *pte, struct page *pmd_page,
+		      unsigned long addr, void *data)
+{
+	unsigned long **frames = (unsigned long **)data;
+
+	set_pte_at(&init_mm, addr, pte, mfn_pte((*frames)[0], PAGE_KERNEL));
+	(*frames)++;
+	return 0;
+}
+
+static int unmap_pte_fn(pte_t *pte, struct page *pmd_page,
+			unsigned long addr, void *data)
+{
+
+	set_pte_at(&init_mm, addr, pte, __pte(0));
+	return 0;
+}
+
+int arch_gnttab_map_shared(unsigned long *frames, unsigned long nr_gframes,
+			   unsigned long max_nr_gframes,
+			   struct grant_entry **__shared)
+{
+	int rc;
+	struct grant_entry *shared = *__shared;
+
+	if (shared == NULL) {
+		struct vm_struct *area =
+			xen_alloc_vm_area(PAGE_SIZE * max_nr_gframes);
+		BUG_ON(area == NULL);
+		shared = area->addr;
+		*__shared = shared;
+	}
+
+	rc = apply_to_page_range(&init_mm, (unsigned long)shared,
+				 PAGE_SIZE * nr_gframes,
+				 map_pte_fn, &frames);
+	return rc;
+}
+
+void arch_gnttab_unmap_shared(struct grant_entry *shared,
+			      unsigned long nr_gframes)
+{
+	apply_to_page_range(&init_mm, (unsigned long)shared,
+			    PAGE_SIZE * nr_gframes, unmap_pte_fn, NULL);
+}
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 2a054ef..6cbcf65 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -156,6 +156,10 @@ void set_pte_mfn(unsigned long vaddr, unsigned long mfn, pgprot_t flags)
 void xen_set_pte_at(struct mm_struct *mm, unsigned long addr,
 		    pte_t *ptep, pte_t pteval)
 {
+	/* updates to init_mm may be done without lock */
+	if (mm == &init_mm)
+		preempt_disable();
+
 	if (mm == current->mm || mm == &init_mm) {
 		if (paravirt_get_lazy_mode() == PARAVIRT_LAZY_MMU) {
 			struct multicall_space mcs;
@@ -163,14 +167,61 @@ void xen_set_pte_at(struct mm_struct *mm, unsigned long addr,
 
 			MULTI_update_va_mapping(mcs.mc, addr, pteval, 0);
 			xen_mc_issue(PARAVIRT_LAZY_MMU);
-			return;
+			goto out;
 		} else
 			if (HYPERVISOR_update_va_mapping(addr, pteval, 0) == 0)
-				return;
+				goto out;
 	}
 	xen_set_pte(ptep, pteval);
+
+out:
+	if (mm == &init_mm)
+		preempt_enable();
+}
+
+pteval_t xen_pte_val(pte_t pte)
+{
+	pteval_t ret = pte.pte;
+
+	if (ret & _PAGE_PRESENT)
+		ret = machine_to_phys(XMADDR(ret)).paddr | _PAGE_PRESENT;
+
+	return ret;
+}
+
+pgdval_t xen_pgd_val(pgd_t pgd)
+{
+	pgdval_t ret = pgd.pgd;
+	if (ret & _PAGE_PRESENT)
+		ret = machine_to_phys(XMADDR(ret)).paddr | _PAGE_PRESENT;
+	return ret;
+}
+
+pte_t xen_make_pte(pteval_t pte)
+{
+	if (pte & _PAGE_PRESENT) {
+		pte = phys_to_machine(XPADDR(pte)).maddr;
+		pte &= ~(_PAGE_PCD | _PAGE_PWT);
+	}
+
+	return (pte_t){ .pte = pte };
 }
 
+pgd_t xen_make_pgd(pgdval_t pgd)
+{
+	if (pgd & _PAGE_PRESENT)
+		pgd = phys_to_machine(XPADDR(pgd)).maddr;
+
+	return (pgd_t){ pgd };
+}
+
+pmdval_t xen_pmd_val(pmd_t pmd)
+{
+	pmdval_t ret = native_pmd_val(pmd);
+	if (ret & _PAGE_PRESENT)
+		ret = machine_to_phys(XMADDR(ret)).paddr | _PAGE_PRESENT;
+	return ret;
+}
 #ifdef CONFIG_X86_PAE
 void xen_set_pud(pud_t *ptr, pud_t val)
 {
@@ -214,100 +265,18 @@ void xen_pmd_clear(pmd_t *pmdp)
 	xen_set_pmd(pmdp, __pmd(0));
 }
 
-unsigned long long xen_pte_val(pte_t pte)
+pmd_t xen_make_pmd(pmdval_t pmd)
 {
-	unsigned long long ret = 0;
-
-	if (pte.pte_low) {
-		ret = ((unsigned long long)pte.pte_high << 32) | pte.pte_low;
-		ret = machine_to_phys(XMADDR(ret)).paddr | 1;
-	}
-
-	return ret;
-}
-
-unsigned long long xen_pmd_val(pmd_t pmd)
-{
-	unsigned long long ret = pmd.pmd;
-	if (ret)
-		ret = machine_to_phys(XMADDR(ret)).paddr | 1;
-	return ret;
-}
-
-unsigned long long xen_pgd_val(pgd_t pgd)
-{
-	unsigned long long ret = pgd.pgd;
-	if (ret)
-		ret = machine_to_phys(XMADDR(ret)).paddr | 1;
-	return ret;
-}
-
-pte_t xen_make_pte(unsigned long long pte)
-{
-	if (pte & _PAGE_PRESENT) {
-		pte = phys_to_machine(XPADDR(pte)).maddr;
-		pte &= ~(_PAGE_PCD | _PAGE_PWT);
-	}
-
-	return (pte_t){ .pte = pte };
-}
-
-pmd_t xen_make_pmd(unsigned long long pmd)
-{
-	if (pmd & 1)
+	if (pmd & _PAGE_PRESENT)
 		pmd = phys_to_machine(XPADDR(pmd)).maddr;
 
-	return (pmd_t){ pmd };
-}
-
-pgd_t xen_make_pgd(unsigned long long pgd)
-{
-	if (pgd & _PAGE_PRESENT)
-		pgd = phys_to_machine(XPADDR(pgd)).maddr;
-
-	return (pgd_t){ pgd };
+	return native_make_pmd(pmd);
 }
 #else  /* !PAE */
 void xen_set_pte(pte_t *ptep, pte_t pte)
 {
 	*ptep = pte;
 }
-
-unsigned long xen_pte_val(pte_t pte)
-{
-	unsigned long ret = pte.pte_low;
-
-	if (ret & _PAGE_PRESENT)
-		ret = machine_to_phys(XMADDR(ret)).paddr;
-
-	return ret;
-}
-
-unsigned long xen_pgd_val(pgd_t pgd)
-{
-	unsigned long ret = pgd.pgd;
-	if (ret)
-		ret = machine_to_phys(XMADDR(ret)).paddr | 1;
-	return ret;
-}
-
-pte_t xen_make_pte(unsigned long pte)
-{
-	if (pte & _PAGE_PRESENT) {
-		pte = phys_to_machine(XPADDR(pte)).maddr;
-		pte &= ~(_PAGE_PCD | _PAGE_PWT);
-	}
-
-	return (pte_t){ pte };
-}
-
-pgd_t xen_make_pgd(unsigned long pgd)
-{
-	if (pgd & _PAGE_PRESENT)
-		pgd = phys_to_machine(XPADDR(pgd)).maddr;
-
-	return (pgd_t){ pgd };
-}
 #endif	/* CONFIG_X86_PAE */
 
 /*
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 2341492..82517e4 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -16,6 +16,7 @@
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
 
+#include <xen/interface/callback.h>
 #include <xen/interface/physdev.h>
 #include <xen/features.h>
 
@@ -68,6 +69,24 @@ static void __init fiddle_vdso(void)
 	*mask |= 1 << VDSO_NOTE_NONEGSEG_BIT;
 }
 
+void xen_enable_sysenter(void)
+{
+	int cpu = smp_processor_id();
+	extern void xen_sysenter_target(void);
+	/* Mask events on entry, even though they get enabled immediately */
+	static struct callback_register sysenter = {
+		.type = CALLBACKTYPE_sysenter,
+		.address = { __KERNEL_CS, (unsigned long)xen_sysenter_target },
+		.flags = CALLBACKF_mask_events,
+	};
+
+	if (!boot_cpu_has(X86_FEATURE_SEP) ||
+	    HYPERVISOR_callback_op(CALLBACKOP_register, &sysenter) != 0) {
+		clear_cpu_cap(&cpu_data(cpu), X86_FEATURE_SEP);
+		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_SEP);
+	}
+}
+
 void __init xen_arch_setup(void)
 {
 	struct physdev_set_iopl set_iopl;
@@ -82,6 +101,8 @@ void __init xen_arch_setup(void)
 	HYPERVISOR_set_callbacks(__KERNEL_CS, (unsigned long)xen_hypervisor_callback,
 				 __KERNEL_CS, (unsigned long)xen_failsafe_callback);
 
+	xen_enable_sysenter();
+
 	set_iopl.iopl = 1;
 	rc = HYPERVISOR_physdev_op(PHYSDEVOP_set_iopl, &set_iopl);
 	if (rc != 0)
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index e340ff9..92dd3db 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -36,8 +36,9 @@
 #include "mmu.h"
 
 static cpumask_t xen_cpu_initialized_map;
-static DEFINE_PER_CPU(int, resched_irq);
-static DEFINE_PER_CPU(int, callfunc_irq);
+static DEFINE_PER_CPU(int, resched_irq) = -1;
+static DEFINE_PER_CPU(int, callfunc_irq) = -1;
+static DEFINE_PER_CPU(int, debug_irq) = -1;
 
 /*
  * Structure and data for smp_call_function(). This is designed to minimise
@@ -72,6 +73,7 @@ static __cpuinit void cpu_bringup_and_idle(void)
 	int cpu = smp_processor_id();
 
 	cpu_init();
+	xen_enable_sysenter();
 
 	preempt_disable();
 	per_cpu(cpu_state, cpu) = CPU_ONLINE;
@@ -88,9 +90,7 @@ static __cpuinit void cpu_bringup_and_idle(void)
 static int xen_smp_intr_init(unsigned int cpu)
 {
 	int rc;
-	const char *resched_name, *callfunc_name;
-
-	per_cpu(resched_irq, cpu) = per_cpu(callfunc_irq, cpu) = -1;
+	const char *resched_name, *callfunc_name, *debug_name;
 
 	resched_name = kasprintf(GFP_KERNEL, "resched%d", cpu);
 	rc = bind_ipi_to_irqhandler(XEN_RESCHEDULE_VECTOR,
@@ -114,6 +114,14 @@ static int xen_smp_intr_init(unsigned int cpu)
 		goto fail;
 	per_cpu(callfunc_irq, cpu) = rc;
 
+	debug_name = kasprintf(GFP_KERNEL, "debug%d", cpu);
+	rc = bind_virq_to_irqhandler(VIRQ_DEBUG, cpu, xen_debug_interrupt,
+				     IRQF_DISABLED | IRQF_PERCPU | IRQF_NOBALANCING,
+				     debug_name, NULL);
+	if (rc < 0)
+		goto fail;
+	per_cpu(debug_irq, cpu) = rc;
+
 	return 0;
 
  fail:
@@ -121,6 +129,8 @@ static int xen_smp_intr_init(unsigned int cpu)
 		unbind_from_irqhandler(per_cpu(resched_irq, cpu), NULL);
 	if (per_cpu(callfunc_irq, cpu) >= 0)
 		unbind_from_irqhandler(per_cpu(callfunc_irq, cpu), NULL);
+	if (per_cpu(debug_irq, cpu) >= 0)
+		unbind_from_irqhandler(per_cpu(debug_irq, cpu), NULL);
 	return rc;
 }
 
diff --git a/arch/x86/xen/xen-asm.S b/arch/x86/xen/xen-asm.S
index fe161ed..2497a30 100644
--- a/arch/x86/xen/xen-asm.S
+++ b/arch/x86/xen/xen-asm.S
@@ -108,6 +108,20 @@ ENDPATCH(xen_restore_fl_direct)
 	RELOC(xen_restore_fl_direct, 2b+1)
 
 /*
+	We can't use sysexit directly, because we're not running in ring0.
+	But we can easily fake it up using iret.  Assuming xen_sysexit
+	is jumped to with a standard stack frame, we can just strip it
+	back to a standard iret frame and use iret.
+ */
+ENTRY(xen_sysexit)
+	movl PT_EAX(%esp), %eax			/* Shouldn't be necessary? */
+	orl $X86_EFLAGS_IF, PT_EFLAGS(%esp)
+	lea PT_EIP(%esp), %esp
+
+	jmp xen_iret
+ENDPROC(xen_sysexit)
+
+/*
 	This is run where a normal iret would be run, with the same stack setup:
 	      8: eflags
 	      4: cs
@@ -184,8 +198,12 @@ iret_restore_end:
 	   region is OK. */
 	je xen_hypervisor_callback
 
-	iret
+1:	iret
 xen_iret_end_crit:
+.section __ex_table,"a"
+	.align 4
+	.long 1b,iret_exc
+.previous
 
 hyper_iret:
 	/* put this out of line since its very rarely used */
@@ -219,9 +237,7 @@ hyper_iret:
 	 ds		}  SAVE_ALL state
 	 eax		}
 	  :		:
-	 ebx		}
-	----------------
-	 return addr	 <- esp
+	 ebx		}<- esp
 	----------------
 
    In order to deliver the nested exception properly, we need to shift
@@ -236,10 +252,8 @@ hyper_iret:
    it's usermode state which we eventually need to restore.
  */
 ENTRY(xen_iret_crit_fixup)
-	/* offsets +4 for return address */
-
 	/*
-	   Paranoia: Make sure we're really coming from userspace.
+	   Paranoia: Make sure we're really coming from kernel space.
 	   One could imagine a case where userspace jumps into the
 	   critical range address, but just before the CPU delivers a GP,
 	   it decides to deliver an interrupt instead.  Unlikely?
@@ -248,32 +262,32 @@ ENTRY(xen_iret_crit_fixup)
 	   jump instruction itself, not the destination, but some virtual
 	   environments get this wrong.
 	 */
-	movl PT_CS+4(%esp), %ecx
+	movl PT_CS(%esp), %ecx
 	andl $SEGMENT_RPL_MASK, %ecx
 	cmpl $USER_RPL, %ecx
 	je 2f
 
-	lea PT_ORIG_EAX+4(%esp), %esi
-	lea PT_EFLAGS+4(%esp), %edi
+	lea PT_ORIG_EAX(%esp), %esi
+	lea PT_EFLAGS(%esp), %edi
 
 	/* If eip is before iret_restore_end then stack
 	   hasn't been restored yet. */
 	cmp $iret_restore_end, %eax
 	jae 1f
 
-	movl 0+4(%edi),%eax		/* copy EAX */
-	movl %eax, PT_EAX+4(%esp)
+	movl 0+4(%edi),%eax		/* copy EAX (just above top of frame) */
+	movl %eax, PT_EAX(%esp)
 
 	lea ESP_OFFSET(%edi),%edi	/* move dest up over saved regs */
 
 	/* set up the copy */
 1:	std
-	mov $(PT_EIP+4) / 4, %ecx	/* copy ret+saved regs up to orig_eax */
+	mov $PT_EIP / 4, %ecx		/* saved regs up to orig_eax */
 	rep movsl
 	cld
 
 	lea 4(%edi),%esp		/* point esp to new frame */
-2:	ret
+2:	jmp xen_do_upcall
 
 
 /*
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 956a491..f1063ae 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -2,6 +2,8 @@
 #define XEN_OPS_H
 
 #include <linux/init.h>
+#include <linux/irqreturn.h>
+#include <xen/xen-ops.h>
 
 /* These are code, but not functions.  Defined in entry.S */
 extern const char xen_hypervisor_callback[];
@@ -9,7 +11,6 @@ extern const char xen_failsafe_callback[];
 
 void xen_copy_trap_info(struct trap_info *traps);
 
-DECLARE_PER_CPU(struct vcpu_info *, xen_vcpu);
 DECLARE_PER_CPU(unsigned long, xen_cr3);
 DECLARE_PER_CPU(unsigned long, xen_current_cr3);
 
@@ -19,6 +20,7 @@ extern struct shared_info *HYPERVISOR_shared_info;
 char * __init xen_memory_setup(void);
 void __init xen_arch_setup(void);
 void __init xen_init_IRQ(void);
+void xen_enable_sysenter(void);
 
 void xen_setup_timer(int cpu);
 void xen_setup_cpu_clockevents(void);
@@ -28,6 +30,8 @@ unsigned long xen_get_wallclock(void);
 int xen_set_wallclock(unsigned long time);
 unsigned long long xen_sched_clock(void);
 
+irqreturn_t xen_debug_interrupt(int irq, void *dev_id);
+
 bool xen_vcpu_stolen(int vcpu);
 
 void xen_mark_init_mm_pinned(void);
@@ -64,4 +68,6 @@ DECL_ASM(unsigned long, xen_save_fl_direct, void);
 DECL_ASM(void, xen_restore_fl_direct, unsigned long);
 
 void xen_iret(void);
+void xen_sysexit(void);
+
 #endif /* XEN_OPS_H */
diff --git a/drivers/Kconfig b/drivers/Kconfig
index 3a0e354..80f0ec9 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -97,4 +97,6 @@ source "drivers/dca/Kconfig"
 source "drivers/auxdisplay/Kconfig"
 
 source "drivers/uio/Kconfig"
+
+source "drivers/xen/Kconfig"
 endmenu
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 9c6f3f9..d771da8 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -47,6 +47,7 @@
 
 #include <xen/interface/grant_table.h>
 #include <xen/interface/io/blkif.h>
+#include <xen/interface/io/protocols.h>
 
 #include <asm/xen/hypervisor.h>
 
@@ -74,7 +75,6 @@ static struct block_device_operations xlvbd_block_fops;
 struct blkfront_info
 {
 	struct xenbus_device *xbdev;
-	dev_t dev;
 	struct gendisk *gd;
 	int vdevice;
 	blkif_vdev_t handle;
@@ -88,6 +88,7 @@ struct blkfront_info
 	struct blk_shadow shadow[BLK_RING_SIZE];
 	unsigned long shadow_free;
 	int feature_barrier;
+	int is_ready;
 
 	/**
 	 * The number of people holding this device open.  We won't allow a
@@ -614,6 +615,12 @@ again:
 		message = "writing event-channel";
 		goto abort_transaction;
 	}
+	err = xenbus_printf(xbt, dev->nodename, "protocol", "%s",
+			    XEN_IO_PROTO_ABI_NATIVE);
+	if (err) {
+		message = "writing protocol";
+		goto abort_transaction;
+	}
 
 	err = xenbus_transaction_end(xbt, 0);
 	if (err) {
@@ -833,6 +840,8 @@ static void blkfront_connect(struct blkfront_info *info)
 	spin_unlock_irq(&blkif_io_lock);
 
 	add_disk(info->gd);
+
+	info->is_ready = 1;
 }
 
 /**
@@ -896,7 +905,7 @@ static void backend_changed(struct xenbus_device *dev,
 		break;
 
 	case XenbusStateClosing:
-		bd = bdget(info->dev);
+		bd = bdget_disk(info->gd, 0);
 		if (bd == NULL)
 			xenbus_dev_fatal(dev, -ENODEV, "bdget failed");
 
@@ -925,6 +934,13 @@ static int blkfront_remove(struct xenbus_device *dev)
 	return 0;
 }
 
+static int blkfront_is_ready(struct xenbus_device *dev)
+{
+	struct blkfront_info *info = dev->dev.driver_data;
+
+	return info->is_ready;
+}
+
 static int blkif_open(struct inode *inode, struct file *filep)
 {
 	struct blkfront_info *info = inode->i_bdev->bd_disk->private_data;
@@ -971,6 +987,7 @@ static struct xenbus_driver blkfront = {
 	.remove = blkfront_remove,
 	.resume = blkfront_resume,
 	.otherend_changed = backend_changed,
+	.is_ready = blkfront_is_ready,
 };
 
 static int __init xlblk_init(void)
@@ -998,3 +1015,5 @@ module_exit(xlblk_exit);
 MODULE_DESCRIPTION("Xen virtual block device frontend");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(XENVBD_MAJOR);
+MODULE_ALIAS("xen:vbd");
+MODULE_ALIAS("xenblk");
diff --git a/drivers/input/Kconfig b/drivers/input/Kconfig
index 9dea14d..5f9d860 100644
--- a/drivers/input/Kconfig
+++ b/drivers/input/Kconfig
@@ -149,6 +149,15 @@ config INPUT_APMPOWER
 	  To compile this driver as a module, choose M here: the
 	  module will be called apm-power.
 
+config XEN_KBDDEV_FRONTEND
+	tristate "Xen virtual keyboard and mouse support"
+	depends on XEN_FBDEV_FRONTEND
+	default y
+	help
+	  This driver implements the front-end of the Xen virtual
+	  keyboard and mouse device driver.  It communicates with a back-end
+	  in another domain.
+
 comment "Input Device Drivers"
 
 source "drivers/input/keyboard/Kconfig"
diff --git a/drivers/input/Makefile b/drivers/input/Makefile
index 2ae87b1..98c4f9a 100644
--- a/drivers/input/Makefile
+++ b/drivers/input/Makefile
@@ -23,3 +23,5 @@ obj-$(CONFIG_INPUT_TOUCHSCREEN)	+= touchscreen/
 obj-$(CONFIG_INPUT_MISC)	+= misc/
 
 obj-$(CONFIG_INPUT_APMPOWER)	+= apm-power.o
+
+obj-$(CONFIG_XEN_KBDDEV_FRONTEND)	+= xen-kbdfront.o
diff --git a/drivers/input/xen-kbdfront.c b/drivers/input/xen-kbdfront.c
new file mode 100644
index 0000000..0f47f46
--- /dev/null
+++ b/drivers/input/xen-kbdfront.c
@@ -0,0 +1,340 @@
+/*
+ * Xen para-virtual input device
+ *
+ * Copyright (C) 2005 Anthony Liguori <aliguori@us.ibm.com>
+ * Copyright (C) 2006-2008 Red Hat, Inc., Markus Armbruster <armbru@redhat.com>
+ *
+ *  Based on linux/drivers/input/mouse/sermouse.c
+ *
+ *  This file is subject to the terms and conditions of the GNU General Public
+ *  License. See the file COPYING in the main directory of this archive for
+ *  more details.
+ */
+
+/*
+ * TODO:
+ *
+ * Switch to grant tables together with xen-fbfront.c.
+ */
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/input.h>
+#include <asm/xen/hypervisor.h>
+#include <xen/events.h>
+#include <xen/page.h>
+#include <xen/interface/io/fbif.h>
+#include <xen/interface/io/kbdif.h>
+#include <xen/xenbus.h>
+
+struct xenkbd_info {
+	struct input_dev *kbd;
+	struct input_dev *ptr;
+	struct xenkbd_page *page;
+	int irq;
+	struct xenbus_device *xbdev;
+	char phys[32];
+};
+
+static int xenkbd_remove(struct xenbus_device *);
+static int xenkbd_connect_backend(struct xenbus_device *, struct xenkbd_info *);
+static void xenkbd_disconnect_backend(struct xenkbd_info *);
+
+/*
+ * Note: if you need to send out events, see xenfb_do_update() for how
+ * to do that.
+ */
+
+static irqreturn_t input_handler(int rq, void *dev_id)
+{
+	struct xenkbd_info *info = dev_id;
+	struct xenkbd_page *page = info->page;
+	__u32 cons, prod;
+
+	prod = page->in_prod;
+	if (prod == page->in_cons)
+		return IRQ_HANDLED;
+	rmb();			/* ensure we see ring contents up to prod */
+	for (cons = page->in_cons; cons != prod; cons++) {
+		union xenkbd_in_event *event;
+		struct input_dev *dev;
+		event = &XENKBD_IN_RING_REF(page, cons);
+
+		dev = info->ptr;
+		switch (event->type) {
+		case XENKBD_TYPE_MOTION:
+			input_report_rel(dev, REL_X, event->motion.rel_x);
+			input_report_rel(dev, REL_Y, event->motion.rel_y);
+			break;
+		case XENKBD_TYPE_KEY:
+			dev = NULL;
+			if (test_bit(event->key.keycode, info->kbd->keybit))
+				dev = info->kbd;
+			if (test_bit(event->key.keycode, info->ptr->keybit))
+				dev = info->ptr;
+			if (dev)
+				input_report_key(dev, event->key.keycode,
+						 event->key.pressed);
+			else
+				printk(KERN_WARNING
+				       "xenkbd: unhandled keycode 0x%x\n",
+				       event->key.keycode);
+			break;
+		case XENKBD_TYPE_POS:
+			input_report_abs(dev, ABS_X, event->pos.abs_x);
+			input_report_abs(dev, ABS_Y, event->pos.abs_y);
+			break;
+		}
+		if (dev)
+			input_sync(dev);
+	}
+	mb();			/* ensure we got ring contents */
+	page->in_cons = cons;
+	notify_remote_via_irq(info->irq);
+
+	return IRQ_HANDLED;
+}
+
+static int __devinit xenkbd_probe(struct xenbus_device *dev,
+				  const struct xenbus_device_id *id)
+{
+	int ret, i;
+	struct xenkbd_info *info;
+	struct input_dev *kbd, *ptr;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info) {
+		xenbus_dev_fatal(dev, -ENOMEM, "allocating info structure");
+		return -ENOMEM;
+	}
+	dev->dev.driver_data = info;
+	info->xbdev = dev;
+	info->irq = -1;
+	snprintf(info->phys, sizeof(info->phys), "xenbus/%s", dev->nodename);
+
+	info->page = (void *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+	if (!info->page)
+		goto error_nomem;
+
+	/* keyboard */
+	kbd = input_allocate_device();
+	if (!kbd)
+		goto error_nomem;
+	kbd->name = "Xen Virtual Keyboard";
+	kbd->phys = info->phys;
+	kbd->id.bustype = BUS_PCI;
+	kbd->id.vendor = 0x5853;
+	kbd->id.product = 0xffff;
+	kbd->evbit[0] = BIT(EV_KEY);
+	for (i = KEY_ESC; i < KEY_UNKNOWN; i++)
+		set_bit(i, kbd->keybit);
+	for (i = KEY_OK; i < KEY_MAX; i++)
+		set_bit(i, kbd->keybit);
+
+	ret = input_register_device(kbd);
+	if (ret) {
+		input_free_device(kbd);
+		xenbus_dev_fatal(dev, ret, "input_register_device(kbd)");
+		goto error;
+	}
+	info->kbd = kbd;
+
+	/* pointing device */
+	ptr = input_allocate_device();
+	if (!ptr)
+		goto error_nomem;
+	ptr->name = "Xen Virtual Pointer";
+	ptr->phys = info->phys;
+	ptr->id.bustype = BUS_PCI;
+	ptr->id.vendor = 0x5853;
+	ptr->id.product = 0xfffe;
+	ptr->evbit[0] = BIT(EV_KEY) | BIT(EV_REL) | BIT(EV_ABS);
+	for (i = BTN_LEFT; i <= BTN_TASK; i++)
+		set_bit(i, ptr->keybit);
+	ptr->relbit[0] = BIT(REL_X) | BIT(REL_Y);
+	input_set_abs_params(ptr, ABS_X, 0, XENFB_WIDTH, 0, 0);
+	input_set_abs_params(ptr, ABS_Y, 0, XENFB_HEIGHT, 0, 0);
+
+	ret = input_register_device(ptr);
+	if (ret) {
+		input_free_device(ptr);
+		xenbus_dev_fatal(dev, ret, "input_register_device(ptr)");
+		goto error;
+	}
+	info->ptr = ptr;
+
+	ret = xenkbd_connect_backend(dev, info);
+	if (ret < 0)
+		goto error;
+
+	return 0;
+
+ error_nomem:
+	ret = -ENOMEM;
+	xenbus_dev_fatal(dev, ret, "allocating device memory");
+ error:
+	xenkbd_remove(dev);
+	return ret;
+}
+
+static int xenkbd_resume(struct xenbus_device *dev)
+{
+	struct xenkbd_info *info = dev->dev.driver_data;
+
+	xenkbd_disconnect_backend(info);
+	memset(info->page, 0, PAGE_SIZE);
+	return xenkbd_connect_backend(dev, info);
+}
+
+static int xenkbd_remove(struct xenbus_device *dev)
+{
+	struct xenkbd_info *info = dev->dev.driver_data;
+
+	xenkbd_disconnect_backend(info);
+	if (info->kbd)
+		input_unregister_device(info->kbd);
+	if (info->ptr)
+		input_unregister_device(info->ptr);
+	free_page((unsigned long)info->page);
+	kfree(info);
+	return 0;
+}
+
+static int xenkbd_connect_backend(struct xenbus_device *dev,
+				  struct xenkbd_info *info)
+{
+	int ret, evtchn;
+	struct xenbus_transaction xbt;
+
+	ret = xenbus_alloc_evtchn(dev, &evtchn);
+	if (ret)
+		return ret;
+	ret = bind_evtchn_to_irqhandler(evtchn, input_handler,
+					0, dev->devicetype, info);
+	if (ret < 0) {
+		xenbus_free_evtchn(dev, evtchn);
+		xenbus_dev_fatal(dev, ret, "bind_evtchn_to_irqhandler");
+		return ret;
+	}
+	info->irq = ret;
+
+ again:
+	ret = xenbus_transaction_start(&xbt);
+	if (ret) {
+		xenbus_dev_fatal(dev, ret, "starting transaction");
+		return ret;
+	}
+	ret = xenbus_printf(xbt, dev->nodename, "page-ref", "%lu",
+			    virt_to_mfn(info->page));
+	if (ret)
+		goto error_xenbus;
+	ret = xenbus_printf(xbt, dev->nodename, "event-channel", "%u",
+			    evtchn);
+	if (ret)
+		goto error_xenbus;
+	ret = xenbus_transaction_end(xbt, 0);
+	if (ret) {
+		if (ret == -EAGAIN)
+			goto again;
+		xenbus_dev_fatal(dev, ret, "completing transaction");
+		return ret;
+	}
+
+	xenbus_switch_state(dev, XenbusStateInitialised);
+	return 0;
+
+ error_xenbus:
+	xenbus_transaction_end(xbt, 1);
+	xenbus_dev_fatal(dev, ret, "writing xenstore");
+	return ret;
+}
+
+static void xenkbd_disconnect_backend(struct xenkbd_info *info)
+{
+	if (info->irq >= 0)
+		unbind_from_irqhandler(info->irq, info);
+	info->irq = -1;
+}
+
+static void xenkbd_backend_changed(struct xenbus_device *dev,
+				   enum xenbus_state backend_state)
+{
+	struct xenkbd_info *info = dev->dev.driver_data;
+	int ret, val;
+
+	switch (backend_state) {
+	case XenbusStateInitialising:
+	case XenbusStateInitialised:
+	case XenbusStateUnknown:
+	case XenbusStateClosed:
+		break;
+
+	case XenbusStateInitWait:
+InitWait:
+		ret = xenbus_scanf(XBT_NIL, info->xbdev->otherend,
+				   "feature-abs-pointer", "%d", &val);
+		if (ret < 0)
+			val = 0;
+		if (val) {
+			ret = xenbus_printf(XBT_NIL, info->xbdev->nodename,
+					    "request-abs-pointer", "1");
+			if (ret)
+				printk(KERN_WARNING
+				       "xenkbd: can't request abs-pointer");
+		}
+		xenbus_switch_state(dev, XenbusStateConnected);
+		break;
+
+	case XenbusStateConnected:
+		/*
+		 * Work around xenbus race condition: If backend goes
+		 * through InitWait to Connected fast enough, we can
+		 * get Connected twice here.
+		 */
+		if (dev->state != XenbusStateConnected)
+			goto InitWait; /* no InitWait seen yet, fudge it */
+		break;
+
+	case XenbusStateClosing:
+		xenbus_frontend_closed(dev);
+		break;
+	}
+}
+
+static struct xenbus_device_id xenkbd_ids[] = {
+	{ "vkbd" },
+	{ "" }
+};
+
+static struct xenbus_driver xenkbd = {
+	.name = "vkbd",
+	.owner = THIS_MODULE,
+	.ids = xenkbd_ids,
+	.probe = xenkbd_probe,
+	.remove = xenkbd_remove,
+	.resume = xenkbd_resume,
+	.otherend_changed = xenkbd_backend_changed,
+};
+
+static int __init xenkbd_init(void)
+{
+	if (!is_running_on_xen())
+		return -ENODEV;
+
+	/* Nothing to do if running in dom0. */
+	if (is_initial_xendomain())
+		return -ENODEV;
+
+	return xenbus_register_frontend(&xenkbd);
+}
+
+static void __exit xenkbd_cleanup(void)
+{
+	xenbus_unregister_driver(&xenkbd);
+}
+
+module_init(xenkbd_init);
+module_exit(xenkbd_cleanup);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 7483d45..e62018a 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1809,3 +1809,5 @@ module_exit(netif_exit);
 
 MODULE_DESCRIPTION("Xen virtual network device frontend");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("xen:vif");
+MODULE_ALIAS("xennet");
diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 1bd5fb3..e3dc8f8 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -1930,6 +1930,20 @@ config FB_VIRTUAL
 
 	  If unsure, say N.
 
+config XEN_FBDEV_FRONTEND
+	tristate "Xen virtual frame buffer support"
+	depends on FB && XEN
+	select FB_SYS_FILLRECT
+	select FB_SYS_COPYAREA
+	select FB_SYS_IMAGEBLIT
+	select FB_SYS_FOPS
+	select FB_DEFERRED_IO
+	default y
+	help
+	  This driver implements the front-end of the Xen virtual
+	  frame buffer driver.  It communicates with a back-end
+	  in another domain.
+
 source "drivers/video/omap/Kconfig"
 
 source "drivers/video/backlight/Kconfig"
diff --git a/drivers/video/Makefile b/drivers/video/Makefile
index 11c0e5e..f172b9b 100644
--- a/drivers/video/Makefile
+++ b/drivers/video/Makefile
@@ -114,6 +114,7 @@ obj-$(CONFIG_FB_PS3)		  += ps3fb.o
 obj-$(CONFIG_FB_SM501)            += sm501fb.o
 obj-$(CONFIG_FB_XILINX)           += xilinxfb.o
 obj-$(CONFIG_FB_OMAP)             += omap/
+obj-$(CONFIG_XEN_FBDEV_FRONTEND)  += xen-fbfront.o
 
 # Platform or fallback drivers go here
 obj-$(CONFIG_FB_UVESA)            += uvesafb.o
diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
new file mode 100644
index 0000000..619a6f8
--- /dev/null
+++ b/drivers/video/xen-fbfront.c
@@ -0,0 +1,550 @@
+/*
+ * Xen para-virtual frame buffer device
+ *
+ * Copyright (C) 2005-2006 Anthony Liguori <aliguori@us.ibm.com>
+ * Copyright (C) 2006-2008 Red Hat, Inc., Markus Armbruster <armbru@redhat.com>
+ *
+ *  Based on linux/drivers/video/q40fb.c
+ *
+ *  This file is subject to the terms and conditions of the GNU General Public
+ *  License. See the file COPYING in the main directory of this archive for
+ *  more details.
+ */
+
+/*
+ * TODO:
+ *
+ * Switch to grant tables when they become capable of dealing with the
+ * frame buffer.
+ */
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/fb.h>
+#include <linux/module.h>
+#include <linux/vmalloc.h>
+#include <linux/mm.h>
+#include <asm/xen/hypervisor.h>
+#include <xen/events.h>
+#include <xen/page.h>
+#include <xen/interface/io/fbif.h>
+#include <xen/interface/io/protocols.h>
+#include <xen/xenbus.h>
+
+struct xenfb_info {
+	unsigned char		*fb;
+	struct fb_info		*fb_info;
+	int			x1, y1, x2, y2;	/* dirty rectangle,
+						   protected by dirty_lock */
+	spinlock_t		dirty_lock;
+	int			nr_pages;
+	int			irq;
+	struct xenfb_page	*page;
+	unsigned long 		*mfns;
+	int			update_wanted; /* XENFB_TYPE_UPDATE wanted */
+
+	struct xenbus_device	*xbdev;
+};
+
+static u32 xenfb_mem_len = XENFB_WIDTH * XENFB_HEIGHT * XENFB_DEPTH / 8;
+
+static int xenfb_remove(struct xenbus_device *);
+static void xenfb_init_shared_page(struct xenfb_info *);
+static int xenfb_connect_backend(struct xenbus_device *, struct xenfb_info *);
+static void xenfb_disconnect_backend(struct xenfb_info *);
+
+static void xenfb_do_update(struct xenfb_info *info,
+			    int x, int y, int w, int h)
+{
+	union xenfb_out_event event;
+	u32 prod;
+
+	event.type = XENFB_TYPE_UPDATE;
+	event.update.x = x;
+	event.update.y = y;
+	event.update.width = w;
+	event.update.height = h;
+
+	prod = info->page->out_prod;
+	/* caller ensures !xenfb_queue_full() */
+	mb();			/* ensure ring space available */
+	XENFB_OUT_RING_REF(info->page, prod) = event;
+	wmb();			/* ensure ring contents visible */
+	info->page->out_prod = prod + 1;
+
+	notify_remote_via_irq(info->irq);
+}
+
+static int xenfb_queue_full(struct xenfb_info *info)
+{
+	u32 cons, prod;
+
+	prod = info->page->out_prod;
+	cons = info->page->out_cons;
+	return prod - cons == XENFB_OUT_RING_LEN;
+}
+
+static void xenfb_refresh(struct xenfb_info *info,
+			  int x1, int y1, int w, int h)
+{
+	unsigned long flags;
+	int y2 = y1 + h - 1;
+	int x2 = x1 + w - 1;
+
+	if (!info->update_wanted)
+		return;
+
+	spin_lock_irqsave(&info->dirty_lock, flags);
+
+	/* Combine with dirty rectangle: */
+	if (info->y1 < y1)
+		y1 = info->y1;
+	if (info->y2 > y2)
+		y2 = info->y2;
+	if (info->x1 < x1)
+		x1 = info->x1;
+	if (info->x2 > x2)
+		x2 = info->x2;
+
+	if (xenfb_queue_full(info)) {
+		/* Can't send right now, stash it in the dirty rectangle */
+		info->x1 = x1;
+		info->x2 = x2;
+		info->y1 = y1;
+		info->y2 = y2;
+		spin_unlock_irqrestore(&info->dirty_lock, flags);
+		return;
+	}
+
+	/* Clear dirty rectangle: */
+	info->x1 = info->y1 = INT_MAX;
+	info->x2 = info->y2 = 0;
+
+	spin_unlock_irqrestore(&info->dirty_lock, flags);
+
+	if (x1 <= x2 && y1 <= y2)
+		xenfb_do_update(info, x1, y1, x2 - x1 + 1, y2 - y1 + 1);
+}
+
+static void xenfb_deferred_io(struct fb_info *fb_info,
+			      struct list_head *pagelist)
+{
+	struct xenfb_info *info = fb_info->par;
+	struct page *page;
+	unsigned long beg, end;
+	int y1, y2, miny, maxy;
+
+	miny = INT_MAX;
+	maxy = 0;
+	list_for_each_entry(page, pagelist, lru) {
+		beg = page->index << PAGE_SHIFT;
+		end = beg + PAGE_SIZE - 1;
+		y1 = beg / fb_info->fix.line_length;
+		y2 = end / fb_info->fix.line_length;
+		if (y2 >= fb_info->var.yres)
+			y2 = fb_info->var.yres - 1;
+		if (miny > y1)
+			miny = y1;
+		if (maxy < y2)
+			maxy = y2;
+	}
+	xenfb_refresh(info, 0, miny, fb_info->var.xres, maxy - miny + 1);
+}
+
+static struct fb_deferred_io xenfb_defio = {
+	.delay		= HZ / 20,
+	.deferred_io	= xenfb_deferred_io,
+};
+
+static int xenfb_setcolreg(unsigned regno, unsigned red, unsigned green,
+			   unsigned blue, unsigned transp,
+			   struct fb_info *info)
+{
+	u32 v;
+
+	if (regno > info->cmap.len)
+		return 1;
+
+#define CNVT_TOHW(val, width) ((((val)<<(width))+0x7FFF-(val))>>16)
+	red = CNVT_TOHW(red, info->var.red.length);
+	green = CNVT_TOHW(green, info->var.green.length);
+	blue = CNVT_TOHW(blue, info->var.blue.length);
+	transp = CNVT_TOHW(transp, info->var.transp.length);
+#undef CNVT_TOHW
+
+	v = (red << info->var.red.offset) |
+	    (green << info->var.green.offset) |
+	    (blue << info->var.blue.offset);
+
+	switch (info->var.bits_per_pixel) {
+	case 16:
+	case 24:
+	case 32:
+		((u32 *)info->pseudo_palette)[regno] = v;
+		break;
+	}
+
+	return 0;
+}
+
+static void xenfb_fillrect(struct fb_info *p, const struct fb_fillrect *rect)
+{
+	struct xenfb_info *info = p->par;
+
+	sys_fillrect(p, rect);
+	xenfb_refresh(info, rect->dx, rect->dy, rect->width, rect->height);
+}
+
+static void xenfb_imageblit(struct fb_info *p, const struct fb_image *image)
+{
+	struct xenfb_info *info = p->par;
+
+	sys_imageblit(p, image);
+	xenfb_refresh(info, image->dx, image->dy, image->width, image->height);
+}
+
+static void xenfb_copyarea(struct fb_info *p, const struct fb_copyarea *area)
+{
+	struct xenfb_info *info = p->par;
+
+	sys_copyarea(p, area);
+	xenfb_refresh(info, area->dx, area->dy, area->width, area->height);
+}
+
+static ssize_t xenfb_write(struct fb_info *p, const char __user *buf,
+			size_t count, loff_t *ppos)
+{
+	struct xenfb_info *info = p->par;
+	ssize_t res;
+
+	res = fb_sys_write(p, buf, count, ppos);
+	xenfb_refresh(info, 0, 0, info->page->width, info->page->height);
+	return res;
+}
+
+static struct fb_ops xenfb_fb_ops = {
+	.owner		= THIS_MODULE,
+	.fb_read	= fb_sys_read,
+	.fb_write	= xenfb_write,
+	.fb_setcolreg	= xenfb_setcolreg,
+	.fb_fillrect	= xenfb_fillrect,
+	.fb_copyarea	= xenfb_copyarea,
+	.fb_imageblit	= xenfb_imageblit,
+};
+
+static irqreturn_t xenfb_event_handler(int rq, void *dev_id)
+{
+	/*
+	 * No in events recognized, simply ignore them all.
+	 * If you need to recognize some, see xen-kbdfront's
+	 * input_handler() for how to do that.
+	 */
+	struct xenfb_info *info = dev_id;
+	struct xenfb_page *page = info->page;
+
+	if (page->in_cons != page->in_prod) {
+		info->page->in_cons = info->page->in_prod;
+		notify_remote_via_irq(info->irq);
+	}
+
+	/* Flush dirty rectangle: */
+	xenfb_refresh(info, INT_MAX, INT_MAX, -INT_MAX, -INT_MAX);
+
+	return IRQ_HANDLED;
+}
+
+static int __devinit xenfb_probe(struct xenbus_device *dev,
+				 const struct xenbus_device_id *id)
+{
+	struct xenfb_info *info;
+	struct fb_info *fb_info;
+	int ret;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (info == NULL) {
+		xenbus_dev_fatal(dev, -ENOMEM, "allocating info structure");
+		return -ENOMEM;
+	}
+	dev->dev.driver_data = info;
+	info->xbdev = dev;
+	info->irq = -1;
+	info->x1 = info->y1 = INT_MAX;
+	spin_lock_init(&info->dirty_lock);
+
+	info->fb = vmalloc(xenfb_mem_len);
+	if (info->fb == NULL)
+		goto error_nomem;
+	memset(info->fb, 0, xenfb_mem_len);
+
+	info->nr_pages = (xenfb_mem_len + PAGE_SIZE - 1) >> PAGE_SHIFT;
+
+	info->mfns = vmalloc(sizeof(unsigned long) * info->nr_pages);
+	if (!info->mfns)
+		goto error_nomem;
+
+	/* set up shared page */
+	info->page = (void *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+	if (!info->page)
+		goto error_nomem;
+
+	xenfb_init_shared_page(info);
+
+	/* abusing framebuffer_alloc() to allocate pseudo_palette */
+	fb_info = framebuffer_alloc(sizeof(u32) * 256, NULL);
+	if (fb_info == NULL)
+		goto error_nomem;
+
+	/* complete the abuse: */
+	fb_info->pseudo_palette = fb_info->par;
+	fb_info->par = info;
+
+	fb_info->screen_base = info->fb;
+
+	fb_info->fbops = &xenfb_fb_ops;
+	fb_info->var.xres_virtual = fb_info->var.xres = info->page->width;
+	fb_info->var.yres_virtual = fb_info->var.yres = info->page->height;
+	fb_info->var.bits_per_pixel = info->page->depth;
+
+	fb_info->var.red = (struct fb_bitfield){16, 8, 0};
+	fb_info->var.green = (struct fb_bitfield){8, 8, 0};
+	fb_info->var.blue = (struct fb_bitfield){0, 8, 0};
+
+	fb_info->var.activate = FB_ACTIVATE_NOW;
+	fb_info->var.height = -1;
+	fb_info->var.width = -1;
+	fb_info->var.vmode = FB_VMODE_NONINTERLACED;
+
+	fb_info->fix.visual = FB_VISUAL_TRUECOLOR;
+	fb_info->fix.line_length = info->page->line_length;
+	fb_info->fix.smem_start = 0;
+	fb_info->fix.smem_len = xenfb_mem_len;
+	strcpy(fb_info->fix.id, "xen");
+	fb_info->fix.type = FB_TYPE_PACKED_PIXELS;
+	fb_info->fix.accel = FB_ACCEL_NONE;
+
+	fb_info->flags = FBINFO_FLAG_DEFAULT;
+
+	ret = fb_alloc_cmap(&fb_info->cmap, 256, 0);
+	if (ret < 0) {
+		framebuffer_release(fb_info);
+		xenbus_dev_fatal(dev, ret, "fb_alloc_cmap");
+		goto error;
+	}
+
+	fb_info->fbdefio = &xenfb_defio;
+	fb_deferred_io_init(fb_info);
+
+	ret = register_framebuffer(fb_info);
+	if (ret) {
+		fb_deferred_io_cleanup(fb_info);
+		fb_dealloc_cmap(&fb_info->cmap);
+		framebuffer_release(fb_info);
+		xenbus_dev_fatal(dev, ret, "register_framebuffer");
+		goto error;
+	}
+	info->fb_info = fb_info;
+
+	ret = xenfb_connect_backend(dev, info);
+	if (ret < 0)
+		goto error;
+
+	return 0;
+
+ error_nomem:
+	ret = -ENOMEM;
+	xenbus_dev_fatal(dev, ret, "allocating device memory");
+ error:
+	xenfb_remove(dev);
+	return ret;
+}
+
+static int xenfb_resume(struct xenbus_device *dev)
+{
+	struct xenfb_info *info = dev->dev.driver_data;
+
+	xenfb_disconnect_backend(info);
+	xenfb_init_shared_page(info);
+	return xenfb_connect_backend(dev, info);
+}
+
+static int xenfb_remove(struct xenbus_device *dev)
+{
+	struct xenfb_info *info = dev->dev.driver_data;
+
+	xenfb_disconnect_backend(info);
+	if (info->fb_info) {
+		fb_deferred_io_cleanup(info->fb_info);
+		unregister_framebuffer(info->fb_info);
+		fb_dealloc_cmap(&info->fb_info->cmap);
+		framebuffer_release(info->fb_info);
+	}
+	free_page((unsigned long)info->page);
+	vfree(info->mfns);
+	vfree(info->fb);
+	kfree(info);
+
+	return 0;
+}
+
+static unsigned long vmalloc_to_mfn(void *address)
+{
+	return pfn_to_mfn(vmalloc_to_pfn(address));
+}
+
+static void xenfb_init_shared_page(struct xenfb_info *info)
+{
+	int i;
+
+	for (i = 0; i < info->nr_pages; i++)
+		info->mfns[i] = vmalloc_to_mfn(info->fb + i * PAGE_SIZE);
+
+	info->page->pd[0] = vmalloc_to_mfn(info->mfns);
+	info->page->pd[1] = 0;
+	info->page->width = XENFB_WIDTH;
+	info->page->height = XENFB_HEIGHT;
+	info->page->depth = XENFB_DEPTH;
+	info->page->line_length = (info->page->depth / 8) * info->page->width;
+	info->page->mem_length = xenfb_mem_len;
+	info->page->in_cons = info->page->in_prod = 0;
+	info->page->out_cons = info->page->out_prod = 0;
+}
+
+static int xenfb_connect_backend(struct xenbus_device *dev,
+				 struct xenfb_info *info)
+{
+	int ret, evtchn;
+	struct xenbus_transaction xbt;
+
+	ret = xenbus_alloc_evtchn(dev, &evtchn);
+	if (ret)
+		return ret;
+	ret = bind_evtchn_to_irqhandler(evtchn, xenfb_event_handler,
+					0, dev->devicetype, info);
+	if (ret < 0) {
+		xenbus_free_evtchn(dev, evtchn);
+		xenbus_dev_fatal(dev, ret, "bind_evtchn_to_irqhandler");
+		return ret;
+	}
+	info->irq = ret;
+
+ again:
+	ret = xenbus_transaction_start(&xbt);
+	if (ret) {
+		xenbus_dev_fatal(dev, ret, "starting transaction");
+		return ret;
+	}
+	ret = xenbus_printf(xbt, dev->nodename, "page-ref", "%lu",
+			    virt_to_mfn(info->page));
+	if (ret)
+		goto error_xenbus;
+	ret = xenbus_printf(xbt, dev->nodename, "event-channel", "%u",
+			    evtchn);
+	if (ret)
+		goto error_xenbus;
+	ret = xenbus_printf(xbt, dev->nodename, "protocol", "%s",
+			    XEN_IO_PROTO_ABI_NATIVE);
+	if (ret)
+		goto error_xenbus;
+	ret = xenbus_printf(xbt, dev->nodename, "feature-update", "1");
+	if (ret)
+		goto error_xenbus;
+	ret = xenbus_transaction_end(xbt, 0);
+	if (ret) {
+		if (ret == -EAGAIN)
+			goto again;
+		xenbus_dev_fatal(dev, ret, "completing transaction");
+		return ret;
+	}
+
+	xenbus_switch_state(dev, XenbusStateInitialised);
+	return 0;
+
+ error_xenbus:
+	xenbus_transaction_end(xbt, 1);
+	xenbus_dev_fatal(dev, ret, "writing xenstore");
+	return ret;
+}
+
+static void xenfb_disconnect_backend(struct xenfb_info *info)
+{
+	if (info->irq >= 0)
+		unbind_from_irqhandler(info->irq, info);
+	info->irq = -1;
+}
+
+static void xenfb_backend_changed(struct xenbus_device *dev,
+				  enum xenbus_state backend_state)
+{
+	struct xenfb_info *info = dev->dev.driver_data;
+	int val;
+
+	switch (backend_state) {
+	case XenbusStateInitialising:
+	case XenbusStateInitialised:
+	case XenbusStateUnknown:
+	case XenbusStateClosed:
+		break;
+
+	case XenbusStateInitWait:
+InitWait:
+		xenbus_switch_state(dev, XenbusStateConnected);
+		break;
+
+	case XenbusStateConnected:
+		/*
+		 * Work around xenbus race condition: If backend goes
+		 * through InitWait to Connected fast enough, we can
+		 * get Connected twice here.
+		 */
+		if (dev->state != XenbusStateConnected)
+			goto InitWait; /* no InitWait seen yet, fudge it */
+
+		if (xenbus_scanf(XBT_NIL, info->xbdev->otherend,
+				 "request-update", "%d", &val) < 0)
+			val = 0;
+		if (val)
+			info->update_wanted = 1;
+		break;
+
+	case XenbusStateClosing:
+		xenbus_frontend_closed(dev);
+		break;
+	}
+}
+
+static struct xenbus_device_id xenfb_ids[] = {
+	{ "vfb" },
+	{ "" }
+};
+
+static struct xenbus_driver xenfb = {
+	.name = "vfb",
+	.owner = THIS_MODULE,
+	.ids = xenfb_ids,
+	.probe = xenfb_probe,
+	.remove = xenfb_remove,
+	.resume = xenfb_resume,
+	.otherend_changed = xenfb_backend_changed,
+};
+
+static int __init xenfb_init(void)
+{
+	if (!is_running_on_xen())
+		return -ENODEV;
+
+	/* Nothing to do if running in dom0. */
+	if (is_initial_xendomain())
+		return -ENODEV;
+
+	return xenbus_register_frontend(&xenfb);
+}
+
+static void __exit xenfb_cleanup(void)
+{
+	xenbus_unregister_driver(&xenfb);
+}
+
+module_init(xenfb_init);
+module_exit(xenfb_cleanup);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
new file mode 100644
index 0000000..4b75a16
--- /dev/null
+++ b/drivers/xen/Kconfig
@@ -0,0 +1,19 @@
+config XEN_BALLOON
+	bool "Xen memory balloon driver"
+	depends on XEN
+	default y
+	help
+	  The balloon driver allows the Xen domain to request more memory from
+	  the system to expand the domain's memory allocation, or alternatively
+	  return unneeded memory to the system.
+
+config XEN_SCRUB_PAGES
+	bool "Scrub pages before returning them to system"
+	depends on XEN_BALLOON
+	default y
+	help
+	  Scrub pages before returning them to the system for reuse by
+	  other domains.  This makes sure that any confidential data
+	  is not accidentally visible to other domains.  Is it more
+	  secure, but slightly less efficient.
+	  If in doubt, say yes.
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index 56592f0..37af04f 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -1,2 +1,4 @@
-obj-y	+= grant-table.o
+obj-y	+= grant-table.o features.o events.o
 obj-y	+= xenbus/
+obj-$(CONFIG_XEN_XENCOMM)	+= xencomm.o
+obj-$(CONFIG_XEN_BALLOON)	+= balloon.o
diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
new file mode 100644
index 0000000..ab25ba6
--- /dev/null
+++ b/drivers/xen/balloon.c
@@ -0,0 +1,712 @@
+/******************************************************************************
+ * balloon.c
+ *
+ * Xen balloon driver - enables returning/claiming memory to/from Xen.
+ *
+ * Copyright (c) 2003, B Dragovic
+ * Copyright (c) 2003-2004, M Williamson, K Fraser
+ * Copyright (c) 2005 Dan M. Smith, IBM Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation; or, when distributed
+ * separately from the Linux kernel or incorporated into other
+ * software packages, subject to the following license:
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this source file (the "Software"), to deal in the Software without
+ * restriction, including without limitation the rights to use, copy, modify,
+ * merge, publish, distribute, sublicense, and/or sell copies of the Software,
+ * and to permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
+ * IN THE SOFTWARE.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/errno.h>
+#include <linux/mm.h>
+#include <linux/bootmem.h>
+#include <linux/pagemap.h>
+#include <linux/highmem.h>
+#include <linux/mutex.h>
+#include <linux/highmem.h>
+#include <linux/list.h>
+#include <linux/sysdev.h>
+
+#include <asm/xen/hypervisor.h>
+#include <asm/page.h>
+#include <asm/pgalloc.h>
+#include <asm/pgtable.h>
+#include <asm/uaccess.h>
+#include <asm/tlb.h>
+
+#include <xen/interface/memory.h>
+#include <xen/balloon.h>
+#include <xen/xenbus.h>
+#include <xen/features.h>
+#include <xen/page.h>
+
+#define PAGES2KB(_p) ((_p)<<(PAGE_SHIFT-10))
+
+#define BALLOON_CLASS_NAME "memory"
+
+struct balloon_stats {
+	/* We aim for 'current allocation' == 'target allocation'. */
+	unsigned long current_pages;
+	unsigned long target_pages;
+	/* We may hit the hard limit in Xen. If we do then we remember it. */
+	unsigned long hard_limit;
+	/*
+	 * Drivers may alter the memory reservation independently, but they
+	 * must inform the balloon driver so we avoid hitting the hard limit.
+	 */
+	unsigned long driver_pages;
+	/* Number of pages in high- and low-memory balloons. */
+	unsigned long balloon_low;
+	unsigned long balloon_high;
+};
+
+static DEFINE_MUTEX(balloon_mutex);
+
+static struct sys_device balloon_sysdev;
+
+static int register_balloon(struct sys_device *sysdev);
+
+/*
+ * Protects atomic reservation decrease/increase against concurrent increases.
+ * Also protects non-atomic updates of current_pages and driver_pages, and
+ * balloon lists.
+ */
+static DEFINE_SPINLOCK(balloon_lock);
+
+static struct balloon_stats balloon_stats;
+
+/* We increase/decrease in batches which fit in a page */
+static unsigned long frame_list[PAGE_SIZE / sizeof(unsigned long)];
+
+/* VM /proc information for memory */
+extern unsigned long totalram_pages;
+
+#ifdef CONFIG_HIGHMEM
+extern unsigned long totalhigh_pages;
+#define inc_totalhigh_pages() (totalhigh_pages++)
+#define dec_totalhigh_pages() (totalhigh_pages--)
+#else
+#define inc_totalhigh_pages() do {} while(0)
+#define dec_totalhigh_pages() do {} while(0)
+#endif
+
+/* List of ballooned pages, threaded through the mem_map array. */
+static LIST_HEAD(ballooned_pages);
+
+/* Main work function, always executed in process context. */
+static void balloon_process(struct work_struct *work);
+static DECLARE_WORK(balloon_worker, balloon_process);
+static struct timer_list balloon_timer;
+
+/* When ballooning out (allocating memory to return to Xen) we don't really
+   want the kernel to try too hard since that can trigger the oom killer. */
+#define GFP_BALLOON \
+	(GFP_HIGHUSER | __GFP_NOWARN | __GFP_NORETRY | __GFP_NOMEMALLOC)
+
+static void scrub_page(struct page *page)
+{
+#ifdef CONFIG_XEN_SCRUB_PAGES
+	if (PageHighMem(page)) {
+		void *v = kmap(page);
+		clear_page(v);
+		kunmap(v);
+	} else {
+		void *v = page_address(page);
+		clear_page(v);
+	}
+#endif
+}
+
+/* balloon_append: add the given page to the balloon. */
+static void balloon_append(struct page *page)
+{
+	/* Lowmem is re-populated first, so highmem pages go at list tail. */
+	if (PageHighMem(page)) {
+		list_add_tail(&page->lru, &ballooned_pages);
+		balloon_stats.balloon_high++;
+		dec_totalhigh_pages();
+	} else {
+		list_add(&page->lru, &ballooned_pages);
+		balloon_stats.balloon_low++;
+	}
+}
+
+/* balloon_retrieve: rescue a page from the balloon, if it is not empty. */
+static struct page *balloon_retrieve(void)
+{
+	struct page *page;
+
+	if (list_empty(&ballooned_pages))
+		return NULL;
+
+	page = list_entry(ballooned_pages.next, struct page, lru);
+	list_del(&page->lru);
+
+	if (PageHighMem(page)) {
+		balloon_stats.balloon_high--;
+		inc_totalhigh_pages();
+	}
+	else
+		balloon_stats.balloon_low--;
+
+	return page;
+}
+
+static struct page *balloon_first_page(void)
+{
+	if (list_empty(&ballooned_pages))
+		return NULL;
+	return list_entry(ballooned_pages.next, struct page, lru);
+}
+
+static struct page *balloon_next_page(struct page *page)
+{
+	struct list_head *next = page->lru.next;
+	if (next == &ballooned_pages)
+		return NULL;
+	return list_entry(next, struct page, lru);
+}
+
+static void balloon_alarm(unsigned long unused)
+{
+	schedule_work(&balloon_worker);
+}
+
+static unsigned long current_target(void)
+{
+	unsigned long target = min(balloon_stats.target_pages, balloon_stats.hard_limit);
+
+	target = min(target,
+		     balloon_stats.current_pages +
+		     balloon_stats.balloon_low +
+		     balloon_stats.balloon_high);
+
+	return target;
+}
+
+static int increase_reservation(unsigned long nr_pages)
+{
+	unsigned long  pfn, i, flags;
+	struct page   *page;
+	long           rc;
+	struct xen_memory_reservation reservation = {
+		.address_bits = 0,
+		.extent_order = 0,
+		.domid        = DOMID_SELF
+	};
+
+	if (nr_pages > ARRAY_SIZE(frame_list))
+		nr_pages = ARRAY_SIZE(frame_list);
+
+	spin_lock_irqsave(&balloon_lock, flags);
+
+	page = balloon_first_page();
+	for (i = 0; i < nr_pages; i++) {
+		BUG_ON(page == NULL);
+		frame_list[i] = page_to_pfn(page);;
+		page = balloon_next_page(page);
+	}
+
+	reservation.extent_start = (unsigned long)frame_list;
+	reservation.nr_extents   = nr_pages;
+	rc = HYPERVISOR_memory_op(
+		XENMEM_populate_physmap, &reservation);
+	if (rc < nr_pages) {
+		if (rc > 0) {
+			int ret;
+
+			/* We hit the Xen hard limit: reprobe. */
+			reservation.nr_extents = rc;
+			ret = HYPERVISOR_memory_op(XENMEM_decrease_reservation,
+					&reservation);
+			BUG_ON(ret != rc);
+		}
+		if (rc >= 0)
+			balloon_stats.hard_limit = (balloon_stats.current_pages + rc -
+						    balloon_stats.driver_pages);
+		goto out;
+	}
+
+	for (i = 0; i < nr_pages; i++) {
+		page = balloon_retrieve();
+		BUG_ON(page == NULL);
+
+		pfn = page_to_pfn(page);
+		BUG_ON(!xen_feature(XENFEAT_auto_translated_physmap) &&
+		       phys_to_machine_mapping_valid(pfn));
+
+		set_phys_to_machine(pfn, frame_list[i]);
+
+		/* Link back into the page tables if not highmem. */
+		if (pfn < max_low_pfn) {
+			int ret;
+			ret = HYPERVISOR_update_va_mapping(
+				(unsigned long)__va(pfn << PAGE_SHIFT),
+				mfn_pte(frame_list[i], PAGE_KERNEL),
+				0);
+			BUG_ON(ret);
+		}
+
+		/* Relinquish the page back to the allocator. */
+		ClearPageReserved(page);
+		init_page_count(page);
+		__free_page(page);
+	}
+
+	balloon_stats.current_pages += nr_pages;
+	totalram_pages = balloon_stats.current_pages;
+
+ out:
+	spin_unlock_irqrestore(&balloon_lock, flags);
+
+	return 0;
+}
+
+static int decrease_reservation(unsigned long nr_pages)
+{
+	unsigned long  pfn, i, flags;
+	struct page   *page;
+	int            need_sleep = 0;
+	int ret;
+	struct xen_memory_reservation reservation = {
+		.address_bits = 0,
+		.extent_order = 0,
+		.domid        = DOMID_SELF
+	};
+
+	if (nr_pages > ARRAY_SIZE(frame_list))
+		nr_pages = ARRAY_SIZE(frame_list);
+
+	for (i = 0; i < nr_pages; i++) {
+		if ((page = alloc_page(GFP_BALLOON)) == NULL) {
+			nr_pages = i;
+			need_sleep = 1;
+			break;
+		}
+
+		pfn = page_to_pfn(page);
+		frame_list[i] = pfn_to_mfn(pfn);
+
+		scrub_page(page);
+	}
+
+	/* Ensure that ballooned highmem pages don't have kmaps. */
+	kmap_flush_unused();
+	flush_tlb_all();
+
+	spin_lock_irqsave(&balloon_lock, flags);
+
+	/* No more mappings: invalidate P2M and add to balloon. */
+	for (i = 0; i < nr_pages; i++) {
+		pfn = mfn_to_pfn(frame_list[i]);
+		set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
+		balloon_append(pfn_to_page(pfn));
+	}
+
+	reservation.extent_start = (unsigned long)frame_list;
+	reservation.nr_extents   = nr_pages;
+	ret = HYPERVISOR_memory_op(XENMEM_decrease_reservation, &reservation);
+	BUG_ON(ret != nr_pages);
+
+	balloon_stats.current_pages -= nr_pages;
+	totalram_pages = balloon_stats.current_pages;
+
+	spin_unlock_irqrestore(&balloon_lock, flags);
+
+	return need_sleep;
+}
+
+/*
+ * We avoid multiple worker processes conflicting via the balloon mutex.
+ * We may of course race updates of the target counts (which are protected
+ * by the balloon lock), or with changes to the Xen hard limit, but we will
+ * recover from these in time.
+ */
+static void balloon_process(struct work_struct *work)
+{
+	int need_sleep = 0;
+	long credit;
+
+	mutex_lock(&balloon_mutex);
+
+	do {
+		credit = current_target() - balloon_stats.current_pages;
+		if (credit > 0)
+			need_sleep = (increase_reservation(credit) != 0);
+		if (credit < 0)
+			need_sleep = (decrease_reservation(-credit) != 0);
+
+#ifndef CONFIG_PREEMPT
+		if (need_resched())
+			schedule();
+#endif
+	} while ((credit != 0) && !need_sleep);
+
+	/* Schedule more work if there is some still to be done. */
+	if (current_target() != balloon_stats.current_pages)
+		mod_timer(&balloon_timer, jiffies + HZ);
+
+	mutex_unlock(&balloon_mutex);
+}
+
+/* Resets the Xen limit, sets new target, and kicks off processing. */
+void balloon_set_new_target(unsigned long target)
+{
+	/* No need for lock. Not read-modify-write updates. */
+	balloon_stats.hard_limit   = ~0UL;
+	balloon_stats.target_pages = target;
+	schedule_work(&balloon_worker);
+}
+
+static struct xenbus_watch target_watch =
+{
+	.node = "memory/target"
+};
+
+/* React to a change in the target key */
+static void watch_target(struct xenbus_watch *watch,
+			 const char **vec, unsigned int len)
+{
+	unsigned long long new_target;
+	int err;
+
+	err = xenbus_scanf(XBT_NIL, "memory", "target", "%llu", &new_target);
+	if (err != 1) {
+		/* This is ok (for domain0 at least) - so just return */
+		return;
+	}
+
+	/* The given memory/target value is in KiB, so it needs converting to
+	 * pages. PAGE_SHIFT converts bytes to pages, hence PAGE_SHIFT - 10.
+	 */
+	balloon_set_new_target(new_target >> (PAGE_SHIFT - 10));
+}
+
+static int balloon_init_watcher(struct notifier_block *notifier,
+				unsigned long event,
+				void *data)
+{
+	int err;
+
+	err = register_xenbus_watch(&target_watch);
+	if (err)
+		printk(KERN_ERR "Failed to set balloon watcher\n");
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block xenstore_notifier;
+
+static int __init balloon_init(void)
+{
+	unsigned long pfn;
+	struct page *page;
+
+	if (!is_running_on_xen())
+		return -ENODEV;
+
+	pr_info("xen_balloon: Initialising balloon driver.\n");
+
+	balloon_stats.current_pages = min(xen_start_info->nr_pages, max_pfn);
+	totalram_pages   = balloon_stats.current_pages;
+	balloon_stats.target_pages  = balloon_stats.current_pages;
+	balloon_stats.balloon_low   = 0;
+	balloon_stats.balloon_high  = 0;
+	balloon_stats.driver_pages  = 0UL;
+	balloon_stats.hard_limit    = ~0UL;
+
+	init_timer(&balloon_timer);
+	balloon_timer.data = 0;
+	balloon_timer.function = balloon_alarm;
+
+	register_balloon(&balloon_sysdev);
+
+	/* Initialise the balloon with excess memory space. */
+	for (pfn = xen_start_info->nr_pages; pfn < max_pfn; pfn++) {
+		page = pfn_to_page(pfn);
+		if (!PageReserved(page))
+			balloon_append(page);
+	}
+
+	target_watch.callback = watch_target;
+	xenstore_notifier.notifier_call = balloon_init_watcher;
+
+	register_xenstore_notifier(&xenstore_notifier);
+
+	return 0;
+}
+
+subsys_initcall(balloon_init);
+
+static void balloon_exit(void)
+{
+    /* XXX - release balloon here */
+    return;
+}
+
+module_exit(balloon_exit);
+
+static void balloon_update_driver_allowance(long delta)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&balloon_lock, flags);
+	balloon_stats.driver_pages += delta;
+	spin_unlock_irqrestore(&balloon_lock, flags);
+}
+
+static int dealloc_pte_fn(
+	pte_t *pte, struct page *pmd_page, unsigned long addr, void *data)
+{
+	unsigned long mfn = pte_mfn(*pte);
+	int ret;
+	struct xen_memory_reservation reservation = {
+		.nr_extents   = 1,
+		.extent_order = 0,
+		.domid        = DOMID_SELF
+	};
+	reservation.extent_start = (unsigned long)&mfn;
+	set_pte_at(&init_mm, addr, pte, __pte_ma(0ull));
+	set_phys_to_machine(__pa(addr) >> PAGE_SHIFT, INVALID_P2M_ENTRY);
+	ret = HYPERVISOR_memory_op(XENMEM_decrease_reservation, &reservation);
+	BUG_ON(ret != 1);
+	return 0;
+}
+
+static struct page **alloc_empty_pages_and_pagevec(int nr_pages)
+{
+	unsigned long vaddr, flags;
+	struct page *page, **pagevec;
+	int i, ret;
+
+	pagevec = kmalloc(sizeof(page) * nr_pages, GFP_KERNEL);
+	if (pagevec == NULL)
+		return NULL;
+
+	for (i = 0; i < nr_pages; i++) {
+		page = pagevec[i] = alloc_page(GFP_KERNEL);
+		if (page == NULL)
+			goto err;
+
+		vaddr = (unsigned long)page_address(page);
+
+		scrub_page(page);
+
+		spin_lock_irqsave(&balloon_lock, flags);
+
+		if (xen_feature(XENFEAT_auto_translated_physmap)) {
+			unsigned long gmfn = page_to_pfn(page);
+			struct xen_memory_reservation reservation = {
+				.nr_extents   = 1,
+				.extent_order = 0,
+				.domid        = DOMID_SELF
+			};
+			reservation.extent_start = (unsigned long)&gmfn;
+			ret = HYPERVISOR_memory_op(XENMEM_decrease_reservation,
+						   &reservation);
+			if (ret == 1)
+				ret = 0; /* success */
+		} else {
+			ret = apply_to_page_range(&init_mm, vaddr, PAGE_SIZE,
+						  dealloc_pte_fn, NULL);
+		}
+
+		if (ret != 0) {
+			spin_unlock_irqrestore(&balloon_lock, flags);
+			__free_page(page);
+			goto err;
+		}
+
+		totalram_pages = --balloon_stats.current_pages;
+
+		spin_unlock_irqrestore(&balloon_lock, flags);
+	}
+
+ out:
+	schedule_work(&balloon_worker);
+	flush_tlb_all();
+	return pagevec;
+
+ err:
+	spin_lock_irqsave(&balloon_lock, flags);
+	while (--i >= 0)
+		balloon_append(pagevec[i]);
+	spin_unlock_irqrestore(&balloon_lock, flags);
+	kfree(pagevec);
+	pagevec = NULL;
+	goto out;
+}
+
+static void free_empty_pages_and_pagevec(struct page **pagevec, int nr_pages)
+{
+	unsigned long flags;
+	int i;
+
+	if (pagevec == NULL)
+		return;
+
+	spin_lock_irqsave(&balloon_lock, flags);
+	for (i = 0; i < nr_pages; i++) {
+		BUG_ON(page_count(pagevec[i]) != 1);
+		balloon_append(pagevec[i]);
+	}
+	spin_unlock_irqrestore(&balloon_lock, flags);
+
+	kfree(pagevec);
+
+	schedule_work(&balloon_worker);
+}
+
+static void balloon_release_driver_page(struct page *page)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&balloon_lock, flags);
+	balloon_append(page);
+	balloon_stats.driver_pages--;
+	spin_unlock_irqrestore(&balloon_lock, flags);
+
+	schedule_work(&balloon_worker);
+}
+
+
+#define BALLOON_SHOW(name, format, args...)			\
+	static ssize_t show_##name(struct sys_device *dev,	\
+				   char *buf)			\
+	{							\
+		return sprintf(buf, format, ##args);		\
+	}							\
+	static SYSDEV_ATTR(name, S_IRUGO, show_##name, NULL)
+
+BALLOON_SHOW(current_kb, "%lu\n", PAGES2KB(balloon_stats.current_pages));
+BALLOON_SHOW(low_kb, "%lu\n", PAGES2KB(balloon_stats.balloon_low));
+BALLOON_SHOW(high_kb, "%lu\n", PAGES2KB(balloon_stats.balloon_high));
+BALLOON_SHOW(hard_limit_kb,
+	     (balloon_stats.hard_limit!=~0UL) ? "%lu\n" : "???\n",
+	     (balloon_stats.hard_limit!=~0UL) ? PAGES2KB(balloon_stats.hard_limit) : 0);
+BALLOON_SHOW(driver_kb, "%lu\n", PAGES2KB(balloon_stats.driver_pages));
+
+static ssize_t show_target_kb(struct sys_device *dev, char *buf)
+{
+	return sprintf(buf, "%lu\n", PAGES2KB(balloon_stats.target_pages));
+}
+
+static ssize_t store_target_kb(struct sys_device *dev,
+			       const char *buf,
+			       size_t count)
+{
+	char memstring[64], *endchar;
+	unsigned long long target_bytes;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (count <= 1)
+		return -EBADMSG; /* runt */
+	if (count > sizeof(memstring))
+		return -EFBIG;   /* too long */
+	strcpy(memstring, buf);
+
+	target_bytes = memparse(memstring, &endchar);
+	balloon_set_new_target(target_bytes >> PAGE_SHIFT);
+
+	return count;
+}
+
+static SYSDEV_ATTR(target_kb, S_IRUGO | S_IWUSR,
+		   show_target_kb, store_target_kb);
+
+static struct sysdev_attribute *balloon_attrs[] = {
+	&attr_target_kb,
+};
+
+static struct attribute *balloon_info_attrs[] = {
+	&attr_current_kb.attr,
+	&attr_low_kb.attr,
+	&attr_high_kb.attr,
+	&attr_hard_limit_kb.attr,
+	&attr_driver_kb.attr,
+	NULL
+};
+
+static struct attribute_group balloon_info_group = {
+	.name = "info",
+	.attrs = balloon_info_attrs,
+};
+
+static struct sysdev_class balloon_sysdev_class = {
+	.name = BALLOON_CLASS_NAME,
+};
+
+static int register_balloon(struct sys_device *sysdev)
+{
+	int i, error;
+
+	error = sysdev_class_register(&balloon_sysdev_class);
+	if (error)
+		return error;
+
+	sysdev->id = 0;
+	sysdev->cls = &balloon_sysdev_class;
+
+	error = sysdev_register(sysdev);
+	if (error) {
+		sysdev_class_unregister(&balloon_sysdev_class);
+		return error;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(balloon_attrs); i++) {
+		error = sysdev_create_file(sysdev, balloon_attrs[i]);
+		if (error)
+			goto fail;
+	}
+
+	error = sysfs_create_group(&sysdev->kobj, &balloon_info_group);
+	if (error)
+		goto fail;
+
+	return 0;
+
+ fail:
+	while (--i >= 0)
+		sysdev_remove_file(sysdev, balloon_attrs[i]);
+	sysdev_unregister(sysdev);
+	sysdev_class_unregister(&balloon_sysdev_class);
+	return error;
+}
+
+static void unregister_balloon(struct sys_device *sysdev)
+{
+	int i;
+
+	sysfs_remove_group(&sysdev->kobj, &balloon_info_group);
+	for (i = 0; i < ARRAY_SIZE(balloon_attrs); i++)
+		sysdev_remove_file(sysdev, balloon_attrs[i]);
+	sysdev_unregister(sysdev);
+	sysdev_class_unregister(&balloon_sysdev_class);
+}
+
+static void balloon_sysfs_exit(void)
+{
+	unregister_balloon(&balloon_sysdev);
+}
+
+MODULE_LICENSE("GPL");
diff --git a/arch/x86/xen/events.c b/drivers/xen/events.c
similarity index 82%
rename from arch/x86/xen/events.c
rename to drivers/xen/events.c
index dcf613e..4f0f22b 100644
--- a/arch/x86/xen/events.c
+++ b/drivers/xen/events.c
@@ -33,12 +33,11 @@
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
 
+#include <xen/xen-ops.h>
 #include <xen/events.h>
 #include <xen/interface/xen.h>
 #include <xen/interface/event_channel.h>
 
-#include "xen-ops.h"
-
 /*
  * This lock protects updates to the following mapping and reference-count
  * arrays. The lock does not need to be acquired to read the mapping tables.
@@ -455,6 +454,53 @@ void xen_send_IPI_one(unsigned int cpu, enum ipi_vector vector)
 	notify_remote_via_irq(irq);
 }
 
+irqreturn_t xen_debug_interrupt(int irq, void *dev_id)
+{
+	struct shared_info *sh = HYPERVISOR_shared_info;
+	int cpu = smp_processor_id();
+	int i;
+	unsigned long flags;
+	static DEFINE_SPINLOCK(debug_lock);
+
+	spin_lock_irqsave(&debug_lock, flags);
+
+	printk("vcpu %d\n  ", cpu);
+
+	for_each_online_cpu(i) {
+		struct vcpu_info *v = per_cpu(xen_vcpu, i);
+		printk("%d: masked=%d pending=%d event_sel %08lx\n  ", i,
+			(get_irq_regs() && i == cpu) ? xen_irqs_disabled(get_irq_regs()) : v->evtchn_upcall_mask,
+			v->evtchn_upcall_pending,
+			v->evtchn_pending_sel);
+	}
+	printk("pending:\n   ");
+	for(i = ARRAY_SIZE(sh->evtchn_pending)-1; i >= 0; i--)
+		printk("%08lx%s", sh->evtchn_pending[i],
+			i % 8 == 0 ? "\n   " : " ");
+	printk("\nmasks:\n   ");
+	for(i = ARRAY_SIZE(sh->evtchn_mask)-1; i >= 0; i--)
+		printk("%08lx%s", sh->evtchn_mask[i],
+			i % 8 == 0 ? "\n   " : " ");
+
+	printk("\nunmasked:\n   ");
+	for(i = ARRAY_SIZE(sh->evtchn_mask)-1; i >= 0; i--)
+		printk("%08lx%s", sh->evtchn_pending[i] & ~sh->evtchn_mask[i],
+			i % 8 == 0 ? "\n   " : " ");
+
+	printk("\npending list:\n");
+	for(i = 0; i < NR_EVENT_CHANNELS; i++) {
+		if (sync_test_bit(i, sh->evtchn_pending)) {
+			printk("  %d: event %d -> irq %d\n",
+				cpu_evtchn[i], i,
+				evtchn_to_irq[i]);
+		}
+	}
+
+	spin_unlock_irqrestore(&debug_lock, flags);
+
+	return IRQ_HANDLED;
+}
+
 
 /*
  * Search the CPUs pending events bitmasks.  For each one found, map
@@ -470,29 +516,44 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
 	int cpu = get_cpu();
 	struct shared_info *s = HYPERVISOR_shared_info;
 	struct vcpu_info *vcpu_info = __get_cpu_var(xen_vcpu);
-	unsigned long pending_words;
+	static DEFINE_PER_CPU(unsigned, nesting_count);
+ 	unsigned count;
 
-	vcpu_info->evtchn_upcall_pending = 0;
+	do {
+		unsigned long pending_words;
 
-	/* NB. No need for a barrier here -- XCHG is a barrier on x86. */
-	pending_words = xchg(&vcpu_info->evtchn_pending_sel, 0);
-	while (pending_words != 0) {
-		unsigned long pending_bits;
-		int word_idx = __ffs(pending_words);
-		pending_words &= ~(1UL << word_idx);
+		vcpu_info->evtchn_upcall_pending = 0;
 
-		while ((pending_bits = active_evtchns(cpu, s, word_idx)) != 0) {
-			int bit_idx = __ffs(pending_bits);
-			int port = (word_idx * BITS_PER_LONG) + bit_idx;
-			int irq = evtchn_to_irq[port];
+		if (__get_cpu_var(nesting_count)++)
+			goto out;
 
-			if (irq != -1) {
-				regs->orig_ax = ~irq;
-				do_IRQ(regs);
+#ifndef CONFIG_X86 /* No need for a barrier -- XCHG is a barrier on x86. */
+		/* Clear master flag /before/ clearing selector flag. */
+		rmb();
+#endif
+		pending_words = xchg(&vcpu_info->evtchn_pending_sel, 0);
+		while (pending_words != 0) {
+			unsigned long pending_bits;
+			int word_idx = __ffs(pending_words);
+			pending_words &= ~(1UL << word_idx);
+
+			while ((pending_bits = active_evtchns(cpu, s, word_idx)) != 0) {
+				int bit_idx = __ffs(pending_bits);
+				int port = (word_idx * BITS_PER_LONG) + bit_idx;
+				int irq = evtchn_to_irq[port];
+
+				if (irq != -1)
+					xen_do_IRQ(irq, regs);
 			}
 		}
-	}
 
+		BUG_ON(!irqs_disabled());
+
+		count = __get_cpu_var(nesting_count);
+		__get_cpu_var(nesting_count) = 0;
+	} while(count != 1);
+
+out:
 	put_cpu();
 }
 
@@ -525,6 +586,22 @@ static void set_affinity_irq(unsigned irq, cpumask_t dest)
 	rebind_irq_to_cpu(irq, tcpu);
 }
 
+int resend_irq_on_evtchn(unsigned int irq)
+{
+	int masked, evtchn = evtchn_from_irq(irq);
+	struct shared_info *s = HYPERVISOR_shared_info;
+
+	if (!VALID_EVTCHN(evtchn))
+		return 1;
+
+	masked = sync_test_and_set_bit(evtchn, s->evtchn_mask);
+	sync_set_bit(evtchn, s->evtchn_pending);
+	if (!masked)
+		unmask_evtchn(evtchn);
+
+	return 1;
+}
+
 static void enable_dynirq(unsigned int irq)
 {
 	int evtchn = evtchn_from_irq(irq);
@@ -554,10 +631,16 @@ static void ack_dynirq(unsigned int irq)
 static int retrigger_dynirq(unsigned int irq)
 {
 	int evtchn = evtchn_from_irq(irq);
+	struct shared_info *sh = HYPERVISOR_shared_info;
 	int ret = 0;
 
 	if (VALID_EVTCHN(evtchn)) {
-		set_evtchn(evtchn);
+		int masked;
+
+		masked = sync_test_and_set_bit(evtchn, sh->evtchn_mask);
+		sync_set_bit(evtchn, sh->evtchn_pending);
+		if (!masked)
+			unmask_evtchn(evtchn);
 		ret = 1;
 	}
 
diff --git a/arch/x86/xen/features.c b/drivers/xen/features.c
similarity index 100%
rename from arch/x86/xen/features.c
rename to drivers/xen/features.c
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index d85dc6d..52b6b41 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -439,24 +439,6 @@ static inline unsigned int max_nr_grant_frames(void)
 	return xen_max;
 }
 
-static int map_pte_fn(pte_t *pte, struct page *pmd_page,
-		      unsigned long addr, void *data)
-{
-	unsigned long **frames = (unsigned long **)data;
-
-	set_pte_at(&init_mm, addr, pte, mfn_pte((*frames)[0], PAGE_KERNEL));
-	(*frames)++;
-	return 0;
-}
-
-static int unmap_pte_fn(pte_t *pte, struct page *pmd_page,
-			unsigned long addr, void *data)
-{
-
-	set_pte_at(&init_mm, addr, pte, __pte(0));
-	return 0;
-}
-
 static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
 {
 	struct gnttab_setup_table setup;
@@ -470,7 +452,7 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
 
 	setup.dom        = DOMID_SELF;
 	setup.nr_frames  = nr_gframes;
-	setup.frame_list = frames;
+	set_xen_guest_handle(setup.frame_list, frames);
 
 	rc = HYPERVISOR_grant_table_op(GNTTABOP_setup_table, &setup, 1);
 	if (rc == -ENOSYS) {
@@ -480,17 +462,9 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
 
 	BUG_ON(rc || setup.status);
 
-	if (shared == NULL) {
-		struct vm_struct *area;
-		area = alloc_vm_area(PAGE_SIZE * max_nr_grant_frames());
-		BUG_ON(area == NULL);
-		shared = area->addr;
-	}
-	rc = apply_to_page_range(&init_mm, (unsigned long)shared,
-				 PAGE_SIZE * nr_gframes,
-				 map_pte_fn, &frames);
+	rc = arch_gnttab_map_shared(frames, nr_gframes, max_nr_grant_frames(),
+				    &shared);
 	BUG_ON(rc);
-	frames -= nr_gframes; /* adjust after map_pte_fn() */
 
 	kfree(frames);
 
@@ -506,10 +480,7 @@ static int gnttab_resume(void)
 
 static int gnttab_suspend(void)
 {
-	apply_to_page_range(&init_mm, (unsigned long)shared,
-			    PAGE_SIZE * nr_grant_frames,
-			    unmap_pte_fn, NULL);
-
+	arch_gnttab_unmap_shared(shared, nr_grant_frames);
 	return 0;
 }
 
diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
index 9fd2f70..0f86b0f 100644
--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -399,7 +399,7 @@ int xenbus_map_ring_valloc(struct xenbus_device *dev, int gnt_ref, void **vaddr)
 
 	*vaddr = NULL;
 
-	area = alloc_vm_area(PAGE_SIZE);
+	area = xen_alloc_vm_area(PAGE_SIZE);
 	if (!area)
 		return -ENOMEM;
 
@@ -409,7 +409,7 @@ int xenbus_map_ring_valloc(struct xenbus_device *dev, int gnt_ref, void **vaddr)
 		BUG();
 
 	if (op.status != GNTST_okay) {
-		free_vm_area(area);
+		xen_free_vm_area(area);
 		xenbus_dev_fatal(dev, op.status,
 				 "mapping in shared page %d from domain %d",
 				 gnt_ref, dev->otherend_id);
@@ -508,7 +508,7 @@ int xenbus_unmap_ring_vfree(struct xenbus_device *dev, void *vaddr)
 		BUG();
 
 	if (op.status == GNTST_okay)
-		free_vm_area(area);
+		xen_free_vm_area(area);
 	else
 		xenbus_dev_error(dev, op.status,
 				 "unmapping page at handle %d error %d",
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 4750de3..57ceb53 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -88,6 +88,16 @@ int xenbus_match(struct device *_dev, struct device_driver *_drv)
 	return match_device(drv->ids, to_xenbus_device(_dev)) != NULL;
 }
 
+static int xenbus_uevent(struct device *_dev, struct kobj_uevent_env *env)
+{
+	struct xenbus_device *dev = to_xenbus_device(_dev);
+
+	if (add_uevent_var(env, "MODALIAS=xen:%s", dev->devicetype))
+		return -ENOMEM;
+
+	return 0;
+}
+
 /* device/<type>/<id> => <type>-<id> */
 static int frontend_bus_id(char bus_id[BUS_ID_SIZE], const char *nodename)
 {
@@ -166,6 +176,7 @@ static struct xen_bus_type xenbus_frontend = {
 	.bus = {
 		.name     = "xen",
 		.match    = xenbus_match,
+		.uevent   = xenbus_uevent,
 		.probe    = xenbus_dev_probe,
 		.remove   = xenbus_dev_remove,
 		.shutdown = xenbus_dev_shutdown,
@@ -438,6 +449,12 @@ static ssize_t xendev_show_devtype(struct device *dev,
 }
 DEVICE_ATTR(devtype, S_IRUSR | S_IRGRP | S_IROTH, xendev_show_devtype, NULL);
 
+static ssize_t xendev_show_modalias(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "xen:%s\n", to_xenbus_device(dev)->devicetype);
+}
+DEVICE_ATTR(modalias, S_IRUSR | S_IRGRP | S_IROTH, xendev_show_modalias, NULL);
 
 int xenbus_probe_node(struct xen_bus_type *bus,
 		      const char *type,
@@ -492,10 +509,16 @@ int xenbus_probe_node(struct xen_bus_type *bus,
 
 	err = device_create_file(&xendev->dev, &dev_attr_devtype);
 	if (err)
-		goto fail_remove_file;
+		goto fail_remove_nodename;
+
+	err = device_create_file(&xendev->dev, &dev_attr_modalias);
+	if (err)
+		goto fail_remove_devtype;
 
 	return 0;
-fail_remove_file:
+fail_remove_devtype:
+	device_remove_file(&xendev->dev, &dev_attr_devtype);
+fail_remove_nodename:
 	device_remove_file(&xendev->dev, &dev_attr_nodename);
 fail_unregister:
 	device_unregister(&xendev->dev);
@@ -846,6 +869,7 @@ static int is_disconnected_device(struct device *dev, void *data)
 {
 	struct xenbus_device *xendev = to_xenbus_device(dev);
 	struct device_driver *drv = data;
+	struct xenbus_driver *xendrv;
 
 	/*
 	 * A device with no driver will never connect. We care only about
@@ -858,7 +882,9 @@ static int is_disconnected_device(struct device *dev, void *data)
 	if (drv && (dev->driver != drv))
 		return 0;
 
-	return (xendev->state != XenbusStateConnected);
+	xendrv = to_xenbus_driver(dev->driver);
+	return (xendev->state != XenbusStateConnected ||
+		(xendrv->is_ready && !xendrv->is_ready(xendev)));
 }
 
 static int exists_disconnected_device(struct device_driver *drv)
diff --git a/drivers/xen/xencomm.c b/drivers/xen/xencomm.c
new file mode 100644
index 0000000..797cb4e
--- /dev/null
+++ b/drivers/xen/xencomm.c
@@ -0,0 +1,232 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ * Copyright (C) IBM Corp. 2006
+ *
+ * Authors: Hollis Blanchard <hollisb@us.ibm.com>
+ */
+
+#include <linux/gfp.h>
+#include <linux/mm.h>
+#include <asm/page.h>
+#include <xen/xencomm.h>
+#include <xen/interface/xen.h>
+#ifdef __ia64__
+#include <asm/xen/xencomm.h>	/* for is_kern_addr() */
+#endif
+
+#ifdef HAVE_XEN_PLATFORM_COMPAT_H
+#include <xen/platform-compat.h>
+#endif
+
+static int xencomm_init(struct xencomm_desc *desc,
+			void *buffer, unsigned long bytes)
+{
+	unsigned long recorded = 0;
+	int i = 0;
+
+	while ((recorded < bytes) && (i < desc->nr_addrs)) {
+		unsigned long vaddr = (unsigned long)buffer + recorded;
+		unsigned long paddr;
+		int offset;
+		int chunksz;
+
+		offset = vaddr % PAGE_SIZE; /* handle partial pages */
+		chunksz = min(PAGE_SIZE - offset, bytes - recorded);
+
+		paddr = xencomm_vtop(vaddr);
+		if (paddr == ~0UL) {
+			printk(KERN_DEBUG "%s: couldn't translate vaddr %lx\n",
+			       __func__, vaddr);
+			return -EINVAL;
+		}
+
+		desc->address[i++] = paddr;
+		recorded += chunksz;
+	}
+
+	if (recorded < bytes) {
+		printk(KERN_DEBUG
+		       "%s: could only translate %ld of %ld bytes\n",
+		       __func__, recorded, bytes);
+		return -ENOSPC;
+	}
+
+	/* mark remaining addresses invalid (just for safety) */
+	while (i < desc->nr_addrs)
+		desc->address[i++] = XENCOMM_INVALID;
+
+	desc->magic = XENCOMM_MAGIC;
+
+	return 0;
+}
+
+static struct xencomm_desc *xencomm_alloc(gfp_t gfp_mask,
+					  void *buffer, unsigned long bytes)
+{
+	struct xencomm_desc *desc;
+	unsigned long buffer_ulong = (unsigned long)buffer;
+	unsigned long start = buffer_ulong & PAGE_MASK;
+	unsigned long end = (buffer_ulong + bytes) | ~PAGE_MASK;
+	unsigned long nr_addrs = (end - start + 1) >> PAGE_SHIFT;
+	unsigned long size = sizeof(*desc) +
+		sizeof(desc->address[0]) * nr_addrs;
+
+	/*
+	 * slab allocator returns at least sizeof(void*) aligned pointer.
+	 * When sizeof(*desc) > sizeof(void*), struct xencomm_desc might
+	 * cross page boundary.
+	 */
+	if (sizeof(*desc) > sizeof(void *)) {
+		unsigned long order = get_order(size);
+		desc = (struct xencomm_desc *)__get_free_pages(gfp_mask,
+							       order);
+		if (desc == NULL)
+			return NULL;
+
+		desc->nr_addrs =
+			((PAGE_SIZE << order) - sizeof(struct xencomm_desc)) /
+			sizeof(*desc->address);
+	} else {
+		desc = kmalloc(size, gfp_mask);
+		if (desc == NULL)
+			return NULL;
+
+		desc->nr_addrs = nr_addrs;
+	}
+	return desc;
+}
+
+void xencomm_free(struct xencomm_handle *desc)
+{
+	if (desc && !((ulong)desc & XENCOMM_INLINE_FLAG)) {
+		struct xencomm_desc *desc__ = (struct xencomm_desc *)desc;
+		if (sizeof(*desc__) > sizeof(void *)) {
+			unsigned long size = sizeof(*desc__) +
+				sizeof(desc__->address[0]) * desc__->nr_addrs;
+			unsigned long order = get_order(size);
+			free_pages((unsigned long)__va(desc), order);
+		} else
+			kfree(__va(desc));
+	}
+}
+
+static int xencomm_create(void *buffer, unsigned long bytes,
+			  struct xencomm_desc **ret, gfp_t gfp_mask)
+{
+	struct xencomm_desc *desc;
+	int rc;
+
+	pr_debug("%s: %p[%ld]\n", __func__, buffer, bytes);
+
+	if (bytes == 0) {
+		/* don't create a descriptor; Xen recognizes NULL. */
+		BUG_ON(buffer != NULL);
+		*ret = NULL;
+		return 0;
+	}
+
+	BUG_ON(buffer == NULL); /* 'bytes' is non-zero */
+
+	desc = xencomm_alloc(gfp_mask, buffer, bytes);
+	if (!desc) {
+		printk(KERN_DEBUG "%s failure\n", "xencomm_alloc");
+		return -ENOMEM;
+	}
+
+	rc = xencomm_init(desc, buffer, bytes);
+	if (rc) {
+		printk(KERN_DEBUG "%s failure: %d\n", "xencomm_init", rc);
+		xencomm_free((struct xencomm_handle *)__pa(desc));
+		return rc;
+	}
+
+	*ret = desc;
+	return 0;
+}
+
+/* check if memory address is within VMALLOC region  */
+static int is_phys_contiguous(unsigned long addr)
+{
+	if (!is_kernel_addr(addr))
+		return 0;
+
+	return (addr < VMALLOC_START) || (addr >= VMALLOC_END);
+}
+
+static struct xencomm_handle *xencomm_create_inline(void *ptr)
+{
+	unsigned long paddr;
+
+	BUG_ON(!is_phys_contiguous((unsigned long)ptr));
+
+	paddr = (unsigned long)xencomm_pa(ptr);
+	BUG_ON(paddr & XENCOMM_INLINE_FLAG);
+	return (struct xencomm_handle *)(paddr | XENCOMM_INLINE_FLAG);
+}
+
+/* "mini" routine, for stack-based communications: */
+static int xencomm_create_mini(void *buffer,
+	unsigned long bytes, struct xencomm_mini *xc_desc,
+	struct xencomm_desc **ret)
+{
+	int rc = 0;
+	struct xencomm_desc *desc;
+	BUG_ON(((unsigned long)xc_desc) % sizeof(*xc_desc) != 0);
+
+	desc = (void *)xc_desc;
+
+	desc->nr_addrs = XENCOMM_MINI_ADDRS;
+
+	rc = xencomm_init(desc, buffer, bytes);
+	if (!rc)
+		*ret = desc;
+
+	return rc;
+}
+
+struct xencomm_handle *xencomm_map(void *ptr, unsigned long bytes)
+{
+	int rc;
+	struct xencomm_desc *desc;
+
+	if (is_phys_contiguous((unsigned long)ptr))
+		return xencomm_create_inline(ptr);
+
+	rc = xencomm_create(ptr, bytes, &desc, GFP_KERNEL);
+
+	if (rc || desc == NULL)
+		return NULL;
+
+	return xencomm_pa(desc);
+}
+
+struct xencomm_handle *__xencomm_map_no_alloc(void *ptr, unsigned long bytes,
+			struct xencomm_mini *xc_desc)
+{
+	int rc;
+	struct xencomm_desc *desc = NULL;
+
+	if (is_phys_contiguous((unsigned long)ptr))
+		return xencomm_create_inline(ptr);
+
+	rc = xencomm_create_mini(ptr, bytes, xc_desc,
+				&desc);
+
+	if (rc)
+		return NULL;
+
+	return xencomm_pa(desc);
+}
diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
index 3d41939..0f13b94 100644
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -220,11 +220,13 @@ struct pv_mmu_ops {
 				 unsigned long va);
 
 	/* Hooks for allocating/releasing pagetable pages */
-	void (*alloc_pt)(struct mm_struct *mm, u32 pfn);
-	void (*alloc_pd)(struct mm_struct *mm, u32 pfn);
-	void (*alloc_pd_clone)(u32 pfn, u32 clonepfn, u32 start, u32 count);
-	void (*release_pt)(u32 pfn);
-	void (*release_pd)(u32 pfn);
+	void (*alloc_pte)(struct mm_struct *mm, u32 pfn);
+	void (*alloc_pmd)(struct mm_struct *mm, u32 pfn);
+	void (*alloc_pmd_clone)(u32 pfn, u32 clonepfn, u32 start, u32 count);
+	void (*alloc_pud)(struct mm_struct *mm, u32 pfn);
+	void (*release_pte)(u32 pfn);
+	void (*release_pmd)(u32 pfn);
+	void (*release_pud)(u32 pfn);
 
 	/* Pagetable manipulation functions */
 	void (*set_pte)(pte_t *ptep, pte_t pteval);
@@ -910,28 +912,37 @@ static inline void flush_tlb_others(cpumask_t cpumask, struct mm_struct *mm,
 	PVOP_VCALL3(pv_mmu_ops.flush_tlb_others, &cpumask, mm, va);
 }
 
-static inline void paravirt_alloc_pt(struct mm_struct *mm, unsigned pfn)
+static inline void paravirt_alloc_pte(struct mm_struct *mm, unsigned pfn)
 {
-	PVOP_VCALL2(pv_mmu_ops.alloc_pt, mm, pfn);
+	PVOP_VCALL2(pv_mmu_ops.alloc_pte, mm, pfn);
 }
-static inline void paravirt_release_pt(unsigned pfn)
+static inline void paravirt_release_pte(unsigned pfn)
 {
-	PVOP_VCALL1(pv_mmu_ops.release_pt, pfn);
+	PVOP_VCALL1(pv_mmu_ops.release_pte, pfn);
 }
 
-static inline void paravirt_alloc_pd(struct mm_struct *mm, unsigned pfn)
+static inline void paravirt_alloc_pmd(struct mm_struct *mm, unsigned pfn)
 {
-	PVOP_VCALL2(pv_mmu_ops.alloc_pd, mm, pfn);
+	PVOP_VCALL2(pv_mmu_ops.alloc_pmd, mm, pfn);
 }
 
-static inline void paravirt_alloc_pd_clone(unsigned pfn, unsigned clonepfn,
-					   unsigned start, unsigned count)
+static inline void paravirt_alloc_pmd_clone(unsigned pfn, unsigned clonepfn,
+					    unsigned start, unsigned count)
 {
-	PVOP_VCALL4(pv_mmu_ops.alloc_pd_clone, pfn, clonepfn, start, count);
+	PVOP_VCALL4(pv_mmu_ops.alloc_pmd_clone, pfn, clonepfn, start, count);
 }
-static inline void paravirt_release_pd(unsigned pfn)
+static inline void paravirt_release_pmd(unsigned pfn)
 {
-	PVOP_VCALL1(pv_mmu_ops.release_pd, pfn);
+	PVOP_VCALL1(pv_mmu_ops.release_pmd, pfn);
+}
+
+static inline void paravirt_alloc_pud(struct mm_struct *mm, unsigned pfn)
+{
+	PVOP_VCALL2(pv_mmu_ops.alloc_pud, mm, pfn);
+}
+static inline void paravirt_release_pud(unsigned pfn)
+{
+	PVOP_VCALL1(pv_mmu_ops.release_pud, pfn);
 }
 
 #ifdef CONFIG_HIGHPTE
diff --git a/include/asm-x86/pgalloc.h b/include/asm-x86/pgalloc.h
index 5886eed..91e4641 100644
--- a/include/asm-x86/pgalloc.h
+++ b/include/asm-x86/pgalloc.h
@@ -1,5 +1,110 @@
-#ifdef CONFIG_X86_32
-# include "pgalloc_32.h"
+#ifndef _ASM_X86_PGALLOC_H
+#define _ASM_X86_PGALLOC_H
+
+#include <linux/threads.h>
+#include <linux/mm.h>		/* for struct page */
+#include <linux/pagemap.h>
+
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
 #else
-# include "pgalloc_64.h"
+static inline void paravirt_alloc_pte(struct mm_struct *mm, unsigned long pfn)	{}
+static inline void paravirt_alloc_pmd(struct mm_struct *mm, unsigned long pfn)	{}
+static inline void paravirt_alloc_pmd_clone(unsigned long pfn, unsigned long clonepfn,
+					    unsigned long start, unsigned long count) {}
+static inline void paravirt_alloc_pud(struct mm_struct *mm, unsigned long pfn)	{}
+static inline void paravirt_release_pte(unsigned long pfn) {}
+static inline void paravirt_release_pmd(unsigned long pfn) {}
+static inline void paravirt_release_pud(unsigned long pfn) {}
 #endif
+
+/*
+ * Allocate and free page tables.
+ */
+extern pgd_t *pgd_alloc(struct mm_struct *);
+extern void pgd_free(struct mm_struct *mm, pgd_t *pgd);
+
+extern pte_t *pte_alloc_one_kernel(struct mm_struct *, unsigned long);
+extern pgtable_t pte_alloc_one(struct mm_struct *, unsigned long);
+
+/* Should really implement gc for free page table pages. This could be
+   done with a reference count in struct page. */
+
+static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
+{
+	BUG_ON((unsigned long)pte & (PAGE_SIZE-1));
+	free_page((unsigned long)pte);
+}
+
+static inline void pte_free(struct mm_struct *mm, struct page *pte)
+{
+	__free_page(pte);
+}
+
+extern void __pte_free_tlb(struct mmu_gather *tlb, struct page *pte);
+
+static inline void pmd_populate_kernel(struct mm_struct *mm,
+				       pmd_t *pmd, pte_t *pte)
+{
+	paravirt_alloc_pte(mm, __pa(pte) >> PAGE_SHIFT);
+	set_pmd(pmd, __pmd(__pa(pte) | _PAGE_TABLE));
+}
+
+static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd,
+				struct page *pte)
+{
+	unsigned long pfn = page_to_pfn(pte);
+
+	paravirt_alloc_pte(mm, pfn);
+	set_pmd(pmd, __pmd(((pteval_t)pfn << PAGE_SHIFT) | _PAGE_TABLE));
+}
+
+#define pmd_pgtable(pmd) pmd_page(pmd)
+
+#if PAGETABLE_LEVELS > 2
+static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
+{
+	return (pmd_t *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
+}
+
+static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
+{
+	BUG_ON((unsigned long)pmd & (PAGE_SIZE-1));
+	free_page((unsigned long)pmd);
+}
+
+extern void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd);
+
+#ifdef CONFIG_X86_PAE
+extern void pud_populate(struct mm_struct *mm, pud_t *pudp, pmd_t *pmd);
+#else	/* !CONFIG_X86_PAE */
+static inline void pud_populate(struct mm_struct *mm, pud_t *pud, pmd_t *pmd)
+{
+	paravirt_alloc_pmd(mm, __pa(pmd) >> PAGE_SHIFT);
+	set_pud(pud, __pud(_PAGE_TABLE | __pa(pmd)));
+}
+#endif	/* CONFIG_X86_PAE */
+
+#if PAGETABLE_LEVELS > 3
+static inline void pgd_populate(struct mm_struct *mm, pgd_t *pgd, pud_t *pud)
+{
+	paravirt_alloc_pud(mm, __pa(pud) >> PAGE_SHIFT);
+	set_pgd(pgd, __pgd(_PAGE_TABLE | __pa(pud)));
+}
+
+static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr)
+{
+	return (pud_t *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
+}
+
+static inline void pud_free(struct mm_struct *mm, pud_t *pud)
+{
+	BUG_ON((unsigned long)pud & (PAGE_SIZE-1));
+	free_page((unsigned long)pud);
+}
+
+extern void __pud_free_tlb(struct mmu_gather *tlb, pud_t *pud);
+#endif	/* PAGETABLE_LEVELS > 3 */
+#endif	/* PAGETABLE_LEVELS > 2 */
+
+#endif	/* _ASM_X86_PGALLOC_H */
diff --git a/include/asm-x86/pgalloc_32.h b/include/asm-x86/pgalloc_32.h
deleted file mode 100644
index 6bea6e5..0000000
--- a/include/asm-x86/pgalloc_32.h
+++ /dev/null
@@ -1,95 +0,0 @@
-#ifndef _I386_PGALLOC_H
-#define _I386_PGALLOC_H
-
-#include <linux/threads.h>
-#include <linux/mm.h>		/* for struct page */
-#include <linux/pagemap.h>
-#include <asm/tlb.h>
-#include <asm-generic/tlb.h>
-
-#ifdef CONFIG_PARAVIRT
-#include <asm/paravirt.h>
-#else
-#define paravirt_alloc_pt(mm, pfn) do { } while (0)
-#define paravirt_alloc_pd(mm, pfn) do { } while (0)
-#define paravirt_alloc_pd_clone(pfn, clonepfn, start, count) do { } while (0)
-#define paravirt_release_pt(pfn) do { } while (0)
-#define paravirt_release_pd(pfn) do { } while (0)
-#endif
-
-static inline void pmd_populate_kernel(struct mm_struct *mm,
-				       pmd_t *pmd, pte_t *pte)
-{
-	paravirt_alloc_pt(mm, __pa(pte) >> PAGE_SHIFT);
-	set_pmd(pmd, __pmd(__pa(pte) | _PAGE_TABLE));
-}
-
-static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd, struct page *pte)
-{
-	unsigned long pfn = page_to_pfn(pte);
-
-	paravirt_alloc_pt(mm, pfn);
-	set_pmd(pmd, __pmd(((pteval_t)pfn << PAGE_SHIFT) | _PAGE_TABLE));
-}
-#define pmd_pgtable(pmd) pmd_page(pmd)
-
-/*
- * Allocate and free page tables.
- */
-extern pgd_t *pgd_alloc(struct mm_struct *);
-extern void pgd_free(struct mm_struct *mm, pgd_t *pgd);
-
-extern pte_t *pte_alloc_one_kernel(struct mm_struct *, unsigned long);
-extern pgtable_t pte_alloc_one(struct mm_struct *, unsigned long);
-
-static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
-{
-	free_page((unsigned long)pte);
-}
-
-static inline void pte_free(struct mm_struct *mm, pgtable_t pte)
-{
-	pgtable_page_dtor(pte);
-	__free_page(pte);
-}
-
-
-extern void __pte_free_tlb(struct mmu_gather *tlb, struct page *pte);
-
-#ifdef CONFIG_X86_PAE
-/*
- * In the PAE case we free the pmds as part of the pgd.
- */
-static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
-{
-	return (pmd_t *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
-}
-
-static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
-{
-	BUG_ON((unsigned long)pmd & (PAGE_SIZE-1));
-	free_page((unsigned long)pmd);
-}
-
-extern void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd);
-
-static inline void pud_populate(struct mm_struct *mm, pud_t *pudp, pmd_t *pmd)
-{
-	paravirt_alloc_pd(mm, __pa(pmd) >> PAGE_SHIFT);
-
-	/* Note: almost everything apart from _PAGE_PRESENT is
-	   reserved at the pmd (PDPT) level. */
-	set_pud(pudp, __pud(__pa(pmd) | _PAGE_PRESENT));
-
-	/*
-	 * According to Intel App note "TLBs, Paging-Structure Caches,
-	 * and Their Invalidation", April 2007, document 317080-001,
-	 * section 8.1: in PAE mode we explicitly have to flush the
-	 * TLB via cr3 if the top-level pgd is changed...
-	 */
-	if (mm == current->active_mm)
-		write_cr3(read_cr3());
-}
-#endif	/* CONFIG_X86_PAE */
-
-#endif /* _I386_PGALLOC_H */
diff --git a/include/asm-x86/pgalloc_64.h b/include/asm-x86/pgalloc_64.h
deleted file mode 100644
index 8d67223..0000000
--- a/include/asm-x86/pgalloc_64.h
+++ /dev/null
@@ -1,133 +0,0 @@
-#ifndef _X86_64_PGALLOC_H
-#define _X86_64_PGALLOC_H
-
-#include <asm/pda.h>
-#include <linux/threads.h>
-#include <linux/mm.h>
-
-#define pmd_populate_kernel(mm, pmd, pte) \
-		set_pmd(pmd, __pmd(_PAGE_TABLE | __pa(pte)))
-#define pud_populate(mm, pud, pmd) \
-		set_pud(pud, __pud(_PAGE_TABLE | __pa(pmd)))
-#define pgd_populate(mm, pgd, pud) \
-		set_pgd(pgd, __pgd(_PAGE_TABLE | __pa(pud)))
-
-#define pmd_pgtable(pmd) pmd_page(pmd)
-
-static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd, struct page *pte)
-{
-	set_pmd(pmd, __pmd(_PAGE_TABLE | (page_to_pfn(pte) << PAGE_SHIFT)));
-}
-
-static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
-{
-	BUG_ON((unsigned long)pmd & (PAGE_SIZE-1));
-	free_page((unsigned long)pmd);
-}
-
-static inline pmd_t *pmd_alloc_one (struct mm_struct *mm, unsigned long addr)
-{
-	return (pmd_t *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
-}
-
-static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr)
-{
-	return (pud_t *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
-}
-
-static inline void pud_free(struct mm_struct *mm, pud_t *pud)
-{
-	BUG_ON((unsigned long)pud & (PAGE_SIZE-1));
-	free_page((unsigned long)pud);
-}
-
-static inline void pgd_list_add(pgd_t *pgd)
-{
-	struct page *page = virt_to_page(pgd);
-	unsigned long flags;
-
-	spin_lock_irqsave(&pgd_lock, flags);
-	list_add(&page->lru, &pgd_list);
-	spin_unlock_irqrestore(&pgd_lock, flags);
-}
-
-static inline void pgd_list_del(pgd_t *pgd)
-{
-	struct page *page = virt_to_page(pgd);
-	unsigned long flags;
-
-	spin_lock_irqsave(&pgd_lock, flags);
-	list_del(&page->lru);
-	spin_unlock_irqrestore(&pgd_lock, flags);
-}
-
-static inline pgd_t *pgd_alloc(struct mm_struct *mm)
-{
-	unsigned boundary;
-	pgd_t *pgd = (pgd_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT);
-	if (!pgd)
-		return NULL;
-	pgd_list_add(pgd);
-	/*
-	 * Copy kernel pointers in from init.
-	 * Could keep a freelist or slab cache of those because the kernel
-	 * part never changes.
-	 */
-	boundary = pgd_index(__PAGE_OFFSET);
-	memset(pgd, 0, boundary * sizeof(pgd_t));
-	memcpy(pgd + boundary,
-	       init_level4_pgt + boundary,
-	       (PTRS_PER_PGD - boundary) * sizeof(pgd_t));
-	return pgd;
-}
-
-static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
-{
-	BUG_ON((unsigned long)pgd & (PAGE_SIZE-1));
-	pgd_list_del(pgd);
-	free_page((unsigned long)pgd);
-}
-
-static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
-{
-	return (pte_t *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
-}
-
-static inline pgtable_t pte_alloc_one(struct mm_struct *mm, unsigned long address)
-{
-	struct page *page;
-	void *p;
-
-	p = (void *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
-	if (!p)
-		return NULL;
-	page = virt_to_page(p);
-	pgtable_page_ctor(page);
-	return page;
-}
-
-/* Should really implement gc for free page table pages. This could be
-   done with a reference count in struct page. */
-
-static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
-{
-	BUG_ON((unsigned long)pte & (PAGE_SIZE-1));
-	free_page((unsigned long)pte); 
-}
-
-static inline void pte_free(struct mm_struct *mm, pgtable_t pte)
-{
-	pgtable_page_dtor(pte);
-	__free_page(pte);
-} 
-
-#define __pte_free_tlb(tlb,pte)				\
-do {							\
-	pgtable_page_dtor((pte));				\
-	tlb_remove_page((tlb), (pte));			\
-} while (0)
-
-#define __pmd_free_tlb(tlb,x)   tlb_remove_page((tlb),virt_to_page(x))
-#define __pud_free_tlb(tlb,x)   tlb_remove_page((tlb),virt_to_page(x))
-
-#endif /* _X86_64_PGALLOC_H */
diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
index f1d9f4a..b8a08bd 100644
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -1,7 +1,6 @@
 #ifndef _ASM_X86_PGTABLE_H
 #define _ASM_X86_PGTABLE_H
 
-#define USER_PTRS_PER_PGD	((TASK_SIZE-1)/PGDIR_SIZE+1)
 #define FIRST_USER_ADDRESS	0
 
 #define _PAGE_BIT_PRESENT	0	/* is present */
@@ -330,6 +329,9 @@ static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 # include "pgtable_64.h"
 #endif
 
+#define KERNEL_PGD_BOUNDARY	pgd_index(PAGE_OFFSET)
+#define KERNEL_PGD_PTRS		(PTRS_PER_PGD - KERNEL_PGD_BOUNDARY)
+
 #ifndef __ASSEMBLY__
 
 enum {
@@ -389,37 +391,17 @@ static inline void native_set_pte_at(struct mm_struct *mm, unsigned long addr,
  * bit at the same time.
  */
 #define  __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
-#define ptep_set_access_flags(vma, address, ptep, entry, dirty)		\
-({									\
-	int __changed = !pte_same(*(ptep), entry);			\
-	if (__changed && dirty) {					\
-		*ptep = entry;						\
-		pte_update_defer((vma)->vm_mm, (address), (ptep));	\
-		flush_tlb_page(vma, address);				\
-	}								\
-	__changed;							\
-})
+extern int ptep_set_access_flags(struct vm_area_struct *vma,
+				 unsigned long address, pte_t *ptep,
+				 pte_t entry, int dirty);
 
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
-#define ptep_test_and_clear_young(vma, addr, ptep) ({			\
-	int __ret = 0;							\
-	if (pte_young(*(ptep)))						\
-		__ret = test_and_clear_bit(_PAGE_BIT_ACCESSED,		\
-					   &(ptep)->pte);		\
-	if (__ret)							\
-		pte_update((vma)->vm_mm, addr, ptep);			\
-	__ret;								\
-})
+extern int ptep_test_and_clear_young(struct vm_area_struct *vma,
+				     unsigned long addr, pte_t *ptep);
 
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
-#define ptep_clear_flush_young(vma, address, ptep)			\
-({									\
-	int __young;							\
-	__young = ptep_test_and_clear_young((vma), (address), (ptep));	\
-	if (__young)							\
-		flush_tlb_page(vma, address);				\
-	__young;							\
-})
+extern int ptep_clear_flush_young(struct vm_area_struct *vma,
+				  unsigned long address, pte_t *ptep);
 
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr,
@@ -456,6 +438,22 @@ static inline void ptep_set_wrprotect(struct mm_struct *mm,
 	pte_update(mm, addr, ptep);
 }
 
+/*
+ * clone_pgd_range(pgd_t *dst, pgd_t *src, int count);
+ *
+ *  dst - pointer to pgd range anwhere on a pgd page
+ *  src - ""
+ *  count - the number of pgds to copy.
+ *
+ * dst and src can be on the same page, but the range must not overlap,
+ * and must not cross a page boundary.
+ */
+static inline void clone_pgd_range(pgd_t *dst, pgd_t *src, int count)
+{
+       memcpy(dst, src, count * sizeof(pgd_t));
+}
+
+
 #include <asm-generic/pgtable.h>
 #endif	/* __ASSEMBLY__ */
 
diff --git a/include/asm-x86/pgtable_32.h b/include/asm-x86/pgtable_32.h
index c4a6436..168b644 100644
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -48,9 +48,6 @@ void paging_init(void);
 #define PGDIR_SIZE	(1UL << PGDIR_SHIFT)
 #define PGDIR_MASK	(~(PGDIR_SIZE - 1))
 
-#define USER_PGD_PTRS (PAGE_OFFSET >> PGDIR_SHIFT)
-#define KERNEL_PGD_PTRS (PTRS_PER_PGD-USER_PGD_PTRS)
-
 /* Just any arbitrary offset to the start of the vmalloc VM area: the
  * current 8MB value just means that there will be a 8MB "hole" after the
  * physical memory until the kernel virtual memory starts.  That means that
@@ -109,21 +106,6 @@ extern int pmd_bad(pmd_t pmd);
 #endif
 
 /*
- * clone_pgd_range(pgd_t *dst, pgd_t *src, int count);
- *
- *  dst - pointer to pgd range anwhere on a pgd page
- *  src - ""
- *  count - the number of pgds to copy.
- *
- * dst and src can be on the same page, but the range must not overlap,
- * and must not cross a page boundary.
- */
-static inline void clone_pgd_range(pgd_t *dst, pgd_t *src, int count)
-{
-       memcpy(dst, src, count * sizeof(pgd_t));
-}
-
-/*
  * Macro to mark a page protection value as "uncacheable".
  * On processors which do not support it, this is a no-op.
  */
diff --git a/include/asm-x86/pgtable_64.h b/include/asm-x86/pgtable_64.h
index 9fd87d0..a3bbf87 100644
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -24,7 +24,7 @@ extern void paging_init(void);
 
 #endif /* !__ASSEMBLY__ */
 
-#define SHARED_KERNEL_PMD	1
+#define SHARED_KERNEL_PMD	0
 
 /*
  * PGDIR_SHIFT determines what a top-level page table entry can map
diff --git a/include/asm-x86/xen/events.h b/include/asm-x86/xen/events.h
new file mode 100644
index 0000000..596312a
--- /dev/null
+++ b/include/asm-x86/xen/events.h
@@ -0,0 +1,22 @@
+#ifndef __XEN_EVENTS_H
+#define __XEN_EVENTS_H
+
+enum ipi_vector {
+	XEN_RESCHEDULE_VECTOR,
+	XEN_CALL_FUNCTION_VECTOR,
+
+	XEN_NR_IPIS,
+};
+
+static inline int xen_irqs_disabled(struct pt_regs *regs)
+{
+	return raw_irqs_disabled_flags(regs->flags);
+}
+
+static inline void xen_do_IRQ(int irq, struct pt_regs *regs)
+{
+	regs->orig_ax = ~irq;
+	do_IRQ(regs);
+}
+
+#endif /* __XEN_EVENTS_H */
diff --git a/include/asm-x86/xen/grant_table.h b/include/asm-x86/xen/grant_table.h
new file mode 100644
index 0000000..2444d45
--- /dev/null
+++ b/include/asm-x86/xen/grant_table.h
@@ -0,0 +1,7 @@
+#ifndef __XEN_GRANT_TABLE_H
+#define __XEN_GRANT_TABLE_H
+
+#define xen_alloc_vm_area(size)	alloc_vm_area(size)
+#define xen_free_vm_area(area)	free_vm_area(area)
+
+#endif /* __XEN_GRANT_TABLE_H */
diff --git a/include/asm-x86/xen/hypercall.h b/include/asm-x86/xen/hypercall.h
index bc0ee7d..c2ccd99 100644
--- a/include/asm-x86/xen/hypercall.h
+++ b/include/asm-x86/xen/hypercall.h
@@ -164,6 +164,12 @@ HYPERVISOR_set_callbacks(unsigned long event_selector,
 }
 
 static inline int
+HYPERVISOR_callback_op(int cmd, void *arg)
+{
+	return _hypercall2(int, callback_op, cmd, arg);
+}
+
+static inline int
 HYPERVISOR_fpu_taskswitch(int set)
 {
 	return _hypercall1(int, fpu_taskswitch, set);
diff --git a/include/asm-x86/xen/interface.h b/include/asm-x86/xen/interface.h
index 165c396..6227000 100644
--- a/include/asm-x86/xen/interface.h
+++ b/include/asm-x86/xen/interface.h
@@ -22,6 +22,30 @@
 #define DEFINE_GUEST_HANDLE(name) __DEFINE_GUEST_HANDLE(name, name)
 #define GUEST_HANDLE(name)        __guest_handle_ ## name
 
+#ifdef __XEN__
+#if defined(__i386__)
+#define set_xen_guest_handle(hnd, val)			\
+	do {						\
+		if (sizeof(hnd) == 8)			\
+			*(uint64_t *)&(hnd) = 0;	\
+		(hnd).p = val;				\
+	} while (0)
+#elif defined(__x86_64__)
+#define set_xen_guest_handle(hnd, val)	do { (hnd).p = val; } while (0)
+#endif
+#else
+#if defined(__i386__)
+#define set_xen_guest_handle(hnd, val)			\
+	do {						\
+		if (sizeof(hnd) == 8)			\
+			*(uint64_t *)&(hnd) = 0;	\
+		(hnd) = val;				\
+	} while (0)
+#elif defined(__x86_64__)
+#define set_xen_guest_handle(hnd, val)	do { (hnd) = val; } while (0)
+#endif
+#endif
+
 #ifndef __ASSEMBLY__
 /* Guest handles for primitive C types. */
 __DEFINE_GUEST_HANDLE(uchar, unsigned char);
@@ -171,6 +195,10 @@ struct arch_vcpu_info {
     unsigned long pad[5]; /* sizeof(struct vcpu_info) == 64 */
 };
 
+struct xen_callback {
+	unsigned long cs;
+	unsigned long eip;
+};
 #endif /* !__ASSEMBLY__ */
 
 /*
diff --git a/include/asm-x86/xen/page.h b/include/asm-x86/xen/page.h
new file mode 100644
index 0000000..0179930
--- /dev/null
+++ b/include/asm-x86/xen/page.h
@@ -0,0 +1,168 @@
+#ifndef __XEN_PAGE_H
+#define __XEN_PAGE_H
+
+#include <linux/pfn.h>
+
+#include <asm/uaccess.h>
+#include <asm/pgtable.h>
+
+#include <xen/features.h>
+
+/* Xen machine address */
+typedef struct xmaddr {
+	phys_addr_t maddr;
+} xmaddr_t;
+
+/* Xen pseudo-physical address */
+typedef struct xpaddr {
+	phys_addr_t paddr;
+} xpaddr_t;
+
+#define XMADDR(x)	((xmaddr_t) { .maddr = (x) })
+#define XPADDR(x)	((xpaddr_t) { .paddr = (x) })
+
+/**** MACHINE <-> PHYSICAL CONVERSION MACROS ****/
+#define INVALID_P2M_ENTRY	(~0UL)
+#define FOREIGN_FRAME_BIT	(1UL<<31)
+#define FOREIGN_FRAME(m)	((m) | FOREIGN_FRAME_BIT)
+
+extern unsigned long *phys_to_machine_mapping;
+
+static inline unsigned long pfn_to_mfn(unsigned long pfn)
+{
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		return pfn;
+
+	return phys_to_machine_mapping[(unsigned int)(pfn)] &
+		~FOREIGN_FRAME_BIT;
+}
+
+static inline int phys_to_machine_mapping_valid(unsigned long pfn)
+{
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		return 1;
+
+	return (phys_to_machine_mapping[pfn] != INVALID_P2M_ENTRY);
+}
+
+static inline unsigned long mfn_to_pfn(unsigned long mfn)
+{
+	unsigned long pfn;
+
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		return mfn;
+
+#if 0
+	if (unlikely((mfn >> machine_to_phys_order) != 0))
+		return max_mapnr;
+#endif
+
+	pfn = 0;
+	/*
+	 * The array access can fail (e.g., device space beyond end of RAM).
+	 * In such cases it doesn't matter what we return (we return garbage),
+	 * but we must handle the fault without crashing!
+	 */
+	__get_user(pfn, &machine_to_phys_mapping[mfn]);
+
+	return pfn;
+}
+
+static inline xmaddr_t phys_to_machine(xpaddr_t phys)
+{
+	unsigned offset = phys.paddr & ~PAGE_MASK;
+	return XMADDR(PFN_PHYS((u64)pfn_to_mfn(PFN_DOWN(phys.paddr))) | offset);
+}
+
+static inline xpaddr_t machine_to_phys(xmaddr_t machine)
+{
+	unsigned offset = machine.maddr & ~PAGE_MASK;
+	return XPADDR(PFN_PHYS((u64)mfn_to_pfn(PFN_DOWN(machine.maddr))) | offset);
+}
+
+/*
+ * We detect special mappings in one of two ways:
+ *  1. If the MFN is an I/O page then Xen will set the m2p entry
+ *     to be outside our maximum possible pseudophys range.
+ *  2. If the MFN belongs to a different domain then we will certainly
+ *     not have MFN in our p2m table. Conversely, if the page is ours,
+ *     then we'll have p2m(m2p(MFN))==MFN.
+ * If we detect a special mapping then it doesn't have a 'struct page'.
+ * We force !pfn_valid() by returning an out-of-range pointer.
+ *
+ * NB. These checks require that, for any MFN that is not in our reservation,
+ * there is no PFN such that p2m(PFN) == MFN. Otherwise we can get confused if
+ * we are foreign-mapping the MFN, and the other domain as m2p(MFN) == PFN.
+ * Yikes! Various places must poke in INVALID_P2M_ENTRY for safety.
+ *
+ * NB2. When deliberately mapping foreign pages into the p2m table, you *must*
+ *      use FOREIGN_FRAME(). This will cause pte_pfn() to choke on it, as we
+ *      require. In all the cases we care about, the FOREIGN_FRAME bit is
+ *      masked (e.g., pfn_to_mfn()) so behaviour there is correct.
+ */
+static inline unsigned long mfn_to_local_pfn(unsigned long mfn)
+{
+	extern unsigned long max_mapnr;
+	unsigned long pfn = mfn_to_pfn(mfn);
+	if ((pfn < max_mapnr)
+	    && !xen_feature(XENFEAT_auto_translated_physmap)
+	    && (phys_to_machine_mapping[pfn] != mfn))
+		return max_mapnr; /* force !pfn_valid() */
+	return pfn;
+}
+
+static inline void set_phys_to_machine(unsigned long pfn, unsigned long mfn)
+{
+	if (xen_feature(XENFEAT_auto_translated_physmap)) {
+		BUG_ON(pfn != mfn && mfn != INVALID_P2M_ENTRY);
+		return;
+	}
+	phys_to_machine_mapping[pfn] = mfn;
+}
+
+/* VIRT <-> MACHINE conversion */
+#define virt_to_machine(v)	(phys_to_machine(XPADDR(__pa(v))))
+#define virt_to_mfn(v)		(pfn_to_mfn(PFN_DOWN(__pa(v))))
+#define mfn_to_virt(m)		(__va(mfn_to_pfn(m) << PAGE_SHIFT))
+
+static inline unsigned long pte_mfn(pte_t pte)
+{
+	return (pte.pte & ~_PAGE_NX) >> PAGE_SHIFT;
+}
+
+static inline pte_t mfn_pte(unsigned long page_nr, pgprot_t pgprot)
+{
+	pte_t pte;
+
+	pte.pte = ((phys_addr_t)page_nr << PAGE_SHIFT) |
+		(pgprot_val(pgprot) & __supported_pte_mask);
+
+	return pte;
+}
+
+static inline pteval_t pte_val_ma(pte_t pte)
+{
+	return pte.pte;
+}
+
+static inline pte_t __pte_ma(pteval_t x)
+{
+	return (pte_t) { .pte = x };
+}
+
+#ifdef CONFIG_X86_PAE
+#define pmd_val_ma(v) ((v).pmd)
+#define pud_val_ma(v) ((v).pgd.pgd)
+#define __pmd_ma(x)	((pmd_t) { (x) } )
+#else  /* !X86_PAE */
+#define pmd_val_ma(v)	((v).pud.pgd.pgd)
+#endif	/* CONFIG_X86_PAE */
+
+#define pgd_val_ma(x)	((x).pgd)
+
+
+xmaddr_t arbitrary_virt_to_machine(unsigned long address);
+void make_lowmem_page_readonly(void *vaddr);
+void make_lowmem_page_readwrite(void *vaddr);
+
+#endif /* __XEN_PAGE_H */
diff --git a/include/xen/balloon.h b/include/xen/balloon.h
new file mode 100644
index 0000000..fe43b0f
--- /dev/null
+++ b/include/xen/balloon.h
@@ -0,0 +1,61 @@
+/******************************************************************************
+ * balloon.h
+ *
+ * Xen balloon driver - enables returning/claiming memory to/from Xen.
+ *
+ * Copyright (c) 2003, B Dragovic
+ * Copyright (c) 2003-2004, M Williamson, K Fraser
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation; or, when distributed
+ * separately from the Linux kernel or incorporated into other
+ * software packages, subject to the following license:
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this source file (the "Software"), to deal in the Software without
+ * restriction, including without limitation the rights to use, copy, modify,
+ * merge, publish, distribute, sublicense, and/or sell copies of the Software,
+ * and to permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
+ * IN THE SOFTWARE.
+ */
+
+#ifndef __XEN_BALLOON_H__
+#define __XEN_BALLOON_H__
+
+#include <linux/spinlock.h>
+
+#if 0
+/*
+ * Inform the balloon driver that it should allow some slop for device-driver
+ * memory activities.
+ */
+void balloon_update_driver_allowance(long delta);
+
+/* Allocate/free a set of empty pages in low memory (i.e., no RAM mapped). */
+struct page **alloc_empty_pages_and_pagevec(int nr_pages);
+void free_empty_pages_and_pagevec(struct page **pagevec, int nr_pages);
+
+void balloon_release_driver_page(struct page *page);
+
+/*
+ * Prevent the balloon driver from changing the memory reservation during
+ * a driver critical region.
+ */
+extern spinlock_t balloon_lock;
+#define balloon_lock(__flags)   spin_lock_irqsave(&balloon_lock, __flags)
+#define balloon_unlock(__flags) spin_unlock_irqrestore(&balloon_lock, __flags)
+#endif
+
+#endif /* __XEN_BALLOON_H__ */
diff --git a/include/xen/events.h b/include/xen/events.h
index 2bde54d..acd8e06 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -5,13 +5,7 @@
 
 #include <xen/interface/event_channel.h>
 #include <asm/xen/hypercall.h>
-
-enum ipi_vector {
-	XEN_RESCHEDULE_VECTOR,
-	XEN_CALL_FUNCTION_VECTOR,
-
-	XEN_NR_IPIS,
-};
+#include <asm/xen/events.h>
 
 int bind_evtchn_to_irq(unsigned int evtchn);
 int bind_evtchn_to_irqhandler(unsigned int evtchn,
@@ -37,6 +31,7 @@ int bind_ipi_to_irqhandler(enum ipi_vector ipi,
 void unbind_from_irqhandler(unsigned int irq, void *dev_id);
 
 void xen_send_IPI_one(unsigned int cpu, enum ipi_vector vector);
+int resend_irq_on_evtchn(unsigned int irq);
 
 static inline void notify_remote_via_evtchn(int port)
 {
diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
index 761c834..4662048 100644
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -39,6 +39,7 @@
 
 #include <asm/xen/hypervisor.h>
 #include <xen/interface/grant_table.h>
+#include <asm/xen/grant_table.h>
 
 /* NR_GRANT_FRAMES must be less than or equal to that configured in Xen */
 #define NR_GRANT_FRAMES 4
@@ -102,6 +103,12 @@ void gnttab_grant_foreign_access_ref(grant_ref_t ref, domid_t domid,
 void gnttab_grant_foreign_transfer_ref(grant_ref_t, domid_t domid,
 				       unsigned long pfn);
 
+int arch_gnttab_map_shared(unsigned long *frames, unsigned long nr_gframes,
+			   unsigned long max_nr_gframes,
+			   struct grant_entry **__shared);
+void arch_gnttab_unmap_shared(struct grant_entry *shared,
+			      unsigned long nr_gframes);
+
 #define gnttab_map_vaddr(map) ((void *)(map.host_virt_addr))
 
 #endif /* __ASM_GNTTAB_H__ */
diff --git a/include/xen/interface/callback.h b/include/xen/interface/callback.h
new file mode 100644
index 0000000..4aadcba
--- /dev/null
+++ b/include/xen/interface/callback.h
@@ -0,0 +1,102 @@
+/******************************************************************************
+ * callback.h
+ *
+ * Register guest OS callbacks with Xen.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this software and associated documentation files (the "Software"), to
+ * deal in the Software without restriction, including without limitation the
+ * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
+ * sell copies of the Software, and to permit persons to whom the Software is
+ * furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Copyright (c) 2006, Ian Campbell
+ */
+
+#ifndef __XEN_PUBLIC_CALLBACK_H__
+#define __XEN_PUBLIC_CALLBACK_H__
+
+#include "xen.h"
+
+/*
+ * Prototype for this hypercall is:
+ *   long callback_op(int cmd, void *extra_args)
+ * @cmd        == CALLBACKOP_??? (callback operation).
+ * @extra_args == Operation-specific extra arguments (NULL if none).
+ */
+
+/* ia64, x86: Callback for event delivery. */
+#define CALLBACKTYPE_event                 0
+
+/* x86: Failsafe callback when guest state cannot be restored by Xen. */
+#define CALLBACKTYPE_failsafe              1
+
+/* x86/64 hypervisor: Syscall by 64-bit guest app ('64-on-64-on-64'). */
+#define CALLBACKTYPE_syscall               2
+
+/*
+ * x86/32 hypervisor: Only available on x86/32 when supervisor_mode_kernel
+ *     feature is enabled. Do not use this callback type in new code.
+ */
+#define CALLBACKTYPE_sysenter_deprecated   3
+
+/* x86: Callback for NMI delivery. */
+#define CALLBACKTYPE_nmi                   4
+
+/*
+ * x86: sysenter is only available as follows:
+ * - 32-bit hypervisor: with the supervisor_mode_kernel feature enabled
+ * - 64-bit hypervisor: 32-bit guest applications on Intel CPUs
+ *                      ('32-on-32-on-64', '32-on-64-on-64')
+ *                      [nb. also 64-bit guest applications on Intel CPUs
+ *                           ('64-on-64-on-64'), but syscall is preferred]
+ */
+#define CALLBACKTYPE_sysenter              5
+
+/*
+ * x86/64 hypervisor: Syscall by 32-bit guest app on AMD CPUs
+ *                    ('32-on-32-on-64', '32-on-64-on-64')
+ */
+#define CALLBACKTYPE_syscall32             7
+
+/*
+ * Disable event deliver during callback? This flag is ignored for event and
+ * NMI callbacks: event delivery is unconditionally disabled.
+ */
+#define _CALLBACKF_mask_events             0
+#define CALLBACKF_mask_events              (1U << _CALLBACKF_mask_events)
+
+/*
+ * Register a callback.
+ */
+#define CALLBACKOP_register                0
+struct callback_register {
+    uint16_t type;
+    uint16_t flags;
+    struct xen_callback address;
+};
+
+/*
+ * Unregister a callback.
+ *
+ * Not all callbacks can be unregistered. -EINVAL will be returned if
+ * you attempt to unregister such a callback.
+ */
+#define CALLBACKOP_unregister              1
+struct callback_unregister {
+    uint16_t type;
+    uint16_t _unused;
+};
+
+#endif /* __XEN_PUBLIC_CALLBACK_H__ */
diff --git a/include/xen/interface/grant_table.h b/include/xen/interface/grant_table.h
index 2190498..39da93c 100644
--- a/include/xen/interface/grant_table.h
+++ b/include/xen/interface/grant_table.h
@@ -185,6 +185,7 @@ struct gnttab_map_grant_ref {
     grant_handle_t handle;
     uint64_t dev_bus_addr;
 };
+DEFINE_GUEST_HANDLE_STRUCT(gnttab_map_grant_ref);
 
 /*
  * GNTTABOP_unmap_grant_ref: Destroy one or more grant-reference mappings
@@ -206,6 +207,7 @@ struct gnttab_unmap_grant_ref {
     /* OUT parameters. */
     int16_t  status;              /* GNTST_* */
 };
+DEFINE_GUEST_HANDLE_STRUCT(gnttab_unmap_grant_ref);
 
 /*
  * GNTTABOP_setup_table: Set up a grant table for <dom> comprising at least
@@ -223,8 +225,9 @@ struct gnttab_setup_table {
     uint32_t nr_frames;
     /* OUT parameters. */
     int16_t  status;              /* GNTST_* */
-    ulong *frame_list;
+    GUEST_HANDLE(ulong) frame_list;
 };
+DEFINE_GUEST_HANDLE_STRUCT(gnttab_setup_table);
 
 /*
  * GNTTABOP_dump_table: Dump the contents of the grant table to the
@@ -237,6 +240,7 @@ struct gnttab_dump_table {
     /* OUT parameters. */
     int16_t status;               /* GNTST_* */
 };
+DEFINE_GUEST_HANDLE_STRUCT(gnttab_dump_table);
 
 /*
  * GNTTABOP_transfer_grant_ref: Transfer <frame> to a foreign domain. The
@@ -255,7 +259,7 @@ struct gnttab_transfer {
     /* OUT parameters. */
     int16_t       status;
 };
-
+DEFINE_GUEST_HANDLE_STRUCT(gnttab_transfer);
 
 /*
  * GNTTABOP_copy: Hypervisor based copy
@@ -296,6 +300,7 @@ struct gnttab_copy {
 	/* OUT parameters. */
 	int16_t       status;
 };
+DEFINE_GUEST_HANDLE_STRUCT(gnttab_copy);
 
 /*
  * GNTTABOP_query_size: Query the current and maximum sizes of the shared
@@ -313,7 +318,7 @@ struct gnttab_query_size {
     uint32_t max_nr_frames;
     int16_t  status;              /* GNTST_* */
 };
-
+DEFINE_GUEST_HANDLE_STRUCT(gnttab_query_size);
 
 /*
  * Bitfield values for update_pin_status.flags.
diff --git a/include/xen/interface/io/fbif.h b/include/xen/interface/io/fbif.h
new file mode 100644
index 0000000..5a934dd
--- /dev/null
+++ b/include/xen/interface/io/fbif.h
@@ -0,0 +1,124 @@
+/*
+ * fbif.h -- Xen virtual frame buffer device
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this software and associated documentation files (the "Software"), to
+ * deal in the Software without restriction, including without limitation the
+ * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
+ * sell copies of the Software, and to permit persons to whom the Software is
+ * furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Copyright (C) 2005 Anthony Liguori <aliguori@us.ibm.com>
+ * Copyright (C) 2006 Red Hat, Inc., Markus Armbruster <armbru@redhat.com>
+ */
+
+#ifndef __XEN_PUBLIC_IO_FBIF_H__
+#define __XEN_PUBLIC_IO_FBIF_H__
+
+/* Out events (frontend -> backend) */
+
+/*
+ * Out events may be sent only when requested by backend, and receipt
+ * of an unknown out event is an error.
+ */
+
+/* Event type 1 currently not used */
+/*
+ * Framebuffer update notification event
+ * Capable frontend sets feature-update in xenstore.
+ * Backend requests it by setting request-update in xenstore.
+ */
+#define XENFB_TYPE_UPDATE 2
+
+struct xenfb_update {
+	uint8_t type;		/* XENFB_TYPE_UPDATE */
+	int32_t x;		/* source x */
+	int32_t y;		/* source y */
+	int32_t width;		/* rect width */
+	int32_t height;		/* rect height */
+};
+
+#define XENFB_OUT_EVENT_SIZE 40
+
+union xenfb_out_event {
+	uint8_t type;
+	struct xenfb_update update;
+	char pad[XENFB_OUT_EVENT_SIZE];
+};
+
+/* In events (backend -> frontend) */
+
+/*
+ * Frontends should ignore unknown in events.
+ * No in events currently defined.
+ */
+
+#define XENFB_IN_EVENT_SIZE 40
+
+union xenfb_in_event {
+	uint8_t type;
+	char pad[XENFB_IN_EVENT_SIZE];
+};
+
+/* shared page */
+
+#define XENFB_IN_RING_SIZE 1024
+#define XENFB_IN_RING_LEN (XENFB_IN_RING_SIZE / XENFB_IN_EVENT_SIZE)
+#define XENFB_IN_RING_OFFS 1024
+#define XENFB_IN_RING(page) \
+	((union xenfb_in_event *)((char *)(page) + XENFB_IN_RING_OFFS))
+#define XENFB_IN_RING_REF(page, idx) \
+	(XENFB_IN_RING((page))[(idx) % XENFB_IN_RING_LEN])
+
+#define XENFB_OUT_RING_SIZE 2048
+#define XENFB_OUT_RING_LEN (XENFB_OUT_RING_SIZE / XENFB_OUT_EVENT_SIZE)
+#define XENFB_OUT_RING_OFFS (XENFB_IN_RING_OFFS + XENFB_IN_RING_SIZE)
+#define XENFB_OUT_RING(page) \
+	((union xenfb_out_event *)((char *)(page) + XENFB_OUT_RING_OFFS))
+#define XENFB_OUT_RING_REF(page, idx) \
+	(XENFB_OUT_RING((page))[(idx) % XENFB_OUT_RING_LEN])
+
+struct xenfb_page {
+	uint32_t in_cons, in_prod;
+	uint32_t out_cons, out_prod;
+
+	int32_t width;          /* width of the framebuffer (in pixels) */
+	int32_t height;         /* height of the framebuffer (in pixels) */
+	uint32_t line_length;   /* length of a row of pixels (in bytes) */
+	uint32_t mem_length;    /* length of the framebuffer (in bytes) */
+	uint8_t depth;          /* depth of a pixel (in bits) */
+
+	/*
+	 * Framebuffer page directory
+	 *
+	 * Each directory page holds PAGE_SIZE / sizeof(*pd)
+	 * framebuffer pages, and can thus map up to PAGE_SIZE *
+	 * PAGE_SIZE / sizeof(*pd) bytes.  With PAGE_SIZE == 4096 and
+	 * sizeof(unsigned long) == 4, that's 4 Megs.  Two directory
+	 * pages should be enough for a while.
+	 */
+	unsigned long pd[2];
+};
+
+/*
+ * Wart: xenkbd needs to know resolution.  Put it here until a better
+ * solution is found, but don't leak it to the backend.
+ */
+#ifdef __KERNEL__
+#define XENFB_WIDTH 800
+#define XENFB_HEIGHT 600
+#define XENFB_DEPTH 32
+#endif
+
+#endif
diff --git a/include/xen/interface/io/kbdif.h b/include/xen/interface/io/kbdif.h
new file mode 100644
index 0000000..fb97f42
--- /dev/null
+++ b/include/xen/interface/io/kbdif.h
@@ -0,0 +1,114 @@
+/*
+ * kbdif.h -- Xen virtual keyboard/mouse
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this software and associated documentation files (the "Software"), to
+ * deal in the Software without restriction, including without limitation the
+ * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
+ * sell copies of the Software, and to permit persons to whom the Software is
+ * furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Copyright (C) 2005 Anthony Liguori <aliguori@us.ibm.com>
+ * Copyright (C) 2006 Red Hat, Inc., Markus Armbruster <armbru@redhat.com>
+ */
+
+#ifndef __XEN_PUBLIC_IO_KBDIF_H__
+#define __XEN_PUBLIC_IO_KBDIF_H__
+
+/* In events (backend -> frontend) */
+
+/*
+ * Frontends should ignore unknown in events.
+ */
+
+/* Pointer movement event */
+#define XENKBD_TYPE_MOTION  1
+/* Event type 2 currently not used */
+/* Key event (includes pointer buttons) */
+#define XENKBD_TYPE_KEY     3
+/*
+ * Pointer position event
+ * Capable backend sets feature-abs-pointer in xenstore.
+ * Frontend requests ot instead of XENKBD_TYPE_MOTION by setting
+ * request-abs-update in xenstore.
+ */
+#define XENKBD_TYPE_POS     4
+
+struct xenkbd_motion {
+	uint8_t type;		/* XENKBD_TYPE_MOTION */
+	int32_t rel_x;		/* relative X motion */
+	int32_t rel_y;		/* relative Y motion */
+};
+
+struct xenkbd_key {
+	uint8_t type;		/* XENKBD_TYPE_KEY */
+	uint8_t pressed;	/* 1 if pressed; 0 otherwise */
+	uint32_t keycode;	/* KEY_* from linux/input.h */
+};
+
+struct xenkbd_position {
+	uint8_t type;		/* XENKBD_TYPE_POS */
+	int32_t abs_x;		/* absolute X position (in FB pixels) */
+	int32_t abs_y;		/* absolute Y position (in FB pixels) */
+};
+
+#define XENKBD_IN_EVENT_SIZE 40
+
+union xenkbd_in_event {
+	uint8_t type;
+	struct xenkbd_motion motion;
+	struct xenkbd_key key;
+	struct xenkbd_position pos;
+	char pad[XENKBD_IN_EVENT_SIZE];
+};
+
+/* Out events (frontend -> backend) */
+
+/*
+ * Out events may be sent only when requested by backend, and receipt
+ * of an unknown out event is an error.
+ * No out events currently defined.
+ */
+
+#define XENKBD_OUT_EVENT_SIZE 40
+
+union xenkbd_out_event {
+	uint8_t type;
+	char pad[XENKBD_OUT_EVENT_SIZE];
+};
+
+/* shared page */
+
+#define XENKBD_IN_RING_SIZE 2048
+#define XENKBD_IN_RING_LEN (XENKBD_IN_RING_SIZE / XENKBD_IN_EVENT_SIZE)
+#define XENKBD_IN_RING_OFFS 1024
+#define XENKBD_IN_RING(page) \
+	((union xenkbd_in_event *)((char *)(page) + XENKBD_IN_RING_OFFS))
+#define XENKBD_IN_RING_REF(page, idx) \
+	(XENKBD_IN_RING((page))[(idx) % XENKBD_IN_RING_LEN])
+
+#define XENKBD_OUT_RING_SIZE 1024
+#define XENKBD_OUT_RING_LEN (XENKBD_OUT_RING_SIZE / XENKBD_OUT_EVENT_SIZE)
+#define XENKBD_OUT_RING_OFFS (XENKBD_IN_RING_OFFS + XENKBD_IN_RING_SIZE)
+#define XENKBD_OUT_RING(page) \
+	((union xenkbd_out_event *)((char *)(page) + XENKBD_OUT_RING_OFFS))
+#define XENKBD_OUT_RING_REF(page, idx) \
+	(XENKBD_OUT_RING((page))[(idx) % XENKBD_OUT_RING_LEN])
+
+struct xenkbd_page {
+	uint32_t in_cons, in_prod;
+	uint32_t out_cons, out_prod;
+};
+
+#endif
diff --git a/include/xen/interface/io/protocols.h b/include/xen/interface/io/protocols.h
new file mode 100644
index 0000000..01fc8ae
--- /dev/null
+++ b/include/xen/interface/io/protocols.h
@@ -0,0 +1,21 @@
+#ifndef __XEN_PROTOCOLS_H__
+#define __XEN_PROTOCOLS_H__
+
+#define XEN_IO_PROTO_ABI_X86_32     "x86_32-abi"
+#define XEN_IO_PROTO_ABI_X86_64     "x86_64-abi"
+#define XEN_IO_PROTO_ABI_IA64       "ia64-abi"
+#define XEN_IO_PROTO_ABI_POWERPC64  "powerpc64-abi"
+
+#if defined(__i386__)
+# define XEN_IO_PROTO_ABI_NATIVE XEN_IO_PROTO_ABI_X86_32
+#elif defined(__x86_64__)
+# define XEN_IO_PROTO_ABI_NATIVE XEN_IO_PROTO_ABI_X86_64
+#elif defined(__ia64__)
+# define XEN_IO_PROTO_ABI_NATIVE XEN_IO_PROTO_ABI_IA64
+#elif defined(__powerpc64__)
+# define XEN_IO_PROTO_ABI_NATIVE XEN_IO_PROTO_ABI_POWERPC64
+#else
+# error arch fixup needed here
+#endif
+
+#endif
diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
index af36ead..da76846 100644
--- a/include/xen/interface/memory.h
+++ b/include/xen/interface/memory.h
@@ -29,7 +29,7 @@ struct xen_memory_reservation {
      *   OUT: GMFN bases of extents that were allocated
      *   (NB. This command also updates the mach_to_phys translation table)
      */
-    GUEST_HANDLE(ulong) extent_start;
+    ulong extent_start;
 
     /* Number of extents, and size/alignment of each (2^extent_order pages). */
     unsigned long  nr_extents;
@@ -50,7 +50,6 @@ struct xen_memory_reservation {
     domid_t        domid;
 
 };
-DEFINE_GUEST_HANDLE_STRUCT(xen_memory_reservation);
 
 /*
  * Returns the maximum machine frame number of mapped RAM in this system.
@@ -86,7 +85,7 @@ struct xen_machphys_mfn_list {
      * any large discontiguities in the machine address space, 2MB gaps in
      * the machphys table will be represented by an MFN base of zero.
      */
-    GUEST_HANDLE(ulong) extent_start;
+    ulong extent_start;
 
     /*
      * Number of extents written to the above array. This will be smaller
@@ -94,7 +93,6 @@ struct xen_machphys_mfn_list {
      */
     unsigned int nr_extents;
 };
-DEFINE_GUEST_HANDLE_STRUCT(xen_machphys_mfn_list);
 
 /*
  * Sets the GPFN at which a particular page appears in the specified guest's
@@ -117,7 +115,6 @@ struct xen_add_to_physmap {
     /* GPFN where the source mapping page should appear. */
     unsigned long gpfn;
 };
-DEFINE_GUEST_HANDLE_STRUCT(xen_add_to_physmap);
 
 /*
  * Translates a list of domain-specific GPFNs into MFNs. Returns a -ve error
@@ -132,14 +129,13 @@ struct xen_translate_gpfn_list {
     unsigned long nr_gpfns;
 
     /* List of GPFNs to translate. */
-    GUEST_HANDLE(ulong) gpfn_list;
+    ulong gpfn_list;
 
     /*
      * Output list to contain MFN translations. May be the same as the input
      * list (in which case each input GPFN is overwritten with the output MFN).
      */
-    GUEST_HANDLE(ulong) mfn_list;
+    ulong mfn_list;
 };
-DEFINE_GUEST_HANDLE_STRUCT(xen_translate_gpfn_list);
 
 #endif /* __XEN_PUBLIC_MEMORY_H__ */
diff --git a/include/xen/interface/vcpu.h b/include/xen/interface/vcpu.h
index b05d8a6..87e6f8a 100644
--- a/include/xen/interface/vcpu.h
+++ b/include/xen/interface/vcpu.h
@@ -85,6 +85,7 @@ struct vcpu_runstate_info {
 		 */
 		uint64_t time[4];
 };
+DEFINE_GUEST_HANDLE_STRUCT(vcpu_runstate_info);
 
 /* VCPU is currently running on a physical CPU. */
 #define RUNSTATE_running  0
@@ -119,6 +120,7 @@ struct vcpu_runstate_info {
 #define VCPUOP_register_runstate_memory_area 5
 struct vcpu_register_runstate_memory_area {
 		union {
+				GUEST_HANDLE(vcpu_runstate_info) h;
 				struct vcpu_runstate_info *v;
 				uint64_t p;
 		} addr;
@@ -134,6 +136,7 @@ struct vcpu_register_runstate_memory_area {
 struct vcpu_set_periodic_timer {
 		uint64_t period_ns;
 };
+DEFINE_GUEST_HANDLE_STRUCT(vcpu_set_periodic_timer);
 
 /*
  * Set or stop a VCPU's single-shot timer. Every VCPU has one single-shot
@@ -145,6 +148,7 @@ struct vcpu_set_singleshot_timer {
 		uint64_t timeout_abs_ns;
 		uint32_t flags;			   /* VCPU_SSHOTTMR_??? */
 };
+DEFINE_GUEST_HANDLE_STRUCT(vcpu_set_singleshot_timer);
 
 /* Flags to VCPUOP_set_singleshot_timer. */
  /* Require the timeout to be in the future (return -ETIME if it's passed). */
@@ -164,5 +168,6 @@ struct vcpu_register_vcpu_info {
     uint32_t offset; /* offset within page */
     uint32_t rsvd;   /* unused */
 };
+DEFINE_GUEST_HANDLE_STRUCT(vcpu_register_vcpu_info);
 
 #endif /* __XEN_PUBLIC_VCPU_H__ */
diff --git a/include/xen/interface/xen.h b/include/xen/interface/xen.h
index 518a5bf..9b018da 100644
--- a/include/xen/interface/xen.h
+++ b/include/xen/interface/xen.h
@@ -58,6 +58,16 @@
 #define __HYPERVISOR_physdev_op           33
 #define __HYPERVISOR_hvm_op               34
 
+/* Architecture-specific hypercall definitions. */
+#define __HYPERVISOR_arch_0               48
+#define __HYPERVISOR_arch_1               49
+#define __HYPERVISOR_arch_2               50
+#define __HYPERVISOR_arch_3               51
+#define __HYPERVISOR_arch_4               52
+#define __HYPERVISOR_arch_5               53
+#define __HYPERVISOR_arch_6               54
+#define __HYPERVISOR_arch_7               55
+
 /*
  * VIRTUAL INTERRUPTS
  *
@@ -68,8 +78,18 @@
 #define VIRQ_CONSOLE    2  /* (DOM0) Bytes received on emergency console. */
 #define VIRQ_DOM_EXC    3  /* (DOM0) Exceptional event for some domain.   */
 #define VIRQ_DEBUGGER   6  /* (DOM0) A domain has paused for debugging.   */
-#define NR_VIRQS        8
 
+/* Architecture-specific VIRQ definitions. */
+#define VIRQ_ARCH_0    16
+#define VIRQ_ARCH_1    17
+#define VIRQ_ARCH_2    18
+#define VIRQ_ARCH_3    19
+#define VIRQ_ARCH_4    20
+#define VIRQ_ARCH_5    21
+#define VIRQ_ARCH_6    22
+#define VIRQ_ARCH_7    23
+
+#define NR_VIRQS       24
 /*
  * MMU-UPDATE REQUESTS
  *
diff --git a/include/xen/interface/xencomm.h b/include/xen/interface/xencomm.h
new file mode 100644
index 0000000..ac45e07
--- /dev/null
+++ b/include/xen/interface/xencomm.h
@@ -0,0 +1,41 @@
+/*
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this software and associated documentation files (the "Software"), to
+ * deal in the Software without restriction, including without limitation the
+ * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
+ * sell copies of the Software, and to permit persons to whom the Software is
+ * furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Copyright (C) IBM Corp. 2006
+ */
+
+#ifndef _XEN_XENCOMM_H_
+#define _XEN_XENCOMM_H_
+
+/* A xencomm descriptor is a scatter/gather list containing physical
+ * addresses corresponding to a virtually contiguous memory area. The
+ * hypervisor translates these physical addresses to machine addresses to copy
+ * to and from the virtually contiguous area.
+ */
+
+#define XENCOMM_MAGIC 0x58434F4D /* 'XCOM' */
+#define XENCOMM_INVALID (~0UL)
+
+struct xencomm_desc {
+    uint32_t magic;
+    uint32_t nr_addrs; /* the number of entries in address[] */
+    uint64_t address[0];
+};
+
+#endif /* _XEN_XENCOMM_H_ */
diff --git a/include/xen/page.h b/include/xen/page.h
index 031ef22..eaf85fa 100644
--- a/include/xen/page.h
+++ b/include/xen/page.h
@@ -1,180 +1 @@
-#ifndef __XEN_PAGE_H
-#define __XEN_PAGE_H
-
-#include <linux/pfn.h>
-
-#include <asm/uaccess.h>
-#include <asm/pgtable.h>
-
-#include <xen/features.h>
-
-#ifdef CONFIG_X86_PAE
-/* Xen machine address */
-typedef struct xmaddr {
-	unsigned long long maddr;
-} xmaddr_t;
-
-/* Xen pseudo-physical address */
-typedef struct xpaddr {
-	unsigned long long paddr;
-} xpaddr_t;
-#else
-/* Xen machine address */
-typedef struct xmaddr {
-	unsigned long maddr;
-} xmaddr_t;
-
-/* Xen pseudo-physical address */
-typedef struct xpaddr {
-	unsigned long paddr;
-} xpaddr_t;
-#endif
-
-#define XMADDR(x)	((xmaddr_t) { .maddr = (x) })
-#define XPADDR(x)	((xpaddr_t) { .paddr = (x) })
-
-/**** MACHINE <-> PHYSICAL CONVERSION MACROS ****/
-#define INVALID_P2M_ENTRY	(~0UL)
-#define FOREIGN_FRAME_BIT	(1UL<<31)
-#define FOREIGN_FRAME(m)	((m) | FOREIGN_FRAME_BIT)
-
-extern unsigned long *phys_to_machine_mapping;
-
-static inline unsigned long pfn_to_mfn(unsigned long pfn)
-{
-	if (xen_feature(XENFEAT_auto_translated_physmap))
-		return pfn;
-
-	return phys_to_machine_mapping[(unsigned int)(pfn)] &
-		~FOREIGN_FRAME_BIT;
-}
-
-static inline int phys_to_machine_mapping_valid(unsigned long pfn)
-{
-	if (xen_feature(XENFEAT_auto_translated_physmap))
-		return 1;
-
-	return (phys_to_machine_mapping[pfn] != INVALID_P2M_ENTRY);
-}
-
-static inline unsigned long mfn_to_pfn(unsigned long mfn)
-{
-	unsigned long pfn;
-
-	if (xen_feature(XENFEAT_auto_translated_physmap))
-		return mfn;
-
-#if 0
-	if (unlikely((mfn >> machine_to_phys_order) != 0))
-		return max_mapnr;
-#endif
-
-	pfn = 0;
-	/*
-	 * The array access can fail (e.g., device space beyond end of RAM).
-	 * In such cases it doesn't matter what we return (we return garbage),
-	 * but we must handle the fault without crashing!
-	 */
-	__get_user(pfn, &machine_to_phys_mapping[mfn]);
-
-	return pfn;
-}
-
-static inline xmaddr_t phys_to_machine(xpaddr_t phys)
-{
-	unsigned offset = phys.paddr & ~PAGE_MASK;
-	return XMADDR(PFN_PHYS((u64)pfn_to_mfn(PFN_DOWN(phys.paddr))) | offset);
-}
-
-static inline xpaddr_t machine_to_phys(xmaddr_t machine)
-{
-	unsigned offset = machine.maddr & ~PAGE_MASK;
-	return XPADDR(PFN_PHYS((u64)mfn_to_pfn(PFN_DOWN(machine.maddr))) | offset);
-}
-
-/*
- * We detect special mappings in one of two ways:
- *  1. If the MFN is an I/O page then Xen will set the m2p entry
- *     to be outside our maximum possible pseudophys range.
- *  2. If the MFN belongs to a different domain then we will certainly
- *     not have MFN in our p2m table. Conversely, if the page is ours,
- *     then we'll have p2m(m2p(MFN))==MFN.
- * If we detect a special mapping then it doesn't have a 'struct page'.
- * We force !pfn_valid() by returning an out-of-range pointer.
- *
- * NB. These checks require that, for any MFN that is not in our reservation,
- * there is no PFN such that p2m(PFN) == MFN. Otherwise we can get confused if
- * we are foreign-mapping the MFN, and the other domain as m2p(MFN) == PFN.
- * Yikes! Various places must poke in INVALID_P2M_ENTRY for safety.
- *
- * NB2. When deliberately mapping foreign pages into the p2m table, you *must*
- *      use FOREIGN_FRAME(). This will cause pte_pfn() to choke on it, as we
- *      require. In all the cases we care about, the FOREIGN_FRAME bit is
- *      masked (e.g., pfn_to_mfn()) so behaviour there is correct.
- */
-static inline unsigned long mfn_to_local_pfn(unsigned long mfn)
-{
-	extern unsigned long max_mapnr;
-	unsigned long pfn = mfn_to_pfn(mfn);
-	if ((pfn < max_mapnr)
-	    && !xen_feature(XENFEAT_auto_translated_physmap)
-	    && (phys_to_machine_mapping[pfn] != mfn))
-		return max_mapnr; /* force !pfn_valid() */
-	return pfn;
-}
-
-static inline void set_phys_to_machine(unsigned long pfn, unsigned long mfn)
-{
-	if (xen_feature(XENFEAT_auto_translated_physmap)) {
-		BUG_ON(pfn != mfn && mfn != INVALID_P2M_ENTRY);
-		return;
-	}
-	phys_to_machine_mapping[pfn] = mfn;
-}
-
-/* VIRT <-> MACHINE conversion */
-#define virt_to_machine(v)	(phys_to_machine(XPADDR(__pa(v))))
-#define virt_to_mfn(v)		(pfn_to_mfn(PFN_DOWN(__pa(v))))
-#define mfn_to_virt(m)		(__va(mfn_to_pfn(m) << PAGE_SHIFT))
-
-#ifdef CONFIG_X86_PAE
-#define pte_mfn(_pte) (((_pte).pte_low >> PAGE_SHIFT) |			\
-		       (((_pte).pte_high & 0xfff) << (32-PAGE_SHIFT)))
-
-static inline pte_t mfn_pte(unsigned long page_nr, pgprot_t pgprot)
-{
-	pte_t pte;
-
-	pte.pte_high = (page_nr >> (32 - PAGE_SHIFT)) |
-		(pgprot_val(pgprot) >> 32);
-	pte.pte_high &= (__supported_pte_mask >> 32);
-	pte.pte_low = ((page_nr << PAGE_SHIFT) | pgprot_val(pgprot));
-	pte.pte_low &= __supported_pte_mask;
-
-	return pte;
-}
-
-static inline unsigned long long pte_val_ma(pte_t x)
-{
-	return x.pte;
-}
-#define pmd_val_ma(v) ((v).pmd)
-#define pud_val_ma(v) ((v).pgd.pgd)
-#define __pte_ma(x)	((pte_t) { .pte = (x) })
-#define __pmd_ma(x)	((pmd_t) { (x) } )
-#else  /* !X86_PAE */
-#define pte_mfn(_pte) ((_pte).pte_low >> PAGE_SHIFT)
-#define mfn_pte(pfn, prot)	__pte_ma(((pfn) << PAGE_SHIFT) | pgprot_val(prot))
-#define pte_val_ma(x)	((x).pte)
-#define pmd_val_ma(v)	((v).pud.pgd.pgd)
-#define __pte_ma(x)	((pte_t) { (x) } )
-#endif	/* CONFIG_X86_PAE */
-
-#define pgd_val_ma(x)	((x).pgd)
-
-
-xmaddr_t arbitrary_virt_to_machine(unsigned long address);
-void make_lowmem_page_readonly(void *vaddr);
-void make_lowmem_page_readwrite(void *vaddr);
-
-#endif /* __XEN_PAGE_H */
+#include <asm/xen/page.h>
diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
new file mode 100644
index 0000000..10ddfe0
--- /dev/null
+++ b/include/xen/xen-ops.h
@@ -0,0 +1,8 @@
+#ifndef INCLUDE_XEN_OPS_H
+#define INCLUDE_XEN_OPS_H
+
+#include <linux/percpu.h>
+
+DECLARE_PER_CPU(struct vcpu_info *, xen_vcpu);
+
+#endif /* INCLUDE_XEN_OPS_H */
diff --git a/include/xen/xenbus.h b/include/xen/xenbus.h
index 6f7c290..6369d89 100644
--- a/include/xen/xenbus.h
+++ b/include/xen/xenbus.h
@@ -97,6 +97,7 @@ struct xenbus_driver {
 	int (*uevent)(struct xenbus_device *, char **, int, char *, int);
 	struct device_driver driver;
 	int (*read_otherend_details)(struct xenbus_device *dev);
+	int (*is_ready)(struct xenbus_device *dev);
 };
 
 static inline struct xenbus_driver *to_xenbus_driver(struct device_driver *drv)
diff --git a/include/xen/xencomm.h b/include/xen/xencomm.h
new file mode 100644
index 0000000..e43b039
--- /dev/null
+++ b/include/xen/xencomm.h
@@ -0,0 +1,77 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ * Copyright (C) IBM Corp. 2006
+ *
+ * Authors: Hollis Blanchard <hollisb@us.ibm.com>
+ *          Jerone Young <jyoung5@us.ibm.com>
+ */
+
+#ifndef _LINUX_XENCOMM_H_
+#define _LINUX_XENCOMM_H_
+
+#include <xen/interface/xencomm.h>
+
+#define XENCOMM_MINI_ADDRS 3
+struct xencomm_mini {
+	struct xencomm_desc _desc;
+	uint64_t address[XENCOMM_MINI_ADDRS];
+};
+
+/* To avoid additionnal virt to phys conversion, an opaque structure is
+   presented.  */
+struct xencomm_handle;
+
+extern void xencomm_free(struct xencomm_handle *desc);
+extern struct xencomm_handle *xencomm_map(void *ptr, unsigned long bytes);
+extern struct xencomm_handle *__xencomm_map_no_alloc(void *ptr,
+			unsigned long bytes,  struct xencomm_mini *xc_area);
+
+#if 0
+#define XENCOMM_MINI_ALIGNED(xc_desc, n)				\
+	struct xencomm_mini xc_desc ## _base[(n)]			\
+	__attribute__((__aligned__(sizeof(struct xencomm_mini))));	\
+	struct xencomm_mini *xc_desc = &xc_desc ## _base[0];
+#else
+/*
+ * gcc bug workaround:
+ * http://gcc.gnu.org/bugzilla/show_bug.cgi?id=16660
+ * gcc doesn't handle properly stack variable with
+ * __attribute__((__align__(sizeof(struct xencomm_mini))))
+ */
+#define XENCOMM_MINI_ALIGNED(xc_desc, n)				\
+	unsigned char xc_desc ## _base[((n) + 1 ) *			\
+				       sizeof(struct xencomm_mini)];	\
+	struct xencomm_mini *xc_desc = (struct xencomm_mini *)		\
+		((unsigned long)xc_desc ## _base +			\
+		 (sizeof(struct xencomm_mini) -				\
+		  ((unsigned long)xc_desc ## _base) %			\
+		  sizeof(struct xencomm_mini)));
+#endif
+#define xencomm_map_no_alloc(ptr, bytes)			\
+	({ XENCOMM_MINI_ALIGNED(xc_desc, 1);			\
+		__xencomm_map_no_alloc(ptr, bytes, xc_desc); })
+
+/* provided by architecture code: */
+extern unsigned long xencomm_vtop(unsigned long vaddr);
+
+static inline void *xencomm_pa(void *ptr)
+{
+	return (void *)xencomm_vtop((unsigned long)ptr);
+}
+
+#define xen_guest_handle(hnd)  ((hnd).p)
+
+#endif /* _LINUX_XENCOMM_H_ */

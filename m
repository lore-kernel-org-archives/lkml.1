Return-Path: <linux-kernel-owner+w=401wt.eu-S1763426AbYA3RS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763426AbYA3RS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 12:18:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762777AbYA3RSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 12:18:47 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:53515
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551AbYA3RSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 12:18:45 -0500
From: Avi Kivity <avi@qumranet.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [GIT PULL] KVM updates for the 2.6.25 merge window
Date: Wed, 30 Jan 2008 19:18:43 +0200
Message-Id: <1201713523-7456-1-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the kvm updates for 2.6.25 from the repo and branch at:

  git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git for-linus

Changes include performance and scalability improvements, completion
of the portability work (though no new architectures are supported
with this submission), support for new hardware features, using
general userspace memory for kvm (which enables swapping guest memory
as well as sharing memory among guests), as well as the usual
cleanups and incremental fixes.

Amit Shah (1):
      KVM: Make unloading of FPU state when putting vcpu arch-independent

Anthony Liguori (6):
      KVM: x86 emulator: Add vmmcall/vmcall to x86_emulate (v3)
      KVM: Refactor hypercall infrastructure (v3)
      KVM: MMU: Clean up MMU functions to take struct kvm when appropriate
      KVM: MMU: More struct kvm_vcpu -> struct kvm cleanups
      KVM: Allocate userspace memory for older userspace
      KVM: Fix gfn_to_page() acquiring mmap_sem twice

Avi Kivity (91):
      KVM: VMX: Further reduce efer reloads
      KVM: Allow not-present guest page faults to bypass kvm
      KVM: MMU: Make flooding detection work when guest page faults are bypassed
      KVM: VMX: Don't clear the vmcs if the vcpu is not loaded on any processor
      KVM: VMX: Simplify vcpu_clear()
      KVM: Move guest pte dirty bit management to the guest pagetable walker
      KVM: MMU: Fix nx access bit for huge pages
      KVM: MMU: Disable write access on clean large pages
      KVM: MMU: Instantiate real-mode shadows as user writable shadows
      KVM: MMU: Move dirty bit updates to a separate function
      KVM: MMU: When updating the dirty bit, inform the mmu about it
      KVM: Move apic timer interrupt backlog processing to common code
      KVM: Rename KVM_TLB_FLUSH to KVM_REQ_TLB_FLUSH
      KVM: MMU: Simplify page table walker
      KVM: Move vmx_vcpu_reset() out of vmx_vcpu_setup()
      KVM: Add a might_sleep() annotation to gfn_to_page()
      KVM: x86 emulator: don't depend on cr2 for mov abs emulation
      KVM: Move page fault processing to common code
      KVM: MMU: Topup the mmu memory preallocation caches before emulating an insn
      KVM: x86 emulator: Extract the common code of SrcReg and DstReg
      KVM: x86 emulator: centralize decoding of one-byte register access insns
      KVM: Simplify decode_register_operand() calling convention
      KVM: x86 emulator: Hoist modrm and abs decoding into separate functions
      KVM: VMX: Use vmx to inject real-mode interrupts
      KVM: VMX: Read & store IDT_VECTORING_INFO_FIELD
      KVM: Fix faults during injection of real-mode interrupts
      KVM: Simplify CPU_TASKS_FROZEN cpu notifier handling
      KVM: VMX: Consolidate register usage in vmx_vcpu_run()
      KVM: Replace 'light_exits' stat with 'host_state_reload'
      KVM: Add fpu_reload counter
      KVM: Add instruction emulation statistics
      KVM: Extend stats support for VM stats
      KVM: MMU: Add some mmu statistics
      KVM: MMU: Remove unused variable
      KVM: Export include/asm-x86/kvm.h
      KVM: x86 emulator: retire ->write_std()
      KVM: x86 emulator: prefetch up to 15 bytes of the instruction executed
      KVM: Split vcpu creation to avoid vcpu_load() before preemption setup
      KVM: MMU: Implement guest page fault bypass for nonpae
      KVM: Add statistic for remote tlb flushes
      KVM: MMU: Avoid unnecessary remote tlb flushes when guest updates a pte
      KVM: Don't bother the mmu if cr3 load doesn't change cr3
      KVM: MMU: Introduce and use gpte_to_gfn()
      KVM: MMU: Move pse36 handling to the guest walker
      KVM: MMU: Remove extra gaddr parameter from set_pte_common()
      KVM: MMU: Remove set_pde()
      KVM: MMU: Merge set_pte() and set_pte_common()
      KVM: MMU: Adjust page_header_update_slot() to accept a gfn instead of a gpa
      KVM: MMU: Introduce gfn_to_gpa()
      KVM: MMU: Simplify nonpaging_map()
      KVM: MMU: Remove gva_to_hpa()
      KVM: Remove gpa_to_hpa()
      KVM: MMU: Rename variables of type 'struct kvm_mmu_page *'
      KVM: MMU: Rename 'release_page'
      KVM: Disallow fork() and similar games when using a VM
      KVM: x86 emulator: address size and operand size overrides are sticky
      KVM: Remove misleading check for mmio during event injection
      KVM: x86 emulator: Move rep processing before instruction execution
      KVM: x86 emulator: unify two switches
      KVM: x86 emulator: unify four switch statements into two
      KVM: Export include/linux/kvm.h only if $ARCH actually supports KVM
      KVM: Generalize exception injection mechanism
      KVM: Replace page fault injection by the generalized exception queue
      KVM: Replace #GP injection by the generalized exception queue
      KVM: Use generalized exception queue for injecting #UD
      KVM: x86 emulator: fix eflags preparation for emulation
      KVM: VMX: Avoid exit when setting cr8 if the local apic is in the kernel
      KVM: x86 emulator: Fix stack instructions on 64-bit mode
      KVM: SVM: Trap access to the cr8 register
      KVM: MMU: Simplify calculation of pte access
      KVM: MMU: Set nx bit correctly on shadow ptes
      KVM: MMU: Move pte access calculation into a helper function
      KVM: MMU: Fix inherited permissions for emulated guest pte updates
      KVM: MMU: No need to pick up nx bit from guest pte
      KVM: MMU: Pass pte dirty flag to set_pte() instead of calculating it on-site
      KVM: MMU: Remove walker argument to set_pte()
      KVM: MMU: Move set_pte() into guest paging mode independent code
      KVM: MMU: Adjust mmu_set_spte() debug code for gpte removal
      KVM: MMU: Use mmu_set_spte() for real-mode shadows
      KVM: Move arch dependent files to new directory arch/x86/kvm/
      KVM: Move drivers/kvm/* to virt/kvm/
      KVM: MMU: Add cache miss statistic
      KVM: Print data for unimplemented wrmsr
      KVM: local APIC TPR access reporting facility
      KVM: Accelerated apic support
      KVM: Disable vapic support on Intel machines with FlexPriority
      KVM: MMU: Avoid calling gfn_to_page() in mmu_set_spte()
      KVM: MMU: Move kvm_free_some_pages() into critical section
      KVM: Initialize the mmu caches only after verifying cpu support
      KVM: Fix unbounded preemption latency
      KVM: Move apic timer migration away from critical section

Carlo Marcelo Arenas Belon (1):
      KVM: SVM: Remove KVM specific defines for MSR_EFER

Carsten Otte (9):
      KVM: Move x86 msr handling to new files x86.[ch]
      KVM: Portability: split kvm_vcpu_ioctl
      KVM: Portability: Split kvm_vm_ioctl v3
      KVM: Portability: Move memory segmentation to x86.c
      KVM: Portability: move get/set_apic_base to x86.c
      KVM: Portability: Move control register helper functions to x86.c
      KVM: Portability: Move kvm_get/set_msr[_common] to x86.c
      KVM: Portability: Move x86 emulation and mmio device hook to x86.c
      KVM: Portability: Move pio emulation functions to x86.c

Christian Borntraeger (2):
      KVM: Use virtual cpu accounting if available for guest times.
      KVM: Per-architecture hypercall definitions

Christian Ehrhardt (1):
      KVM: Portability: Move kvm_fpu to asm-x86/kvm.h

Dan Kenigsberg (1):
      KVM: Enhance guest cpuid management

Dong, Eddie (1):
      KVM: MMU: Merge shadow level check in FNAME(fetch)

Dor Laor (1):
      KVM: Add make_page_dirty() to kvm_clear_guest_page()

Eddie Dong (5):
      KVM: Export PIC reset for kernel device reset
      KVM: Split IOAPIC reset function and export for kernel RESET
      KVM: VMX: Comment VMX primary/secondary exec ctl definitions
      KVM: VMX: wbinvd exiting
      KVM: MMU: Coalesce remote tlb flushes

Glauber de Oliveira Costa (1):
      KVM: Put kvm_para.h include outside __KERNEL__

Guillaume Thouvenin (2):
      KVM: x86 emulator: Make a distinction between repeat prefixes F3 and F2
      KVM: x86 emulator: cmps instruction

Hollis Blanchard (11):
      KVM: Portability: Make exported debugfs data architecture-specific
      KVM: Portability: Move x86 instruction emulation code to x86.c
      KVM: Portability: Move x86 FPU handling to x86.c
      KVM: Portability: Move x86 vcpu ioctl handlers to x86.c
      KVM: Remove unused "rmap_overflow" variable
      KVM: Correct consistent typo: "destory" -> "destroy"
      KVM: Move misplaced comment
      KVM: Portability: Move address types to their own header file
      KVM: Portability: Move IO device definitions to its own header file
      KVM: Portability: Stop including x86-specific headers in kvm_main.c
      KVM: Portability: Create kvm_arch_vcpu_runnable() function

Izik Eidus (23):
      KVM: Remove the usage of page->private field by rmap
      KVM: Add general accessors to read and write guest memory
      KVM: Allow dynamic allocation of the mmu shadow cache size
      KVM: Support assigning userspace memory to the guest
      KVM: MMU: Add rmap_next(), a helper for walking kvm rmaps
      KVM: MMU: Keep a reverse mapping of non-writable translations
      KVM: MMU: Make gfn_to_page() always safe
      KVM: MMU: Partial swapping of guest memory
      KVM: Unmap kernel-allocated memory on slot destruction
      KVM: Export memory slot allocation mechanism
      KVM: Add kernel-internal memory slots
      KVM: Add ioctl to tss address from userspace,
      KVM: x86 emulator: remove 8 bytes operands emulator for call near instruction
      KVM: add kvm_is_error_hva()
      KVM: introduce gfn_to_hva()
      KVM: Change kvm_{read,write}_guest() to use copy_{from,to}_user()
      KVM: MMU: Change guest pte access to kvm_{read,write}_guest()
      KVM: Simplify kvm_clear_guest_page()
      KVM: MMU: Fix potential memory leak with smp real-mode
      KVM: MMU: Selectively set PageDirty when releasing guest memory
      KVM: MMU: Code cleanup
      KVM: MMU: mark pages that were inserted to the shadow pages table as accessed
      KVM: MMU: Fix dirty page setting for pages removed from rmap

Jan Kiszka (1):
      KVM: VMX: Force seg.base == (seg.sel << 4) in real  mode

Jerone Young (8):
      KVM: Portability: Move kvm_memory_alias to asm/kvm.h
      KVM: Portability: Move x86 pic strutctures
      KVM: Portability: Move kvm_regs to <asm/kvm.h>
      KVM: Portability: Move structure lapic_state to <asm/kvm.h>
      KVM: Portability: Move kvm_segment & kvm_dtable structure to  <asm/kvm.h>
      KVM: Portability: Move kvm_sregs and msr structures to <asm/kvm.h>
      KVM: Portability: Move cpuid structures to <asm/kvm.h>
      KVM: Add ifdef in irqchip struct for x86 only structures

Joe Perches (1):
      KVM: Remove ptr comparisons to 0

Joerg Roedel (4):
      KVM: SVM: Emulate read/write access to cr8
      KVM: SVM: Exit to userspace if write to cr8 and not using in-kernel apic
      KVM: LAPIC: minor debugging compile fix
      KVM: SVM: support writing 0 to K8 performance counter control registers

Laurent Vivier (15):
      KVM: x86 emulator: remove unused functions
      KVM: x86 emulator: move all x86_emulate_memop() to a structure
      KVM: x86 emulator: move all decoding process to function x86_decode_insn()
      KVM: emulate_instruction() calls now x86_decode_insn() and x86_emulate_insn()
      KVM: Call x86_decode_insn() only when needed
      KVM: x86 emulator: split some decoding into functions for readability
      KVM: x86 emulator: remove _eflags and use directly ctxt->eflags.
      KVM: x86 emulator: Remove no_wb, use dst.type = OP_NONE instead
      KVM: Purify x86_decode_insn() error case management
      KVM: x86 emulator: Any legacy prefix after a REX prefix nullifies its effect
      KVM: Add some \n in ioapic_debug()
      KVM: VMX: Let gcc to choose which registers to save (x86_64)
      KVM: VMX: Let gcc to choose which registers to save (i386)
      KVM: SVM: Let gcc to choose which registers to save (x86_64)
      KVM: SVM: Let gcc to choose which registers to save (i386)

Marcelo Tosatti (7):
      KVM: MMU: Remove unused prev_shadow_ent variable from fetch()
      KVM: MMU: Use cmpxchg for pte updates on walk_addr()
      KVM: MMU: Fix SMP shadow instantiation race
      KVM: MMU: emulated cmpxchg8b should be atomic on i386
      KVM: MMU: Concurrent guest walkers
      KVM: Add kvm_read_guest_atomic()
      KVM: MMU: Switch to mmu spinlock

Mike Day (1):
      KVM: CodingStyle cleanup

Nitin A Kamble (2):
      KVM: x86 emulator: Implement emulation of instruction: inc & dec
      KVM: x86 emulator: cmc, clc, cli, sti

Qing He (2):
      KVM: x86_emulator: no writeback for bt
      KVM: apic round robin cleanup

Rusty Russell (3):
      KVM: Add kvm_free_lapic() to pair with kvm_create_lapic()
      KVM: Hoist kvm_create_lapic() into kvm_vcpu_init()
      KVM: Remove gratuitous casts from lapic.c

Ryan Harper (2):
      KVM: MMU: Ignore reserved bits in cr3 in non-pae mode
      KVM: VMX: Add printk_ratelimit in vmx_intr_assist

Sheng Yang (5):
      KVM: VMX: Enable memory mapped TPR shadow (FlexPriority)
      KVM: x86 emulator: modify 'lods', and 'stos' not to depend on CR2
      KVM: VMX: Remove the secondary execute control dependency on irqchip
      KVM: x86 emulator: Rename 'cr2' to 'memop'
      KVM: x86 emulator: Only allow VMCALL/VMMCALL trapped by #UD

Uri Lublin (1):
      KVM: Make mark_page_dirty() work for aliased pages too.

Zhang Xiantao (40):
      KVM: Portability: Split kvm_vcpu into arch dependent and independent parts (part 1)
      KVM: Portability: Move some includes to x86.c
      KVM: Portability: Move kvm_x86_ops to x86.c
      KVM: Portability: Add vcpu and hardware management arch hooks
      KVM: Portability: Combine kvm_init and kvm_init_x86
      KVM: Portability: Move x86 specific code from kvm_init() to kvm_arch()
      KVM: Portability: move KVM_CHECK_EXTENSION
      KVM: Portability: Make kvm_vcpu_ioctl_translate arch dependent
      KVM: Remove __init attributes for kvm_init_debug and kvm_init_msr_list
      KVM: Portability: Add two hooks to handle kvm_create and destroy vm
      KVM: Portability: Move kvm_vcpu_ioctl_get_dirty_log to arch-specific  file
      KVM: Portability: MMU initialization and teardown split
      KVM: Portability: Move some macro definitions from kvm.h to x86.h
      KVM: Portability: Move struct kvm_x86_ops definition to x86.h
      KVM: Portability: Move vcpu regs enumeration definition to x86.h
      KVM: Move some static inline functions out from kvm.h into x86.h
      KVM: Portability: Move some function declarations to x86.h
      KVM: Recalculate mmu pages needed for every memory region change
      KVM: Portability:  Split kvm_set_memory_region() to have an arch callout
      KVM: Portability: Move unalias_gfn to arch dependent file
      KVM: Portability: Move KVM_INTERRUPT vcpu ioctl to x86.c
      KVM: Correct kvm_init() error paths not freeing bad_pge.
      KVM: Replace kvm_lapic with kvm_vcpu in ioapic/lapic interface
      KVM: Replace dest_Lowest_Prio and dest_Fixed with self-defined macros
      KVM: Extend ioapic code to support iosapic
      KVM: Portability: Move kvm{pic,ioapic} accesors to x86 specific code
      KVM: Portability: Introduce kvm_vcpu_arch
      KVM: Portability: Split mmu-related static inline functions to mmu.h
      KVM: Portability: Move kvm_vcpu definition back to kvm.h
      KVM: Portability: Expand the KVM_VCPU_COMM in kvm_vcpu structure.
      KVM: Portability: Move kvm_vcpu_stat to x86.h
      KVM: Portability: Move memslot aliases to new struct kvm_arch
      KVM: Portability: Move mmu-related fields to kvm_arch
      KVM: Portability: move vpic and vioapic to kvm_arch
      KVM: Portability: Move round_robin_prev_vcpu and tss_addr to kvm_arch
      KVM: Portability: Move kvm_vm_stat to x86.h
      KVM: Move irqchip declarations into new ioapic.h and lapic.h
      KVM: Move ioapic code to common directory.
      KVM: Move kvm_vcpu_kick() to x86.c
      KVM: Expose ioapic to ia64 save/restore APIs

npiggin@suse.de (1):
      KVM: Convert KVM from ->nopage() to ->fault()

 arch/x86/Kconfig                                   |    3 +
 arch/x86/Makefile                                  |    2 +
 {drivers => arch/x86}/kvm/Kconfig                  |    7 +-
 {drivers => arch/x86}/kvm/Makefile                 |    6 +-
 {drivers => arch/x86}/kvm/i8259.c                  |    8 +-
 {drivers => arch/x86}/kvm/irq.c                    |   22 +-
 arch/x86/kvm/irq.h                                 |   88 +
 {drivers => arch/x86}/kvm/kvm_svm.h                |    2 +-
 {drivers => arch/x86}/kvm/lapic.c                  |  216 +-
 arch/x86/kvm/lapic.h                               |   50 +
 arch/x86/kvm/mmu.c                                 | 1885 +++++++++
 arch/x86/kvm/mmu.h                                 |   44 +
 arch/x86/kvm/paging_tmpl.h                         |  484 +++
 arch/x86/kvm/segment_descriptor.h                  |   29 +
 {drivers => arch/x86}/kvm/svm.c                    |  353 +-
 {drivers => arch/x86}/kvm/svm.h                    |    3 +-
 {drivers => arch/x86}/kvm/vmx.c                    | 1079 +++---
 {drivers => arch/x86}/kvm/vmx.h                    |   26 +-
 drivers/kvm/kvm_main.c => arch/x86/kvm/x86.c       | 4243 +++++++++-----------
 arch/x86/kvm/x86_emulate.c                         | 1912 +++++++++
 drivers/Kconfig                                    |    2 -
 drivers/Makefile                                   |    1 -
 drivers/kvm/irq.h                                  |  165 -
 drivers/kvm/mmu.c                                  | 1498 -------
 drivers/kvm/paging_tmpl.h                          |  511 ---
 drivers/kvm/segment_descriptor.h                   |   17 -
 drivers/kvm/x86_emulate.c                          | 1662 --------
 include/asm-x86/Kbuild                             |    1 +
 include/asm-x86/kvm.h                              |  191 +
 drivers/kvm/kvm.h => include/asm-x86/kvm_host.h    |  537 +--
 include/asm-x86/kvm_para.h                         |  105 +
 .../asm-x86/kvm_x86_emulate.h                      |   69 +-
 include/linux/Kbuild                               |    2 +-
 include/linux/kvm.h                                |  203 +-
 include/linux/kvm_host.h                           |  299 ++
 include/linux/kvm_para.h                           |   82 +-
 include/linux/kvm_types.h                          |   54 +
 kernel/fork.c                                      |    1 +
 {drivers => virt}/kvm/ioapic.c                     |   99 +-
 virt/kvm/ioapic.h                                  |   95 +
 virt/kvm/iodev.h                                   |   63 +
 virt/kvm/kvm_main.c                                | 1400 +++++++
 42 files changed, 9955 insertions(+), 7564 deletions(-)
 rename {drivers => arch/x86}/kvm/Kconfig (94%)
 rename {drivers => arch/x86}/kvm/Makefile (51%)
 rename {drivers => arch/x86}/kvm/i8259.c (98%)
 rename {drivers => arch/x86}/kvm/irq.c (81%)
 create mode 100644 arch/x86/kvm/irq.h
 rename {drivers => arch/x86}/kvm/kvm_svm.h (96%)
 rename {drivers => arch/x86}/kvm/lapic.c (83%)
 create mode 100644 arch/x86/kvm/lapic.h
 create mode 100644 arch/x86/kvm/mmu.c
 create mode 100644 arch/x86/kvm/mmu.h
 create mode 100644 arch/x86/kvm/paging_tmpl.h
 create mode 100644 arch/x86/kvm/segment_descriptor.h
 rename {drivers => arch/x86}/kvm/svm.c (84%)
 rename {drivers => arch/x86}/kvm/svm.h (98%)
 rename {drivers => arch/x86}/kvm/vmx.c (75%)
 rename {drivers => arch/x86}/kvm/vmx.h (96%)
 rename drivers/kvm/kvm_main.c => arch/x86/kvm/x86.c (52%)
 create mode 100644 arch/x86/kvm/x86_emulate.c
 delete mode 100644 drivers/kvm/irq.h
 delete mode 100644 drivers/kvm/mmu.c
 delete mode 100644 drivers/kvm/paging_tmpl.h
 delete mode 100644 drivers/kvm/segment_descriptor.h
 delete mode 100644 drivers/kvm/x86_emulate.c
 create mode 100644 include/asm-x86/kvm.h
 rename drivers/kvm/kvm.h => include/asm-x86/kvm_host.h (64%)
 create mode 100644 include/asm-x86/kvm_para.h
 rename drivers/kvm/x86_emulate.h => include/asm-x86/kvm_x86_emulate.h (83%)
 create mode 100644 include/linux/kvm_host.h
 create mode 100644 include/linux/kvm_types.h
 rename {drivers => virt}/kvm/ioapic.c (83%)
 create mode 100644 virt/kvm/ioapic.h
 create mode 100644 virt/kvm/iodev.h
 create mode 100644 virt/kvm/kvm_main.c



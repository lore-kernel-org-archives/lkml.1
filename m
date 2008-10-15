Return-Path: <linux-kernel-owner+w=401wt.eu-S1754995AbYJONbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995AbYJONbW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 09:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbYJONbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 09:31:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55700 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754204AbYJONbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 09:31:02 -0400
From: Avi Kivity <avi@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] KVM updates for Linux 2.6.28
Date: Wed, 15 Oct 2008 15:30:54 +0200
Message-Id: <1224077454-9734-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git kvm-updates/2.6.28

to receive the kvm updates for the 2.6.28 merge window.  Changes include
performance improvement, pci device assignment, and improved emulation
accuracy.

Alexander Graf (1):
      KVM: Ignore DEBUGCTL MSRs with no effect

Amit Shah (5):
      KVM: Introduce kvm_set_irq to inject interrupts in guests
      KVM: Device assignment: Check for privileges before assigning irq
      KVM: SVM: Fix typo
      KVM: Use kvm_set_irq to inject interrupts
      KVM: Device Assignment: Free device structures if IRQ allocation fails

Avi Kivity (36):
      KVM: MMU: Separate the code for unlinking a shadow page from its parents
      KVM: MMU: Simplify kvm_mmu_zap_page()
      KVM: Move NMI IRET fault processing to new vmx_complete_interrupts()
      KVM: VMX: Move nmi injection failure processing to vm exit path
      KVM: Clear exception queue before emulating an instruction
      KVM: VMX: Fix pending exception processing
      KVM: Add a pending interrupt queue
      KVM: VMX: Move interrupt post-processing to vmx_complete_interrupts()
      KVM: Consolidate PIC isr clearing into a function
      KVM: VMX: Unify register save/restore across 32 and 64 bit hosts
      KVM: SVM: Unify register save/restore across 32 and 64 bit hosts
      KVM: VMX: Avoid vmwrite(HOST_RSP) when possible
      KVM: Add irq ack notifier list
      KVM: VMX: Use interrupt queue for !irqchip_in_kernel
      KVM: Simplify exception entries by using __ASM_SIZE and _ASM_PTR
      KVM: Handle spurious acks for PIT interrupts
      KVM: VMX: Change cs reset state to be a data segment
      KVM: VMX: Change segment dpl at reset to 3
      KVM: Load real mode segments correctly
      KVM: x86 emulator: remove bad ByteOp specifier from NEG descriptor
      KVM: MMU: Move SHADOW_PT_INDEX to mmu.c
      KVM: MMU: Unify direct map 4K and large page paths
      KVM: MMU: Infer shadow root level in direct_map()
      KVM: MMU: Add generic shadow walker
      KVM: MMU: Convert direct maps to use the generic shadow walker
      KVM: MMU: Convert the paging mode shadow walk to use the generic walker
      KVM: Allocate guest memory as MAP_PRIVATE, not MAP_SHARED
      KVM: Don't call get_user_pages(.force = 1)
      KVM: MMU: Account for npt/ept/realmode page faults
      KVM: MMU: Add locking around kvm_mmu_slot_remove_write_access()
      KVM: MMU: Flush tlbs after clearing write permission when accessing dirty log
      KVM: MMU: Fix setting the accessed bit on non-speculative sptes
      KVM: SVM: No need to unprotect memory during event injection when using npt
      KVM: Add statistics for guest irq injections
      KVM: x86 emulator: fix jmp r/m64 instruction
      MAINTAINERS: Update Avi Kivity's email address

Ben-Ami Yassour (4):
      KVM: direct mmio pfn check
      KVM: pci device assignment
      KVM: remove unused field from the assigned dev struct
      KVM: Device Assignment with VT-d

Christian Borntraeger (2):
      KVM: s390: Make facility bits future-proof
      KVM: s390: change help text of guest Kconfig

Christian Ehrhardt (3):
      KVM: kvmtrace: Remove use of bit fields in kvm trace structure
      KVM: kvmtrace: replace get_cycles with ktime_get v3
      KVM: ppc: trace powerpc instruction emulation

Dave Hansen (4):
      KVM: Reduce kvm stack usage in kvm_arch_vm_ioctl()
      KVM: Reduce stack usage in kvm_vcpu_ioctl()
      KVM: Reduce stack usage in kvm_arch_vcpu_ioctl()
      KVM: Reduce stack usage in kvm_pv_mmu_op()

Glauber Costa (3):
      x86: paravirt: factor out cpu_khz to common code
      x86: KVM guest: use paravirt function to calculate cpu khz
      KVM: Don't destroy vcpu in case vcpu_setup fails

Gleb Natapov (1):
      KVM: don't enter guest after SIPI was received by a CPU

Guillaume Thouvenin (3):
      KVM: x86 emulator: Add DstAcc operand type
      KVM: x86 emulator: Add cmp al, imm and cmp ax, imm instructions (ocodes 3c, 3d)
      KVM: x86 emulator: Use DstAcc for 'and'

Harvey Harrison (3):
      KVM: make irq ack notifier functions static
      KVM: x86.c make kvm_load_realmode_segment static
      x86: pvclock: fix shadowed variable warning

Hollis Blanchard (6):
      KVM: Move KVM TRACE DEFINITIONS to common header
      KVM: ppc: guest breakpoint support
      KVM: ppc: Stop saving host TLB state
      KVM: ppc: Write only modified shadow entries into the TLB on exit
      KVM: powerpc: Map guest userspace with TID=0 mappings
      KVM: ppc: kvmppc_44x_shadow_release() does not require mmap_sem to be locked

Jan Kiszka (4):
      KVM: Consolidate XX_VECTOR defines
      KVM: VMX: Reinject real mode exception
      KVM: VMX: Cleanup stalled INTR_INFO read
      KVM: x86: Silence various LAPIC-related host kernel messages

Jerone Young (2):
      KVM: ppc: enable KVM_TRACE building for powerpc
      KVM: ppc: adds trace points for ppc tlb activity

Joerg Roedel (2):
      KVM: add MC5_MISC msr read support
      MAINTAINERS: add entry for the KVM AMD module

Kay, Allen M (1):
      VT-d: Changes to support KVM

Marcelo Tosatti (24):
      KVM: x86: accessors for guest registers
      KVM: irq ack notification
      KVM: PIT: fix injection logic and count
      KVM: set debug registers after "schedulable" section
      KVM: fix i8259 reset irq acking
      KVM: x86: do not execute halted vcpus
      KVM: x86: unhalt vcpu0 on reset
      KVM: opencode gfn_to_page in kvm_vm_fault
      KVM: switch to get_user_pages_fast
      KVM: MMU: flush remote TLBs on large->normal entry overwrite
      KVM: MMU: split mmu_set_spte
      KVM: MMU: move local TLB flush to mmu_set_spte
      KVM: MMU: do not write-protect large mappings
      KVM: MMU: mode specific sync_page
      KVM: MMU: sync roots on mmu reload
      KVM: x86: trap invlpg
      KVM: MMU: mmu_parent_walk
      KVM: MMU: awareness of new kvm_mmu_zap_page behaviour
      KVM: MMU: mmu_convert_notrap helper
      KVM: MMU: out of sync shadow core
      KVM: MMU: speed up mmu_unsync_walk
      KVM: MMU: add "oos_shadow" parameter to disable oos
      KVM: PIC: enhance IPI avoidance
      KVM: VMX: enable invlpg exiting if EPT is disabled

Mohammed Gamal (9):
      KVM: VMX: Remove redundant check in handle_rmode_exception
      KVM: VMX: Add Guest State Validity Checks
      KVM: VMX: Add module parameter and emulation flag.
      KVM: VMX: Add invalid guest state handler
      KVM: VMX: Modify mode switching and vmentry functions
      KVM: x86 emulator: Add mov r, imm instructions (opcodes 0xb0-0xbf)
      KVM: x86 emulator: Add std and cld instructions (opcodes 0xfc-0xfd)
      KVM: x86 emulator: Add in/out instructions (opcodes 0xe4-0xe7, 0xec-0xef)
      KVM: x86 emulator: Add call near absolute instruction (opcode 0xff/2)

Sheng Yang (5):
      KVM: VMX: Rename misnamed msr bits
      KVM: VMX: Clean up magic number 0x66 in init_rmode_tss
      KVM: MMU: Modify kvm_shadow_walk.entry to accept u64 addr
      KVM: VMX: Rename IA32_FEATURE_CONTROL bits
      x86: Move FEATURE_CONTROL bits to msr-index.h

Weidong Han (2):
      KVM: Remove useless intel-iommu.h header inclusion
      KVM: Device Assignment: Map mmio pages into VT-d page table

Xiantao Zhang (12):
      KVM: ia64: add a dummy irq ack notification
      KVM: ia64: Enable virtio driver for ia64 in Kconfig
      KVM: ia64: Implement kvm_arch_vcpu_ioctl_{set,get}_mpstate
      KVM: ia64: Implement a uniform vps interface
      KVM: ia64: add support for Tukwila processors
      KVM: Move device assignment logic to common code
      KVM: Change is_mmio_pfn to kvm_is_mmio_pfn, and make it common for all archs
      KVM: Separate irq ack notification out of arch/x86/kvm/irq.c
      KVM: Move irqchip_in_kernel() from ioapic.h to irq.h
      KVM: ia64: Make pmt table be able to hold physical mmio entries.
      KVM: ia64: add directed mmio range support for kvm guests
      KVM: ia64: Add intel iommu support for guests.

Zhang xiantao (1):
      KVM: Device Assignment: Move vtd.c from arch/x86/kvm/ to virt/kvm/

roel kluin (1):
      KVM: x86 emulator: remove duplicate SrcImm

 MAINTAINERS                                    |    9 +-
 arch/ia64/include/asm/kvm_host.h               |    6 +-
 arch/ia64/kvm/Kconfig                          |    2 +
 arch/ia64/kvm/Makefile                         |    6 +-
 arch/ia64/kvm/irq.h                            |   31 +
 arch/ia64/kvm/kvm-ia64.c                       |   66 ++-
 arch/ia64/kvm/kvm_minstate.h                   |   23 +-
 arch/ia64/kvm/optvfault.S                      |  181 ++++++-
 arch/ia64/kvm/process.c                        |    4 +-
 arch/ia64/kvm/vcpu.h                           |   26 +-
 arch/ia64/kvm/vmm_ivt.S                        |   39 +--
 arch/ia64/kvm/vtlb.c                           |   23 +-
 arch/powerpc/include/asm/kvm_host.h            |   14 +-
 arch/powerpc/include/asm/kvm_ppc.h             |   12 +
 arch/powerpc/kernel/asm-offsets.c              |    4 +-
 arch/powerpc/kvm/44x_tlb.c                     |   53 ++-
 arch/powerpc/kvm/Kconfig                       |   11 +
 arch/powerpc/kvm/Makefile                      |    6 +-
 arch/powerpc/kvm/booke_guest.c                 |   17 +
 arch/powerpc/kvm/booke_interrupts.S            |   79 ++--
 arch/powerpc/kvm/emulate.c                     |    8 +-
 arch/powerpc/kvm/powerpc.c                     |   99 ++++-
 arch/s390/Kconfig                              |    7 +-
 arch/s390/kvm/priv.c                           |    4 +-
 arch/x86/kernel/kvmclock.c                     |   30 +
 arch/x86/kernel/pvclock.c                      |   12 +
 arch/x86/kvm/Makefile                          |    5 +-
 arch/x86/kvm/i8254.c                           |   81 ++--
 arch/x86/kvm/i8254.h                           |    7 +-
 arch/x86/kvm/i8259.c                           |   53 ++-
 arch/x86/kvm/irq.c                             |    3 +-
 arch/x86/kvm/irq.h                             |    6 +-
 arch/x86/kvm/kvm_cache_regs.h                  |   32 ++
 arch/x86/kvm/lapic.c                           |   43 +-
 arch/x86/kvm/mmu.c                             |  680 ++++++++++++++++++-----
 arch/x86/kvm/paging_tmpl.h                     |  249 ++++++---
 arch/x86/kvm/svm.c                             |  156 +++---
 arch/x86/kvm/vmx.c                             |  712 ++++++++++++++++--------
 arch/x86/kvm/vmx.h                             |    3 -
 arch/x86/kvm/x86.c                             |  552 +++++++++++--------
 arch/x86/kvm/x86.h                             |   22 +
 arch/x86/kvm/x86_emulate.c                     |  170 ++++--
 arch/x86/xen/time.c                            |   11 +-
 drivers/pci/dmar.c                             |    4 +-
 drivers/pci/intel-iommu.c                      |  116 ++++-
 drivers/pci/intr_remapping.c                   |    2 +-
 drivers/pci/intr_remapping.h                   |    2 +-
 drivers/pci/iova.c                             |    2 +-
 include/asm-x86/kvm.h                          |   22 -
 include/asm-x86/kvm_host.h                     |   82 ++--
 include/asm-x86/msr-index.h                    |    3 +
 include/asm-x86/pvclock.h                      |    1 +
 {drivers/pci => include/linux}/dma_remapping.h |    0
 {drivers/pci => include/linux}/intel-iommu.h   |   24 +-
 {drivers/pci => include/linux}/iova.h          |    0
 include/linux/kvm.h                            |   72 +++-
 include/linux/kvm_host.h                       |   82 +++
 virt/kvm/ioapic.c                              |   22 +-
 virt/kvm/ioapic.h                              |   10 +-
 virt/kvm/irq_comm.c                            |   60 ++
 virt/kvm/kvm_main.c                            |  382 +++++++++++--
 virt/kvm/kvm_trace.c                           |   30 +-
 virt/kvm/vtd.c                                 |  191 +++++++
 63 files changed, 3432 insertions(+), 1232 deletions(-)
 create mode 100644 arch/ia64/kvm/irq.h
 create mode 100644 arch/x86/kvm/kvm_cache_regs.h
 create mode 100644 arch/x86/kvm/x86.h
 rename {drivers/pci => include/linux}/dma_remapping.h (100%)
 rename {drivers/pci => include/linux}/intel-iommu.h (92%)
 rename {drivers/pci => include/linux}/iova.h (100%)
 create mode 100644 virt/kvm/irq_comm.c
 create mode 100644 virt/kvm/vtd.c

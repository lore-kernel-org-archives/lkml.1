Return-Path: <linux-kernel-owner+w=401wt.eu-S1756697AbZAAJ7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbZAAJ7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 04:59:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755744AbZAAJ7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 04:59:41 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58219 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755708AbZAAJ7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 04:59:38 -0500
From: Avi Kivity <avi@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM updates for 2.6.29-rc
Date: Thu,  1 Jan 2009 11:59:30 +0200
Message-Id: <1230803970-21513-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git kvm-updates/2.6.29

for the 2.6.29 cycle KVM updates.  These include improved NMI support,
emulator improvements, better integration with kdump and emergency reboot,
MTRR support, MSI for assigned devices, some MMU performance optimizations,
arch updates, and random fixes.

Amit Shah (4):
      KVM: x86: Fix typo in function name
      KVM: SVM: Set the 'g' bit of the cs selector for cross-vendor migration
      KVM: SVM: Set the 'busy' flag of the TR selector
      KVM: x86 emulator: Fix handling of VMMCALL instruction

Avi Kivity (13):
      KVM: VMX: Conditionally request interrupt window after injecting irq
      KVM: x86 emulator: reduce duplication in one operand emulation thunks
      KVM: x86 emulator: consolidate emulation of two operand instructions
      KVM: x86 emulator: Extract 'pop' sequence into a function
      KVM: x86 emulator: allow pop from mmio
      KVM: x86 emulator: switch 'pop reg' instruction to emulate_pop()
      KVM: x86 emulator: fix ret emulation
      KVM: x86 emulator: fix popf emulation
      KVM: Remove extraneous semicolon after do/while
      KVM: Advertise the bug in memory region destruction as fixed
      KVM: Consolidate userspace memory capability reporting into common code
      KVM: MMU: Don't treat a global pte as such if cr4.pge is cleared
      KVM: Add locking to virtual i8259 interrupt controller

Christian Borntraeger (4):
      KVM: s390: Fix refcounting and allow module unload
      KVM: s390: Fix memory leak of vcpu->run
      anon_inodes: use fops->owner for module refcount
      KVM: set owner of cpu and vm file operations

Eduardo Habkost (13):
      KVM: VMX: move vmx.h to include/asm
      KVM: SVM: move svm.h to include/asm
      KVM: VMX: move ASM_VMX_* definitions from asm/kvm_host.h to asm/vmx.h
      KVM: VMX: move cpu_has_kvm_support() to an inline on asm/virtext.h
      x86: asm/virtext.h: add cpu_vmxoff() inline function
      KVM: VMX: extract kvm_cpu_vmxoff() from hardware_disable()
      x86: cpu_emergency_vmxoff() function
      KVM: SVM: move has_svm() code to asm/virtext.h
      KVM: SVM: move svm_hardware_disable() code to asm/virtext.h
      x86: cpu_emergency_svm_disable() function
      kdump: forcibly disable VMX and SVM on machine_crash_shutdown()
      x86: disable VMX on all CPUs on reboot
      x86: KVM guest: kvm_get_tsc_khz: return khz, not lpj

Glauber Costa (2):
      x86: KVM guest: sign kvmclock as paravirt
      KVM: Really remove a slot when a user ask us so

Gleb Natapov (1):
      KVM: call kvm_arch_vcpu_reset() instead of the kvm_x86_ops callback

Guillaume Thouvenin (9):
      KVM: x86 emulator: consolidate push reg
      KVM: x86 emulator: Add decode entries for 0x04 and 0x05 opcodes (add acc, imm)
      KVM: allow emulator to adjust rip for emulated pio instructions
      KVM: VMX: Handle mmio emulation when guest state is invalid
      KVM: x86 emulator: Extend the opcode descriptor
      KVM: x86 emulator: add Src2 decode set
      KVM: x86 emulator: add a new "implied 1" Src decode type
      KVM: x86 emulator: add the assembler code for three operands
      KVM: x86 emulator: add the emulation of shld and shrd instructions

Hannes Eder (2):
      KVM: fix sparse warning
      KVM: VMX: fix sparse warning

Hollis Blanchard (25):
      KVM: ppc: Move 440-specific TLB code into 44x_tlb.c
      KVM: ppc: Rename "struct tlbe" to "struct kvmppc_44x_tlbe"
      KVM: ppc: combine booke_guest.c and booke_host.c
      KVM: ppc: Refactor powerpc.c to relocate 440-specific code
      ppc: Create disassemble.h to extract instruction fields
      KVM: ppc: refactor instruction emulation into generic and core-specific pieces
      KVM: ppc: Move the last bits of 44x code out of booke.c
      KVM: ppc: create struct kvm_vcpu_44x and introduce container_of() accessor
      KVM: ppc: adjust vcpu types to support 64-bit cores
      KVM: ppc: fix set regs to take care of msr change
      KVM: ppc: optimize kvm stat handling
      KVM: ppc: optimize find first bit
      KVM: ppc: optimize irq delivery path
      KVM: ppc: improve trap emulation
      KVM: ensure that memslot userspace addresses are page-aligned
      KVM: ppc: fix Kconfig constraints
      KVM: ppc: use MMUCR accessor to obtain TID
      KVM: ppc: use prefetchable mappings for guest memory
      KVM: ppc: fix userspace mapping invalidation on context switch
      KVM: ppc: support large host pages
      powerpc/44x: declare tlb_44x_index for use in C code
      KVM: ppc: directly insert shadow mappings into the hardware TLB
      KVM: ppc: save and restore guest mappings on context switch
      KVM: ppc: Implement in-kernel exit timing statistics
      KVM: ppc: mostly cosmetic updates to the exit timing accounting code

Izik Eidus (1):
      KVM: MMU: Fix aliased gfns treated as unaliased

Jan Kiszka (17):
      KVM: VMX: include all IRQ window exits in statistics
      KVM: VMX: Use INTR_TYPE_NMI_INTR instead of magic value
      KVM: VMX: Support for NMI task gates
      KVM: x86: Reset pending/inject NMI state on CPU reset
      KVM: VMX: refactor/fix IRQ and NMI injectability determination
      KVM: VMX: refactor IRQ and NMI window enabling
      KVM: VMX: fix real-mode NMI support
      KVM: x86: Enable NMI Watchdog via in-kernel PIT source
      KVM: x86: VCPU with pending NMI is runnabled
      KVM: Kick NMI receiving VCPU
      KVM: x86: Support for user space injected NMIs
      KVM: VMX: Provide support for user space injected NMIs
      KVM: VMX: work around lacking VNMI support
      KVM: x86: Fix and refactor NMI watchdog emulation
      KVM: x86: Optimize NMI watchdog delivery
      KVM: VMX: Fix pending NMI-vs.-IRQ race for user space irqchip
      KVM: x86: Rework user space NMI injection as KVM_CAP_USER_NMI

Jes Sorensen (1):
      KVM: ia64: Fix kvm_arch_vcpu_ioctl_[gs]et_regs()

Marcelo Tosatti (7):
      KVM: MMU: optimize set_spte for page sync
      KVM: MMU: use page array in unsync walk
      KVM: MMU: collapse remote TLB flushes on root sync
      KVM: MMU: skip global pgtables on sync due to cr3 switch
      KVM: MMU: prepopulate the shadow on invlpg
      KVM: MMU: check for present pdptr shadow page in walk_shadow
      KVM: MMU: handle large host sptes on invlpg/resync

Mark McLoughlin (6):
      KVM: remove the IRQ ACK notifier assertions
      KVM: make kvm_unregister_irq_ack_notifier() safe
      KVM: don't free an unallocated irq source id
      KVM: add KVM_USERSPACE_IRQ_SOURCE_ID assertions
      KVM: split out kvm_free_assigned_irq()
      KVM: fix handling of ACK from shared guest IRQ

Nitin A Kamble (2):
      KVM: Fix cpuid leaf 0xb loop termination
      KVM: Fix cpuid iteration on multiple leaves per eac

Rusty Russell (3):
      KVM: Extract core of kvm_flush_remote_tlbs/kvm_reload_remote_mmus
      KVM: use modern cpumask primitives, no cpumask_t on stack
      KVM: use cpumask_var_t for cpus_hardware_enabled

Sheng Yang (21):
      x86: Rename mtrr_state struct and macro names
      x86: Export some definition of MTRR
      KVM: Improve MTRR structure
      KVM: VMX: Add PAT support for EPT
      KVM: Add local get_mtrr_type() to support MTRR
      KVM: Enable MTRR for EPT
      KVM: Clean up kvm_x86_emulate.h
      KVM: MMU: Extend kvm_mmu_page->slot_bitmap size
      KVM: VMX: Move private memory slot position
      KVM: IRQ ACK notifier should be used with in-kernel irqchip
      KVM: Enable Function Level Reset for assigned device
      KVM: Fix kernel allocated memory slot
      KVM: Move ack notifier register and IRQ sourcd ID request
      KVM: Separate update irq to a single function
      KVM: Replace irq_requested with more generic irq_requested_type
      KVM: Clean up assigned_device_update_irq
      KVM: Add fields for MSI device assignment
      KVM: Export ioapic_get_delivery_bitmask
      KVM: Add assigned_device_msi_dispatch()
      KVM: Enable MSI for device assignment
      KVM: MSI to INTx translate

Wu Fengguang (1):
      KVM: Prevent trace call into unloaded module text

Xiantao Zhang (8):
      KVM: ia64: Re-organize data sturure of guests' data area
      KVM: ia64: Remove lock held by halted vcpu
      KVM: ia64: Remove some macro definitions in asm-offsets.c.
      KVM: ia64: Define printk function for kvm-intel module
      KVM: ia64: Add some debug points to provide crash infomation
      KVM: ia64: Add handler for crashed vmm
      KVM: ia64: Clean up vmm_ivt.S using tab to indent every line
      MAINTAINERS: Maintainership changes for kvm/ia64

 MAINTAINERS                                 |    2 -
 arch/ia64/include/asm/kvm.h                 |    6 +-
 arch/ia64/include/asm/kvm_host.h            |  196 +++--
 arch/ia64/kvm/Makefile                      |    2 +-
 arch/ia64/kvm/asm-offsets.c                 |   11 +-
 arch/ia64/kvm/kvm-ia64.c                    |  107 +--
 arch/ia64/kvm/kvm_lib.c                     |   15 +
 arch/ia64/kvm/kvm_minstate.h                |    4 +-
 arch/ia64/kvm/misc.h                        |    3 +-
 arch/ia64/kvm/mmio.c                        |   38 +-
 arch/ia64/kvm/process.c                     |   29 +-
 arch/ia64/kvm/vcpu.c                        |   76 ++-
 arch/ia64/kvm/vcpu.h                        |    5 +-
 arch/ia64/kvm/vmm.c                         |   29 +
 arch/ia64/kvm/vmm_ivt.S                     | 1469 +++++++++++++--------------
 arch/ia64/kvm/vtlb.c                        |    4 +-
 arch/powerpc/include/asm/disassemble.h      |   80 ++
 arch/powerpc/include/asm/kvm_44x.h          |   61 ++
 arch/powerpc/include/asm/kvm_host.h         |  116 ++-
 arch/powerpc/include/asm/kvm_ppc.h          |   83 +-
 arch/powerpc/include/asm/mmu-44x.h          |    1 +
 arch/powerpc/kernel/asm-offsets.c           |   21 +-
 arch/powerpc/kvm/44x.c                      |  228 +++++
 arch/powerpc/kvm/44x_emulate.c              |  371 +++++++
 arch/powerpc/kvm/44x_tlb.c                  |  463 +++++++--
 arch/powerpc/kvm/44x_tlb.h                  |   26 +-
 arch/powerpc/kvm/Kconfig                    |   28 +-
 arch/powerpc/kvm/Makefile                   |   12 +-
 arch/powerpc/kvm/{booke_guest.c => booke.c} |  418 ++++-----
 arch/powerpc/kvm/booke.h                    |   60 ++
 arch/powerpc/kvm/booke_host.c               |   83 --
 arch/powerpc/kvm/booke_interrupts.S         |   72 +-
 arch/powerpc/kvm/emulate.c                  |  447 +--------
 arch/powerpc/kvm/powerpc.c                  |  130 +---
 arch/powerpc/kvm/timing.c                   |  239 +++++
 arch/powerpc/kvm/timing.h                   |  102 ++
 arch/s390/kvm/kvm-s390.c                    |   41 +-
 arch/x86/include/asm/kvm_host.h             |   45 +-
 arch/x86/include/asm/kvm_x86_emulate.h      |   11 +-
 arch/x86/include/asm/mtrr.h                 |   25 +
 arch/x86/{kvm => include/asm}/svm.h         |    0
 arch/x86/include/asm/virtext.h              |  132 +++
 arch/x86/{kvm => include/asm}/vmx.h         |   27 +-
 arch/x86/kernel/cpu/mtrr/generic.c          |   12 +-
 arch/x86/kernel/cpu/mtrr/main.c             |    4 +-
 arch/x86/kernel/cpu/mtrr/mtrr.h             |   18 +-
 arch/x86/kernel/crash.c                     |   18 +
 arch/x86/kernel/kvmclock.c                  |   10 +-
 arch/x86/kernel/reboot.c                    |   62 ++-
 arch/x86/kvm/i8254.c                        |   19 +
 arch/x86/kvm/i8259.c                        |   52 +-
 arch/x86/kvm/irq.h                          |    6 +
 arch/x86/kvm/kvm_svm.h                      |    2 +-
 arch/x86/kvm/lapic.c                        |   58 +-
 arch/x86/kvm/mmu.c                          |  444 +++++++--
 arch/x86/kvm/paging_tmpl.h                  |   44 +-
 arch/x86/kvm/svm.c                          |   48 +-
 arch/x86/kvm/vmx.c                          |  350 +++++---
 arch/x86/kvm/x86.c                          |  117 ++-
 arch/x86/kvm/x86_emulate.c                  |  297 ++++---
 fs/anon_inodes.c                            |    7 +-
 include/linux/kvm.h                         |   18 +
 include/linux/kvm_host.h                    |   12 +-
 virt/kvm/ioapic.c                           |    8 +-
 virt/kvm/ioapic.h                           |    2 +
 virt/kvm/irq_comm.c                         |   19 +-
 virt/kvm/kvm_main.c                         |  420 ++++++--
 virt/kvm/kvm_trace.c                        |    1 +
 68 files changed, 4760 insertions(+), 2606 deletions(-)
 create mode 100644 arch/ia64/kvm/kvm_lib.c
 create mode 100644 arch/powerpc/include/asm/disassemble.h
 create mode 100644 arch/powerpc/include/asm/kvm_44x.h
 create mode 100644 arch/powerpc/kvm/44x.c
 create mode 100644 arch/powerpc/kvm/44x_emulate.c
 rename arch/powerpc/kvm/{booke_guest.c => booke.c} (56%)
 create mode 100644 arch/powerpc/kvm/booke.h
 delete mode 100644 arch/powerpc/kvm/booke_host.c
 create mode 100644 arch/powerpc/kvm/timing.c
 create mode 100644 arch/powerpc/kvm/timing.h
 rename arch/x86/{kvm => include/asm}/svm.h (100%)
 create mode 100644 arch/x86/include/asm/virtext.h
 rename arch/x86/{kvm => include/asm}/vmx.h (93%)

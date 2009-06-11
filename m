Return-Path: <linux-kernel-owner+w=401wt.eu-S1760176AbZFKII1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760176AbZFKII1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 04:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755949AbZFKIIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 04:08:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48284 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755931AbZFKIIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 04:08:07 -0400
From: Avi Kivity <avi@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] KVM updates for 2.6.31
Date: Thu, 11 Jun 2009 11:08:00 +0300
Message-Id: <1244707680-30921-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the 2.6.31 KVM batch from

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.31

Changes include MSI support, a rework of the interrupt code, improved smp
performance, and architecure code updates.

Amit Shah (1):
      KVM: x86: Ignore reads to EVNTSEL MSRs

Andi Kleen (1):
      KVM: Add VT-x machine check support

Andre Przywara (1):
      KVM: SVM: Fix cross vendor migration issue in segment segment descriptor

Avi Kivity (18):
      KVM: VMX: Don't use highmem pages for the msr and pio bitmaps
      KVM: VMX: Don't intercept MSR_KERNEL_GS_BASE
      KVM: VMX: Make module parameters readable
      KVM: VMX: Rename kvm_handle_exit() to vmx_handle_exit()
      KVM: VMX: Simplify module parameter names
      KVM: VMX: Annotate module parameters as __read_mostly
      KVM: VMX: Zero the vpid module parameter if vpid is not supported
      KVM: VMX: Zero ept module parameter if ept is not present
      KVM: VMX: Fold vm_need_ept() into callers
      KVM: VMX: Make flexpriority module parameter reflect hardware capability
      KVM: MMU: Use different shadows when EFER.NXE changes
      KVM: Replace kvmclock open-coded get_cpu_var() with the real thing
      KVM: Fix cpuid feature misreporting
      KVM: Add AMD cpuid bit: cr8_legacy, abm, misaligned sse, sse4, 3dnow prefetch
      x86: Add cpu features MOVBE and POPCNT
      KVM: Update cpuid 1.ecx reporting
      KVM: Disable large pages on misaligned memory slots
      KVM: Prevent overflow in largepages calculation

Carsten Otte (4):
      KVM: s390: Fix memory slot versus run - v3
      KVM: s390: Unlink vcpu on destroy - v2
      KVM: s390: Sanity check on validity intercept
      KVM: s390: Verify memory in kvm run

Chris Wright (1):
      KVM: Trivial format fix in setup_routing_entry()

Christian Borntraeger (3):
      KVM: declare ioapic functions only on affected hardware
      KVM: s390: use hrtimer for clock wakeup from idle - v2
      KVM: s390: optimize float int lock: spin_lock_bh --> spin_lock

Dong, Eddie (2):
      KVM: MMU: Emulate #PF error code of reserved bits violation
      KVM: Use rsvd_bits_mask in load_pdptrs()

Eddie Dong (1):
      KVM: MMU: Fix comment in page_fault()

Glauber Costa (3):
      KVM: fix apic_debug instances
      KVM: Replace ->drop_interrupt_shadow() by ->set_interrupt_shadow()
      KVM: Deal with interrupt shadow state for emulated instructions

Gleb Natapov (51):
      KVM: APIC: kvm_apic_set_irq deliver all kinds of interrupts
      KVM: ioapic/msi interrupt delivery consolidation
      KVM: consolidate ioapic/ipi interrupt delivery logic
      KVM: change the way how lowest priority vcpu is calculated
      KVM: APIC: get rid of deliver_bitmask
      KVM: MMU: do not free active mmu pages in free_mmu_pages()
      KVM: SVM: Remove duplicate code in svm_do_inject_vector()
      KVM: reuse (pop|push)_irq from svm.c in vmx.c
      KVM: Timer event should not unconditionally unhalt vcpu.
      KVM: Fix interrupt unhalting a vcpu when it shouldn't
      KVM: VMX: Fix handling of a fault during NMI unblocked due to IRET
      KVM: VMX: Rewrite vmx_complete_interrupt()'s twisted maze of if() statements
      KVM: VMX: Do not zero idt_vectoring_info in vmx_complete_interrupts().
      KVM: Fix task switch back link handling.
      KVM: Fix unneeded instruction skipping during task switching.
      KVM: x86 emulator: fix call near emulation
      KVM: x86 emulator: Add decoding of 16bit second immediate argument
      KVM: x86 emulator: Add lcall decoding
      KVM: x86 emulator: Complete ljmp decoding at decode stage
      KVM: x86 emulator: Complete short/near jcc decoding in decode stage
      KVM: x86 emulator: Complete decoding of call near in decode stage
      KVM: x86 emulator: Add unsigned byte immediate decode
      KVM: x86 emulator: Completely decode in/out at decoding stage
      KVM: x86 emulator: Decode soft interrupt instructions
      KVM: x86 emulator: Add new mode of instruction emulation: skip
      KVM: SVM: Skip instruction on a task switch only when appropriate
      KVM: Make kvm_cpu_(has|get)_interrupt() work for userspace irqchip too
      KVM: VMX: Consolidate userspace and kernel interrupt injection for VMX
      KVM: VMX: Cleanup vmx_intr_assist()
      KVM: Use kvm_arch_interrupt_allowed() instead of checking interrupt_window_open directly
      KVM: SVM: Coalesce userspace/kernel irqchip interrupt injection logic
      KVM: Remove exception_injected() callback.
      KVM: Remove inject_pending_vectors() callback
      KVM: Remove kvm_push_irq()
      KVM: sync_lapic_to_cr8() should always sync cr8 to V_TPR
      KVM: Do not report TPR write to userspace if new value bigger or equal to a previous one.
      KVM: Get rid of arch.interrupt_window_open & arch.nmi_window_open
      KVM: SVM: Add NMI injection support
      KVM: Fix userspace IRQ chip migration
      KVM: Get rid of get_irq() callback
      KVM: SVM: Don't reinject event that caused a task switch
      KVM: Unprotect a page if #PF happens during NMI injection.
      KVM: Do not allow interrupt injection from userspace if there is a pending event.
      KVM: Remove irq_pending bitmap
      KVM: skip_emulated_instruction() decode instruction if size is not known
      KVM: Do not re-execute INTn instruction.
      KVM: Always request IRQ/NMI window if an interrupt is pending
      KVM: inject NMI after IRET from a previous NMI, not before.
      KVM: Do not migrate pending software interrupts.
      KVM: Disable CR8 intercept if tpr patching is active
      KVM: Move "exit due to NMI" handling into vmx_complete_interrupts()

Hannes Eder (1):
      KVM: make 'lapic_timer_ops' and 'kpit_ops' static

Jan Blunck (1):
      KVM: Wake up waitqueue before calling get_cpu()

Jan Kiszka (2):
      KVM: MMU: Fix auditing code
      KVM: Drop request_nmi from stats

Jes Sorensen (9):
      KVM: ia64: Map in SN2 RTC registers to the VMM module
      KVM: ia64: Create inline function kvm_get_itc() to centralize ITC reading.
      KVM: ia64: SN2 adjust emulated ITC frequency to match RTC frequency
      KVM: ia64: Drop in SN2 replacement of fast path ITC emulation fault handler
      KVM: ia64: Don't hold slots_lock in guest mode
      KVM: ia64: remove empty function vti_vcpu_load()
      KVM: ia64: restore irq state before calling kvm_vcpu_init
      KVM: ia64: preserve int status through call to kvm_insert_vmm_mapping
      KVM: ia64: ia64 vcpu_reset() do not call kmalloc() with irqs disabled

Joerg Roedel (1):
      KVM: MMU: remove call to kvm_mmu_pte_write from walk_addr

Marcelo Tosatti (12):
      KVM: x86: paravirt skip pit-through-ioapic boot check
      KVM: PIT: remove unused scheduled variable
      KVM: PIT: remove usage of count_load_time for channel 0
      KVM: unify part of generic timer handling
      KVM: PIT: fix count read and mode 0 handling
      KVM: MMU: remove global page optimization logic
      KVM: x86: check for cr3 validity in ioctl_set_sregs
      KVM: use smp_send_reschedule in kvm_vcpu_kick
      KVM: protect assigned dev workqueue, int handler and irq acker
      KVM: MMU: protect kvm_mmu_change_mmu_pages with mmu_lock
      KVM: take mmu_lock when updating a deleted slot
      KVM: x86: check for cr3 validity in mmu_alloc_roots

Matt T. Yourst (1):
      KVM: x86: silence preempt warning on kvm_write_guest_time

Nitin A Kamble (1):
      KVM: VMX: Rename rmode.active to rmode.vm86_active

Robert P. J. Day (1):
      KVM: Expand on "help" info to specify kvm intel and amd module names

Sheng Yang (17):
      KVM: Split IOAPIC structure
      KVM: Unify the delivery of IOAPIC and MSI interrupts
      KVM: Change API of kvm_ioapic_get_delivery_bitmask
      KVM: Update intr delivery func to accept unsigned long* bitmap
      KVM: bit ops for deliver_bitmap
      KVM: Ioctls for init MSI-X entry
      KVM: Add MSI-X interrupt injection logic
      KVM: Enable MSI-X for KVM assigned device
      KVM: Merge kvm_ioapic_get_delivery_bitmask into kvm_get_intr_delivery_bitmask
      KVM: Device assignment framework rework
      KVM: VMX: Correct wrong vmcs field sizes
      KVM: VMX: Clean up Flex Priority related
      KVM: VMX: Fix feature testing
      KVM: MMU: Discard reserved bits checking on PDE bit 7-8
      KVM: Replace get_mt_mask_shift with get_mt_mask
      KVM: Enable snooping control for supported hardware
      KVM: VMX: Disable VMX when system shutdown

Wei Yongjun (1):
      KVM: remove pointless conditional before kfree() in lapic initialization

Xiantao Zhang (1):
      KVM: ia64: Flush all TLBs once guest's memory mapping changes.

Yang Zhang (2):
      KVM: ia64: fix compilation error in kvm_get_lowest_prio_vcpu
      KVM: ia64: enable external interrupt in vmm

Zhang, Xiantao (1):
      KVM: ia64: make kvm depend on CONFIG_MODULES.

nathan binkert (1):
      KVM: Make kvm header C++ friendly

 arch/ia64/include/asm/kvm_host.h       |    6 +-
 arch/ia64/include/asm/pgtable.h        |    2 +
 arch/ia64/kernel/irq_ia64.c            |    3 +
 arch/ia64/kvm/Kconfig                  |    2 +-
 arch/ia64/kvm/kvm-ia64.c               |  263 ++++++++----
 arch/ia64/kvm/kvm_fw.c                 |   28 ++-
 arch/ia64/kvm/lapic.h                  |    6 +-
 arch/ia64/kvm/optvfault.S              |   30 ++
 arch/ia64/kvm/process.c                |    5 +
 arch/ia64/kvm/vcpu.c                   |   20 +-
 arch/ia64/kvm/vmm.c                    |   12 +-
 arch/ia64/kvm/vmm_ivt.S                |   18 +-
 arch/ia64/kvm/vtlb.c                   |    3 +-
 arch/powerpc/kvm/powerpc.c             |    6 +
 arch/s390/include/asm/kvm_host.h       |    5 +-
 arch/s390/kvm/intercept.c              |   28 +-
 arch/s390/kvm/interrupt.c              |   59 ++-
 arch/s390/kvm/kvm-s390.c               |   63 +++-
 arch/s390/kvm/kvm-s390.h               |    4 +-
 arch/s390/kvm/priv.c                   |    4 +-
 arch/s390/kvm/sigp.c                   |   16 +-
 arch/x86/include/asm/cpufeature.h      |    2 +
 arch/x86/include/asm/kvm.h             |    1 +
 arch/x86/include/asm/kvm_host.h        |   45 ++-
 arch/x86/include/asm/kvm_x86_emulate.h |    6 +
 arch/x86/include/asm/svm.h             |    1 +
 arch/x86/include/asm/vmx.h             |    1 +
 arch/x86/kernel/cpu/mcheck/mce_64.c    |    1 +
 arch/x86/kernel/kvm.c                  |    4 +
 arch/x86/kernel/smp.c                  |    3 +
 arch/x86/kvm/Kconfig                   |    6 +
 arch/x86/kvm/Makefile                  |    2 +-
 arch/x86/kvm/i8254.c                   |  109 +++---
 arch/x86/kvm/i8254.h                   |   12 +-
 arch/x86/kvm/irq.c                     |    7 +
 arch/x86/kvm/kvm_timer.h               |   18 +
 arch/x86/kvm/lapic.c                   |  251 ++++--------
 arch/x86/kvm/lapic.h                   |   12 +-
 arch/x86/kvm/mmu.c                     |  194 +++++----
 arch/x86/kvm/mmu.h                     |    5 +
 arch/x86/kvm/paging_tmpl.h             |   16 +-
 arch/x86/kvm/svm.c                     |  415 +++++++++++--------
 arch/x86/kvm/timer.c                   |   46 ++
 arch/x86/kvm/vmx.c                     |  721 +++++++++++++++++---------------
 arch/x86/kvm/x86.c                     |  409 ++++++++++++-------
 arch/x86/kvm/x86.h                     |   14 +-
 arch/x86/kvm/x86_emulate.c             |  141 +++----
 include/linux/kvm.h                    |   46 ++-
 include/linux/kvm_host.h               |   21 +-
 include/linux/kvm_types.h              |   27 ++
 virt/kvm/ioapic.c                      |  153 +------
 virt/kvm/ioapic.h                      |   27 +-
 virt/kvm/iommu.c                       |   27 +-
 virt/kvm/irq_comm.c                    |  111 +++--
 virt/kvm/kvm_main.c                    |  678 +++++++++++++++++++++---------
 55 files changed, 2471 insertions(+), 1644 deletions(-)
 create mode 100644 arch/x86/kvm/kvm_timer.h
 create mode 100644 arch/x86/kvm/timer.c

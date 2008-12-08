Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498AbYLHLhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbYLHLhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:37:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbYLHLhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:37:03 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48201 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915AbYLHLhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:00 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/45] KVM Updates for 2.6.29 (Part 1 of 3)
Date: Mon,  8 Dec 2008 13:36:11 +0200
Message-Id: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following is the kvm patchqueue for the 2.6.29 merge window.  Due to the
number of patches, this will be sent in three batches, of which this is the
first.

Amit Shah (3):
  KVM: x86: Fix typo in function name
  KVM: SVM: Set the 'g' bit of the cs selector for cross-vendor
    migration
  KVM: SVM: Set the 'busy' flag of the TR selector

Gleb Natapov (1):
  KVM: call kvm_arch_vcpu_reset() instead of the kvm_x86_ops callback

Guillaume Thouvenin (4):
  KVM: x86 emulator: consolidate push reg
  KVM: x86 emulator: Add decode entries for 0x04 and 0x05 opcodes (add
    acc, imm)
  KVM: allow emulator to adjust rip for emulated pio instructions
  KVM: VMX: Handle mmio emulation when guest state is invalid

Hollis Blanchard (8):
  KVM: ppc: Move 440-specific TLB code into 44x_tlb.c
  KVM: ppc: Rename "struct tlbe" to "struct kvmppc_44x_tlbe"
  KVM: ppc: combine booke_guest.c and booke_host.c
  KVM: ppc: Refactor powerpc.c to relocate 440-specific code
  ppc: Create disassemble.h to extract instruction fields
  KVM: ppc: refactor instruction emulation into generic and
    core-specific pieces
  KVM: ppc: Move the last bits of 44x code out of booke.c
  KVM: ppc: create struct kvm_vcpu_44x and introduce container_of()
    accessor

Izik Eidus (1):
  KVM: MMU: Fix aliased gfns treated as unaliased

Jan Kiszka (15):
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

Sheng Yang (11):
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

Xiantao Zhang (2):
  KVM: ia64: Re-organize data sturure of guests' data area
  KVM: ia64: Remove lock held by halted vcpu

 arch/ia64/include/asm/kvm_host.h            |  192 ++++++++-----
 arch/ia64/kvm/kvm-ia64.c                    |   62 ++--
 arch/ia64/kvm/kvm_minstate.h                |    4 +-
 arch/ia64/kvm/misc.h                        |    3 +-
 arch/ia64/kvm/vcpu.c                        |    5 +-
 arch/ia64/kvm/vtlb.c                        |    4 +-
 arch/powerpc/include/asm/disassemble.h      |   80 +++++
 arch/powerpc/include/asm/kvm_44x.h          |   47 +++
 arch/powerpc/include/asm/kvm_host.h         |   12 +-
 arch/powerpc/include/asm/kvm_ppc.h          |   75 ++---
 arch/powerpc/kernel/asm-offsets.c           |   16 +-
 arch/powerpc/kvm/44x.c                      |  234 ++++++++++++++
 arch/powerpc/kvm/44x_emulate.c              |  335 ++++++++++++++++++++
 arch/powerpc/kvm/44x_tlb.c                  |  179 ++++++++++-
 arch/powerpc/kvm/44x_tlb.h                  |   29 ++-
 arch/powerpc/kvm/Kconfig                    |   11 +-
 arch/powerpc/kvm/Makefile                   |   11 +-
 arch/powerpc/kvm/{booke_guest.c => booke.c} |  187 +++++++-----
 arch/powerpc/kvm/booke.h                    |   39 +++
 arch/powerpc/kvm/booke_host.c               |   83 -----
 arch/powerpc/kvm/booke_interrupts.S         |    6 +-
 arch/powerpc/kvm/emulate.c                  |  437 ++-------------------------
 arch/powerpc/kvm/powerpc.c                  |  126 +-------
 arch/x86/include/asm/kvm_host.h             |   22 +-
 arch/x86/include/asm/kvm_x86_emulate.h      |   10 +-
 arch/x86/include/asm/mtrr.h                 |   25 ++
 arch/x86/kernel/cpu/mtrr/generic.c          |   12 +-
 arch/x86/kernel/cpu/mtrr/main.c             |    4 +-
 arch/x86/kernel/cpu/mtrr/mtrr.h             |   18 +-
 arch/x86/kvm/i8254.c                        |   19 ++
 arch/x86/kvm/irq.h                          |    1 +
 arch/x86/kvm/lapic.c                        |   58 +++-
 arch/x86/kvm/mmu.c                          |  135 ++++++++-
 arch/x86/kvm/svm.c                          |   23 ++
 arch/x86/kvm/vmx.c                          |  345 +++++++++++++++-------
 arch/x86/kvm/vmx.h                          |   12 +-
 arch/x86/kvm/x86.c                          |  133 +++++++-
 arch/x86/kvm/x86_emulate.c                  |   12 +-
 include/linux/kvm.h                         |   11 +-
 include/linux/kvm_host.h                    |    3 +-
 virt/kvm/ioapic.c                           |    1 +
 virt/kvm/irq_comm.c                         |    8 +-
 virt/kvm/kvm_main.c                         |   16 +-
 43 files changed, 1940 insertions(+), 1105 deletions(-)
 create mode 100644 arch/powerpc/include/asm/disassemble.h
 create mode 100644 arch/powerpc/include/asm/kvm_44x.h
 create mode 100644 arch/powerpc/kvm/44x.c
 create mode 100644 arch/powerpc/kvm/44x_emulate.c
 rename arch/powerpc/kvm/{booke_guest.c => booke.c} (80%)
 create mode 100644 arch/powerpc/kvm/booke.h
 delete mode 100644 arch/powerpc/kvm/booke_host.c


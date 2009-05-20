Return-Path: <linux-kernel-owner+w=401wt.eu-S1755902AbZETLUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbZETLUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755953AbZETLSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:18:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55254 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715AbZETLSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:46 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 00/46] KVM updates for the 2.6.31 merge window (batch 2/3)
Date: Wed, 20 May 2009 14:17:57 +0300
Message-Id: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Second batch of the 2.6.31 merge window submission.  Note there will only be
three batches instead of four as advertised in the previous message due to a
divide failure.  Please review.

Avi Kivity (3):
  KVM: VMX: Make flexpriority module parameter reflect hardware
    capability
  KVM: MMU: Use different shadows when EFER.NXE changes
  KVM: Replace kvmclock open-coded get_cpu_var() with the real thing

Dong, Eddie (2):
  KVM: MMU: Emulate #PF error code of reserved bits violation
  KVM: Use rsvd_bits_mask in load_pdptrs()

Eddie Dong (1):
  KVM: MMU: Fix comment in page_fault()

Gleb Natapov (22):
  KVM: VMX: Fix handling of a fault during NMI unblocked due to IRET
  KVM: VMX: Rewrite vmx_complete_interrupt()'s twisted maze of if()
    statements
  KVM: VMX: Do not zero idt_vectoring_info in
    vmx_complete_interrupts().
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
  KVM: Make kvm_cpu_(has|get)_interrupt() work for userspace irqchip
    too
  KVM: VMX: Consolidate userspace and kernel interrupt injection for
    VMX
  KVM: VMX: Cleanup vmx_intr_assist()
  KVM: Use kvm_arch_interrupt_allowed() instead of checking
    interrupt_window_open directly
  KVM: SVM: Coalesce userspace/kernel irqchip interrupt injection logic
  KVM: Remove exception_injected() callback.

Jan Kiszka (1):
  KVM: MMU: Fix auditing code

Jes Sorensen (5):
  KVM: ia64: Don't hold slots_lock in guest mode
  KVM: ia64: remove empty function vti_vcpu_load()
  KVM: ia64: restore irq state before calling kvm_vcpu_init
  KVM: ia64: preserve int status through call to kvm_insert_vmm_mapping
  KVM: ia64: ia64 vcpu_reset() do not call kmalloc() with irqs disabled

Marcelo Tosatti (3):
  KVM: PIT: fix count read and mode 0 handling
  KVM: MMU: remove global page optimization logic
  KVM: x86: check for cr3 validity in ioctl_set_sregs

Sheng Yang (4):
  KVM: VMX: Correct wrong vmcs field sizes
  KVM: VMX: Clean up Flex Priority related
  KVM: VMX: Fix feature testing
  KVM: MMU: Discard reserved bits checking on PDE bit 7-8

Wei Yongjun (1):
  KVM: remove pointless conditional before kfree() in lapic
    initialization

Xiantao Zhang (1):
  KVM: ia64: Flush all TLBs once guest's memory mapping changes.

Yang Zhang (1):
  KVM: ia64: enable external interrupt in vmm

Zhang, Xiantao (1):
  KVM: ia64: make kvm depend on CONFIG_MODULES.

nathan binkert (1):
  KVM: Make kvm header C++ friendly

 arch/ia64/kvm/Kconfig           |    2 +-
 arch/ia64/kvm/kvm-ia64.c        |   82 ++++++-----
 arch/ia64/kvm/process.c         |    5 +
 arch/ia64/kvm/vmm_ivt.S         |   18 ++--
 arch/ia64/kvm/vtlb.c            |    3 +-
 arch/x86/include/asm/kvm_host.h |   11 +-
 arch/x86/include/asm/svm.h      |    1 +
 arch/x86/kvm/i8254.c            |   26 ++--
 arch/x86/kvm/irq.c              |    7 +
 arch/x86/kvm/mmu.c              |  136 +++++++++++-------
 arch/x86/kvm/mmu.h              |    5 +
 arch/x86/kvm/paging_tmpl.h      |   15 ++-
 arch/x86/kvm/svm.c              |  226 ++++++++++++++---------------
 arch/x86/kvm/vmx.c              |  303 +++++++++++++++++++--------------------
 arch/x86/kvm/x86.c              |  105 ++++++++++----
 arch/x86/kvm/x86_emulate.c      |  121 ++++++----------
 include/linux/kvm.h             |    6 +-
 17 files changed, 569 insertions(+), 503 deletions(-)


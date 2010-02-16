Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017Ab0BPKpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:45:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932774Ab0BPKfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:35:38 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/38] KVM updates for the 2.6.34 merge window (batch 3/4)
Date: Tue, 16 Feb 2010 12:34:58 +0200
Message-Id: <1266316536-28936-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the first of four batches of patches for the 2.6.34 merge window.  KVM
changes for this cycle include:

 - rdtscp support
 - powerpc server-class updates
 - much improved large-guest scaling (now up to 64 vcpus)
 - improved guest fpu handling
 - initial Hyper-V emulation
 - better swapping with EPT
 - 1GB pages on Intel
 - x86 emulator fixes

as well as the usual assortment of random fixes and improvements.

Avi Kivity (13):
  KVM: export <asm/hyperv.h>
  KVM: Allow kvm_load_guest_fpu() even when !vcpu->fpu_active
  KVM: Drop kvm_{load,put}_guest_fpu() exports
  KVM: Activate fpu on clts
  KVM: Add a helper for checking if the guest is in protected mode
  KVM: Move cr0/cr4/efer related helpers to x86.h
  KVM: Rename vcpu->shadow_efer to efer
  KVM: Optimize kvm_read_cr[04]_bits()
  KVM: trace guest fpu loads and unloads
  KVM: VMX: Pass cr0.mp through to the guest when the fpu is active
  KVM: Fix msr trace
  KVM: Trace failed msr reads and writes
  KVM: VMX: Wire up .fpu_activate() callback

Gleb Natapov (3):
  KVM: fix Hyper-V hypercall warnings and wrong mask value
  KVM: x86: fix checking of cr0 validity
  KVM: mark segments accessed on HW task switch

Gui Jianfeng (1):
  KVM: VMX: Remove redundant check in
    vm_need_virtualize_apic_accesses()

Jan Kiszka (5):
  KVM: VMX: Fix exceptions of mov to dr
  KVM: VMX: Fix emulation of DR4 and DR5
  KVM: VMX: Clean up DR6 emulation
  KVM: SVM: Clean up and enhance mov dr emulation
  KVM: SVM: Trap all debug register accesses

Joe Perches (1):
  KVM: ia64: Fix string literal continuation lines

Joerg Roedel (1):
  KVM: Introduce kvm_host_page_size

Julia Lawall (1):
  KVM: VMX: Remove redundant test in vmx_set_efer()

Liu Yu (3):
  KVM: PPC E500: Add register l1csr0 emulation
  KVM: PPC: Add PVR/PIR init for E500
  KVM: PPC E500: fix tlbcfg emulation

Marcelo Tosatti (1):
  KVM: fix cleanup_srcu_struct on vm destruction

Rik van Riel (1):
  KVM: VMX: emulate accessed bit for EPT

Sheng Yang (2):
  KVM: VMX: Remove emulation failure report
  KVM: Fix kvm_coalesced_mmio_ring duplicate allocation

Takuya Yoshikawa (4):
  KVM: x86: Use macros for x86_emulate_ops to avoid future mistakes
  KVM: fix load_guest_segment_descriptor() to return X86EMUL_*
  KVM: fix kvm_fix_hypercall() to return X86EMUL_*
  KVM: Remove redundant reading of rax on OUT instructions

Wei Yongjun (1):
  KVM: MMU: Remove some useless code from alloc_mmu_pages()

Zhai, Edwin (1):
  KVM: enable PCI multiple-segments for pass-through device

 arch/ia64/kvm/kvm-ia64.c            |    1 +
 arch/ia64/kvm/mmio.c                |    4 +-
 arch/ia64/kvm/vcpu.c                |    4 +-
 arch/powerpc/include/asm/kvm_e500.h |    3 +
 arch/powerpc/kvm/e500.c             |    6 ++
 arch/powerpc/kvm/e500_emulate.c     |   26 +++------
 arch/powerpc/kvm/e500_tlb.c         |    6 ++
 arch/powerpc/kvm/powerpc.c          |    1 +
 arch/s390/kvm/kvm-s390.c            |    1 +
 arch/x86/include/asm/Kbuild         |    1 +
 arch/x86/include/asm/kvm_host.h     |    8 +-
 arch/x86/kvm/emulate.c              |   75 ++++++++++++-----------
 arch/x86/kvm/kvm_cache_regs.h       |   11 +++-
 arch/x86/kvm/mmu.c                  |   38 ++++-------
 arch/x86/kvm/mmu.h                  |   24 -------
 arch/x86/kvm/svm.c                  |  111 +++++++++++++++++++---------------
 arch/x86/kvm/trace.h                |   27 +++++----
 arch/x86/kvm/vmx.c                  |  114 +++++++++++++++++++----------------
 arch/x86/kvm/x86.c                  |  107 ++++++++++++++-------------------
 arch/x86/kvm/x86.h                  |   30 +++++++++
 include/linux/kvm.h                 |    4 +-
 include/linux/kvm_host.h            |    2 +
 include/trace/events/kvm.h          |   19 ++++++
 virt/kvm/assigned-dev.c             |    4 +-
 virt/kvm/iommu.c                    |    9 ++-
 virt/kvm/kvm_main.c                 |   43 ++++++++------
 26 files changed, 373 insertions(+), 306 deletions(-)


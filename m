Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934338Ab0BQNvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:51:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933732Ab0BQNpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:45:35 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/20] KVM updates for the 2.6.34 merge window (batch 4/4)
Date: Wed, 17 Feb 2010 15:45:10 +0200
Message-Id: <1266414330-27444-1-git-send-email-avi@redhat.com>
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

Avi Kivity (2):
  KVM: MMU: Add tracepoint for guest page aging
  KVM: Plan obsolescence of kernel allocated slots, paravirt mmu

Gleb Natapov (9):
  KVM: x86 emulator: Add group8 instruction decoding
  KVM: x86 emulator: Add group9 instruction decoding
  KVM: x86 emulator: Add Virtual-8086 mode of emulation
  KVM: x86 emulator: fix memory access during x86 emulation
  KVM: x86 emulator: Check IOPL level during io instruction emulation
  KVM: x86 emulator: Fix popf emulation
  KVM: x86 emulator: Check CPL level during privilege instruction
    emulation
  KVM: x86 emulator: Add LOCK prefix validity checking
  KVM: x86 emulator: disallow opcode 82 in 64-bit mode

Jochen Maes (1):
  KVM: Fix Codestyle in virt/kvm/coalesced_mmio.c

Liu Yu (1):
  KVM: ppc/booke: Set ESR and DEAR when inject interrupt to guest

Michael S. Tsirkin (1):
  KVM: do not store wqh in irqfd

Sheng Yang (1):
  KVM: VMX: Rename VMX_EPT_IGMT_BIT to VMX_EPT_IPAT_BIT

Wei Yongjun (5):
  KVM: PIT: unregister kvm irq notifier if fail to create pit
  KVM: kvm->arch.vioapic should be NULL if kvm_ioapic_init() failure
  KVM: cleanup the failure path of KVM_CREATE_IRQCHIP ioctrl
  KVM: ia64: destroy ioapic device if fail to setup default irq routing
  KVM: x86 emulator: code style cleanup

 Documentation/feature-removal-schedule.txt |   30 +++
 arch/ia64/kvm/kvm-ia64.c                   |    2 +-
 arch/powerpc/include/asm/kvm_host.h        |    2 +
 arch/powerpc/kvm/booke.c                   |   59 ++++--
 arch/powerpc/kvm/emulate.c                 |    4 +-
 arch/x86/include/asm/kvm_emulate.h         |   15 ++-
 arch/x86/include/asm/kvm_host.h            |    8 +-
 arch/x86/include/asm/vmx.h                 |    2 +-
 arch/x86/kvm/emulate.c                     |  300 +++++++++++++++++++++-------
 arch/x86/kvm/i8254.c                       |    5 +-
 arch/x86/kvm/i8259.c                       |   11 +
 arch/x86/kvm/irq.h                         |    1 +
 arch/x86/kvm/mmu.c                         |   28 ++--
 arch/x86/kvm/mmu.h                         |    6 +
 arch/x86/kvm/paging_tmpl.h                 |   11 +-
 arch/x86/kvm/vmx.c                         |    4 +-
 arch/x86/kvm/x86.c                         |  152 ++++++++++----
 include/trace/events/kvm.h                 |   22 ++
 virt/kvm/coalesced_mmio.c                  |    4 +-
 virt/kvm/eventfd.c                         |    3 -
 virt/kvm/ioapic.c                          |   15 ++-
 virt/kvm/ioapic.h                          |    1 +
 22 files changed, 525 insertions(+), 160 deletions(-)


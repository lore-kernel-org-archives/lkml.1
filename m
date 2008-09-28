Return-Path: <linux-kernel-owner+w=401wt.eu-S1752067AbYI1PqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbYI1PqM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 11:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbYI1PpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 11:45:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50825 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087AbYI1PpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 11:45:07 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 00/25] KVM Updates for 2.6.28 merge window (part 3 of 3)
Date: Sun, 28 Sep 2008 18:44:36 +0300
Message-Id: <1222616701-1206-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the third and last batch of the KVM updates for the 2.6.28 merge window.

Linux 2.6.28 KVM will introduce support for pci device assignment and will
improve overall emulation accuracy.

Amit Shah (1):
  KVM: Device Assignment: Free device structures if IRQ allocation
    fails

Avi Kivity (3):
  KVM: Add statistics for guest irq injections
  KVM: x86 emulator: fix jmp r/m64 instruction
  MAINTAINERS: Update Avi Kivity's email address

Ben-Ami Yassour (1):
  KVM: Device Assignment with VT-d

Guillaume Thouvenin (3):
  KVM: x86 emulator: Add DstAcc operand type
  KVM: x86 emulator: Add cmp al, imm and cmp ax, imm instructions
    (ocodes 3c, 3d)
  KVM: x86 emulator: Use DstAcc for 'and'

Harvey Harrison (1):
  KVM: x86.c make kvm_load_realmode_segment static

Hollis Blanchard (1):
  KVM: ppc: kvmppc_44x_shadow_release() does not require mmap_sem to be
    locked

Jan Kiszka (1):
  KVM: VMX: Cleanup stalled INTR_INFO read

Joerg Roedel (1):
  add MAINTAINERS entry for the KVM AMD module

Kay, Allen M (1):
  VT-d: Changes to support KVM

Marcelo Tosatti (4):
  KVM: x86: do not execute halted vcpus
  KVM: x86: unhalt vcpu0 on reset
  KVM: opencode gfn_to_page in kvm_vm_fault
  KVM: switch to get_user_pages_fast

Mohammed Gamal (3):
  KVM: x86 emulator: Add std and cld instructions (opcodes 0xfc-0xfd)
  KVM: x86 emulator: Add in/out instructions (opcodes 0xe4-0xe7,
    0xec-0xef)
  KVM: x86 emulator: Add call near absolute instruction (opcode 0xff/2)

Sheng Yang (4):
  KVM: MMU: Modify kvm_shadow_walk.entry to accept u64 addr
  x86: Move VMX MSRs to msr-index.h
  KVM: VMX: Rename IA32_FEATURE_CONTROL bits
  x86: Move FEATURE_CONTROL bits to msr-index.h

Xiantao Zhang (1):
  KVM: ia64: Implement kvm_arch_vcpu_ioctl_{set,get}_mpstate

 MAINTAINERS                                  |    9 +-
 arch/ia64/kvm/kvm-ia64.c                     |   37 ++++-
 arch/powerpc/kvm/44x_tlb.c                   |    8 -
 arch/x86/kvm/Makefile                        |    3 +
 arch/x86/kvm/i8254.c                         |    5 +-
 arch/x86/kvm/lapic.c                         |   16 +--
 arch/x86/kvm/mmu.c                           |   33 ++---
 arch/x86/kvm/paging_tmpl.h                   |   12 +-
 arch/x86/kvm/svm.c                           |    1 +
 arch/x86/kvm/vmx.c                           |   26 ++--
 arch/x86/kvm/vmx.h                           |   18 --
 arch/x86/kvm/vtd.c                           |  198 ++++++++++++++++++++++++
 arch/x86/kvm/x86.c                           |  215 +++++++++++++++-----------
 arch/x86/kvm/x86_emulate.c                   |  132 +++++++++++-----
 drivers/pci/dmar.c                           |    4 +-
 drivers/pci/intel-iommu.c                    |  116 +++++++++++++-
 drivers/pci/iova.c                           |    2 +-
 include/asm-x86/kvm_host.h                   |   24 +---
 include/asm-x86/msr-index.h                  |   19 +++
 {drivers/pci => include/linux}/intel-iommu.h |   11 ++
 {drivers/pci => include/linux}/iova.h        |    0
 include/linux/kvm.h                          |    3 +
 include/linux/kvm_host.h                     |   53 +++++++
 virt/kvm/kvm_main.c                          |   48 ++++--
 24 files changed, 726 insertions(+), 267 deletions(-)
 create mode 100644 arch/x86/kvm/vtd.c
 rename {drivers/pci => include/linux}/intel-iommu.h (94%)
 rename {drivers/pci => include/linux}/iova.h (100%)


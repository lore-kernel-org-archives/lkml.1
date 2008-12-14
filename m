Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbYLNIJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbYLNIJn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:09:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754268AbYLNIHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:07:24 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59902 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388AbYLNIHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:07:14 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/36] KVM Updates for 2.6.29 (part 3 of 3)
Date: Sun, 14 Dec 2008 10:06:33 +0200
Message-Id: <1229242029-13410-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the third batch of the 2.6.29 merge window queue.

Amit Shah (1):
  KVM: x86 emulator: Fix handling of VMMCALL instruction

Avi Kivity (8):
  KVM: x86 emulator: reduce duplication in one operand emulation thunks
  KVM: x86 emulator: consolidate emulation of two operand instructions
  KVM: x86 emulator: Extract 'pop' sequence into a function
  KVM: x86 emulator: allow pop from mmio
  KVM: x86 emulator: switch 'pop reg' instruction to emulate_pop()
  KVM: x86 emulator: fix ret emulation
  KVM: x86 emulator: fix popf emulation
  KVM: Remove extraneous semicolon after do/while

Christian Borntraeger (2):
  KVM: s390: Fix refcounting and allow module unload
  KVM: s390: Fix memory leak of vcpu->run

Eduardo Habkost (1):
  x86: KVM guest: kvm_get_tsc_khz: return khz, not lpj

Glauber Costa (1):
  KVM: Really remove a slot when a user ask us so

Guillaume Thouvenin (5):
  KVM: x86 emulator: Extend the opcode descriptor
  KVM: x86 emulator: add Src2 decode set
  KVM: x86 emulator: add a new "implied 1" Src decode type
  KVM: x86 emulator: add the assembler code for three operands
  KVM: x86 emulator: add the emulation of shld and shrd instructions

Hannes Eder (2):
  KVM: fix sparse warning
  KVM: VMX: fix sparse warning

Hollis Blanchard (6):
  KVM: ppc: support large host pages
  powerpc/44x: declare tlb_44x_index for use in C code
  KVM: ppc: directly insert shadow mappings into the hardware TLB
  KVM: ppc: save and restore guest mappings on context switch
  KVM: ppc: Implement in-kernel exit timing statistics
  KVM: ppc: mostly cosmetic updates to the exit timing accounting code

Marcelo Tosatti (4):
  KVM: MMU: use page array in unsync walk
  KVM: MMU: collapse remote TLB flushes on root sync
  KVM: MMU: skip global pgtables on sync due to cr3 switch
  KVM: MMU: prepopulate the shadow on invlpg

Mark McLoughlin (5):
  KVM: remove the IRQ ACK notifier assertions
  KVM: make kvm_unregister_irq_ack_notifier() safe
  KVM: don't fee an unallocated irq source id
  KVM: add KVM_USERSPACE_IRQ_SOURCE_ID assertions
  KVM: split out kvm_free_assigned_irq()

Wu Fengguang (1):
  KVM: Prevent trace call into unloaded module text

 arch/powerpc/include/asm/kvm_44x.h     |   26 ++-
 arch/powerpc/include/asm/kvm_host.h    |   54 +++++
 arch/powerpc/include/asm/kvm_ppc.h     |    5 +-
 arch/powerpc/include/asm/mmu-44x.h     |    1 +
 arch/powerpc/kernel/asm-offsets.c      |   17 +-
 arch/powerpc/kvm/44x.c                 |   18 +-
 arch/powerpc/kvm/44x_emulate.c         |   11 +-
 arch/powerpc/kvm/44x_tlb.c             |  374 ++++++++++++++++++++------------
 arch/powerpc/kvm/44x_tlb.h             |    7 +-
 arch/powerpc/kvm/Kconfig               |   11 +
 arch/powerpc/kvm/Makefile              |    1 +
 arch/powerpc/kvm/booke.c               |   70 ++++---
 arch/powerpc/kvm/booke.h               |    5 +-
 arch/powerpc/kvm/booke_interrupts.S    |   72 ++----
 arch/powerpc/kvm/emulate.c             |    4 +
 arch/powerpc/kvm/powerpc.c             |    8 +-
 arch/powerpc/kvm/timing.c              |  239 ++++++++++++++++++++
 arch/powerpc/kvm/timing.h              |  102 +++++++++
 arch/s390/kvm/kvm-s390.c               |   39 ++--
 arch/x86/include/asm/kvm_host.h        |   11 +-
 arch/x86/include/asm/kvm_x86_emulate.h |    1 +
 arch/x86/kernel/kvmclock.c             |    8 +-
 arch/x86/kvm/mmu.c                     |  292 ++++++++++++++++++-------
 arch/x86/kvm/paging_tmpl.h             |   35 +++-
 arch/x86/kvm/vmx.c                     |    2 +-
 arch/x86/kvm/x86.c                     |    6 +-
 arch/x86/kvm/x86_emulate.c             |  285 +++++++++++++++----------
 virt/kvm/irq_comm.c                    |   21 +-
 virt/kvm/kvm_main.c                    |   43 +++-
 virt/kvm/kvm_trace.c                   |    1 +
 30 files changed, 1276 insertions(+), 493 deletions(-)
 create mode 100644 arch/powerpc/kvm/timing.c
 create mode 100644 arch/powerpc/kvm/timing.h


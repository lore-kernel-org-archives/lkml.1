Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbYGTLoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbYGTLoU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 07:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858AbYGTLoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 07:44:06 -0400
Received: from il.qumranet.com ([212.179.150.194]:16948 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754305AbYGTLoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 07:44:04 -0400
From: Avi Kivity <avi@qumranet.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] KVM Updates for the 2.6.27 merge window
Date: Sun, 20 Jul 2008 14:44:01 +0300
Message-Id: <1216554241-9966-1-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the repo and branch:

  git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git kvm-updates-2.6.27

to receive the 2.6.27 merge window kvm updates.  Changes include mmio
coalescing, x86 emulator updates, nmi support, mtrr emualtion, and
some kvmtrace work.

Shortlog, diffstat:

Adrian Bunk (1):
      x86: KVM guest: make kvm_smp_prepare_boot_cpu() static

Anthony Liguori (1):
      KVM: Handle vma regions with no backing page

Aurelien Jarno (1):
      KVM: PIT: support mode 3

Avi Kivity (26):
      KVM: VMX: Trivial vmcs_write64() code simplification
      KVM: MMU: Fix false flooding when a pte points to page table
      KVM: Handle virtualization instruction #UD faults during reboot
      KVM: VMX: Add list of potentially locally cached vcpus
      KVM: Remove decache_vcpus_on_cpu() and related callbacks
      KVM: Remove unnecessary ->decache_regs() call
      KVM: Order segment register constants in the same way as cpu operand encoding
      KVM: MTRR support
      KVM: MMU: Optimize prefetch_page()
      KVM: x86 emulator: simplify push imm8 emulation
      KVM: x86 emulator: implement 'push imm' (opcode 0x68)
      KVM: MMU: Move nonpaging_prefetch_page()
      KVM: MMU: Avoid page prefetch on SVM
      KVM: Use printk_rlimit() instead of reporting emulation failures just once
      KVM: x86 emulator: handle undecoded rex.b with r/m = 5 in certain cases
      KVM: x86 emulator: simplify sib decoding
      KVM: x86 emulator: simplify r/m decoding
      KVM: x86 emulator: simplify rip relative decoding
      KVM: x86 emulator: avoid segment base adjust for lea
      KVM: x86 emulator: lazily evaluate segment registers
      KVM: MMU: When debug is enabled, make it a run-time parameter
      KVM: MMU: Fix printk format
      KVM: Apply the kernel sigmask to vcpus blocked due to being uninitialized
      KVM: Prefix some x86 low level function with kvm_, to avoid namespace issues
      KVM: MMU: Fix potential race setting upper shadow ptes on nonpae hosts
      KVM: Adjust smp_call_function_mask() callers to new requirements

Ben-Ami Yassour (1):
      KVM: check injected pic irq within valid pic irqs

Carsten Otte (2):
      KVM: s390: dont allocate dirty bitmap
      KVM: Fix memory leak on guest exit

Chris Lalancette (2):
      KVM: SVM: Fake MSR_K7 performance counters
      KVM: VMX: Fake emulate Intel perfctr MSRs

Christian Borntraeger (3):
      KVM: remove long -> void *user -> long cast
      KVM: s390: Set guest storage limit and offset to sane values
      KVM: s390: rename private structures

Glauber Costa (2):
      KVM: Do not calculate linear rip in emulation failure report
      KVM: x86 emulator: emulate clflush

Guillaume Thouvenin (6):
      KVM: Prefixes segment functions that will be exported with "kvm_"
      KVM: x86 emulator: Update c->dst.bytes in decode instruction
      KVM: x86 emulator: add support for jmp far 0xea
      KVM: x86 emulator: adds support to mov r,imm (opcode 0xb8) instruction
      KVM: x86 emulator: Add support for mov seg, r (0x8e) instruction
      KVM: x86 emulator: Add support for mov r, sreg (0x8c) instruction

Harvey Harrison (1):
      KVM: add statics were possible, function definition in lapic.h

Joerg Roedel (7):
      KVM: VMX: move APIC_ACCESS trace entry to generic code
      KVM: SVM: implement dedicated NMI exit handler
      KVM: SVM: implement dedicated INTR exit handler
      KVM: add missing kvmtrace bits
      KVM: SVM: add missing kvmtrace markers
      KVM: SVM: add tracing support for TDP page faults
      KVM: SVM: fix suspend/resume support

Laurent Vivier (5):
      KVM: kvm_io_device: extend in_range() to manage len and write attribute
      KVM: Add coalesced MMIO support (common part)
      KVM: Add coalesced MMIO support (x86 part)
      KVM: Add coalesced MMIO support (powerpc part)
      KVM: Add coalesced MMIO support (ia64 part)

Marcelo Tosatti (5):
      KVM: only abort guest entry if timer count goes from 0->1
      KVM: move slots_lock acquision down to vapic_exit
      KVM: mmu_shrink: kvm_mmu_zap_page requires slots_lock to be held
      KVM: MMU: nuke shadowed pgtable pages and ptes on memslot destruction
      KVM: MMU: improve invalid shadow root page handling

Mohammed Gamal (2):
      KVM: x86 emulator: emulate nop and xchg reg, acc (opcodes 0x90 - 0x97)
      KVM: x86 emulator: Fix HLT instruction

Sheng Yang (4):
      KVM: IOAPIC/LAPIC: Enable NMI support
      KVM: VMX: Enable NMI with in-kernel irqchip
      KVM: VMX: Fix a wrong usage of vmcs_config
      KVM: VMX: Add ept_sync_context in flush_tlb

Tan, Li (1):
      KVM: Support mixed endian machines

 arch/ia64/kvm/Makefile            |    3 +-
 arch/ia64/kvm/kvm-ia64.c          |   20 +--
 arch/powerpc/kvm/Makefile         |    2 +-
 arch/powerpc/kvm/powerpc.c        |   11 +-
 arch/s390/kvm/interrupt.c         |   32 ++--
 arch/s390/kvm/kvm-s390.c          |   21 ++-
 arch/s390/kvm/priv.c              |    2 +-
 arch/s390/kvm/sigp.c              |   20 ++--
 arch/x86/kernel/kvmclock.c        |    2 +-
 arch/x86/kvm/Makefile             |    3 +-
 arch/x86/kvm/i8254.c              |   24 ++--
 arch/x86/kvm/i8259.c              |    9 +-
 arch/x86/kvm/irq.h                |    2 +
 arch/x86/kvm/lapic.c              |   14 ++-
 arch/x86/kvm/lapic.h              |    1 +
 arch/x86/kvm/mmu.c                |   62 ++++++---
 arch/x86/kvm/mmu.h                |    3 +-
 arch/x86/kvm/paging_tmpl.h        |   28 ++--
 arch/x86/kvm/svm.c                |  131 +++++++++++-----
 arch/x86/kvm/vmx.c                |  230 +++++++++++++++++++++-------
 arch/x86/kvm/vmx.h                |   12 ++-
 arch/x86/kvm/x86.c                |  299 ++++++++++++++++++++-----------------
 arch/x86/kvm/x86_emulate.c        |  257 ++++++++++++++++++++------------
 include/asm-ia64/kvm_host.h       |    3 +
 include/asm-powerpc/kvm_host.h    |    2 +
 include/asm-s390/kvm_host.h       |   36 +++---
 include/asm-x86/kvm.h             |    1 +
 include/asm-x86/kvm_host.h        |   69 +++++++--
 include/asm-x86/kvm_x86_emulate.h |   11 +-
 include/linux/kvm.h               |   33 ++++-
 include/linux/kvm_host.h          |   11 +-
 virt/kvm/coalesced_mmio.c         |  156 +++++++++++++++++++
 virt/kvm/coalesced_mmio.h         |   23 +++
 virt/kvm/ioapic.c                 |   23 +++-
 virt/kvm/iodev.h                  |    8 +-
 virt/kvm/kvm_main.c               |  153 ++++++++++++++++---
 virt/kvm/kvm_trace.c              |   18 ++-
 37 files changed, 1215 insertions(+), 520 deletions(-)
 create mode 100644 virt/kvm/coalesced_mmio.c
 create mode 100644 virt/kvm/coalesced_mmio.h

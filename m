Return-Path: <linux-kernel-owner+w=401wt.eu-S1757022AbYFZMrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022AbYFZMrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbYFZMaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:30:12 -0400
Received: from il.qumranet.com ([212.179.150.194]:32310 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbYFZM2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:33 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/50] KVM patches review for the 2.6.27 merge window
Date: Thu, 26 Jun 2008 15:27:42 +0300
Message-Id: <1214483312-9265-1-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patchset contains the kvm updates for 2.6.27.  Nothing
particularly exciting:  NMI, MTRR, mmio coalescing, and the inevitable
x86 emulator work.

Anthony Liguori (1):
  KVM: Handle vma regions with no backing page

Aurelien Jarno (1):
  KVM: PIT: support mode 3

Avi Kivity (22):
  KVM: VMX: Trivial vmcs_write64() code simplification
  KVM: MMU: Fix false flooding when a pte points to page table
  KVM: Handle virtualization instruction #UD faults during reboot
  KVM: VMX: Add list of potentially locally cached vcpus
  KVM: Remove decache_vcpus_on_cpu() and related callbacks
  KVM: Remove unnecessary ->decache_regs() call
  KVM: Order segment register constants in the same way as cpu operand
    encoding
  KVM: MTRR support
  KVM: MMU: Optimize prefetch_page()
  KVM: x86 emulator: simplify push imm8 emulation
  KVM: x86 emulator: implement 'push imm' (opcode 0x68)
  KVM: MMU: Move nonpaging_prefetch_page()
  KVM: MMU: Avoid page prefetch on SVM
  KVM: Use printk_rlimit() instead of reporting emulation failures just
    once
  KVM: x86 emulator: handle undecoded rex.b with r/m = 5 in certain
    cases
  KVM: x86 emulator: simplify sib decoding
  KVM: x86 emulator: simplify r/m decoding
  KVM: x86 emulator: simplify rip relative decoding
  KVM: x86 emulator: avoid segment base adjust for lea
  KVM: x86 emulator: lazily evaluate segment registers
  KVM: MMU: When debug is enabled, make it a run-time parameter
  KVM: MMU: Fix printk format

Chris Lalancette (1):
  KVM: SVM: Fake MSR_K7 performance counters

Christian Borntraeger (1):
  KVM: remove long -> void *user -> long cast

Glauber Costa (1):
  KVM: Do not calculate linear rip in emulation failure report

Guillaume Thouvenin (6):
  KVM: Prefixes segment functions that will be exported with "kvm_"
  KVM: x86 emulator: Update c->dst.bytes in decode instruction
  KVM: x86 emulator: add support for jmp far 0xea
  KVM: x86 emulator: adds support to mov r,imm (opcode 0xb8)
    instruction
  KVM: x86 emulator: Add support for mov seg, r (0x8e) instruction
  KVM: x86 emulator: Add support for mov r, sreg (0x8c) instruction

Harvey Harrison (1):
  KVM: add statics were possible, function definition in lapic.h

Joerg Roedel (6):
  KVM: VMX: move APIC_ACCESS trace entry to generic code
  KVM: SVM: implement dedicated NMI exit handler
  KVM: SVM: implement dedicated INTR exit handler
  KVM: add missing kvmtrace bits
  KVM: SVM: add missing kvmtrace markers
  KVM: SVM: add tracing support for TDP page faults

Laurent Vivier (5):
  KVM: kvm_io_device: extend in_range() to manage len and write
    attribute
  KVM: Add coalesced MMIO support (common part)
  KVM: Add coalesced MMIO support (x86 part)
  KVM: Add coalesced MMIO support (powerpc part)
  KVM: Add coalesced MMIO support (ia64 part)

Marcelo Tosatti (1):
  KVM: only abort guest entry if timer count goes from 0->1

Mohammed Gamal (1):
  KVM: x86 emulator: emulate nop and xchg reg, acc (opcodes 0x90 -
    0x97)

Sheng Yang (2):
  KVM: IOAPIC/LAPIC: Enable NMI support
  KVM: VMX: Enable NMI with in-kernel irqchip

Tan, Li (1):
  KVM: Support mixed endian machines

 arch/ia64/kvm/Makefile            |    3 +-
 arch/ia64/kvm/kvm-ia64.c          |   17 +--
 arch/powerpc/kvm/Makefile         |    2 +-
 arch/powerpc/kvm/powerpc.c        |    7 +-
 arch/s390/kvm/kvm-s390.c          |    4 -
 arch/x86/kvm/Makefile             |    3 +-
 arch/x86/kvm/i8254.c              |   24 ++--
 arch/x86/kvm/i8259.c              |    3 +-
 arch/x86/kvm/lapic.c              |   14 ++-
 arch/x86/kvm/lapic.h              |    1 +
 arch/x86/kvm/mmu.c                |   47 +++++--
 arch/x86/kvm/mmu.h                |    3 +-
 arch/x86/kvm/paging_tmpl.h        |   28 ++--
 arch/x86/kvm/svm.c                |   85 +++++++++----
 arch/x86/kvm/vmx.c                |  187 ++++++++++++++++++++------
 arch/x86/kvm/vmx.h                |   12 ++-
 arch/x86/kvm/x86.c                |  262 ++++++++++++++++++++-----------------
 arch/x86/kvm/x86_emulate.c        |  251 ++++++++++++++++++++++-------------
 include/asm-ia64/kvm_host.h       |    3 +
 include/asm-powerpc/kvm_host.h    |    2 +
 include/asm-x86/kvm.h             |    1 +
 include/asm-x86/kvm_host.h        |   43 ++++++-
 include/asm-x86/kvm_x86_emulate.h |   11 +-
 include/linux/kvm.h               |   33 +++++-
 include/linux/kvm_host.h          |   10 +-
 virt/kvm/coalesced_mmio.c         |  156 ++++++++++++++++++++++
 virt/kvm/coalesced_mmio.h         |   23 ++++
 virt/kvm/ioapic.c                 |   23 +++-
 virt/kvm/iodev.h                  |    8 +-
 virt/kvm/kvm_main.c               |  130 ++++++++++++++++---
 virt/kvm/kvm_trace.c              |   18 ++-
 31 files changed, 1019 insertions(+), 395 deletions(-)
 create mode 100644 virt/kvm/coalesced_mmio.c
 create mode 100644 virt/kvm/coalesced_mmio.h


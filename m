Return-Path: <linux-kernel-owner+w=401wt.eu-S1751366AbXECHQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366AbXECHQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 03:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbXECHQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 03:16:27 -0400
Received: from il.qumranet.com ([82.166.9.18]:37684 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366AbXECHQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 03:16:25 -0400
From: Avi Kivity <avi@qumranet.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [GIT PULL] KVM updates for Linux 2.6.22
Date: Thu,  3 May 2007 10:16:23 +0300
Message-Id: <11781765833054-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from the repository and branch

  git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git for-linus

to receive the pending kvm updates for 2.6.22.  The changes increase
the range of guests we support, improve performance, fix various bugs,
and improve the userspace interface.

Adrian Bunk (1):
      KVM: fix an if() condition

Anthony Liguori (3):
      KVM: Lazy FPU support for SVM
      KVM: VMX: Properly shadow the CR0 register in the vcpu struct
      KVM: VMX: Add lazy FPU support for VT

Avi Kivity (51):
      KVM: Use own minor number
      KVM: Export <linux/kvm.h>
      KVM: Fix bogus sign extension in mmu mapping audit
      KVM: Use a shared page for kernel/user communication when runing a vcpu
      KVM: Do not communicate to userspace through cpu registers during PIO
      KVM: Handle cpuid in the kernel instead of punting to userspace
      KVM: Remove the 'emulated' field from the userspace interface
      KVM: Remove minor wart from KVM_CREATE_VCPU ioctl
      KVM: Renumber ioctls
      KVM: Add method to check for backwards-compatible API extensions
      KVM: Allow userspace to process hypercalls which have no kernel handler
      KVM: Fold kvm_run::exit_type into kvm_run::exit_reason
      KVM: Add a special exit reason when exiting due to an interrupt
      KVM: Initialize the apic_base msr on svm too
      KVM: Add guest mode signal mask
      KVM: Allow kernel to select size of mmap() buffer
      KVM: Future-proof argument-less ioctls
      KVM: Avoid guest virtual addresses in string pio userspace interface
      KVM: MMU: Remove unnecessary check for pdptr access
      KVM: MMU: Remove global pte tracking
      KVM: Workaround vmx inability to virtualize the reset state
      KVM: Remove set_cr0_no_modeswitch() arch op
      KVM: Modify guest segments after potentially switching modes
      KVM: Hack real-mode segments on vmx from KVM_SET_SREGS
      KVM: Don't allow the guest to turn off the cpu cache
      KVM: Remove unused and write-only variables
      KVM: MMU: Fix hugepage pdes mapping same physical address with different access
      KVM: SVM: Ensure timestamp counter monotonicity
      KVM: Use list_move()
      KVM: Remove debug message
      KVM: x86 emulator: fix bit string operations operand size
      KVM: Simply gfn_to_page()
      KVM: Add physical memory aliasing feature
      KVM: Add fpu get/set operations
      KVM: Use kernel-standard types
      KVM: Initialize cr0 to indicate an fpu is present
      KVM: Handle partial pae pdptr
      KVM: Use slab caches to allocate mmu data structures
      KVM: Retry sleeping allocation if atomic allocation fails
      KVM: SVM: Report hardware exit reason to userspace instead of dmesg
      KVM: Handle guest page faults when emulating mmio
      KVM: VMX: Reduce unnecessary saving of host msrs
      KVM: VMX: Don't switch 64-bit msrs for 32-bit guests
      KVM: Fold drivers/kvm/kvm_vmx.h into drivers/kvm/vmx.c
      KVM: VMX: Only save/restore MSR_K6_STAR if necessary
      KVM: Per-vcpu statistics
      KVM: Allow passing 64-bit values to the emulated read/write API
      KVM: Don't complain about cpu erratum AA15
      KVM: Remove extraneous guest entry on mmio read
      KVM: Don't require explicit indication of completion of mmio or pio
      KVM: Remove unused 'instruction_length'

Dor Laor (3):
      KVM: Fix guest register corruption on paravirt hypercall
      KVM: Use the generic skip_emulated_instruction() in hypercall code
      KVM: Add mmu cache clear function

Eric Sesterhenn / Snakebyte (1):
      KVM: Fix overflow bug in overflow detection code

Joerg Roedel (2):
      KVM: SVM: forbid guest to execute monitor/mwait
      KVM: SVM: enable LBRV virtualization if available

Michal Piotrowski (1):
      KVM: Remove unused function

Sergey Kiselev (1):
      KVM: Handle writes to MCG_STATUS msr

Signed-off-by: Anthony Liguori (1):
      KVM: SVM: Only save/restore MSRs when needed

Yaozu Dong (2):
      KVM: MMU: Avoid heavy ASSERT at non debug mode.
      KVM: VMX: Avoid unnecessary vcpu_load()/vcpu_put() cycles

 drivers/kvm/kvm.h          |  100 ++++--
 drivers/kvm/kvm_main.c     |  792 +++++++++++++++++++++++++++++++++++++-------
 drivers/kvm/kvm_svm.h      |   13 +-
 drivers/kvm/kvm_vmx.h      |   14 -
 drivers/kvm/mmu.c          |  154 +++++++---
 drivers/kvm/paging_tmpl.h  |   12 +-
 drivers/kvm/svm.c          |  197 +++++++----
 drivers/kvm/svm.h          |    6 +
 drivers/kvm/vmx.c          |  273 +++++++++++-----
 drivers/kvm/x86_emulate.c  |   51 +---
 drivers/kvm/x86_emulate.h  |   32 +--
 include/linux/Kbuild       |    1 +
 include/linux/kvm.h        |  133 ++++++---
 include/linux/miscdevice.h |    1 +
 14 files changed, 1301 insertions(+), 478 deletions(-)
 delete mode 100644 drivers/kvm/kvm_vmx.h

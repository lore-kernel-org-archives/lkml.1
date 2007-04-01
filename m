Return-Path: <linux-kernel-owner+w=401wt.eu-S933297AbXDAOjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933297AbXDAOjs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933351AbXDAOfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:35:44 -0400
Received: from il.qumranet.com ([82.166.9.18]:47530 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933102AbXDAOfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:35:40 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/41] kvm updates for 2.6.22
Date: Sun,  1 Apr 2007 17:34:57 +0300
Message-Id: <1175438138288-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following is my current 2.6.22 kvm queue.  It contains userspace interface
updates, improved guest support, cleanups, and plain bugfixes.  It will
likely grow slightly by the time the merge window opens.

Avi Kivity (34):
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

Dor Laor (3):
      KVM: Fix guest register corruption on paravirt hypercall
      KVM: Use the generic skip_emulated_instruction() in hypercall code
      KVM: Add mmu cache clear function

Joerg Roedel (2):
      KVM: SVM: forbid guest to execute monitor/mwait
      KVM: SVM: enable LBRV virtualization if available

Michal Piotrowski (1):
      KVM: Remove unused function

Sergey Kiselev (1):
      KVM: Handle writes to MCG_STATUS msr

 drivers/kvm/kvm.h          |   57 +++-
 drivers/kvm/kvm_main.c     |  649 ++++++++++++++++++++++++++++++++++++++++----
 drivers/kvm/kvm_svm.h      |    2 -
 drivers/kvm/mmu.c          |   69 +++--
 drivers/kvm/paging_tmpl.h  |   10 +-
 drivers/kvm/svm.c          |  111 +++++---
 drivers/kvm/svm.h          |    6 +
 drivers/kvm/vmx.c          |   88 +++----
 drivers/kvm/x86_emulate.c  |    5 +-
 include/linux/Kbuild       |    1 +
 include/linux/kvm.h        |  135 +++++++---
 include/linux/miscdevice.h |    1 +
 12 files changed, 898 insertions(+), 236 deletions(-)

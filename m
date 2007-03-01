Return-Path: <linux-kernel-owner+w=401wt.eu-S1752373AbXCAMzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbXCAMzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 07:55:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbXCAMzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 07:55:08 -0500
Received: from il.qumranet.com ([82.166.9.18]:52823 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373AbXCAMzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 07:55:06 -0500
Message-ID: <45E6CCA5.6050905@qumranet.com>
Date: Thu, 01 Mar 2007 14:52:53 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: [GIT PULL] KVM updates for Linux 2.6.21-rc2
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit 2ff7354fe888f46f6629b57e463b0a1eb956c02b:
  Eric W. Biederman (1):
        x86_64/i386 irq: Fix !CONFIG_SMP compilation

are found in the git repository at:

  git://kvm.qumranet.com/kvm.git#linus

The changes fall into three broad categories:
- initial kvm paravirtulization support
- the first batch of the stable userspace interface changes
- fixes, fixes, fixes

The userspace interface changes, while nontrivial, are crucially 
important as I'd like to freeze the non-paravirt userspace interface for 
2.6.21.  Unfortunately there are a few more changes of that nature pending.

Please exercise more than the usual care when pulling as I am very much 
a git newbie.

Ahmed S. Darwish (1):
      KVM: Use ARRAY_SIZE macro instead of manual calculation.

Andrew Morton (1):
      KVM: Move kvmfs magic number to <linux/magic.h>

Avi Kivity (13):
      KVM: mmu: add missing dirty page tracking cases
      KVM: Cosmetics
      KVM: Add hypercall host support for svm
      KVM: Wire up hypercall handlers to a central arch-independent location
      KVM: svm: init cr0 with the wp bit set
      KVM: More 0 -> NULL conversions
      KVM: Add internal filesystem for generating inodes
      KVM: Create an inode per virtual machine
      KVM: Rename some kvm_dev_ioctl_*() functions to kvm_vm_ioctl_*()
      KVM: Move kvm_vm_ioctl_create_vcpu() around
      KVM: Per-vcpu inodes
      KVM: Bump API version
      KVM: Fix bogus failure in kvm.ko module initialization

Ingo Molnar (2):
      KVM: add MSR based hypercall API
      KVM: Add host hypercall support for vmx

Jeremy Katz (1):
      KVM: Move virtualization deactivation from CPU_DEAD state to 
CPU_DOWN_PREPARE

Joerg Roedel (2):
      KVM: vmx: hack set_cr0_no_modeswitch() to actually do modeswitch
      KVM: SVM: intercept SMI to handle it at host level

Markus Rechberger (1):
      KVM: Use page_private()/set_page_private() apis

Uri Lublin (4):
      KVM: Add missing calls to mark_page_dirty()
      KVM: Fix dirty page log bitmap size/access calculation
      kvm: move do_remove_write_access() up
      KVM: Remove write access permissions when dirty-page-logging is 
enabled

 drivers/kvm/kvm.h         |   13 +-
 drivers/kvm/kvm_main.c    |  776 
+++++++++++++++++++++++++++++++--------------
 drivers/kvm/kvm_svm.h     |    3 +-
 drivers/kvm/mmu.c         |   36 +-
 drivers/kvm/paging_tmpl.h |   18 +-
 drivers/kvm/svm.c         |   42 ++-
 drivers/kvm/vmx.c         |   33 ++-
 include/linux/kvm.h       |   50 ++--
 include/linux/kvm_para.h  |   73 +++++
 include/linux/magic.h     |    1 +
 10 files changed, 748 insertions(+), 297 deletions(-)
 create mode 100644 include/linux/kvm_para.h

-- 
error compiling committee.c: too many arguments to function


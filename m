Return-Path: <linux-kernel-owner+w=401wt.eu-S1751526AbXCDJVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526AbXCDJVm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 04:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbXCDJVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 04:21:42 -0500
Received: from mis011-2.exch011.intermedia.net ([64.78.21.129]:18934 "EHLO
	mis011-2.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751524AbXCDJVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 04:21:41 -0500
Message-ID: <45EA8F9F.6010006@qumranet.com>
Date: Sun, 04 Mar 2007 11:21:35 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: [GIT PULL][RETRY] KVM updates for Linux 2.6.21-rc2
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Mar 2007 09:21:40.0399 (UTC) FILETIME=[844D4BF0:01C75E3E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit b648a0d22908116b4ef168935a160d7f17c4e6d:
   Linus Torvalds (1):
         Merge branch 'upstream-linus' of 
master.kernel.org:/.../jgarzik/libata-dev

are found in the 'linus' branch of the git repository at:

  git://kvm.qumranet.com/home/avi/kvm.git

The changes fall into three broad categories:
- initial kvm paravirtulization support
- the first batch of the stable userspace interface changes
- fixes, fixes, fixes

The userspace interface changes, while nontrivial, are crucially
important as I'd like to freeze the non-paravirt userspace interface for
2.6.21.  Unfortunately there are a few more changes of that nature pending.

The patches have been sitting in -mm collecting bit dust for a while, as 
well as in the regular kvm releases.

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


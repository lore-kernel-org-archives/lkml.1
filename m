Return-Path: <linux-kernel-owner+w=401wt.eu-S1765024AbYCDQD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765024AbYCDQD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 11:03:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759506AbYCDQDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 11:03:49 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:42771
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757064AbYCDQDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:03:48 -0500
Message-ID: <47CD72E0.6060603@qumranet.com>
Date: Tue, 04 Mar 2008 18:03:44 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: [GIT PULL] KVM fixes for 2.6.25-rc3
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the kvm fixes in the repo and branch

  git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git for-linus

comprising an ABI fix, a few host crash fixes, AMD specific fixes,
a Kbuild fix for the randconfig addicts, fallout from the scaling
work, and other miscellany.

Avi Kivity (5):
      KVM: Make the supported cpuid list a host property rather than a 
vm property
      KVM: Avoid infinite-frequency local apic timer
      KVM: Route irq 0 to vcpu 0 exclusively
      KVM: MMU: Fix race when instantiating a shadow pte
      KVM: VMX: Avoid rearranging switched guest msrs while they are loaded

Izik Eidus (1):
      KVM: remove the usage of the mmap_sem for the protection of the 
memory slots.

Joerg Roedel (4):
      KVM: SVM: Fix lazy FPU switching
      KVM: SVM: set NM intercept when enabling CR0.TS in the guest
      KVM: emulate access to MSR_IA32_MCG_CTL
      KVM: SVM: fix Windows XP 64 bit installation crash

Marcelo Tosatti (2):
      KVM: move alloc_apic_access_page() outside of non-preemptable region
      KVM: make MMU_DEBUG compile again

Paul Knowles (1):
      KVM: Fix kvm_arch_vcpu_ioctl_set_sregs so that set_cr0 works properly

Randy Dunlap (1):
      x86: disable KVM for Voyager and friends

 arch/x86/Kconfig           |    2 +-
 arch/x86/kvm/lapic.c       |    4 ++
 arch/x86/kvm/mmu.c         |   38 ++++++++++-----
 arch/x86/kvm/paging_tmpl.h |   20 +++++---
 arch/x86/kvm/svm.c         |   26 ++++++++++
 arch/x86/kvm/vmx.c         |   14 ++++--
 arch/x86/kvm/x86.c         |  114 
+++++++++++++++++++++++++-------------------
 include/linux/kvm.h        |    4 +-
 include/linux/kvm_host.h   |    1 +
 virt/kvm/ioapic.c          |    8 +++
 virt/kvm/kvm_main.c        |    5 +-
 11 files changed, 156 insertions(+), 80 deletions(-)

-- 
error compiling committee.c: too many arguments to function


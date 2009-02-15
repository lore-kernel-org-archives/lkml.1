Return-Path: <linux-kernel-owner+w=401wt.eu-S1753818AbZBOCiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbZBOCiX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 21:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbZBOCiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 21:38:13 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38969 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751AbZBOCiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 21:38:13 -0500
From: Avi Kivity <avi@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 2.6.29-rc5
Date: Sun, 15 Feb 2009 04:38:06 +0200
Message-Id: <1234665486-11863-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from repo and branch at

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.29

to receive a bunch of kvm fixes for Linux 2.6.29-rc5.  Among other fixes,
several device assignment bugs are corrected here.

Shortlog, diffstat follows.

Avi Kivity (2):
      KVM: Avoid using CONFIG_ in userspace visible headers
      KVM: VMX: Flush volatile msrs before emulating rdmsr

Marcelo Tosatti (4):
      KVM: mmu_notifiers release method
      KVM: PIT: fix i8254 pending count read
      KVM: x86: disable kvmclock on non constant TSC hosts
      KVM: x86: fix LAPIC pending count calculation

Mark McLoughlin (1):
      KVM: Fix assigned devices circular locking dependency

Sheng Yang (4):
      KVM: Add kvm_arch_sync_events to sync with asynchronize events
      KVM: Fix racy in kvm_free_assigned_irq
      KVM: MMU: Map device MMIO as UC in EPT
      KVM: Fix INTx for device assignment

Yang Zhang (1):
      KVM: ia64: fix fp fault/trap handler

 arch/ia64/include/asm/kvm.h |    4 ++
 arch/ia64/kvm/kvm-ia64.c    |    4 ++
 arch/ia64/kvm/process.c     |   17 ++++++-----
 arch/powerpc/kvm/powerpc.c  |    4 ++
 arch/s390/kvm/kvm-s390.c    |    4 ++
 arch/x86/include/asm/kvm.h  |    7 ++++
 arch/x86/kvm/i8254.c        |    2 +-
 arch/x86/kvm/irq.c          |    7 ----
 arch/x86/kvm/irq.h          |    1 -
 arch/x86/kvm/lapic.c        |   66 ++++++++++---------------------------------
 arch/x86/kvm/lapic.h        |    2 -
 arch/x86/kvm/mmu.c          |    9 ++++-
 arch/x86/kvm/svm.c          |    1 -
 arch/x86/kvm/vmx.c          |    5 +--
 arch/x86/kvm/x86.c          |   10 +++++-
 include/linux/kvm.h         |   10 +++---
 include/linux/kvm_host.h    |    1 +
 virt/kvm/iommu.c            |    6 +--
 virt/kvm/kvm_main.c         |   43 +++++++++++++++++++++------
 19 files changed, 106 insertions(+), 97 deletions(-)

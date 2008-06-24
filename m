Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbYFXVFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbYFXVFD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 17:05:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbYFXVEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 17:04:54 -0400
Received: from il.qumranet.com ([212.179.150.194]:58167 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbYFXVEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 17:04:53 -0400
Message-ID: <48616182.9030902@qumranet.com>
Date: Wed, 25 Jun 2008 00:05:06 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: kvm-devel <kvm@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] KVM fixes for 2.6.26-rc7
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (firebolt.argo.co.il [0.0.0.0]); Wed, 25 Jun 2008 00:05:06 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the repo and branch at:

  git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git 
kvm-updates-2.6.26

to receive kvm updates for 2.6.26-rc7.  The patches fix host oopses,
guest interrupt loss, and total kvm clock borkage.

Since one of the goals of kvm clock was to be binary compatible with the Xen
clock, the patchset moves the Xen time code to common code and makes kvm 
reuse it.
This fixes both the ABI and correctness issues.  Jeremy has acked the Xen
changes.

Avi Kivity (3):
      KVM: MMU: Fix oops on guest userspace access to guest pagetable
      KVM: ioapic: fix lost interrupt when changing a device's irq
      KVM: VMX: Fix host msr corruption with preemption enabled

Gerd Hoffmann (5):
      x86: Add structs and functions for paravirt clocksource
      x86: Make xen use the paravirt clocksource structs and functions
      KVM: Make kvm host use the paravirt clocksource structs
      x86: KVM guest: Use the paravirt clocksource structs and functions
      KVM: Remove now unused structs from kvm_para.h

Marcelo Tosatti (4):
      KVM: Fix race between timer migration and vcpu migration
      KVM: close timer injection race window in __vcpu_run
      KVM: MMU: Fix rmap_write_protect() hugepage iteration bug
      KVM: MMU: large page update_pte issue with non-PAE 32-bit guests 
(resend)

 arch/x86/Kconfig              |    5 ++
 arch/x86/kernel/Makefile      |    1 +
 arch/x86/kernel/kvmclock.c    |   89 ++++++++++----------------
 arch/x86/kernel/pvclock.c     |  141 
+++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/i8254.c          |    9 ++-
 arch/x86/kvm/lapic.c          |    1 +
 arch/x86/kvm/mmu.c            |   19 +++---
 arch/x86/kvm/vmx.c            |   19 +++---
 arch/x86/kvm/x86.c            |   91 +++++++++++++++++++-------
 arch/x86/xen/Kconfig          |    1 +
 arch/x86/xen/time.c           |  132 
++++-----------------------------------
 include/asm-x86/kvm_host.h    |    4 +-
 include/asm-x86/kvm_para.h    |   18 -----
 include/asm-x86/pvclock-abi.h |   42 ++++++++++++
 include/asm-x86/pvclock.h     |   13 ++++
 include/linux/kvm_host.h      |    1 +
 include/xen/interface/xen.h   |    7 +-
 virt/kvm/ioapic.c             |   31 +++------
 18 files changed, 358 insertions(+), 266 deletions(-)
 create mode 100644 arch/x86/kernel/pvclock.c
 create mode 100644 include/asm-x86/pvclock-abi.h
 create mode 100644 include/asm-x86/pvclock.h

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.


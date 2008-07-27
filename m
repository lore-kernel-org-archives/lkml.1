Return-Path: <linux-kernel-owner+w=401wt.eu-S1753717AbYG0L4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbYG0L4o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 07:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbYG0L4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 07:56:34 -0400
Received: from il.qumranet.com ([212.179.150.194]:13045 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbYG0L4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 07:56:33 -0400
From: Avi Kivity <avi@qumranet.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] KVM fixes for 2.6.27-rc
Date: Sun, 27 Jul 2008 14:56:32 +0300
Message-Id: <1217159792-30016-1-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from repo & branch at

  git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git kvm-updates-2.6.27

which contains fixes for 2.6.27's KVM.  These include an interrupt injection
fix, corrections for the universally admired x86 hardware task switching
mechanism, making unloading and reloading the vendor specific module
work while changing module parameters, and s390, ppc, and ia64 fixes.

Shortlog/diffstat follow.

Avi Kivity (1):
      KVM: Avoid instruction emulation when event delivery is pending

Carsten Otte (1):
      KVM: s390: Advertise KVM_CAP_USER_MEMORY

Christian Borntraeger (4):
      KVM: s390: Fix guest kconfig
      KVM: s390: Fix program check on interrupt delivery handling
      KVM: s390: Fix instruction naming for lctlg
      KVM: s390: Fix possible host kernel bug on lctl(g) handling

Hollis Blanchard (1):
      KVM: ppc: fix invalidation of large guest pages

Joerg Roedel (1):
      KVM: SVM: allow enabling/disabling NPT by reloading only the architecture module

Julia Lawall (1):
      KVM: ia64: Fix irq disabling leak in error handling code

Marcelo Tosatti (3):
      KVM: task switch: segment base is linear address
      KVM: task switch: use seg regs provided by subarch instead of reading from GDT
      KVM: task switch: translate guest segment limit to virt-extension byte granular field

Martin Schwidefsky (1):
      KVM: s390: Change guestaddr type in gaccess

Sheng Yang (2):
      KVM: VMX: Fix bypass_guest_pf enabling when disable EPT in module parameter
      KVM: VMX: Fix undefined beaviour of EPT after reload kvm-intel.ko

 arch/ia64/kvm/kvm-ia64.c      |    5 +-
 arch/powerpc/kvm/44x_tlb.c    |    5 +-
 arch/powerpc/kvm/emulate.c    |    2 +-
 arch/s390/kvm/gaccess.h       |   62 ++++++++++++-----------
 arch/s390/kvm/intercept.c     |   14 ++++--
 arch/s390/kvm/interrupt.c     |   21 +++-----
 arch/s390/kvm/kvm-s390.c      |    9 +++-
 arch/s390/kvm/sigp.c          |    5 +-
 arch/x86/kvm/mmu.c            |    7 +++
 arch/x86/kvm/svm.c            |   10 +++-
 arch/x86/kvm/vmx.c            |   22 +++++----
 arch/x86/kvm/x86.c            |  109 ++++++++++++++++-------------------------
 drivers/s390/kvm/Makefile     |    2 +-
 include/asm-powerpc/kvm_ppc.h |    3 +-
 include/asm-s390/kvm_host.h   |    4 +-
 include/asm-x86/kvm_host.h    |    1 +
 16 files changed, 143 insertions(+), 138 deletions(-)

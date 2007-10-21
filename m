Return-Path: <linux-kernel-owner+w=401wt.eu-S1753155AbXJULIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbXJULIX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 07:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbXJULHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 07:07:54 -0400
Received: from il.qumranet.com ([82.166.9.18]:58414 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbXJULHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 07:07:53 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/11] KVM updates for Linux 2.6.24-rc review
Date: Sun, 21 Oct 2007 13:08:01 +0200
Message-Id: <1192964892617-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches fix fallout from the main 2.6.24 KVM merge.  An
exception is the movnti emulation patch, which adds support for Linux
2.6.16 guests.

The patches can be found in kvm.git in the branch kvm-updates-2.6.24.
There is also a branch kvm-updates-2.6.25 which will form the basis of
the next merge window submission.

Please review the patches and let me know if something is wrong or if
a patch is missing.


Aurelien Jarno (1):
      KVM: x86 emulator: fix access registers for instructions with ModR/M byte and Mod = 3

Avi Kivity (2):
      KVM: VMX: Handle NMIs before enabling interrupts and preemption
      KVM: VMX: Force vm86 mode if setting flags during real mode

Eddie Dong (1):
      KVM: VMX: Reset mmu context when entering real mode

Izik Eidus (1):
      KVM: MMU: Set shadow pte atomically in mmu_pte_write_zap_pte()

Kevin Pedretti (2):
      KVM: Fix local apic timer divide by zero
      KVM: Improve local apic timer wraparound handling

Laurent Vivier (2):
      KVM: x86 emulator: fix repne/repnz decoding
      KVM: Move kvm_guest_exit() after local_irq_enable()

Nitin A Kamble (1):
      KVM: x86 emulator: fix merge screwup due to emulator split

Sheng Yang (1):
      KVM: x86 emulator: implement 'movnti mem, reg'

 drivers/kvm/kvm_main.c    |   11 ++++++-
 drivers/kvm/lapic.c       |   38 ++++++++++++++++------
 drivers/kvm/mmu.c         |    3 +-
 drivers/kvm/vmx.c         |   16 +++++++--
 drivers/kvm/x86_emulate.c |   77 ++++++++++++++++++++++++++++----------------
 5 files changed, 100 insertions(+), 45 deletions(-)

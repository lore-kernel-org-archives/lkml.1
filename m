Return-Path: <linux-kernel-owner+w=401wt.eu-S1758477AbYAFOkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477AbYAFOkn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:40:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755106AbYAFOjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:39:43 -0500
Received: from il.qumranet.com ([82.166.9.18]:46583 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769AbYAFOjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:39:41 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 00/33] KVM patch queue review for 2.6.25 merge window (part V)
Date: Sun,  6 Jan 2008 16:39:06 +0200
Message-Id: <1199630379-28638-1-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fifth set of kvm updates scheduled for the 2.6.25 merge window.  Please
review.  Diffstat below is for this batch only.

I haven't yet implemented the previous comments, so code that is copied from
previous patches may have the same issue.

 arch/x86/Kconfig                                   |    2 +
 arch/x86/Makefile                                  |    2 +
 {drivers => arch/x86}/kvm/Kconfig                  |    0 
 {drivers => arch/x86}/kvm/Makefile                 |    6 +-
 {drivers => arch/x86}/kvm/i8259.c                  |    3 +-
 {drivers => arch/x86}/kvm/irq.c                    |   23 +-
 arch/x86/kvm/irq.h                                 |   88 +++
 {drivers => arch/x86}/kvm/kvm_svm.h                |    2 +-
 {drivers => arch/x86}/kvm/lapic.c                  |  171 +++--
 arch/x86/kvm/lapic.h                               |   50 ++
 {drivers => arch/x86}/kvm/mmu.c                    |  314 +++++---
 arch/x86/kvm/mmu.h                                 |   44 ++
 {drivers => arch/x86}/kvm/paging_tmpl.h            |   83 ++-
 {drivers => arch/x86}/kvm/segment_descriptor.h     |    0 
 {drivers => arch/x86}/kvm/svm.c                    |  148 ++--
 {drivers => arch/x86}/kvm/svm.h                    |    0 
 {drivers => arch/x86}/kvm/vmx.c                    |  264 ++++----
 {drivers => arch/x86}/kvm/vmx.h                    |    0 
 {drivers => arch/x86}/kvm/x86.c                    |  796 ++++++++++++--------
 {drivers => arch/x86}/kvm/x86_emulate.c            |   29 +-
 drivers/Kconfig                                    |    2 -
 drivers/Makefile                                   |    1 -
 drivers/kvm/irq.h                                  |  182 -----
 drivers/kvm/x86.h => include/asm-x86/kvm_host.h    |  222 ++++--
 .../asm-x86/kvm_x86_emulate.h                      |    0 
 include/linux/kvm.h                                |   26 +
 drivers/kvm/kvm.h => include/linux/kvm_host.h      |  244 +-----
 include/linux/kvm_para.h                           |    2 +
 drivers/kvm/types.h => include/linux/kvm_types.h   |   13 +
 {drivers => virt}/kvm/ioapic.c                     |   25 +-
 virt/kvm/ioapic.h                                  |   95 +++
 {drivers => virt}/kvm/iodev.h                      |    2 +-
 {drivers => virt}/kvm/kvm_main.c                   |   45 +-
 33 files changed, 1661 insertions(+), 1223 deletions(-)

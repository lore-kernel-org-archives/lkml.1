Return-Path: <linux-kernel-owner+w=401wt.eu-S1757879AbYAFOpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879AbYAFOpb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758406AbYAFOkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:40:03 -0500
Received: from il.qumranet.com ([82.166.9.18]:46648 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755895AbYAFOjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:39:47 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 18/33] KVM: Move ioapic code to common directory.
Date: Sun,  6 Jan 2008 16:39:24 +0200
Message-Id: <1199630379-28638-19-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199630379-28638-1-git-send-email-avi@qumranet.com>
References: <1199630379-28638-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Xiantao <xiantao.zhang@intel.com>

Move ioapic code to common, since IA64 also needs it.

Signed-off-by: Zhang Xiantao <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/Makefile           |    7 +++----
 {arch/x86 => virt}/kvm/ioapic.c |    2 +-
 {arch/x86 => virt}/kvm/ioapic.h |    0 
 3 files changed, 4 insertions(+), 5 deletions(-)
 rename {arch/x86 => virt}/kvm/ioapic.c (99%)
 rename {arch/x86 => virt}/kvm/ioapic.h (100%)

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index af41534..ffdd0b3 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -2,12 +2,11 @@
 # Makefile for Kernel-based Virtual Machine module
 #
 
-common-objs = $(addprefix ../../../virt/kvm/, kvm_main.o)
+common-objs = $(addprefix ../../../virt/kvm/, kvm_main.o ioapic.o)
 
-EXTRA_CFLAGS += -I virt/kvm
+EXTRA_CFLAGS += -Ivirt/kvm -Iarch/x86/kvm
 
-kvm-objs := $(common-objs) x86.o mmu.o x86_emulate.o i8259.o irq.o lapic.o \
-	ioapic.o
+kvm-objs := $(common-objs) x86.o mmu.o x86_emulate.o i8259.o irq.o lapic.o
 obj-$(CONFIG_KVM) += kvm.o
 kvm-intel-objs = vmx.o
 obj-$(CONFIG_KVM_INTEL) += kvm-intel.o
diff --git a/arch/x86/kvm/ioapic.c b/virt/kvm/ioapic.c
similarity index 99%
rename from arch/x86/kvm/ioapic.c
rename to virt/kvm/ioapic.c
index 40cd53e..317f8e2 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -363,7 +363,7 @@ static void ioapic_mmio_write(struct kvm_io_device *this, gpa_t addr, int len,
 		break;
 #ifdef	CONFIG_IA64
 	case IOAPIC_REG_EOI:
-		kvm_ioapic_update_eoi(ioapic, data);
+		kvm_ioapic_update_eoi(ioapic->kvm, data);
 		break;
 #endif
 
diff --git a/arch/x86/kvm/ioapic.h b/virt/kvm/ioapic.h
similarity index 100%
rename from arch/x86/kvm/ioapic.h
rename to virt/kvm/ioapic.h
-- 
1.5.3.7


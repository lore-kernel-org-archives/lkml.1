Return-Path: <linux-kernel-owner+w=401wt.eu-S1755104AbZHPJix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbZHPJix (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbZHPJiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:38:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45338 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967AbZHPJaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:11 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 08/48] KVM: cleanup arch/x86/kvm/Makefile
Date: Sun, 16 Aug 2009 12:29:28 +0300
Message-Id: <1250415008-17175-9-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>

Use proper foo-y style list additions to cleanup all the conditionals,
move module selection after compound object selection and remove the
superflous comment.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/Makefile |   32 +++++++++++++-------------------
 1 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index b43c4ef..bee9512 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -1,22 +1,16 @@
-#
-# Makefile for Kernel-based Virtual Machine module
-#
-
-common-objs = $(addprefix ../../../virt/kvm/, kvm_main.o ioapic.o \
-                coalesced_mmio.o irq_comm.o)
-ifeq ($(CONFIG_KVM_TRACE),y)
-common-objs += $(addprefix ../../../virt/kvm/, kvm_trace.o)
-endif
-ifeq ($(CONFIG_IOMMU_API),y)
-common-objs += $(addprefix ../../../virt/kvm/, iommu.o)
-endif
 
 EXTRA_CFLAGS += -Ivirt/kvm -Iarch/x86/kvm
 
-kvm-objs := $(common-objs) x86.o mmu.o x86_emulate.o i8259.o irq.o lapic.o \
-	i8254.o timer.o
-obj-$(CONFIG_KVM) += kvm.o
-kvm-intel-objs = vmx.o
-obj-$(CONFIG_KVM_INTEL) += kvm-intel.o
-kvm-amd-objs = svm.o
-obj-$(CONFIG_KVM_AMD) += kvm-amd.o
+kvm-y			+= $(addprefix ../../../virt/kvm/, kvm_main.o ioapic.o \
+				coalesced_mmio.o irq_comm.o)
+kvm-$(CONFIG_KVM_TRACE)	+= $(addprefix ../../../virt/kvm/, kvm_trace.o)
+kvm-$(CONFIG_IOMMU_API)	+= $(addprefix ../../../virt/kvm/, iommu.o)
+
+kvm-y			+= x86.o mmu.o x86_emulate.o i8259.o irq.o lapic.o \
+			   i8254.o timer.o
+kvm-intel-y		+= vmx.o
+kvm-amd-y		+= svm.o
+
+obj-$(CONFIG_KVM)	+= kvm.o
+obj-$(CONFIG_KVM_INTEL)	+= kvm-intel.o
+obj-$(CONFIG_KVM_AMD)	+= kvm-amd.o
-- 
1.6.3.3


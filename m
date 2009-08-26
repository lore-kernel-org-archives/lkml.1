Return-Path: <linux-kernel-owner+w=401wt.eu-S932477AbZHZKcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477AbZHZKcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932418AbZHZKby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:31:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757132AbZHZKaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:15 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 38/47] KVM: Rename x86_emulate.c to emulate.c
Date: Wed, 26 Aug 2009 13:30:00 +0300
Message-Id: <1251282609-12835-39-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're in arch/x86, what could we possibly be emulating?

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 .../asm/{kvm_x86_emulate.h => kvm_emulate.h}       |    0
 arch/x86/include/asm/kvm_host.h                    |    2 +-
 arch/x86/kvm/Makefile                              |    2 +-
 arch/x86/kvm/{x86_emulate.c => emulate.c}          |    4 ++--
 arch/x86/kvm/x86.c                                 |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)
 rename arch/x86/include/asm/{kvm_x86_emulate.h => kvm_emulate.h} (100%)
 rename arch/x86/kvm/{x86_emulate.c => emulate.c} (99%)

diff --git a/arch/x86/include/asm/kvm_x86_emulate.h b/arch/x86/include/asm/kvm_emulate.h
similarity index 100%
rename from arch/x86/include/asm/kvm_x86_emulate.h
rename to arch/x86/include/asm/kvm_emulate.h
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b17d845..33901be 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -138,7 +138,7 @@ enum {
 	VCPU_SREG_LDTR,
 };
 
-#include <asm/kvm_x86_emulate.h>
+#include <asm/kvm_emulate.h>
 
 #define KVM_NR_MEM_OBJS 40
 
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index afaaa76..0e7fe78 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -9,7 +9,7 @@ kvm-y			+= $(addprefix ../../../virt/kvm/, kvm_main.o ioapic.o \
 				coalesced_mmio.o irq_comm.o eventfd.o)
 kvm-$(CONFIG_IOMMU_API)	+= $(addprefix ../../../virt/kvm/, iommu.o)
 
-kvm-y			+= x86.o mmu.o x86_emulate.o i8259.o irq.o lapic.o \
+kvm-y			+= x86.o mmu.o emulate.o i8259.o irq.o lapic.o \
 			   i8254.o timer.o
 kvm-intel-y		+= vmx.o
 kvm-amd-y		+= svm.o
diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/emulate.c
similarity index 99%
rename from arch/x86/kvm/x86_emulate.c
rename to arch/x86/kvm/emulate.c
index c6663d4..2eb807a 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1,5 +1,5 @@
 /******************************************************************************
- * x86_emulate.c
+ * emulate.c
  *
  * Generic x86 (32-bit and 64-bit) instruction decoder and emulator.
  *
@@ -30,7 +30,7 @@
 #define DPRINTF(x...) do {} while (0)
 #endif
 #include <linux/module.h>
-#include <asm/kvm_x86_emulate.h>
+#include <asm/kvm_emulate.h>
 
 #include "mmu.h"		/* for is_long_mode() */
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1aa7e6d..c0e9427 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2759,7 +2759,7 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 	kvm_clear_exception_queue(vcpu);
 	vcpu->arch.mmio_fault_cr2 = cr2;
 	/*
-	 * TODO: fix x86_emulate.c to use guest_read/write_register
+	 * TODO: fix emulate.c to use guest_read/write_register
 	 * instead of direct ->regs accesses, can save hundred cycles
 	 * on Intel for instructions that don't read/change RSP, for
 	 * for example.
-- 
1.6.4.1


Return-Path: <linux-kernel-owner+w=401wt.eu-S1760197AbYAFOrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760197AbYAFOrv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:47:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758514AbYAFOkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:40:13 -0500
Received: from il.qumranet.com ([82.166.9.18]:46608 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755915AbYAFOjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:39:48 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 15/33] KVM: Move arch dependent files to new directory arch/x86/kvm/
Date: Sun,  6 Jan 2008 16:39:21 +0200
Message-Id: <1199630379-28638-16-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199630379-28638-1-git-send-email-avi@qumranet.com>
References: <1199630379-28638-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This paves the way for multiple architecture support.  Note that while
ioapic.c could potentially be shared with ia64, it is also moved.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/Kconfig                                   |    2 ++
 arch/x86/Makefile                                  |    2 ++
 {drivers => arch/x86}/kvm/Kconfig                  |    0 
 {drivers => arch/x86}/kvm/Makefile                 |    7 ++++++-
 {drivers => arch/x86}/kvm/i8259.c                  |    3 ++-
 {drivers => arch/x86}/kvm/ioapic.c                 |    4 +---
 {drivers => arch/x86}/kvm/irq.c                    |    3 +--
 {drivers => arch/x86}/kvm/irq.h                    |    3 +--
 {drivers => arch/x86}/kvm/kvm_svm.h                |    2 +-
 {drivers => arch/x86}/kvm/lapic.c                  |    4 +---
 {drivers => arch/x86}/kvm/mmu.c                    |    3 +--
 {drivers => arch/x86}/kvm/mmu.h                    |    2 +-
 {drivers => arch/x86}/kvm/paging_tmpl.h            |    0 
 {drivers => arch/x86}/kvm/segment_descriptor.h     |    0 
 {drivers => arch/x86}/kvm/svm.c                    |    4 ++--
 {drivers => arch/x86}/kvm/svm.h                    |    0 
 {drivers => arch/x86}/kvm/vmx.c                    |    4 +---
 {drivers => arch/x86}/kvm/vmx.h                    |    0 
 {drivers => arch/x86}/kvm/x86.c                    |    4 +---
 {drivers => arch/x86}/kvm/x86_emulate.c            |    5 ++---
 drivers/Kconfig                                    |    2 --
 drivers/Makefile                                   |    1 -
 drivers/kvm/iodev.h                                |    2 +-
 drivers/kvm/kvm_main.c                             |    2 +-
 drivers/kvm/x86.h => include/asm-x86/kvm_host.h    |    9 ++++-----
 .../asm-x86/kvm_x86_emulate.h                      |    0 
 drivers/kvm/kvm.h => include/linux/kvm_host.h      |    8 ++++----
 drivers/kvm/types.h => include/linux/kvm_types.h   |    0 
 28 files changed, 35 insertions(+), 41 deletions(-)
 rename {drivers => arch/x86}/kvm/Kconfig (100%)
 rename {drivers => arch/x86}/kvm/Makefile (52%)
 rename {drivers => arch/x86}/kvm/i8259.c (99%)
 rename {drivers => arch/x86}/kvm/ioapic.c (99%)
 rename {drivers => arch/x86}/kvm/irq.c (98%)
 rename {drivers => arch/x86}/kvm/irq.h (99%)
 rename {drivers => arch/x86}/kvm/kvm_svm.h (96%)
 rename {drivers => arch/x86}/kvm/lapic.c (99%)
 rename {drivers => arch/x86}/kvm/mmu.c (99%)
 rename {drivers => arch/x86}/kvm/mmu.h (96%)
 rename {drivers => arch/x86}/kvm/paging_tmpl.h (100%)
 rename {drivers => arch/x86}/kvm/segment_descriptor.h (100%)
 rename {drivers => arch/x86}/kvm/svm.c (99%)
 rename {drivers => arch/x86}/kvm/svm.h (100%)
 rename {drivers => arch/x86}/kvm/vmx.c (99%)
 rename {drivers => arch/x86}/kvm/vmx.h (100%)
 rename {drivers => arch/x86}/kvm/x86.c (99%)
 rename {drivers => arch/x86}/kvm/x86_emulate.c (99%)
 rename drivers/kvm/x86.h => include/asm-x86/kvm_host.h (99%)
 rename drivers/kvm/x86_emulate.h => include/asm-x86/kvm_x86_emulate.h (100%)
 rename drivers/kvm/kvm.h => include/linux/kvm_host.h (98%)
 rename drivers/kvm/types.h => include/linux/kvm_types.h (100%)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e029a93..ab2df55 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1623,4 +1623,6 @@ source "security/Kconfig"
 
 source "crypto/Kconfig"
 
+source "arch/x86/kvm/Kconfig"
+
 source "lib/Kconfig"
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 7aa1dc6..96f79eb 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -17,3 +17,5 @@ else
         UTS_MACHINE := x86_64
         include $(srctree)/arch/x86/Makefile_64
 endif
+
+core-$(CONFIG_KVM) += arch/x86/kvm/
diff --git a/drivers/kvm/Kconfig b/arch/x86/kvm/Kconfig
similarity index 100%
rename from drivers/kvm/Kconfig
rename to arch/x86/kvm/Kconfig
diff --git a/drivers/kvm/Makefile b/arch/x86/kvm/Makefile
similarity index 52%
rename from drivers/kvm/Makefile
rename to arch/x86/kvm/Makefile
index cf18ad4..880ffe4 100644
--- a/drivers/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -2,7 +2,12 @@
 # Makefile for Kernel-based Virtual Machine module
 #
 
-kvm-objs := kvm_main.o x86.o mmu.o x86_emulate.o i8259.o irq.o lapic.o ioapic.o
+common-objs = $(addprefix ../../../drivers/kvm/, kvm_main.o)
+
+EXTRA_CFLAGS += -I drivers/kvm
+
+kvm-objs := $(common-objs) x86.o mmu.o x86_emulate.o i8259.o irq.o lapic.o \
+	ioapic.o
 obj-$(CONFIG_KVM) += kvm.o
 kvm-intel-objs = vmx.o
 obj-$(CONFIG_KVM_INTEL) += kvm-intel.o
diff --git a/drivers/kvm/i8259.c b/arch/x86/kvm/i8259.c
similarity index 99%
rename from drivers/kvm/i8259.c
rename to arch/x86/kvm/i8259.c
index b3cad63..ab29cf2 100644
--- a/drivers/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -27,7 +27,8 @@
  */
 #include <linux/mm.h>
 #include "irq.h"
-#include "kvm.h"
+
+#include <linux/kvm_host.h>
 
 /*
  * set irq level. If an edge is detected, then the IRR is set to 1
diff --git a/drivers/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
similarity index 99%
rename from drivers/kvm/ioapic.c
rename to arch/x86/kvm/ioapic.c
index f823677..72f12f7 100644
--- a/drivers/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -26,9 +26,7 @@
  *  Based on Xen 3.1 code.
  */
 
-#include "kvm.h"
-#include "x86.h"
-
+#include <linux/kvm_host.h>
 #include <linux/kvm.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
diff --git a/drivers/kvm/irq.c b/arch/x86/kvm/irq.c
similarity index 98%
rename from drivers/kvm/irq.c
rename to arch/x86/kvm/irq.c
index 59b47c5..07a09aa 100644
--- a/drivers/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -20,9 +20,8 @@
  */
 
 #include <linux/module.h>
+#include <linux/kvm_host.h>
 
-#include "kvm.h"
-#include "x86.h"
 #include "irq.h"
 
 /*
diff --git a/drivers/kvm/irq.h b/arch/x86/kvm/irq.h
similarity index 99%
rename from drivers/kvm/irq.h
rename to arch/x86/kvm/irq.h
index 6e023dc..6316638 100644
--- a/drivers/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -24,9 +24,8 @@
 
 #include <linux/mm_types.h>
 #include <linux/hrtimer.h>
-#include <asm/kvm.h>
+#include <linux/kvm_host.h>
 #include "iodev.h"
-#include "kvm.h"
 
 struct kvm;
 struct kvm_vcpu;
diff --git a/drivers/kvm/kvm_svm.h b/arch/x86/kvm/kvm_svm.h
similarity index 96%
rename from drivers/kvm/kvm_svm.h
rename to arch/x86/kvm/kvm_svm.h
index a0e415d..ecdfe97 100644
--- a/drivers/kvm/kvm_svm.h
+++ b/arch/x86/kvm/kvm_svm.h
@@ -4,10 +4,10 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/list.h>
+#include <linux/kvm_host.h>
 #include <asm/msr.h>
 
 #include "svm.h"
-#include "kvm.h"
 
 static const u32 host_save_user_msrs[] = {
 #ifdef CONFIG_X86_64
diff --git a/drivers/kvm/lapic.c b/arch/x86/kvm/lapic.c
similarity index 99%
rename from drivers/kvm/lapic.c
rename to arch/x86/kvm/lapic.c
index 8c74bf1..4076331 100644
--- a/drivers/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -17,9 +17,7 @@
  * the COPYING file in the top-level directory.
  */
 
-#include "kvm.h"
-#include "x86.h"
-
+#include <linux/kvm_host.h>
 #include <linux/kvm.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
diff --git a/drivers/kvm/mmu.c b/arch/x86/kvm/mmu.c
similarity index 99%
rename from drivers/kvm/mmu.c
rename to arch/x86/kvm/mmu.c
index c26d83f..401eb7c 100644
--- a/drivers/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -18,10 +18,9 @@
  */
 
 #include "vmx.h"
-#include "kvm.h"
-#include "x86.h"
 #include "mmu.h"
 
+#include <linux/kvm_host.h>
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/mm.h>
diff --git a/drivers/kvm/mmu.h b/arch/x86/kvm/mmu.h
similarity index 96%
rename from drivers/kvm/mmu.h
rename to arch/x86/kvm/mmu.h
index cbfc272..1fce19e 100644
--- a/drivers/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -1,7 +1,7 @@
 #ifndef __KVM_X86_MMU_H
 #define __KVM_X86_MMU_H
 
-#include "kvm.h"
+#include <linux/kvm_host.h>
 
 static inline void kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
 {
diff --git a/drivers/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
similarity index 100%
rename from drivers/kvm/paging_tmpl.h
rename to arch/x86/kvm/paging_tmpl.h
diff --git a/drivers/kvm/segment_descriptor.h b/arch/x86/kvm/segment_descriptor.h
similarity index 100%
rename from drivers/kvm/segment_descriptor.h
rename to arch/x86/kvm/segment_descriptor.h
diff --git a/drivers/kvm/svm.c b/arch/x86/kvm/svm.c
similarity index 99%
rename from drivers/kvm/svm.c
rename to arch/x86/kvm/svm.c
index 35ad96d..745b1ec 100644
--- a/drivers/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -13,9 +13,9 @@
  * the COPYING file in the top-level directory.
  *
  */
-#include "x86.h"
+#include <linux/kvm_host.h>
+
 #include "kvm_svm.h"
-#include "x86_emulate.h"
 #include "irq.h"
 #include "mmu.h"
 
diff --git a/drivers/kvm/svm.h b/arch/x86/kvm/svm.h
similarity index 100%
rename from drivers/kvm/svm.h
rename to arch/x86/kvm/svm.h
diff --git a/drivers/kvm/vmx.c b/arch/x86/kvm/vmx.c
similarity index 99%
rename from drivers/kvm/vmx.c
rename to arch/x86/kvm/vmx.c
index 4407998..20c0f5e 100644
--- a/drivers/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -15,14 +15,12 @@
  *
  */
 
-#include "kvm.h"
-#include "x86.h"
-#include "x86_emulate.h"
 #include "irq.h"
 #include "vmx.h"
 #include "segment_descriptor.h"
 #include "mmu.h"
 
+#include <linux/kvm_host.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
diff --git a/drivers/kvm/vmx.h b/arch/x86/kvm/vmx.h
similarity index 100%
rename from drivers/kvm/vmx.h
rename to arch/x86/kvm/vmx.h
diff --git a/drivers/kvm/x86.c b/arch/x86/kvm/x86.c
similarity index 99%
rename from drivers/kvm/x86.c
rename to arch/x86/kvm/x86.c
index b37c009..5902c5c 100644
--- a/drivers/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -14,9 +14,7 @@
  *
  */
 
-#include "kvm.h"
-#include "x86.h"
-#include "x86_emulate.h"
+#include <linux/kvm_host.h>
 #include "segment_descriptor.h"
 #include "irq.h"
 #include "mmu.h"
diff --git a/drivers/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
similarity index 99%
rename from drivers/kvm/x86_emulate.c
rename to arch/x86/kvm/x86_emulate.c
index 50b133f..7958600 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -25,12 +25,11 @@
 #include <public/xen.h>
 #define DPRINTF(_f, _a ...) printf(_f , ## _a)
 #else
-#include "kvm.h"
-#include "x86.h"
+#include <linux/kvm_host.h>
 #define DPRINTF(x...) do {} while (0)
 #endif
-#include "x86_emulate.h"
 #include <linux/module.h>
+#include <asm/kvm_x86_emulate.h>
 
 /*
  * Opcode effective-address decode tables.
diff --git a/drivers/Kconfig b/drivers/Kconfig
index f4076d9..08d4ae2 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -90,8 +90,6 @@ source "drivers/dca/Kconfig"
 
 source "drivers/auxdisplay/Kconfig"
 
-source "drivers/kvm/Kconfig"
-
 source "drivers/uio/Kconfig"
 
 source "drivers/virtio/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index 8cb37e3..513ae86 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -47,7 +47,6 @@ obj-$(CONFIG_SPI)		+= spi/
 obj-$(CONFIG_PCCARD)		+= pcmcia/
 obj-$(CONFIG_DIO)		+= dio/
 obj-$(CONFIG_SBUS)		+= sbus/
-obj-$(CONFIG_KVM)		+= kvm/
 obj-$(CONFIG_ZORRO)		+= zorro/
 obj-$(CONFIG_MAC)		+= macintosh/
 obj-$(CONFIG_ATA_OVER_ETH)	+= block/aoe/
diff --git a/drivers/kvm/iodev.h b/drivers/kvm/iodev.h
index eb9e8a7..c14e642 100644
--- a/drivers/kvm/iodev.h
+++ b/drivers/kvm/iodev.h
@@ -16,7 +16,7 @@
 #ifndef __KVM_IODEV_H__
 #define __KVM_IODEV_H__
 
-#include "types.h"
+#include <linux/kvm_types.h>
 
 struct kvm_io_device {
 	void (*read)(struct kvm_io_device *this,
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 5bfa200..a5ee518 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -15,9 +15,9 @@
  *
  */
 
-#include "kvm.h"
 #include "iodev.h"
 
+#include <linux/kvm_host.h>
 #include <linux/kvm.h>
 #include <linux/module.h>
 #include <linux/errno.h>
diff --git a/drivers/kvm/x86.h b/include/asm-x86/kvm_host.h
similarity index 99%
rename from drivers/kvm/x86.h
rename to include/asm-x86/kvm_host.h
index dfb8091..28940e1 100644
--- a/drivers/kvm/x86.h
+++ b/include/asm-x86/kvm_host.h
@@ -8,19 +8,18 @@
  *
  */
 
-#ifndef KVM_X86_H
-#define KVM_X86_H
+#ifndef ASM_KVM_HOST_H
+#define ASM_KVM_HOST_H
 
 #include <linux/types.h>
 #include <linux/mm.h>
 
 #include <linux/kvm.h>
 #include <linux/kvm_para.h>
+#include <linux/kvm_types.h>
 
 #include <asm/desc.h>
 
-#include "types.h"
-
 #define CR3_PAE_RESERVED_BITS ((X86_CR3_PWT | X86_CR3_PCD) - 1)
 #define CR3_NONPAE_RESERVED_BITS ((PAGE_SIZE-1) & ~(X86_CR3_PWT | X86_CR3_PCD))
 #define CR3_L_MODE_RESERVED_BITS (CR3_NONPAE_RESERVED_BITS|0xFFFFFF0000000000ULL)
@@ -102,7 +101,7 @@ enum {
 	VCPU_SREG_LDTR,
 };
 
-#include "x86_emulate.h"
+#include <asm/kvm_x86_emulate.h>
 
 #define KVM_NR_MEM_OBJS 40
 
diff --git a/drivers/kvm/x86_emulate.h b/include/asm-x86/kvm_x86_emulate.h
similarity index 100%
rename from drivers/kvm/x86_emulate.h
rename to include/asm-x86/kvm_x86_emulate.h
diff --git a/drivers/kvm/kvm.h b/include/linux/kvm_host.h
similarity index 98%
rename from drivers/kvm/kvm.h
rename to include/linux/kvm_host.h
index bf6a3b3..a85d5b6 100644
--- a/drivers/kvm/kvm.h
+++ b/include/linux/kvm_host.h
@@ -1,5 +1,5 @@
-#ifndef __KVM_H
-#define __KVM_H
+#ifndef __KVM_HOST_H
+#define __KVM_HOST_H
 
 /*
  * This work is licensed under the terms of the GNU GPL, version 2.  See
@@ -20,9 +20,9 @@
 #include <linux/kvm.h>
 #include <linux/kvm_para.h>
 
-#include "types.h"
+#include <linux/kvm_types.h>
 
-#include "x86.h"
+#include <asm/kvm_host.h>
 
 #define KVM_MAX_VCPUS 4
 #define KVM_MEMORY_SLOTS 8
diff --git a/drivers/kvm/types.h b/include/linux/kvm_types.h
similarity index 100%
rename from drivers/kvm/types.h
rename to include/linux/kvm_types.h
-- 
1.5.3.7


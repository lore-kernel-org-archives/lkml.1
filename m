Return-Path: <linux-kernel-owner+w=401wt.eu-S1758626AbYFZMkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626AbYFZMkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754572AbYFZM3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:29:37 -0400
Received: from il.qumranet.com ([212.179.150.194]:32382 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001AbYFZM2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:44 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Laurent Vivier <Laurent.Vivier@bull.net>
Subject: [PATCH 37/50] KVM: Add coalesced MMIO support (ia64 part)
Date: Thu, 26 Jun 2008 15:28:19 +0300
Message-Id: <1214483312-9265-38-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Vivier <Laurent.Vivier@bull.net>

This patch enables coalesced MMIO for ia64 architecture.
It defines KVM_MMIO_PAGE_OFFSET and KVM_CAP_COALESCED_MMIO.
It enables the compilation of coalesced_mmio.c.

[akpm: fix compile error on ia64]

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/ia64/kvm/Makefile      |    3 ++-
 arch/ia64/kvm/kvm-ia64.c    |    3 +++
 include/asm-ia64/kvm_host.h |    1 +
 3 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/kvm/Makefile b/arch/ia64/kvm/Makefile
index 112791d..bf22fb9 100644
--- a/arch/ia64/kvm/Makefile
+++ b/arch/ia64/kvm/Makefile
@@ -43,7 +43,8 @@ $(obj)/$(offsets-file): arch/ia64/kvm/asm-offsets.s
 EXTRA_CFLAGS += -Ivirt/kvm -Iarch/ia64/kvm/
 EXTRA_AFLAGS += -Ivirt/kvm -Iarch/ia64/kvm/
 
-common-objs = $(addprefix ../../../virt/kvm/, kvm_main.o ioapic.o)
+common-objs = $(addprefix ../../../virt/kvm/, kvm_main.o ioapic.o \
+		coalesced_mmio.o)
 
 kvm-objs := $(common-objs) kvm-ia64.o kvm_fw.o
 obj-$(CONFIG_KVM) += kvm.o
diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index b59231b..a4cf4a2 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -187,6 +187,9 @@ int kvm_dev_ioctl_check_extension(long ext)
 
 		r = 1;
 		break;
+	case KVM_CAP_COALESCED_MMIO:
+		r = KVM_COALESCED_MMIO_PAGE_OFFSET;
+		break;
 	default:
 		r = 0;
 	}
diff --git a/include/asm-ia64/kvm_host.h b/include/asm-ia64/kvm_host.h
index 5c958b0..1efe513 100644
--- a/include/asm-ia64/kvm_host.h
+++ b/include/asm-ia64/kvm_host.h
@@ -38,6 +38,7 @@
 /* memory slots that does not exposed to userspace */
 #define KVM_PRIVATE_MEM_SLOTS 4
 
+#define KVM_COALESCED_MMIO_PAGE_OFFSET 1
 
 /* define exit reasons from vmm to kvm*/
 #define EXIT_REASON_VM_PANIC		0
-- 
1.5.6


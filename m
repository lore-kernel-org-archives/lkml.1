Return-Path: <linux-kernel-owner+w=401wt.eu-S1757096AbYIWN7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096AbYIWN7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbYIWNsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:48:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52472 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059AbYIWNsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:48:19 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Jerone Young <jyoung5@us.ibm.com>
Subject: [PATCH 21/40] KVM: ppc: enable KVM_TRACE building for powerpc
Date: Tue, 23 Sep 2008 16:46:35 +0300
Message-Id: <1222177614-26669-22-git-send-email-avi@redhat.com>
In-Reply-To: <1222177614-26669-1-git-send-email-avi@redhat.com>
References: <1222177614-26669-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jerone Young <jyoung5@us.ibm.com>

This patch enables KVM_TRACE to build for PowerPC arch. This means just
adding sections to Kconfig and Makefile.

Signed-off-by: Jerone Young <jyoung5@us.ibm.com>
Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/powerpc/kvm/Kconfig  |   11 +++++++++++
 arch/powerpc/kvm/Makefile |    6 ++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index 6b07601..53aaa66 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -37,6 +37,17 @@ config KVM_BOOKE_HOST
 	  Provides host support for KVM on Book E PowerPC processors. Currently
 	  this works on 440 processors only.
 
+config KVM_TRACE
+	bool "KVM trace support"
+	depends on KVM && MARKERS && SYSFS
+	select RELAY
+	select DEBUG_FS
+	default n
+	---help---
+	  This option allows reading a trace of kvm-related events through
+	  relayfs.  Note the ABI is not considered stable and will be
+	  modified in future updates.
+
 source drivers/virtio/Kconfig
 
 endif # VIRTUALIZATION
diff --git a/arch/powerpc/kvm/Makefile b/arch/powerpc/kvm/Makefile
index 04e3449..2a5d439 100644
--- a/arch/powerpc/kvm/Makefile
+++ b/arch/powerpc/kvm/Makefile
@@ -4,9 +4,11 @@
 
 EXTRA_CFLAGS += -Ivirt/kvm -Iarch/powerpc/kvm
 
-common-objs = $(addprefix ../../../virt/kvm/, kvm_main.o coalesced_mmio.o)
+common-objs-y = $(addprefix ../../../virt/kvm/, kvm_main.o coalesced_mmio.o)
 
-kvm-objs := $(common-objs) powerpc.o emulate.o booke_guest.o
+common-objs-$(CONFIG_KVM_TRACE)  += $(addprefix ../../../virt/kvm/, kvm_trace.o)
+
+kvm-objs := $(common-objs-y) powerpc.o emulate.o booke_guest.o
 obj-$(CONFIG_KVM) += kvm.o
 
 AFLAGS_booke_interrupts.o := -I$(obj)
-- 
1.6.0.1


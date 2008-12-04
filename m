Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbYLDR3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbYLDR3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:29:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754738AbYLDR3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:29:11 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:2333 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629AbYLDR3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:29:09 -0500
X-BigFish: VPS7(z1033izzzzz2b68kz32i43j67h)
X-Spam-TCS-SCL: 6:0
X-WSS-ID: 0KBD4K5-03-CR5-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 01/11] KVM: rename vtd.c to iommu.c
Date: Thu, 4 Dec 2008 18:28:46 +0100
Message-ID: <1228411736-22644-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <20081204172142.GH12816@amd.com>
References: <20081204172142.GH12816@amd.com>
X-OriginalArrivalTime: 04 Dec 2008 17:28:56.0600 (UTC) FILETIME=[C9394980:01C95635]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: file renamed

The code in the vtd.c file can be reused for other IOMMUs as well. So
rename it to make it clear that it handle more than VT-d.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/ia64/kvm/Makefile      |    2 +-
 arch/x86/kvm/Makefile       |    2 +-
 virt/kvm/{vtd.c => iommu.c} |    0 
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename virt/kvm/{vtd.c => iommu.c} (100%)

diff --git a/arch/ia64/kvm/Makefile b/arch/ia64/kvm/Makefile
index 76464dc..cb69dfc 100644
--- a/arch/ia64/kvm/Makefile
+++ b/arch/ia64/kvm/Makefile
@@ -52,7 +52,7 @@ common-objs = $(addprefix ../../../virt/kvm/, kvm_main.o ioapic.o \
 		coalesced_mmio.o irq_comm.o)
 
 ifeq ($(CONFIG_DMAR),y)
-common-objs += $(addprefix ../../../virt/kvm/, vtd.o)
+common-objs += $(addprefix ../../../virt/kvm/, iommu.o)
 endif
 
 kvm-objs := $(common-objs) kvm-ia64.o kvm_fw.o
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index c023435..00f46c2 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -8,7 +8,7 @@ ifeq ($(CONFIG_KVM_TRACE),y)
 common-objs += $(addprefix ../../../virt/kvm/, kvm_trace.o)
 endif
 ifeq ($(CONFIG_DMAR),y)
-common-objs += $(addprefix ../../../virt/kvm/, vtd.o)
+common-objs += $(addprefix ../../../virt/kvm/, iommu.o)
 endif
 
 EXTRA_CFLAGS += -Ivirt/kvm -Iarch/x86/kvm
diff --git a/virt/kvm/vtd.c b/virt/kvm/iommu.c
similarity index 100%
rename from virt/kvm/vtd.c
rename to virt/kvm/iommu.c
-- 
1.5.6.4



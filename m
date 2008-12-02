Return-Path: <linux-kernel-owner+w=401wt.eu-S1755110AbYLBNDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbYLBNDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 08:03:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754251AbYLBNBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 08:01:41 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:54451 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121AbYLBNBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 08:01:38 -0500
X-BigFish: VPS7(z1033izzzzz2b68kz32i43j67h)
X-Spam-TCS-SCL: 6:0
X-WSS-ID: 0KB92UA-04-VCI-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Alexander Graf <agraf@suse.de>,
       Han Weidong <weidong.han@intel.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 03/12] KVM: rename vtd.c to iommu.c
Date: Tue, 2 Dec 2008 14:01:14 +0100
Message-ID: <1228222883-17207-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1228222883-17207-1-git-send-email-joerg.roedel@amd.com>
References: <1228222883-17207-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 02 Dec 2008 13:01:23.0831 (UTC) FILETIME=[1433A070:01C9547E]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impace: file renamed

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



Return-Path: <linux-kernel-owner+w=401wt.eu-S932459AbZHZKb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459AbZHZKb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932403AbZHZKbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:31:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757140AbZHZKaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:15 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 47/47] KVM: Document KVM_CAP_IRQCHIP
Date: Wed, 26 Aug 2009 13:30:09 +0300
Message-Id: <1251282609-12835-48-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 Documentation/kvm/api.txt |   76 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 76 insertions(+), 0 deletions(-)

diff --git a/Documentation/kvm/api.txt b/Documentation/kvm/api.txt
index 1b1c22d..5a4bc8c 100644
--- a/Documentation/kvm/api.txt
+++ b/Documentation/kvm/api.txt
@@ -517,6 +517,82 @@ struct kvm_fpu {
 	__u32 pad2;
 };
 
+4.23 KVM_CREATE_IRQCHIP
+
+Capability: KVM_CAP_IRQCHIP
+Architectures: x86, ia64
+Type: vm ioctl
+Parameters: none
+Returns: 0 on success, -1 on error
+
+Creates an interrupt controller model in the kernel.  On x86, creates a virtual
+ioapic, a virtual PIC (two PICs, nested), and sets up future vcpus to have a
+local APIC.  IRQ routing for GSIs 0-15 is set to both PIC and IOAPIC; GSI 16-23
+only go to the IOAPIC.  On ia64, a IOSAPIC is created.
+
+4.24 KVM_IRQ_LINE
+
+Capability: KVM_CAP_IRQCHIP
+Architectures: x86, ia64
+Type: vm ioctl
+Parameters: struct kvm_irq_level
+Returns: 0 on success, -1 on error
+
+Sets the level of a GSI input to the interrupt controller model in the kernel.
+Requires that an interrupt controller model has been previously created with
+KVM_CREATE_IRQCHIP.  Note that edge-triggered interrupts require the level
+to be set to 1 and then back to 0.
+
+struct kvm_irq_level {
+	union {
+		__u32 irq;     /* GSI */
+		__s32 status;  /* not used for KVM_IRQ_LEVEL */
+	};
+	__u32 level;           /* 0 or 1 */
+};
+
+4.25 KVM_GET_IRQCHIP
+
+Capability: KVM_CAP_IRQCHIP
+Architectures: x86, ia64
+Type: vm ioctl
+Parameters: struct kvm_irqchip (in/out)
+Returns: 0 on success, -1 on error
+
+Reads the state of a kernel interrupt controller created with
+KVM_CREATE_IRQCHIP into a buffer provided by the caller.
+
+struct kvm_irqchip {
+	__u32 chip_id;  /* 0 = PIC1, 1 = PIC2, 2 = IOAPIC */
+	__u32 pad;
+        union {
+		char dummy[512];  /* reserving space */
+		struct kvm_pic_state pic;
+		struct kvm_ioapic_state ioapic;
+	} chip;
+};
+
+4.26 KVM_SET_IRQCHIP
+
+Capability: KVM_CAP_IRQCHIP
+Architectures: x86, ia64
+Type: vm ioctl
+Parameters: struct kvm_irqchip (in)
+Returns: 0 on success, -1 on error
+
+Sets the state of a kernel interrupt controller created with
+KVM_CREATE_IRQCHIP from a buffer provided by the caller.
+
+struct kvm_irqchip {
+	__u32 chip_id;  /* 0 = PIC1, 1 = PIC2, 2 = IOAPIC */
+	__u32 pad;
+        union {
+		char dummy[512];  /* reserving space */
+		struct kvm_pic_state pic;
+		struct kvm_ioapic_state ioapic;
+	} chip;
+};
+
 5. The kvm_run structure
 
 Application code obtains a pointer to the kvm_run structure by
-- 
1.6.4.1


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758937AbZB0KdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758937AbZB0KdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:33:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756957AbZB0K1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:27:45 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53594 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756223AbZB0K1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:27:11 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 37/37] KVM: Avoid using CONFIG_ in userspace visible headers
Date: Fri, 27 Feb 2009 12:27:00 +0200
Message-Id: <1235730420-7929-38-git-send-email-avi@redhat.com>
In-Reply-To: <1235730420-7929-1-git-send-email-avi@redhat.com>
References: <1235730420-7929-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kconfig symbols are not available in userspace, and are not stripped by
headers-install.  Avoid their use by adding #defines in <asm/kvm.h> to
suit each architecture.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm.h |    1 +
 include/linux/kvm.h        |    6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm.h b/arch/x86/include/asm/kvm.h
index 54bcf22..dc3f6cf 100644
--- a/arch/x86/include/asm/kvm.h
+++ b/arch/x86/include/asm/kvm.h
@@ -15,6 +15,7 @@
 #define __KVM_HAVE_DEVICE_ASSIGNMENT
 #define __KVM_HAVE_MSI
 #define __KVM_HAVE_USER_NMI
+#define __KVM_HAVE_GUEST_DEBUG
 
 /* Architectural interrupt line count. */
 #define KVM_NR_INTERRUPTS 256
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 7a5d73a..869462c 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -393,13 +393,13 @@ struct kvm_trace_rec {
 #ifdef __KVM_HAVE_USER_NMI
 #define KVM_CAP_USER_NMI 22
 #endif
-#if defined(CONFIG_X86)
+#ifdef __KVM_HAVE_GUEST_DEBUG
 #define KVM_CAP_SET_GUEST_DEBUG 23
 #endif
-#if defined(CONFIG_X86)
+#ifdef __KVM_HAVE_PIT
 #define KVM_CAP_REINJECT_CONTROL 24
 #endif
-#if defined(CONFIG_X86)||defined(CONFIG_IA64)
+#ifdef __KVM_HAVE_IOAPIC
 #define KVM_CAP_IRQ_ROUTING 25
 #endif
 
-- 
1.6.0.6


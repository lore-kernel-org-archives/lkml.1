Return-Path: <linux-kernel-owner+w=401wt.eu-S1755834AbYIWNxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbYIWNxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753672AbYIWNrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:47:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52385 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbYIWNr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:47:27 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 03/40] KVM: Move KVM TRACE DEFINITIONS to common header
Date: Tue, 23 Sep 2008 16:46:17 +0300
Message-Id: <1222177614-26669-4-git-send-email-avi@redhat.com>
In-Reply-To: <1222177614-26669-1-git-send-email-avi@redhat.com>
References: <1222177614-26669-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

Move KVM trace definitions from x86 specific kvm headers to common kvm
headers to create a cross-architecture numbering scheme for trace
events. This means the kvmtrace_format userspace tool won't need to know
which architecture produced the log file being processed.

Signed-off-by: Jerone Young <jyoung5@us.ibm.com>
Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/asm-x86/kvm.h      |   22 ----------------------
 include/asm-x86/kvm_host.h |   18 ------------------
 include/linux/kvm.h        |   21 +++++++++++++++++++++
 include/linux/kvm_host.h   |   19 +++++++++++++++++++
 4 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/include/asm-x86/kvm.h b/include/asm-x86/kvm.h
index 6f18408..8f13749 100644
--- a/include/asm-x86/kvm.h
+++ b/include/asm-x86/kvm.h
@@ -208,26 +208,4 @@ struct kvm_pit_channel_state {
 struct kvm_pit_state {
 	struct kvm_pit_channel_state channels[3];
 };
-
-#define KVM_TRC_INJ_VIRQ         (KVM_TRC_HANDLER + 0x02)
-#define KVM_TRC_REDELIVER_EVT    (KVM_TRC_HANDLER + 0x03)
-#define KVM_TRC_PEND_INTR        (KVM_TRC_HANDLER + 0x04)
-#define KVM_TRC_IO_READ          (KVM_TRC_HANDLER + 0x05)
-#define KVM_TRC_IO_WRITE         (KVM_TRC_HANDLER + 0x06)
-#define KVM_TRC_CR_READ          (KVM_TRC_HANDLER + 0x07)
-#define KVM_TRC_CR_WRITE         (KVM_TRC_HANDLER + 0x08)
-#define KVM_TRC_DR_READ          (KVM_TRC_HANDLER + 0x09)
-#define KVM_TRC_DR_WRITE         (KVM_TRC_HANDLER + 0x0A)
-#define KVM_TRC_MSR_READ         (KVM_TRC_HANDLER + 0x0B)
-#define KVM_TRC_MSR_WRITE        (KVM_TRC_HANDLER + 0x0C)
-#define KVM_TRC_CPUID            (KVM_TRC_HANDLER + 0x0D)
-#define KVM_TRC_INTR             (KVM_TRC_HANDLER + 0x0E)
-#define KVM_TRC_NMI              (KVM_TRC_HANDLER + 0x0F)
-#define KVM_TRC_VMMCALL          (KVM_TRC_HANDLER + 0x10)
-#define KVM_TRC_HLT              (KVM_TRC_HANDLER + 0x11)
-#define KVM_TRC_CLTS             (KVM_TRC_HANDLER + 0x12)
-#define KVM_TRC_LMSW             (KVM_TRC_HANDLER + 0x13)
-#define KVM_TRC_APIC_ACCESS      (KVM_TRC_HANDLER + 0x14)
-#define KVM_TRC_TDP_FAULT        (KVM_TRC_HANDLER + 0x15)
-
 #endif
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index 6187a1c..b016fef 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -691,24 +691,6 @@ enum {
 	TASK_SWITCH_GATE = 3,
 };
 
-#define KVMTRACE_5D(evt, vcpu, d1, d2, d3, d4, d5, name) \
-	trace_mark(kvm_trace_##name, "%u %p %u %u %u %u %u %u", KVM_TRC_##evt, \
-						vcpu, 5, d1, d2, d3, d4, d5)
-#define KVMTRACE_4D(evt, vcpu, d1, d2, d3, d4, name) \
-	trace_mark(kvm_trace_##name, "%u %p %u %u %u %u %u %u", KVM_TRC_##evt, \
-						vcpu, 4, d1, d2, d3, d4, 0)
-#define KVMTRACE_3D(evt, vcpu, d1, d2, d3, name) \
-	trace_mark(kvm_trace_##name, "%u %p %u %u %u %u %u %u", KVM_TRC_##evt, \
-						vcpu, 3, d1, d2, d3, 0, 0)
-#define KVMTRACE_2D(evt, vcpu, d1, d2, name) \
-	trace_mark(kvm_trace_##name, "%u %p %u %u %u %u %u %u", KVM_TRC_##evt, \
-						vcpu, 2, d1, d2, 0, 0, 0)
-#define KVMTRACE_1D(evt, vcpu, d1, name) \
-	trace_mark(kvm_trace_##name, "%u %p %u %u %u %u %u %u", KVM_TRC_##evt, \
-						vcpu, 1, d1, 0, 0, 0, 0)
-#define KVMTRACE_0D(evt, vcpu, name) \
-	trace_mark(kvm_trace_##name, "%u %p %u %u %u %u %u %u", KVM_TRC_##evt, \
-						vcpu, 0, 0, 0, 0, 0, 0)
 
 #ifdef CONFIG_64BIT
 # define KVM_EX_ENTRY ".quad"
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 70a3065..8a3cead 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -440,4 +440,25 @@ struct kvm_trace_rec {
 #define KVM_GET_MP_STATE          _IOR(KVMIO,  0x98, struct kvm_mp_state)
 #define KVM_SET_MP_STATE          _IOW(KVMIO,  0x99, struct kvm_mp_state)
 
+#define KVM_TRC_INJ_VIRQ         (KVM_TRC_HANDLER + 0x02)
+#define KVM_TRC_REDELIVER_EVT    (KVM_TRC_HANDLER + 0x03)
+#define KVM_TRC_PEND_INTR        (KVM_TRC_HANDLER + 0x04)
+#define KVM_TRC_IO_READ          (KVM_TRC_HANDLER + 0x05)
+#define KVM_TRC_IO_WRITE         (KVM_TRC_HANDLER + 0x06)
+#define KVM_TRC_CR_READ          (KVM_TRC_HANDLER + 0x07)
+#define KVM_TRC_CR_WRITE         (KVM_TRC_HANDLER + 0x08)
+#define KVM_TRC_DR_READ          (KVM_TRC_HANDLER + 0x09)
+#define KVM_TRC_DR_WRITE         (KVM_TRC_HANDLER + 0x0A)
+#define KVM_TRC_MSR_READ         (KVM_TRC_HANDLER + 0x0B)
+#define KVM_TRC_MSR_WRITE        (KVM_TRC_HANDLER + 0x0C)
+#define KVM_TRC_CPUID            (KVM_TRC_HANDLER + 0x0D)
+#define KVM_TRC_INTR             (KVM_TRC_HANDLER + 0x0E)
+#define KVM_TRC_NMI              (KVM_TRC_HANDLER + 0x0F)
+#define KVM_TRC_VMMCALL          (KVM_TRC_HANDLER + 0x10)
+#define KVM_TRC_HLT              (KVM_TRC_HANDLER + 0x11)
+#define KVM_TRC_CLTS             (KVM_TRC_HANDLER + 0x12)
+#define KVM_TRC_LMSW             (KVM_TRC_HANDLER + 0x13)
+#define KVM_TRC_APIC_ACCESS      (KVM_TRC_HANDLER + 0x14)
+#define KVM_TRC_TDP_FAULT        (KVM_TRC_HANDLER + 0x15)
+
 #endif
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8525afc..a18aaad 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -326,6 +326,25 @@ struct kvm_stats_debugfs_item {
 extern struct kvm_stats_debugfs_item debugfs_entries[];
 extern struct dentry *kvm_debugfs_dir;
 
+#define KVMTRACE_5D(evt, vcpu, d1, d2, d3, d4, d5, name) \
+	trace_mark(kvm_trace_##name, "%u %p %u %u %u %u %u %u", KVM_TRC_##evt, \
+						vcpu, 5, d1, d2, d3, d4, d5)
+#define KVMTRACE_4D(evt, vcpu, d1, d2, d3, d4, name) \
+	trace_mark(kvm_trace_##name, "%u %p %u %u %u %u %u %u", KVM_TRC_##evt, \
+						vcpu, 4, d1, d2, d3, d4, 0)
+#define KVMTRACE_3D(evt, vcpu, d1, d2, d3, name) \
+	trace_mark(kvm_trace_##name, "%u %p %u %u %u %u %u %u", KVM_TRC_##evt, \
+						vcpu, 3, d1, d2, d3, 0, 0)
+#define KVMTRACE_2D(evt, vcpu, d1, d2, name) \
+	trace_mark(kvm_trace_##name, "%u %p %u %u %u %u %u %u", KVM_TRC_##evt, \
+						vcpu, 2, d1, d2, 0, 0, 0)
+#define KVMTRACE_1D(evt, vcpu, d1, name) \
+	trace_mark(kvm_trace_##name, "%u %p %u %u %u %u %u %u", KVM_TRC_##evt, \
+						vcpu, 1, d1, 0, 0, 0, 0)
+#define KVMTRACE_0D(evt, vcpu, name) \
+	trace_mark(kvm_trace_##name, "%u %p %u %u %u %u %u %u", KVM_TRC_##evt, \
+						vcpu, 0, 0, 0, 0, 0, 0)
+
 #ifdef CONFIG_KVM_TRACE
 int kvm_trace_ioctl(unsigned int ioctl, unsigned long arg);
 void kvm_trace_cleanup(void);
-- 
1.6.0.1


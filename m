Return-Path: <linux-kernel-owner+w=401wt.eu-S1757466AbYLIUhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466AbYLIUhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:37:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755509AbYLIUYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:24:33 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34867 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754804AbYLIUXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:11 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 23/44] x86: cpu_emergency_vmxoff() function
Date: Tue,  9 Dec 2008 22:22:38 +0200
Message-Id: <1228854179-23002-24-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduardo Habkost <ehabkost@redhat.com>

Add cpu_emergency_vmxoff() and its friends: cpu_vmx_enabled() and
__cpu_emergency_vmxoff().

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/virtext.h |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
index 7dee5b5..6bcf0ac 100644
--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -43,4 +43,27 @@ static inline void cpu_vmxoff(void)
 	write_cr4(read_cr4() & ~X86_CR4_VMXE);
 }
 
+static inline int cpu_vmx_enabled(void)
+{
+	return read_cr4() & X86_CR4_VMXE;
+}
+
+/** Disable VMX if it is enabled on the current CPU
+ *
+ * You shouldn't call this if cpu_has_vmx() returns 0.
+ */
+static inline void __cpu_emergency_vmxoff(void)
+{
+	if (cpu_vmx_enabled())
+		cpu_vmxoff();
+}
+
+/** Disable VMX if it is supported and enabled on the current CPU
+ */
+static inline void cpu_emergency_vmxoff(void)
+{
+	if (cpu_has_vmx())
+		__cpu_emergency_vmxoff();
+}
+
 #endif /* _ASM_X86_VIRTEX_H */
-- 
1.6.0.3


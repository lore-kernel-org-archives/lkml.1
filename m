Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbYKMRp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbYKMRp6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 12:45:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbYKMRpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 12:45:15 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37268 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946AbYKMRpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 12:45:13 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Zachary Amsden <zach@vmware.com>,
       kexec@lists.infradead.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 05/11] x86: cpu_emergency_vmxoff() function
Date: Thu, 13 Nov 2008 15:43:45 -0200
Message-Id: <1226598231-18311-6-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1226598231-18311-1-git-send-email-ehabkost@redhat.com>
References: <1226598231-18311-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add cpu_emergency_vmxoff() and its friends: cpu_vmx_enabled() and
__cpu_emergency_vmxoff().

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/x86/include/asm/virtext.h |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
index 475fb17..2d090f3 100644
--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -58,4 +58,27 @@ static inline void cpu_vmxoff(void)
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
+/** Disable VMX if it is supportd and enabled on the current CPU
+ */
+static inline void cpu_emergency_vmxoff(void)
+{
+	if (cpu_has_vmx())
+		__cpu_emergency_vmxoff();
+}
+
 #endif /* _ASM_X86_VIRTEX_H */
-- 
1.5.5.GIT


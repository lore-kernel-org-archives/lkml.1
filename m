Return-Path: <linux-kernel-owner+w=401wt.eu-S1751466AbZERJkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466AbZERJkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754869AbZERJY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:24:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38437 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754692AbZERJXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:11 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 40/43] KVM: VMX: Zero ept module parameter if ept is not present
Date: Mon, 18 May 2009 12:23:02 +0300
Message-Id: <1242638585-18470-41-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows reading back hardware capability.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 9b97c8e..2f65120 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -265,7 +265,7 @@ static inline int cpu_has_vmx_ept(void)
 
 static inline int vm_need_ept(void)
 {
-	return (cpu_has_vmx_ept() && enable_ept);
+	return enable_ept;
 }
 
 static inline int vm_need_virtualize_apic_accesses(struct kvm *kvm)
@@ -1205,6 +1205,9 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf)
 	if (!cpu_has_vmx_vpid())
 		enable_vpid = 0;
 
+	if (!cpu_has_vmx_ept())
+		enable_ept = 0;
+
 	min = 0;
 #ifdef CONFIG_X86_64
 	min |= VM_EXIT_HOST_ADDR_SPACE_SIZE;
-- 
1.6.0.6


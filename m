Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbZETLTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbZETLTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbZETLSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:18:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55252 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083AbZETLSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:46 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 01/46] KVM: VMX: Make flexpriority module parameter reflect hardware capability
Date: Wed, 20 May 2009 14:17:58 +0300
Message-Id: <1242818323-10413-2-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the hardware does not support flexpriority, zero the module parameter.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index b9e06b0..37ae13d 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -237,9 +237,7 @@ static inline int cpu_has_secondary_exec_ctrls(void)
 
 static inline bool cpu_has_vmx_virtualize_apic_accesses(void)
 {
-	return flexpriority_enabled
-		&& (vmcs_config.cpu_based_2nd_exec_ctrl &
-		    SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES);
+	return flexpriority_enabled;
 }
 
 static inline int cpu_has_vmx_invept_individual_addr(void)
@@ -1203,6 +1201,9 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf)
 	if (!cpu_has_vmx_ept())
 		enable_ept = 0;
 
+	if (!(vmcs_config.cpu_based_2nd_exec_ctrl & SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES))
+		flexpriority_enabled = 0;
+
 	min = 0;
 #ifdef CONFIG_X86_64
 	min |= VM_EXIT_HOST_ADDR_SPACE_SIZE;
-- 
1.6.0.6


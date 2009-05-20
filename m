Return-Path: <linux-kernel-owner+w=401wt.eu-S1759423AbZETLbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759423AbZETLbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757164AbZETLVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:21:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55262 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755025AbZETLSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:47 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 09/46] KVM: VMX: Fix feature testing
Date: Wed, 20 May 2009 14:18:06 +0300
Message-Id: <1242818323-10413-10-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

The testing of feature is too early now, before vmcs_config complete initialization.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 1caa1fc..7d7b0d6 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1208,15 +1208,6 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf)
 		      vmx_capability.ept, vmx_capability.vpid);
 	}
 
-	if (!cpu_has_vmx_vpid())
-		enable_vpid = 0;
-
-	if (!cpu_has_vmx_ept())
-		enable_ept = 0;
-
-	if (!cpu_has_vmx_flexpriority())
-		flexpriority_enabled = 0;
-
 	min = 0;
 #ifdef CONFIG_X86_64
 	min |= VM_EXIT_HOST_ADDR_SPACE_SIZE;
@@ -1320,6 +1311,15 @@ static __init int hardware_setup(void)
 	if (boot_cpu_has(X86_FEATURE_NX))
 		kvm_enable_efer_bits(EFER_NX);
 
+	if (!cpu_has_vmx_vpid())
+		enable_vpid = 0;
+
+	if (!cpu_has_vmx_ept())
+		enable_ept = 0;
+
+	if (!cpu_has_vmx_flexpriority())
+		flexpriority_enabled = 0;
+
 	return alloc_kvm_area();
 }
 
-- 
1.6.0.6


Return-Path: <linux-kernel-owner+w=401wt.eu-S1762131AbYDCTk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762131AbYDCTk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761148AbYDCTdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:33:19 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:39116
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760335AbYDCTdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:33:01 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 33/35] KVM: VMX: Add module option to disable flexpriority
Date: Thu,  3 Apr 2008 22:32:48 +0300
Message-Id: <1207251170-5013-34-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1207251170-5013-1-git-send-email-avi@qumranet.com>
References: <1207251170-5013-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Useful for debugging.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/vmx.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index fb0389d..0155931 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -39,6 +39,9 @@ module_param(bypass_guest_pf, bool, 0);
 static int enable_vpid = 1;
 module_param(enable_vpid, bool, 0);
 
+static int flexpriority_enabled = 1;
+module_param(flexpriority_enabled, bool, 0);
+
 struct vmcs {
 	u32 revision_id;
 	u32 abort;
@@ -200,8 +203,9 @@ static inline int cpu_has_secondary_exec_ctrls(void)
 
 static inline bool cpu_has_vmx_virtualize_apic_accesses(void)
 {
-	return (vmcs_config.cpu_based_2nd_exec_ctrl &
-		SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES);
+	return flexpriority_enabled
+		&& (vmcs_config.cpu_based_2nd_exec_ctrl &
+		    SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES);
 }
 
 static inline int vm_need_virtualize_apic_accesses(struct kvm *kvm)
-- 
1.5.4.5


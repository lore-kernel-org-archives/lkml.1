Return-Path: <linux-kernel-owner+w=401wt.eu-S1757574AbZERJl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574AbZERJl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754782AbZERJZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:25:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38436 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754629AbZERJXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:11 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 39/43] KVM: VMX: Zero the vpid module parameter if vpid is not supported
Date: Mon, 18 May 2009 12:23:01 +0300
Message-Id: <1242638585-18470-40-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows reading back how the hardware is configured.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index f4b6c4b..9b97c8e 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1202,6 +1202,9 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf)
 		      vmx_capability.ept, vmx_capability.vpid);
 	}
 
+	if (!cpu_has_vmx_vpid())
+		enable_vpid = 0;
+
 	min = 0;
 #ifdef CONFIG_X86_64
 	min |= VM_EXIT_HOST_ADDR_SPACE_SIZE;
@@ -2082,7 +2085,7 @@ static void allocate_vpid(struct vcpu_vmx *vmx)
 	int vpid;
 
 	vmx->vpid = 0;
-	if (!enable_vpid || !cpu_has_vmx_vpid())
+	if (!enable_vpid)
 		return;
 	spin_lock(&vmx_vpid_lock);
 	vpid = find_first_zero_bit(vmx_vpid_bitmap, VMX_NR_VPIDS);
-- 
1.6.0.6


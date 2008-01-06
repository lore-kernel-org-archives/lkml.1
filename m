Return-Path: <linux-kernel-owner+w=401wt.eu-S1758524AbYAFOqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524AbYAFOqi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:46:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbYAFOkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:40:06 -0500
Received: from il.qumranet.com ([82.166.9.18]:46609 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755949AbYAFOjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:39:48 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 23/33] KVM: Print data for unimplemented wrmsr
Date: Sun,  6 Jan 2008 16:39:29 +0200
Message-Id: <1199630379-28638-24-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199630379-28638-1-git-send-email-avi@qumranet.com>
References: <1199630379-28638-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This can help diagnosing what the guest is trying to do.  In many cases
we can get away with partial emulation of msrs.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fa9e42c..513258c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -499,7 +499,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		vcpu->arch.ia32_misc_enable_msr = data;
 		break;
 	default:
-		pr_unimpl(vcpu, "unhandled wrmsr: 0x%x\n", msr);
+		pr_unimpl(vcpu, "unhandled wrmsr: 0x%x data %llx\n", msr, data);
 		return 1;
 	}
 	return 0;
-- 
1.5.3.7


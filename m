Return-Path: <linux-kernel-owner+w=401wt.eu-S933520AbZHWMHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933520AbZHWMHQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 08:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933527AbZHWMGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 08:06:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933524AbZHWL4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:48 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/46] KVM: handle AMD microcode MSR
Date: Sun, 23 Aug 2009 14:56:08 +0300
Message-Id: <1251028605-31977-10-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andre Przywara <andre.przywara@amd.com>

Windows 7 tries to update the CPU's microcode on some processors,
so we ignore the MSR write here. The patchlevel register is already handled
(returning 0), because the MSR number is the same as Intel's.

Signed-off-by: Andre Przywara <andre.przywara@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a50c832..6dde99c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -861,6 +861,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 	case MSR_IA32_UCODE_REV:
 	case MSR_IA32_UCODE_WRITE:
 	case MSR_VM_HSAVE_PA:
+	case MSR_AMD64_PATCH_LOADER:
 		break;
 	case 0x200 ... 0x2ff:
 		return set_msr_mtrr(vcpu, msr, data);
-- 
1.6.4.1


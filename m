Return-Path: <linux-kernel-owner+w=401wt.eu-S1759425AbZEXP6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425AbZEXP6V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 11:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758698AbZEXPxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:53:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41843 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754572AbZEXPue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:34 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 18/45] KVM: Fix cpuid feature misreporting
Date: Sun, 24 May 2009 18:50:03 +0300
Message-Id: <1243180230-2480-19-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MTRR, PAT, MCE, and MCA are all supported (to some extent) but not reported.
Vista requires these features, so if userspace relies on kernel cpuid
reporting, it loses support for Vista.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 308d8e9..a403df1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1250,9 +1250,12 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		bit(X86_FEATURE_VME) | bit(X86_FEATURE_DE) |
 		bit(X86_FEATURE_PSE) | bit(X86_FEATURE_TSC) |
 		bit(X86_FEATURE_MSR) | bit(X86_FEATURE_PAE) |
+		bit(X86_FEATURE_MCE) |
 		bit(X86_FEATURE_CX8) | bit(X86_FEATURE_APIC) |
-		bit(X86_FEATURE_SEP) | bit(X86_FEATURE_PGE) |
-		bit(X86_FEATURE_CMOV) | bit(X86_FEATURE_PSE36) |
+		bit(X86_FEATURE_SEP) | bit(X86_FEATURE_MTRR) |
+		bit(X86_FEATURE_PGE) | bit(X86_FEATURE_MCA) |
+		bit(X86_FEATURE_CMOV) | bit(X86_FEATURE_PAT) |
+		bit(X86_FEATURE_PSE36) |
 		bit(X86_FEATURE_CLFLSH) | bit(X86_FEATURE_MMX) |
 		bit(X86_FEATURE_FXSR) | bit(X86_FEATURE_XMM) |
 		bit(X86_FEATURE_XMM2) | bit(X86_FEATURE_SELFSNOOP);
-- 
1.6.0.6


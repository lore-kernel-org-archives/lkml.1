Return-Path: <linux-kernel-owner+w=401wt.eu-S1759125AbZEXPzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759125AbZEXPzy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 11:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755045AbZEXPwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:52:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41851 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754844AbZEXPue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:34 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 21/45] KVM: Update cpuid 1.ecx reporting
Date: Sun, 24 May 2009 18:50:06 +0300
Message-Id: <1243180230-2480-22-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 95a2a83..038ef77 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1277,7 +1277,13 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		0 /* Reserved */ | f_lm | F(3DNOWEXT) | F(3DNOW);
 	/* cpuid 1.ecx */
 	const u32 kvm_supported_word4_x86_features =
-		F(XMM3) | F(CX16);
+		F(XMM3) | 0 /* Reserved, DTES64, MONITOR */ |
+		0 /* DS-CPL, VMX, SMX, EST */ |
+		0 /* TM2 */ | F(SSSE3) | 0 /* CNXT-ID */ | 0 /* Reserved */ |
+		0 /* Reserved */ | F(CX16) | 0 /* xTPR Update, PDCM */ |
+		0 /* Reserved, DCA */ | F(XMM4_1) |
+		F(XMM4_2) | 0 /* x2APIC */ | F(MOVBE) | F(POPCNT) |
+		0 /* Reserved, XSAVE, OSXSAVE */;
 	/* cpuid 0x80000001.ecx */
 	const u32 kvm_supported_word6_x86_features =
 		F(LAHF_LM) | F(CMP_LEGACY) | F(SVM) | 0 /* ExtApicSpace */ |
-- 
1.6.0.6


Return-Path: <linux-kernel-owner+w=401wt.eu-S932142AbZLNMI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142AbZLNMI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 07:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757080AbZLNMI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 07:08:56 -0500
Received: from mail-va3.bigfish.com ([216.32.180.114]:54713 "EHLO
	mail150-va3-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757078AbZLNMIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 07:08:55 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0KUN5QK-01-78G-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] x86: Print AMD virtualization features in /proc/cpuinfo
Date: Mon, 14 Dec 2009 13:08:41 +0100
Message-ID: <1260792521-15212-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.4
X-OriginalArrivalTime: 14 Dec 2009 12:08:43.0834 (UTC) FILETIME=[2E6E19A0:01CA7CB6]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds code to cpu initialization path to detect
the extended virtualization features of AMD cpus to show
them in /proc/cpuinfo.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/cpufeature.h          |    4 ++++
 arch/x86/kernel/cpu/addon_cpuid_features.c |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 613700f..7dbc1c2 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -167,6 +167,10 @@
 #define X86_FEATURE_FLEXPRIORITY (8*32+ 2) /* Intel FlexPriority */
 #define X86_FEATURE_EPT         (8*32+ 3) /* Intel Extended Page Table */
 #define X86_FEATURE_VPID        (8*32+ 4) /* Intel Virtual Processor ID */
+#define X86_FEATURE_NPT		(8*32+5)  /* AMD Nested Page Table support */
+#define X86_FEATURE_LBRV	(8*32+6)  /* AMD LBR Virtualization support */
+#define X86_FEATURE_SVML	(8*32+7)  /* "svm_lock" AMD SVM locking MSR */
+#define X86_FEATURE_NRIPS	(8*32+8)  /* "nrip_save" AMD SVM next_rip save */
 
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index 468489b..97ad79c 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -32,6 +32,10 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 	static const struct cpuid_bit __cpuinitconst cpuid_bits[] = {
 		{ X86_FEATURE_IDA, CR_EAX, 1, 0x00000006 },
 		{ X86_FEATURE_ARAT, CR_EAX, 2, 0x00000006 },
+		{ X86_FEATURE_NPT,   CR_EDX, 0, 0x8000000a },
+		{ X86_FEATURE_LBRV,  CR_EDX, 1, 0x8000000a },
+		{ X86_FEATURE_SVML,  CR_EDX, 2, 0x8000000a },
+		{ X86_FEATURE_NRIPS, CR_EDX, 3, 0x8000000a },
 		{ 0, 0, 0, 0 }
 	};
 
-- 
1.6.5.4



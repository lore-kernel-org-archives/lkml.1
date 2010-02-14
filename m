Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140Ab0BNATY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 19:19:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:52798 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395Ab0BNATW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 19:19:22 -0500
Date: Sun, 14 Feb 2010 00:18:43 GMT
From: tip-bot for Joerg Roedel <joerg.roedel@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       joerg.roedel@amd.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       joerg.roedel@amd.com, tglx@linutronix.de
In-Reply-To: <1260792521-15212-1-git-send-email-joerg.roedel@amd.com>
References: <1260792521-15212-1-git-send-email-joerg.roedel@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cpu: Print AMD virtualization features in /proc/cpuinfo
Message-ID: <tip-414bb144efa2d2fe16d104d836d0d6b6e9265788@git.kernel.org>
Git-Commit-ID: 414bb144efa2d2fe16d104d836d0d6b6e9265788
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Feb 2010 00:18:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  414bb144efa2d2fe16d104d836d0d6b6e9265788
Gitweb:     http://git.kernel.org/tip/414bb144efa2d2fe16d104d836d0d6b6e9265788
Author:     Joerg Roedel <joerg.roedel@amd.com>
AuthorDate: Mon, 14 Dec 2009 13:08:41 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sat, 13 Feb 2010 15:04:40 -0800

x86, cpu: Print AMD virtualization features in /proc/cpuinfo

This patch adds code to cpu initialization path to detect
the extended virtualization features of AMD cpus to show
them in /proc/cpuinfo.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
LKML-Reference: <1260792521-15212-1-git-send-email-joerg.roedel@amd.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/cpufeature.h          |    4 ++++
 arch/x86/kernel/cpu/addon_cpuid_features.c |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 637e1ec..0cd82d0 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -168,6 +168,10 @@
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
 

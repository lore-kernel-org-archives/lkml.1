Return-Path: <linux-kernel-owner+w=401wt.eu-S934804AbZLPIV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934804AbZLPIV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 03:21:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934776AbZLPIVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 03:21:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:60348 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934791AbZLPIVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 03:21:09 -0500
Date: Wed, 16 Dec 2009 08:20:20 GMT
From: tip-bot for Sheng Yang <sheng@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       mtosatti@redhat.com, tglx@linutronix.de, sheng@linux.intel.com,
       avi@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       mtosatti@redhat.com, tglx@linutronix.de, sheng@linux.intel.com,
       avi@redhat.com, mingo@elte.hu
In-Reply-To: <1260942485-19156-4-git-send-email-sheng@linux.intel.com>
References: <1260942485-19156-4-git-send-email-sheng@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Add IA32_TSC_AUX MSR and use it
Message-ID: <tip-5df974009fe513c664303de24725ea0f8b47f12e@git.kernel.org>
Git-Commit-ID: 5df974009fe513c664303de24725ea0f8b47f12e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5df974009fe513c664303de24725ea0f8b47f12e
Gitweb:     http://git.kernel.org/tip/5df974009fe513c664303de24725ea0f8b47f12e
Author:     Sheng Yang <sheng@linux.intel.com>
AuthorDate: Wed, 16 Dec 2009 13:48:04 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Dec 2009 09:02:42 +0100

x86: Add IA32_TSC_AUX MSR and use it

Clean up write_tsc() and write_tscp_aux() by replacing
hardcoded values.

No change in functionality.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
LKML-Reference: <1260942485-19156-4-git-send-email-sheng@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/msr-index.h |    1 +
 arch/x86/include/asm/msr.h       |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 4ffe09b..ac98d29 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -12,6 +12,7 @@
 #define MSR_FS_BASE		0xc0000100 /* 64bit FS base */
 #define MSR_GS_BASE		0xc0000101 /* 64bit GS base */
 #define MSR_KERNEL_GS_BASE	0xc0000102 /* SwapGS GS shadow */
+#define MSR_TSC_AUX		0xc0000103 /* Auxiliary TSC */
 
 /* EFER bits: */
 #define _EFER_SCE		0  /* SYSCALL/SYSRET */
diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 2d228fc..cf985aa 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -240,9 +240,9 @@ do {                                                            \
 #define checking_wrmsrl(msr, val) wrmsr_safe((msr), (u32)(val),		\
 					     (u32)((val) >> 32))
 
-#define write_tsc(val1, val2) wrmsr(0x10, (val1), (val2))
+#define write_tsc(val1, val2) wrmsr(MSR_IA32_TSC, (val1), (val2))
 
-#define write_rdtscp_aux(val) wrmsr(0xc0000103, (val), 0)
+#define write_rdtscp_aux(val) wrmsr(MSR_TSC_AUX, (val), 0)
 
 struct msr *msrs_alloc(void);
 void msrs_free(struct msr *msrs);

Return-Path: <linux-kernel-owner+w=401wt.eu-S1764135AbYBMVbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764135AbYBMVbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:31:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762660AbYBMV3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:29:51 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:55643 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762604AbYBMV3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:29:49 -0500
Date: Wed, 13 Feb 2008 23:29:33 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Roland McGrath <roland@redhat.com>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86: make mxcsr_feature_mask static again
Message-ID: <20080213212933.GE3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mxcsr_feature_mask needlessly became global.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/x86/kernel/i387.c |    2 +-
 include/asm-x86/i387.h |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

76adc866d04ed20a5b2eb548920f93ad87268cbd 
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 26719bd..763dfc4 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -39,7 +39,7 @@
 #define HAVE_HWFP 1
 #endif
 
-unsigned int mxcsr_feature_mask __read_mostly = 0xffffffffu;
+static unsigned int mxcsr_feature_mask __read_mostly = 0xffffffffu;
 
 void mxcsr_feature_mask_init(void)
 {
diff --git a/include/asm-x86/i387.h b/include/asm-x86/i387.h
index ba8105c..4c7706a 100644
--- a/include/asm-x86/i387.h
+++ b/include/asm-x86/i387.h
@@ -19,7 +19,6 @@
 #include <asm/uaccess.h>
 
 extern void fpu_init(void);
-extern unsigned int mxcsr_feature_mask;
 extern void mxcsr_feature_mask_init(void);
 extern void init_fpu(struct task_struct *child);
 extern asmlinkage void math_state_restore(void);


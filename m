Return-Path: <linux-kernel-owner+w=401wt.eu-S1758294AbYARE7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294AbYARE7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 23:59:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbYARE7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 23:59:22 -0500
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:56173 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbYARE7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 23:59:22 -0500
Date: Thu, 17 Jan 2008 23:59:21 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: hpa@zytor.com
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: make clflush a required feature on x86_64
Message-ID: <20080118045921.GB974@phobos.i.cabal.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hopefully nobody will be stupid enough to implement a cpu without
it. Frankly, it seems safe enough given we already require SSE2.

This means the compiler can optimise away "if (!cpu_has_clflush)"
blocks.

Signed-off-by: Kyle McMartin <kyle@mcmartin.ca>
---
 include/asm-x86/cpufeature_64.h     |    3 +++
 include/asm-x86/required-features.h |    4 +++-
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/cpufeature_64.h b/include/asm-x86/cpufeature_64.h
index e18496b..ef11d27 100644
--- a/include/asm-x86/cpufeature_64.h
+++ b/include/asm-x86/cpufeature_64.h
@@ -18,6 +18,9 @@
 #undef  cpu_has_mp
 #define cpu_has_mp             1 /* XXX */
 
+#undef	cpu_has_clflush
+#define	cpu_has_clflush        1
+
 #undef  cpu_has_k6_mtrr
 #define cpu_has_k6_mtrr        0
 
diff --git a/include/asm-x86/required-features.h b/include/asm-x86/required-features.h
index 7400d3a..cc27664 100644
--- a/include/asm-x86/required-features.h
+++ b/include/asm-x86/required-features.h
@@ -45,6 +45,7 @@
 #define NEED_XMM	(1<<(X86_FEATURE_XMM & 31))
 #define NEED_XMM2	(1<<(X86_FEATURE_XMM2 & 31))
 #define NEED_LM		(1<<(X86_FEATURE_LM & 31))
+#define NEED_CLFLSH	(1<<(X86_FEATURE_CLFLSH & 31))
 #else
 #define NEED_PSE	0
 #define NEED_MSR	0
@@ -53,11 +54,12 @@
 #define NEED_XMM	0
 #define NEED_XMM2	0
 #define NEED_LM		0
+#define NEED_CLFLSH	0
 #endif
 
 #define REQUIRED_MASK0	(NEED_FPU|NEED_PSE|NEED_MSR|NEED_PAE|\
 			 NEED_CX8|NEED_PGE|NEED_FXSR|NEED_CMOV|\
-			 NEED_XMM|NEED_XMM2)
+			 NEED_XMM|NEED_XMM2|NEED_CLFLSH)
 #define SSE_MASK	(NEED_XMM|NEED_XMM2)
 
 #define REQUIRED_MASK1	(NEED_LM|NEED_3DNOW)
-- 
1.5.3.7


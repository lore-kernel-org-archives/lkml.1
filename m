Return-Path: <linux-kernel-owner+w=401wt.eu-S1758209AbZEKRB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209AbZEKRB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 13:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757815AbZEKRAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 13:00:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:43644 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757734AbZEKRAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 13:00:08 -0400
Subject: [PATCH 8/15 -tip] x86: Add cpufeature for Platform feature
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Robert Richter <robert.richter@amd.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1242060601.5139.17.camel@ht.satnam>
References: <1242058494.5139.7.camel@ht.satnam>
	 <1242060119.5139.9.camel@ht.satnam>  <1242060207.5139.11.camel@ht.satnam>
	 <1242060254.5139.12.camel@ht.satnam>  <1242060301.5139.13.camel@ht.satnam>
	 <1242060523.5139.15.camel@ht.satnam>  <1242060567.5139.16.camel@ht.satnam>
	 <1242060601.5139.17.camel@ht.satnam>
Content-Type: text/plain
Date: Mon, 11 May 2009 22:20:44 +0530
Message-Id: <1242060644.5139.18.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


X86_FEATURE_PLATFORM : Platform Feature MSR_PLATFORM_BRV

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/cpufeature.h |    1 +
 arch/x86/kernel/cpu/intel.c       |    7 +++++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index f9e8a02..6eb9134 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -162,6 +162,7 @@
 #define X86_FEATURE_SOFT_POWERON (7*32+ 7) /* Soft Poweron configuration*/
 #define X86_FEATURE_FSB_FREQ 	(7*32+ 8) /* Scaleable bus speed	*/
 #define X86_FEATURE_MISC 	(7*32+ 9) /* Miscellaneous features	*/
+#define X86_FEATURE_PLATFORM 	(7*32+ 10) /* Platform feature		*/
 
 /* Virtualization flags: Linux defined */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index f63b151..9c8f386 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -461,6 +461,13 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 
 		/* Miscellaneous Features IA32_MISC_ENABLE		*/
 		set_cpu_cap(c, X86_FEATURE_MISC);
+
+		switch (c->x86_model) {
+		case 3: case 4: case 6:
+			/* Platform Feature MSR_PLATFORM_BRV		*/
+			set_cpu_cap(c, X86_FEATURE_PLATFORM);
+			break;
+		}
 	}
 }
 
-- 
1.6.0.6




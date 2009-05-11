Return-Path: <linux-kernel-owner+w=401wt.eu-S1758278AbZEKRCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278AbZEKRCm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 13:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757950AbZEKRAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 13:00:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:43670 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757944AbZEKRAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 13:00:32 -0400
Subject: [PATCH 10/15 -tip] x86: Add cpufeature for System configuration
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Robert Richter <robert.richter@amd.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1242060681.5139.19.camel@ht.satnam>
References: <1242058494.5139.7.camel@ht.satnam>
	 <1242060119.5139.9.camel@ht.satnam>  <1242060207.5139.11.camel@ht.satnam>
	 <1242060254.5139.12.camel@ht.satnam>  <1242060301.5139.13.camel@ht.satnam>
	 <1242060523.5139.15.camel@ht.satnam>  <1242060567.5139.16.camel@ht.satnam>
	 <1242060601.5139.17.camel@ht.satnam>  <1242060644.5139.18.camel@ht.satnam>
	 <1242060681.5139.19.camel@ht.satnam>
Content-Type: text/plain
Date: Mon, 11 May 2009 22:22:01 +0530
Message-Id: <1242060721.5139.20.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


X86_FEATURE_SYS_CFG (System configuration MSRs) :
 MSRC001_0010 System Configuration Register (SYS_CFG)
 MSRC001_001F Northbridge Configuration Register (NB_CFG)

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/cpufeature.h |    1 +
 arch/x86/kernel/cpu/amd.c         |    8 ++++++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 13050e9..674493f 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -164,6 +164,7 @@
 #define X86_FEATURE_MISC 	(7*32+ 9) /* Miscellaneous features	*/
 #define X86_FEATURE_PLATFORM 	(7*32+ 10) /* Platform feature		*/
 #define X86_FEATURE_HW_CFG 	(7*32+ 11) /* Hardware configuration	*/
+#define X86_FEATURE_SYS_CFG 	(7*32+ 12) /* System configuration	*/
 
 /* Virtualization flags: Linux defined */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index b2bccd2..8a8db1a 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -482,6 +482,14 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		/* MSRC001_0015 Hardware Configuration Register (HWCR)	*/
 		set_cpu_cap(c, X86_FEATURE_HW_CFG);
 	}
+	if (c->x86 >= 8) {				/* K8+		*/
+		/*
+		 * System configuration MSRs:
+		 * MSRC001_0010 System Configuration Register (SYS_CFG)
+		 * MSRC001_001F Northbridge Configuration Register (NB_CFG)
+		 */
+		set_cpu_cap(c, X86_FEATURE_SYS_CFG);
+	}
 	if (c->x86 >= 0x10) {				/* fam10h+	*/
 		/* MSRC001_1022 Data Cache Configuration (DC_CFG)	*/
 		set_cpu_cap(c, X86_FEATURE_CACHE_CTL);
-- 
1.6.0.6




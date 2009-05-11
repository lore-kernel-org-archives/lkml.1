Return-Path: <linux-kernel-owner+w=401wt.eu-S1758587AbZEKRDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587AbZEKRDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 13:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757831AbZEKRBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 13:01:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:43715 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757137AbZEKRBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 13:01:07 -0400
Subject: [PATCH 12/15 -tip] x86: Add cpufeature for MM configuration
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Robert Richter <robert.richter@amd.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1242060771.5139.21.camel@ht.satnam>
References: <1242058494.5139.7.camel@ht.satnam>
	 <1242060119.5139.9.camel@ht.satnam>  <1242060207.5139.11.camel@ht.satnam>
	 <1242060254.5139.12.camel@ht.satnam>  <1242060301.5139.13.camel@ht.satnam>
	 <1242060523.5139.15.camel@ht.satnam>  <1242060567.5139.16.camel@ht.satnam>
	 <1242060601.5139.17.camel@ht.satnam>  <1242060644.5139.18.camel@ht.satnam>
	 <1242060681.5139.19.camel@ht.satnam>  <1242060721.5139.20.camel@ht.satnam>
	 <1242060771.5139.21.camel@ht.satnam>
Content-Type: text/plain
Date: Mon, 11 May 2009 22:23:32 +0530
Message-Id: <1242060812.5139.22.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


X86_FEATURE_MM_CFG : MSRC001_0058 MMIO Configuration Base Address Register

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/cpufeature.h |    1 +
 arch/x86/kernel/cpu/amd.c         |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index e108284..101d8de 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -166,6 +166,7 @@
 #define X86_FEATURE_HW_CFG 	(7*32+ 11) /* Hardware configuration	*/
 #define X86_FEATURE_SYS_CFG 	(7*32+ 12) /* System configuration	*/
 #define X86_FEATURE_SMM 	(7*32+ 13) /* System Management	Mode	*/
+#define X86_FEATURE_MM_CFG 	(7*32+ 14) /* MM configuration		*/
 
 /* Virtualization flags: Linux defined */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 88cac44..d068044 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -495,6 +495,8 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	if (c->x86 >= 0x10) {				/* fam10h+	*/
 		/* MSRC001_1022 Data Cache Configuration (DC_CFG)	*/
 		set_cpu_cap(c, X86_FEATURE_CACHE_CTL);
+		/* MSRC001_0058 MMIO Configuration Base Address Register*/
+		set_cpu_cap(c, X86_FEATURE_MM_CFG);
 	}
 }
 
-- 
1.6.0.6




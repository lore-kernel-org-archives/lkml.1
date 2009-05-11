Return-Path: <linux-kernel-owner+w=401wt.eu-S1758570AbZEKRC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570AbZEKRC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 13:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758019AbZEKRAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 13:00:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:43686 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757743AbZEKRAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 13:00:43 -0400
Subject: [PATCH 11/15 -tip] x86: Add cpufeature for System management mode
 (SMM)
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Robert Richter <robert.richter@amd.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1242060721.5139.20.camel@ht.satnam>
References: <1242058494.5139.7.camel@ht.satnam>
	 <1242060119.5139.9.camel@ht.satnam>  <1242060207.5139.11.camel@ht.satnam>
	 <1242060254.5139.12.camel@ht.satnam>  <1242060301.5139.13.camel@ht.satnam>
	 <1242060523.5139.15.camel@ht.satnam>  <1242060567.5139.16.camel@ht.satnam>
	 <1242060601.5139.17.camel@ht.satnam>  <1242060644.5139.18.camel@ht.satnam>
	 <1242060681.5139.19.camel@ht.satnam>  <1242060721.5139.20.camel@ht.satnam>
Content-Type: text/plain
Date: Mon, 11 May 2009 22:22:51 +0530
Message-Id: <1242060771.5139.21.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


X86_FEATURE_SMM : SMM MSRs C001_0111-C001_0113 & C001_0050-C000_0056

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/cpufeature.h |    1 +
 arch/x86/kernel/cpu/amd.c         |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 674493f..e108284 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -165,6 +165,7 @@
 #define X86_FEATURE_PLATFORM 	(7*32+ 10) /* Platform feature		*/
 #define X86_FEATURE_HW_CFG 	(7*32+ 11) /* Hardware configuration	*/
 #define X86_FEATURE_SYS_CFG 	(7*32+ 12) /* System configuration	*/
+#define X86_FEATURE_SMM 	(7*32+ 13) /* System Management	Mode	*/
 
 /* Virtualization flags: Linux defined */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 8a8db1a..88cac44 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -489,6 +489,8 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		 * MSRC001_001F Northbridge Configuration Register (NB_CFG)
 		 */
 		set_cpu_cap(c, X86_FEATURE_SYS_CFG);
+		/* SMM MSRs C001_0111-C001_0113 & C001_0050-C000_0056	*/
+		set_cpu_cap(c, X86_FEATURE_SMM);
 	}
 	if (c->x86 >= 0x10) {				/* fam10h+	*/
 		/* MSRC001_1022 Data Cache Configuration (DC_CFG)	*/
-- 
1.6.0.6




Return-Path: <linux-kernel-owner+w=401wt.eu-S1757098AbZEKRBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098AbZEKRBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 13:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757260AbZEKQ7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 12:59:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:43605 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757020AbZEKQ7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 12:59:53 -0400
Subject: [PATCH 6/15 -tip] x86: Add cpufeature for Scaleable bus speed
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Robert Richter <robert.richter@amd.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1242060523.5139.15.camel@ht.satnam>
References: <1242058494.5139.7.camel@ht.satnam>
	 <1242060119.5139.9.camel@ht.satnam>  <1242060207.5139.11.camel@ht.satnam>
	 <1242060254.5139.12.camel@ht.satnam>  <1242060301.5139.13.camel@ht.satnam>
	 <1242060523.5139.15.camel@ht.satnam>
Content-Type: text/plain
Date: Mon, 11 May 2009 22:19:27 +0530
Message-Id: <1242060567.5139.16.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


X86_FEATURE_FSB_FREQ : Scaleable bus speed MSR_FSB_FREQ

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/cpufeature.h |    1 +
 arch/x86/kernel/cpu/intel.c       |    8 ++++++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 97e54ad..8f789b5 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -160,6 +160,7 @@
 #define X86_FEATURE_CACHE_CTL	(7*32+ 5) /* Cache control MSRs		*/
 #define X86_FEATURE_HARD_POWERON (7*32+ 6) /* Hard Poweron configuration*/
 #define X86_FEATURE_SOFT_POWERON (7*32+ 7) /* Soft Poweron configuration*/
+#define X86_FEATURE_FSB_FREQ 	(7*32+ 8) /* Scaleable bus speed	*/
 
 /* Virtualization flags: Linux defined */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 239048d..aca1c7d 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -410,6 +410,12 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 			break;
 
 		case 9:	case 0xD:			/* Pentium M	*/
+			/* Hard Poweron configuration MSR_EBL_CR_POWERON*/
+			set_cpu_cap(c, X86_FEATURE_HARD_POWERON);
+			/* BBL_CR_CTL* MSRs (Cache control MSRs)	*/
+			set_cpu_cap(c, X86_FEATURE_CACHE_CTL);
+			break;
+
 		case 0xE:				/* Core		*/
 		case 0xF: case 0x17:			/* Core 2	*/
 		case 0x1C:				/* ATOM		*/
@@ -417,6 +423,8 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 			set_cpu_cap(c, X86_FEATURE_HARD_POWERON);
 			/* BBL_CR_CTL* MSRs (Cache control MSRs)	*/
 			set_cpu_cap(c, X86_FEATURE_CACHE_CTL);
+			/* Scaleable bus speed MSR_FSB_FREQ		*/
+			set_cpu_cap(c, X86_FEATURE_FSB_FREQ);
 			break;
 
 		case 0x16:				/* Celeron Core	*/
-- 
1.6.0.6




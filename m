Return-Path: <linux-kernel-owner+w=401wt.eu-S1755514AbZFTK1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbZFTK1S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 06:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbZFTK1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 06:27:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:58296 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbZFTK1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 06:27:08 -0400
Subject: [POWERNOW PATCH] x86: powernow-k8 move power management MSRs
 declaration to msr-index.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 20 Jun 2009 15:56:21 +0530
Message-Id: <1245493581.8613.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Keep all MSRs declaration in msr-index.h to easily access MSRs declaration.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/msr-index.h          |    9 +++++++++
 arch/x86/kernel/cpu/cpufreq/powernow-k8.h |    9 +--------
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 4d58d04..103a253 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -109,6 +109,15 @@
 #define MSR_AMD64_IBSDCPHYSAD		0xc0011039
 #define MSR_AMD64_IBSCTL		0xc001103a
 
+/* Power Management MSRs */
+#define MSR_FIDVID_CTL			0xc0010041
+#define MSR_FIDVID_STATUS		0xc0010042
+
+#define MSR_PSTATE_CUR_LIMIT		0xc0010061 /* Pstate current limit */
+#define MSR_PSTATE_CTRL			0xc0010062 /* Pstate control	*/
+#define MSR_PSTATE_STATUS		0xc0010063 /* Pstate Status	*/
+#define MSR_PSTATE_DEF_BASE		0xc0010064 /* base of Pstate	*/
+
 /* Fam 10h MSRs */
 #define MSR_FAM10H_MMIO_CONF_BASE	0xc0010058
 #define FAM10H_MMIO_CONF_ENABLE		(1<<0)
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.h b/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
index 6c6698f..d420ea0 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
@@ -73,9 +73,6 @@ struct powernow_k8_data {
 /* the value to write is placed in edx:eax. For reads (rdmsr - opcode 0f 32), */
 /* the register number is placed in ecx, and the data is returned in edx:eax. */
 
-#define MSR_FIDVID_CTL      0xc0010041
-#define MSR_FIDVID_STATUS   0xc0010042
-
 /* Field definitions within the FID VID Low Control MSR : */
 #define MSR_C_LO_INIT_FID_VID     0x00010000
 #define MSR_C_LO_NEW_VID          0x00003f00
@@ -100,16 +97,12 @@ struct powernow_k8_data {
 #define MSR_C_HI_STP_GNT_BENIGN	  0x00000001
 
 
-/* Hardware Pstate _PSS and MSR definitions */
+/* Hardware Pstate _PSS */
 #define USE_HW_PSTATE		0x00000080
 #define HW_PSTATE_MASK 		0x00000007
 #define HW_PSTATE_VALID_MASK 	0x80000000
 #define HW_PSTATE_MAX_MASK	0x000000f0
 #define HW_PSTATE_MAX_SHIFT	4
-#define MSR_PSTATE_DEF_BASE 	0xc0010064 /* base of Pstate MSRs */
-#define MSR_PSTATE_STATUS 	0xc0010063 /* Pstate Status MSR */
-#define MSR_PSTATE_CTRL 	0xc0010062 /* Pstate control MSR */
-#define MSR_PSTATE_CUR_LIMIT	0xc0010061 /* pstate current limit MSR */
 
 /* define the two driver architectures */
 #define CPU_OPTERON 0
-- 
1.6.0.6




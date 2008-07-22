Return-Path: <linux-kernel-owner+w=401wt.eu-S1757480AbYGVTbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480AbYGVTbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754530AbYGVTZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:25:10 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:17474 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbYGVTZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:25:06 -0400
X-BigFish: VPS24(z37d4jzzz10d3izzz32i87il65h)
X-Spam-TCS-SCL: 4:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K4F9WX-01-8RV-01
From: Robert Richter <robert.richter@amd.com>
To: Barry Kasindorf <barry.kasindorf@amd.com>, Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 19/24] x86/oprofile: Macro definition cleanup in op_model_athlon.c
Date: Tue, 22 Jul 2008 21:09:03 +0200
Message-ID: <1216753748-11261-20-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 22 Jul 2008 19:23:40.0652 (UTC) FILETIME=[72AC02C0:01C8EC30]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_athlon.c |   46 +++++++++++++----------------------
 1 files changed, 17 insertions(+), 29 deletions(-)

diff --git a/arch/x86/oprofile/op_model_athlon.c b/arch/x86/oprofile/op_model_athlon.c
index 1acb067..a3a2058 100644
--- a/arch/x86/oprofile/op_model_athlon.c
+++ b/arch/x86/oprofile/op_model_athlon.c
@@ -47,32 +47,20 @@
 #define CTRL_SET_HOST_ONLY(val, h) (val |= ((h & 1) << 9))
 #define CTRL_SET_GUEST_ONLY(val, h) (val |= ((h & 1) << 8))
 
-#define IBS_FETCH_CTL_HIGH_MASK		0xFFFFFFFF
-/* high dword bit IbsFetchCtl[bit 49] */
-#define IBS_FETCH_VALID_BIT		(1UL << 17)
-/* high dword bit IbsFetchCtl[bit 52] */
-#define IBS_FETCH_PHY_ADDR_VALID_BIT 	(1UL << 20)
-/* high dword bit IbsFetchCtl[bit 48] */
-#define IBS_FETCH_ENABLE		(1UL << 16)
+/* IbsFetchCtl bits/masks */
+#define IBS_FETCH_HIGH_VALID_BIT	(1UL << 17)	/* bit 49 */
+#define IBS_FETCH_HIGH_ENABLE		(1UL << 16)	/* bit 48 */
+#define IBS_FETCH_LOW_MAX_CNT_MASK	0x0000FFFFUL	/* MaxCnt mask */
 
-#define IBS_FETCH_CTL_CNT_MASK 		0x00000000FFFF0000UL
-#define IBS_FETCH_CTL_MAX_CNT_MASK 	0x000000000000FFFFUL
-
-/*IbsOpCtl masks/bits */
-#define IBS_OP_VALID_BIT	(1ULL<<18)	/* IbsOpCtl[bit18] */
-#define IBS_OP_ENABLE		(1ULL<<17)	/* IBS_OP_ENABLE[bit17]*/
+/*IbsOpCtl bits */
+#define IBS_OP_LOW_VALID_BIT		(1ULL<<18)	/* bit 18 */
+#define IBS_OP_LOW_ENABLE		(1ULL<<17)	/* bit 17 */
 
 /* Codes used in cpu_buffer.c */
+/* This produces duplicate code, need to be fixed */
 #define IBS_FETCH_BEGIN 3
 #define IBS_OP_BEGIN    4
 
-/*IbsOpData3 masks */
-#define IBS_CTL_LVT_OFFSET_VALID_BIT		(1ULL<<8)
-
-/*PCI Extended Configuration Constants */
-/* MSR to set the IBS control register APIC LVT offset */
-#define IBS_LVT_OFFSET_PCI		0x1CC
-
 /* The function interface needs to be fixed, something like add
    data. Should then be added to linux/oprofile.h. */
 extern void oprofile_add_ibs_sample(struct pt_regs *const regs,
@@ -213,7 +201,7 @@ op_amd_handle_ibs(struct pt_regs * const regs,
 
 	if (ibs_config.fetch_enabled) {
 		rdmsr(MSR_AMD64_IBSFETCHCTL, low, high);
-		if (high & IBS_FETCH_VALID_BIT) {
+		if (high & IBS_FETCH_HIGH_VALID_BIT) {
 			ibs_fetch.ibs_fetch_ctl_high = high;
 			ibs_fetch.ibs_fetch_ctl_low = low;
 			rdmsr(MSR_AMD64_IBSFETCHLINAD, low, high);
@@ -229,16 +217,16 @@ op_amd_handle_ibs(struct pt_regs * const regs,
 
 			/*reenable the IRQ */
 			rdmsr(MSR_AMD64_IBSFETCHCTL, low, high);
-			high &= ~(IBS_FETCH_VALID_BIT);
-			high |= IBS_FETCH_ENABLE;
-			low &= IBS_FETCH_CTL_MAX_CNT_MASK;
+			high &= ~IBS_FETCH_HIGH_VALID_BIT;
+			high |= IBS_FETCH_HIGH_ENABLE;
+			low &= IBS_FETCH_LOW_MAX_CNT_MASK;
 			wrmsr(MSR_AMD64_IBSFETCHCTL, low, high);
 		}
 	}
 
 	if (ibs_config.op_enabled) {
 		rdmsr(MSR_AMD64_IBSOPCTL, low, high);
-		if (low & IBS_OP_VALID_BIT) {
+		if (low & IBS_OP_LOW_VALID_BIT) {
 			rdmsr(MSR_AMD64_IBSOPRIP, low, high);
 			ibs_op.ibs_op_rip_low = low;
 			ibs_op.ibs_op_rip_high = high;
@@ -263,8 +251,8 @@ op_amd_handle_ibs(struct pt_regs * const regs,
 						(unsigned int *)&ibs_op,
 						IBS_OP_BEGIN);
 			rdmsr(MSR_AMD64_IBSOPCTL, low, high);
-			low &= ~(IBS_OP_VALID_BIT);
-			low |= IBS_OP_ENABLE;
+			low &= ~IBS_OP_LOW_VALID_BIT;
+			low |= IBS_OP_LOW_ENABLE;
 			wrmsr(MSR_AMD64_IBSOPCTL, low, high);
 		}
 	}
@@ -307,12 +295,12 @@ static void op_amd_start(struct op_msrs const * const msrs)
 	}
 	if (ibs_allowed && ibs_config.fetch_enabled) {
 		low = (ibs_config.max_cnt_fetch >> 4) & 0xFFFF;
-		high = IBS_FETCH_ENABLE;
+		high = IBS_FETCH_HIGH_ENABLE;
 		wrmsr(MSR_AMD64_IBSFETCHCTL, low, high);
 	}
 
 	if (ibs_allowed && ibs_config.op_enabled) {
-		low = ((ibs_config.max_cnt_op >> 4) & 0xFFFF) + IBS_OP_ENABLE;
+		low = ((ibs_config.max_cnt_op >> 4) & 0xFFFF) + IBS_OP_LOW_ENABLE;
 		high = 0;
 		wrmsr(MSR_AMD64_IBSOPCTL, low, high);
 	}
-- 
1.5.5.4



Return-Path: <linux-kernel-owner+w=401wt.eu-S1751591AbXFOQ72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591AbXFOQ72 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 12:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbXFOQ65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 12:58:57 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:26398 "EHLO
	outbound7-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750979AbXFOQ6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 12:58:55 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Fri, 15 Jun 2007 18:59:28 +0200
From: "Robert Richter" <robert.richter@amd.com>
To: "Stephane Eranian" <eranian@hpl.hp.com>
cc: "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: [patch 4/8] 2.6.22-rc3 perfmon2 : IBS implementation for AMD64
Message-ID: <20070615093331.168842000@localhost>
References: <20070614215818.509851000@localhost>
MIME-Version: 1.0
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 15 Jun 2007 16:58:42.0241 (UTC)
 FILETIME=[6D8A9310:01C7AF6E]
X-WSS-ID: 6A6C1ACF23K500866-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch rearranges AMD64 MSR definitions.

Signed-off-by: Robert Richter <robert.richter@amd.com>

Index: linux-2.6.22-rc3/include/asm-i386/msr-index.h
===================================================================
--- linux-2.6.22-rc3.orig/include/asm-i386/msr-index.h
+++ linux-2.6.22-rc3/include/asm-i386/msr-index.h
@@ -75,6 +75,18 @@
 
 /* K7/K8 MSRs. Not complete. See the architecture manual for a more
    complete list. */
+
+/* K8 MSRs */
+#define MSR_K8_TOP_MEM1			0xC001001A
+#define MSR_K8_TOP_MEM2			0xC001001D
+#define MSR_K8_SYSCFG			0xC0010010
+#define MSR_K8_HWCR			0xC0010015
+#define MSR_K8_ENABLE_C1E		0xc0010055
+#define K8_MTRRFIXRANGE_DRAM_ENABLE	0x00040000 /* MtrrFixDramEn bit    */
+#define K8_MTRRFIXRANGE_DRAM_MODIFY	0x00080000 /* MtrrFixDramModEn bit */
+#define K8_MTRR_RDMEM_WRMEM_MASK	0x18181818 /* Mask: RdMem|WrMem    */
+
+/* K7 MSRs */
 #define MSR_K7_EVNTSEL0			0xc0010000
 #define MSR_K7_PERFCTR0			0xc0010004
 #define MSR_K7_EVNTSEL1			0xc0010001
@@ -83,20 +95,10 @@
 #define MSR_K7_PERFCTR2			0xc0010006
 #define MSR_K7_EVNTSEL3			0xc0010003
 #define MSR_K7_PERFCTR3			0xc0010007
-#define MSR_K8_TOP_MEM1			0xc001001a
 #define MSR_K7_CLK_CTL			0xc001001b
-#define MSR_K8_TOP_MEM2			0xc001001d
-#define MSR_K8_SYSCFG			0xc0010010
-
-#define K8_MTRRFIXRANGE_DRAM_ENABLE	0x00040000 /* MtrrFixDramEn bit    */
-#define K8_MTRRFIXRANGE_DRAM_MODIFY	0x00080000 /* MtrrFixDramModEn bit */
-#define K8_MTRR_RDMEM_WRMEM_MASK	0x18181818 /* Mask: RdMem|WrMem    */
-
 #define MSR_K7_HWCR			0xc0010015
-#define MSR_K8_HWCR			0xc0010015
 #define MSR_K7_FID_VID_CTL		0xc0010041
 #define MSR_K7_FID_VID_STATUS		0xc0010042
-#define MSR_K8_ENABLE_C1E		0xc0010055
 
 /* K6 MSRs */
 #define MSR_K6_EFER			0xc0000080

--
AMD Saxony, Dresden, Germany
Operating System Research Center
email: robert.richter@amd.com





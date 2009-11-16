Return-Path: <linux-kernel-owner+w=401wt.eu-S1753829AbZKPOSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbZKPOSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 09:18:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbZKPOSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 09:18:50 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:31841 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbZKPOQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 09:16:25 -0500
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KT7GZ6-01-9KP-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <x86@kernel.org>, <norsk5@yahoo.com>
Subject: [PATCH 13/21] amd64_edac: rename StinkyIdentifier
Date: Mon, 16 Nov 2009 15:16:40 +0100
Message-ID: <1258381008-18783-14-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
References: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 16 Nov 2009 14:16:13.0079 (UTC) FILETIME=[5A2B4270:01CA66C7]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SystemAddress -> sys_addr

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   36 ++++++++++++++++++------------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 86742aa..202f08e 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1117,7 +1117,7 @@ static void k8_read_dram_base_limit(struct amd64_pvt *pvt, int dram)
 
 static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci,
 					struct err_regs *info,
-					u64 SystemAddress)
+					u64 sys_addr)
 {
 	struct mem_ctl_info *src_mci;
 	unsigned short syndrome;
@@ -1152,28 +1152,28 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci,
 		 * was obtained from email communication with someone at AMD.
 		 * (Wish the email was placed in this comment - norsk)
 		 */
-		channel = ((SystemAddress & BIT(3)) != 0);
+		channel = ((sys_addr & BIT(3)) != 0);
 	}
 
 	/*
 	 * Find out which node the error address belongs to. This may be
 	 * different from the node that detected the error.
 	 */
-	src_mci = find_mc_by_sys_addr(mci, SystemAddress);
+	src_mci = find_mc_by_sys_addr(mci, sys_addr);
 	if (!src_mci) {
 		amd64_mc_printk(mci, KERN_ERR,
 			     "failed to map error address 0x%lx to a node\n",
-			     (unsigned long)SystemAddress);
+			     (unsigned long)sys_addr);
 		edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR);
 		return;
 	}
 
-	/* Now map the SystemAddress to a CSROW */
-	csrow = sys_addr_to_csrow(src_mci, SystemAddress);
+	/* Now map the sys_addr to a CSROW */
+	csrow = sys_addr_to_csrow(src_mci, sys_addr);
 	if (csrow < 0) {
 		edac_mc_handle_ce_no_info(src_mci, EDAC_MOD_STR);
 	} else {
-		error_address_to_page_and_offset(SystemAddress, &page, &offset);
+		error_address_to_page_and_offset(sys_addr, &page, &offset);
 
 		edac_mc_handle_ce(src_mci, page, offset, syndrome, csrow,
 				  channel, EDAC_MOD_STR);
@@ -2108,7 +2108,7 @@ static void amd64_handle_ce(struct mem_ctl_info *mci,
 			    struct err_regs *info)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
-	u64 SystemAddress;
+	u64 sys_addr;
 
 	/* Ensure that the Error Address is VALID */
 	if ((info->nbsh & K8_NBSH_VALID_ERROR_ADDR) == 0) {
@@ -2118,12 +2118,12 @@ static void amd64_handle_ce(struct mem_ctl_info *mci,
 		return;
 	}
 
-	SystemAddress = extract_error_address(mci, info);
+	sys_addr = extract_error_address(mci, info);
 
 	amd64_mc_printk(mci, KERN_ERR,
-		"CE ERROR_ADDRESS= 0x%llx\n", SystemAddress);
+		"CE ERROR_ADDRESS= 0x%llx\n", sys_addr);
 
-	pvt->ops->map_sysaddr_to_csrow(mci, info, SystemAddress);
+	pvt->ops->map_sysaddr_to_csrow(mci, info, sys_addr);
 }
 
 /* Handle any Un-correctable Errors (UEs) */
@@ -2131,7 +2131,7 @@ static void amd64_handle_ue(struct mem_ctl_info *mci,
 			    struct err_regs *info)
 {
 	int csrow;
-	u64 SystemAddress;
+	u64 sys_addr;
 	u32 page, offset;
 	struct mem_ctl_info *log_mci, *src_mci = NULL;
 
@@ -2144,31 +2144,31 @@ static void amd64_handle_ue(struct mem_ctl_info *mci,
 		return;
 	}
 
-	SystemAddress = extract_error_address(mci, info);
+	sys_addr = extract_error_address(mci, info);
 
 	/*
 	 * Find out which node the error address belongs to. This may be
 	 * different from the node that detected the error.
 	 */
-	src_mci = find_mc_by_sys_addr(mci, SystemAddress);
+	src_mci = find_mc_by_sys_addr(mci, sys_addr);
 	if (!src_mci) {
 		amd64_mc_printk(mci, KERN_CRIT,
 			"ERROR ADDRESS (0x%lx) value NOT mapped to a MC\n",
-			(unsigned long)SystemAddress);
+			(unsigned long)sys_addr);
 		edac_mc_handle_ue_no_info(log_mci, EDAC_MOD_STR);
 		return;
 	}
 
 	log_mci = src_mci;
 
-	csrow = sys_addr_to_csrow(log_mci, SystemAddress);
+	csrow = sys_addr_to_csrow(log_mci, sys_addr);
 	if (csrow < 0) {
 		amd64_mc_printk(mci, KERN_CRIT,
 			"ERROR_ADDRESS (0x%lx) value NOT mapped to 'csrow'\n",
-			(unsigned long)SystemAddress);
+			(unsigned long)sys_addr);
 		edac_mc_handle_ue_no_info(log_mci, EDAC_MOD_STR);
 	} else {
-		error_address_to_page_and_offset(SystemAddress, &page, &offset);
+		error_address_to_page_and_offset(sys_addr, &page, &offset);
 		edac_mc_handle_ue(log_mci, page, offset, csrow, EDAC_MOD_STR);
 	}
 }
-- 
1.6.4.3



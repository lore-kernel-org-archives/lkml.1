Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbZKPOQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbZKPOQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 09:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbZKPOQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 09:16:18 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:24974 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbZKPOQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 09:16:17 -0500
X-SpamScore: 4
X-BigFish: VPS4(zza84eizz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KT7GYZ-02-PYT-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <x86@kernel.org>, <norsk5@yahoo.com>
Subject: [PATCH 01/21] amd64_edac: clarify DRAM CTL debug reporting
Date: Mon, 16 Nov 2009 15:16:28 +0100
Message-ID: <1258381008-18783-2-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
References: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 16 Nov 2009 14:16:12.0641 (UTC) FILETIME=[59E86D10:01CA66C7]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make debug info formulations about the DRAM and DCT configuration of the
machine more human readable.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   37 +++++++++++++++++++++++--------------
 1 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index a38831c..0252a61 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1402,27 +1402,36 @@ static void f10_read_dram_ctl_register(struct amd64_pvt *pvt)
 	err = pci_read_config_dword(pvt->dram_f2_ctl, F10_DCTL_SEL_LOW,
 				    &pvt->dram_ctl_select_low);
 	if (err) {
-		debugf0("Reading F10_DCTL_SEL_LOW failed\n");
+		debugf0("Reading F2x110 (DCTL Sel. Low) failed\n");
 	} else {
-		debugf0("DRAM_DCTL_SEL_LOW=0x%x  DctSelBaseAddr=0x%x\n",
-			pvt->dram_ctl_select_low, dct_sel_baseaddr(pvt));
-
-		debugf0("  DRAM DCTs are=%s DRAM Is=%s DRAM-Ctl-"
-				"sel-hi-range=%s\n",
-			(dct_ganging_enabled(pvt) ? "GANGED" : "NOT GANGED"),
-			(dct_dram_enabled(pvt) ? "Enabled"   : "Disabled"),
-			(dct_high_range_enabled(pvt) ? "Enabled" : "Disabled"));
-
-		debugf0("  DctDatIntLv=%s MemCleared=%s DctSelIntLvAddr=0x%x\n",
-			(dct_data_intlv_enabled(pvt) ? "Enabled" : "Disabled"),
-			(dct_memory_cleared(pvt) ? "True " : "False "),
+		debugf0("F2x110 (DCTL Sel. Low): 0x%08x, "
+			"High range addresses at: 0x%x\n",
+			pvt->dram_ctl_select_low,
+			dct_sel_baseaddr(pvt));
+
+		debugf0("  DCT mode: %s, All DCTs on: %s\n",
+			(dct_ganging_enabled(pvt) ? "ganged" : "unganged"),
+			(dct_dram_enabled(pvt) ? "yes"   : "no"));
+
+		if (!dct_ganging_enabled(pvt))
+			debugf0("  Address range split per DCT: %s\n",
+				(dct_high_range_enabled(pvt) ? "yes" : "no"));
+
+		debugf0("  DCT data interleave for ECC: %s, "
+			"DRAM cleared since last warm reset: %s\n",
+			(dct_data_intlv_enabled(pvt) ? "enabled" : "disabled"),
+			(dct_memory_cleared(pvt) ? "yes" : "no"));
+
+		debugf0("  DCT channel interleave: %s, "
+			"DCT interleave bits selector: 0x%x\n",
+			(dct_interleave_enabled(pvt) ? "enabled" : "disabled"),
 			dct_sel_interleave_addr(pvt));
 	}
 
 	err = pci_read_config_dword(pvt->dram_f2_ctl, F10_DCTL_SEL_HIGH,
 				    &pvt->dram_ctl_select_high);
 	if (err)
-		debugf0("Reading F10_DCTL_SEL_HIGH failed\n");
+		debugf0("Reading F2x114 (DCT Sel. High) failed\n");
 }
 
 /*
-- 
1.6.4.3



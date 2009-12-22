Return-Path: <linux-kernel-owner+w=401wt.eu-S1752885AbZLVLlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbZLVLlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 06:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbZLVLlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 06:41:51 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:44018 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbZLVLlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 06:41:49 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KV1XTC-01-IW5-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <norsk5@yahoo.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 5/6] amd64_edac: restrict PCI config space access
Date: Tue, 22 Dec 2009 12:41:16 +0100
Message-ID: <1261482077-23733-6-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.5.4
In-Reply-To: <1261482077-23733-1-git-send-email-borislav.petkov@amd.com>
References: <1261482077-23733-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 22 Dec 2009 11:41:35.0223 (UTC) FILETIME=[B701C870:01CA82FB]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not access F2x19[0,4] on K8 since they're undefined there.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 63c04d3..c5facd9 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2349,7 +2349,7 @@ static void amd64_read_mc_registers(struct amd64_pvt *pvt)
 	amd64_read_pci_cfg(pvt->dram_f2_ctl, F10_DCLR_0, &pvt->dclr0);
 	amd64_read_pci_cfg(pvt->dram_f2_ctl, F10_DCHR_0, &pvt->dchr0);
 
-	if (!dct_ganging_enabled(pvt)) {
+	if (!dct_ganging_enabled(pvt) && boot_cpu_data.x86 >= 0x10) {
 		amd64_read_pci_cfg(pvt->dram_f2_ctl, F10_DCLR_1, &pvt->dclr1);
 		amd64_read_pci_cfg(pvt->dram_f2_ctl, F10_DCHR_1, &pvt->dchr1);
 	}
-- 
1.6.5.4



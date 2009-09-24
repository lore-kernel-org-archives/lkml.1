Return-Path: <linux-kernel-owner+w=401wt.eu-S1752675AbZIXMd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbZIXMd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 08:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbZIXMdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 08:33:55 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:48009
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752306AbZIXMdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 08:33:49 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KQH6W2-04-3W3-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <norsk5@yahoo.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 04/10] amd64_edac: fix DRAM base and limit address extraction
Date: Thu, 24 Sep 2009 14:32:42 +0200
Message-ID: <1253795568-9877-5-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253795568-9877-1-git-send-email-borislav.petkov@amd.com>
References: <1253795568-9877-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 24 Sep 2009 12:33:37.0413 (UTC) FILETIME=[3D366B50:01CA3D13]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

K8 DRAM base and limit addresses from F1x40 +8*i and F1x44 + 8*i, where
i in (0..7) are both bits 39-24 and therefore the shifting should be
done by 24 and not by 8.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 49911be..96deaaf 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1130,7 +1130,7 @@ static void k8_read_dram_base_limit(struct amd64_pvt *pvt, int dram)
 		debugf0("Reading K8_DRAM_BASE_LOW failed\n");
 
 	/* Extract parts into separate data entries */
-	pvt->dram_base[dram] = ((u64) low & 0xFFFF0000) << 8;
+	pvt->dram_base[dram] = ((u64) low & 0xFFFF0000) << 24;
 	pvt->dram_IntlvEn[dram] = (low >> 8) & 0x7;
 	pvt->dram_rw_en[dram] = (low & 0x3);
 
@@ -1143,7 +1143,7 @@ static void k8_read_dram_base_limit(struct amd64_pvt *pvt, int dram)
 	 * Extract parts into separate data entries. Limit is the HIGHEST memory
 	 * location of the region, so lower 24 bits need to be all ones
 	 */
-	pvt->dram_limit[dram] = (((u64) low & 0xFFFF0000) << 8) | 0x00FFFFFF;
+	pvt->dram_limit[dram] = (((u64) low & 0xFFFF0000) << 24) | 0x00FFFFFF;
 	pvt->dram_IntlvSel[dram] = (low >> 8) & 0x7;
 	pvt->dram_DstNode[dram] = (low & 0x7);
 }
-- 
1.6.3.3



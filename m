Return-Path: <linux-kernel-owner+w=401wt.eu-S1752585AbZIXMdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbZIXMdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 08:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbZIXMdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 08:33:49 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:26625
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751728AbZIXMds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 08:33:48 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KQH6W6-03-AHY-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <norsk5@yahoo.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 05/10] amd64_edac: fix interleave enable tests
Date: Thu, 24 Sep 2009 14:32:43 +0200
Message-ID: <1253795568-9877-6-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253795568-9877-1-git-send-email-borislav.petkov@amd.com>
References: <1253795568-9877-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 24 Sep 2009 12:33:40.0256 (UTC) FILETIME=[3EE83A00:01CA3D13]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pvt->dram_IntlvEn saves the 3 "Interleave Enable" bits already
right-shifted by 8 so the check in find_mc_by_sys_addr() by shifting the
values to the left 8 bits is wrong.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 96deaaf..3dfb8e6 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -289,12 +289,12 @@ static struct mem_ctl_info *find_mc_by_sys_addr(struct mem_ctl_info *mci,
 		goto found;
 	}
 
-	if (unlikely((intlv_en != (0x01 << 8)) &&
-		     (intlv_en != (0x03 << 8)) &&
-		     (intlv_en != (0x07 << 8)))) {
+	if (unlikely((intlv_en != 0x01) &&
+		     (intlv_en != 0x03) &&
+		     (intlv_en != 0x07))) {
 		amd64_printk(KERN_WARNING, "junk value of 0x%x extracted from "
 			     "IntlvEn field of DRAM Base Register for node 0: "
-			     "This probably indicates a BIOS bug.\n", intlv_en);
+			     "this probably indicates a BIOS bug.\n", intlv_en);
 		return NULL;
 	}
 
-- 
1.6.3.3



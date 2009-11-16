Return-Path: <linux-kernel-owner+w=401wt.eu-S1753554AbZKPOSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbZKPOSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 09:18:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753448AbZKPOQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 09:16:27 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:13932
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753367AbZKPOQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 09:16:23 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KT7GZ3-02-PZ1-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <x86@kernel.org>, <norsk5@yahoo.com>
Subject: [PATCH 17/21] amd64_edac: detect DDR3 memory type
Date: Mon, 16 Nov 2009 15:16:44 +0100
Message-ID: <1258381008-18783-18-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
References: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 16 Nov 2009 14:16:13.0172 (UTC) FILETIME=[5A397340:01CA66C7]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 708d065..d9cde71 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1017,10 +1017,11 @@ static enum mem_type amd64_determine_memory_type(struct amd64_pvt *pvt)
 	enum mem_type type;
 
 	if (boot_cpu_data.x86 >= 0x10 || pvt->ext_model >= K8_REV_F) {
-		/* Rev F and later */
-		type = (pvt->dclr0 & BIT(16)) ? MEM_DDR2 : MEM_RDDR2;
+		if (pvt->dchr0 & DDR3_MODE)
+			type = (pvt->dclr0 & BIT(16)) ?	MEM_DDR3 : MEM_RDDR3;
+		else
+			type = (pvt->dclr0 & BIT(16)) ? MEM_DDR2 : MEM_RDDR2;
 	} else {
-		/* Rev E and earlier */
 		type = (pvt->dclr0 & BIT(18)) ? MEM_DDR : MEM_RDDR;
 	}
 
-- 
1.6.4.3



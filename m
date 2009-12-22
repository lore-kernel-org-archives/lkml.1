Return-Path: <linux-kernel-owner+w=401wt.eu-S1752937AbZLVLmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbZLVLmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 06:42:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbZLVLls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 06:41:48 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:10357
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752712AbZLVLlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 06:41:47 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KV1XTB-01-IW4-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <norsk5@yahoo.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 4/6] amd64_edac: fix forcing module load/unload
Date: Tue, 22 Dec 2009 12:41:15 +0100
Message-ID: <1261482077-23733-5-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.5.4
In-Reply-To: <1261482077-23733-1-git-send-email-borislav.petkov@amd.com>
References: <1261482077-23733-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 22 Dec 2009 11:41:35.0161 (UTC) FILETIME=[B6F85290:01CA82FB]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clear the override flag after force-loading the module.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index a8af27a..63c04d3 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2690,9 +2690,8 @@ static int amd64_check_ecc_enabled(struct amd64_pvt *pvt)
 			amd64_printk(KERN_WARNING, "%s", ecc_warning);
 			return -ENODEV;
 		}
-	} else
-		/* CLEAR the override, since BIOS controlled it */
 		ecc_enable_override = 0;
+	}
 
 	return 0;
 }
-- 
1.6.5.4



Return-Path: <linux-kernel-owner+w=401wt.eu-S1759307AbZFWLne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307AbZFWLne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 07:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759169AbZFWLnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 07:43:19 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:11969 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759233AbZFWLnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 07:43:18 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i17ch43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KLOWJT-02-0GE-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <norsk5@yahoo.com>
CC: <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: [PATCH 2/3] amd64_edac: fix ecc_enable_override handling
Date: Tue, 23 Jun 2009 13:43:02 +0200
Message-ID: <1245757383-21333-2-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245757383-21333-1-git-send-email-borislav.petkov@amd.com>
References: <1245757383-21333-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 23 Jun 2009 11:43:07.0075 (UTC) FILETIME=[C692C930:01C9F3F7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

amd64_check_ecc_enabled() returns non-zero status when ECC
checking/correcting is disabled and this fails further loading of the
driver even when 'ecc_enable_override' module param is used.

Fix that by clearing return status in that case.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 3b76605..8497963 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2966,7 +2966,12 @@ static int amd64_check_ecc_enabled(struct amd64_pvt *pvt)
 				"    Use of the override can cause "
 				"unknown side effects.\n");
 			ret = -ENODEV;
-		}
+		} else
+			/*
+			 * enable further driver loading if ECC enable is
+			 * overridden.
+			 */
+			ret = 0;
 	} else {
 		amd64_printk(KERN_INFO,
 			"ECC is enabled by BIOS, Proceeding "
-- 
1.6.3.1



Return-Path: <linux-kernel-owner+w=401wt.eu-S1752754AbZIXMeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbZIXMeO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 08:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbZIXMeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 08:34:11 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:6575 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbZIXMeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 08:34:10 -0400
X-SpamScore: 10
X-BigFish: VPS10(zza4b1ozz1202hzzz32i6bh43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KQH6W9-03-AI4-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <norsk5@yahoo.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
       Keith Mannthey <kmannth@us.ibm.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 07/10] amd64_edac: simple fix to allow reporting of CECC errors
Date: Thu, 24 Sep 2009 14:32:45 +0200
Message-ID: <1253795568-9877-8-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253795568-9877-1-git-send-email-borislav.petkov@amd.com>
References: <1253795568-9877-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 24 Sep 2009 12:33:40.0287 (UTC) FILETIME=[3EECF4F0:01CA3D13]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keith Mannthey <kmannth@us.ibm.com>

This allows the errors to be further decoded and mapped to csrows.
Tested with ECC debug dimms and an Rev F cpu based system.

Signed-off-by: Keith Mannthey <kmannth@us.ibm.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 3f98ae0..cb3bbf2 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1190,7 +1190,7 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci,
 	 * different from the node that detected the error.
 	 */
 	src_mci = find_mc_by_sys_addr(mci, SystemAddress);
-	if (src_mci) {
+	if (!src_mci) {
 		amd64_mc_printk(mci, KERN_ERR,
 			     "failed to map error address 0x%lx to a node\n",
 			     (unsigned long)SystemAddress);
-- 
1.6.3.3



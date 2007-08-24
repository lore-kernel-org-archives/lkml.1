Return-Path: <linux-kernel-owner+w=401wt.eu-S965159AbXHXATx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965159AbXHXATx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 20:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965010AbXHXATK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 20:19:10 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:14051 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964971AbXHXATG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 20:19:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:resent-from:resent-to:resent-date:resent-message-id:message-id:in-reply-to:references:from:date:subject:to:cc:mime-version:content-transfer-encoding:content-disposition;
        b=GesYlFblYDBGUTF9LqR+6hq8NQz4EWfZiXZsOIACbV/vL7ZxtwK42N5NQs6KNChDYipHCDmzOnD6ziXFaf50TFlzSFDyhx0HeA5ViZ3MdSH6PukthEH1rKrqNvEex3Hp+hoAhbj2oTfmo43JNdKmsfBd1tTCPPgRcfSRiyF1WUI=
Message-Id: <82de4728edd63551c2c8a2fff0350f0917ed73a5.1187912217.git.jesper.juhl@gmail.com>
In-Reply-To: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
From: Jesper Juhl <jesper.juhl@gmail.com>
Date: Fri, 24 Aug 2007 02:16:12 +0200
Subject: [PATCH 20/30] scsi: In the Advansys driver, do not cast allocation function return values
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>,
       linux@connectcom.net, Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There's no reason to cast void pointers returned by the generic
memory allocation functions.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---
 drivers/scsi/advansys.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 79c0b6e..b28729c 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -18513,7 +18513,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 		 * Allocate buffer carrier structures. The total size
 		 * is about 4 KB, so allocate all at once.
 		 */
-		carrp = (ADV_CARR_T *) kmalloc(ADV_CARRIER_BUFSIZE, GFP_ATOMIC);
+		carrp = kmalloc(ADV_CARRIER_BUFSIZE, GFP_ATOMIC);
 		ASC_DBG1(1, "advansys_board_found: carrp 0x%lx\n", (ulong)carrp);
 
 		if (carrp == NULL) {
@@ -18529,8 +18529,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 		for (req_cnt = adv_dvc_varp->max_host_qng;
 		     req_cnt > 0; req_cnt--) {
 
-			reqp = (adv_req_t *)
-			    kmalloc(sizeof(adv_req_t) * req_cnt, GFP_ATOMIC);
+			reqp = kmalloc(sizeof(adv_req_t) * req_cnt, GFP_ATOMIC);
 
 			ASC_DBG3(1,
 				 "advansys_board_found: reqp 0x%lx, req_cnt %d, bytes %lu\n",
@@ -18552,9 +18551,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 		boardp->adv_sgblkp = NULL;
 		for (sg_cnt = 0; sg_cnt < ADV_TOT_SG_BLOCK; sg_cnt++) {
 
-			sgp = (adv_sgblk_t *)
-			    kmalloc(sizeof(adv_sgblk_t), GFP_ATOMIC);
-
+			sgp = kmalloc(sizeof(adv_sgblk_t), GFP_ATOMIC);
 			if (sgp == NULL) {
 				break;
 			}
-- 
1.5.2.2


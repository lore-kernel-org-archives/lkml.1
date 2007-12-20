Return-Path: <linux-kernel-owner+w=401wt.eu-S1761558AbXLTBvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761558AbXLTBvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:51:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759458AbXLTBgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:36:54 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:12451 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758904AbXLTBeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=JYSPZCMlcmC9Bh5lk3TjB/BJkECcFiSonFxzunPXyLYY66LvYxdK2D7vP7euDNw/jf3Khk4D7FQvgwMCeOfEawEj0Xd9c/ZQ93OsowsW4CfOiGOq3I+kCTaCacnLRpbvb+5/JfL8peReTDP0lk1qOcANvxkfxl7bK+3apSSJE4U=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 46/63] ide-cd: call blk_dump_rq_flags() on "missing data" in cdrom_newpc_intr()
Date: Thu, 20 Dec 2007 02:27:51 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200227.51519.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1343,7 +1343,11 @@ static ide_startstop_t cdrom_newpc_intr(
 		}
 
 		if (!ptr) {
-			printk(KERN_ERR "%s: confused, missing data\n", drive->name);
+			printk(KERN_ERR "%s: confused, missing data\n",
+					drive->name);
+			blk_dump_rq_flags(rq, rq_data_dir(rq)
+					      ? "cdrom_newpc_intr, write"
+					      : "cdrom_newpc_intr, read");
 			break;
 		}
 

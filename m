Return-Path: <linux-kernel-owner+w=401wt.eu-S1751552AbZG3Mtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbZG3Mtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 08:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbZG3Mtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 08:49:50 -0400
Received: from dscas1.ad.uiuc.edu ([128.174.68.119]:49345 "EHLO
	dscas1.ad.uiuc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbZG3Mtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 08:49:50 -0400
From: Stoyan Gaydarov <sgayda2@uiuc.edu>
To: linux-kernel@vger.kernel.org
CC: Stoyan Gaydarov <sgayda2@uiuc.edu>, David.Woodhouse@intel.com, sr@denx.de,
       bigeasy@linutronix.de, kay.sievers@vrfy.org, gregkh@suse.de,
       linux-mtd@lists.infradead.org
Subject: Re: [PATCH] [mtd] fixed faulty check
Date: Thu, 30 Jul 2009 07:49:38 -0500
Message-ID: <1248958178-22599-1-git-send-email-sgayda2@uiuc.edu>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resubmit of a patch with some additions, see http://lkml.org/lkml/2009/7/30/97

Signed-off-by: Stoyan Gaydarov <sgayda2@uiuc.edu>
---
 drivers/mtd/maps/physmap_of.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/maps/physmap_of.c b/drivers/mtd/maps/physmap_of.c
index 39d357b..e7ab5f0 100644
--- a/drivers/mtd/maps/physmap_of.c
+++ b/drivers/mtd/maps/physmap_of.c
@@ -215,7 +215,8 @@ static int __devinit of_flash_probe(struct of_device *dev,
 		goto err_out;
 
 	mtd_list = kzalloc(sizeof(struct mtd_info) * count, GFP_KERNEL);
-	if (!info)
+	if (!mtd_list)
+		kfree(info);
 		goto err_out;
 
 	dev_set_drvdata(&dev->dev, info);
-- 
1.6.3.3


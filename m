Return-Path: <linux-kernel-owner+w=401wt.eu-S1763463AbZDBXdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763463AbZDBXdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 19:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763728AbZDBXcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 19:32:46 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:42548 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763155AbZDBXcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 19:32:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=bTYQQWM9/DkkisCO+lylzAsPt3BT1prL/Zljb7VSW3A4a5XpIANf/selbFTEs02nvA
         bY5fGriFIuuqTRRqrt5nHT9a6u+96fA4FB90Ro4m0bO0bls6n2GlC6CVlqKkSeIJpmSG
         eijH3cCeAETxmnDqjg/IdnRM14HGhuJzBSk7A=
MIME-Version: 1.0
Date: Thu, 2 Apr 2009 16:32:42 -0700
Message-ID: <a95a62fe0904021632l14ddb299l7818f2f2d32c20ac@mail.gmail.com>
Subject: [PATCH] MTD: nandsim should delete its partitions on module unload
From: Kevin Cernekee <kpc.mtd@gmail.com>
To: dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kevin Cernekee <kpc.mtd@gmail.com>
---
 drivers/mtd/nand/nandsim.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/nand/nandsim.c b/drivers/mtd/nand/nandsim.c
index cd0711b..f4fda9b 100644
--- a/drivers/mtd/nand/nandsim.c
+++ b/drivers/mtd/nand/nandsim.c
@@ -2349,6 +2349,7 @@ static void __exit ns_cleanup_module(void)
 	struct nandsim *ns = (struct nandsim *)(((struct nand_chip
*)nsmtd->priv)->priv);
 	int i;

+	del_mtd_partitions(nsmtd);
 	free_nandsim(ns);    /* Free nandsim private resources */
 	nand_release(nsmtd); /* Unregister driver */
 	for (i = 0;i < ARRAY_SIZE(ns->partitions); ++i)
-- 
1.5.6.3

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752282AbZG0QQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbZG0QQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 12:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbZG0QQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 12:16:28 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:40749 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019AbZG0QQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 12:16:27 -0400
Date: Mon, 27 Jul 2009 18:13:11 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/12] drivers/mtd: Correct redundant test
Message-ID: <Pine.LNX.4.64.0907271812540.2682@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

info has already been tested.  It seems that this test should be on the
recently returned value mtd_list.

A simplified version of the semantic match that finds this problem is as
follows: (http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
expression E;
@@

if (x == NULL || ...) { ... when forall
   return ...; }
... when != \(x=E\|x--\|x++\|--x\|++x\|x-=E\|x+=E\|x|=E\|x&=E\|&x\)
(
*x == NULL
|
*x != NULL
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/mtd/maps/physmap_of.c       |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/maps/physmap_of.c b/drivers/mtd/maps/physmap_of.c
index 39d357b..2cc0b0d 100644
--- a/drivers/mtd/maps/physmap_of.c
+++ b/drivers/mtd/maps/physmap_of.c
@@ -215,7 +215,7 @@ static int __devinit of_flash_probe(struct of_device *dev,
 		goto err_out;
 
 	mtd_list = kzalloc(sizeof(struct mtd_info) * count, GFP_KERNEL);
-	if (!info)
+	if (!mtd_list)
 		goto err_out;
 
 	dev_set_drvdata(&dev->dev, info);

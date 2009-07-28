Return-Path: <linux-kernel-owner+w=401wt.eu-S1753401AbZG1RLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbZG1RLH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 13:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbZG1RLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 13:11:07 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:38490 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbZG1RLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 13:11:05 -0400
Date: Tue, 28 Jul 2009 19:09:59 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-s390@vger.kernel.org, linux390@de.ibm.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/s390: put NULL test before dereference
Message-ID: <Pine.LNX.4.64.0907281909190.28189@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If the NULL test on block is needed, it should be before the dereference of
the base field.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
expression E1,E2;
identifier fld;
statement S1,S2;
@@

E1 = E2->fld;
(
if (E1 == NULL) S1 else S2
|
*if (E2 == NULL) S1 else S2
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/s390/block/dasd.c           |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index 001af66..e109da4 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -2133,9 +2133,9 @@ static int dasd_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 	struct dasd_device *base;
 
 	block = bdev->bd_disk->private_data;
-	base = block->base;
 	if (!block)
 		return -ENODEV;
+	base = block->base;
 
 	if (!base->discipline ||
 	    !base->discipline->fill_geometry)

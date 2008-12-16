Return-Path: <linux-kernel-owner+w=401wt.eu-S1758141AbYLPPQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141AbYLPPQJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 10:16:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758040AbYLPPPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 10:15:35 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:59632 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758154AbYLPPPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 10:15:34 -0500
Date: Tue, 16 Dec 2008 16:15:31 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 10/11] drivers/spi: Move a dereference below a NULL test
Message-ID: <Pine.LNX.4.64.0812161615090.20444@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In each case, if the NULL test is necessary, then the dereference should be
moved below the NULL test.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
expression E;
identifier i,fld;
statement S;
@@

- T i = E->fld;
+ T i;
  ... when != E
      when != i
  if (E == NULL) S
+ i = E->fld;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/spi/pxa2xx_spi.c            |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/pxa2xx_spi.c b/drivers/spi/pxa2xx_spi.c
index cf12f2d..fbad7e4 100644
--- a/drivers/spi/pxa2xx_spi.c
+++ b/drivers/spi/pxa2xx_spi.c
@@ -1561,11 +1561,12 @@ out_error_master_alloc:
 static int pxa2xx_spi_remove(struct platform_device *pdev)
 {
 	struct driver_data *drv_data = platform_get_drvdata(pdev);
-	struct ssp_device *ssp = drv_data->ssp;
+	struct ssp_device *ssp;
 	int status = 0;
 
 	if (!drv_data)
 		return 0;
+	ssp = drv_data->ssp;
 
 	/* Remove the queue */
 	status = destroy_queue(drv_data);

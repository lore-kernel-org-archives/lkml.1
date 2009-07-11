Return-Path: <linux-kernel-owner+w=401wt.eu-S1755754AbZGKHvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754AbZGKHvH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 03:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753784AbZGKHuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 03:50:52 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:58848 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093AbZGKHuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 03:50:50 -0400
Date: Sat, 11 Jul 2009 09:49:48 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/5] drivers/ata: Move a dereference below a NULL test
Message-ID: <Pine.LNX.4.64.0907110949280.29592@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If the NULL test is necessary, then the dereference should be moved below
the NULL test.

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
 drivers/ata/pata_at91.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -u -p a/drivers/ata/pata_at91.c b/drivers/ata/pata_at91.c
--- a/drivers/ata/pata_at91.c
+++ b/drivers/ata/pata_at91.c
@@ -312,11 +312,12 @@ err_ide_ioremap:
 static int __devexit pata_at91_remove(struct platform_device *pdev)
 {
 	struct ata_host *host = dev_get_drvdata(&pdev->dev);
-	struct at91_ide_info *info = host->private_data;
+	struct at91_ide_info *info;
 	struct device *dev = &pdev->dev;
 
 	if (!host)
 		return 0;
+	info = host->private_data;
 
 	ata_host_detach(host);
 

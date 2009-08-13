Return-Path: <linux-kernel-owner+w=401wt.eu-S1754147AbZHMKC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbZHMKC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 06:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbZHMKBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 06:01:51 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:45525 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754058AbZHMKBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 06:01:50 -0400
Message-Id: <20090813100639.003140517@fluff.org>
References: <20090813100602.545180197@fluff.org>
User-Agent: quilt/0.46-1
Date: Thu, 13 Aug 2009 11:06:07 +0100
From: Ben Dooks <ben@simtec.co.uk>
To: spi-devel-general@lists.sourceforge.net, dbrownell@users.sourceforge.ne
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 5/7] spi_s3c24xx: use resource_size() to get resource size
Content-Disposition: inline; filename=spi-use-resource-size.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the use of (res->end - res->start) to use resource_size() to
get the size of the resource.

Signed-off-by: Ben Dooks <ben@simtec.co.uk>
---
 drivers/spi/spi_s3c24xx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/spi/spi_s3c24xx.c
===================================================================
--- a/drivers/spi/spi_s3c24xx.c	2009-08-08 09:53:33.000000000 +0100
+++ b/drivers/spi/spi_s3c24xx.c	2009-08-08 09:54:03.000000000 +0100
@@ -299,7 +299,7 @@ static int __init s3c24xx_spi_probe(stru
 		goto err_no_iores;
 	}
 
-	hw->ioarea = request_mem_region(res->start, (res->end - res->start)+1,
+	hw->ioarea = request_mem_region(res->start, resource_size(res),
 					pdev->name);
 
 	if (hw->ioarea == NULL) {
@@ -308,7 +308,7 @@ static int __init s3c24xx_spi_probe(stru
 		goto err_no_iores;
 	}
 
-	hw->regs = ioremap(res->start, (res->end - res->start)+1);
+	hw->regs = ioremap(res->start, resource_size(res));
 	if (hw->regs == NULL) {
 		dev_err(&pdev->dev, "Cannot map IO\n");
 		err = -ENXIO;

-- 

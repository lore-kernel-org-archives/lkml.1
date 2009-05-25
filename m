Return-Path: <linux-kernel-owner+w=401wt.eu-S1754436AbZEYT2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbZEYT2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 15:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbZEYT2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 15:28:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:9307 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbZEYT2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 15:28:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=n1AMJBBZhMkXyMC1HMlhsAWojdHgki9W6Y20uB8R7yy8TjQj6Jbwp+NxQccRpl+5J1
         0cFEqi8mABBNhU2GJFlsRSArBZc7GqEPZmqPd8ZzRKZXYCjqikD76/S2XUwravRb1LAF
         PT0YaNat++fnemPgRcSnTNRShUcst0YMVUljE=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Molton <spyro@f2s.com>, Philipp Zabel <philipp.zabel@gmail.com>,
       Pierre Ossman <pierre@ossman.eu>
Subject: [PATCH 5/5] mmc: tmio_mmc: move probe function into __init section
Date: Mon, 25 May 2009 21:28:01 +0200
Message-Id: <1243279681-4233-6-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1243279681-4233-1-git-send-email-philipp.zabel@gmail.com>
References: <1243279681-4233-1-git-send-email-philipp.zabel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As MFD cells are not hotpluggable, this should be safe to do.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Ian Molton <spyro@f2s.com>
---
 drivers/mmc/host/tmio_mmc.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
index b1b4e6c..5858279 100644
--- a/drivers/mmc/host/tmio_mmc.c
+++ b/drivers/mmc/host/tmio_mmc.c
@@ -514,7 +514,7 @@ out:
 #define tmio_mmc_resume NULL
 #endif
 
-static int __devinit tmio_mmc_probe(struct platform_device *dev)
+static int __init tmio_mmc_probe(struct platform_device *dev)
 {
 	struct mfd_cell	*cell = (struct mfd_cell *)dev->dev.platform_data;
 	struct tmio_mmc_data *pdata;
@@ -643,7 +643,6 @@ static struct platform_driver tmio_mmc_driver = {
 		.name = "tmio-mmc",
 		.owner = THIS_MODULE,
 	},
-	.probe = tmio_mmc_probe,
 	.remove = __devexit_p(tmio_mmc_remove),
 	.suspend = tmio_mmc_suspend,
 	.resume = tmio_mmc_resume,
@@ -652,7 +651,7 @@ static struct platform_driver tmio_mmc_driver = {
 
 static int __init tmio_mmc_init(void)
 {
-	return platform_driver_register(&tmio_mmc_driver);
+	return platform_driver_probe(&tmio_mmc_driver, tmio_mmc_probe);
 }
 
 static void __exit tmio_mmc_exit(void)
-- 
1.6.3.1


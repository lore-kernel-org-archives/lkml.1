Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbYISTK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbYISTK3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 15:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbYISTJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 15:09:53 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:39978 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbYISTJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 15:09:51 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: linux-kernel@vger.kernel.org, kernel@avr32linux.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH 3/4] atmel-mci: Fix bogus debugfs file size
Date: Fri, 19 Sep 2008 21:09:29 +0200
Message-Id: <1221851370-20189-4-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1221851370-20189-3-git-send-email-haavard.skinnemoen@atmel.com>
References: <1221851370-20189-1-git-send-email-haavard.skinnemoen@atmel.com>
 <1221851370-20189-2-git-send-email-haavard.skinnemoen@atmel.com>
 <1221851370-20189-3-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 19 Sep 2008 19:09:20.0305 (UTC) FILETIME=[383CBA10:01C91A8B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We used to store a binary register snapshot in the "regs" file, so we
set the file size to be the size of this snapshot. This is no longer
valid since we switched to using seq_file.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 drivers/mmc/host/atmel-mci.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index becca91..3909608 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -241,7 +241,6 @@ static void atmci_init_debugfs(struct atmel_mci *host)
 	struct mmc_host	*mmc;
 	struct dentry	*root;
 	struct dentry	*node;
-	struct resource	*res;
 
 	mmc = host->mmc;
 	root = mmc->debugfs_root;
@@ -255,9 +254,6 @@ static void atmci_init_debugfs(struct atmel_mci *host)
 	if (!node)
 		goto err;
 
-	res = platform_get_resource(host->pdev, IORESOURCE_MEM, 0);
-	node->d_inode->i_size = res->end - res->start + 1;
-
 	node = debugfs_create_file("req", S_IRUSR, root, host, &atmci_req_fops);
 	if (!node)
 		goto err;
-- 
1.5.6.5


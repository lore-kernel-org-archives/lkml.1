Return-Path: <linux-kernel-owner+w=401wt.eu-S1752006AbZHXH5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006AbZHXH5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 03:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbZHXH5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 03:57:11 -0400
Received: from brick.kernel.dk ([93.163.65.50]:45626 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665AbZHXH5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 03:57:06 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, benh@kernel.crashing.org, htejun@gmail.com,
       bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 4/7] libata: use lazy workqueues for the pio task
Date: Mon, 24 Aug 2009 09:56:53 +0200
Message-Id: <1251100616-28604-5-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.173.g3f189
In-Reply-To: <1251100616-28604-1-git-send-email-jens.axboe@oracle.com>
References: <1251100616-28604-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/ata/libata-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 072ba5e..35f74c9 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6580,7 +6580,7 @@ static int __init ata_init(void)
 {
 	ata_parse_force_param();
 
-	ata_wq = create_workqueue("ata");
+	ata_wq = create_lazy_workqueue("ata");
 	if (!ata_wq)
 		goto free_force_tbl;
 
-- 
1.6.4.173.g3f189


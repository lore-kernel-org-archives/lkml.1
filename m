Return-Path: <linux-kernel-owner+w=401wt.eu-S1752944AbZHCUzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944AbZHCUzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 16:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752342AbZHCUzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 16:55:08 -0400
Received: from cobra.newdream.net ([66.33.216.30]:34203 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbZHCUzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 16:55:05 -0400
From: Sage Weil <sage@newdream.net>
To: linux-kernel@vger.kernel.org
Cc: Sage Weil <sage@newdream.net>, linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] ibmvscsi: avoid unnecessary use of kzalloc_pool
Date: Mon,  3 Aug 2009 13:54:47 -0700
Message-Id: <1249332888-13440-2-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1249332888-13440-1-git-send-email-sage@newdream.net>
References: <1249332888-13440-1-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The allocated struct is manually zeroed after allocation, so avoid using
the (broken) kzalloc mempool (which does not re-zero previously used items
when they are returned to the pool).

CC: linux-scsi@vger.kernel.org
CC: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Sage Weil <sage@newdream.net>
---
 drivers/scsi/ibmvscsi/ibmvfc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 166d964..bb2c696 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -4217,7 +4217,7 @@ static int ibmvfc_alloc_mem(struct ibmvfc_host *vhost)
 	if (!vhost->trace)
 		goto free_disc_buffer;
 
-	vhost->tgt_pool = mempool_create_kzalloc_pool(IBMVFC_TGT_MEMPOOL_SZ,
+	vhost->tgt_pool = mempool_create_kmalloc_pool(IBMVFC_TGT_MEMPOOL_SZ,
 						      sizeof(struct ibmvfc_target));
 
 	if (!vhost->tgt_pool) {
-- 
1.5.6.5


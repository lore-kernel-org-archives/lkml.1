Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbZHYO43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbZHYO43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 10:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754981AbZHYO42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 10:56:28 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:45209 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860AbZHYO42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 10:56:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=tzNTl7U/Snw2AGD5zag/1KckIqZYjhV1xjdK8i5xm8G7saMrdeZpGKs//WWEEGmeo1
         RHZhRkKL/Qz9rK31he1/D1C3spx3SUeEkHniU1M+z1+CLSRtdY6zRxrlbpNdm0cQpL3L
         mM64oG05r883FwHRzC9JANqSlXwHqB4dfPKQI=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] Staging: agnx: remove flush_workqueue()
Date: Tue, 25 Aug 2009 17:25:44 +0400
Message-Id: <1251206744-16581-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mac80211 already does flush_workqueue() at stop/start and
suspend\resume.
(fix build error)

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/staging/agnx/pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/agnx/pci.c b/drivers/staging/agnx/pci.c
index 1fe9870..32b5489 100644
--- a/drivers/staging/agnx/pci.c
+++ b/drivers/staging/agnx/pci.c
@@ -280,7 +280,7 @@ static void agnx_stop(struct ieee80211_hw *dev)
 	/* make sure hardware will not generate irq */
 	agnx_hw_reset(priv);
 	free_irq(priv->pdev->irq, dev);
-	flush_workqueue(priv->hw->workqueue);
+/*	flush_workqueue(priv->hw->workqueue); */
 /*	cancel_delayed_work_sync(&priv->periodic_work); */
 	unfill_rings(priv);
 	rings_free(priv);
-- 
1.6.4


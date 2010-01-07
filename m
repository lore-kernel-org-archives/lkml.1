Return-Path: <linux-kernel-owner+w=401wt.eu-S1756578Ab0AGBtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab0AGBtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 20:49:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756565Ab0AGBtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 20:49:01 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:54414 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756560Ab0AGBs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 20:48:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=I21GvxSQeqtc/SnBfLFIeF+BzC2G9B8aV9/uK0E9JKTvQsM9R5EtaicMf82mtrd4uf
         6hsXQukYOdgrSSC4HpVBOOw/52MIQngMs5vzmiv3E4woc+vPTzpp+oqzlDt6SzZJFd0G
         SWEsru6qSaRl/xnKJCMglZBaSQ2ODI1Y7EyrE=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [PATCH 2/4] SCSI: pm8001: avoid NULL pointer dereference
Date: Thu,  7 Jan 2010 04:48:39 +0300
Message-Id: <1262828921-29517-2-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1262828921-29517-1-git-send-email-a.beregalov@gmail.com>
References: <1262828921-29517-1-git-send-email-a.beregalov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assign device_id only if pm8001_dev is not NULL.

Cc: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/scsi/pm8001/pm8001_sas.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 7f9c83a..4e748d1 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -884,11 +884,12 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
 	u32 tag;
 	struct pm8001_hba_info *pm8001_ha;
 	struct pm8001_device *pm8001_dev = dev->lldd_dev;
-	u32 device_id = pm8001_dev->device_id;
+	u32 device_id;
 	pm8001_ha = pm8001_find_ha_by_dev(dev);
 	spin_lock_irqsave(&pm8001_ha->lock, flags);
 	pm8001_tag_alloc(pm8001_ha, &tag);
 	if (pm8001_dev) {
+		device_id = pm8001_dev->device_id;
 		PM8001_DISC_DBG(pm8001_ha,
 			pm8001_printk("found dev[%d:%x] is gone.\n",
 			pm8001_dev->device_id, pm8001_dev->dev_type));
-- 
1.6.6


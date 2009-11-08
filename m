Return-Path: <linux-kernel-owner+w=401wt.eu-S1753790AbZKHTa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790AbZKHTa5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 14:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752690AbZKHTa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 14:30:57 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:46446 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbZKHTa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 14:30:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=HOdC6Oi3Dbcw85ObnZB29z/QWdY529nPPPGpUt07qJKm6V7A6B2Rf5M+FX8NhQHOFB
         NyMB8/2HekXccrRRvy1LmpYoP2/5lOAyGhEisKdBzp4/rwrl1wNjP9+E0e+STT8tPVSi
         LUQHNdIIp/UtXKZvx6iifGRecuugO3/7fkMgk=
From: Thiago Farina <tfransosi@gmail.com>
To: jgarzik@pobox.com
Cc: mlord@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thiago Farina <tfransosi@gmail.com>
Subject: [PATCH] ata: Clean up hard coded array size calculation.
Date: Sun,  8 Nov 2009 14:30:57 -0500
Message-Id: <1257708657-1232-1-git-send-email-tfransosi@gmail.com>
X-Mailer: git-send-email 1.6.5.2.150.g1b52a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use ARRAY_SIZE macro of kernel api instead.

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 drivers/ata/sata_mv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 6f5093b..a8a7be0 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -2217,7 +2217,7 @@ static unsigned int mv_qc_issue_fis(struct ata_queued_cmd *qc)
 	int err = 0;
 
 	ata_tf_to_fis(&qc->tf, link->pmp, 1, (void *)fis);
-	err = mv_send_fis(ap, fis, sizeof(fis) / sizeof(fis[0]));
+	err = mv_send_fis(ap, fis, ARRAY_SIZE(fis));
 	if (err)
 		return err;
 
-- 
1.6.5.2.150.g1b52a


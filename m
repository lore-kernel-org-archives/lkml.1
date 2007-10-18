Return-Path: <linux-kernel-owner+w=401wt.eu-S1763168AbXJRKwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763168AbXJRKwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 06:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764245AbXJRKvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 06:51:42 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:44758 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762473AbXJRKvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 06:51:40 -0400
Date: Thu, 18 Oct 2007 12:52:07 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] scsi/aic7xxx_old.c: fix NULL check
Message-ID: <20071018105207.GK3778@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Commit bbfbbbc1182f8b44c8cc4c99f4a3f3a512149022 accidentally reversed 
the logic of this NULL check.

Spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
ee645f41f64ebeb782a0ca2e724dff929f854b68 
diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
index 4025608..8f8db5f 100644
--- a/drivers/scsi/aic7xxx_old.c
+++ b/drivers/scsi/aic7xxx_old.c
@@ -8417,7 +8417,7 @@ aic7xxx_alloc(struct scsi_host_template *sht, struct aic7xxx_host *temp)
     p->host = host;
 
     p->scb_data = kzalloc(sizeof(scb_data_type), GFP_ATOMIC);
-    if (!p->scb_data)
+    if (p->scb_data)
     {
       scbq_init (&p->scb_data->free_scbs);
     }


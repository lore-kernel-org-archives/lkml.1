Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbXLHPlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbXLHPlq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 10:41:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756242AbXLHPlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 10:41:35 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:6557 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbXLHPld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 10:41:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=lPcGaHejCYUfrpYa/LzIh1QlKvg09LP5tDjeCPfMTTb6FGVJmbfQdSmXV9F0/A0eidBjADvUlz9T5beIo2axhbqny4JHuDru1mZgxFrbus40Cdyr6du2xGC8kJaRGCHC4Az9LOGVFbgyWjqh26CPn1J9XAyDs6KRyFxcrR9CuDs=
From: Denis Cheng <crquan@gmail.com>
To: Adam Radford <linuxraid@amcc.com>
Cc: linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] 3W RAID drivers: memset not needed in probe
Date: Sat,  8 Dec 2007 23:40:59 +0800
Message-Id: <1197128459-14014-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the memory return from scsi_host_alloc is alloced by kzalloc,
which is already zero initilized, so memset not needed.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 drivers/scsi/3w-9xxx.c |    2 --
 drivers/scsi/3w-xxxx.c |    2 --
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index afb262b..cb28511 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -2028,8 +2028,6 @@ static int __devinit twa_probe(struct pci_dev *pdev, const struct pci_device_id
 	}
 	tw_dev = (TW_Device_Extension *)host->hostdata;
 
-	memset(tw_dev, 0, sizeof(TW_Device_Extension));
-
 	/* Save values to device extension */
 	tw_dev->host = host;
 	tw_dev->tw_pci_dev = pdev;
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 59716eb..a8c12d7 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -2295,8 +2295,6 @@ static int __devinit tw_probe(struct pci_dev *pdev, const struct pci_device_id *
 	}
 	tw_dev = (TW_Device_Extension *)host->hostdata;
 
-	memset(tw_dev, 0, sizeof(TW_Device_Extension));
-
 	/* Save values to device extension */
 	tw_dev->host = host;
 	tw_dev->tw_pci_dev = pdev;
-- 
1.5.3.4


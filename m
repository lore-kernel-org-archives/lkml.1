Return-Path: <linux-kernel-owner+w=401wt.eu-S932574AbYBGUiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574AbYBGUiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:38:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707AbYBGUih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:38:37 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:59805 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbYBGUig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:38:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=fiwUMRHvu18b3nwRB0o3HFEKpTBkxNBn+6zaoICHH2FJaYrHkne0+gblsaVHujCGvuL2uU0ow2Re12zBqLLtmkl0cweg6zNXCnLax40BOtH9a//OXfevu8F6lD6PLBpV8PPQ5uyavGspEHkInVkoR9Z4RczLn0c/iKJOt72QEnc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.5/3] palm_bk3710: port initialization/probing bugfix
Date: Thu, 7 Feb 2008 21:50:34 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, Anton Salnikov <asalnikov@ru.mvista.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802072150.34389.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Probe port _after_ it is fully initialized.

Cc: Anton Salnikov <asalnikov@ru.mvista.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/palm_bk3710.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: b/drivers/ide/arm/palm_bk3710.c
===================================================================
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -370,13 +370,6 @@ static int __devinit palm_bk3710_probe(s
 	ide_init_port_hw(hwif, &hw);
 	hwif->quirkproc = NULL;
 
-	idx[0] = i;
-
-	ide_device_add(idx, NULL);
-
-	if (!hwif->present)
-		goto out;
-
 	hwif->set_pio_mode = &palm_bk3710_set_pio_mode;
 	hwif->set_dma_mode = &palm_bk3710_set_dma_mode;
 	hwif->mmio = 1;
@@ -390,6 +383,13 @@ static int __devinit palm_bk3710_probe(s
 
 	ide_setup_dma(hwif, mem->start);
 
+	idx[0] = i;
+
+	ide_device_add(idx, NULL);
+
+	if (!hwif->present)
+		goto out;
+
 	return 0;
 out:
 	printk(KERN_WARNING "Palm Chip BK3710 IDE Register Fail\n");

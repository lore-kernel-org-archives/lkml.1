Return-Path: <linux-kernel-owner+w=401wt.eu-S1752570AbYLMUQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbYLMUQQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 15:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbYLMUP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 15:15:58 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:13373 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbYLMUP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 15:15:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=erb0mAPaj6MhEptT1hE/ZkLkfDuz9oLsvrC8NpWQpfWftN+4FOQh5DMGsWMDY6Naza
         pvd/Oh3VlhwxgtGS3LqwZXDn1G1jmF4m6oZuOM3eqCNRszz8XNPz/hWVjS54CzuBe4MA
         MiYmxv4ccBKqOKRF634MDtW5gR6mh/O8vlTVM=
Message-ID: <494417FF.7010501@gmail.com>
Date: Sat, 13 Dec 2008 21:15:59 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: drzeus@drzeus.cx
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] mmc: balanc pci_iomap with pci_iounmap
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

balance pci_iomap with pci_iounmap, not iounmap

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/mmc/host/sdricoh_cs.c b/drivers/mmc/host/sdricoh_cs.c
index 1df44d9..d4d86be 100644
--- a/drivers/mmc/host/sdricoh_cs.c
+++ b/drivers/mmc/host/sdricoh_cs.c
@@ -463,7 +463,7 @@ static int sdricoh_init_mmc(struct pci_dev *pci_dev,
 
 err:
 	if (iobase)
-		iounmap(iobase);
+		pci_iounmap(iobase);
 	if (mmc)
 		mmc_free_host(mmc);
 


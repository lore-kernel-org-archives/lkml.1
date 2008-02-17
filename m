Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbYBQSH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbYBQSH5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 13:07:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbYBQSHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 13:07:49 -0500
Received: from vsmtp1.tin.it ([212.216.176.141]:65187 "EHLO vsmtp1.tin.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbYBQSHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 13:07:48 -0500
From: Leonardo Potenza <lpotenza@inwind.it>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH resend] drivers/video/aty/radeon_base.c: compilation warning fix
Date: Sun, 17 Feb 2008 19:07:50 +0100
User-Agent: KMail/1.9.7
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802171907.50497.lpotenza@inwind.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Leonardo Potenza <lpotenza@inwind.it>

Add a check for the sysfs_create_bin_file() return value.
In case of error the framebuffer creation is not aborted, but a warning message is generated instead.

Signed-off-by: Leonardo Potenza <lpotenza@inwind.it>
---

The aim of this patch is to remove the following warning messages:
drivers/video/aty/radeon_base.c: In function 'radeonfb_pci_register':
drivers/video/aty/radeon_base.c:2334: warning: ignoring return value of 'sysfs_create_bin_file', declared with attribute warn_unused_result
drivers/video/aty/radeon_base.c:2336: warning: ignoring return value of 'sysfs_create_bin_file', declared with attribute warn_unused_result

The patch was already acknowledged by Benjamin Herrenschmidt, but I realised that I did not cc the LKML (sorry for that).

--- linux-2.6.orig/drivers/video/aty/radeon_base.c
+++ linux-2.6/drivers/video/aty/radeon_base.c
@@ -2331,9 +2331,9 @@ static int __devinit radeonfb_pci_regist
 
 	/* Register some sysfs stuff (should be done better) */
 	if (rinfo->mon1_EDID)
-		sysfs_create_bin_file(&rinfo->pdev->dev.kobj, &edid1_attr);
+		WARN_ON(sysfs_create_bin_file(&rinfo->pdev->dev.kobj, &edid1_attr));
 	if (rinfo->mon2_EDID)
-		sysfs_create_bin_file(&rinfo->pdev->dev.kobj, &edid2_attr);
+		WARN_ON(sysfs_create_bin_file(&rinfo->pdev->dev.kobj, &edid2_attr));
 
 	/* save current mode regs before we switch into the new one
 	 * so we can restore this upon __exit

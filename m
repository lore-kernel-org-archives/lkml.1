Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbXCSJ0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbXCSJ0G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 05:26:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbXCSJ0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 05:26:06 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:34846 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753356AbXCSJZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 05:25:49 -0400
Date: Mon, 19 Mar 2007 10:25:52 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Ondrej Zajicek <santiago@crfreenet.org>,
       James Simmons <jsimmons@infradead.org>, adaplas@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/video/s3fb.c: fix a use-before-check
Message-ID: <20070319092552.GP752@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

NULL checks should be before the first dereference.

Spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc3-mm2/drivers/video/s3fb.c.old	2007-03-19 09:20:22.000000000 +0100
+++ linux-2.6.21-rc3-mm2/drivers/video/s3fb.c	2007-03-19 09:21:07.000000000 +0100
@@ -1000,11 +1000,12 @@ err_enable_device:
 static void __devexit s3_pci_remove(struct pci_dev *dev)
 {
 	struct fb_info *info = pci_get_drvdata(dev);
-	struct s3fb_info *par = info->par;
 
 	if (info) {
 
 #ifdef CONFIG_MTRR
+		struct s3fb_info *par = info->par;
+
 		if (par->mtrr_reg >= 0) {
 			mtrr_del(par->mtrr_reg, 0, 0);
 			par->mtrr_reg = -1;


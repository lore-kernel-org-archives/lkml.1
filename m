Return-Path: <linux-kernel-owner+w=401wt.eu-S936169AbXJPX1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936169AbXJPX1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 19:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754223AbXJPX1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 19:27:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34937 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036AbXJPX1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 19:27:20 -0400
Date: Wed, 17 Oct 2007 00:27:18 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, adaplas@gmail.com
Subject: [PATCH] fix cirrusfb breakage
Message-ID: <20071016232718.GD8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/video/cirrusfb.c b/drivers/video/cirrusfb.c
index ce22bf5..f99cb77 100644
--- a/drivers/video/cirrusfb.c
+++ b/drivers/video/cirrusfb.c
@@ -2225,8 +2225,9 @@ static void cirrusfb_pci_unmap(struct fb_info *info)
 #endif /* CONFIG_PCI */
 
 #ifdef CONFIG_ZORRO
-static void __devexit cirrusfb_zorro_unmap(struct cirrusfb_info *cinfo)
+static void __devexit cirrusfb_zorro_unmap(struct fb_info *info)
 {
+	struct cirrusfb_info *cinfo = info->par;
 	zorro_release_device(cinfo->zdev);
 
 	if (cinfo->btype == BT_PICASSO4) {
@@ -2573,7 +2574,7 @@ static int cirrusfb_zorro_register(struct zorro_dev *z,
 	printk(KERN_INFO "Cirrus Logic chipset on Zorro bus\n");
 	zorro_set_drvdata(z, info);
 
-	ret = cirrusfb_register(cinfo);
+	ret = cirrusfb_register(info);
 	if (ret) {
 		if (btype == BT_PICASSO4) {
 			iounmap(info->screen_base);

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbYKJKxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbYKJKxZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 05:53:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbYKJKxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 05:53:17 -0500
Received: from smtp.zeuux.org ([210.51.160.52]:52774 "EHLO z.billxu.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbYKJKxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 05:53:16 -0500
Date: Mon, 10 Nov 2008 18:53:32 +0800
From: Jianjun Kong <jianjun@zeuux.org>
To: spock@gentoo.org
Cc: Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH] drivers: process failure of sysfs_create_group()
Message-ID: <20081110105332.GA19358@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


drivers: drivers/video/uvesafb.c:
When fail to call sysfs_create_group(), it should recycle resources and return the error.
This patch fix for processing failure of sysfs_create_group().

Signed-off-by: Jianjun Kong <jianjun@zeuux.org>
---
 drivers/video/uvesafb.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index 6c2d37f..a78d4d9 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -1811,12 +1811,16 @@ static int __devinit uvesafb_probe(struct platform_device *dev)
 			info->fix.id);
 
 	err = sysfs_create_group(&dev->dev.kobj, &uvesafb_dev_attgrp);
-	if (err != 0)
+	if (err != 0) {
 		printk(KERN_WARNING "fb%d: failed to register attributes\n",
 			info->node);
+		goto out_frame;
+	}
 
 	return 0;
 
+our_frame:
+	unregister_framebuffer(info);
 out_reg:
 	release_region(0x3c0, 32);
 out_unmap:
-- 
1.5.6.3


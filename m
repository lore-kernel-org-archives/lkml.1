Return-Path: <linux-kernel-owner+w=401wt.eu-S1762660AbXJNRwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762660AbXJNRwx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 13:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758570AbXJNRvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 13:51:10 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35256 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759382AbXJNRvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 13:51:07 -0400
Date: Sun, 14 Oct 2007 19:51:37 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] ivtv: fix NULL dereference
Message-ID: <20071014175137.GM4211@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We shouldn't dereference "itv" when we know it's NULL...

Spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
--- linux-2.6/drivers/media/video/ivtv/ivtv-fileops.c.old	2007-10-14 19:17:12.000000000 +0200
+++ linux-2.6/drivers/media/video/ivtv/ivtv-fileops.c	2007-10-14 19:18:05.000000000 +0200
@@ -947,7 +947,7 @@ int ivtv_v4l2_open(struct inode *inode, 
 	if (itv == NULL) {
 		/* Couldn't find a device registered
 		   on that minor, shouldn't happen! */
-		IVTV_WARN("No ivtv device found on minor %d\n", minor);
+		printk(KERN_WARNING "No ivtv device found on minor %d\n", minor);
 		return -ENXIO;
 	}
 


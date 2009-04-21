Return-Path: <linux-kernel-owner+w=401wt.eu-S1754323AbZDUO0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbZDUO0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 10:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbZDUO0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 10:26:35 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:7659 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbZDUO0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 10:26:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=e3JNKESXIs49F5VOm6dkhx1LKvrlbr5wFbi0dMufu2JokaAvovqpcWFx6F0cz7O64N
         9L+st+rcjZ2fxtV0h8laLV9rzN863+U10J/G9LW/kbSsNoIFtfeoUQaKdGUcAY9MnAT3
         Xmv7vjwvGAnO3GsNVOzemvIIav9JvDH9xOO/g=
Message-ID: <49EDD799.8060607@gmail.com>
Date: Tue, 21 Apr 2009 16:26:33 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: adaplas@gmail.com
CC: linux-fbdev-devel@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>
Subject: fbcmap: non working tests on unsigned cmap->start
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vi include/linux/fb.h +478

Note that struct fb_cmap_user cmap->start in fb_set_user_cmap() is unsigned.
Should there maybe be a test:

if (cmap->start > MAX || ...)

(and what should MAX be then?)

Otherwise you may want to apply the cleanup patch below

Roel
------------------------------>8-------------8<---------------------------------
Remove redundant tests on unsigned

Signed-off-by: Roel Kluin <roel.kluin@gmail.com> 
---
diff --git a/drivers/video/fbcmap.c b/drivers/video/fbcmap.c
index f53b9f1..958bf4e 100644
--- a/drivers/video/fbcmap.c
+++ b/drivers/video/fbcmap.c
@@ -266,8 +266,7 @@ int fb_set_user_cmap(struct fb_cmap_user *cmap, struct fb_info *info)
 		rc = -ENODEV;
 		goto out;
 	}
-	if (cmap->start < 0 || (!info->fbops->fb_setcolreg &&
-				!info->fbops->fb_setcmap)) {
+	if (!info->fbops->fb_setcolreg && !info->fbops->fb_setcmap) {
 		rc = -EINVAL;
 		goto out1;
 	}

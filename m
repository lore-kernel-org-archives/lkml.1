Return-Path: <linux-kernel-owner+w=401wt.eu-S1752455AbZJTTUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbZJTTUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 15:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbZJTTUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 15:20:35 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:63223 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbZJTTUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 15:20:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=pghU+gvKk5TxqhdV3HwEJfOvNZp7aQjBe1b85nCbhQ8okjS6eFPPc4gCoezjYoklzH
         s8KHodujiEkvJ2LB6pW/JPJBFrtL2Vp0elfeNL9JrbfnA3iQKYBcx2yn8mDppTMPTQLm
         RSykVpFXQrp8KgxKPlOsrfFsrZ0VHbaX2aR6A=
Message-ID: <4ADE0FDE.5070101@gmail.com>
Date: Tue, 20 Oct 2009 21:30:38 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] fbdev: Wrong test on unsigned in fb_set_user_cmap()?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct fb_cmap_user member start is unsigned.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Is this required?

diff --git a/drivers/video/fbcmap.c b/drivers/video/fbcmap.c
index f53b9f1..f46f05f 100644
--- a/drivers/video/fbcmap.c
+++ b/drivers/video/fbcmap.c
@@ -266,7 +266,7 @@ int fb_set_user_cmap(struct fb_cmap_user *cmap, struct fb_info *info)
 		rc = -ENODEV;
 		goto out;
 	}
-	if (cmap->start < 0 || (!info->fbops->fb_setcolreg &&
+	if ((int)cmap->start < 0 || (!info->fbops->fb_setcolreg &&
 				!info->fbops->fb_setcmap)) {
 		rc = -EINVAL;
 		goto out1;

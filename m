Return-Path: <linux-kernel-owner+w=401wt.eu-S1756792AbYA0Lf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbYA0Lf1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 06:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbYA0LfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 06:35:19 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:3058 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbYA0LfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 06:35:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version:content-type:content-disposition:x-pgp-key:user-agent:sender;
        b=oWxndpKD3aBgCPTLQyEHWdi6LwObHDiOGe1vHPBmwxmOG78oYGcf47sjANcd3M+GGppOzSYZkJS6RFaNBGoUqUI3l3yntoBYrDdfSlYYOlHqC6WBwDiIZCv/kiMy34gdi0jquxfz1e0zmtrMp+mlO2AT8Az/bCr448+GIqVtTg8=
Date: Sun, 27 Jan 2008 12:34:56 +0100
From: Michal Januszewski <spock@gentoo.org>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] uvesafb: don't treat valid modes returned by
	fb_find_mode() as errors
Message-ID: <20080127113456.GA17976@spock.one.pl>
Reply-To: spock@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Januszewski <spock@gentoo.org>

Don't treat valid modes returned by fb_find_mode() (best-fit modes,
default modes or the first valid mode) as errors.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
---
diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index a14ef89..fc68b3e 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -885,7 +885,7 @@ static int __devinit uvesafb_vbe_init_mode(struct fb_info *info)
 	}
 
 	/* fb_find_mode() failed */
-	if (i == 0 || i >= 3) {
+	if (i == 0) {
 		info->var.xres = 640;
 		info->var.yres = 480;
 		mode = (struct fb_videomode *)



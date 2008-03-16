Return-Path: <linux-kernel-owner+w=401wt.eu-S1752609AbYCPLYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbYCPLYB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 07:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbYCPLXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 07:23:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:43917 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbYCPLXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 07:23:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:x-pgp-key:user-agent:sender;
        b=VshhCVw75wHkF8U+BlP3GLdfB1JK9hTlC+Ho2iPYj9YIXg/cd/Ui5b3+DHRifY3Vn8cZ7K966w0eOSQOEf0ruzwhQV/LokhHD06eTAFA0o0yN3EZelElArwjTjIvcVTi377lHXm+/tyw/BJoR5fiGNEEEJgDAdZ/2PBE2RZEYCw=
Date: Sun, 16 Mar 2008 12:23:38 +0100
From: Michal Januszewski <spock@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] uvesafb: don't treat valid modes returned by
	fb_find_mode() as errors
Message-ID: <20080316112338.GA4788@spock.one.pl>
Reply-To: spock@gentoo.org
References: <20080127113456.GA17976@spock.one.pl> <20080305225412.ad1d3bb5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080305225412.ad1d3bb5.akpm@linux-foundation.org>
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Januszewski <spock@gentoo.org>

Don't treat valid modes returned by fb_find_mode() (best-fit modes,
default modes or the first valid mode) as errors.

Currently, when fb_find_mode() finds a valid mode belonging to one
of the above-mentioned classes, uvesafb will ignore it and will try
to set a 640x480 video mode.  The expected behaviour (introduced by
this patch) would be to use the valid mode returned by fb_find_mode()
instead.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
---
As requested, this patch contains an expanded changelog message.  The
bug is by no means critical and should have no impact on the large
majority of users, so it's definitely not 2.6.24 material.

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



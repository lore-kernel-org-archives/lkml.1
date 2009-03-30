Return-Path: <linux-kernel-owner+w=401wt.eu-S1762579AbZC3WOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762579AbZC3WOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 18:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762513AbZC3WNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 18:13:51 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:48218 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762505AbZC3WNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 18:13:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:x-pgp-key:user-agent;
        b=pNcjZKWzBSRtIqcYMKgbs6LdtmH+mddflgP/2L9+fSGNvBA7ZQXcENKYgciUBl0Lh3
         ZIXVP4WjYcqW20+rOUaKlOVEdaONrzrkMxD42MTgqr3R89aEm0vNLw7VrlA4SNclrFIM
         IhGfy2F3IHPcJYrC11lNcz9T4r0ihato2z7wE=
Date: Tue, 31 Mar 2009 00:13:40 +0200
From: Michal Januszewski <spock@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: thomas@winischhofer.net, linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH] sisfb: fix color component length for pseudocolor modes
Message-ID: <20090330221340.GF6993@spock.one.pl>
Reply-To: spock@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sisfb incorrectly sets the length of the color fields to 6 bits
for PSEUDOCOLOR modes, even though 8 bits are always used per pixel.
Fix this by setting the length to 8.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
---
diff --git a/drivers/video/sis/sis_main.c b/drivers/video/sis/sis_main.c
index 346d645..7e17ee9 100644
--- a/drivers/video/sis/sis_main.c
+++ b/drivers/video/sis/sis_main.c
@@ -1129,7 +1129,7 @@ sisfb_bpp_to_var(struct sis_video_info *ivideo, struct fb_var_screeninfo *var)
 	switch(var->bits_per_pixel) {
 	case 8:
 		var->red.offset = var->green.offset = var->blue.offset = 0;
-		var->red.length = var->green.length = var->blue.length = 6;
+		var->red.length = var->green.length = var->blue.length = 8;
 		break;
 	case 16:
 		var->red.offset = 11;


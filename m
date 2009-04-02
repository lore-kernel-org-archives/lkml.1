Return-Path: <linux-kernel-owner+w=401wt.eu-S1757705AbZDBM0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705AbZDBM0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 08:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756186AbZDBM0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 08:26:32 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:53317 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757383AbZDBM0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 08:26:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:reply-to:references
         :mime-version:content-type:content-disposition:in-reply-to:x-pgp-key
         :user-agent;
        b=wh/b9+JVFOlD+pnfQHJJ+Od4D0Daer8ndLbHUe/PxRP1abY5IF22WlyNIs5TybAkBQ
         62bAfzchpWsbD63HFoDi/R/PEdQ/kSE8n96u8z9w/X2lmj/xnxCc1nMtAVdceU0DIgdX
         KS0nprssDeosn3fazQwpqW6Tzk/wJU9pn2+aQ=
Date: Thu, 2 Apr 2009 14:26:13 +0200
From: Michal Januszewski <spock@gentoo.org>
To: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH] vga16fb: fix color component length for pseudocolor modes
Message-ID: <20090402122613.GA16899@tria>
Reply-To: spock@gentoo.org
References: <20090330220523.GA6993@spock.one.pl> <20090401185856.44d89699.krzysztof.h1@poczta.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090401185856.44d89699.krzysztof.h1@poczta.fm>
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vga16fb incorrectly sets the length of the color fields to 6 or 2 bits
for PSEUDOCOLOR modes, for which either 8 or 4 bits are used per pixel.
Fix this by setting the length to 8 or 4, respectively.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
---
diff --git a/drivers/video/vga16fb.c b/drivers/video/vga16fb.c
index 5b29389..8f1eb7f 100644
--- a/drivers/video/vga16fb.c
+++ b/drivers/video/vga16fb.c
@@ -506,7 +506,7 @@ static int vga16fb_check_var(struct fb_var_screeninfo *var,
 	var->red.offset = var->green.offset = var->blue.offset = 
 	var->transp.offset = 0;
 	var->red.length = var->green.length = var->blue.length =
-		(par->isVGA) ? 6 : 2;
+		(par->isVGA) ? 8 : 4;
 	var->transp.length = 0;
 	var->activate = FB_ACTIVATE_NOW;
 	var->height = -1;
@@ -1324,7 +1324,7 @@ static int __init vga16fb_probe(struct platform_device *dev)
 	par->palette_blanked = 0;
 	par->vesa_blanked = 0;
 
-	i = par->isVGA? 6 : 2;
+	i = par->isVGA? 8 : 4;
 	
 	vga16fb_defined.red.length   = i;
 	vga16fb_defined.green.length = i;

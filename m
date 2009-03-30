Return-Path: <linux-kernel-owner+w=401wt.eu-S1762020AbZC3WFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762020AbZC3WFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 18:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754926AbZC3WFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 18:05:34 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:39654 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836AbZC3WFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 18:05:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:x-pgp-key:user-agent;
        b=Q8w2QuH/oDU7WUN3ZwWImz2+9lIgVSFH692zKbKC4ARj5B8T5Y9OrEnHF6VydU5EHy
         UvKUWSFxccM4s3T4y3rLq0kBsrKKIK58avZH/XWJdS3t872t8lyYF3tWZc52w4jACyoI
         yBUtquVdm29G4qbaZnEvUepBMIs4gMdpFArSc=
Date: Tue, 31 Mar 2009 00:05:24 +0200
From: Michal Januszewski <spock@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH] vga16fb: fix color component length for pseudocolor modes
Message-ID: <20090330220523.GA6993@spock.one.pl>
Reply-To: spock@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
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
index 5b29389..50033b9 100644
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

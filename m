Return-Path: <linux-kernel-owner+w=401wt.eu-S1762208AbZC3WJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762208AbZC3WJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 18:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760117AbZC3WI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 18:08:58 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:61380 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762159AbZC3WI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 18:08:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:x-pgp-key:user-agent;
        b=ajm0ZrwzSoCDKx9ximJw4E+/Mdkn85fjwgQG9YfMIQRgfOTal+gVJoNl0SLEJi2CvM
         vE5WaYUres3L6ZtyTsK1F6g8kEn9vuYdyK3opJcH9+odavdFN8ToH3ECOIQmQNk3h7sP
         LiqPCxb9kZS78xxIEBqy//H6iQJQjDgLX34mc=
Date: Tue, 31 Mar 2009 00:08:48 +0200
From: Michal Januszewski <spock@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fbdev-devel@lists.sourceforge.net, Knut_Petersen@t-online.de
Subject: [PATCH] cyblafb: fix color component length for pseudocolor modes
Message-ID: <20090330220848.GC6993@spock.one.pl>
Reply-To: spock@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cyblafb incorrectly sets the length of the color fields to 6 bits
for PSEUDOCOLOR modes, even though 8 bits are always used per pixel.
Fix this by setting the length to 8.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
Cc: Knut Petersen <Knut_Petersen@t-online.de>
---
diff --git a/drivers/video/cyblafb.c b/drivers/video/cyblafb.c
index 9704b73..8e3a264 100644
--- a/drivers/video/cyblafb.c
+++ b/drivers/video/cyblafb.c
@@ -615,9 +615,9 @@ static int cyblafb_check_var(struct fb_var_screeninfo *var,
 		var->red.offset = 0;
 		var->green.offset = 0;
 		var->blue.offset = 0;
-		var->red.length = 6;
-		var->green.length = 6;
-		var->blue.length = 6;
+		var->red.length = 8;
+		var->green.length = 8;
+		var->blue.length = 8;
 		break;
 	case 16:
 		var->red.offset = 11;

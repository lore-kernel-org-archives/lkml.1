Return-Path: <linux-kernel-owner+w=401wt.eu-S1761924AbZC3WHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761924AbZC3WHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 18:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757806AbZC3WHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 18:07:21 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:42802 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757232AbZC3WHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 18:07:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:user-agent;
        b=DTdZ45/l4dIh8exJY/azm+q0CiKCQjqLIcCzzhilyzPPJ2NU2AGUwge6H/sSyFh6Di
         FMpHMqc+C9ArZmogZfojdgvy87WF+qnZvT32XL1dy/4VvE8bT6wjoNzsFHySEHcu9rxc
         k60c+EchNKrURMz8Cnw2KR/ywDmjvqgfHdltk=
Date: Tue, 31 Mar 2009 00:07:10 +0200
From: Michal Januszewski <spock@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH] cirrusfb: fix color component length for pseudocolor modes
Message-ID: <20090330220710.GB6993@spock.one.pl>
Reply-To: spock@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cirrusfb incorrectly sets the length of the color fields to 6 bits
for PSEUDOCOLOR modes, even though 8 bits are always used per pixel.
Fix this by setting the length to 8.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
---
diff --git a/drivers/video/cirrusfb.c b/drivers/video/cirrusfb.c
index a2aa6dd..2dfe0e7 100644
--- a/drivers/video/cirrusfb.c
+++ b/drivers/video/cirrusfb.c
@@ -550,7 +550,7 @@ static int cirrusfb_check_var(struct fb_var_screeninfo *var,
 
 	case 8:
 		var->red.offset = 0;
-		var->red.length = 6;
+		var->red.length = 8;
 		var->green = var->red;
 		var->blue = var->red;
 		break;


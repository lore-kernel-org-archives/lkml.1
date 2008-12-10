Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbYLKABR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbYLKABR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 19:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbYLKABB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 19:01:01 -0500
Received: from smtp.tal.de ([81.92.1.5]:56615 "EHLO smtp.tal.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbYLKABA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 19:01:00 -0500
X-Greylist: delayed 1752 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Dec 2008 19:01:00 EST
From: ib@wupperonline.de (Ingo Brueckl)
Date: Wed, 10 Dec 2008 23:35:00 +0100
Subject: [PATCH] console ASCII glyph 1:1 mapping
X-Mailer: blueMail 1.4 (SlipDoor 2.2)
Message-ID: <4940441e@wupperonline.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the console, there is a 1:1 mapping of glyphs which cannot be found in the current font. This seems to be meant as a kind of 'emergency fallback' for fonts without unicode mapping which otherwise would display nothing readable on the screen.

At the moment it affects all chars for which no substitution character is defined. In particular this means that for all chars (>= 128) where there is no iso88591-1/unicode character (e.g. control character area) you'll get the very strange 1:1 mapping of the (cp437) graphics card glyphs.

I'm pretty sure that the 1:1 mapping should only affect strict ASCII code characters, i.e. chars < 128.

The patch limits the mapping as it probably was meant anyway.

Signed-off-by: Ingo Brueckl <ib@wupperonline.de>

--- linux-2.6.27.8.orig/drivers/char/vt.c	2008-12-05 21:03:02.000000000 +0100
+++ linux-2.6.27.8/drivers/char/vt.c	2008-12-10 20:51:30.000000000 +0100
@@ -2287,7 +2287,7 @@ rescan_last_byte:
 				    continue; /* nothing to display */
 				}
 				/* Glyph not found */
-				if ((!(vc->vc_utf && !vc->vc_disp_ctrl) || c < 128) && !(c & ~charmask)) {
+				if ((!(vc->vc_utf && !vc->vc_disp_ctrl) && c < 128) && !(c & ~charmask)) {
 				    /* In legacy mode use the glyph we get by a 1:1 mapping.
 				       This would make absolutely no sense with Unicode in mind,
 				       but do this for ASCII characters since a font may lack

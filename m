Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbYDWRVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbYDWRVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 13:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbYDWRVC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 13:21:02 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:58277 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbYDWRVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 13:21:00 -0400
Message-ID: <480F6FF9.9000605@tiscali.nl>
Date: Wed, 23 Apr 2008 19:20:57 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: adaplas@gmail.com, linux-fbdev-devel@lists.sourceforge.net
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] vga16fb: test virtual screen range before subtraction on
 unsigned
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dx and dy are u32's, so the test should occur before the subtraction

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/video/vga16fb.c b/drivers/video/vga16fb.c
index 9b3c592..9d27517 100644
--- a/drivers/video/vga16fb.c
+++ b/drivers/video/vga16fb.c
@@ -1087,12 +1087,15 @@ static void vga16fb_copyarea(struct fb_info *info, const struct fb_copyarea *are
 	width = x2 - dx;
 	height = y2 - dy;
 
+	if (sx + dx < old_dx || sy + dy < old_dy)
+		return;
+
 	/* update sx1,sy1 */
 	sx += (dx - old_dx);
 	sy += (dy - old_dy);
 
 	/* the source must be completely inside the virtual screen */
-	if (sx < 0 || sy < 0 || (sx + width) > vxres || (sy + height) > vyres)
+	if (sx + width > vxres || sy + height > vyres)
 		return;
 
 	switch (info->fix.type) {

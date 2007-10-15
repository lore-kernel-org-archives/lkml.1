Return-Path: <linux-kernel-owner+w=401wt.eu-S1765695AbXJORmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765695AbXJORmZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 13:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756646AbXJORmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 13:42:17 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:34533 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616AbXJORmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 13:42:15 -0400
Date: Mon, 15 Oct 2007 18:42:07 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Antonino Daplas <adaplas@pol.net>,
       linux-fbdev-devel@lists.sourceforge.net
cc: Jay Estabrook <Jay.Estabrook@hp.com>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] tgafb: Remove a redundant non-mono test in mono imageblit
Message-ID: <Pine.LNX.4.64N.0710151836490.16262@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 There is a test in tgafb_mono_imageblit() for a colour image with a 
fall-back to cfb_imageblit().  The test is not necessary as the only 
caller, which is tgafb_imageblit(), checks it too and only invokes this 
function for monochrome images.  It looks like a left-over from before 
some changes to tgafb_imageblit().

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 Checked with checkpatch.pl and at the run time with an 8-bit TC frame
buffer on a MIPS host.

 Please apply.

  Maciej

patch-mips-2.6.23-rc5-20070904-tgafb-mono_imageblit-depth-0
diff -up --recursive --new-file linux-mips-2.6.23-rc5-20070904.macro/drivers/video/tgafb.c linux-mips-2.6.23-rc5-20070904/drivers/video/tgafb.c
--- linux-mips-2.6.23-rc5-20070904.macro/drivers/video/tgafb.c	2007-09-04 04:55:46.000000000 +0000
+++ linux-mips-2.6.23-rc5-20070904/drivers/video/tgafb.c	2007-10-14 20:32:13.000000000 +0000
@@ -636,15 +636,6 @@ tgafb_mono_imageblit(struct fb_info *inf
 
 	is8bpp = info->var.bits_per_pixel == 8;
 
-	/* For copies that aren't pixel expansion, there's little we
-	   can do better than the generic code.  */
-	/* ??? There is a DMA write mode; I wonder if that could be
-	   made to pull the data from the image buffer...  */
-	if (image->depth > 1) {
-		cfb_imageblit(info, image);
-		return;
-	}
-
 	dx = image->dx;
 	dy = image->dy;
 	width = image->width;

Return-Path: <linux-kernel-owner+w=401wt.eu-S1423484AbXD3PxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423484AbXD3PxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:53:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423480AbXD3PxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:53:08 -0400
Received: from ns2.suse.de ([195.135.220.15]:34404 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423484AbXD3PuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:50:08 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430549.617098000@suse.de>
In-Reply-To: <20070430549.617098000@suse.de>
To: kraxel@suse.de, alan@lxorguk.ukuu.org.uk, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [34/34] x86_64: ignore vgacon if hardware not present
Message-Id: <20070430155007.E4996151F8@wotan.suse.de>
Date: Mon, 30 Apr 2007 17:50:07 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Gerd Hoffmann <kraxel@suse.de>

Avoid trying to set up vgacon if there's no vga hardware present.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Alan <alan@lxorguk.ukuu.org.uk>
Acked-by: Ingo Molnar <mingo@elte.hu>

---
 drivers/video/console/vgacon.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

===================================================================
Index: linux/drivers/video/console/vgacon.c
===================================================================
--- linux.orig/drivers/video/console/vgacon.c
+++ linux/drivers/video/console/vgacon.c
@@ -371,7 +371,8 @@ static const char *vgacon_startup(void)
 	}
 
 	/* VGA16 modes are not handled by VGACON */
-	if ((ORIG_VIDEO_MODE == 0x0D) ||	/* 320x200/4 */
+	if ((ORIG_VIDEO_MODE == 0x00) ||	/* SCREEN_INFO not initialized */
+	    (ORIG_VIDEO_MODE == 0x0D) ||	/* 320x200/4 */
 	    (ORIG_VIDEO_MODE == 0x0E) ||	/* 640x200/4 */
 	    (ORIG_VIDEO_MODE == 0x10) ||	/* 640x350/4 */
 	    (ORIG_VIDEO_MODE == 0x12) ||	/* 640x480/4 */

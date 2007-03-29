Return-Path: <linux-kernel-owner+w=401wt.eu-S965980AbXC2HrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965980AbXC2HrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 03:47:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965979AbXC2HrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 03:47:12 -0400
Received: from ozlabs.org ([203.10.76.45]:33330 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965980AbXC2HrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 03:47:11 -0400
Subject: [PATCH] ignore vgacon if hardware not present
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>, Gerd Hoffmann <kraxel@suse.de>,
       Alan <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 29 Mar 2007 17:46:48 +1000
Message-Id: <1175154408.12230.195.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(Did this fall through the cracks?  I don't see it in -mm.  It's
standalone, and saves some silly code in lguest and presumably others).
==

Avoid trying to set up vgacon if there's no vga hardware present.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
From: Gerd Hoffmann <kraxel@suse.de>
Cc: Alan <alan@lxorguk.ukuu.org.uk>
Acked-by: Ingo Molnar <mingo@elte.hu>

---
 drivers/video/console/vgacon.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

===================================================================
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -372,7 +372,8 @@ static const char *vgacon_startup(void)
 	}
 
 	/* VGA16 modes are not handled by VGACON */
-	if ((ORIG_VIDEO_MODE == 0x0D) ||	/* 320x200/4 */
+	if ((ORIG_VIDEO_MODE == 0x00) ||	/* SCREEN_INFO not initialized */
+	    (ORIG_VIDEO_MODE == 0x0D) ||	/* 320x200/4 */
 	    (ORIG_VIDEO_MODE == 0x0E) ||	/* 640x200/4 */
 	    (ORIG_VIDEO_MODE == 0x10) ||	/* 640x350/4 */
 	    (ORIG_VIDEO_MODE == 0x12) ||	/* 640x480/4 */



Return-Path: <linux-kernel-owner+w=401wt.eu-S1030579AbXB0Iqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030579AbXB0Iqr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 03:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932780AbXB0IiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 03:38:22 -0500
Received: from gw.goop.org ([64.81.55.164]:46801 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932799AbXB0IiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 03:38:19 -0500
Message-Id: <20070227081629.908636118@goop.org>
References: <20070227081337.434798469@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 27 Feb 2007 00:13:39 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@muc.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [patch 02/26] Xen-paravirt_ops: ignore vgacon if hardware not present
Content-Disposition: inline; filename=vgacon-ignore-uninitialized.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid trying to set up vgacon if there's no vga hardware present.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
From: Gerd Hoffmann <kraxel@suse.de>

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

-- 


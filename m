Return-Path: <linux-kernel-owner+w=401wt.eu-S1161263AbXCBABQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161263AbXCBABQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 19:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161313AbXCAX4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 18:56:52 -0500
Received: from 207.47.60.4.static.nextweb.net ([207.47.60.4]:47864 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161262AbXCAX4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 18:56:48 -0500
Message-Id: <20070301232525.875538104@goop.org>
References: <20070301232443.195603797@goop.org>
User-Agent: quilt/0.46-1
Date: Thu, 01 Mar 2007 15:24:45 -0800
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


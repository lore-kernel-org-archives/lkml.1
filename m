Return-Path: <linux-kernel-owner+w=401wt.eu-S1755838AbZBGRTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbZBGRTn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 12:19:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbZBGRTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 12:19:04 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:43435 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755409AbZBGRTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 12:19:00 -0500
Date: Sat, 7 Feb 2009 12:18:57 -0500
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com
Subject: [PATCH 14/15] amifb: check fb_alloc_cmap return value and handle
 failure properly
Message-ID: <20090207121857.6bc5d5bc@ephemeral>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/video/amifb.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/video/amifb.c b/drivers/video/amifb.c
index 100f236..82bedd7 100644
--- a/drivers/video/amifb.c
+++ b/drivers/video/amifb.c
@@ -2437,7 +2437,9 @@ default_chipset:
 		goto amifb_error;
 	}
 
-	fb_alloc_cmap(&fb_info.cmap, 1<<fb_info.var.bits_per_pixel, 0);
+	err = fb_alloc_cmap(&fb_info.cmap, 1<<fb_info.var.bits_per_pixel, 0);
+	if (err)
+		goto amifb_error;
 
 	if (register_framebuffer(&fb_info) < 0) {
 		err = -EINVAL;
@@ -2456,7 +2458,8 @@ amifb_error:
 
 static void amifb_deinit(void)
 {
-	fb_dealloc_cmap(&fb_info.cmap);
+	if (fb_info.cmap.len)
+		fb_dealloc_cmap(&fb_info.cmap);
 	chipfree();
 	if (videomemory)
 		iounmap((void*)videomemory);
-- 
1.5.6.5


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755770AbZBGRXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbZBGRXi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 12:23:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472AbZBGRWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 12:22:33 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:43444 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083AbZBGRWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 12:22:31 -0500
Date: Sat, 7 Feb 2009 12:14:48 -0500
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com
Subject: [PATCH 6/15] sm501fb: check fb_alloc_cmap return value and handle
 failure properly
Message-ID: <20090207121448.7b18c3fd@ephemeral>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/video/sm501fb.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/video/sm501fb.c b/drivers/video/sm501fb.c
index dcd9879..eb5d73a 100644
--- a/drivers/video/sm501fb.c
+++ b/drivers/video/sm501fb.c
@@ -1525,7 +1525,10 @@ static int sm501fb_init_fb(struct fb_info *fb,
 	}
 
 	/* initialise and set the palette */
-	fb_alloc_cmap(&fb->cmap, NR_PALETTE, 0);
+	if (fb_alloc_cmap(&fb->cmap, NR_PALETTE, 0)) {
+		dev_err(info->dev, "failed to allocate cmap memory\n");
+		return -ENOMEM;
+	}
 	fb_set_cmap(&fb->cmap, fb);
 
 	ret = (fb->fbops->fb_check_var)(&fb->var, fb);
-- 
1.5.6.5


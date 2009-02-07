Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbZBGRXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbZBGRXV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 12:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbZBGRWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 12:22:32 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:43443 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075AbZBGRWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 12:22:31 -0500
Date: Sat, 7 Feb 2009 12:12:42 -0500
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com
Subject: [PATCH 4/15] vfb: fix memory leaks in removal path
Message-ID: <20090207121242.21c07e0e@ephemeral>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We were leaking the cmap memory.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/video/vfb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/video/vfb.c b/drivers/video/vfb.c
index 93fe08d..cc919ae 100644
--- a/drivers/video/vfb.c
+++ b/drivers/video/vfb.c
@@ -543,6 +543,7 @@ static int vfb_remove(struct platform_device *dev)
 	if (info) {
 		unregister_framebuffer(info);
 		rvfree(videomemory, videomemorysize);
+		fb_dealloc_cmap(&info->cmap);
 		framebuffer_release(info);
 	}
 	return 0;
-- 
1.5.6.5


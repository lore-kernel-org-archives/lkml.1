Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251AbZBGRWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbZBGRWn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 12:22:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbZBGRWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 12:22:31 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:43442 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022AbZBGRWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 12:22:30 -0500
Date: Sat, 7 Feb 2009 12:12:15 -0500
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com
Subject: [PATCH 1/15] fix memory leaks in removal path
Message-ID: <20090207121215.77e45acf@ephemeral>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We were leaking both the cmap memory and the info struct memory.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/video/sgivwfb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/video/sgivwfb.c b/drivers/video/sgivwfb.c
index f5252c2..bba5371 100644
--- a/drivers/video/sgivwfb.c
+++ b/drivers/video/sgivwfb.c
@@ -837,6 +837,8 @@ static int sgivwfb_remove(struct platform_device *dev)
 		iounmap(par->regs);
 		iounmap(info->screen_base);
 		release_mem_region(DBE_REG_PHYS, DBE_REG_SIZE);
+		fb_dealloc_cmap(&info->cmap);
+		framebuffer_release(info);
 	}
 	return 0;
 }
-- 
1.5.6.5


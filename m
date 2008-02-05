Return-Path: <linux-kernel-owner+w=401wt.eu-S1759314AbYBESlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759314AbYBESlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 13:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbYBESlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 13:41:08 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:50367 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755134AbYBESlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 13:41:07 -0500
Date: Tue, 5 Feb 2008 21:40:42 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: adaplas@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] fb: fix warning: no return statement in function returning non-void
Message-ID: <20080205184042.GA16247@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Warning is reproducible with selected FB_CFB_REV_PIXELS_IN_BYTE.

  CC      drivers/video/sysfillrect.o
In file included from drivers/video/sysfillrect.c:18:
drivers/video/fb_draw.h: In function ‘fb_rev_pixels_in_long’:
drivers/video/fb_draw.h:94: warning: no return statement in function returning non-void
  CC      drivers/video/syscopyarea.o
In file included from drivers/video/syscopyarea.c:22:
drivers/video/fb_draw.h: In function ‘fb_rev_pixels_in_long’:
drivers/video/fb_draw.h:94: warning: no return statement in function returning non-void

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/video/fb_draw.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/video/fb_draw.h b/drivers/video/fb_draw.h
index cdafbe1..a2a0618 100644
--- a/drivers/video/fb_draw.h
+++ b/drivers/video/fb_draw.h
@@ -91,6 +91,7 @@ static inline unsigned long fb_rev_pixels_in_long(unsigned long val,
 		val = comp(val >> 2, val << 2, REV_PIXELS_MASK2);
 	if (bswapmask & 3)
 		val = comp(val >> 4, val << 4, REV_PIXELS_MASK4);
+	return val;
 }
 
 static inline u32 fb_shifted_pixels_mask_u32(u32 index, u32 bswapmask)
-- 
1.5.2.2

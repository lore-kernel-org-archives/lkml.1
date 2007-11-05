Return-Path: <linux-kernel-owner+w=401wt.eu-S1753606AbXKECaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbXKECaG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 21:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbXKEC34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 21:29:56 -0500
Received: from [222.73.24.84] ([222.73.24.84]:56935 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbXKEC34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 21:29:56 -0500
Message-ID: <472E7FBC.7020906@cn.fujitsu.com>
Date: Mon, 05 Nov 2007 10:28:12 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/6] drivers/video/ps3fb: fix memset size error
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The size passing to memset is wrong.

Signed-off-by Li Zefan <lizf@cn.fujitsu.com>

---
 drivers/video/ps3fb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/ps3fb.c b/drivers/video/ps3fb.c
index b3463dd..75836aa 100644
--- a/drivers/video/ps3fb.c
+++ b/drivers/video/ps3fb.c
@@ -727,7 +727,7 @@ static int ps3fb_blank(int blank, struct fb_info *info)
 
 static int ps3fb_get_vblank(struct fb_vblank *vblank)
 {
-	memset(vblank, 0, sizeof(&vblank));
+	memset(vblank, 0, sizeof(*vblank));
 	vblank->flags = FB_VBLANK_HAVE_VSYNC;
 	return 0;
 }
-- 
1.5.3.rc7


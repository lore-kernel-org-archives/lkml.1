Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbXKECZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbXKECZ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 21:25:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbXKECZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 21:25:49 -0500
Received: from [222.73.24.84] ([222.73.24.84]:53664 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753553AbXKECZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 21:25:49 -0500
Message-ID: <472E7EB9.1040904@cn.fujitsu.com>
Date: Mon, 05 Nov 2007 10:23:53 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.sourceforge.net,
       airlied@linux.ie
Subject: [PATCH 4/6] DRM: fix memset size error
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The size passing to memset is wrong.

Signed-off-by Li Zefan <lizf@cn.fujitsu.com>

---
 drivers/char/drm/drm_ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/drm/drm_ioctl.c b/drivers/char/drm/drm_ioctl.c
index d9be146..3cbebf8 100644
--- a/drivers/char/drm/drm_ioctl.c
+++ b/drivers/char/drm/drm_ioctl.c
@@ -272,7 +272,7 @@ int drm_getstats(struct drm_device *dev, void *data,
 	struct drm_stats *stats = data;
 	int i;
 
-	memset(stats, 0, sizeof(stats));
+	memset(stats, 0, sizeof(*stats));
 
 	mutex_lock(&dev->struct_mutex);
 
-- 
1.5.3.rc7


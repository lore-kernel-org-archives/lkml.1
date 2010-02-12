Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab0BLWkJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 17:40:09 -0500
Received: from mail.windriver.com ([147.11.1.11]:44605 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232Ab0BLWkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 17:40:00 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>,
       David Airlie <airlied@linux.ie>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Clemens Ladisch <clemens@ladisch.de>
Subject: [PATCH 5/7] drm_fb_helper: Preserve capability to use atomic kms
Date: Fri, 12 Feb 2010 16:36:26 -0600
Message-Id: <1266014188-29505-6-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1266014188-29505-1-git-send-email-jason.wessel@windriver.com>
References: <1266014188-29505-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 12 Feb 2010 22:39:27.0690 (UTC) FILETIME=[3BE942A0:01CAAC34]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 5349ef3127c77075ff70b2014f17ae0fbcaaf199 changed logic of when
a pixclock was valid vs invalid.

The atomic kernel mode setting used by the kernel debugger relied upon
the drm_fb_helper_check_var() to always return -EINVAL.  Until a
better solution exists, this behavior will be restored.

CC: David Airlie <airlied@linux.ie>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/gpu/drm/drm_fb_helper.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index ea06bf3..35ede53 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -677,7 +677,7 @@ int drm_fb_helper_check_var(struct fb_var_screeninfo *var,
 	struct drm_framebuffer *fb = fb_helper->fb;
 	int depth;
 
-	if (var->pixclock != 0)
+	if (var->pixclock != 0 || in_dbg_master())
 		return -EINVAL;
 
 	/* Need to resize the fb object !!! */
-- 
1.6.4.rc1


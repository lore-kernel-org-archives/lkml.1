Return-Path: <linux-kernel-owner+w=401wt.eu-S1763025AbZLQXZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763025AbZLQXZV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 18:25:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760945AbZLQXZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 18:25:17 -0500
Received: from mail.windriver.com ([147.11.1.11]:57303 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760127AbZLQXZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 18:25:15 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: David Airlie <airlied@linux.ie>
Cc: linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>,
       David Airlie <airlied@linux.ie>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Clemens Ladisch <clemens@ladisch.de>
Subject: [PATCH] drm_fb_helper: fix regression in pixclock check
Date: Thu, 17 Dec 2009 17:25:03 -0600
Message-Id: <1261092303-4570-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
X-OriginalArrivalTime: 17 Dec 2009 23:25:09.0924 (UTC) FILETIME=[2CDD3640:01CA7F70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 5349ef3127c77075ff70b2014f17ae0fbcaaf199 changed pixclock to be
initialized to zero instead of -1.  The validation routine always
returns -EINVAL for a valid pixclock which prevents atomic kernel mode
setting from working correctly.

CC: David Airlie <airlied@linux.ie>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/gpu/drm/drm_fb_helper.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 1b49fa0..7b59cf1 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -602,7 +602,7 @@ int drm_fb_helper_check_var(struct fb_var_screeninfo *var,
 	struct drm_framebuffer *fb = fb_helper->fb;
 	int depth;
 
-	if (var->pixclock != 0)
+	if (!var->pixclock)
 		return -EINVAL;
 
 	/* Need to resize the fb object !!! */
-- 
1.6.4.rc1


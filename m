Return-Path: <linux-kernel-owner+w=401wt.eu-S1756909Ab0ANPCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab0ANPCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 10:02:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756837Ab0ANPCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 10:02:16 -0500
Received: from mail.windriver.com ([147.11.1.11]:47942 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab0ANPB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 10:01:57 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>,
       David Airlie <airlied@linux.ie>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Clemens Ladisch <clemens@ladisch.de>
Subject: [PATCH 35/40] drm_fb_helper: Preserve capability to use atomic kms
Date: Thu, 14 Jan 2010 08:59:31 -0600
Message-Id: <1263481176-1897-36-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com>
References: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 14 Jan 2010 15:01:19.0632 (UTC) FILETIME=[6DC5B900:01CA952A]
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
index f65aa4d..1097a47 100644
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
1.6.3.1.9.g95405b


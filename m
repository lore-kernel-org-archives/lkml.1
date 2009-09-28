Return-Path: <linux-kernel-owner+w=401wt.eu-S1752740AbZI1Q0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbZI1Q0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 12:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbZI1Q0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 12:26:47 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:45530 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbZI1Q0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 12:26:47 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19136.58289.484320.591187@pilspetsen.it.uu.se>
Date: Mon, 28 Sep 2009 18:26:25 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: dri-devel@lists.sourceforge.net
Subject: [PATCH 2.6.32-rc1] fix drm_fb_helper warning when !CONFIG_MAGIC_SYSRQ
Cc: linux-kernel@vger.kernel.org
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compiling DRM throws the following warning if MAGIC_SYSRQ is disabled:

drivers/gpu/drm/drm_fb_helper.c:101: warning: 'sysrq_drm_fb_helper_restore_op' defined but not used

Fix: place sysrq_drm_fb_helper_restore_op and associated
definitions inside #ifdef CONFIG_MAGIC_SYSRQ.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
---
 drivers/gpu/drm/drm_fb_helper.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.32-rc1/drivers/gpu/drm/drm_fb_helper.c.~1~	2009-09-28 13:54:30.000000000 +0200
+++ linux-2.6.32-rc1/drivers/gpu/drm/drm_fb_helper.c	2009-09-28 17:16:12.000000000 +0200
@@ -87,6 +87,7 @@ void drm_fb_helper_restore(void)
 }
 EXPORT_SYMBOL(drm_fb_helper_restore);
 
+#ifdef CONFIG_MAGIC_SYSRQ
 static void drm_fb_helper_restore_work_fn(struct work_struct *ignored)
 {
 	drm_fb_helper_restore();
@@ -103,6 +104,7 @@ static struct sysrq_key_op sysrq_drm_fb_
 	.help_msg = "force-fb(V)",
 	.action_msg = "Restore framebuffer console",
 };
+#endif
 
 static void drm_fb_helper_on(struct fb_info *info)
 {

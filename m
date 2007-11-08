Return-Path: <linux-kernel-owner+w=401wt.eu-S1763501AbXKIAac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763501AbXKIAac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 19:30:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757889AbXKIAaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 19:30:23 -0500
Received: from v32413.1blu.de ([88.84.155.73]:36460 "EHLO mail.lenk.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754177AbXKIAaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 19:30:22 -0500
X-Greylist: delayed 3377 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Nov 2007 19:30:19 EST
From: Frank Lichtenheld <frank@lichtenheld.de>
To: Michal Januszewski <spock@gentoo.org>
Cc: linux-kernel@vger.kernel.org, Frank Lichtenheld <frank@lichtenheld.de>
Subject: [PATCH] uvesafb: Fix warnings about unused variables on non-x86
Date: Fri,  9 Nov 2007 00:08:19 +0100
Message-Id: <1194563299-19768-1-git-send-email-frank@lichtenheld.de>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Variables that are only used in #ifdef CONFIG_X86 should also
only be declared there.

Signed-off-by: Frank Lichtenheld <frank@lichtenheld.de>
---
 drivers/video/uvesafb.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index b983d26..d1d6c0f 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -926,8 +926,10 @@ static int uvesafb_setpalette(struct uvesafb_pal_entry *entries, int count,
 		int start, struct fb_info *info)
 {
 	struct uvesafb_ktask *task;
+#ifdef CONFIG_X86
 	struct uvesafb_par *par = info->par;
 	int i = par->mode_idx;
+#endif
 	int err = 0;
 
 	/*
@@ -1103,11 +1105,11 @@ static int uvesafb_pan_display(struct fb_var_screeninfo *var,
 
 static int uvesafb_blank(int blank, struct fb_info *info)
 {
-	struct uvesafb_par *par = info->par;
 	struct uvesafb_ktask *task;
 	int err = 1;
-
 #ifdef CONFIG_X86
+	struct uvesafb_par *par = info->par;
+
 	if (par->vbe_ib.capabilities & VBE_CAP_VGACOMPAT) {
 		int loop = 10000;
 		u8 seq = 0, crtc17 = 0;
-- 
1.5.3.4


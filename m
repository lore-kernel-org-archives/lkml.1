Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508Ab0AEWyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab0AEWyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 17:54:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755170Ab0AEWyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 17:54:19 -0500
Received: from mail.gmx.net ([213.165.64.20]:46185 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755403Ab0AEWyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 17:54:17 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19sQ1JBIvtsY8tE0OXcJZuO4Z9h+6CxPhz3rEXZxv
	wsQApPEJQ3t6PQ
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
       Erik-Jan Post <ej.lfs@xs4all.nl>
Subject: [PATCH 3/4] viafb: do modesetting after updating variables
Date: Tue,  5 Jan 2010 22:59:58 +0000
Message-Id: <1262732399-3416-3-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1262732399-3416-2-git-send-email-FlorianSchandinat@gmx.de>
References: <1262732399-3416-1-git-send-email-FlorianSchandinat@gmx.de>
 <1262732399-3416-2-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: do modesetting after updating variables

Reorder viafb_set_par to allow using the updated variables in
viafb_setmode. This fixes a regression that prevented proper
runtime mode changes.

Signed-off-by: Erik-Jan Post <ej.lfs@xs4all.nl>
Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/viafbdev.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index e16df84..f7ff4ea 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -174,15 +174,15 @@ static int viafb_set_par(struct fb_info *info)
 	}
 
 	if (vmode_entry) {
-		viafb_setmode(vmode_entry, info->var.bits_per_pixel,
-			vmode_entry1, viafb_bpp1);
-
 		viafb_update_fix(info);
 		viafb_bpp = info->var.bits_per_pixel;
 		if (info->var.accel_flags & FB_ACCELF_TEXT)
 			info->flags &= ~FBINFO_HWACCEL_DISABLED;
 		else
 			info->flags |= FBINFO_HWACCEL_DISABLED;
+
+		viafb_setmode(vmode_entry, info->var.bits_per_pixel,
+			vmode_entry1, viafb_bpp1);
 	}
 
 	return 0;
-- 
1.6.3.2


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549Ab0AEWyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab0AEWyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 17:54:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755430Ab0AEWyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 17:54:52 -0500
Received: from mail.gmx.net ([213.165.64.20]:45909 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754968Ab0AEWyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 17:54:15 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19xLo0IuIFxYqiiCy3yUyMfVh3rLNi7SKXpFq0JK2
	5D1yTjiYHXs9lp
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 2/4] viafb: fix LCD hardware cursor regression
Date: Tue,  5 Jan 2010 22:59:57 +0000
Message-Id: <1262732399-3416-2-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1262732399-3416-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1262732399-3416-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: fix LCD hardware cursor regression

Although I'd consider this a hardware bug, as there is hardware out
that for whatever reason does not support hardware cursors on LCD
output we have to care about it in the driver.
This fixes a regression (invisible cursor) introduced by:
    viafb: cleanup viafb_cursor

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Reported-by: Julian Wollrath <jwollrath@web.de>
Tested-by: Julian Wollrath <jwollrath@web.de>
---
 drivers/video/via/viafbdev.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 02ed2f6..e16df84 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -869,7 +869,9 @@ static int viafb_cursor(struct fb_info *info, struct fb_cursor *cursor)
 	if (info->flags & FBINFO_HWACCEL_DISABLED || info != viafbinfo)
 		return -ENODEV;
 
-	if (chip_name == UNICHROME_CLE266 && viapar->iga_path == IGA2)
+	/* LCD ouput does not support hw cursors (at least on VN896) */
+	if ((chip_name == UNICHROME_CLE266 && viapar->iga_path == IGA2) ||
+		viafb_LCD_ON)
 		return -ENODEV;
 
 	viafb_show_hw_cursor(info, HW_Cursor_OFF);
-- 
1.6.3.2


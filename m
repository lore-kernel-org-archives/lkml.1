Return-Path: <linux-kernel-owner+w=401wt.eu-S933177AbXAaMn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933177AbXAaMn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 07:43:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933183AbXAaMn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 07:43:58 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:41243 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933177AbXAaMn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 07:43:57 -0500
Date: Wed, 31 Jan 2007 13:43:55 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: James Simmons <jsimmons@infradead.org>
cc: Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/7] fbdev: Avoid vertical overflow when making space for
 the logo
In-Reply-To: <Pine.LNX.4.62.0701311325480.14996@pademelon.sonytel.be>
Message-ID: <Pine.LNX.4.62.0701311328170.15066@pademelon.sonytel.be>
References: <Pine.LNX.4.62.0701311325480.14996@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

fbcon_prepare_logo(): Avoid vertical overflow when making space for the logo

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
---
 drivers/video/console/fbcon.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

--- ps3-linux-2.6.20-rc7.orig/drivers/video/console/fbcon.c
+++ ps3-linux-2.6.20-rc7/drivers/video/console/fbcon.c
@@ -619,8 +619,13 @@ static void fbcon_prepare_logo(struct vc
 			r -= cols;
 		}
 		if (!save) {
-			vc->vc_y += logo_lines;
-			vc->vc_pos += logo_lines * vc->vc_size_row;
+			int lines;
+			if (vc->vc_y + logo_lines >= rows)
+				lines = rows - vc->vc_y - 1;
+			else
+				lines = logo_lines;
+			vc->vc_y += lines;
+			vc->vc_pos += lines * vc->vc_size_row;
 		}
 	}
 	scr_memsetw((unsigned short *) vc->vc_origin,

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium

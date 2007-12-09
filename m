Return-Path: <linux-kernel-owner+w=401wt.eu-S1754378AbXLIVeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbXLIVeb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 16:34:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbXLIVeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 16:34:06 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:52637 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbXLIVeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 16:34:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:content-transfer-encoding:user-agent;
        b=a9rHwHdgbSZOaOx+RGOG4jgrnYB1mj/p5jZkLAVuJzW2Ez/aiSYm9vVYDHw3WxLfo2ygFhzksYjwsWA//0sOcX1mPDy8f7RMX4ZkQ9F0TfF+z6kSO4ZHsO51Gsvew2CCe+kUn5EKcS7LlXRfFgpJfJxp+nYsHPqIpUrg9dLQNLo=
Date: Sun, 9 Dec 2007 22:34:33 +0100
From: Marcin =?utf-8?Q?=C5=9Alusarz?= <marcin.slusarz@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Antonino Daplas <adaplas@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] fbcon: fix sparse warning about shadowing 'p' symbol
Message-ID: <20071209213429.GE9440@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fbcon: fix sparse warning about shadowing 'p' symbol

Signed-off-by: Marcin Ślusarz <marcin.slusarz@gmail.com>
---
 drivers/video/console/fbcon.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 0f32f4a..849e114 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -2795,7 +2795,7 @@ static int fbcon_scrolldelta(struct vc_data *vc, int lines)
 {
 	struct fb_info *info = registered_fb[con2fb_map[fg_console]];
 	struct fbcon_ops *ops = info->fbcon_par;
-	struct display *p = &fb_display[fg_console];
+	struct display *disp = &fb_display[fg_console];
 	int offset, limit, scrollback_old;

 	if (softback_top) {
@@ -2833,7 +2833,7 @@ static int fbcon_scrolldelta(struct vc_data *vc, int lines)
 			logo_shown = FBCON_LOGO_CANSHOW;
 		}
 		fbcon_cursor(vc, CM_ERASE | CM_SOFTBACK);
-		fbcon_redraw_softback(vc, p, lines);
+		fbcon_redraw_softback(vc, disp, lines);
 		fbcon_cursor(vc, CM_DRAW | CM_SOFTBACK);
 		return 0;
 	}
@@ -2855,9 +2855,9 @@ static int fbcon_scrolldelta(struct vc_data *vc, int lines)

 	fbcon_cursor(vc, CM_ERASE);

-	offset = p->yscroll - scrollback_current;
-	limit = p->vrows;
-	switch (p->scrollmode) {
+	offset = disp->yscroll - scrollback_current;
+	limit = disp->vrows;
+	switch (disp->scrollmode) {
 	case SCROLL_WRAP_MOVE:
 		info->var.vmode |= FB_VMODE_YWRAP;
 		break;

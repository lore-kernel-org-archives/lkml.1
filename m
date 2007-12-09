Return-Path: <linux-kernel-owner+w=401wt.eu-S1754041AbXLIVff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbXLIVff (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 16:35:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbXLIVf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 16:35:26 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:54165 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbXLIVfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 16:35:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:content-transfer-encoding:user-agent;
        b=rCB0AVOQVjZG3flDwSRVvfhujtT4ekXBMrcVuEOiUmuIM8QcVX3uxe7OWuQEeO5hXBRvEz9vxP9rGKsg01wRyrVPFtWa05yB5GRwd0VNno3LAU3SNQUd/1HVKYltfQ9G/am6kJA2QMHTV0XyMySqXyR0qrvQd23OltMYZkHrjR4=
Date: Sun, 9 Dec 2007 22:36:54 +0100
From: Marcin =?utf-8?Q?=C5=9Alusarz?= <marcin.slusarz@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Antonino Daplas <adaplas@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] fbcon: fix sparse warning about shadowing 'rotate' symbol
Message-ID: <20071209213650.GF9440@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fbcon: fix sparse warning about shadowing 'rotate' symbol

Signed-off-by: Marcin Ślusarz <marcin.slusarz@gmail.com>
---
 drivers/video/console/fbcon.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 849e114..445839c 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -147,7 +147,7 @@ static char fontname[40];
 static int info_idx = -1;

 /* console rotation */
-static int rotate;
+static int initial_rotation;
 static int fbcon_has_sysfs;

 static const struct consw fb_con;
@@ -537,9 +537,9 @@ static int __init fb_console_setup(char *this_opt)
 		if (!strncmp(options, "rotate:", 7)) {
 			options += 7;
 			if (*options)
-				rotate = simple_strtoul(options, &options, 0);
-			if (rotate > 3)
-				rotate = 0;
+				initial_rotation = simple_strtoul(options, &options, 0);
+			if (initial_rotation > 3)
+				initial_rotation = 0;
 		}
 	}
 	return 1;
@@ -989,7 +989,7 @@ static const char *fbcon_startup(void)
 	ops->graphics = 1;
 	ops->cur_rotate = -1;
 	info->fbcon_par = ops;
-	p->con_rotate = rotate;
+	p->con_rotate = initial_rotation;
 	set_blitting_type(vc, info);

 	if (info->fix.type != FB_TYPE_TEXT) {
@@ -1176,7 +1176,7 @@ static void fbcon_init(struct vc_data *vc, int init)
 		con_copy_unimap(vc, svc);

 	ops = info->fbcon_par;
-	p->con_rotate = rotate;
+	p->con_rotate = initial_rotation;
 	set_blitting_type(vc, info);

 	cols = vc->vc_cols;

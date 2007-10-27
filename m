Return-Path: <linux-kernel-owner+w=401wt.eu-S1755922AbXJ0OTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbXJ0OTk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 10:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbXJ0OT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 10:19:28 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:57346 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755859AbXJ0OTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 10:19:25 -0400
Date: Sat, 27 Oct 2007 16:19:46 +0200
From: Adrian Bunk <bunk@kernel.org>
To: adaplas@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] video/sis/: fix negative array index
Message-ID: <20071027141946.GX30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the possible usage of a negative value as an array 
index spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/video/sis/sis_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

9f63bf8c543710521e885b09d88271d1a308b158 
diff --git a/drivers/video/sis/sis_main.c b/drivers/video/sis/sis_main.c
index bc7d236..37bd24b 100644
--- a/drivers/video/sis/sis_main.c
+++ b/drivers/video/sis/sis_main.c
@@ -1245,24 +1245,25 @@ sisfb_do_set_var(struct fb_var_screeninfo *var, int isactive, struct fb_info *in
 		ivideo->sisfb_mode_idx++;
 	}
 
 	if(found_mode) {
 		ivideo->sisfb_mode_idx = sisfb_validate_mode(ivideo,
 				ivideo->sisfb_mode_idx, ivideo->currentvbflags);
-		ivideo->mode_no = sisbios_mode[ivideo->sisfb_mode_idx].mode_no[ivideo->mni];
 	} else {
 		ivideo->sisfb_mode_idx = -1;
 	}
 
        	if(ivideo->sisfb_mode_idx < 0) {
 		printk(KERN_ERR "sisfb: Mode %dx%dx%d not supported\n", var->xres,
 		       var->yres, var->bits_per_pixel);
 		ivideo->sisfb_mode_idx = old_mode;
 		return -EINVAL;
 	}
 
+	ivideo->mode_no = sisbios_mode[ivideo->sisfb_mode_idx].mode_no[ivideo->mni];
+
 	if(sisfb_search_refresh_rate(ivideo, ivideo->refresh_rate, ivideo->sisfb_mode_idx) == 0) {
 		ivideo->rate_idx = sisbios_mode[ivideo->sisfb_mode_idx].rate_idx;
 		ivideo->refresh_rate = 60;
 	}
 
 	if(isactive) {


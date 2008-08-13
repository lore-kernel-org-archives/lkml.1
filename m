Return-Path: <linux-kernel-owner+w=401wt.eu-S1752898AbYHMU4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbYHMU4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbYHMUzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:55:53 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:45154 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbYHMUzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:55:52 -0400
From: York Sun <yorksun@freescale.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       galak@kernel.crashing.org, linux-fbdev-devel@lists.sourceforge.net,
       York Sun <yorksun@freescale.com>
Subject: [PATCH 2/2] Bug fix. Add sanity check for AOI position
Date: Wed, 13 Aug 2008 15:55:04 -0500
Message-Id: <1218660906446-git-send-email-yorksun@freescale.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <12186609063047-git-send-email-yorksun@freescale.com>
References: <12186609042933-git-send-email-yorksun@freescale.com>
 <12186609063047-git-send-email-yorksun@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AOI position cannot be negative.

Signed-off-by: York Sun <yorksun@freescale.com>
---
 drivers/video/fsl-diu-fb.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/video/fsl-diu-fb.c b/drivers/video/fsl-diu-fb.c
index d67e79b..8898d2a 100644
--- a/drivers/video/fsl-diu-fb.c
+++ b/drivers/video/fsl-diu-fb.c
@@ -479,6 +479,10 @@ static void adjust_aoi_size_position(struct fb_var_screeninfo *var,
 	base_plane_width = machine_data->fsl_diu_info[0]->var.xres;
 	base_plane_height = machine_data->fsl_diu_info[0]->var.yres;
 
+	if (mfbi->x_aoi_d < 0)
+		mfbi->x_aoi_d = 0;
+	if (mfbi->y_aoi_d < 0)
+		mfbi->y_aoi_d = 0;
 	switch (index) {
 	case 0:
 		if (mfbi->x_aoi_d != 0)
-- 
1.5.2.2


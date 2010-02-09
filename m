Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503Ab0BIO0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 09:26:19 -0500
Received: from mail.gmx.net ([213.165.64.20]:53571 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754181Ab0BIO0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 09:26:14 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/P4H9+fujPvCuZmUbxSok7764Z0kvNWPCkCbvz2G
	OAyKK5d7eViIUu
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 1/3] viafb: reorder initialization for dual framebuffer mode
Date: Tue,  9 Feb 2010 14:32:36 +0000
Message-Id: <1265725958-4641-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: reorder initialization for dual framebuffer mode

This patch reorders the initialization for dual framebuffer mode to
not ignore the settings for the first mode. Previously they were
overwritten with the settings for the second one before they were
applied.
This should have no effect on non dual framebuffer mode and do
what the user intended (initalization to desired modes) in dual
framebuffer mode.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/viafbdev.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 5f5b5e9..4d955ca 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -1960,6 +1960,9 @@ static int __devinit via_pci_probe(struct pci_dev *pdev,
 	default_var.lower_margin = 4;
 	default_var.hsync_len = default_var.left_margin;
 	default_var.vsync_len = 4;
+	viafb_setup_fixinfo(&viafbinfo->fix, viaparinfo);
+	viafb_check_var(&default_var, viafbinfo);
+	viafbinfo->var = default_var;
 
 	if (viafb_dual_fb) {
 		viafbinfo1 = framebuffer_alloc(viafb_par_length, &pdev->dev);
@@ -2015,9 +2018,6 @@ static int __devinit via_pci_probe(struct pci_dev *pdev,
 			&viafbinfo1->fix);
 	}
 
-	viafb_setup_fixinfo(&viafbinfo->fix, viaparinfo);
-	viafb_check_var(&default_var, viafbinfo);
-	viafbinfo->var = default_var;
 	viafb_update_fix(viafbinfo);
 	viaparinfo->depth = fb_get_color_depth(&viafbinfo->var,
 		&viafbinfo->fix);
-- 
1.6.3.2


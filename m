Return-Path: <linux-kernel-owner+w=401wt.eu-S1758376AbZFMA4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758376AbZFMA4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 20:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759254AbZFMAzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 20:55:48 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:58673 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469AbZFMAzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 20:55:45 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] fbdev: bfin-t350mcqb-fb: drop unused local variables
Date: Fri, 12 Jun 2009 20:55:33 -0400
Message-Id: <1244854536-2367-3-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244854536-2367-1-git-send-email-vapier@gentoo.org>
References: <1244854536-2367-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The local fbinfo/info vars in the suspend functions don't actually get
used which cause ugly gcc warnings, so drop them.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/video/bfin-t350mcqb-fb.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/video/bfin-t350mcqb-fb.c b/drivers/video/bfin-t350mcqb-fb.c
index 90cfdda..2a2e116 100644
--- a/drivers/video/bfin-t350mcqb-fb.c
+++ b/drivers/video/bfin-t350mcqb-fb.c
@@ -637,9 +637,6 @@ static int bfin_t350mcqb_remove(struct platform_device *pdev)
 #ifdef CONFIG_PM
 static int bfin_t350mcqb_suspend(struct platform_device *pdev, pm_message_t state)
 {
-	struct fb_info *fbinfo = platform_get_drvdata(pdev);
-	struct bfin_t350mcqbfb_info *info = fbinfo->par;
-
 	bfin_t350mcqb_disable_ppi();
 	disable_dma(CH_PPI);
 	bfin_write_PPI_STATUS(0xFFFF);
@@ -649,9 +646,6 @@ static int bfin_t350mcqb_suspend(struct platform_device *pdev, pm_message_t stat
 
 static int bfin_t350mcqb_resume(struct platform_device *pdev)
 {
-	struct fb_info *fbinfo = platform_get_drvdata(pdev);
-	struct bfin_t350mcqbfb_info *info = fbinfo->par;
-
 	enable_dma(CH_PPI);
 	bfin_t350mcqb_enable_ppi();
 
-- 
1.6.3.1


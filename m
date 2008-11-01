Return-Path: <linux-kernel-owner+w=401wt.eu-S1753998AbYKASVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbYKASVs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 14:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbYKASUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 14:20:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58332 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696AbYKASUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 14:20:40 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] section fixes for cirrusfb
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1KwL5T-0000Vb-FJ@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 01 Nov 2008 18:20:39 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


cirrusfb_zorro_unmap() may be called both from __devexit and (on
cleanup path) from __devinit.  So it needs to be a normal function,
same as for cirrusfb_pci_unmap()

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/video/cirrusfb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/cirrusfb.c b/drivers/video/cirrusfb.c
index 048b139..8a87602 100644
--- a/drivers/video/cirrusfb.c
+++ b/drivers/video/cirrusfb.c
@@ -2049,7 +2049,7 @@ static void cirrusfb_pci_unmap(struct fb_info *info)
 #endif /* CONFIG_PCI */
 
 #ifdef CONFIG_ZORRO
-static void __devexit cirrusfb_zorro_unmap(struct fb_info *info)
+static void cirrusfb_zorro_unmap(struct fb_info *info)
 {
 	struct cirrusfb_info *cinfo = info->par;
 	struct zorro_dev *zdev = to_zorro_dev(info->device);
-- 
1.5.6.5



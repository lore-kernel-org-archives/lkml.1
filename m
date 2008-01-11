Return-Path: <linux-kernel-owner+w=401wt.eu-S1759883AbYAKDVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759883AbYAKDVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 22:21:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756920AbYAKDVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 22:21:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:53109 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755912AbYAKDVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 22:21:41 -0500
Subject: [PATCH 2/11 ] Change drm_ioctl as an unlocked_ioctl function : i810
From: Nikanth Karthikesan <knikanth@suse.de>
To: airlied@linux.ie, dri-devel@lists.sourceforge.net,
       benh@kernel.crashing.org, paulus@samba.org, thomas@winischhofer.net,
       adaplas@gmail.com, sylvain.meyer@worldonline.fr
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain
Date: Fri, 11 Jan 2008 08:55:23 +0530
Message-Id: <1200021923.3844.2.camel@nikanth-laptop.blr.novell.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register drm_ioctl as an unlocked_ioctl function.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

--- 
diff --git a/drivers/char/drm/i810_dma.c b/drivers/char/drm/i810_dma.c
index eb381a7..e3adbf3 100644
--- a/drivers/char/drm/i810_dma.c
+++ b/drivers/char/drm/i810_dma.c
@@ -115,7 +115,7 @@ static int i810_mmap_buffers(struct file *filp, struct vm_area_struct *vma)
 static const struct file_operations i810_buffer_fops = {
 	.open = drm_open,
 	.release = drm_release,
-	.ioctl = drm_ioctl,
+	.unlocked_ioctl = drm_ioctl,
 	.mmap = i810_mmap_buffers,
 	.fasync = drm_fasync,
 };
diff --git a/drivers/char/drm/i810_drv.c b/drivers/char/drm/i810_drv.c
index fabb9a8..c1e0275 100644
--- a/drivers/char/drm/i810_drv.c
+++ b/drivers/char/drm/i810_drv.c
@@ -59,7 +59,7 @@ static struct drm_driver driver = {
 		 .owner = THIS_MODULE,
 		 .open = drm_open,
 		 .release = drm_release,
-		 .ioctl = drm_ioctl,
+		 .unlocked_ioctl = drm_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
 		 .fasync = drm_fasync,



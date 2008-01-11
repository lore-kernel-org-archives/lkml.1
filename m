Return-Path: <linux-kernel-owner+w=401wt.eu-S1760007AbYAKDWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760007AbYAKDWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 22:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756916AbYAKDWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 22:22:01 -0500
Received: from cantor.suse.de ([195.135.220.2]:51612 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757515AbYAKDWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 22:22:00 -0500
Subject: [PATCH 3/11 ] Change drm_ioctl as an unlocked_ioctl function : i830
From: Nikanth Karthikesan <knikanth@suse.de>
To: airlied@linux.ie, dri-devel@lists.sourceforge.net,
       benh@kernel.crashing.org, paulus@samba.org, thomas@winischhofer.net,
       adaplas@gmail.com, sylvain.meyer@worldonline.fr
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain
Date: Fri, 11 Jan 2008 08:55:42 +0530
Message-Id: <1200021942.3844.4.camel@nikanth-laptop.blr.novell.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register drm_ioctl as an unlocked_ioctl function.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

--- 
diff --git a/drivers/char/drm/i830_dma.c b/drivers/char/drm/i830_dma.c
index 69a363e..2f82480 100644
--- a/drivers/char/drm/i830_dma.c
+++ b/drivers/char/drm/i830_dma.c
@@ -117,7 +117,7 @@ static int i830_mmap_buffers(struct file *filp, struct vm_area_struct *vma)
 static const struct file_operations i830_buffer_fops = {
 	.open = drm_open,
 	.release = drm_release,
-	.ioctl = drm_ioctl,
+	.unlocked_ioctl = drm_ioctl,
 	.mmap = i830_mmap_buffers,
 	.fasync = drm_fasync,
 };
diff --git a/drivers/char/drm/i830_drv.c b/drivers/char/drm/i830_drv.c
index 389597e..44f990b 100644
--- a/drivers/char/drm/i830_drv.c
+++ b/drivers/char/drm/i830_drv.c
@@ -70,7 +70,7 @@ static struct drm_driver driver = {
 		 .owner = THIS_MODULE,
 		 .open = drm_open,
 		 .release = drm_release,
-		 .ioctl = drm_ioctl,
+		 .unlocked_ioctl = drm_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
 		 .fasync = drm_fasync,



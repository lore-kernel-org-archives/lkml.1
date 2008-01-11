Return-Path: <linux-kernel-owner+w=401wt.eu-S1760440AbYAKDXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760440AbYAKDXK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 22:23:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760076AbYAKDW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 22:22:26 -0500
Received: from mail.suse.de ([195.135.220.2]:51664 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760053AbYAKDWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 22:22:25 -0500
Subject: [PATCH 6/11 ] Change drm_ioctl as an unlocked_ioctl function : r128
From: Nikanth Karthikesan <knikanth@suse.de>
To: airlied@linux.ie, dri-devel@lists.sourceforge.net,
       benh@kernel.crashing.org, paulus@samba.org, thomas@winischhofer.net,
       adaplas@gmail.com, sylvain.meyer@worldonline.fr
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain
Date: Fri, 11 Jan 2008 08:56:01 +0530
Message-Id: <1200021961.3844.10.camel@nikanth-laptop.blr.novell.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register drm_ioctl as an unlocked_ioctl function.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

--- 
diff --git a/drivers/char/drm/r128_drv.c b/drivers/char/drm/r128_drv.c
index 6108e75..b2a16a7 100644
--- a/drivers/char/drm/r128_drv.c
+++ b/drivers/char/drm/r128_drv.c
@@ -62,7 +62,7 @@ static struct drm_driver driver = {
 		 .owner = THIS_MODULE,
 		 .open = drm_open,
 		 .release = drm_release,
-		 .ioctl = drm_ioctl,
+		 .unlocked_ioctl = drm_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
 		 .fasync = drm_fasync,
diff --git a/drivers/char/drm/r128_ioc32.c b/drivers/char/drm/r128_ioc32.c
index d3cb676..1f3c5e5 100644
--- a/drivers/char/drm/r128_ioc32.c
+++ b/drivers/char/drm/r128_ioc32.c
@@ -95,8 +95,8 @@ static int compat_r128_init(struct file *file, unsigned int cmd,
 			  &init->agp_textures_offset))
 		return -EFAULT;
 
-	return drm_ioctl(file->f_path.dentry->d_inode, file,
-			 DRM_IOCTL_R128_INIT, (unsigned long)init);
+	return drm_ioctl(file, DRM_IOCTL_R128_INIT,
+					 (unsigned long)init);
 }
 
 typedef struct drm_r128_depth32 {
@@ -129,8 +129,8 @@ static int compat_r128_depth(struct file *file, unsigned int cmd,
 			  &depth->mask))
 		return -EFAULT;
 
-	return drm_ioctl(file->f_path.dentry->d_inode, file,
-			 DRM_IOCTL_R128_DEPTH, (unsigned long)depth);
+	return drm_ioctl(file, DRM_IOCTL_R128_DEPTH,
+				 (unsigned long)depth);
 
 }
 
@@ -153,8 +153,8 @@ static int compat_r128_stipple(struct file *file, unsigned int cmd,
 			  &stipple->mask))
 		return -EFAULT;
 
-	return drm_ioctl(file->f_path.dentry->d_inode, file,
-			 DRM_IOCTL_R128_STIPPLE, (unsigned long)stipple);
+	return drm_ioctl(file, DRM_IOCTL_R128_STIPPLE,
+					 (unsigned long)stipple);
 }
 
 typedef struct drm_r128_getparam32 {
@@ -178,8 +178,8 @@ static int compat_r128_getparam(struct file *file, unsigned int cmd,
 			  &getparam->value))
 		return -EFAULT;
 
-	return drm_ioctl(file->f_path.dentry->d_inode, file,
-			 DRM_IOCTL_R128_GETPARAM, (unsigned long)getparam);
+	return drm_ioctl(file, DRM_IOCTL_R128_GETPARAM,
+					 (unsigned long)getparam);
 }
 
 drm_ioctl_compat_t *r128_compat_ioctls[] = {
@@ -214,7 +214,7 @@ long r128_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	if (fn != NULL)
 		ret = (*fn) (filp, cmd, arg);
 	else
-		ret = drm_ioctl(filp->f_path.dentry->d_inode, filp, cmd, arg);
+		ret = drm_ioctl(filp, cmd, arg);
 	unlock_kernel();
 
 	return ret;



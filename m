Return-Path: <linux-kernel-owner+w=401wt.eu-S1756701AbZCSENF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701AbZCSENF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 00:13:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbZCSEMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 00:12:38 -0400
Received: from kroah.org ([198.145.64.141]:34745 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754528AbZCSELl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 00:11:41 -0400
Date: Wed, 18 Mar 2009 21:08:43 -0700
From: Greg KH <greg@kroah.com>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Thomas Hellstrom <thellstrom@vmware.com>,
       Richard Purdie <rpurdie@linux.intel.com>
Subject: [patch 4/5] drm: Add unlocked IOCTL functionality from the drm
	repo.
Message-ID: <20090319040843.GD29249@kroah.com>
References: <20090319035834.875839585@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="drm-add-unlocked-ioctl-functionality-from-the-drm-repo.patch"
In-Reply-To: <20090319040809.GA29249@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Richard Purdie <rpurdie@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/drm_drv.c |    9 +++++++--
 include/drm/drmP.h        |    2 ++
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -455,6 +455,12 @@ static int drm_version(struct drm_device
 int drm_ioctl(struct inode *inode, struct file *filp,
 	      unsigned int cmd, unsigned long arg)
 {
+	return drm_unlocked_ioctl(filp, cmd, arg);
+}
+EXPORT_SYMBOL(drm_ioctl);
+
+long drm_unlocked_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
 	struct drm_file *file_priv = filp->private_data;
 	struct drm_device *dev = file_priv->minor->dev;
 	struct drm_ioctl_desc *ioctl;
@@ -530,8 +536,7 @@ int drm_ioctl(struct inode *inode, struc
 		DRM_DEBUG("ret = %x\n", retcode);
 	return retcode;
 }
-
-EXPORT_SYMBOL(drm_ioctl);
+EXPORT_SYMBOL(drm_unlocked_ioctl);
 
 drm_local_map_t *drm_getsarea(struct drm_device *dev)
 {
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -1016,6 +1016,8 @@ extern int drm_init(struct drm_driver *d
 extern void drm_exit(struct drm_driver *driver);
 extern int drm_ioctl(struct inode *inode, struct file *filp,
 		     unsigned int cmd, unsigned long arg);
+extern long drm_unlocked_ioctl(struct file *filp,
+			       unsigned int cmd, unsigned long arg);
 extern long drm_compat_ioctl(struct file *filp,
 			     unsigned int cmd, unsigned long arg);
 extern int drm_lastclose(struct drm_device *dev);


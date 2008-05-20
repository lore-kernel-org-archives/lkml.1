Return-Path: <linux-kernel-owner+w=401wt.eu-S933273AbYETPan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933273AbYETPan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758831AbYETPa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:30:26 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:29054 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbYETPaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:30:24 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080520528.793382059@firstfloor.org>
In-Reply-To: <20080520528.793382059@firstfloor.org>
To: airlied@linux.ie, corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: [PATCH] [7/11] Convert DRM to unlocked_fasync
Message-Id: <20080520152848.EA50B1B4203@basil.firstfloor.org>
Date: Tue, 20 May 2008 17:28:48 +0200 (CEST)
X-OriginalArrivalTime: 20 May 2008 15:21:47.0027 (UTC) FILETIME=[37DA5630:01C8BA8D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Doesn't need BKL because it just uses fasync_helper and minor->dev is 
protected by the file reference count.

Cc: airlied@linux.ie

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/char/drm/i810_dma.c   |    2 +-
 drivers/char/drm/i810_drv.c   |    2 +-
 drivers/char/drm/i830_dma.c   |    2 +-
 drivers/char/drm/i830_drv.c   |    2 +-
 drivers/char/drm/i915_drv.c   |    2 +-
 drivers/char/drm/mga_drv.c    |    2 +-
 drivers/char/drm/r128_drv.c   |    2 +-
 drivers/char/drm/radeon_drv.c |    2 +-
 drivers/char/drm/savage_drv.c |    2 +-
 drivers/char/drm/sis_drv.c    |    2 +-
 drivers/char/drm/tdfx_drv.c   |    2 +-
 drivers/char/drm/via_drv.c    |    2 +-
 12 files changed, 12 insertions(+), 12 deletions(-)

Index: linux/drivers/char/drm/i810_dma.c
===================================================================
--- linux.orig/drivers/char/drm/i810_dma.c
+++ linux/drivers/char/drm/i810_dma.c
@@ -117,7 +117,7 @@ static const struct file_operations i810
 	.release = drm_release,
 	.ioctl = drm_ioctl,
 	.mmap = i810_mmap_buffers,
-	.fasync = drm_fasync,
+	.unlocked_fasync = drm_fasync,
 };
 
 static int i810_map_buffer(struct drm_buf * buf, struct drm_file *file_priv)
Index: linux/drivers/char/drm/i810_drv.c
===================================================================
--- linux.orig/drivers/char/drm/i810_drv.c
+++ linux/drivers/char/drm/i810_drv.c
@@ -62,7 +62,7 @@ static struct drm_driver driver = {
 		 .ioctl = drm_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
-		 .fasync = drm_fasync,
+		 .unlocked_fasync = drm_fasync,
 	},
 
 	.pci_driver = {
Index: linux/drivers/char/drm/i830_dma.c
===================================================================
--- linux.orig/drivers/char/drm/i830_dma.c
+++ linux/drivers/char/drm/i830_dma.c
@@ -119,7 +119,7 @@ static const struct file_operations i830
 	.release = drm_release,
 	.ioctl = drm_ioctl,
 	.mmap = i830_mmap_buffers,
-	.fasync = drm_fasync,
+	.unlocked_fasync = drm_fasync,
 };
 
 static int i830_map_buffer(struct drm_buf * buf, struct drm_file *file_priv)
Index: linux/drivers/char/drm/i830_drv.c
===================================================================
--- linux.orig/drivers/char/drm/i830_drv.c
+++ linux/drivers/char/drm/i830_drv.c
@@ -73,7 +73,7 @@ static struct drm_driver driver = {
 		 .ioctl = drm_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
-		 .fasync = drm_fasync,
+		 .unlocked_fasync = drm_fasync,
 	},
 
 	.pci_driver = {
Index: linux/drivers/char/drm/i915_drv.c
===================================================================
--- linux.orig/drivers/char/drm/i915_drv.c
+++ linux/drivers/char/drm/i915_drv.c
@@ -559,7 +559,7 @@ static struct drm_driver driver = {
 		 .ioctl = drm_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
-		 .fasync = drm_fasync,
+		 .unlocked_fasync = drm_fasync,
 #ifdef CONFIG_COMPAT
 		 .compat_ioctl = i915_compat_ioctl,
 #endif
Index: linux/drivers/char/drm/mga_drv.c
===================================================================
--- linux.orig/drivers/char/drm/mga_drv.c
+++ linux/drivers/char/drm/mga_drv.c
@@ -71,7 +71,7 @@ static struct drm_driver driver = {
 		 .ioctl = drm_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
-		 .fasync = drm_fasync,
+		 .unlocked_fasync = drm_fasync,
 #ifdef CONFIG_COMPAT
 		 .compat_ioctl = mga_compat_ioctl,
 #endif
Index: linux/drivers/char/drm/r128_drv.c
===================================================================
--- linux.orig/drivers/char/drm/r128_drv.c
+++ linux/drivers/char/drm/r128_drv.c
@@ -66,7 +66,7 @@ static struct drm_driver driver = {
 		 .ioctl = drm_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
-		 .fasync = drm_fasync,
+		 .unlocked_fasync = drm_fasync,
 #ifdef CONFIG_COMPAT
 		 .compat_ioctl = r128_compat_ioctl,
 #endif
Index: linux/drivers/char/drm/radeon_drv.c
===================================================================
--- linux.orig/drivers/char/drm/radeon_drv.c
+++ linux/drivers/char/drm/radeon_drv.c
@@ -88,7 +88,7 @@ static struct drm_driver driver = {
 		 .ioctl = drm_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
-		 .fasync = drm_fasync,
+		 .unlocked_fasync = drm_fasync,
 #ifdef CONFIG_COMPAT
 		 .compat_ioctl = radeon_compat_ioctl,
 #endif
Index: linux/drivers/char/drm/savage_drv.c
===================================================================
--- linux.orig/drivers/char/drm/savage_drv.c
+++ linux/drivers/char/drm/savage_drv.c
@@ -53,7 +53,7 @@ static struct drm_driver driver = {
 		 .ioctl = drm_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
-		 .fasync = drm_fasync,
+		 .unlocked_fasync = drm_fasync,
 	},
 
 	.pci_driver = {
Index: linux/drivers/char/drm/sis_drv.c
===================================================================
--- linux.orig/drivers/char/drm/sis_drv.c
+++ linux/drivers/char/drm/sis_drv.c
@@ -83,7 +83,7 @@ static struct drm_driver driver = {
 		 .ioctl = drm_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
-		 .fasync = drm_fasync,
+		 .unlocked_fasync = drm_fasync,
 	},
 	.pci_driver = {
 		 .name = DRIVER_NAME,
Index: linux/drivers/char/drm/tdfx_drv.c
===================================================================
--- linux.orig/drivers/char/drm/tdfx_drv.c
+++ linux/drivers/char/drm/tdfx_drv.c
@@ -51,7 +51,7 @@ static struct drm_driver driver = {
 		 .ioctl = drm_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
-		 .fasync = drm_fasync,
+		 .unlocked_fasync = drm_fasync,
 	},
 	.pci_driver = {
 		 .name = DRIVER_NAME,
Index: linux/drivers/char/drm/via_drv.c
===================================================================
--- linux.orig/drivers/char/drm/via_drv.c
+++ linux/drivers/char/drm/via_drv.c
@@ -67,7 +67,7 @@ static struct drm_driver driver = {
 		 .ioctl = drm_ioctl,
 		 .mmap = drm_mmap,
 		 .poll = drm_poll,
-		 .fasync = drm_fasync,
+		 .unlocked_fasync = drm_fasync,
 	},
 	.pci_driver = {
 		 .name = DRIVER_NAME,

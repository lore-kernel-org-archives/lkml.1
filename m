Return-Path: <linux-kernel-owner+w=401wt.eu-S1756991AbYESMef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991AbYESMef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 08:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759157AbYESMbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 08:31:52 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:11599 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757126AbYESMbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 08:31:50 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080519231.561421028@firstfloor.org>
In-Reply-To: <20080519231.561421028@firstfloor.org>
To: airlied@linux.ie, corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: [PATCH] [7/11] Convert DRM to unlocked_fasync
Message-Id: <20080519123116.B24B51B41FF@basil.firstfloor.org>
Date: Mon, 19 May 2008 14:31:16 +0200 (CEST)
X-OriginalArrivalTime: 19 May 2008 12:24:14.0578 (UTC) FILETIME=[4015DD20:01C8B9AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Doesn't need BKL because it just uses fasync_helper and minor->dev is 
protected by the file reference count.

Cc: airlied@linux.ie

Signed-off-by: Andi Kleen <ak@linux.intel.com>

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

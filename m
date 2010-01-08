Return-Path: <linux-kernel-owner+w=401wt.eu-S1753728Ab0AHUpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab0AHUpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 15:45:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750904Ab0AHUpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 15:45:38 -0500
Received: from [206.15.93.42] ([206.15.93.42]:31372 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750750Ab0AHUph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 15:45:37 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/gpu/drm/drm_info.c: remove unnecessary casts
Date: Fri, 8 Jan 2010 13:45:34 -0700
Cc: dri-devel@lists.sourceforge.net, airlied@linux.ie
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001081345.34601.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/gpu/drm/drm_info.c: Remove unnecessary casts.

The struct seq_file 'private' member is a void *, the casts are not needed.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Airlie <airlied@linux.ie>

---

diff --git a/drivers/gpu/drm/drm_info.c b/drivers/gpu/drm/drm_info.c
index f0f6c6b..25d90e6 100644
--- a/drivers/gpu/drm/drm_info.c
+++ b/drivers/gpu/drm/drm_info.c
@@ -43,7 +43,7 @@
  */
 int drm_name_info(struct seq_file *m, void *data)
 {
-	struct drm_info_node *node = (struct drm_info_node *) m->private;
+	struct drm_info_node *node = m->private;
 	struct drm_minor *minor = node->minor;
 	struct drm_device *dev = minor->dev;
 	struct drm_master *master = minor->master;
@@ -70,7 +70,7 @@ int drm_name_info(struct seq_file *m, void *data)
  */
 int drm_vm_info(struct seq_file *m, void *data)
 {
-	struct drm_info_node *node = (struct drm_info_node *) m->private;
+	struct drm_info_node *node = m->private;
 	struct drm_device *dev = node->minor->dev;
 	struct drm_local_map *map;
 	struct drm_map_list *r_list;
@@ -114,7 +114,7 @@ int drm_vm_info(struct seq_file *m, void *data)
  */
 int drm_queues_info(struct seq_file *m, void *data)
 {
-	struct drm_info_node *node = (struct drm_info_node *) m->private;
+	struct drm_info_node *node = m->private;
 	struct drm_device *dev = node->minor->dev;
 	int i;
 	struct drm_queue *q;
@@ -150,7 +150,7 @@ int drm_queues_info(struct seq_file *m, void *data)
  */
 int drm_bufs_info(struct seq_file *m, void *data)
 {
-	struct drm_info_node *node = (struct drm_info_node *) m->private;
+	struct drm_info_node *node = m->private;
 	struct drm_device *dev = node->minor->dev;
 	struct drm_device_dma *dma;
 	int i, seg_pages;
@@ -192,7 +192,7 @@ int drm_bufs_info(struct seq_file *m, void *data)
  */
 int drm_vblank_info(struct seq_file *m, void *data)
 {
-	struct drm_info_node *node = (struct drm_info_node *) m->private;
+	struct drm_info_node *node = m->private;
 	struct drm_device *dev = node->minor->dev;
 	int crtc;
 
@@ -217,7 +217,7 @@ int drm_vblank_info(struct seq_file *m, void *data)
  */
 int drm_clients_info(struct seq_file *m, void *data)
 {
-	struct drm_info_node *node = (struct drm_info_node *) m->private;
+	struct drm_info_node *node = m->private;
 	struct drm_device *dev = node->minor->dev;
 	struct drm_file *priv;
 
@@ -251,7 +251,7 @@ int drm_gem_one_name_info(int id, void *ptr, void *data)
 
 int drm_gem_name_info(struct seq_file *m, void *data)
 {
-	struct drm_info_node *node = (struct drm_info_node *) m->private;
+	struct drm_info_node *node = m->private;
 	struct drm_device *dev = node->minor->dev;
 
 	seq_printf(m, "  name     size handles refcount\n");
@@ -261,7 +261,7 @@ int drm_gem_name_info(struct seq_file *m, void *data)
 
 int drm_gem_object_info(struct seq_file *m, void* data)
 {
-	struct drm_info_node *node = (struct drm_info_node *) m->private;
+	struct drm_info_node *node = m->private;
 	struct drm_device *dev = node->minor->dev;
 
 	seq_printf(m, "%d objects\n", atomic_read(&dev->object_count));
@@ -277,7 +277,7 @@ int drm_gem_object_info(struct seq_file *m, void* data)
 
 int drm_vma_info(struct seq_file *m, void *data)
 {
-	struct drm_info_node *node = (struct drm_info_node *) m->private;
+	struct drm_info_node *node = m->private;
 	struct drm_device *dev = node->minor->dev;
 	struct drm_vma_entry *pt;
 	struct vm_area_struct *vma;

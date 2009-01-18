Return-Path: <linux-kernel-owner+w=401wt.eu-S932332AbZARP3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332AbZARP3e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 10:29:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933838AbZARP2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 10:28:47 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:41503 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933824AbZARP2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 10:28:45 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 1/3] drivers/gpu/drm: fix sparse warnings: make symbols static
To: dri-devel@lists.sourceforge.net
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 18 Jan 2009 16:28:40 +0100
Message-ID: <20090118152840.4179.3536.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090118152725.4179.40835.stgit@vmbox.hanneseder.net>
References: <20090118152725.4179.40835.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.292.gb975.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warnings:

  drivers/gpu/drm/drm_crtc.c:270:17: warning: symbol 'drm_crtc_from_fb' was not declared. Should it be static?
  drivers/gpu/drm/drm_crtc.c:810:5: warning: symbol 'drm_mode_group_init' was not declared. Should it be static?
  drivers/gpu/drm/drm_crtc.c:913:6: warning: symbol 'drm_crtc_convert_to_umode' was not declared. Should it be static?
  drivers/gpu/drm/drm_crtc.c:945:6: warning: symbol 'drm_crtc_convert_umode' was not declared. Should it be static?
  drivers/gpu/drm/drm_edid.c:252:25: warning: symbol 'drm_mode_std' was not declared. Should it be static?
  drivers/gpu/drm/drm_modes.c:446:6: warning: symbol 'list_sort' was not declared. Should it be static?

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/gpu/drm/drm_crtc.c  |   15 ++++++++-------
 drivers/gpu/drm/drm_edid.c  |    4 ++--
 drivers/gpu/drm/drm_modes.c |    4 ++--
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index 5b2cbb7..d378306 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -267,8 +267,8 @@ EXPORT_SYMBOL(drm_mode_object_find);
  * RETURNS:
  * Pointer to the CRTC or NULL if it wasn't found.
  */
-struct drm_crtc *drm_crtc_from_fb(struct drm_device *dev,
-				  struct drm_framebuffer *fb)
+static struct drm_crtc *drm_crtc_from_fb(struct drm_device *dev,
+					 struct drm_framebuffer *fb)
 {
 	struct drm_crtc *crtc;
 
@@ -807,7 +807,8 @@ void drm_mode_config_init(struct drm_device *dev)
 }
 EXPORT_SYMBOL(drm_mode_config_init);
 
-int drm_mode_group_init(struct drm_device *dev, struct drm_mode_group *group)
+static int drm_mode_group_init(struct drm_device *dev,
+			       struct drm_mode_group *group)
 {
 	uint32_t total_objects = 0;
 
@@ -910,8 +911,8 @@ EXPORT_SYMBOL(drm_mode_config_cleanup);
  * Convert a drm_display_mode into a drm_mode_modeinfo structure to return to
  * the user.
  */
-void drm_crtc_convert_to_umode(struct drm_mode_modeinfo *out,
-			       struct drm_display_mode *in)
+static void drm_crtc_convert_to_umode(struct drm_mode_modeinfo *out,
+				      struct drm_display_mode *in)
 {
 	out->clock = in->clock;
 	out->hdisplay = in->hdisplay;
@@ -942,8 +943,8 @@ void drm_crtc_convert_to_umode(struct drm_mode_modeinfo *out,
  * Convert a drm_mode_modeinfo into a drm_display_mode structure to return to
  * the caller.
  */
-void drm_crtc_convert_umode(struct drm_display_mode *out,
-			    struct drm_mode_modeinfo *in)
+static void drm_crtc_convert_umode(struct drm_display_mode *out,
+				   struct drm_mode_modeinfo *in)
 {
 	out->clock = in->clock;
 	out->hdisplay = in->hdisplay;
diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 0fbb0da..47737b2 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -249,8 +249,8 @@ static void edid_fixup_preferred(struct drm_connector *connector,
  * Punts for now, but should eventually use the FB layer's CVT based mode
  * generation code.
  */
-struct drm_display_mode *drm_mode_std(struct drm_device *dev,
-				      struct std_timing *t)
+static struct drm_display_mode *drm_mode_std(struct drm_device *dev,
+					     struct std_timing *t)
 {
 	struct drm_display_mode *mode;
 	int hsize = t->hsize * 8 + 248, vsize;
diff --git a/drivers/gpu/drm/drm_modes.c b/drivers/gpu/drm/drm_modes.c
index c9b80fd..7c36f16 100644
--- a/drivers/gpu/drm/drm_modes.c
+++ b/drivers/gpu/drm/drm_modes.c
@@ -443,8 +443,8 @@ static int drm_mode_compare(struct list_head *lh_a, struct list_head *lh_b)
 
 /* FIXME: what we don't have a list sort function? */
 /* list sort from Mark J Roberts (mjr@znex.org) */
-void list_sort(struct list_head *head,
-	       int (*cmp)(struct list_head *a, struct list_head *b))
+static void list_sort(struct list_head *head,
+		      int (*cmp)(struct list_head *a, struct list_head *b))
 {
 	struct list_head *p, *q, *e, *list, *tail, *oldhead;
 	int insize, nmerges, psize, qsize, i;


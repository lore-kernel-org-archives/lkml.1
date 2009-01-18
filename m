Return-Path: <linux-kernel-owner+w=401wt.eu-S933633AbZARPaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933633AbZARPaA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 10:30:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933848AbZARP24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 10:28:56 -0500
Received: from mu-out-0910.google.com ([209.85.134.186]:64280 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932282AbZARP2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 10:28:54 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 2/3] drivers/gpu/drm: fix sparse warnings: unexport symbols
To: dri-devel@lists.sourceforge.net
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 18 Jan 2009 16:28:48 +0100
Message-ID: <20090118152848.4179.85741.stgit@vmbox.hanneseder.net>
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

  drivers/gpu/drm/drm_crtc_helper.c:137:6: warning: symbol 'drm_helper_probe_connector_modes' was not declared. Should it be static?
  drivers/gpu/drm/drm_modes.c:360:6: warning: symbol 'drm_mode_validate_clocks' was not declared. Should it be static?

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/gpu/drm/drm_crtc_helper.c |    6 +++---
 drivers/gpu/drm/drm_modes.c       |    7 +++----
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/drm_crtc_helper.c b/drivers/gpu/drm/drm_crtc_helper.c
index d8a982b..a0b2601 100644
--- a/drivers/gpu/drm/drm_crtc_helper.c
+++ b/drivers/gpu/drm/drm_crtc_helper.c
@@ -134,8 +134,9 @@ void drm_helper_probe_single_connector_modes(struct drm_connector *connector,
 }
 EXPORT_SYMBOL(drm_helper_probe_single_connector_modes);
 
-void drm_helper_probe_connector_modes(struct drm_device *dev, uint32_t maxX,
-				      uint32_t maxY)
+static void drm_helper_probe_connector_modes(struct drm_device *dev,
+					     uint32_t maxX,
+					     uint32_t maxY)
 {
 	struct drm_connector *connector;
 
@@ -143,7 +144,6 @@ void drm_helper_probe_connector_modes(struct drm_device *dev, uint32_t maxX,
 		drm_helper_probe_single_connector_modes(connector, maxX, maxY);
 	}
 }
-EXPORT_SYMBOL(drm_helper_probe_connector_modes);
 
 
 /**
diff --git a/drivers/gpu/drm/drm_modes.c b/drivers/gpu/drm/drm_modes.c
index 7c36f16..c0cfe39 100644
--- a/drivers/gpu/drm/drm_modes.c
+++ b/drivers/gpu/drm/drm_modes.c
@@ -357,9 +357,9 @@ EXPORT_SYMBOL(drm_mode_validate_size);
  * sure each mode falls within a given range (defined by @min and @max
  * arrays) and sets @mode->status as needed.
  */
-void drm_mode_validate_clocks(struct drm_device *dev,
-			      struct list_head *mode_list,
-			      int *min, int *max, int n_ranges)
+static void drm_mode_validate_clocks(struct drm_device *dev,
+				     struct list_head *mode_list,
+				     int *min, int *max, int n_ranges)
 {
 	struct drm_display_mode *mode;
 	int i;
@@ -376,7 +376,6 @@ void drm_mode_validate_clocks(struct drm_device *dev,
 			mode->status = MODE_CLOCK_RANGE;
 	}
 }
-EXPORT_SYMBOL(drm_mode_validate_clocks);
 
 /**
  * drm_mode_prune_invalid - remove invalid modes from mode list


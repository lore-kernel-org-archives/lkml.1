Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932993Ab0BQJnN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 04:43:13 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:46048 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932551Ab0BQJnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 04:43:10 -0500
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, David Airlie <airlied@linux.ie>,
       Ben Skeggs <bskeggs@redhat.com>,
       Francisco Jerez <currojerez@riseup.net>,
       Maarten Maathuis <madman2003@gmail.com>,
       Xavier Chantry <shiningxc@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       dri-devel@lists.sourceforge.net
Subject: [PATCH] nouveau: fix undefined reference to acpi_lid_open
Date: Wed, 17 Feb 2010 10:42:43 +0100
Message-Id: <1266399763-28911-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following compile time error:

drivers/built-in.o: In function `nouveau_connector_detect':
/home/daniel/src/linux/jup/linux-2.6/drivers/gpu/drm/nouveau/nouveau_connector.c:243: undefined reference to `acpi_lid_open'

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Francisco Jerez <currojerez@riseup.net>
Cc: Maarten Maathuis <madman2003@gmail.com>
Cc: Xavier Chantry <shiningxc@gmail.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: dri-devel@lists.sourceforge.net
---
 drivers/gpu/drm/nouveau/nouveau_connector.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_connector.c b/drivers/gpu/drm/nouveau/nouveau_connector.c
index d2f6335..c74d45d 100644
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -239,7 +239,7 @@ nouveau_connector_detect(struct drm_connector *connector)
 	if (connector->connector_type == DRM_MODE_CONNECTOR_LVDS)
 		nv_encoder = find_encoder_by_type(connector, OUTPUT_LVDS);
 	if (nv_encoder && nv_connector->native_mode) {
-#ifdef CONFIG_ACPI
+#ifdef CONFIG_ACPI_BUTTON
 		if (!nouveau_ignorelid && !acpi_lid_open())
 			return connector_status_disconnected;
 #endif
-- 
1.6.5.2


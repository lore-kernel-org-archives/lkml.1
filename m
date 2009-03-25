Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425AbZCYAe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbZCYAe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756758AbZCYA3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:29:53 -0400
Received: from kroah.org ([198.145.64.141]:54078 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754435AbZCYA3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:29:48 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, airlied@linux.ie
Subject: [PATCH 16/61] drm: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue, 24 Mar 2009 17:26:20 -0700
Message-Id: <1237940825-22904-16-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Cc: airlied@linux.ie
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/gpu/drm/drm_sysfs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_sysfs.c b/drivers/gpu/drm/drm_sysfs.c
index 5aa6780..186d081 100644
--- a/drivers/gpu/drm/drm_sysfs.c
+++ b/drivers/gpu/drm/drm_sysfs.c
@@ -359,8 +359,8 @@ int drm_sysfs_connector_add(struct drm_connector *connector)
 	DRM_DEBUG("adding \"%s\" to sysfs\n",
 		  drm_get_connector_name(connector));
 
-	snprintf(connector->kdev.bus_id, BUS_ID_SIZE, "card%d-%s",
-		 dev->primary->index, drm_get_connector_name(connector));
+	dev_set_name(&connector->kdev, "card%d-%s",
+		     dev->primary->index, drm_get_connector_name(connector));
 	ret = device_register(&connector->kdev);
 
 	if (ret) {
-- 
1.6.2


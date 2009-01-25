Return-Path: <linux-kernel-owner+w=401wt.eu-S1751629AbZAYWoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629AbZAYWoT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 17:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbZAYWoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 17:44:11 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:46488 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbZAYWoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 17:44:10 -0500
Subject: drm: struct device - replace bus_id with dev_name(), dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: airlied@linux.ie
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 25 Jan 2009 23:43:17 +0100
Message-Id: <1232923397.2924.6.camel@nga>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: drm: struct device - replace bus_id with dev_name(), dev_set_name()

Cc: airlied@linux.ie
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/gpu/drm/drm_sysfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/drm_sysfs.c
+++ b/drivers/gpu/drm/drm_sysfs.c
@@ -359,8 +359,8 @@ int drm_sysfs_connector_add(struct drm_c
 	DRM_DEBUG("adding \"%s\" to sysfs\n",
 		  drm_get_connector_name(connector));
 
-	snprintf(connector->kdev.bus_id, BUS_ID_SIZE, "card%d-%s",
-		 dev->primary->index, drm_get_connector_name(connector));
+	dev_set_name(&connector->kdev, "card%d-%s",
+		     dev->primary->index, drm_get_connector_name(connector));
 	ret = device_register(&connector->kdev);
 
 	if (ret) {


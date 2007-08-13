Return-Path: <linux-kernel-owner+w=401wt.eu-S1756516AbXHMEES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbXHMEES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 00:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbXHMEEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 00:04:07 -0400
Received: from smtp3.hushmail.com ([65.39.178.135]:57544 "EHLO
	smtp3.hushmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbXHMEEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 00:04:06 -0400
Date: Mon, 13 Aug 2007 00:04:05 -0400
To: <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
       <dri-devel@lists.sourceforge.net>
Subject: [PATCH 3 of 5 ] /drivers/char/drm ioremap balancing/ returncode check
Reply-to: postfail@hushmail.com
From: "Scott Thompson" <postfail@hushmail.com>
Content-type: text/plain; charset="UTF-8"
Message-Id: <20070813040406.1E2EBDA820@mailserver8.hushmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

patchset against 2.6.23-rc2 and this set is an audit of 
/drivers/char/a* 
through drivers/char .   

this corrects missing ioremap return checks and balancing on 
iounmap calls..

Signed-off-by: Scott Thompson <postfail <at> hushmail.com>
----------------------------------------------------------
diff --git a/drivers/char/drm/drm_bufs.c 
b/drivers/char/drm/drm_bufs.c
index 923174c..448488b 100644
--- a/drivers/char/drm/drm_bufs.c
+++ b/drivers/char/drm/drm_bufs.c
@@ -177,8 +177,13 @@ static int drm_addmap_core(struct drm_device * 
dev, unsigned int offset,
 						     MTRR_TYPE_WRCOMB, 1);
 			}
 		}
-		if (map->type == _DRM_REGISTERS)
+		if (map->type == _DRM_REGISTERS) {
 			map->handle = ioremap(map->offset, map->size);
+			if (!map->handle) {
+				drm_free(map, sizeof(*map), DRM_MEM_MAPS);
+				return -ENOMEM;
+			}
+		}
 		break;
 	case _DRM_SHM:
 		list = drm_find_matching_map(dev, map);


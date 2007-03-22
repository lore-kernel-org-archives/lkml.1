Return-Path: <linux-kernel-owner+w=401wt.eu-S965821AbXCVGG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965821AbXCVGG1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 02:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965828AbXCVGEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 02:04:54 -0400
Received: from ozlabs.org ([203.10.76.45]:57965 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965821AbXCVGEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 02:04:07 -0400
To: Linux Memory Management <linux-mm@kvack.org>
CC: <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 22 Mar 2007 17:01:28 +1100
Subject: [RFC/PATCH 12/15] get_unmapped_area handles MAP_FIXED in ffb DRM
In-Reply-To: <1174543217.531981.572863804039.qpush@grosgo>
Message-Id: <20070322060302.72AE6DE40D@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

 drivers/char/drm/ffb_drv.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-cell/drivers/char/drm/ffb_drv.c
===================================================================
--- linux-cell.orig/drivers/char/drm/ffb_drv.c	2007-03-22 16:21:22.000000000 +1100
+++ linux-cell/drivers/char/drm/ffb_drv.c	2007-03-22 16:23:13.000000000 +1100
@@ -191,6 +191,12 @@ unsigned long ffb_get_unmapped_area(stru
 			if ((kvirt & (SHMLBA - 1)) != (addr & (SHMLBA - 1))) {
 				unsigned long koff, aoff;
 
+				/* Address needs adjusting which can't be done
+				 * for MAP_FIXED
+				 */
+				if (flags & MAP_FIXED)
+					return -EINVAL;
+
 				koff = kvirt & (SHMLBA - 1);
 				aoff = addr & (SHMLBA - 1);
 				if (koff < aoff)

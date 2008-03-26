Return-Path: <linux-kernel-owner+w=401wt.eu-S1759918AbYCZRJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759918AbYCZRJs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 13:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758243AbYCZRIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 13:08:30 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:29110 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757773AbYCZRI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 13:08:28 -0400
Message-Id: <20080326171223.669628073@ldl.fc.hp.com>
References: <20080326171058.099442579@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Wed, 26 Mar 2008 11:11:00 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 02/37] PNPACPI: continue after _CRS and _PRS errors
Content-Disposition: inline; filename=pnpacpi-ignore-errors
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep going and register the device even if we have trouble parsing
_CRS or _PRS.  A parsing problem might mean we ignore some resources
the device is using, or we might not be able to change its resources.
But we should still take note of anything we *could* parse correctly.

Also remove reference to dev_id because I plan to remove it soon.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work7/drivers/pnp/pnpacpi/core.c
===================================================================
--- work7.orig/drivers/pnp/pnpacpi/core.c	2008-03-21 15:12:19.000000000 -0600
+++ work7/drivers/pnp/pnpacpi/core.c	2008-03-21 15:12:20.000000000 -0600
@@ -213,8 +213,7 @@
 							  &dev->res);
 		if (ACPI_FAILURE(status) && (status != AE_NOT_FOUND)) {
 			pnp_err("PnPACPI: METHOD_NAME__CRS failure for %s",
-				dev_id->id);
-			goto err1;
+				acpi_device_hid(device));
 		}
 	}
 
@@ -223,8 +222,7 @@
 							    dev);
 		if (ACPI_FAILURE(status) && (status != AE_NOT_FOUND)) {
 			pnp_err("PnPACPI: METHOD_NAME__PRS failure for %s",
-				dev_id->id);
-			goto err1;
+				acpi_device_hid(device));
 		}
 	}
 
@@ -252,8 +250,6 @@
 	num++;
 
 	return AE_OK;
-err1:
-	kfree(dev_id);
 err:
 	kfree(dev);
 	return -EINVAL;

-- 

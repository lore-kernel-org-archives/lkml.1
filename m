Return-Path: <linux-kernel-owner+w=401wt.eu-S1762392AbYCZRRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762392AbYCZRRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 13:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758106AbYCZRJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 13:09:23 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:22098 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760513AbYCZRI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 13:08:57 -0400
Message-Id: <20080326171227.131971545@ldl.fc.hp.com>
References: <20080326171058.099442579@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Wed, 26 Mar 2008 11:11:17 -0600
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
Subject: [patch 19/37] PNP: remove pnp_resource_table from internal pnp_clean_resource_table interface
Content-Disposition: inline; filename=pnp-remove-pnp_resource_table-from-clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes pnp_clean_resource_table() to take a pnp_dev pointer
rather than a pnp_resource_table pointer.  This reduces the visibility
of pnp_resource_table and removes an opportunity for error in the
caller.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work7/drivers/pnp/manager.c
===================================================================
--- work7.orig/drivers/pnp/manager.c	2008-03-25 11:03:59.000000000 -0600
+++ work7/drivers/pnp/manager.c	2008-03-25 11:04:52.000000000 -0600
@@ -247,8 +247,9 @@
  * pnp_clean_resources - clears resources that were not manually set
  * @res: the resources to clean
  */
-static void pnp_clean_resource_table(struct pnp_resource_table *res)
+static void pnp_clean_resource_table(struct pnp_dev *dev)
 {
+	struct pnp_resource_table *res = &dev->res;
 	int idx;
 
 	for (idx = 0; idx < PNP_MAX_IRQ; idx++) {
@@ -304,7 +305,7 @@
 		return -ENODEV;
 
 	mutex_lock(&pnp_res_mutex);
-	pnp_clean_resource_table(&dev->res);	/* start with a fresh slate */
+	pnp_clean_resource_table(dev);
 	if (dev->independent) {
 		port = dev->independent->port;
 		mem = dev->independent->mem;
@@ -376,7 +377,7 @@
 	return 1;
 
 fail:
-	pnp_clean_resource_table(&dev->res);
+	pnp_clean_resource_table(dev);
 	mutex_unlock(&pnp_res_mutex);
 	return 0;
 }
@@ -554,7 +555,7 @@
 
 	/* release the resources so that other devices can use them */
 	mutex_lock(&pnp_res_mutex);
-	pnp_clean_resource_table(&dev->res);
+	pnp_clean_resource_table(dev);
 	mutex_unlock(&pnp_res_mutex);
 
 	return 0;

-- 

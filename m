Return-Path: <linux-kernel-owner+w=401wt.eu-S936437AbYD1XBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936437AbYD1XBb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 19:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966746AbYD1WiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:38:22 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:1032 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966820AbYD1Whd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:37:33 -0400
Message-Id: <20080428223627.551087646@ldl.fc.hp.com>
References: <20080428223347.233593713@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 16:34:41 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, Rene Herman <rene.herman@gmail.com>
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 54/55] ISAPNP: remove unused pnp_dev->regs field
Content-Disposition: inline; filename=isapnp-remove-unused-pnp_dev-fields
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "regs" field in struct pnp_dev is set but never read, so remove it.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-By: Rene Herman <rene.herman@gmail.com>

Index: work10/drivers/pnp/isapnp/core.c
===================================================================
--- work10.orig/drivers/pnp/isapnp/core.c	2008-04-28 16:09:49.000000000 -0600
+++ work10/drivers/pnp/isapnp/core.c	2008-04-28 16:09:51.000000000 -0600
@@ -416,10 +416,7 @@
 	if (!dev)
 		return NULL;
 
-	dev->regs = tmp[4];
 	dev->card = card;
-	if (size > 5)
-		dev->regs |= tmp[5] << 8;
 	dev->capabilities |= PNP_CONFIGURABLE;
 	dev->capabilities |= PNP_READ;
 	dev->capabilities |= PNP_WRITE;
Index: work10/include/linux/pnp.h
===================================================================
--- work10.orig/include/linux/pnp.h	2008-04-28 16:09:50.000000000 -0600
+++ work10/include/linux/pnp.h	2008-04-28 16:09:51.000000000 -0600
@@ -253,7 +253,6 @@
 	struct pnp_resource_table *res;
 
 	char name[PNP_NAME_LEN];	/* contains a human-readable name */
-	unsigned short regs;		/* ISAPnP: supported registers */
 	int flags;			/* used by protocols */
 	struct proc_dir_entry *procent;	/* device entry in /proc/bus/isapnp */
 	void *data;

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1763986AbYDRVNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763986AbYDRVNZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 17:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761295AbYDRUxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 16:53:40 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:21870 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761347AbYDRUwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 16:52:38 -0400
Message-Id: <20080418205057.357405111@ldl.fc.hp.com>
References: <20080418204955.342963315@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Apr 2008 14:50:45 -0600
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
Subject: [patch 50/53] ISAPNP: remove unused pnp_dev->regs field
Content-Disposition: inline; filename=isapnp-remove-unused-pnp_dev-fields
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "regs" field in struct pnp_dev is set but never read, so remove it.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work8/drivers/pnp/isapnp/core.c
===================================================================
--- work8.orig/drivers/pnp/isapnp/core.c	2008-04-18 11:15:16.000000000 -0600
+++ work8/drivers/pnp/isapnp/core.c	2008-04-18 11:19:49.000000000 -0600
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
Index: work8/include/linux/pnp.h
===================================================================
--- work8.orig/include/linux/pnp.h	2008-04-18 11:19:43.000000000 -0600
+++ work8/include/linux/pnp.h	2008-04-18 11:19:49.000000000 -0600
@@ -255,7 +255,6 @@
 	struct list_head resources;
 
 	char name[PNP_NAME_LEN];	/* contains a human-readable name */
-	unsigned short regs;		/* ISAPnP: supported registers */
 	int flags;			/* used by protocols */
 	struct proc_dir_entry *procent;	/* device entry in /proc/bus/isapnp */
 	void *data;

-- 

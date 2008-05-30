Return-Path: <linux-kernel-owner+w=401wt.eu-S1755211AbYE3WwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbYE3WwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 18:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755033AbYE3Wtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 18:49:49 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:36043 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbYE3Wth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 18:49:37 -0400
Message-Id: <20080530224932.974122201@ldl.fc.hp.com>
References: <20080530224853.976744229@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 30 May 2008 16:49:01 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Takashi Iwai <tiwai@suse.de>
Subject: [patch 08/15] PNP: in debug resource dump, make empty list obvious
Content-Disposition: inline; filename=pnp-improve-debug-resource-dump
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the resource list is empty, say that explicitly.  Previously,
it was confusing because often the heading was followed by zero
resource lines, then some "add resource" lines from auto-assignment,
so the "add" lines looked like current resources.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work10/drivers/pnp/support.c
===================================================================
--- work10.orig/drivers/pnp/support.c	2008-05-16 16:01:26.000000000 -0600
+++ work10/drivers/pnp/support.c	2008-05-16 16:13:42.000000000 -0600
@@ -77,7 +77,12 @@ void dbg_pnp_show_resources(struct pnp_d
 	struct pnp_resource *pnp_res;
 	struct resource *res;
 
-	dev_dbg(&dev->dev, "current resources: %s\n", desc);
+	if (list_empty(&dev->resources)) {
+		dev_dbg(&dev->dev, "%s: no current resources\n", desc);
+		return;
+	}
+
+	dev_dbg(&dev->dev, "%s: current resources:\n", desc);
 	list_for_each_entry(pnp_res, &dev->resources, list) {
 		res = &pnp_res->res;
 

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761588AbYFQXHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761588AbYFQXHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 19:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759624AbYFQXAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 19:00:31 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:9412 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759076AbYFQXAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 19:00:01 -0400
Message-Id: <20080617225911.600024092@ldl.fc.hp.com>
References: <20080617225823.045233728@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Tue, 17 Jun 2008 16:58:42 -0600
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
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jiri Slaby <jirislaby@gmail.com>
Subject: [patch 19/28] PNP: remove redundant pnp_can_configure() check
Content-Disposition: inline; filename=pnp-remove-assign-configurability-check
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pnp_assign_resources() is static and the only caller checks
pnp_can_configure() before calling it, so no need to do it
again.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-by: Rene Herman <rene.herman@gmail.com>

Index: work10/drivers/pnp/manager.c
===================================================================
--- work10.orig/drivers/pnp/manager.c	2008-05-13 13:29:57.000000000 -0600
+++ work10/drivers/pnp/manager.c	2008-05-13 13:30:21.000000000 -0600
@@ -231,9 +231,6 @@ static int pnp_assign_resources(struct p
 	struct pnp_dma *dma;
 	int nport = 0, nmem = 0, nirq = 0, ndma = 0;
 
-	if (!pnp_can_configure(dev))
-		return -ENODEV;
-
 	dbg_pnp_show_resources(dev, "before pnp_assign_resources");
 	mutex_lock(&pnp_res_mutex);
 	pnp_clean_resource_table(dev);

-- 

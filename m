Return-Path: <linux-kernel-owner+w=401wt.eu-S932167AbYF0XJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167AbYF0XJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 19:09:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764282AbYF0W7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 18:59:33 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:6004 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764386AbYF0W7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 18:59:05 -0400
Message-Id: <20080627225802.140634493@ldl.fc.hp.com>
References: <20080627225651.663174474@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 16:57:10 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
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
Cc: David Howells <dhowells@redhat.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
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

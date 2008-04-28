Return-Path: <linux-kernel-owner+w=401wt.eu-S967670AbYD1Wxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967670AbYD1Wxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 18:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966832AbYD1Whm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:37:42 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:12895 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966752AbYD1WhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:37:12 -0400
Message-Id: <20080428223624.698767070@ldl.fc.hp.com>
References: <20080428223347.233593713@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 16:34:27 -0600
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
Subject: [patch 40/55] rtc: dont reference pnp_resource_table directly
Content-Disposition: inline; filename=rtc-remove-pnp_resource_table-use
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pnp_resource_table is going away soon, so use the more
generic public interfaces instead.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-By: Rene Herman <rene.herman@gmail.com>

Index: work10/drivers/rtc/rtc-cmos.c
===================================================================
--- work10.orig/drivers/rtc/rtc-cmos.c	2008-04-28 15:57:02.000000000 -0600
+++ work10/drivers/rtc/rtc-cmos.c	2008-04-28 16:09:37.000000000 -0600
@@ -854,11 +854,12 @@
 		 * don't define the IRQ. It should always be safe to
 		 * hardcode it in these cases
 		 */
-		return cmos_do_probe(&pnp->dev, &pnp->res.port_resource[0], 8);
+		return cmos_do_probe(&pnp->dev,
+				pnp_get_resource(pnp, IORESOURCE_IO, 0), 8);
 	else
 		return cmos_do_probe(&pnp->dev,
-				     &pnp->res.port_resource[0],
-				     pnp->res.irq_resource[0].start);
+				pnp_get_resource(pnp, IORESOURCE_IO, 0),
+				pnp_irq(pnp, 0));
 }
 
 static void __exit cmos_pnp_remove(struct pnp_dev *pnp)

-- 

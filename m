Return-Path: <linux-kernel-owner+w=401wt.eu-S1765698AbYDYS4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765698AbYDYS4P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 14:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764429AbYDYSku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:40:50 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:10080 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764776AbYDYSkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:40:20 -0400
Message-Id: <20080425183932.050706483@ldl.fc.hp.com>
References: <20080425183807.366134771@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 Apr 2008 12:38:46 -0600
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
Subject: [patch 39/54] rtc: dont reference pnp_resource_table directly
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
--- work10.orig/drivers/rtc/rtc-cmos.c	2008-04-25 11:12:15.000000000 -0600
+++ work10/drivers/rtc/rtc-cmos.c	2008-04-25 11:15:08.000000000 -0600
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

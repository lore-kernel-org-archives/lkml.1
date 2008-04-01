Return-Path: <linux-kernel-owner+w=401wt.eu-S1761918AbYDAP10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761918AbYDAP10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 11:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbYDAPSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 11:18:55 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:17527 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756743AbYDAPSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 11:18:36 -0400
Message-Id: <20080401151742.662774841@ldl.fc.hp.com>
References: <20080401151634.730901933@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Tue, 01 Apr 2008 09:17:09 -0600
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
Subject: [patch 35/37] rtc: dont reference pnp_resource_table directly
Content-Disposition: inline; filename=rtc-remove-pnp_resource_table-use
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pnp_resource_table is going away soon, so use the more
generic public interfaces instead.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work7/drivers/rtc/rtc-cmos.c
===================================================================
--- work7.orig/drivers/rtc/rtc-cmos.c	2008-03-25 17:04:44.000000000 -0600
+++ work7/drivers/rtc/rtc-cmos.c	2008-03-25 17:04:45.000000000 -0600
@@ -855,11 +855,12 @@
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

Return-Path: <linux-kernel-owner+w=401wt.eu-S1763454AbYEEWlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763454AbYEEWlJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 18:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754927AbYEEWkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 18:40:00 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:19927 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760629AbYEEWj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 18:39:58 -0400
Message-Id: <20080505223958.851331042@ldl.fc.hp.com>
References: <20080505223630.682082986@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Mon, 05 May 2008 16:36:31 -0600
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
Subject: [patch 1/8] PNP: set IRQ index in sysfs "set irq" interface
Content-Disposition: inline; filename=pnp-interface-fixup
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have to set the ISAPNP register index when setting an IRQ via
the sysfs interface.  We already do it for IO, MEM, and DMA
resources; I just missed the IRQ one.

This should be in 2.6.26.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work10/drivers/pnp/interface.c
===================================================================
--- work10.orig/drivers/pnp/interface.c	2008-05-01 15:26:28.000000000 -0600
+++ work10/drivers/pnp/interface.c	2008-05-01 15:26:39.000000000 -0600
@@ -424,7 +424,7 @@
 				start = simple_strtoul(buf, &buf, 0);
 				pnp_res = pnp_add_irq_resource(dev, start, 0);
 				if (pnp_res)
-					nirq++;
+					pnp_res->index = nirq++;
 				continue;
 			}
 			if (!strnicmp(buf, "dma", 3)) {

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1762480AbYCZRMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762480AbYCZRMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 13:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760687AbYCZRIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 13:08:46 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:26021 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760006AbYCZRIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 13:08:41 -0400
Message-Id: <20080326171225.541605422@ldl.fc.hp.com>
References: <20080326171058.099442579@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Wed, 26 Mar 2008 11:11:09 -0600
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
Subject: [patch 11/37] PNPACPI: pnpacpi_encode_ext_irq() wrongly set "irq" instead of "extended_irq"
Content-Disposition: inline; filename=pnpacpi-fix-encode-extended-irq
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has been wrong since at least 2.6.12.  I haven't seen any bug
reports, but it's clearly incorrect.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work7/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work7.orig/drivers/pnp/pnpacpi/rsparser.c	2008-03-20 11:50:19.000000000 -0600
+++ work7/drivers/pnp/pnpacpi/rsparser.c	2008-03-20 12:02:18.000000000 -0600
@@ -818,9 +818,9 @@
 	resource->data.extended_irq.triggering = triggering;
 	resource->data.extended_irq.polarity = polarity;
 	if (triggering == ACPI_EDGE_SENSITIVE)
-		resource->data.irq.sharable = ACPI_EXCLUSIVE;
+		resource->data.extended_irq.sharable = ACPI_EXCLUSIVE;
 	else
-		resource->data.irq.sharable = ACPI_SHARED;
+		resource->data.extended_irq.sharable = ACPI_SHARED;
 	resource->data.extended_irq.interrupt_count = 1;
 	resource->data.extended_irq.interrupts[0] = p->start;
 }

-- 

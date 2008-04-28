Return-Path: <linux-kernel-owner+w=401wt.eu-S935948AbYD1Wmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935948AbYD1Wmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 18:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964860AbYD1Wgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:36:37 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:3545 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966158AbYD1Wgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:36:32 -0400
Message-Id: <20080428223618.877424514@ldl.fc.hp.com>
References: <20080428223347.233593713@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 16:33:59 -0600
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
Subject: [patch 12/55] PNPACPI: pnpacpi_encode_ext_irq() wrongly set "irq" instead of "extended_irq"
Content-Disposition: inline; filename=pnpacpi-fix-encode-extended-irq
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pnpacpi_encode_ext_irq() should set resource->data.extended_irq, not
resource->data.irq.

This has been wrong since at least 2.6.12.  I haven't seen any bug
reports, but it's clearly incorrect.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work10/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work10.orig/drivers/pnp/pnpacpi/rsparser.c	2008-04-28 15:57:04.000000000 -0600
+++ work10/drivers/pnp/pnpacpi/rsparser.c	2008-04-28 16:09:15.000000000 -0600
@@ -820,9 +820,9 @@
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

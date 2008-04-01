Return-Path: <linux-kernel-owner+w=401wt.eu-S1760573AbYDAPWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760573AbYDAPWE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 11:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759392AbYDAPSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 11:18:13 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:11805 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbYDAPSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 11:18:00 -0400
Message-Id: <20080401151737.850030639@ldl.fc.hp.com>
References: <20080401151634.730901933@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Tue, 01 Apr 2008 09:16:45 -0600
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

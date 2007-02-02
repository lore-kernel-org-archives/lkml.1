Return-Path: <linux-kernel-owner+w=401wt.eu-S1946066AbXBBUyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946066AbXBBUyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 15:54:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946067AbXBBUyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 15:54:15 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:38674 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946064AbXBBUyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 15:54:14 -0500
From: John Keller <jpk@sgi.com>
To: linux-acpi@vger.kernel.org
Cc: ayoung@sgi.com, linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Keller <jpk@sgi.com>
Date: Fri, 02 Feb 2007 14:54:12 -0600
Message-Id: <20070202205412.14367.60290.sendpatchset@attica.americas.sgi.com>
Subject: [PATCH 1/1] -  Altix: more ACPI PRT support
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The SN Altix platform does not conform to the 
IOSAPIC IRQ routing model. Add code in acpi_unregister_gsi()
to check if (acpi_irq_model == ACPI_IRQ_MODEL_PLATFORM) and
return.

Signed-off-by: John Keller <jpk@sgi.com>
---

Due to an oversight, this code was not added previously when
similar code was added to acpi_register_gsi().

http://marc.theaimsgroup.com/?l=linux-acpi&m=116680983430121&w=2

 arch/ia64/kernel/acpi.c |    3 +++
 1 file changed, 3 insertions(+)


Index: linux-2.6/arch/ia64/kernel/acpi.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/acpi.c	2007-02-02 14:44:31.000000000 -0600
+++ linux-2.6/arch/ia64/kernel/acpi.c	2007-02-02 14:47:44.658143727 -0600
@@ -609,6 +609,9 @@ EXPORT_SYMBOL(acpi_register_gsi);
 
 void acpi_unregister_gsi(u32 gsi)
 {
+	if (acpi_irq_model == ACPI_IRQ_MODEL_PLATFORM)
+		return;
+
 	iosapic_unregister_intr(gsi);
 }
 

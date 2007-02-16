Return-Path: <linux-kernel-owner+w=401wt.eu-S1946243AbXBPVH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946243AbXBPVH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 16:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946242AbXBPVH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 16:07:29 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:47836 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1946237AbXBPVH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 16:07:28 -0500
From: John Keller <jpk@sgi.com>
To: linux-acpi@vger.kernel.org
Cc: ayoung@sgi.com, linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Keller <jpk@sgi.com>
Date: Fri, 16 Feb 2007 15:07:27 -0600
Message-Id: <20070216210727.7407.93052.sendpatchset@attica.americas.sgi.com>
Subject: [PATCH 1/1] -  acpi_boot_init() making bad check on return code
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_boot_init() is making a bad check on the return
status from acpi_table_parse(). acpi_table_parse() now
returns zero on success, one on failure.

Signed-off-by: Aaron Young <ayoung@sgi.com>
---

Index: release/arch/ia64/kernel/acpi.c
===================================================================
--- release.orig/arch/ia64/kernel/acpi.c	2007-02-16 08:58:10.000000000 -0600
+++ release/arch/ia64/kernel/acpi.c	2007-02-16 09:03:16.893360100 -0600
@@ -651,7 +651,7 @@ int __init acpi_boot_init(void)
 	 * information -- the successor to MPS tables.
 	 */
 
-	if (acpi_table_parse(ACPI_SIG_MADT, acpi_parse_madt) < 1) {
+	if (acpi_table_parse(ACPI_SIG_MADT, acpi_parse_madt)) {
 		printk(KERN_ERR PREFIX "Can't find MADT\n");
 		goto skip_madt;
 	}
@@ -702,7 +702,7 @@ int __init acpi_boot_init(void)
 	 * gets interrupts such as power and sleep buttons.  If it's not
 	 * on a Legacy interrupt, it needs to be setup.
 	 */
-	if (acpi_table_parse(ACPI_SIG_FADT, acpi_parse_fadt) < 1)
+	if (acpi_table_parse(ACPI_SIG_FADT, acpi_parse_fadt))
 		printk(KERN_ERR PREFIX "Can't find FADT\n");
 
 #ifdef CONFIG_SMP

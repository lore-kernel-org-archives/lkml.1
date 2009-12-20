Return-Path: <linux-kernel-owner+w=401wt.eu-S1752877AbZLTJb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbZLTJb5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 04:31:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbZLTJb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 04:31:56 -0500
Received: from mail.issp.bas.bg ([195.96.236.10]:56835 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274AbZLTJbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 04:31:55 -0500
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH]Section mismatch: drivers/pci/dmar.c, add __init notation
Date: Sun, 20 Dec 2009 11:31:04 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.33-rc1; KDE/4.2.4; x86_64; ; )
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912201131.04479.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The function dmar_ir_support() references the variable __initdata dmar_tbl. 
dmar_ir_support() itself is called by __init intr_remapping_supported() only.
Mark it __init too.

The patch is against 2.6.33-rc1.

Signed-off-by: Marin Mitov <mitov@issp.bas.bg>

=====================================================================
--- a/drivers/pci/dmar.c	2009-12-20 10:37:50.000000000 +0200
+++ b/drivers/pci/dmar.c	2009-12-20 10:38:29.000000000 +0200
@@ -1456,7 +1456,7 @@
 /*
  * Check interrupt remapping support in DMAR table description.
  */
-int dmar_ir_support(void)
+int __init dmar_ir_support(void)
 {
 	struct acpi_table_dmar *dmar;
 	dmar = (struct acpi_table_dmar *)dmar_tbl;

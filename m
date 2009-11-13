Return-Path: <linux-kernel-owner+w=401wt.eu-S1756071AbZKMRAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbZKMRAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 12:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754775AbZKMRAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 12:00:34 -0500
Received: from mail.issp.bas.bg ([195.96.236.10]:55787 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbZKMRAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 12:00:34 -0500
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: Ashok Raj <ashok.raj@intel.com>
Subject: [PATCH]Section mismatch in 2.6.32-rc7
Date: Fri, 13 Nov 2009 18:59:02 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.32-rc7; KDE/4.2.4; x86_64; ; )
Cc: Shaohua Li <shaohua.li@intel.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911131859.02883.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The function dmar_ir_support()  in drivers/pci/dmar.c references
the variable __initdata dmar_tbl. The function is used only in 
intr_remapping_supported (in drivers/pci/intr_remapping.c) which
is already marked __init. Mark it also as __init.

The patch is against 2.6.32-rc7.

Signed-off-by: Marin Mitov <mitov@issp.bas.bg>

====================================================================
--- a/drivers/pci/dmar.c	2009-11-13 18:16:31.000000000 +0200
+++ b/drivers/pci/dmar.c	2009-11-13 18:18:33.000000000 +0200
@@ -1338,7 +1338,7 @@
 /*
  * Check interrupt remapping support in DMAR table description.
  */
-int dmar_ir_support(void)
+int __init dmar_ir_support(void)
 {
 	struct acpi_table_dmar *dmar;
 	dmar = (struct acpi_table_dmar *)dmar_tbl;

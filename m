Return-Path: <linux-kernel-owner+w=401wt.eu-S1756888AbYELSNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888AbYELSNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 14:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbYELSNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 14:13:13 -0400
Received: from smtp1.betherenow.co.uk ([87.194.0.68]:50547 "HELO
	smtp1.betherenow.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752576AbYELSNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 14:13:12 -0400
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Len Brown <len.brown@intel.com>
Subject: [PATCH] ACPI 2.6.26-rc2: Add missing newline to DSDT/SSDT warning message
Date: Mon, 12 May 2008 19:13:09 +0100
User-Agent: KMail/1.9.9
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805121913.09502.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of recently (probably 2.6.26-rc1) I've been getting the following mangling
in the kernel log:

[4294014.568167] ACPI: DSDT override uses original SSDTs unless "acpi_no_auto_ssdt"<6>CPU0: Intel(R) Pentium(R) Dual  CPU  E2160  @ 1.80GHz stepping 0d

This is due to a missing newline character in the first message. The following
patch against 2.6.26-rc2 fixes it. Please apply.

Signed-off-by: Alistair John Strachan <alistair@devzero.co.uk>
---

diff --git a/drivers/acpi/tables/tbxface.c b/drivers/acpi/tables/tbxface.c
index fb57b93..0e31960 100644
--- a/drivers/acpi/tables/tbxface.c
+++ b/drivers/acpi/tables/tbxface.c
@@ -540,7 +540,7 @@ static acpi_status acpi_tb_load_namespace(void)
 		acpi_tb_print_table_header(0, table);
 
 		if (no_auto_ssdt == 0) {
-			printk(KERN_WARNING "ACPI: DSDT override uses original SSDTs unless \"acpi_no_auto_ssdt\"");
+			printk(KERN_WARNING "ACPI: DSDT override uses original SSDTs unless \"acpi_no_auto_ssdt\"\n");
 		}
 	}
 
-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.

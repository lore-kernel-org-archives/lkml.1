Return-Path: <linux-kernel-owner+w=401wt.eu-S933347AbXIAX3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347AbXIAX3R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 19:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757616AbXIAX3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 19:29:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41785 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbXIAX3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 19:29:07 -0400
Date: Sun, 2 Sep 2007 05:12:14 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
Subject: [PATCH -mm] drivers/acpi/tables/tbutils.c: Shut up bogus uninitialized
 variable warning
In-Reply-To: <20070831215822.26e1432b.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0709020510300.20781@enigma.security.iitk.ac.in>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


drivers/acpi/tables/tbutils.c: In function 'acpi_tb_parse_root_table':
drivers/acpi/tables/tbutils.c:403:
warning: 'rsdt_address' may be used uninitialized in this function

has been verified to be a bogus warning. Let's just initialize the
variable to zero and shut this up.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

I didn't use uninitialized_var() here because drivers/acpi/ is dual-licensed
stuff and used elsewhere, where that macro may be unavailable (?)

 drivers/acpi/tables/tbutils.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.23-rc4-mm1/drivers/acpi/tables/tbutils.c~fix	2007-09-02 05:07:02.000000000 +0530
+++ linux-2.6.23-rc4-mm1/drivers/acpi/tables/tbutils.c	2007-09-02 05:07:14.000000000 +0530
@@ -400,7 +400,7 @@ acpi_tb_parse_root_table(acpi_physical_a
 	u32 table_count;
 	struct acpi_table_header *table;
 	acpi_physical_address address;
-	acpi_physical_address rsdt_address;
+	acpi_physical_address rsdt_address = 0;
 	u32 length;
 	u8 *table_entry;
 	acpi_status status;

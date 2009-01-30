Return-Path: <linux-kernel-owner+w=401wt.eu-S1757499AbZA3Wpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499AbZA3Wpu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 17:45:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756775AbZA3WpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 17:45:01 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:2284 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677AbZA3Wo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 17:44:59 -0500
From: Myron Stowe <myron.stowe@hp.com>
Subject: [PATCH 2/2] ACPICA: 80 column adherence (no functional change)
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       myron.stowe@hp.com, Myron Stowe <myron.stowe@hp.com>
Date: Fri, 30 Jan 2009 15:44:58 -0700
Message-ID: <20090130224458.24329.8120.stgit@bob.kio>
In-Reply-To: <20090130223832.24329.5434.stgit@bob.kio>
References: <20090130223832.24329.5434.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies a file derived from ACPI CA and as such formatting
may come directly from the CA code or indirectly from some type of parsing
of the original CA code.  As such, non-functional formatting changes may be
counter productive.  If this is the case then feel free to ignore this
component of the patch series.


This modification may be used under either the GPL or the BSD-style
license used for Intel ACPI CA code.

Signed-off-by: Myron Stowe <myron.stowe@hp.com>
---

 drivers/acpi/acpica/tbutils.c |   36 +++++++++++++++++++++++++-----------
 1 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/acpica/tbutils.c b/drivers/acpi/acpica/tbutils.c
index 22ce489..e5c24b8 100644
--- a/drivers/acpi/acpica/tbutils.c
+++ b/drivers/acpi/acpica/tbutils.c
@@ -179,7 +179,10 @@ acpi_tb_print_table_header(acpi_physical_address address,
 
 	if (ACPI_COMPARE_NAME(header->signature, ACPI_SIG_FACS)) {
 
-		/* FACS only has signature and length fields of common table header */
+		/*
+		 * FACS only has signature and length fields of common table
+		 * header
+		 */
 
 		ACPI_INFO((AE_INFO, "%4.4s %08lX, %04X",
 			   header->signature, (unsigned long)address,
@@ -379,14 +382,18 @@ acpi_tb_get_root_table_entry(u8 *table_entry, u32 table_entry_size)
 	} else {
 		/*
 		 * 32-bit platform, XSDT: Truncate 64-bit to 32-bit and return
-		 * 64-bit platform, XSDT: Move (unaligned) 64-bit to local, return 64-bit
+		 * 64-bit platform, XSDT: Move (unaligned) 64-bit to local,
+		 * return 64-bit
 		 */
 		ACPI_MOVE_64_TO_64(&address64, table_entry);
 
 #if ACPI_MACHINE_WIDTH == 32
 		if (address64 > ACPI_UINT32_MAX) {
 
-			/* Will truncate 64-bit address to 32 bits, issue warning */
+			/*
+			 * Will truncate 64-bit address to 32 bits, issue
+			 * warning
+			 */
 
 			ACPI_WARNING((AE_INFO,
 				      "64-bit Physical Address in XSDT is too large (%8.8X%8.8X), truncating",
@@ -448,9 +455,9 @@ acpi_tb_parse_root_table(acpi_physical_address rsdp_address, u8 flags)
 	if (rsdp->revision > 1 && rsdp->xsdt_physical_address
 			&& !acpi_rsdt_forced) {
 		/*
-		 * Root table is an XSDT (64-bit physical addresses). We must use the
-		 * XSDT if the revision is > 1 and the XSDT pointer is present, as per
-		 * the ACPI specification.
+		 * Root table is an XSDT (64-bit physical addresses). We must
+		 * use the XSDT if the revision is > 1 and the XSDT pointer
+		 * is present, as per * the ACPI specification.
 		 */
 		address = (acpi_physical_address) rsdp->xsdt_physical_address;
 		table_entry_size = sizeof(u64);
@@ -487,7 +494,7 @@ acpi_tb_parse_root_table(acpi_physical_address rsdp_address, u8 flags)
 
 	acpi_tb_print_table_header(address, table);
 
-	/* Get the length of the full table, verify length and map entire table */
+	/* Get the length of the full table, verify len, and map entire table */
 
 	length = table->length;
 	acpi_os_unmap_memory(table, sizeof(struct acpi_table_header));
@@ -518,8 +525,9 @@ acpi_tb_parse_root_table(acpi_physical_address rsdp_address, u8 flags)
 		    sizeof(struct acpi_table_header)) / table_entry_size);
 
 	/*
-	 * First two entries in the table array are reserved for the DSDT and FACS,
-	 * which are not actually present in the RSDT/XSDT - they come from the FADT
+	 * First two entries in the table array are reserved for the DSDT and
+	 * FACS, * which are not actually present in the RSDT/XSDT - they come
+	 * from the FADT
 	 */
 	table_entry =
 	    ACPI_CAST_PTR(u8, table) + sizeof(struct acpi_table_header);
@@ -532,7 +540,10 @@ acpi_tb_parse_root_table(acpi_physical_address rsdp_address, u8 flags)
 		if (acpi_gbl_root_table_list.count >=
 		    acpi_gbl_root_table_list.size) {
 
-			/* There is no more room in the root table array, attempt resize */
+			/*
+			 * There is no more room in the root table array,
+			 * attempt resize
+			 */
 
 			status = acpi_tb_resize_root_table_list();
 			if (ACPI_FAILURE(status)) {
@@ -545,7 +556,10 @@ acpi_tb_parse_root_table(acpi_physical_address rsdp_address, u8 flags)
 			}
 		}
 
-		/* Get the table physical address (32-bit for RSDT, 64-bit for XSDT) */
+		/*
+		 * Get the table physical address (32-bit for RSDT,
+		 * 64-bit for XSDT)
+		 */
 
 		acpi_gbl_root_table_list.tables[acpi_gbl_root_table_list.count].
 		    address =


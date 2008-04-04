Return-Path: <linux-kernel-owner+w=401wt.eu-S1758253AbYDDMgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253AbYDDMgM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 08:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbYDDMf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 08:35:58 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:40297
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752075AbYDDMf6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 08:35:58 -0400
Message-Id: <47F63CE3.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Fri, 04 Apr 2008 13:36:19 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <len.brown@intel.com>
Cc: "linux-acpi" <linux-acpi@intel.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] use __init* on everything in tables/tbfadt.c
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All of the code in this file is use at boot time only.

Additionally, acpi_tb_create_local_fadt() doesn't need a globally
visible declaration.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 drivers/acpi/tables/tbfadt.c |   15 +++++++++------
 include/acpi/actables.h      |    2 --
 2 files changed, 9 insertions(+), 8 deletions(-)

--- linux-2.6.25-rc8/drivers/acpi/tables/tbfadt.c	2007-10-09 22:31:38.000000000 +0200
+++ 2.6.25-rc8-acpi-tbfadt-init/drivers/acpi/tables/tbfadt.c	2008-04-03 11:15:08.000000000 +0200
@@ -52,6 +52,8 @@ static void inline
 acpi_tb_init_generic_address(struct acpi_generic_address *generic_address,
 			     u8 bit_width, u64 address);
 
+static void acpi_tb_create_local_fadt(struct acpi_table_header *, u32 length);
+
 static void acpi_tb_convert_fadt(void);
 
 static void acpi_tb_validate_fadt(void);
@@ -59,7 +61,7 @@ static void acpi_tb_validate_fadt(void);
 /* Table for conversion of FADT to common internal format and FADT validation */
 
 typedef struct acpi_fadt_info {
-	char *name;
+	const char *name;
 	u8 target;
 	u8 source;
 	u8 length;
@@ -70,7 +72,7 @@ typedef struct acpi_fadt_info {
 #define ACPI_FADT_REQUIRED          1
 #define ACPI_FADT_SEPARATE_LENGTH   2
 
-static struct acpi_fadt_info fadt_info_table[] = {
+static struct acpi_fadt_info __initdata fadt_info_table[] = {
 	{"Pm1aEventBlock", ACPI_FADT_OFFSET(xpm1a_event_block),
 	 ACPI_FADT_OFFSET(pm1a_event_block),
 	 ACPI_FADT_OFFSET(pm1_event_length), ACPI_FADT_REQUIRED},
@@ -155,7 +157,7 @@ acpi_tb_init_generic_address(struct acpi
  *
  ******************************************************************************/
 
-void acpi_tb_parse_fadt(acpi_native_uint table_index, u8 flags)
+void __init acpi_tb_parse_fadt(acpi_native_uint table_index, u8 flags)
 {
 	u32 length;
 	struct acpi_table_header *table;
@@ -215,7 +217,8 @@ void acpi_tb_parse_fadt(acpi_native_uint
  *
  ******************************************************************************/
 
-void acpi_tb_create_local_fadt(struct acpi_table_header *table, u32 length)
+static void __init
+acpi_tb_create_local_fadt(struct acpi_table_header *table, u32 length)
 {
 
 	/*
@@ -276,7 +279,7 @@ void acpi_tb_create_local_fadt(struct ac
  *
  ******************************************************************************/
 
-static void acpi_tb_convert_fadt(void)
+static void __init acpi_tb_convert_fadt(void)
 {
 	u8 pm1_register_length;
 	struct acpi_generic_address *target;
@@ -391,7 +394,7 @@ static void acpi_tb_convert_fadt(void)
  *
  ******************************************************************************/
 
-static void acpi_tb_validate_fadt(void)
+static void __init acpi_tb_validate_fadt(void)
 {
 	u32 *address32;
 	struct acpi_generic_address *address64;
--- linux-2.6.25-rc8/include/acpi/actables.h	2007-04-26 05:08:32.000000000 +0200
+++ 2.6.25-rc8-acpi-tbfadt-init/include/acpi/actables.h	2008-04-02 08:53:31.000000000 +0200
@@ -51,8 +51,6 @@ acpi_status acpi_allocate_root_table(u32
  */
 void acpi_tb_parse_fadt(acpi_native_uint table_index, u8 flags);
 
-void acpi_tb_create_local_fadt(struct acpi_table_header *table, u32 length);
-
 /*
  * tbfind - find ACPI table
  */




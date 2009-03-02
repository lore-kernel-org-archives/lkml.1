Return-Path: <linux-kernel-owner+w=401wt.eu-S1759612AbZCBKUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759612AbZCBKUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 05:20:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757552AbZCBKTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 05:19:35 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:58984 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757140AbZCBKTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 05:19:34 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: mingo@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/3] x86_32: apic/es7000_32, fix section mismatch
Date: Mon,  2 Mar 2009 11:18:52 +0100
Message-Id: <1235989134-29146-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove __init section placement for some functions, so that we don't
get section mismatch warnings.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/apic/es7000_32.c |   32 +++++++++++++++-----------------
 1 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 4d8830f..67947b6 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -173,7 +173,7 @@ static int __init es7000_apic_is_cluster(void)
 	return 0;
 }
 
-static void __init setup_unisys(void)
+static void setup_unisys(void)
 {
 	/*
 	 * Determine the generation of the ES7000 currently running.
@@ -192,7 +192,7 @@ static void __init setup_unisys(void)
 /*
  * Parse the OEM Table:
  */
-static int __init parse_unisys_oem(char *oemptr)
+static int parse_unisys_oem(char *oemptr)
 {
 	int			i;
 	int 			success = 0;
@@ -254,7 +254,7 @@ static int __init parse_unisys_oem(char *oemptr)
 }
 
 #ifdef CONFIG_ACPI
-static int __init find_unisys_acpi_oem_table(unsigned long *oem_addr)
+static int find_unisys_acpi_oem_table(unsigned long *oem_addr)
 {
 	struct acpi_table_header *header = NULL;
 	struct es7000_oem_table *table;
@@ -285,7 +285,7 @@ static int __init find_unisys_acpi_oem_table(unsigned long *oem_addr)
 	return 0;
 }
 
-static void __init unmap_unisys_acpi_oem_table(unsigned long oem_addr)
+static void unmap_unisys_acpi_oem_table(unsigned long oem_addr)
 {
 	if (!oem_addr)
 		return;
@@ -303,10 +303,10 @@ static int es7000_check_dsdt(void)
 	return 0;
 }
 
-static int __initdata es7000_acpi_ret;
+static int es7000_acpi_ret;
 
 /* Hook from generic ACPI tables.c */
-static int __init es7000_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+static int es7000_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	unsigned long oem_addr = 0;
 	int check_dsdt;
@@ -333,8 +333,7 @@ static int __init es7000_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	return ret && !es7000_apic_is_cluster();
 }
 
-static int __init
-es7000_acpi_madt_oem_check_cluster(char *oem_id, char *oem_table_id)
+static int es7000_acpi_madt_oem_check_cluster(char *oem_id, char *oem_table_id)
 {
 	int ret = es7000_acpi_ret;
 
@@ -342,13 +341,12 @@ es7000_acpi_madt_oem_check_cluster(char *oem_id, char *oem_table_id)
 }
 
 #else /* !CONFIG_ACPI: */
-static int __init es7000_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+static int es7000_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	return 0;
 }
 
-static int __init
-es7000_acpi_madt_oem_check_cluster(char *oem_id, char *oem_table_id)
+static int es7000_acpi_madt_oem_check_cluster(char *oem_id, char *oem_table_id)
 {
 	return 0;
 }
@@ -396,7 +394,7 @@ es7000_mip_write(struct mip_reg *mip_reg)
 	return status;
 }
 
-static void __init es7000_enable_apic_mode(void)
+static void es7000_enable_apic_mode(void)
 {
 	struct mip_reg es7000_mip_reg;
 	int mip_status;
@@ -627,9 +625,9 @@ static int probe_es7000(void)
 	return 0;
 }
 
-static int __initdata es7000_mps_ret;
-static __init int
-es7000_mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
+static int es7000_mps_ret;
+static int es7000_mps_oem_check(struct mpc_table *mpc, char *oem,
+		char *productid)
 {
 	int ret = 0;
 
@@ -646,8 +644,8 @@ es7000_mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
 	return ret && !es7000_apic_is_cluster();
 }
 
-static __init int
-es7000_mps_oem_check_cluster(struct mpc_table *mpc, char *oem, char *productid)
+static int es7000_mps_oem_check_cluster(struct mpc_table *mpc, char *oem,
+		char *productid)
 {
 	int ret = es7000_mps_ret;
 
-- 
1.6.1.3


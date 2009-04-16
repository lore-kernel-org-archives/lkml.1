Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbZDPUu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbZDPUu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 16:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753606AbZDPUuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 16:50:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:40259 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473AbZDPUuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 16:50:04 -0400
Subject: [PATCH-tip] x86: apic/es7000_32.c find_unisys_acpi_oem_table and
 es7000_acpi_madt_oem_check should use __init
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 17 Apr 2009 02:19:34 +0530
Message-Id: <1239914974.10567.15.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix sections mismatch warnings
 WARNING: arch/x86/built-in.o(.text+0x65e67): Section mismatch in reference from the function find_unisys_acpi_oem_table() to the function .init.text:__acpi_map_table()
 The function find_unisys_acpi_oem_table() references
 the function __init __acpi_map_table().
 This is often because find_unisys_acpi_oem_table lacks a __init
 annotation or the annotation of __acpi_map_table is wrong.

 WARNING: arch/x86/built-in.o(.text+0x65f98): Section mismatch in reference from the function es7000_acpi_madt_oem_check() to the function .init.text:__acpi_unmap_table()
 The function es7000_acpi_madt_oem_check() references
 the function __init __acpi_unmap_table().
 This is often because es7000_acpi_madt_oem_check lacks a __init
 annotation or the annotation of __acpi_unmap_table is wrong.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/apic/es7000_32.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 1c11b81..a7a7bbe 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -254,7 +254,7 @@ static int parse_unisys_oem(char *oemptr)
 }
 
 #ifdef CONFIG_ACPI
-static int find_unisys_acpi_oem_table(unsigned long *oem_addr)
+static int __init find_unisys_acpi_oem_table(unsigned long *oem_addr)
 {
 	struct acpi_table_header *header = NULL;
 	struct es7000_oem_table *table;
@@ -306,7 +306,7 @@ static int es7000_check_dsdt(void)
 static int es7000_acpi_ret;
 
 /* Hook from generic ACPI tables.c */
-static int es7000_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+static int __init es7000_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	unsigned long oem_addr = 0;
 	int check_dsdt;
@@ -717,7 +717,7 @@ struct apic apic_es7000_cluster = {
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
 };
 
-struct apic apic_es7000 = {
+struct apic __initdata apic_es7000 = {
 
 	.name				= "es7000",
 	.probe				= probe_es7000,
-- 
1.6.0.6




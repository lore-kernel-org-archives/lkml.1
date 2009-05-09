Return-Path: <linux-kernel-owner+w=401wt.eu-S1754909AbZEIJf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbZEIJf1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 05:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbZEIJfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 05:35:12 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:58711 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbZEIJfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 05:35:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dWYjye1d/Kqcpl+QBoKgeNGCl9/KRyU2eOi8FG/9PimH+Aqa3beOuAx8g5RLcjOM9Z
         lna63aFNX5Z1bAh8BevRyh4E/ehldLepC34RL/zZKrTLSR0+cerx9dF9RuYmh0WbWRhN
         th49IC1Rn3rXC3mUSccOOiIRp1zkOQp/20WC8=
MIME-Version: 1.0
Date: Sat, 9 May 2009 15:35:10 +0600
Message-ID: <b9df5fa10905090235s4bfd26a8o979f93809c9727ad@mail.gmail.com>
Subject: [PATCH] x86: Fix false positive section mismatch in apic.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Sorry guys , for being late. My system was out of order for a week.


 x86: Fix false positive section mismatch warnings in the apic code

----
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linus/arch/x86/kernel/apic/es7000_32.c	2009-05-08 07:03:07.000000000 +0600
+++ rakib/arch/x86/kernel/apic/es7000_32.c	2009-05-07 20:38:06.000000000 +0600
@@ -254,7 +254,7 @@ static int parse_unisys_oem(char *oemptr
 }

 #ifdef CONFIG_ACPI
-static int find_unisys_acpi_oem_table(unsigned long *oem_addr)
+static int __init find_unisys_acpi_oem_table(unsigned long *oem_addr)
 {
 	struct acpi_table_header *header = NULL;
 	struct es7000_oem_table *table;
@@ -285,7 +285,7 @@ static int find_unisys_acpi_oem_table(un
 	return 0;
 }

-static void unmap_unisys_acpi_oem_table(unsigned long oem_addr)
+static void __init unmap_unisys_acpi_oem_table(unsigned long oem_addr)
 {
 	if (!oem_addr)
 		return;
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
+struct apic __refdata apic_es7000 = {

 	.name				= "es7000",
 	.probe				= probe_es7000,

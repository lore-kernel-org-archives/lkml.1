Return-Path: <linux-kernel-owner+w=401wt.eu-S1760655AbXLMIdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760655AbXLMIdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 03:33:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbXLMId2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 03:33:28 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:29007
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753288AbXLMId1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 03:33:27 -0500
Message-Id: <4760FC87.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 13 Dec 2007 08:33:59 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <len.brown@intel.com>
Cc: "linux-acpi" <linux-acpi@intel.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] acpi: make __acpi_map_table() and __init function
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.. as it it used only during early boot.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 arch/ia64/kernel/acpi.c     |    2 +-
 arch/x86/kernel/acpi/boot.c |    4 ++--
 drivers/acpi/osl.c          |    3 ++-
 3 files changed, 5 insertions(+), 4 deletions(-)

--- linux-2.6.24-rc5/arch/ia64/kernel/acpi.c	2007-12-12 11:28:03.000000000 +0100
+++ 2.6.24-rc5-acpi-map-table-init/arch/ia64/kernel/acpi.c	2007-12-04 16:09:33.000000000 +0100
@@ -152,7 +152,7 @@ int acpi_request_vector(u32 int_type)
 	return vector;
 }
 
-char *__acpi_map_table(unsigned long phys_addr, unsigned long size)
+char *__init __acpi_map_table(unsigned long phys_addr, unsigned long size)
 {
 	return __va(phys_addr);
 }
--- linux-2.6.24-rc5/arch/x86/kernel/acpi/boot.c	2007-12-12 11:28:17.000000000 +0100
+++ 2.6.24-rc5-acpi-map-table-init/arch/x86/kernel/acpi/boot.c	2007-12-04 16:09:33.000000000 +0100
@@ -106,7 +106,7 @@ enum acpi_irq_model_id acpi_irq_model = 
 #ifdef	CONFIG_X86_64
 
 /* rely on all ACPI tables being in the direct mapping */
-char *__acpi_map_table(unsigned long phys_addr, unsigned long size)
+char *__init __acpi_map_table(unsigned long phys_addr, unsigned long size)
 {
 	if (!phys_addr || !size)
 		return NULL;
@@ -131,7 +131,7 @@ char *__acpi_map_table(unsigned long phy
  * from the fixed base.  That's why we start at FIX_IO_APIC_BASE_END and
  * count idx down while incrementing the phys address.
  */
-char *__acpi_map_table(unsigned long phys, unsigned long size)
+char *__init __acpi_map_table(unsigned long phys, unsigned long size)
 {
 	unsigned long base, offset, mapped_size;
 	int idx;
--- linux-2.6.24-rc5/drivers/acpi/osl.c	2007-12-12 11:28:21.000000000 +0100
+++ 2.6.24-rc5-acpi-map-table-init/drivers/acpi/osl.c	2007-12-04 16:09:33.000000000 +0100
@@ -211,7 +211,8 @@ acpi_physical_address __init acpi_os_get
 		return acpi_find_rsdp();
 }
 
-void __iomem *acpi_os_map_memory(acpi_physical_address phys, acpi_size size)
+void __iomem *__init_refok
+acpi_os_map_memory(acpi_physical_address phys, acpi_size size)
 {
 	if (phys > ULONG_MAX) {
 		printk(KERN_ERR PREFIX "Cannot map memory that high\n");




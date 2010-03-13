Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936295Ab0CMBMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:12:20 -0500
Received: from kroah.org ([198.145.64.141]:46669 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935344Ab0CMAas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:30:48 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:06 2010
Message-Id: <20100313002706.823730568@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:25:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Len Brown <len.brown@intel.com>
Subject: [018/145] ACPI: fix "acpi=ht" boot option
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Len Brown <len.brown@intel.com>

commit 49bf83a45fc677db1ed44d0e072e6aaeabe4e124 upstream.

We broke "acpi=ht" in 2.6.32 by disabling MADT parsing
for acpi=disabled.  e5b8fc6ac158f65598f58dba2c0d52ba3b412f52
This also broke systems which invoked acpi=ht via DMI blacklist.

acpi=ht is a really ugly hack,
but restore it for those that still use it.

http://bugzilla.kernel.org/show_bug.cgi?id=14886

Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/ia64/include/asm/acpi.h |    1 +
 drivers/acpi/tables.c        |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/arch/ia64/include/asm/acpi.h
+++ b/arch/ia64/include/asm/acpi.h
@@ -94,6 +94,7 @@ ia64_acpi_release_global_lock (unsigned
 #define acpi_noirq 0	/* ACPI always enabled on IA64 */
 #define acpi_pci_disabled 0 /* ACPI PCI always enabled on IA64 */
 #define acpi_strict 1	/* no ACPI spec workarounds on IA64 */
+#define acpi_ht 0	/* no HT-only mode on IA64 */
 #endif
 #define acpi_processor_cstate_check(x) (x) /* no idle limits on IA64 :) */
 static inline void disable_acpi(void) { }
--- a/drivers/acpi/tables.c
+++ b/drivers/acpi/tables.c
@@ -213,7 +213,7 @@ acpi_table_parse_entries(char *id,
 	unsigned long table_end;
 	acpi_size tbl_size;
 
-	if (acpi_disabled)
+	if (acpi_disabled && !acpi_ht)
 		return -ENODEV;
 
 	if (!handler)
@@ -280,7 +280,7 @@ int __init acpi_table_parse(char *id, ac
 	struct acpi_table_header *table = NULL;
 	acpi_size tbl_size;
 
-	if (acpi_disabled)
+	if (acpi_disabled && !acpi_ht)
 		return -ENODEV;
 
 	if (!handler)



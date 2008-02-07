Return-Path: <linux-kernel-owner+w=401wt.eu-S934196AbYBGVDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934196AbYBGVDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762572AbYBGUw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:52:27 -0500
Received: from mail.suse.de ([195.135.220.2]:45692 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932768AbYBGUwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:52:24 -0500
Date: Thu, 7 Feb 2008 12:47:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Len Brown <len.brown@intel.com>
Subject: [patch 27/45] ACPI: update ACPI blacklist
Message-ID: <20080207204742.GB16389@suse.de>
References: <20080207204118.202098927@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-update-acpi-blacklist.patch"
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Len Brown <len.brown@intel.com>

These minor changes sync the latest ACPI blacklist into 2.6.24.
The main benefit of this patch is to make any future
changes easier to apply.  The immediate benefit is one less
dmesg line on Acer systems.

Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/blacklist.c    |   23 ++++++++++++++---------
 drivers/acpi/osl.c          |   16 ++++++++--------
 drivers/firmware/dmi_scan.c |    9 ---------
 include/linux/dmi.h         |    2 --
 4 files changed, 22 insertions(+), 28 deletions(-)

--- a/drivers/acpi/blacklist.c
+++ b/drivers/acpi/blacklist.c
@@ -208,24 +208,24 @@ static struct dmi_system_id acpi_osi_dmi
 	 * Disable OSI(Linux) warnings on all "Acer, inc."
 	 *
 	 * _OSI(Linux) disables the latest Windows BIOS code:
+	 * DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 3100"),
 	 * DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5050"),
+	 * DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5100"),
 	 * DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5580"),
 	 * DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 3010"),
 	 * _OSI(Linux) effect unknown:
 	 * DMI_MATCH(DMI_PRODUCT_NAME, "Ferrari 5000"),
 	 */
-	{
-	.callback = dmi_disable_osi_linux,
-	.ident = "Acer, inc.",
-	.matches = {
-		     DMI_MATCH(DMI_SYS_VENDOR, "Acer, inc."),
-		},
-	},
+	/*
+	 * note that dmi_check_system() uses strstr()
+	 * to match sub-strings rather than !strcmp(),
+	 * so "Acer" below matches "Acer, inc." above.
+	 */
 	/*
 	 * Disable OSI(Linux) warnings on all "Acer"
 	 *
 	 * _OSI(Linux) effect unknown:
-	 * DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5100"),
+	 * DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5315"),
 	 * DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5610"),
 	 * DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 7720Z"),
 	 * DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 5520"),
@@ -300,7 +300,7 @@ static struct dmi_system_id acpi_osi_dmi
 		     DMI_MATCH(DMI_BIOS_VENDOR, "COMPAL"),
 		},
 	},
-	{ /* OSI(Linux) touches USB, breaks suspend to disk */
+	{ /* OSI(Linux) touches USB, unknown side-effect */
 	.callback = dmi_disable_osi_linux,
 	.ident = "Dell Dimension 5150",
 	.matches = {
@@ -474,6 +474,11 @@ static struct dmi_system_id acpi_osi_dmi
 	 *
 	 * _OSI(Linux) confirmed to be a NOP:
 	 * DMI_MATCH(DMI_PRODUCT_NAME, "P1-J150B"),
+	 * with DMI_MATCH(DMI_BOARD_NAME, "ROCKY"),
+	 *
+	 * unknown:
+	 * DMI_MATCH(DMI_PRODUCT_NAME, "S1-MDGDG"),
+	 * with DMI_MATCH(DMI_BOARD_NAME, "ROCKY"),
 	 */
 	{
 	.callback = dmi_disable_osi_linux,
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -120,7 +120,7 @@ static char osi_additional_string[OSI_ST
  */
 #define OSI_LINUX_ENABLE 0
 
-struct osi_linux {
+static struct osi_linux {
 	unsigned int	enable:1;
 	unsigned int	dmi:1;
 	unsigned int	cmdline:1;
@@ -1213,24 +1213,24 @@ acpi_status acpi_os_release_object(acpi_
  *
  *	Returns 0 on success
  */
-int acpi_dmi_dump(void)
+static int acpi_dmi_dump(void)
 {
 
 	if (!dmi_available)
 		return -1;
 
 	printk(KERN_NOTICE PREFIX "DMI System Vendor: %s\n",
-		dmi_get_slot(DMI_SYS_VENDOR));
+		dmi_get_system_info(DMI_SYS_VENDOR));
 	printk(KERN_NOTICE PREFIX "DMI Product Name: %s\n",
-		dmi_get_slot(DMI_PRODUCT_NAME));
+		dmi_get_system_info(DMI_PRODUCT_NAME));
 	printk(KERN_NOTICE PREFIX "DMI Product Version: %s\n",
-		dmi_get_slot(DMI_PRODUCT_VERSION));
+		dmi_get_system_info(DMI_PRODUCT_VERSION));
 	printk(KERN_NOTICE PREFIX "DMI Board Name: %s\n",
-		dmi_get_slot(DMI_BOARD_NAME));
+		dmi_get_system_info(DMI_BOARD_NAME));
 	printk(KERN_NOTICE PREFIX "DMI BIOS Vendor: %s\n",
-		dmi_get_slot(DMI_BIOS_VENDOR));
+		dmi_get_system_info(DMI_BIOS_VENDOR));
 	printk(KERN_NOTICE PREFIX "DMI BIOS Date: %s\n",
-		dmi_get_slot(DMI_BIOS_DATE));
+		dmi_get_system_info(DMI_BIOS_DATE));
 
 	return 0;
 }
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -469,12 +469,3 @@ int dmi_get_year(int field)
 
 	return year;
 }
-
-/**
- *	dmi_get_slot - return dmi_ident[slot]
- *	@slot:	index into dmi_ident[]
- */
-char *dmi_get_slot(int slot)
-{
-	return(dmi_ident[slot]);
-}
--- a/include/linux/dmi.h
+++ b/include/linux/dmi.h
@@ -79,7 +79,6 @@ extern void dmi_scan_machine(void);
 extern int dmi_get_year(int field);
 extern int dmi_name_in_vendors(const char *str);
 extern int dmi_available;
-extern char *dmi_get_slot(int slot);
 
 #else
 
@@ -90,7 +89,6 @@ static inline const struct dmi_device * 
 static inline int dmi_get_year(int year) { return 0; }
 static inline int dmi_name_in_vendors(const char *s) { return 0; }
 #define dmi_available 0
-static inline char *dmi_get_slot(int slot) { return NULL; }
 
 #endif
 

-- 

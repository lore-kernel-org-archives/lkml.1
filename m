Return-Path: <linux-kernel-owner+w=401wt.eu-S1758789AbYLKTrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789AbYLKTrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:47:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757950AbYLKTTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:19:37 -0500
Received: from kroah.org ([198.145.64.141]:56863 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757943AbYLKTTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:19:36 -0500
Date: Thu, 11 Dec 2008 11:16:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Len Brown <len.brown@intel.com>
Subject: [patch 81/83] ACPI: delete OSI(Linux) DMI dmesg spam
Message-ID: <20081211191652.GC5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-delete-osi-dmi-dmesg-spam.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Len Brown <lenb@kernel.org>

With the 2.6.28 commit a6e0887f21bbab337ee32d9c0a84d7c0b6e9141b, we now
have fixed up the ACPI DMI code, so stop asking for people to report the
issues to the acpi developers, it is no longer needed at all.

Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/osl.c |   36 ------------------------------------
 1 file changed, 36 deletions(-)

--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -1261,34 +1261,6 @@ acpi_status acpi_os_release_object(acpi_
 	return (AE_OK);
 }
 
-/**
- *	acpi_dmi_dump - dump DMI slots needed for blacklist entry
- *
- *	Returns 0 on success
- */
-static int acpi_dmi_dump(void)
-{
-
-	if (!dmi_available)
-		return -1;
-
-	printk(KERN_NOTICE PREFIX "DMI System Vendor: %s\n",
-		dmi_get_system_info(DMI_SYS_VENDOR));
-	printk(KERN_NOTICE PREFIX "DMI Product Name: %s\n",
-		dmi_get_system_info(DMI_PRODUCT_NAME));
-	printk(KERN_NOTICE PREFIX "DMI Product Version: %s\n",
-		dmi_get_system_info(DMI_PRODUCT_VERSION));
-	printk(KERN_NOTICE PREFIX "DMI Board Name: %s\n",
-		dmi_get_system_info(DMI_BOARD_NAME));
-	printk(KERN_NOTICE PREFIX "DMI BIOS Vendor: %s\n",
-		dmi_get_system_info(DMI_BIOS_VENDOR));
-	printk(KERN_NOTICE PREFIX "DMI BIOS Date: %s\n",
-		dmi_get_system_info(DMI_BIOS_DATE));
-
-	return 0;
-}
-
-
 /******************************************************************************
  *
  * FUNCTION:    acpi_os_validate_interface
@@ -1315,14 +1287,6 @@ acpi_os_validate_interface (char *interf
 			osi_linux.cmdline ? " via cmdline" :
 			osi_linux.dmi ? " via DMI" : "");
 
-		if (!osi_linux.dmi) {
-			if (acpi_dmi_dump())
-				printk(KERN_NOTICE PREFIX
-					"[please extract dmidecode output]\n");
-			printk(KERN_NOTICE PREFIX
-				"Please send DMI info above to "
-				"linux-acpi@vger.kernel.org\n");
-		}
 		if (!osi_linux.known && !osi_linux.cmdline) {
 			printk(KERN_NOTICE PREFIX
 				"If \"acpi_osi=%sLinux\" works better, "


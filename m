Return-Path: <linux-kernel-owner+w=401wt.eu-S1761468AbYBVTf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761468AbYBVTf1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 14:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756429AbYBVTfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 14:35:13 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:44777 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755454AbYBVTfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 14:35:11 -0500
Date: Fri, 22 Feb 2008 11:25:04 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Nish Aravamudan <nish.aravamudan@gmail.com>, Len Brown <lenb@kernel.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH] [BUILD_FAILURE] 2.6.25-rc2-mm1 - Build Failure at acpi_os
Message-Id: <20080222112504.04e6b6a9.randy.dunlap@oracle.com>
In-Reply-To: <20080222185648.GA6843@uranus.ravnborg.org>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
	<47B73DD8.4030405@linux.vnet.ibm.com>
	<200802210208.47487.lenb@kernel.org>
	<29495f1d0802211054s26665d3cy1609d3347867cb16@mail.gmail.com>
	<20080221222245.GB30976@uranus.ravnborg.org>
	<29495f1d0802211738leb47f9ayf9b3ab6aa51b66cb@mail.gmail.com>
	<20080222180815.GB6434@uranus.ravnborg.org>
	<20080222101344.821ea02a.randy.dunlap@oracle.com>
	<20080222182737.GC6434@uranus.ravnborg.org>
	<47BF1492.20901@oracle.com>
	<20080222185648.GA6843@uranus.ravnborg.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's see what the ACPI people think about this change.

Thanks, Sam.
---
From: Randy Dunlap <randy.dunlap@oracle.com>

Make ACPI_CUSTOM_DSDT boolean config symbol a hidden and derived
value, based on the value of ACPI_CUSTOM_DSDT_FILE (string).
Only the latter is presented to the user as a config option.

This fixes problems with "make randconfig" setting ACPI_CUSTOM_DSDT
but leaving ACPI_CUSTOM_DSDT_FILE empty/blank.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/acpi/Kconfig |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- linux-2.6.25-rc2-git5.orig/drivers/acpi/Kconfig
+++ linux-2.6.25-rc2-git5/drivers/acpi/Kconfig
@@ -283,24 +283,23 @@ config ACPI_TOSHIBA
 	  If you have a legacy free Toshiba laptop (such as the Libretto L1
 	  series), say Y.
 
-config ACPI_CUSTOM_DSDT
-	bool "Include Custom DSDT"
+config ACPI_CUSTOM_DSDT_FILE
+	string "Custom DSDT Table file to include"
+	default ""
 	depends on !STANDALONE
-	default n 
 	help
 	  This option supports a custom DSDT by linking it into the kernel.
 	  See Documentation/acpi/dsdt-override.txt
 
-	  If unsure, say N.
-
-config ACPI_CUSTOM_DSDT_FILE
-	string "Custom DSDT Table file to include"
-	depends on ACPI_CUSTOM_DSDT
-	default ""
-	help
 	  Enter the full path name to the file which includes the AmlCode
 	  declaration.
 
+	  If unsure, don't enter a file name.
+
+config ACPI_CUSTOM_DSDT
+	bool
+	default ACPI_CUSTOM_DSDT_FILE != ""
+
 config ACPI_CUSTOM_DSDT_INITRD
 	bool "Read Custom DSDT from initramfs"
 	depends on BLK_DEV_INITRD

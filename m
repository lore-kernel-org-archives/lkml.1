Return-Path: <linux-kernel-owner+w=401wt.eu-S1031517AbXD3L4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031517AbXD3L4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 07:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031525AbXD3L4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 07:56:20 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:60316 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031517AbXD3L4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 07:56:18 -0400
Date: Mon, 30 Apr 2007 13:53:44 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Kylene Hall <kjhall@us.ibm.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Marcel Selhorst <tpm@selhorst.net>, tpmdd-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 30/36] Use menuconfig objects II - TPM
In-Reply-To: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704301353170.29151@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Change Kconfig objects from "menu, config" into "menuconfig" so
that the user can disable the whole feature without having to
enter the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 drivers/char/tpm/Kconfig |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- linux-2.6.21-mm_20070428.orig/drivers/char/tpm/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/char/tpm/Kconfig
@@ -2,9 +2,7 @@
 # TPM device configuration
 #
 
-menu "TPM devices"
-
-config TCG_TPM
+menuconfig TCG_TPM
 	tristate "TPM Hardware Support"
 	depends on EXPERIMENTAL
 	---help---
@@ -20,9 +18,11 @@ config TCG_TPM
 	  Note: For more TPM drivers enable CONFIG_PNP, CONFIG_ACPI
 	  and CONFIG_PNPACPI.
 
+if TCG_TPM
+
 config TCG_TIS
 	tristate "TPM Interface Specification 1.2 Interface"
-	depends on TCG_TPM && PNPACPI
+	depends on PNPACPI
 	---help---
 	  If you have a TPM security chip that is compliant with the
 	  TCG TIS 1.2 TPM specification say Yes and it will be accessible
@@ -31,7 +31,7 @@ config TCG_TIS
 
 config TCG_NSC
 	tristate "National Semiconductor TPM Interface"
-	depends on TCG_TPM && PNPACPI
+	depends on PNPACPI
 	---help---
 	  If you have a TPM security chip from National Semicondutor 
 	  say Yes and it will be accessible from within Linux.  To 
@@ -40,7 +40,6 @@ config TCG_NSC
 
 config TCG_ATMEL
 	tristate "Atmel TPM Interface"
-	depends on TCG_TPM
 	---help---
 	  If you have a TPM security chip from Atmel say Yes and it 
 	  will be accessible from within Linux.  To compile this driver 
@@ -48,7 +47,7 @@ config TCG_ATMEL
 
 config TCG_INFINEON
 	tristate "Infineon Technologies TPM Interface"
-	depends on TCG_TPM && PNPACPI
+	depends on PNPACPI
 	---help---
 	  If you have a TPM security chip from Infineon Technologies
 	  (either SLD 9630 TT 1.1 or SLB 9635 TT 1.2) say Yes and it
@@ -58,5 +57,4 @@ config TCG_INFINEON
 	  Further information on this driver and the supported hardware
 	  can be found at http://www.prosec.rub.de/tpm
 
-endmenu
-
+endif # TCG_TPM

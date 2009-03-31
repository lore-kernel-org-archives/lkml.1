Return-Path: <linux-kernel-owner+w=401wt.eu-S1763731AbZCaVsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763731AbZCaVsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 17:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763717AbZCaVr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 17:47:56 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:46152 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763050AbZCaVrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 17:47:55 -0400
Date: Tue, 31 Mar 2009 22:47:49 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-acpi@vger.kernel.org
Cc: dsilvers@simtec.co.uk, toshiba_acpi@memebeam.org,
       linux-kernel@vger.kernel.org, lenb@intel.com
Subject: [PATCH 2/2] toshiba-acpi: Support TOS1900-type devices
Message-ID: <20090331214749.GD29489@srcf.ucam.org>
References: <20090331214501.GC29489@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090331214501.GC29489@srcf.ucam.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Despite toshiba_acpi exporting TOS1900 as a modalias, it doesn't appear to
support these machines. They have their HCI method implemented in a
different but compatible manner and so need a different method address.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/platform/x86/toshiba_acpi.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index fb87b57..9fb4873 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -67,6 +67,7 @@ MODULE_LICENSE("GPL");
 #define TOSH_INTERFACE_2	"\\_SB_.VALZ"
 #define METHOD_VIDEO_OUT	"\\_SB_.VALX.DSSX"
 #define GHCI_METHOD		".GHCI"
+#define SPFC_METHOD		".SPFC"
 
 /* Toshiba HCI interface definitions
  *
@@ -935,6 +936,10 @@ static int __init toshiba_acpi_init(void)
 		method_hci = TOSH_INTERFACE_2 GHCI_METHOD;
 		if (toshiba_acpi_setup_keyboard(TOSH_INTERFACE_2))
 			printk(MY_INFO "Unable to activate hotkeys\n");
+	} else if (is_valid_acpi_path(TOSH_INTERFACE_2 SPFC_METHOD)) {
+		method_hci = TOSH_INTERFACE_2 SPFC_METHOD;
+		if (toshiba_acpi_setup_keyboard(TOSH_INTERFACE_2))
+			printk(MY_INFO "Unable to activate hotkeys\n");
 	} else
 		return -ENODEV;
 
-- 
Matthew Garrett | mjg59@srcf.ucam.org

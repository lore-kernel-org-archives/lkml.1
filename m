Return-Path: <linux-kernel-owner+w=401wt.eu-S1751978AbZHQMvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbZHQMvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 08:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbZHQMvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 08:51:45 -0400
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:54656 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751286AbZHQMvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 08:51:44 -0400
To: linux-acpi@vger.kernel.org
Subject: [PATCH,resend] acpi processor: simplify needlessly complex printk
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Content-Disposition: inline
From: Frans Pop <elendil@planet.nl>
Date: Mon, 17 Aug 2009 14:51:43 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908171451.44732.elendil@planet.nl>
X-OriginalArrivalTime: 17 Aug 2009 12:51:45.0233 (UTC) FILETIME=[79E81410:01CA1F39]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why use three printk statements if one will do?
Also makes it easier to grep for the string.

Signed-off-by: Frans Pop <elendil@planet.nl>

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 84e0f3c..b8fb74a 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -772,12 +772,11 @@ static int __cpuinit acpi_processor_start(struct acpi_device *device)
 	if (result)
 		printk(KERN_ERR PREFIX "Create sysfs link\n");
 
-	if (pr->flags.throttling) {
-		printk(KERN_INFO PREFIX "%s [%s] (supports",
-		       acpi_device_name(device), acpi_device_bid(device));
-		printk(" %d throttling states", pr->throttling.state_count);
-		printk(")\n");
-	}
+	if (pr->flags.throttling)
+		printk(KERN_INFO PREFIX
+			"%s [%s] (supports %d throttling states)\n",
+			acpi_device_name(device), acpi_device_bid(device),
+			pr->throttling.state_count);
 
       end:
 

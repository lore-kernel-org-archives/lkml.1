Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbZF1UEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbZF1UEH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 16:04:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbZF1UDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 16:03:54 -0400
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:58279 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751519AbZF1UDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 16:03:54 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-acpi@vger.kernel.org
Subject: [PATCH] acpi processor: simplify needlessly complex printk
Date: Sun, 28 Jun 2009 22:03:54 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906282203.55643.elendil@planet.nl>
X-OriginalArrivalTime: 28 Jun 2009 20:03:56.0382 (UTC) FILETIME=[916BE7E0:01C9F82B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why use three printk statements if one will do?

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
 

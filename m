Return-Path: <linux-kernel-owner+w=401wt.eu-S1762629AbXHaFGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762629AbXHaFGA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 01:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbXHaFFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 01:05:53 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:52852 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751059AbXHaFFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 01:05:52 -0400
Message-ID: <46D7A196.7070309@suse.de>
Date: Fri, 31 Aug 2007 09:05:26 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Daniel Ritz <daniel.ritz-ml@swissonline.ch>,
       Luca Tettamanti <kronos.it@gmail.com>, linux-kernel@vger.kernel.org,
       Len Brown <len.brown@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ACPI: EC: Check if boot_ec was really found in DSDT
References: <200708290129.57243.daniel.ritz-ml@swissonline.ch> <20070829232150.GA17467@dreamland.darkstar.lan> <200708301907.56561.daniel.ritz-ml@swissonline.ch> <alpine.LFD.0.999.0708301020410.25853@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0708301020410.25853@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Starikovskiy <astarikovskiy@suse.de>

acpi_get_devices() returns success if it did not find any device.
We have to check for this case.

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
---

 drivers/acpi/ec.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 43749c8..3f7935a 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -886,7 +886,8 @@ int __init acpi_ec_ecdt_probe(void)
         printk(KERN_DEBUG PREFIX "Look up EC in DSDT\n");
         status = acpi_get_devices(ec_device_ids[0].id, ec_parse_device,
                         boot_ec, NULL);
-        if (ACPI_FAILURE(status))
+        /* Check that acpi_get_devices actually find something */
+        if (ACPI_FAILURE(status) || !boot_ec->handle)
             goto error;
     }
 


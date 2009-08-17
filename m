Return-Path: <linux-kernel-owner+w=401wt.eu-S1756582AbZHQAXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbZHQAXa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 20:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756547AbZHQAX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 20:23:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46003 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755634AbZHQAWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 20:22:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "linux-pm" <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 6/7] PM: Asynchronous suspend and resume of ACPI devices
Date: Mon, 17 Aug 2009 02:20:54 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: "linux-acpi" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>, Greg KH <gregkh@suse.de>
References: <200908122218.13975.rjw@sisk.pl> <200908170215.21173.rjw@sisk.pl>
In-Reply-To: <200908170215.21173.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908170220.54253.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set async_suspend for all ACPI devices.

---
 drivers/acpi/scan.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/drivers/acpi/scan.c
===================================================================
--- linux-2.6.orig/drivers/acpi/scan.c
+++ linux-2.6/drivers/acpi/scan.c
@@ -539,6 +539,7 @@ static int acpi_device_register(struct a
 		       dev_name(&device->dev));
 
 	device->removal_type = ACPI_BUS_REMOVAL_NORMAL;
+	device_enable_async_suspend(&device->dev, true);
 	return 0;
 end:
 	mutex_lock(&acpi_device_lock);

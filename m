Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbZHLUWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbZHLUWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 16:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754679AbZHLUWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 16:22:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59779 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060AbZHLUVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 16:21:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "linux-pm" <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 3/3] PM: Asynchronous suspend and resume for ACPI battery
Date: Wed, 12 Aug 2009 22:22:02 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: "linux-acpi" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>
References: <200908122218.13975.rjw@sisk.pl>
In-Reply-To: <200908122218.13975.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908122222.02315.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the ACPI battery device to be resumed and suspended
asynchronously.

This only means that the driver's suspend and resume callbacks may
be executed in parallel with the callbacks of devices that don't
directly depend on the battery device (i.e. that are not its parent
or children).

Index: linux-2.6/drivers/acpi/battery.c
===================================================================
--- linux-2.6.orig/drivers/acpi/battery.c
+++ linux-2.6/drivers/acpi/battery.c
@@ -837,6 +837,7 @@ static int acpi_battery_add(struct acpi_
 		printk(KERN_INFO PREFIX "%s Slot [%s] (battery %s)\n",
 			ACPI_BATTERY_DEVICE_NAME, acpi_device_bid(device),
 			device->status.battery_present ? "present" : "absent");
+		device_enable_async_suspend(&device->dev, true);
 	} else {
 #ifdef CONFIG_ACPI_PROCFS_POWER
 		acpi_battery_remove_fs(device);

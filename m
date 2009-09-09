Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbZIIXnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbZIIXnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 19:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754582AbZIIXn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 19:43:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35995 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562AbZIIXl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 19:41:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "linux-pm" <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 5/9] PM: Allow ACPI devices to suspend/resume asynchronously
Date: Thu, 10 Sep 2009 01:37:38 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc9-rjw; KDE/4.3.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>
References: <200909100127.11252.rjw@sisk.pl>
In-Reply-To: <200909100127.11252.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909100137.38335.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Set async_suspend for all ACPI devices, so that they can be suspended
and resumed asynchronously with other devices they don't depend on in
a known way (i.e. devices which are not their parents or children and
to which they are not connected via struct pm_link objects).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
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

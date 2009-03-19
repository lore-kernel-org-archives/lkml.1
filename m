Return-Path: <linux-kernel-owner+w=401wt.eu-S1758711AbZCSXHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711AbZCSXHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 19:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbZCSXHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 19:07:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42818 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754801AbZCSXHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 19:07:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <htejun@gmail.com>
Subject: [PATCH] ahci: Blacklist HP Compaq 6720s that spins off disks during ACPI power off
Date: Fri, 20 Mar 2009 00:06:46 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-tst; KDE/4.2.1; x86_64; ; )
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903200006.46859.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maciej Rutecki <maciej.rutecki@gmail.com>

Blacklist HP Compaq 6720s so that it doesn't play a "spin down,
spin up, spin down" ping-pong with the hard disk during system
power off.

Signed-off-by: Maciej Rutecki <maciej.rutecki@gmail.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
---
 drivers/ata/ahci.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-2.6/drivers/ata/ahci.c
===================================================================
--- linux-2.6.orig/drivers/ata/ahci.c
+++ linux-2.6/drivers/ata/ahci.c
@@ -2565,6 +2565,15 @@ static bool ahci_broken_system_poweroff(
 			/* PCI slot number of the controller */
 			.driver_data = (void *)0x1FUL,
 		},
+		{
+			.ident = "HP Compaq 6720s",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq 6720s"),
+			},
+			/* PCI slot number of the controller */
+			.driver_data = (void *)0x1FUL,
+		},
 
 		{ }	/* terminate list */
 	};

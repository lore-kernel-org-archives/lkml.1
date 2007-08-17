Return-Path: <linux-kernel-owner+w=401wt.eu-S1759429AbXHQFFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429AbXHQFFU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 01:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754449AbXHQFFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 01:05:08 -0400
Received: from lixom.net ([66.141.50.11]:37590 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325AbXHQFFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 01:05:06 -0400
Date: Thu, 16 Aug 2007 23:09:02 -0500
From: Olof Johansson <olof@lixom.net>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] serial: Add pci ids for PA Semi PWRficient onchip uarts
Message-ID: <20070817040902.GB8294@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add PCI IDs for the onchip UARTs on PA Semi PWRficient.

Signed-off-by: Olof Johansson <olof@lixom.net>


Index: linux-2.6/drivers/serial/8250_pci.c
===================================================================
--- linux-2.6.orig/drivers/serial/8250_pci.c
+++ linux-2.6/drivers/serial/8250_pci.c
@@ -984,6 +984,7 @@ enum pci_board_num_t {
 	pbn_exar_XR17C152,
 	pbn_exar_XR17C154,
 	pbn_exar_XR17C158,
+	pbn_pasemi_1682M,
 };
 
 /*
@@ -1511,6 +1512,14 @@ static struct pciserial_board pci_boards
 		.base_baud	= 921600,
 		.uart_offset	= 0x200,
 	},
+	/*
+	 * PA Semi PWRficient PA6T-1682M on-chip UART
+	 */
+	[pbn_pasemi_1682M] = {
+		.flags		= FL_BASE0,
+		.num_ports	= 1,
+		.base_baud	= 8333333,
+	},
 };
 
 /*
@@ -2402,6 +2411,13 @@ static struct pci_device_id serial_pci_t
 		PCI_SUBVENDOR_ID_PERLE, PCI_SUBDEVICE_ID_PCI_RAS8,
 		0, 0, pbn_b2_8_921600 },
 	/*
+	 * PA Semi PA6T-1682M on-chip UART
+	 */
+	{	PCI_VENDOR_ID_PASEMI, 0xa004,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_pasemi_1682M },
+
+	/*
 	 * These entries match devices with class COMMUNICATION_SERIAL,
 	 * COMMUNICATION_MODEM or COMMUNICATION_MULTISERIAL
 	 */

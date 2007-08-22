Return-Path: <linux-kernel-owner+w=401wt.eu-S934338AbXHVV5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934338AbXHVV5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 17:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934064AbXHVV5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 17:57:25 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35185 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933880AbXHVV5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 17:57:24 -0400
Date: Wed, 22 Aug 2007 23:05:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] 8250_pci: Autodetect mainpine cards
Message-ID: <20070822230527.649f3714@the-village.bc.nu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for a whole range of boards. Some are partly autodetected but
not fully correctly others (PCI Express notably) not at all. Stick all
the right entries in.

Thanks to Mainpine for information and testing.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.23rc3-mm1/drivers/serial/8250_pci.c linux-2.6.23rc3-mm1/drivers/serial/8250_pci.c
--- linux.vanilla-2.6.23rc3-mm1/drivers/serial/8250_pci.c	2007-08-22 17:23:07.000000000 +0100
+++ linux-2.6.23rc3-mm1/drivers/serial/8250_pci.c	2007-08-22 17:48:05.000000000 +0100
@@ -1036,6 +1036,7 @@
 	pbn_b0_2_115200,
 	pbn_b0_4_115200,
 	pbn_b0_5_115200,
+	pbn_b0_8_115200,
 
 	pbn_b0_1_921600,
 	pbn_b0_2_921600,
@@ -1172,6 +1173,12 @@
 		.base_baud	= 115200,
 		.uart_offset	= 8,
 	},
+	[pbn_b0_8_115200] = {
+		.flags		= FL_BASE0,
+		.num_ports	= 8,
+		.base_baud	= 115200,
+		.uart_offset	= 8,
+	},
 
 	[pbn_b0_1_921600] = {
 		.flags		= FL_BASE0,
@@ -2566,6 +2573,119 @@
 	{       PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9030,
 		PCI_SUBVENDOR_ID_PERLE, PCI_SUBDEVICE_ID_PCI_RAS8,
 		0, 0, pbn_b2_8_921600 },
+		
+	/*
+	 * Mainpine series cards: Fairly standard layout but fools
+	 * parts of the autodetect in some cases and uses otherwise
+	 * unmatched communications subclasses in the PCI Express case
+	 */
+	 
+	{	/* RockForceDUO */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x0200,
+		0, 0, pbn_b0_2_115200 },
+	{	/* RockForceQUATRO */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x0300,
+		0, 0, pbn_b0_4_115200 },
+	{	/* RockForceDUO+ */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x0400,
+		0, 0, pbn_b0_2_115200 },
+	{	/* RockForceQUATRO+ */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x0500,
+		0, 0, pbn_b0_4_115200 },
+	{	/* RockForce+ */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x0600,
+		0, 0, pbn_b0_2_115200 },
+	{	/* RockForce+ */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x0700,
+		0, 0, pbn_b0_4_115200 },
+	{	/* RockForceOCTO+ */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x0800,
+		0, 0, pbn_b0_8_115200 },
+	{	/* RockForceDUO+ */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x0C00,
+		0, 0, pbn_b0_2_115200 },
+	{	/* RockForceQUARTRO+ */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x0D00,
+		0, 0, pbn_b0_4_115200 },
+	{	/* RockForceOCTO+ */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x1D00,
+		0, 0, pbn_b0_8_115200 },
+	{	/* RockForceD1 */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x2000,
+		0, 0, pbn_b0_1_115200 },
+	{	/* RockForceF1 */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x2100,
+		0, 0, pbn_b0_1_115200 },
+	{	/* RockForceD2 */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x2200,
+		0, 0, pbn_b0_2_115200 },
+	{	/* RockForceF2 */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x2300,
+		0, 0, pbn_b0_2_115200 },
+	{	/* RockForceD4 */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x2400,
+		0, 0, pbn_b0_4_115200 },
+	{	/* RockForceF4 */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x2500,
+		0, 0, pbn_b0_4_115200 },
+	{	/* RockForceD8 */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x2600,
+		0, 0, pbn_b0_8_115200 },
+	{	/* RockForceF8 */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x2700,
+		0, 0, pbn_b0_8_115200 },
+	{	/* IQ Express D1 */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x3000, 
+		0, 0, pbn_b0_1_115200 },
+	{	/* IQ Express F1 */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x3100, 
+		0, 0, pbn_b0_1_115200 },
+	{	/* IQ Express D2 */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x3200, 
+		0, 0, pbn_b0_2_115200 },
+	{	/* IQ Express F2 */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x3300, 
+		0, 0, pbn_b0_2_115200 },
+	{	/* IQ Express D4 */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x3400, 
+		0, 0, pbn_b0_4_115200 },
+	{	/* IQ Express F4 */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x3500, 
+		0, 0, pbn_b0_4_115200 },
+	{	/* IQ Express D8 */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x3C00, 
+		0, 0, pbn_b0_8_115200 },
+	{	/* IQ Express F8 */
+		PCI_VENDOR_ID_MAINPINE, PCI_DEVICE_ID_MAINPINE_PBRIDGE,
+		PCI_VENDOR_ID_MAINPINE, 0x3D00, 
+		0, 0, pbn_b0_8_115200 },
+	
+
 	/*
 	 * PA Semi PA6T-1682M on-chip UART
 	 */

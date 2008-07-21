Return-Path: <linux-kernel-owner+w=401wt.eu-S1753028AbYGUQAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbYGUQAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 12:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750877AbYGUQA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 12:00:26 -0400
Received: from adelie.canonical.com ([91.189.90.139]:53343 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbYGUQAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 12:00:25 -0400
Subject: Re: [PATCH 3/7] bluetooth: Add quirks for a few hci_usb devices
From: Ben Collins <ben.collins@canonical.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
In-Reply-To: <1216616891.8411.114.camel@violet.holtmann.net>
References: <E1KKl4I-00068H-S6@swissweb.swissdisk.com>
	 <1216616891.8411.114.camel@violet.holtmann.net>
Content-Type: text/plain
Organization: Canonical
Date: Mon, 21 Jul 2008 12:00:14 -0400
Message-Id: <1216656014.7585.146.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preface: The "Broadcom" device is on unreleased hardware, so I can't
disclose the actual model.

When the Dell 370 and 410 BT adapters are put into BT radio mode, they
need to be prepared like many other Broadcom adapters.
    
Also, add quirk Broadcom 2046 devices with HCI_RESET. Reference for this
bug: https://launchpad.net/bugs/249448
    
CC: linux-bluetooth@vger.kernel.org
Signed-off-by: Michael Frey <michael.frey@canonical.com>
Signed-off-by: Mario Limonciello <Mario_Limonciello@Dell.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Ben Collins <ben.collins@canonical.com>

diff --git a/drivers/bluetooth/hci_usb.c b/drivers/bluetooth/hci_usb.c
index 192522e..c33bb59 100644
--- a/drivers/bluetooth/hci_usb.c
+++ b/drivers/bluetooth/hci_usb.c
@@ -134,6 +134,13 @@ static struct usb_device_id blacklist_ids[] = {
 
 	/* Dell laptop with Broadcom chip */
 	{ USB_DEVICE(0x413c, 0x8126), .driver_info = HCI_RESET | HCI_WRONG_SCO_MTU },
+	/* Dell Wireless 370 */
+	{ USB_DEVICE(0x413c, 0x8156), .driver_info = HCI_RESET | HCI_WRONG_SCO_MTU },
+	/* Dell Wireless 410 */
+	{ USB_DEVICE(0x413c, 0x8152), .driver_info = HCI_RESET | HCI_WRONG_SCO_MTU },
+
+	/* Broadcom 2046 */
+	{ USB_DEVICE(0x0a5c, 0x2151), .driver_info = HCI_RESET },
 
 	/* Microsoft Wireless Transceiver for Bluetooth 2.0 */
 	{ USB_DEVICE(0x045e, 0x009c), .driver_info = HCI_RESET },



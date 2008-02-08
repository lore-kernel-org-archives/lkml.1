Return-Path: <linux-kernel-owner+w=401wt.eu-S1759548AbYBHMtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548AbYBHMtq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 07:49:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbYBHMti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 07:49:38 -0500
Received: from queueout04-winn.ispmail.ntl.com ([81.103.221.58]:29476 "EHLO
	queueout04-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752375AbYBHMth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 07:49:37 -0500
From: Daniel Drake <dsd@gentoo.org>
To: marcel@holtmann.org
Cc: bluez-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] hci_usb: another device with buggy SCO support
Message-Id: <20080208124505.434C69D412D@zog.reactivated.net>
Date: Fri,  8 Feb 2008 12:45:05 +0000 (GMT)
X-Cloudmark-Analysis: v=1.0 c=1 a=RuX7Chmrt_0A:10 a=6NZ8fVIUmUSsLoVjiD5+pA==:17 a=7mOBRU54AAAA:8 a=danhDmx_AAAA:8 a=8FeB8E8mQ5FogfOGJFoA:9 a=tFxMLJ3S0wvg-3dZ9nkA:7 a=ujtVTHZIOl4tdSdBoWNnMfLfAuoA:4 a=WeOa-AV5lc8A:10 a=9XSpoOj3B7kA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As reported at:
https://bugs.gentoo.org/show_bug.cgi?id=203196
https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.22/+bug/152689

This unbranded bluetooth USB dongle causes the following message to
repeatedly appear in the kernel logs:
    hci_scodata_packet: hci0 SCO packet for unknown connection handle 92

This patch solves the issue. I'm not sure of its correctness, it is based
on work by Ossi Berg and Tim Gardner on the Ubuntu bug tracker.

Signed-off-by: Daniel Drake <dsd@gentoo.org>

---

resending due to no response after 2 weeks

diff --git a/drivers/bluetooth/hci_usb.c b/drivers/bluetooth/hci_usb.c
index 98a9cde..fa3f0de 100644
--- a/drivers/bluetooth/hci_usb.c
+++ b/drivers/bluetooth/hci_usb.c
@@ -161,6 +161,9 @@ static struct usb_device_id blacklist_ids[] = {
 	/* Frontline ComProbe Bluetooth Sniffer */
 	{ USB_DEVICE(0x16d3, 0x0002), .driver_info = HCI_SNIFFER },
 
+	/* Generic/no-name device with buggy SCO support */
+	{ USB_DEVICE(0x0e5e, 0x6622), .driver_info = HCI_BROKEN_ISOC },
+
 	{ }	/* Terminating entry */
 };
 
